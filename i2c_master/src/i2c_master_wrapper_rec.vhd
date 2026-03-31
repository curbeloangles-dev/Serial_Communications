--! wrap i2c master into records types

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.i2c_master_utils_pkg.all;

--! {"name": "i2c_wrapper", "test" : "cocotb", 
--!   "description": "wrapper for i2c master module", 
--!   "signal": [
--!    ["CLK",
--!     {"name": "clk_in", "wave": "p...|...", "type":"std_logic", "period":"2"}],
--!    ["IN",
--!     {"name": "start_in", "wave": "0...10..........", "type": "std_logic"},
--!     {"name": "i2c_in", "wave": "x.4.....|.......", "type":"std_logic_vector"}],
--!    ["OUT",
--!     {"name": "i2c_out", "wave": "x.......|...7...", "type": "std_logic_vector",},
--!     {"name": "ready_out", "wave": "1.....0.|...1...", "type": "std_logic",}]
--! ]}


entity i2c_master_wrapper_rec is
   generic (
      g_input_clk : integer := 100_000_000; --! input clock speed from user logic in Hz
      g_bus_clk   : integer := 100_000    --! speed the i2c bus (scl) will run at in Hz
      );
   port (
      clk_in   : in std_logic;  --! system clock
      reset_n  : in std_logic;  --! active low reset
      start_in : in std_logic;  --! start transaction
      ready_out    : out std_logic; --! indicates transaction done

      i2c_in  : in  i2c_rec_in;  --! i2c record port
      i2c_out : out i2c_rec_out; --! i2c record port

      sda_o         : in std_logic;                    
      sda_i         : out std_logic;
      sda_t         : out std_logic;
      scl_o         : in std_logic; 
      scl_i         : out std_logic;
      scl_t         : out std_logic
      );
end entity;

architecture rtl of i2c_master_wrapper_rec is

signal s_i2c_in : i2c_rec_in:=(
   byte_cnt_in => "0010",
   addr_in => "0000010",
   data_wr_0_in => x"aa",
   data_wr_1_in => x"bb",
   data_wr_2_in => x"cc",
   data_wr_3_in => x"dd",
   data_wr_4_in => x"ee",
   data_wr_5_in => x"ff",
   data_wr_6_in => x"88",
   data_wr_7_in => x"11",
   rw_in => '0'
);

signal s_i2c_out : i2c_rec_out;
signal s_data_wr_in : std_logic_vector(63 downto 0):=(others => '0');
signal s_data_rd_out : std_logic_vector(63 downto 0):=(others => '0');

begin

   s_i2c_in                <= i2c_in;
   i2c_out                 <= s_i2c_out;
   s_data_wr_in            <= s_i2c_in.data_wr_7_in & s_i2c_in.data_wr_6_in & s_i2c_in.data_wr_5_in & s_i2c_in.data_wr_4_in & s_i2c_in.data_wr_3_in & s_i2c_in.data_wr_2_in & s_i2c_in.data_wr_1_in & s_i2c_in.data_wr_0_in;
   s_i2c_out.data_rd_0_out <= s_data_rd_out(7 downto 0);
   s_i2c_out.data_rd_1_out <= s_data_rd_out(15 downto 8);
   s_i2c_out.data_rd_2_out <= s_data_rd_out(23 downto 16);
   s_i2c_out.data_rd_3_out <= s_data_rd_out(31 downto 24);
   s_i2c_out.data_rd_4_out <= s_data_rd_out(39 downto 32);
   s_i2c_out.data_rd_5_out <= s_data_rd_out(47 downto 40);
   s_i2c_out.data_rd_6_out <= s_data_rd_out(55 downto 48);
   s_i2c_out.data_rd_7_out <= s_data_rd_out(63 downto 56);

   i2c_master_wrapper_inst : entity work.i2c_master_wrapper
      generic map(
         g_input_clk => g_input_clk,
         g_bus_clk   => g_bus_clk
      )
      port map(
         clk_in        => clk_in,
         reset_n       => reset_n,
         start_in      => start_in,
         byte_cnt_in   => s_i2c_in.byte_cnt_in,
         addr_in       => s_i2c_in.addr_in,
         rw_in         => s_i2c_in.rw_in,
         data_wr_in    => s_data_wr_in,
         busy_out      => s_i2c_out.busy_out,
         ready_out     => ready_out,
         data_rd_out   => s_data_rd_out,
         ack_error_out => s_i2c_out.ack_error_out,
         sda_o         => sda_o,
         sda_i         => sda_i,
         sda_t         => sda_t,
         scl_o         => scl_o,
         scl_i         => scl_i,
         scl_t         => scl_t
      );
end architecture;