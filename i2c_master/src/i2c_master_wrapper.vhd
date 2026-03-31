--! ### i2c master wrapper.

--! The module receives a configuration to make a transfer that can be a read or a write.
--! 
--! The **ready signal** indicates if the transaction has been already done and the data output is ready to be read.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! {"name": "i2c_wrapper", "test" : "cocotb", 
--!   "description": "wrapper for i2c master module", 
--!   "signal": [
--!    ["CLK",
--!     {"name": "clk_in", "wave": "p...|...", "type":"std_logic", "period":"2"}],
--!    ["IN",
--!     {"name": "start_in", "wave": "0..10..........", "type": "std_logic"},
--!     {"name": "byte_cnt_in", "wave": "x.5.....|......", "type": "std_logic_vector"},
--!     {"name": "addr_in", "wave": "x.3.....|......", "type": "std_logic_vector"},
--!     {"name": "rw_in", "wave": "x.1.....|......", "type": "std_logic"},
--!     {"name": "data_wr_in", "wave": "x.4.....|......", "type":"std_logic_vector"}],
--!    ["OUT",
--!     {"name": "data_rd_out", "wave": "x.......|...7..", "type": "std_logic_vector",},
--!     {"name": "ack_error_out", "wave": "x.....0.|...x..", "type": "std_logic",},
--!     {"name": "ready_out", "wave": "1.....0.|...1..", "type": "std_logic",}]
--! ]}
--! ### data_rd_out [31:0]
--! {reg: [
--! {bits: 8, name: 'byte 0', type: 6},
--! {bits: 8, name: 'byte 1', type: 6},
--! {bits: 8, name: 'byte 2', type: 6},
--! {bits: 8, name: 'byte 3', type: 6},
--! ]}
--! ### data_rd_out [63:32]
--! {reg: [
--! {bits: 8, name: 'byte 4', type: 6},
--! {bits: 8, name: 'byte 5', type: 6},
--! {bits: 8, name: 'byte 6', type: 6},
--! {bits: 8, name: 'byte 7', type: 6},
--! ]}
--! ### data_wr_in [31:0]
--! {reg: [
--! {bits: 8, name: 'byte 0', type: 2},
--! {bits: 8, name: 'byte 1', type: 2},
--! {bits: 8, name: 'byte 2', type: 2},
--! {bits: 8, name: 'byte 3', type: 2},
--! ]}
--! ### data_wr_in [63:32]
--! {reg: [
--! {bits: 8, name: 'byte 4', type: 2},
--! {bits: 8, name: 'byte 5', type: 2},
--! {bits: 8, name: 'byte 6', type: 2},
--! {bits: 8, name: 'byte 7', type: 2},
--! ]}

entity i2c_master_wrapper is
   generic (
      g_input_clk : integer := 100_000_000; --! input clock speed from user logic in Hz
      g_bus_clk   : integer := 100_000);    --! speed the i2c bus (scl) will run at in Hz
   port (
      clk_in        : in std_logic;                      --! system clock
      reset_n       : in std_logic;                      --! active low reset
      start_in      : in std_logic;                      --! latch in command
      byte_cnt_in   : in std_logic_vector(3 downto 0);   --! byte count rw
      addr_in       : in std_logic_vector(6 downto 0);   --! address of target slave
      rw_in         : in std_logic;                      --! '0' is write, '1' is read
      data_wr_in    : in std_logic_vector(63 downto 0);  --! data to write to slave
      busy_out      : out std_logic;                     --! indicates transaction in progress
      ready_out     : out std_logic:='1';                     --! indicates transaction done
      data_rd_out   : out std_logic_vector(63 downto 0); --! data read from slave
      ack_error_out : out std_logic;                     --! flag if improper acknowledge from slave
      sda_o         : in std_logic;                    
      sda_i         : out std_logic;
      sda_t         : out std_logic;
      scl_o         : in std_logic; 
      scl_i         : out std_logic;
      scl_t         : out std_logic
   );                 
end i2c_master_wrapper;

