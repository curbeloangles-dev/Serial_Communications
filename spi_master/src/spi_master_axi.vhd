
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spi_interface_regs_pkg.all;

entity spi_master_axi is
   generic (
      AXI_ADDR_WIDTH : integer := 32; --! width of the AXI address bus
      g_slaves       : integer := 4;  --! number of spi slaves
      g_d_width      : integer := 16; --! data bus width
      g_clk_div      : integer := 10
   );
   port (
      clock   : in std_logic;
      reset_n : in std_logic;
      miso    : in std_logic;
      mosi    : out std_logic;
      sclk    : out std_logic;
      ss_n    : out std_logic_vector(g_slaves-1 downto 0);

      -- Clock and Reset
      axi_aclk    : in std_logic;
      axi_aresetn : in std_logic;
      -- AXI Write Address Channel
      s_axi_awaddr  : in std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
      s_axi_awprot  : in std_logic_vector(2 downto 0); -- sigasi @suppress "Unused port"
      s_axi_awvalid : in std_logic;
      s_axi_awready : out std_logic;
      -- AXI Write Data Channel
      s_axi_wdata  : in std_logic_vector(31 downto 0);
      s_axi_wstrb  : in std_logic_vector(3 downto 0);
      s_axi_wvalid : in std_logic;
      s_axi_wready : out std_logic;
      -- AXI Read Address Channel
      s_axi_araddr  : in std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
      s_axi_arprot  : in std_logic_vector(2 downto 0); -- sigasi @suppress "Unused port"
      s_axi_arvalid : in std_logic;
      s_axi_arready : out std_logic;
      -- AXI Read Data Channel
      s_axi_rdata  : out std_logic_vector(31 downto 0);
      s_axi_rresp  : out std_logic_vector(1 downto 0);
      s_axi_rvalid : out std_logic;
      s_axi_rready : in std_logic;
      -- AXI Write Response Channel
      s_axi_bresp  : out std_logic_vector(1 downto 0);
      s_axi_bvalid : out std_logic;
      s_axi_bready : in std_logic
   );
end entity spi_master_axi;

architecture rtl of spi_master_axi is

   signal user2regs : user2regs_t;
   signal regs2user : regs2user_t;

begin

    user2regs.version_value <= x"00000001";
   
   spi_interface_regs_inst : entity work.spi_interface_regs
      generic map(
         AXI_ADDR_WIDTH => AXI_ADDR_WIDTH
      )
      port map(
         axi_aclk      => axi_aclk,
         axi_aresetn   => axi_aresetn,
         s_axi_awaddr  => s_axi_awaddr,
         s_axi_awprot  => s_axi_awprot,
         s_axi_awvalid => s_axi_awvalid,
         s_axi_awready => s_axi_awready,
         s_axi_wdata   => s_axi_wdata,
         s_axi_wstrb   => s_axi_wstrb,
         s_axi_wvalid  => s_axi_wvalid,
         s_axi_wready  => s_axi_wready,
         s_axi_araddr  => s_axi_araddr,
         s_axi_arprot  => s_axi_arprot,
         s_axi_arvalid => s_axi_arvalid,
         s_axi_arready => s_axi_arready,
         s_axi_rdata   => s_axi_rdata,
         s_axi_rresp   => s_axi_rresp,
         s_axi_rvalid  => s_axi_rvalid,
         s_axi_rready  => s_axi_rready,
         s_axi_bresp   => s_axi_bresp,
         s_axi_bvalid  => s_axi_bvalid,
         s_axi_bready  => s_axi_bready,
         user2regs     => user2regs,
         regs2user     => regs2user
      );

   spi_master_inst : entity work.spi_master
      generic map(
         slaves  => g_slaves,
         d_width => g_d_width,
         clk_div => g_clk_div
      )
      port map(
         clock   => clock,
         reset_n => reset_n,
         enable  => regs2user.control_start(0),
         cpol    => regs2user.control_cpol(0),
         cpha    => regs2user.control_cpha(0),
         cont    => regs2user.control_cont(0),
         addr    => regs2user.addr_addr(g_slaves - 1 downto 0),
         tx_data => regs2user.data_wr_data_wr(g_d_width - 1 downto 0),
         miso    => miso,
         sclk    => sclk,
         ss_n    => ss_n,
         mosi    => mosi,
         busy    => user2regs.status_busy(0),
         rx_data => user2regs.data_rd_data_rd(g_d_width - 1 downto 0)
      );

end architecture;