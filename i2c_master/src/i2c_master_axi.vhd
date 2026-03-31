--! Maps i2c master registers into axi-lite
--!
--! **Register table**
--!
--!  | OFFSET | LABEL               |  R/W  | SC  | DESCRIPTION                                                                                                   | RESET VALUE |
--!  | :----: | ------------------- | :---: | --- | ------------------------------------------------------------------------------------------------------------- | ----------- |
--!  |  0x0   | **Version** |       |     |                                                                                                             |             |
--!  |        | _[31:0] Version_    |   R   | NO  | Version info                                                                                                  | 0x1         |
--!  |  0x4   | **Control** |       |     |                                                                                                               |             |
--!  |        | _[0] start_        |   W  | YES  | start signal when '1'                                                                            | 0x0         |
--!  |        | _[1] rw_        |  R/W  | NO  | Read -> '1';  write -> '0' | 0x0         |
--!  |        | _[5:2] byte count_        |  R/W  | NO  | Bytes to read or write | 0x0         |
--!  |        | _[31:6] Reserved_   |       |     | Reserved                                                                                                      |             |
--!  |  0x8   | **Status**    |       |     |                                                                                                         |             |
--!  |        | _[0] ready_        |   R  | NO  | Ready when '1'                                                                            | 0x0         |
--!  |        | _[1] ack_error_        |  R  | NO  | acknowledge error from slave when '1' | 0x0         |
--!  |        | _[2] busy_        |  R  | NO  | transaction in progress when '1' | 0x0         |
--!  |        | _[31:3] Reserved_   |       |     | Reserved                                                                                                      |             |
--!  |  0xC   | **addr**    |       |     |                                                                                                         |             |
--!  |        | _[6:0] addr_        |   W/R  | NO  | address of target slave                                                                            | 0x0         |
--!  |        | _[31:7] Reserved_   |       |     | Reserved                                                                                                      |             |
--!  |  0x10  | **data_wr_low**    |       |     |                                                                                                         |             |
--!  |        | _[7:0] data_wr_0_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
--!  |        | _[15:8] data_wr_1_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
--!  |        | _[23:16] data_wr_2_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
--!  |        | _[31:24] data_wr_3_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
--!  |  0x14  | **data_wr_high**    |       |     |                                                                                                         |             |
--!  |        | _[7:0] data_wr_4_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
--!  |        | _[15:8] data_wr_5_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
--!  |        | _[23:16] data_wr_6_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
--!  |        | _[31:24] data_wr_7_        |   W/R  | NO  | byte to write to slave                                                                            | 0x0         |
--!  |  0x18  | **data_rd_low**    |       |     |                                                                                                         |             |
--!  |        | _[7:0] data_rd_0_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
--!  |        | _[15:8] data_rd_1_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
--!  |        | _[23:16] data_rd_2_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
--!  |        | _[31:24] data_rd_3_        |   R  | NO  | byte read to slave                                                                            | 0x0         |
--!  |  0x1C  | **data_rd_high**    |       |     |                                                                                                         |             |
--!  |        | _[7:0] data_rd_4_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
--!  |        | _[15:8] data_rd_5_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
--!  |        | _[23:16] data_rd_6_        |   R  | NO  | byte read from slave                                                                            | 0x0         |
--!  |        | _[31:24] data_rd_7_        |   R  | NO  | byte read from slave                                                                            | 0x0         |

--! 
--! [Register documentation](../doc/i2c_interface_regs.html)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.i2c_master_utils_pkg.all;
use work.i2c_interface_regs_pkg.all;