architecture rtl of i2c_master_wrapper is

   constant c_data_size : integer := 8;

   type t_FSM is (IDLE, READ, WRITE);
   signal FSM : t_FSM := IDLE;

   signal s_data_read  : std_logic_vector(63 downto 0) := (others => '0');
   signal s_data_write : std_logic_vector(63 downto 0) := (others => '0');
   signal s_data_rd    : std_logic_vector(7 downto 0)  := (others => '0');
   signal s_data_wr    : std_logic_vector(7 downto 0)  := (others => '0');

   signal r0_busy, r1_busy, s_busy_r_pulse, s_busy_f_pulse : std_logic            := '0';
   signal s_ena                                            : std_logic            := '0';
   signal s_byte_cnt                                       : integer range 0 to 7 := 0;
   
begin

   busy_out <= r0_busy;

   -- rising edge detector
   rising_edge_detector : process (clk_in)
   begin
      if rising_edge(clk_in) then
         if reset_n = '0' then
            r1_busy <= '0';
         else
            r1_busy <= r0_busy;
         end if;
      end if;
   end process rising_edge_detector;
   s_busy_r_pulse <= not r1_busy and r0_busy;
   s_busy_f_pulse <= not r0_busy and r1_busy;

   fsm_proc: process (clk_in)
   begin
      if rising_edge(clk_in) then
         if reset_n = '0' then
            s_byte_cnt  <= 0;
            FSM         <= IDLE;
            s_ena       <= '0';
            ready_out   <= '1';
            s_data_read <= (others => '0');
         end if;

         case FSM is
            when IDLE =>
               ready_out   <= '1';
               s_ena       <= '0';
               s_byte_cnt  <= 0; -- max value = to_integer(unsigned(byte_cnt_in))
               s_data_wr   <= s_data_write(c_data_size - 1 downto 0);

               if start_in = '1' and rw_in = '1' then
                  FSM       <= READ;
                  s_ena     <= '1';
                  ready_out <= '0';
               elsif start_in = '1' and rw_in = '0' then
                  FSM       <= WRITE;
                  ready_out <= '0';
                  s_ena     <= '1';
               end if;

            when READ =>
               if s_busy_f_pulse = '1' and s_byte_cnt < to_integer(unsigned(byte_cnt_in)) then
                  s_data_read((1 + s_byte_cnt) * c_data_size - 1 downto c_data_size * s_byte_cnt) <= s_data_rd;
                  s_byte_cnt                                                                      <= s_byte_cnt + 1;
               elsif s_byte_cnt >= to_integer(unsigned(byte_cnt_in)) then
                  FSM <= IDLE;
               end if;
               if s_byte_cnt = to_integer(unsigned(byte_cnt_in)) - 1 and s_busy_r_pulse = '1' then
                  s_ena <= '0';
               end if;

            when WRITE =>
               if scl_o = '0' then
                  s_data_wr <= s_data_write((1 + s_byte_cnt + 1) * c_data_size - 1 downto c_data_size * (s_byte_cnt + 1));
               end if;
               if s_busy_f_pulse = '1' and s_byte_cnt < to_integer(unsigned(byte_cnt_in)) then
                  s_byte_cnt <= s_byte_cnt + 1;
               elsif s_byte_cnt >= to_integer(unsigned(byte_cnt_in)) then
                  FSM <= IDLE;
               end if;
               if s_byte_cnt = to_integer(unsigned(byte_cnt_in)) - 1 and s_busy_r_pulse = '1' then
                  s_ena <= '0';
                  report "s_ena = 0";
               end if;

            when others =>
               FSM <= IDLE;
         end case;
      end if;
   end process;
   data_rd_out  <= s_data_read;
   s_data_write <= data_wr_in;

   i2c_master_inst : entity work.i2c_master
      generic map(
         input_clk      => g_input_clk,
         bus_clk        => g_bus_clk
      )     
      port map(      
         clk            => clk_in,
         reset_n        => reset_n,
         ena            => s_ena,
         addr           => addr_in,
         rw             => rw_in,
         data_wr        => s_data_wr,
         busy           => r0_busy,
         data_rd        => s_data_rd,
         ack_error      => ack_error_out,
         sda_o          => sda_o,
         sda_i          => sda_i,
         sda_t          => sda_t,
         scl_i          => scl_i,
         scl_t          => scl_t
      );

end rtl;