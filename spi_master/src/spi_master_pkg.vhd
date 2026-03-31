--------------------------------------------------------------------------------
--
--   FileName:         spi_master.vhd
--   Dependencies:     none
--   Design Software:  Quartus II Version 9.0 Build 132 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 7/23/2010 Scott Larson
--     Initial Public Release
--   Version 1.1 4/11/2013 Scott Larson
--     Corrected ModelSim simulation error (explicitly reset clk_toggles signal)
--    
--------------------------------------------------------------------------------

--! Standard library.
library ieee;
--! Logic elements.
use ieee.std_logic_1164.all;
--! arithmetic functions.
use ieee.numeric_std.all;

package spi_master_pkg is

  component spi_master
    generic (
      slaves  : integer;
      d_width : integer;
      clk_div : integer
    );
    port (
      clock   : in std_logic;
      reset_n : in std_logic;
      enable  : in std_logic;
      cpol    : in std_logic;
      cpha    : in std_logic;
      cont    : in std_logic;
      addr    : in std_logic_vector(slaves - 1 downto 0);
      tx_data : in std_logic_vector(d_width - 1 downto 0);
      miso    : in std_logic;
      sclk    : out std_logic;
      ss_n    : out std_logic_vector(slaves - 1 downto 0);
      mosi    : out std_logic;
      busy    : out std_logic;
      rx_data : out std_logic_vector(d_width - 1 downto 0)
    );
  end component;

end package;