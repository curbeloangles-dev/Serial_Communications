-- -----------------------------------------------------------------------------
-- 'spi_interface' Register Component
-- Revision: 24
-- -----------------------------------------------------------------------------
-- Generated on 2021-06-21 at 05:56 (UTC) by airhdl version 2021.06.1
-- -----------------------------------------------------------------------------
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spi_interface_regs_pkg.all;

entity spi_interface_regs is
    generic(
        AXI_ADDR_WIDTH : integer := 32  -- width of the AXI address bus
    );
    port(
        -- Clock and Reset
        axi_aclk    : in  std_logic;
        axi_aresetn : in  std_logic;
        -- AXI Write Address Channel
        s_axi_awaddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_awprot  : in  std_logic_vector(2 downto 0); -- sigasi @suppress "Unused port"
        s_axi_awvalid : in  std_logic;
        s_axi_awready : out std_logic;
        -- AXI Write Data Channel
        s_axi_wdata   : in  std_logic_vector(31 downto 0);
        s_axi_wstrb   : in  std_logic_vector(3 downto 0);
        s_axi_wvalid  : in  std_logic;
        s_axi_wready  : out std_logic;
        -- AXI Read Address Channel
        s_axi_araddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_arprot  : in  std_logic_vector(2 downto 0); -- sigasi @suppress "Unused port"
        s_axi_arvalid : in  std_logic;
        s_axi_arready : out std_logic;
        -- AXI Read Data Channel
        s_axi_rdata   : out std_logic_vector(31 downto 0);
        s_axi_rresp   : out std_logic_vector(1 downto 0);
        s_axi_rvalid  : out std_logic;
        s_axi_rready  : in  std_logic;
        -- AXI Write Response Channel
        s_axi_bresp   : out std_logic_vector(1 downto 0);
        s_axi_bvalid  : out std_logic;
        s_axi_bready  : in  std_logic;
        -- User Ports
        user2regs     : in user2regs_t;
        regs2user     : out regs2user_t
    );
end entity spi_interface_regs;

