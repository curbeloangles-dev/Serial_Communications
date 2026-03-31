-- -----------------------------------------------------------------------------
-- 'spi_interface' Register Definitions
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

package spi_interface_regs_pkg is

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
        status_busy : std_logic_vector(0 downto 0); -- value of register 'status', field 'busy'
        data_rd_data_rd : std_logic_vector(31 downto 0); -- value of register 'data_rd', field 'data_rd'
    end record;

    -- User-logic ports (from register file to user-logic)
    type regs2user_t is record
        version_strobe : std_logic; -- Strobe signal for register 'version' (pulsed when the register is read from the bus}
        control_strobe : std_logic; -- Strobe signal for register 'control' (pulsed when the register is written from the bus}
        control_start : std_logic_vector(0 downto 0); -- Value of register 'control', field 'start'
        control_cpol : std_logic_vector(0 downto 0); -- Value of register 'control', field 'cpol'
        control_cpha : std_logic_vector(0 downto 0); -- Value of register 'control', field 'cpha'
        control_cont : std_logic_vector(0 downto 0); -- Value of register 'control', field 'cont'
        status_strobe : std_logic; -- Strobe signal for register 'status' (pulsed when the register is read from the bus}
        addr_strobe : std_logic; -- Strobe signal for register 'addr' (pulsed when the register is written from the bus}
        addr_addr : std_logic_vector(6 downto 0); -- Value of register 'addr', field 'addr'
        data_wr_strobe : std_logic; -- Strobe signal for register 'data_wr' (pulsed when the register is written from the bus}
        data_wr_data_wr : std_logic_vector(31 downto 0); -- Value of register 'data_wr', field 'data_wr'
        data_rd_strobe : std_logic; -- Strobe signal for register 'data_rd' (pulsed when the register is read from the bus}
    end record;

    -- Revision number of the 'spi_interface' register map
    constant SPI_INTERFACE_REVISION : natural := 24;

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
    -- Field 'control.cpol'
    constant CONTROL_CPOL_BIT_OFFSET : natural := 1; -- bit offset of the 'cpol' field
    constant CONTROL_CPOL_BIT_WIDTH : natural := 1; -- bit width of the 'cpol' field
    constant CONTROL_CPOL_RESET : std_logic_vector(1 downto 1) := std_logic_vector'("0"); -- reset value of the 'cpol' field
    -- Field 'control.cpha'
    constant CONTROL_CPHA_BIT_OFFSET : natural := 2; -- bit offset of the 'cpha' field
    constant CONTROL_CPHA_BIT_WIDTH : natural := 1; -- bit width of the 'cpha' field
    constant CONTROL_CPHA_RESET : std_logic_vector(2 downto 2) := std_logic_vector'("0"); -- reset value of the 'cpha' field
    -- Field 'control.cont'
    constant CONTROL_CONT_BIT_OFFSET : natural := 3; -- bit offset of the 'cont' field
    constant CONTROL_CONT_BIT_WIDTH : natural := 1; -- bit width of the 'cont' field
    constant CONTROL_CONT_RESET : std_logic_vector(3 downto 3) := std_logic_vector'("0"); -- reset value of the 'cont' field

    -- Register 'status'
    constant STATUS_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000008"); -- address offset of the 'status' register
    -- Field 'status.busy'
    constant STATUS_BUSY_BIT_OFFSET : natural := 0; -- bit offset of the 'busy' field
    constant STATUS_BUSY_BIT_WIDTH : natural := 1; -- bit width of the 'busy' field
    constant STATUS_BUSY_RESET : std_logic_vector(0 downto 0) := std_logic_vector'("0"); -- reset value of the 'busy' field

    -- Register 'addr'
    constant ADDR_OFFSET : unsigned(31 downto 0) := unsigned'(x"0000000C"); -- address offset of the 'addr' register
    -- Field 'addr.addr'
    constant ADDR_ADDR_BIT_OFFSET : natural := 0; -- bit offset of the 'addr' field
    constant ADDR_ADDR_BIT_WIDTH : natural := 7; -- bit width of the 'addr' field
    constant ADDR_ADDR_RESET : std_logic_vector(6 downto 0) := std_logic_vector'("0000000"); -- reset value of the 'addr' field

    -- Register 'data_wr'
    constant DATA_WR_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000010"); -- address offset of the 'data_wr' register
    -- Field 'data_wr.data_wr'
    constant DATA_WR_DATA_WR_BIT_OFFSET : natural := 0; -- bit offset of the 'data_wr' field
    constant DATA_WR_DATA_WR_BIT_WIDTH : natural := 32; -- bit width of the 'data_wr' field
    constant DATA_WR_DATA_WR_RESET : std_logic_vector(31 downto 0) := std_logic_vector'("00000000000000000000000000000000"); -- reset value of the 'data_wr' field

    -- Register 'data_rd'
    constant DATA_RD_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000014"); -- address offset of the 'data_rd' register
    -- Field 'data_rd.data_rd'
    constant DATA_RD_DATA_RD_BIT_OFFSET : natural := 0; -- bit offset of the 'data_rd' field
    constant DATA_RD_DATA_RD_BIT_WIDTH : natural := 32; -- bit width of the 'data_rd' field
    constant DATA_RD_DATA_RD_RESET : std_logic_vector(31 downto 0) := std_logic_vector'("00000000000000000000000000000000"); -- reset value of the 'data_rd' field

end spi_interface_regs_pkg;
