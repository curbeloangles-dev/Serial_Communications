-- -----------------------------------------------------------------------------
-- 'i2c_interface' Register Definitions
-- Revision: 62
-- -----------------------------------------------------------------------------
-- Generated on 2021-05-19 at 07:47 (UTC) by airhdl version 2021.05.1
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

package i2c_interface_regs_pkg is

    -- Type definitions
    type slv1_array_t is array(natural range <>) of std_logic_vector(0 downto 0);
    type slv2_array_t is array(natural range <>) of std_logic_vector(1 downto 0);
    type slv3_array_t is array(natural range <>) of std_logic_vector(2 downto 0);
    type slv4_array_t is array(natural range <>) of std_logic_vector(3 downto 0);
    type slv5_array_t is array(natural range <>) of std_logic_vector(4 downto 0);
    type slv6_array_t is array(natural range <>) of std_logic_vector(5 downto 0);
    type slv7_array_t is array(natural range <>) of std_logic_vector(6 downto 0);
    type slv8_array_t is array(natural range <>) of std_logic_vector(7 downto 0);
    type slv9_array_t is array(natural range <>) of std_logic_vector(8 downto 0);
    type slv10_array_t is array(natural range <>) of std_logic_vector(9 downto 0);
    type slv11_array_t is array(natural range <>) of std_logic_vector(10 downto 0);
    type slv12_array_t is array(natural range <>) of std_logic_vector(11 downto 0);
    type slv13_array_t is array(natural range <>) of std_logic_vector(12 downto 0);
    type slv14_array_t is array(natural range <>) of std_logic_vector(13 downto 0);
    type slv15_array_t is array(natural range <>) of std_logic_vector(14 downto 0);
    type slv16_array_t is array(natural range <>) of std_logic_vector(15 downto 0);
    type slv17_array_t is array(natural range <>) of std_logic_vector(16 downto 0);
    type slv18_array_t is array(natural range <>) of std_logic_vector(17 downto 0);
    type slv19_array_t is array(natural range <>) of std_logic_vector(18 downto 0);
    type slv20_array_t is array(natural range <>) of std_logic_vector(19 downto 0);
    type slv21_array_t is array(natural range <>) of std_logic_vector(20 downto 0);
    type slv22_array_t is array(natural range <>) of std_logic_vector(21 downto 0);
    type slv23_array_t is array(natural range <>) of std_logic_vector(22 downto 0);
    type slv24_array_t is array(natural range <>) of std_logic_vector(23 downto 0);
    type slv25_array_t is array(natural range <>) of std_logic_vector(24 downto 0);
    type slv26_array_t is array(natural range <>) of std_logic_vector(25 downto 0);
    type slv27_array_t is array(natural range <>) of std_logic_vector(26 downto 0);
    type slv28_array_t is array(natural range <>) of std_logic_vector(27 downto 0);
    type slv29_array_t is array(natural range <>) of std_logic_vector(28 downto 0);
    type slv30_array_t is array(natural range <>) of std_logic_vector(29 downto 0);
    type slv31_array_t is array(natural range <>) of std_logic_vector(30 downto 0);
    type slv32_array_t is array(natural range <>) of std_logic_vector(31 downto 0);

    -- User-logic ports (from user-logic to register file)
    type user2regs_t is record
        version_value : std_logic_vector(31 downto 0); -- value of register 'version', field 'value'
        status_ready : std_logic_vector(0 downto 0); -- value of register 'status', field 'ready'
        status_ack_error : std_logic_vector(0 downto 0); -- value of register 'status', field 'ack_error'
        status_busy : std_logic_vector(0 downto 0); -- value of register 'status', field 'busy'
        data_rd_low_data_rd_0 : std_logic_vector(7 downto 0); -- value of register 'data_rd_low', field 'data_rd_0'
        data_rd_low_data_rd_1 : std_logic_vector(7 downto 0); -- value of register 'data_rd_low', field 'data_rd_1'
        data_rd_low_data_rd_2 : std_logic_vector(7 downto 0); -- value of register 'data_rd_low', field 'data_rd_2'
        data_rd_low_data_rd_3 : std_logic_vector(7 downto 0); -- value of register 'data_rd_low', field 'data_rd_3'
        data_rd_high_data_rd_4 : std_logic_vector(7 downto 0); -- value of register 'data_rd_high', field 'data_rd_4'
        data_rd_high_data_rd_5 : std_logic_vector(7 downto 0); -- value of register 'data_rd_high', field 'data_rd_5'
        data_rd_high_data_rd_6 : std_logic_vector(7 downto 0); -- value of register 'data_rd_high', field 'data_rd_6'
        data_rd_high_data_rd_7 : std_logic_vector(7 downto 0); -- value of register 'data_rd_high', field 'data_rd_7'
    end record;

    -- User-logic ports (from register file to user-logic)
    type regs2user_t is record
        version_strobe : std_logic; -- Strobe signal for register 'version' (pulsed when the register is read from the bus}
        control_strobe : std_logic; -- Strobe signal for register 'control' (pulsed when the register is written from the bus}
        control_start : std_logic_vector(0 downto 0); -- Value of register 'control', field 'start'
        control_rw : std_logic_vector(0 downto 0); -- Value of register 'control', field 'rw'
        control_byte_count : std_logic_vector(3 downto 0); -- Value of register 'control', field 'byte_count'
        status_strobe : std_logic; -- Strobe signal for register 'status' (pulsed when the register is read from the bus}
        addr_strobe : std_logic; -- Strobe signal for register 'addr' (pulsed when the register is written from the bus}
        addr_addr : std_logic_vector(6 downto 0); -- Value of register 'addr', field 'addr'
        data_wr_low_strobe : std_logic; -- Strobe signal for register 'data_wr_low' (pulsed when the register is written from the bus}
        data_wr_low_data_wr_0 : std_logic_vector(7 downto 0); -- Value of register 'data_wr_low', field 'data_wr_0'
        data_wr_low_data_wr_1 : std_logic_vector(7 downto 0); -- Value of register 'data_wr_low', field 'data_wr_1'
        data_wr_low_data_wr_2 : std_logic_vector(7 downto 0); -- Value of register 'data_wr_low', field 'data_wr_2'
        data_wr_low_data_wr_3 : std_logic_vector(7 downto 0); -- Value of register 'data_wr_low', field 'data_wr_3'
        data_wr_high_strobe : std_logic; -- Strobe signal for register 'data_wr_high' (pulsed when the register is written from the bus}
        data_wr_high_data_wr_4 : std_logic_vector(7 downto 0); -- Value of register 'data_wr_high', field 'data_wr_4'
        data_wr_high_data_wr_5 : std_logic_vector(7 downto 0); -- Value of register 'data_wr_high', field 'data_wr_5'
        data_wr_high_data_wr_6 : std_logic_vector(7 downto 0); -- Value of register 'data_wr_high', field 'data_wr_6'
        data_wr_high_data_wr_7 : std_logic_vector(7 downto 0); -- Value of register 'data_wr_high', field 'data_wr_7'
        data_rd_low_strobe : std_logic; -- Strobe signal for register 'data_rd_low' (pulsed when the register is read from the bus}
        data_rd_high_strobe : std_logic; -- Strobe signal for register 'data_rd_high' (pulsed when the register is read from the bus}
    end record;

    -- Revision number of the 'i2c_interface' register map
    constant I2C_INTERFACE_REVISION : natural := 62;

    -- Default base address of the 'i2c_interface' register map
    constant I2C_INTERFACE_DEFAULT_BASEADDR : unsigned(31 downto 0) := unsigned'(x"00000000");

    -- Register 'version'
    constant VERSION_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000000"); -- address offset of the 'version' register
    -- Field 'version.value'
    constant VERSION_VALUE_BIT_OFFSET : natural := 0; -- bit offset of the 'value' field
    constant VERSION_VALUE_BIT_WIDTH : natural := 32; -- bit width of the 'value' field
    constant VERSION_VALUE_RESET : std_logic_vector(31 downto 0) := std_logic_vector'("00000000000000000000000000000001"); -- reset value of the 'value' field

    -- Register 'control'
    constant CONTROL_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000004"); -- address offset of the 'control' register
    -- Field 'control.start'
    constant CONTROL_START_BIT_OFFSET : natural := 0; -- bit offset of the 'start' field
    constant CONTROL_START_BIT_WIDTH : natural := 1; -- bit width of the 'start' field
    constant CONTROL_START_RESET : std_logic_vector(0 downto 0) := std_logic_vector'("0"); -- reset value of the 'start' field
    -- Field 'control.rw'
    constant CONTROL_RW_BIT_OFFSET : natural := 1; -- bit offset of the 'rw' field
    constant CONTROL_RW_BIT_WIDTH : natural := 1; -- bit width of the 'rw' field
    constant CONTROL_RW_RESET : std_logic_vector(1 downto 1) := std_logic_vector'("0"); -- reset value of the 'rw' field
    -- Field 'control.byte_count'
    constant CONTROL_BYTE_COUNT_BIT_OFFSET : natural := 2; -- bit offset of the 'byte_count' field
    constant CONTROL_BYTE_COUNT_BIT_WIDTH : natural := 4; -- bit width of the 'byte_count' field
    constant CONTROL_BYTE_COUNT_RESET : std_logic_vector(5 downto 2) := std_logic_vector'("0000"); -- reset value of the 'byte_count' field

    -- Register 'status'
    constant STATUS_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000008"); -- address offset of the 'status' register
    -- Field 'status.ready'
    constant STATUS_READY_BIT_OFFSET : natural := 0; -- bit offset of the 'ready' field
    constant STATUS_READY_BIT_WIDTH : natural := 1; -- bit width of the 'ready' field
    constant STATUS_READY_RESET : std_logic_vector(0 downto 0) := std_logic_vector'("1"); -- reset value of the 'ready' field
    -- Field 'status.ack_error'
    constant STATUS_ACK_ERROR_BIT_OFFSET : natural := 1; -- bit offset of the 'ack_error' field
    constant STATUS_ACK_ERROR_BIT_WIDTH : natural := 1; -- bit width of the 'ack_error' field
    constant STATUS_ACK_ERROR_RESET : std_logic_vector(1 downto 1) := std_logic_vector'("0"); -- reset value of the 'ack_error' field
    -- Field 'status.busy'
    constant STATUS_BUSY_BIT_OFFSET : natural := 2; -- bit offset of the 'busy' field
    constant STATUS_BUSY_BIT_WIDTH : natural := 1; -- bit width of the 'busy' field
    constant STATUS_BUSY_RESET : std_logic_vector(2 downto 2) := std_logic_vector'("0"); -- reset value of the 'busy' field

    -- Register 'addr'
    constant ADDR_OFFSET : unsigned(31 downto 0) := unsigned'(x"0000000C"); -- address offset of the 'addr' register
    -- Field 'addr.addr'
    constant ADDR_ADDR_BIT_OFFSET : natural := 0; -- bit offset of the 'addr' field
    constant ADDR_ADDR_BIT_WIDTH : natural := 7; -- bit width of the 'addr' field
    constant ADDR_ADDR_RESET : std_logic_vector(6 downto 0) := std_logic_vector'("0000000"); -- reset value of the 'addr' field

    -- Register 'data_wr_low'
    constant DATA_WR_LOW_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000010"); -- address offset of the 'data_wr_low' register
    -- Field 'data_wr_low.data_wr_0'
    constant DATA_WR_LOW_DATA_WR_0_BIT_OFFSET : natural := 0; -- bit offset of the 'data_wr_0' field
    constant DATA_WR_LOW_DATA_WR_0_BIT_WIDTH : natural := 8; -- bit width of the 'data_wr_0' field
    constant DATA_WR_LOW_DATA_WR_0_RESET : std_logic_vector(7 downto 0) := std_logic_vector'("00000000"); -- reset value of the 'data_wr_0' field
    -- Field 'data_wr_low.data_wr_1'
    constant DATA_WR_LOW_DATA_WR_1_BIT_OFFSET : natural := 8; -- bit offset of the 'data_wr_1' field
    constant DATA_WR_LOW_DATA_WR_1_BIT_WIDTH : natural := 8; -- bit width of the 'data_wr_1' field
    constant DATA_WR_LOW_DATA_WR_1_RESET : std_logic_vector(15 downto 8) := std_logic_vector'("00000000"); -- reset value of the 'data_wr_1' field
    -- Field 'data_wr_low.data_wr_2'
    constant DATA_WR_LOW_DATA_WR_2_BIT_OFFSET : natural := 16; -- bit offset of the 'data_wr_2' field
    constant DATA_WR_LOW_DATA_WR_2_BIT_WIDTH : natural := 8; -- bit width of the 'data_wr_2' field
    constant DATA_WR_LOW_DATA_WR_2_RESET : std_logic_vector(23 downto 16) := std_logic_vector'("00000000"); -- reset value of the 'data_wr_2' field
    -- Field 'data_wr_low.data_wr_3'
    constant DATA_WR_LOW_DATA_WR_3_BIT_OFFSET : natural := 24; -- bit offset of the 'data_wr_3' field
    constant DATA_WR_LOW_DATA_WR_3_BIT_WIDTH : natural := 8; -- bit width of the 'data_wr_3' field
    constant DATA_WR_LOW_DATA_WR_3_RESET : std_logic_vector(31 downto 24) := std_logic_vector'("00000000"); -- reset value of the 'data_wr_3' field

    -- Register 'data_wr_high'
    constant DATA_WR_HIGH_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000014"); -- address offset of the 'data_wr_high' register
    -- Field 'data_wr_high.data_wr_4'
    constant DATA_WR_HIGH_DATA_WR_4_BIT_OFFSET : natural := 0; -- bit offset of the 'data_wr_4' field
    constant DATA_WR_HIGH_DATA_WR_4_BIT_WIDTH : natural := 8; -- bit width of the 'data_wr_4' field
    constant DATA_WR_HIGH_DATA_WR_4_RESET : std_logic_vector(7 downto 0) := std_logic_vector'("00000000"); -- reset value of the 'data_wr_4' field
    -- Field 'data_wr_high.data_wr_5'
    constant DATA_WR_HIGH_DATA_WR_5_BIT_OFFSET : natural := 8; -- bit offset of the 'data_wr_5' field
    constant DATA_WR_HIGH_DATA_WR_5_BIT_WIDTH : natural := 8; -- bit width of the 'data_wr_5' field
    constant DATA_WR_HIGH_DATA_WR_5_RESET : std_logic_vector(15 downto 8) := std_logic_vector'("00000000"); -- reset value of the 'data_wr_5' field
    -- Field 'data_wr_high.data_wr_6'
    constant DATA_WR_HIGH_DATA_WR_6_BIT_OFFSET : natural := 16; -- bit offset of the 'data_wr_6' field
    constant DATA_WR_HIGH_DATA_WR_6_BIT_WIDTH : natural := 8; -- bit width of the 'data_wr_6' field
    constant DATA_WR_HIGH_DATA_WR_6_RESET : std_logic_vector(23 downto 16) := std_logic_vector'("00000000"); -- reset value of the 'data_wr_6' field
    -- Field 'data_wr_high.data_wr_7'
    constant DATA_WR_HIGH_DATA_WR_7_BIT_OFFSET : natural := 24; -- bit offset of the 'data_wr_7' field
    constant DATA_WR_HIGH_DATA_WR_7_BIT_WIDTH : natural := 8; -- bit width of the 'data_wr_7' field
    constant DATA_WR_HIGH_DATA_WR_7_RESET : std_logic_vector(31 downto 24) := std_logic_vector'("00000000"); -- reset value of the 'data_wr_7' field

    -- Register 'data_rd_low'
    constant DATA_RD_LOW_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000018"); -- address offset of the 'data_rd_low' register
    -- Field 'data_rd_low.data_rd_0'
    constant DATA_RD_LOW_DATA_RD_0_BIT_OFFSET : natural := 0; -- bit offset of the 'data_rd_0' field
    constant DATA_RD_LOW_DATA_RD_0_BIT_WIDTH : natural := 8; -- bit width of the 'data_rd_0' field
    constant DATA_RD_LOW_DATA_RD_0_RESET : std_logic_vector(7 downto 0) := std_logic_vector'("00000000"); -- reset value of the 'data_rd_0' field
    -- Field 'data_rd_low.data_rd_1'
    constant DATA_RD_LOW_DATA_RD_1_BIT_OFFSET : natural := 8; -- bit offset of the 'data_rd_1' field
    constant DATA_RD_LOW_DATA_RD_1_BIT_WIDTH : natural := 8; -- bit width of the 'data_rd_1' field
    constant DATA_RD_LOW_DATA_RD_1_RESET : std_logic_vector(15 downto 8) := std_logic_vector'("00000000"); -- reset value of the 'data_rd_1' field
    -- Field 'data_rd_low.data_rd_2'
    constant DATA_RD_LOW_DATA_RD_2_BIT_OFFSET : natural := 16; -- bit offset of the 'data_rd_2' field
    constant DATA_RD_LOW_DATA_RD_2_BIT_WIDTH : natural := 8; -- bit width of the 'data_rd_2' field
    constant DATA_RD_LOW_DATA_RD_2_RESET : std_logic_vector(23 downto 16) := std_logic_vector'("00000000"); -- reset value of the 'data_rd_2' field
    -- Field 'data_rd_low.data_rd_3'
    constant DATA_RD_LOW_DATA_RD_3_BIT_OFFSET : natural := 24; -- bit offset of the 'data_rd_3' field
    constant DATA_RD_LOW_DATA_RD_3_BIT_WIDTH : natural := 8; -- bit width of the 'data_rd_3' field
    constant DATA_RD_LOW_DATA_RD_3_RESET : std_logic_vector(31 downto 24) := std_logic_vector'("00000000"); -- reset value of the 'data_rd_3' field

    -- Register 'data_rd_high'
    constant DATA_RD_HIGH_OFFSET : unsigned(31 downto 0) := unsigned'(x"0000001C"); -- address offset of the 'data_rd_high' register
    -- Field 'data_rd_high.data_rd_4'
    constant DATA_RD_HIGH_DATA_RD_4_BIT_OFFSET : natural := 0; -- bit offset of the 'data_rd_4' field
    constant DATA_RD_HIGH_DATA_RD_4_BIT_WIDTH : natural := 8; -- bit width of the 'data_rd_4' field
    constant DATA_RD_HIGH_DATA_RD_4_RESET : std_logic_vector(7 downto 0) := std_logic_vector'("00000000"); -- reset value of the 'data_rd_4' field
    -- Field 'data_rd_high.data_rd_5'
    constant DATA_RD_HIGH_DATA_RD_5_BIT_OFFSET : natural := 8; -- bit offset of the 'data_rd_5' field
    constant DATA_RD_HIGH_DATA_RD_5_BIT_WIDTH : natural := 8; -- bit width of the 'data_rd_5' field
    constant DATA_RD_HIGH_DATA_RD_5_RESET : std_logic_vector(15 downto 8) := std_logic_vector'("00000000"); -- reset value of the 'data_rd_5' field
    -- Field 'data_rd_high.data_rd_6'
    constant DATA_RD_HIGH_DATA_RD_6_BIT_OFFSET : natural := 16; -- bit offset of the 'data_rd_6' field
    constant DATA_RD_HIGH_DATA_RD_6_BIT_WIDTH : natural := 8; -- bit width of the 'data_rd_6' field
    constant DATA_RD_HIGH_DATA_RD_6_RESET : std_logic_vector(23 downto 16) := std_logic_vector'("00000000"); -- reset value of the 'data_rd_6' field
    -- Field 'data_rd_high.data_rd_7'
    constant DATA_RD_HIGH_DATA_RD_7_BIT_OFFSET : natural := 24; -- bit offset of the 'data_rd_7' field
    constant DATA_RD_HIGH_DATA_RD_7_BIT_WIDTH : natural := 8; -- bit width of the 'data_rd_7' field
    constant DATA_RD_HIGH_DATA_RD_7_RESET : std_logic_vector(31 downto 24) := std_logic_vector'("00000000"); -- reset value of the 'data_rd_7' field

end i2c_interface_regs_pkg;