architecture RTL of spi_interface_regs is

    -- Constants
    constant AXI_OKAY           : std_logic_vector(1 downto 0) := "00";
    constant AXI_DECERR         : std_logic_vector(1 downto 0) := "11";

    -- Registered signals
    signal s_axi_awready_r    : std_logic;
    signal s_axi_wready_r     : std_logic;
    signal s_axi_awaddr_reg_r : unsigned(s_axi_awaddr'range);
    signal s_axi_bvalid_r     : std_logic;
    signal s_axi_bresp_r      : std_logic_vector(s_axi_bresp'range);
    signal s_axi_arready_r    : std_logic;
    signal s_axi_araddr_reg_r : unsigned(AXI_ADDR_WIDTH - 1 downto 0);
    signal s_axi_rvalid_r     : std_logic;
    signal s_axi_rresp_r      : std_logic_vector(s_axi_rresp'range);
    signal s_axi_wdata_reg_r  : std_logic_vector(s_axi_wdata'range);
    signal s_axi_wstrb_reg_r  : std_logic_vector(s_axi_wstrb'range);
    signal s_axi_rdata_r      : std_logic_vector(s_axi_rdata'range);

    -- User-defined registers
    signal s_version_strobe_r : std_logic;
    signal s_reg_version_value : std_logic_vector(31 downto 0);
    signal s_control_strobe_r : std_logic;
    signal s_reg_control_start_r : std_logic_vector(0 downto 0);
    signal s_reg_control_cpol_r : std_logic_vector(0 downto 0);
    signal s_reg_control_cpha_r : std_logic_vector(0 downto 0);
    signal s_reg_control_cont_r : std_logic_vector(0 downto 0);
    signal s_status_strobe_r : std_logic;
    signal s_reg_status_busy : std_logic_vector(0 downto 0);
    signal s_addr_strobe_r : std_logic;
    signal s_reg_addr_addr_r : std_logic_vector(6 downto 0);
    signal s_data_wr_strobe_r : std_logic;
    signal s_reg_data_wr_data_wr_r : std_logic_vector(31 downto 0);
    signal s_data_rd_strobe_r : std_logic;
    signal s_reg_data_rd_data_rd : std_logic_vector(31 downto 0);

    constant C_AXI_DIR_BITS : integer := 16;

begin

    ----------------------------------------------------------------------------
    -- Inputs
    --
    s_reg_version_value <= user2regs.version_value;
    s_reg_status_busy <= user2regs.status_busy;
    s_reg_data_rd_data_rd <= user2regs.data_rd_data_rd;

    ----------------------------------------------------------------------------
    -- Read-transaction FSM
    --
    read_fsm : process(axi_aclk, axi_aresetn) is
        constant MAX_MEMORY_LATENCY : natural := 5;
        type t_state is (IDLE, READ_REGISTER, WAIT_MEMORY_RDATA, READ_RESPONSE, DONE);
        -- registered state variables
        variable v_state_r          : t_state;
        variable v_rdata_r          : std_logic_vector(31 downto 0);
        variable v_rresp_r          : std_logic_vector(s_axi_rresp'range);
        variable v_mem_wait_count_r : natural range 0 to MAX_MEMORY_LATENCY;
        -- combinatorial helper variables
        variable v_addr_hit : boolean;
        variable v_mem_addr : unsigned(AXI_ADDR_WIDTH-1 downto 0);
    begin
        if axi_aresetn = '0' then
            v_state_r          := IDLE;
            v_rdata_r          := (others => '0');
            v_rresp_r          := (others => '0');
            v_mem_wait_count_r := 0;
            s_axi_arready_r    <= '0';
            s_axi_rvalid_r     <= '0';
            s_axi_rresp_r      <= (others => '0');
            s_axi_araddr_reg_r <= (others => '0');
            s_axi_rdata_r      <= (others => '0');
            s_version_strobe_r <= '0';
            s_status_strobe_r <= '0';
            s_data_rd_strobe_r <= '0';

        elsif rising_edge(axi_aclk) then
            -- Default values:
            s_axi_arready_r <= '0';
            s_version_strobe_r <= '0';
            s_status_strobe_r <= '0';
            s_data_rd_strobe_r <= '0';

            case v_state_r is

                -- Wait for the start of a read transaction, which is
                -- initiated by the assertion of ARVALID
                when IDLE =>
                    if s_axi_arvalid = '1' then
                        s_axi_araddr_reg_r <= unsigned(s_axi_araddr); -- save the read address
                        s_axi_arready_r    <= '1'; -- acknowledge the read-address
                        v_state_r          := READ_REGISTER;
                    end if;

                -- Read from the actual storage element
                when READ_REGISTER =>
                    -- defaults:
                    v_addr_hit := false;
                    v_rdata_r  := (others => '0');

                    -- register 'version' at address offset 0x0
                    if s_axi_araddr_reg_r(C_AXI_DIR_BITS - 1 downto 0) = VERSION_OFFSET(C_AXI_DIR_BITS - 1 downto 0) then
                        v_addr_hit := true;
                        v_rdata_r(31 downto 0) := s_reg_version_value;
                        s_version_strobe_r <= '1';
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'control' at address offset 0x4
                    if s_axi_araddr_reg_r(C_AXI_DIR_BITS - 1 downto 0) = CONTROL_OFFSET(C_AXI_DIR_BITS - 1 downto 0) then
                        v_addr_hit := true;
                        v_rdata_r(0 downto 0) := s_reg_control_start_r;
                        v_rdata_r(1 downto 1) := s_reg_control_cpol_r;
                        v_rdata_r(2 downto 2) := s_reg_control_cpha_r;
                        v_rdata_r(3 downto 3) := s_reg_control_cont_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'status' at address offset 0x8
                    if s_axi_araddr_reg_r(C_AXI_DIR_BITS - 1 downto 0) = STATUS_OFFSET(C_AXI_DIR_BITS - 1 downto 0) then
                        v_addr_hit := true;
                        v_rdata_r(0 downto 0) := s_reg_status_busy;
                        s_status_strobe_r <= '1';
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'addr' at address offset 0xC
                    if s_axi_araddr_reg_r(C_AXI_DIR_BITS - 1 downto 0) = ADDR_OFFSET(C_AXI_DIR_BITS - 1 downto 0) then
                        v_addr_hit := true;
                        v_rdata_r(6 downto 0) := s_reg_addr_addr_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'data_wr' at address offset 0x10
                    if s_axi_araddr_reg_r(C_AXI_DIR_BITS - 1 downto 0) = DATA_WR_OFFSET(C_AXI_DIR_BITS - 1 downto 0) then
                        v_addr_hit := true;
                        v_rdata_r(31 downto 0) := s_reg_data_wr_data_wr_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'data_rd' at address offset 0x14
                    if s_axi_araddr_reg_r(C_AXI_DIR_BITS - 1 downto 0) = DATA_RD_OFFSET(C_AXI_DIR_BITS - 1 downto 0) then
                        v_addr_hit := true;
                        v_rdata_r(31 downto 0) := s_reg_data_rd_data_rd;
                        s_data_rd_strobe_r <= '1';
                        v_state_r := READ_RESPONSE;
                    end if;
                    --
                    if v_addr_hit then
                        v_rresp_r := AXI_OKAY;
                    else
                        v_rresp_r := AXI_DECERR;
                        -- pragma translate_off
                        report "ARADDR decode error" severity warning;
                        -- pragma translate_on
                        v_state_r := READ_RESPONSE;
                    end if;

                -- Wait for memory read data
                when WAIT_MEMORY_RDATA =>
                    if v_mem_wait_count_r = 0 then
                        v_state_r      := READ_RESPONSE;
                    else
                        v_mem_wait_count_r := v_mem_wait_count_r - 1;
                    end if;

                -- Generate read response
                when READ_RESPONSE =>
                    s_axi_rvalid_r <= '1';
                    s_axi_rresp_r  <= v_rresp_r;
                    s_axi_rdata_r  <= v_rdata_r;
                    --
                    v_state_r      := DONE;

                -- Write transaction completed, wait for master RREADY to proceed
                when DONE =>
                    if s_axi_rready = '1' then
                        s_axi_rvalid_r <= '0';
                        s_axi_rdata_r   <= (others => '0');
                        v_state_r      := IDLE;
                    end if;
            end case;
        end if;
    end process read_fsm;

    ----------------------------------------------------------------------------
    -- Write-transaction FSM
    --
    write_fsm : process(axi_aclk, axi_aresetn) is
        type t_state is (IDLE, ADDR_FIRST, DATA_FIRST, UPDATE_REGISTER, DONE);
        variable v_state_r  : t_state;
        variable v_addr_hit : boolean;
        variable v_mem_addr : unsigned(AXI_ADDR_WIDTH-1 downto 0);
    begin
        if axi_aresetn = '0' then
            v_state_r          := IDLE;
            s_axi_awready_r    <= '0';
            s_axi_wready_r     <= '0';
            s_axi_awaddr_reg_r <= (others => '0');
            s_axi_wdata_reg_r  <= (others => '0');
            s_axi_wstrb_reg_r  <= (others => '0');
            s_axi_bvalid_r     <= '0';
            s_axi_bresp_r      <= (others => '0');
            --
            s_control_strobe_r <= '0';
            s_reg_control_start_r <= CONTROL_START_RESET;
            s_reg_control_cpol_r <= CONTROL_CPOL_RESET;
            s_reg_control_cpha_r <= CONTROL_CPHA_RESET;
            s_reg_control_cont_r <= CONTROL_CONT_RESET;
            s_addr_strobe_r <= '0';
            s_reg_addr_addr_r <= ADDR_ADDR_RESET;
            s_data_wr_strobe_r <= '0';
            s_reg_data_wr_data_wr_r <= DATA_WR_DATA_WR_RESET;

        elsif rising_edge(axi_aclk) then
            -- Default values:
            s_axi_awready_r <= '0';
            s_axi_wready_r  <= '0';
            s_control_strobe_r <= '0';
            s_addr_strobe_r <= '0';
            s_data_wr_strobe_r <= '0';

            -- Self-clearing fields:
            s_reg_control_start_r <= (others => '0');

            case v_state_r is

                -- Wait for the start of a write transaction, which may be
                -- initiated by either of the following conditions:
                --   * assertion of both AWVALID and WVALID
                --   * assertion of AWVALID
                --   * assertion of WVALID
                when IDLE =>
                    if s_axi_awvalid = '1' and s_axi_wvalid = '1' then
                        s_axi_awaddr_reg_r <= unsigned(s_axi_awaddr); -- save the write-address
                        s_axi_awready_r    <= '1'; -- acknowledge the write-address
                        s_axi_wdata_reg_r  <= s_axi_wdata; -- save the write-data
                        s_axi_wstrb_reg_r  <= s_axi_wstrb; -- save the write-strobe
                        s_axi_wready_r     <= '1'; -- acknowledge the write-data
                        v_state_r          := UPDATE_REGISTER;
                    elsif s_axi_awvalid = '1' then
                        s_axi_awaddr_reg_r <= unsigned(s_axi_awaddr); -- save the write-address
                        s_axi_awready_r    <= '1'; -- acknowledge the write-address
                        v_state_r          := ADDR_FIRST;
                    elsif s_axi_wvalid = '1' then
                        s_axi_wdata_reg_r <= s_axi_wdata; -- save the write-data
                        s_axi_wstrb_reg_r <= s_axi_wstrb; -- save the write-strobe
                        s_axi_wready_r    <= '1'; -- acknowledge the write-data
                        v_state_r         := DATA_FIRST;
                    end if;

                -- Address-first write transaction: wait for the write-data
                when ADDR_FIRST =>
                    if s_axi_wvalid = '1' then
                        s_axi_wdata_reg_r <= s_axi_wdata; -- save the write-data
                        s_axi_wstrb_reg_r <= s_axi_wstrb; -- save the write-strobe
                        s_axi_wready_r    <= '1'; -- acknowledge the write-data
                        v_state_r         := UPDATE_REGISTER;
                    end if;

                -- Data-first write transaction: wait for the write-address
                when DATA_FIRST =>
                    if s_axi_awvalid = '1' then
                        s_axi_awaddr_reg_r <= unsigned(s_axi_awaddr); -- save the write-address
                        s_axi_awready_r    <= '1'; -- acknowledge the write-address
                        v_state_r          := UPDATE_REGISTER;
                    end if;

                -- Update the actual storage element
                when UPDATE_REGISTER =>
                    s_axi_bresp_r               <= AXI_OKAY; -- default value, may be overriden in case of decode error
                    s_axi_bvalid_r              <= '1';
                    --
                    v_addr_hit := false;
                    -- register 'control' at address offset 0x4
                    if s_axi_awaddr_reg_r(C_AXI_DIR_BITS - 1 downto 0) = CONTROL_OFFSET(C_AXI_DIR_BITS - 1 downto 0) then
                        v_addr_hit := true;
                        s_control_strobe_r <= '1';
                        -- field 'start':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_control_start_r(0) <= s_axi_wdata_reg_r(0); -- start(0)
                        end if;
                        -- field 'cpol':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_control_cpol_r(0) <= s_axi_wdata_reg_r(1); -- cpol(0)
                        end if;
                        -- field 'cpha':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_control_cpha_r(0) <= s_axi_wdata_reg_r(2); -- cpha(0)
                        end if;
                        -- field 'cont':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_control_cont_r(0) <= s_axi_wdata_reg_r(3); -- cont(0)
                        end if;
                    end if;
                    -- register 'addr' at address offset 0xC
                    if s_axi_awaddr_reg_r(C_AXI_DIR_BITS - 1 downto 0) = ADDR_OFFSET(C_AXI_DIR_BITS - 1 downto 0) then
                        v_addr_hit := true;
                        s_addr_strobe_r <= '1';
                        -- field 'addr':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_addr_addr_r(0) <= s_axi_wdata_reg_r(0); -- addr(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_addr_addr_r(1) <= s_axi_wdata_reg_r(1); -- addr(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_addr_addr_r(2) <= s_axi_wdata_reg_r(2); -- addr(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_addr_addr_r(3) <= s_axi_wdata_reg_r(3); -- addr(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_addr_addr_r(4) <= s_axi_wdata_reg_r(4); -- addr(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_addr_addr_r(5) <= s_axi_wdata_reg_r(5); -- addr(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_addr_addr_r(6) <= s_axi_wdata_reg_r(6); -- addr(6)
                        end if;
                    end if;
                    -- register 'data_wr' at address offset 0x10
                    if s_axi_awaddr_reg_r(C_AXI_DIR_BITS - 1 downto 0) = DATA_WR_OFFSET(C_AXI_DIR_BITS - 1 downto 0) then
                        v_addr_hit := true;
                        s_data_wr_strobe_r <= '1';
                        -- field 'data_wr':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_data_wr_data_wr_r(0) <= s_axi_wdata_reg_r(0); -- data_wr(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_data_wr_data_wr_r(1) <= s_axi_wdata_reg_r(1); -- data_wr(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_data_wr_data_wr_r(2) <= s_axi_wdata_reg_r(2); -- data_wr(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_data_wr_data_wr_r(3) <= s_axi_wdata_reg_r(3); -- data_wr(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_data_wr_data_wr_r(4) <= s_axi_wdata_reg_r(4); -- data_wr(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_data_wr_data_wr_r(5) <= s_axi_wdata_reg_r(5); -- data_wr(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_data_wr_data_wr_r(6) <= s_axi_wdata_reg_r(6); -- data_wr(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_data_wr_data_wr_r(7) <= s_axi_wdata_reg_r(7); -- data_wr(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_data_wr_data_wr_r(8) <= s_axi_wdata_reg_r(8); -- data_wr(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_data_wr_data_wr_r(9) <= s_axi_wdata_reg_r(9); -- data_wr(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_data_wr_data_wr_r(10) <= s_axi_wdata_reg_r(10); -- data_wr(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_data_wr_data_wr_r(11) <= s_axi_wdata_reg_r(11); -- data_wr(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_data_wr_data_wr_r(12) <= s_axi_wdata_reg_r(12); -- data_wr(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_data_wr_data_wr_r(13) <= s_axi_wdata_reg_r(13); -- data_wr(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_data_wr_data_wr_r(14) <= s_axi_wdata_reg_r(14); -- data_wr(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_data_wr_data_wr_r(15) <= s_axi_wdata_reg_r(15); -- data_wr(15)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_data_wr_data_wr_r(16) <= s_axi_wdata_reg_r(16); -- data_wr(16)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_data_wr_data_wr_r(17) <= s_axi_wdata_reg_r(17); -- data_wr(17)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_data_wr_data_wr_r(18) <= s_axi_wdata_reg_r(18); -- data_wr(18)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_data_wr_data_wr_r(19) <= s_axi_wdata_reg_r(19); -- data_wr(19)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_data_wr_data_wr_r(20) <= s_axi_wdata_reg_r(20); -- data_wr(20)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_data_wr_data_wr_r(21) <= s_axi_wdata_reg_r(21); -- data_wr(21)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_data_wr_data_wr_r(22) <= s_axi_wdata_reg_r(22); -- data_wr(22)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_data_wr_data_wr_r(23) <= s_axi_wdata_reg_r(23); -- data_wr(23)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_data_wr_data_wr_r(24) <= s_axi_wdata_reg_r(24); -- data_wr(24)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_data_wr_data_wr_r(25) <= s_axi_wdata_reg_r(25); -- data_wr(25)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_data_wr_data_wr_r(26) <= s_axi_wdata_reg_r(26); -- data_wr(26)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_data_wr_data_wr_r(27) <= s_axi_wdata_reg_r(27); -- data_wr(27)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_data_wr_data_wr_r(28) <= s_axi_wdata_reg_r(28); -- data_wr(28)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_data_wr_data_wr_r(29) <= s_axi_wdata_reg_r(29); -- data_wr(29)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_data_wr_data_wr_r(30) <= s_axi_wdata_reg_r(30); -- data_wr(30)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_data_wr_data_wr_r(31) <= s_axi_wdata_reg_r(31); -- data_wr(31)
                        end if;
                    end if;
                    --
                    if not v_addr_hit then
                        s_axi_bresp_r <= AXI_DECERR;
                        -- pragma translate_off
                        report "AWADDR decode error" severity warning;
                        -- pragma translate_on
                    end if;
                    --
                    v_state_r := DONE;

                -- Write transaction completed, wait for master BREADY to proceed
                when DONE =>
                    if s_axi_bready = '1' then
                        s_axi_bvalid_r <= '0';
                        v_state_r      := IDLE;
                    end if;

            end case;


        end if;
    end process write_fsm;

    ----------------------------------------------------------------------------
    -- Outputs
    --
    s_axi_awready <= s_axi_awready_r;
    s_axi_wready  <= s_axi_wready_r;
    s_axi_bvalid  <= s_axi_bvalid_r;
    s_axi_bresp   <= s_axi_bresp_r;
    s_axi_arready <= s_axi_arready_r;
    s_axi_rvalid  <= s_axi_rvalid_r;
    s_axi_rresp   <= s_axi_rresp_r;
    s_axi_rdata   <= s_axi_rdata_r;

    regs2user.version_strobe <= s_version_strobe_r;
    regs2user.control_strobe <= s_control_strobe_r;
    regs2user.control_start <= s_reg_control_start_r;
    regs2user.control_cpol <= s_reg_control_cpol_r;
    regs2user.control_cpha <= s_reg_control_cpha_r;
    regs2user.control_cont <= s_reg_control_cont_r;
    regs2user.status_strobe <= s_status_strobe_r;
    regs2user.addr_strobe <= s_addr_strobe_r;
    regs2user.addr_addr <= s_reg_addr_addr_r;
    regs2user.data_wr_strobe <= s_data_wr_strobe_r;
    regs2user.data_wr_data_wr <= s_reg_data_wr_data_wr_r;
    regs2user.data_rd_strobe <= s_data_rd_strobe_r;

end architecture RTL;
