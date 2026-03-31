
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package i2c_master_utils_pkg is

   type i2c_rec_in is record
      byte_cnt_in : std_logic_vector(3 downto 0);
      addr_in     : std_logic_vector(6 downto 0);
      data_wr_0_in  : std_logic_vector(7 downto 0);
      data_wr_1_in  : std_logic_vector(7 downto 0);
      data_wr_2_in  : std_logic_vector(7 downto 0);
      data_wr_3_in  : std_logic_vector(7 downto 0);
      data_wr_4_in  : std_logic_vector(7 downto 0);
      data_wr_5_in  : std_logic_vector(7 downto 0);
      data_wr_6_in  : std_logic_vector(7 downto 0);
      data_wr_7_in  : std_logic_vector(7 downto 0);
      rw_in       : std_logic;
   end record i2c_rec_in;

   type i2c_rec_out is record
      busy_out      : std_logic;
      data_rd_0_out   : std_logic_vector(7 downto 0);
      data_rd_1_out   : std_logic_vector(7 downto 0);
      data_rd_2_out   : std_logic_vector(7 downto 0);
      data_rd_3_out   : std_logic_vector(7 downto 0);
      data_rd_4_out   : std_logic_vector(7 downto 0);
      data_rd_5_out   : std_logic_vector(7 downto 0);
      data_rd_6_out   : std_logic_vector(7 downto 0);
      data_rd_7_out   : std_logic_vector(7 downto 0);
      ack_error_out : std_logic;
   end record i2c_rec_out;

end package;