entity i2c_master_axi is
   generic (
      g_axi_addr_width : integer := 32;
      g_input_clk      : integer := 100_000_000; --! input clock speed from user logic in Hz
      g_bus_clk        : integer := 100_000      --! speed the i2c bus (scl) will run at in Hz
   );
   port (
      -- Clock and Reset
      axi_aclk    : in std_logic;
      axi_aresetn : in std_logic;
      --! @virtualbus axi_lite_config an AXI4-Lite interface to write core registers
      s_axi_awaddr  : in std_logic_vector(g_axi_addr_width - 1 downto 0);
      s_axi_awprot  : in std_logic_vector(2 downto 0);
      s_axi_awvalid : in std_logic;
      s_axi_awready : out std_logic;
      s_axi_wdata  : in std_logic_vector(31 downto 0);
      s_axi_wstrb  : in std_logic_vector(3 downto 0);
      s_axi_wvalid : in std_logic;
      s_axi_wready : out std_logic;
      s_axi_araddr  : in std_logic_vector(g_axi_addr_width - 1 downto 0);
      s_axi_arprot  : in std_logic_vector(2 downto 0); 
      s_axi_arvalid : in std_logic;
      s_axi_arready : out std_logic;
      s_axi_rdata  : out std_logic_vector(31 downto 0);
      s_axi_rresp  : out std_logic_vector(1 downto 0);
      s_axi_rvalid : out std_logic;
      s_axi_rready : in std_logic;
      s_axi_bresp  : out std_logic_vector(1 downto 0);
      s_axi_bvalid : out std_logic;
      s_axi_bready : in std_logic; --! @end
      sda_o         : in std_logic;                    
      sda_i         : out std_logic;
      sda_t         : out std_logic;
      scl_o         : in std_logic; 
      scl_i         : out std_logic;
      scl_t         : out std_logic
   );
end entity;

architecture rtl of i2c_master_axi is

   signal s_i2c_in  : i2c_rec_in;
   signal s_i2c_out : i2c_rec_out;
   signal user2regs : user2regs_t;
   signal regs2user : regs2user_t;

   signal s_ready_out : std_logic := '0';
   signal s_start_in  : std_logic := '0';

begin

   user2regs.version_value                <= x"00000001";
   user2regs.status_ready(0)           <= s_ready_out;
   user2regs.status_ack_error(0)       <= s_i2c_out.ack_error_out;
   user2regs.status_busy(0)            <= s_i2c_out.busy_out;
   user2regs.data_rd_low_data_rd_0  <= s_i2c_out.data_rd_0_out;
   user2regs.data_rd_low_data_rd_1  <= s_i2c_out.data_rd_1_out;
   user2regs.data_rd_low_data_rd_2  <= s_i2c_out.data_rd_2_out;
   user2regs.data_rd_low_data_rd_3  <= s_i2c_out.data_rd_3_out;
   user2regs.data_rd_high_data_rd_4 <= s_i2c_out.data_rd_4_out;
   user2regs.data_rd_high_data_rd_5 <= s_i2c_out.data_rd_5_out;
   user2regs.data_rd_high_data_rd_6 <= s_i2c_out.data_rd_6_out;
   user2regs.data_rd_high_data_rd_7 <= s_i2c_out.data_rd_7_out;

   s_start_in <= regs2user.control_start(0);

   s_i2c_in.byte_cnt_in  <= regs2user.control_byte_count;
   s_i2c_in.addr_in      <= regs2user.addr_addr;
   s_i2c_in.rw_in        <= regs2user.control_rw(0);
   s_i2c_in.data_wr_0_in <= regs2user.data_wr_low_data_wr_0;
   s_i2c_in.data_wr_1_in <= regs2user.data_wr_low_data_wr_1;
   s_i2c_in.data_wr_2_in <= regs2user.data_wr_low_data_wr_2;
   s_i2c_in.data_wr_3_in <= regs2user.data_wr_low_data_wr_3;
   s_i2c_in.data_wr_4_in <= regs2user.data_wr_high_data_wr_4;
   s_i2c_in.data_wr_5_in <= regs2user.data_wr_high_data_wr_5;
   s_i2c_in.data_wr_6_in <= regs2user.data_wr_high_data_wr_6;
   s_i2c_in.data_wr_7_in <= regs2user.data_wr_high_data_wr_7;

   i2c_master_wrapper_rec_inst : entity work.i2c_master_wrapper_rec
      generic map(
         g_input_clk => g_input_clk,
         g_bus_clk   => g_bus_clk
      )
      port map(
         clk_in    => axi_aclk,
         reset_n   => axi_aresetn,
         start_in  => s_start_in,
         ready_out => s_ready_out,
         i2c_in    => s_i2c_in,
         i2c_out   => s_i2c_out,
         sda_o     => sda_o,
         sda_i     => sda_i,
         sda_t     => sda_t,
         scl_o     => scl_o,
         scl_i     => scl_i,
         scl_t     => scl_t
      );

   i2c_interface_regs_inst : entity work.i2c_interface_regs
      generic map(
         AXI_ADDR_WIDTH => g_axi_addr_width
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

end architecture;