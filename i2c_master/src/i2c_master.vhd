--------------------------------------------------------------------------------
--
--   FileName:         i2c_master.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 13.1 Build 162 SJ Full Version
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
--   Version 1.0 11/01/2012 Scott Larson
--     Initial Public Release
--   Version 2.0 06/20/2014 Scott Larson
--     Added ability to interface with different slaves in the same transaction
--     Corrected ack_error bug where ack_error went 'Z' instead of '1' on error
--     Corrected timing of when ack_error signal clears
--   Version 2.1 10/21/2014 Scott Larson
--     Replaced gated clock with clock enable
--     Adjusted timing of SCL during start and stop conditions
--   Version 2.2 02/05/2015 Scott Larson
--     Corrected small SDA glitch introduced in version 2.1
-- 
--------------------------------------------------------------------------------
--! **Setting the Serial Clock Speed**
--!
--! The component derives the serial clock scl from two GENERIC parameters declared in the ENTITY, 
--! input_clk and bus_clk. The input_clk parameter must be set to the input system clock clk frequency in Hz.
--! The default setting in the example code is 50 MHz (the frequency at which the component was simulated and tested).
--! The bus_clk parameter must be set to the desired frequency of the serial clock scl. 
--! The default setting in the example code is 400 kHz, corresponding to the Fast-mode bit rate in the I2C specification.
--!
--! **Acknowledge errors**
--! 
--! After each transmitted byte, the receiving end of the I2C bus must issue an acknowledge or no-acknowledge signal. If the I2C master receives an incorrect response from the slave, it notifies the user logic by flagging the error on the ack_error port. The I2C master does not automatically attempt to resend the information, so the user logic must decide whether or not to reissue the command and/or take any additional action. The ack_error port is cleared once the next transaction begins.
--!
--! **Doc reference:** 
--! 
--! https://forum.digikey.com/t/i2c-master-vhdl/12797

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity i2c_master is
  generic (
    input_clk     : integer := 100_000_000; --! input clock speed from user logic in Hz
    bus_clk       : integer := 100_000      --! speed the i2c bus (scl) will run at in Hz
  );
  port (
    clk           : in std_logic;                     --! system clock
    reset_n       : in std_logic;                     --! active low reset
    ena           : in std_logic;                     --! latch in command
    addr          : in std_logic_vector(6 downto 0);  --! address of target slave
    rw            : in std_logic;                     --! '0' is write, '1' is read
    data_wr       : in std_logic_vector(7 downto 0);  --! data to write to slave
    busy          : out std_logic;                    --! indicates transaction in progress
    data_rd       : out std_logic_vector(7 downto 0); --! data read from slave
    ack_error     : out std_logic;                    --! flag if improper acknowledge from slave
    sda_o         : in std_logic;                     
    sda_i         : out std_logic;
    sda_t         : out std_logic;
    scl_i         : out std_logic;
    scl_t         : out std_logic
  );
end i2c_master;

architecture logic of i2c_master is
  constant divider : integer := (input_clk/bus_clk)/4;                                --! number of clocks in 1/4 cycle of scl
  type machine is(ready, start, command, slv_ack1, wr, rd, slv_ack2, mstr_ack, stop); --! needed states
  signal state          : machine;                                                     --! state machine
  signal data_clk       : std_logic;                                                   --! data clock for sda
  signal data_clk_prev  : std_logic;                                                   --! data clock during previous system clock
  signal scl_clk        : std_logic;                                                   --! constantly running internal scl
  signal scl_ena        : std_logic := '0';                                            --! enables internal scl to output
  signal sda_int        : std_logic := '1';                                            --! internal sda
  signal addr_rw        : std_logic_vector(7 downto 0);                                --! latched in address and read/write
  signal data_tx        : std_logic_vector(7 downto 0);                                --! latched in data to write to slave
  signal data_rx        : std_logic_vector(7 downto 0);                                --! data received from slave
  signal bit_cnt        : integer range 0 to 7 := 7;                                   --! tracks bit number in transaction
  signal stretch        : std_logic            := '0';                                 --! identifies if slave is stretching scl
  signal r0_ack_error   : std_logic            := '0';                                 --! registered ack_error

  signal debug_scl      : std_logic:='0';
  signal debug_sda      : std_logic:='0';
  signal s_sda_t        : std_logic:='0';

  attribute MARK_DEBUG  : string;
  attribute MARK_DEBUG of debug_scl: signal is "TRUE";
  attribute MARK_DEBUG of debug_sda: signal is "TRUE";

begin
  --generate the timing for the bus clock (scl_clk) and the data clock (data_clk)
  sclk_gen: process (clk, reset_n)
    variable count : integer range 0 to divider * 4; --timing for clock generation
  begin
    if (reset_n = '0') then --reset asserted
      stretch <= '0';
      count := 0;
    elsif (clk'EVENT and clk = '1') then
      data_clk_prev <= data_clk;        --store previous value of data clock
      if (count = divider * 4 - 1) then --end of timing cycle
        count := 0;                       --reset timer
      else
        count := count + 1; --continue clock generation timing
      end if;
      if count >= 0 and count              <= divider - 1 then
        scl_clk                              <= '0';
        data_clk                             <= '0';
      elsif count >= divider and count     <= divider * 2 - 1 then --second 1/4 cycle of clocking
        scl_clk                              <= '0';
        data_clk                             <= '1';
      elsif count >= divider * 2 and count <= divider * 3 - 1 then --third 1/4 cycle of clocking
        scl_clk                              <= '1';                 --release scl
        data_clk                             <= '1';
      else --last 1/4 cycle of clocking
        scl_clk  <= '1';
        data_clk <= '0';
      end if;
    end if;
  end process;

  --! state machine and writing to sda during scl low (data_clk rising edge)
  sda_write: process (clk, reset_n)
  begin
    if (reset_n = '0') then     --reset asserted
      state        <= ready;      --return to initial state
      busy         <= '1';        --indicate not available
      scl_ena      <= '0';        --sets scl high impedance
      sda_int      <= '1';        --sets sda high impedance
      r0_ack_error <= '0';        --clear acknowledge error flag
      bit_cnt      <= 7;          --restarts data bit counter
      data_rd      <= "00000000"; --clear data read port
    elsif (clk'EVENT and clk = '1') then
      if (data_clk = '1' and data_clk_prev = '0') then --data clock rising edge
        case state is
          when ready =>         --idle state
            if (ena = '1') then   --transaction requested
              busy    <= '1';       --flag busy
              addr_rw <= addr & rw; --collect requested slave address and command
              data_tx <= data_wr;   --collect requested data to write
              state   <= start;     --go to start bit
            else                  --remain idle
              busy  <= '0';         --unflag busy
              state <= ready;       --remain idle
            end if;
          when start =>                    --start bit of transaction
            busy    <= '1';                  --resume busy if continuous mode
            sda_int <= addr_rw(bit_cnt);     --set first address bit to bus
            state   <= command;              --go to command
          when command =>                  --address and command byte of transaction
            if (bit_cnt = 0) then            --command transmit finished
              sda_int <= '1';                  --release sda for slave acknowledge
              bit_cnt <= 7;                    --reset bit counter for "byte" states
              state   <= slv_ack1;             --go to slave acknowledge (command)
            else                             --next clock cycle of command state
              bit_cnt <= bit_cnt - 1;          --keep track of transaction bits
              sda_int <= addr_rw(bit_cnt - 1); --write address/command bit to bus
              state   <= command;              --continue with command
            end if;
          when slv_ack1 =>             --slave acknowledge bit (command)
            if (addr_rw(0) = '0') then   --write command
              sda_int <= data_tx(bit_cnt); --write first bit of data
              state   <= wr;               --go to write byte
            else                         --read command
              sda_int <= '1';              --release sda from incoming data
              state   <= rd;               --go to read byte
            end if;
          when wr =>                       --write byte of transaction
            busy <= '1';                     --resume busy if continuous mode
            if (bit_cnt = 0) then            --write byte transmit finished
              sda_int <= '1';                  --release sda for slave acknowledge
              bit_cnt <= 7;                    --reset bit counter for "byte" states
              state   <= slv_ack2;             --go to slave acknowledge (write)
            else                             --next clock cycle of write state
              bit_cnt <= bit_cnt - 1;          --keep track of transaction bits
              sda_int <= data_tx(bit_cnt - 1); --write next bit to bus
              state   <= wr;                   --continue writing
            end if;
          when rd =>                                  --read byte of transaction
            busy <= '1';                                --resume busy if continuous mode
            if (bit_cnt = 0) then                       --read byte receive finished
              if (ena = '1' and addr_rw = addr & rw) then --continuing with another read at same address
                sda_int <= '0';                             --acknowledge the byte has been received
              else                                        --stopping or continuing with a write
                sda_int <= '1';                             --send a no-acknowledge (before stop or repeated start)
              end if;
              bit_cnt <= 7;           --reset bit counter for "byte" states
              data_rd <= data_rx;     --output received data
              state   <= mstr_ack;    --go to master acknowledge
            else                    --next clock cycle of read state
              bit_cnt <= bit_cnt - 1; --keep track of transaction bits
              state   <= rd;          --continue reading
            end if;
          when slv_ack2 =>              --slave acknowledge bit (write)
            if (ena = '1') then           --continue transaction
              busy    <= '0';               --continue is accepted
              addr_rw <= addr & rw;         --collect requested slave address and command
              data_tx <= data_wr;           --collect requested data to write
              if (addr_rw = addr & rw) then --continue transaction with another write
                sda_int <= data_wr(bit_cnt);  --write first bit of data
                state   <= wr;                --go to write byte
              else                          --continue transaction with a read or new slave
                state <= start;               --go to repeated start
              end if;
            else           --complete transaction
              state <= stop; --go to stop bit
            end if;
          when mstr_ack =>              --master acknowledge bit after a read
            if (ena = '1') then           --continue transaction
              busy    <= '0';               --continue is accepted and data received is available on bus
              addr_rw <= addr & rw;         --collect requested slave address and command
              data_tx <= data_wr;           --collect requested data to write
              if (addr_rw = addr & rw) then --continue transaction with another read
                sda_int <= '1';               --release sda from incoming data
                state   <= rd;                --go to read byte
              else                          --continue transaction with a write or new slave
                state <= start;               --repeated start
              end if;
            else           --complete transaction
              state <= stop; --go to stop bit
            end if;
          when stop =>    --stop bit of transaction
            busy  <= '0';   --unflag busy
            state <= ready; --go to idle state
        end case;
      elsif (data_clk = '0' and data_clk_prev = '1') then --data clock falling edge
        case state is
          when start =>
            if (scl_ena = '0') then --starting new transaction
              scl_ena      <= '1';    --enable scl output
              r0_ack_error <= '0';    --reset acknowledge error output
            end if;
          when slv_ack1 =>                           --receiving slave acknowledge (command)
            if (sda_o /= '0' or r0_ack_error = '1') then --no-acknowledge or previous no-acknowledge
              r0_ack_error <= '1';                       --set error output if no-acknowledge
            end if;
          when rd =>                                 --receiving slave data
            data_rx(bit_cnt) <= sda_o;                   --receive current slave data bit
          when slv_ack2 =>                           --receiving slave acknowledge (write)
            if (sda_o /= '0' or r0_ack_error = '1') then --no-acknowledge or previous no-acknowledge
              r0_ack_error <= '1';                       --set error output if no-acknowledge
            end if;
          when stop =>
            scl_ena <= '0'; --disable scl
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

  --assign ack_error output
  ack_error <= r0_ack_error;

  --set scl and sda outputs
  sda_i     <= '0' when s_sda_t = '0' else '1';
  with state select
  s_sda_t <= data_clk_prev when start,  --generate start condition
    not data_clk_prev when stop,        --generate stop condition
    sda_int when others;                --set to internal sda signal    
  sda_t     <= s_sda_t;

  scl_i     <= '0' when (scl_ena = '1' and scl_clk = '0') else '1';  
  scl_t     <= '0' when (scl_ena = '1' and scl_clk = '0') else '1';  

  debug_sda <= '0' when s_sda_t = '0' else '1';
  debug_scl <= '0' when (scl_ena = '1' and scl_clk = '0') else '1';

end logic;