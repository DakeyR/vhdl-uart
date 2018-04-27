library IEEE;
use IEEE.Std_logic_1164.all;

entity uart_tb is
port( OK: out Boolean := True);
end entity uart_tb;

architecture Bench of uart_tb is

  signal freq: positive := 50E6; -- 50MHz
  signal interval: time := 1 sec / freq;
  signal Clock, Reset, Dav, Go, Rx, Rx_Error, Busy: Std_logic;
  signal Dout, Data: Std_logic_vector(7 downto 0);
  signal Baudsel: Std_logic_vector(1 downto 0);
  signal i: natural;

begin

  Clk: process
  begin
    while now <= 30000 US loop
      Clock <= '0';
      wait for interval / 2;
      Clock <= '1';
      wait for interval / 2;
    end loop;
    wait;
  end process;

  Uart: process
  begin
    Reset <= '1';
    wait for 10 ns;
    Go <= '0';
    Data <= "01001111";
    Baudsel <= "11";
    Reset <= '0';
    wait for 10 ns;
    Go <= '1';

    wait for 104 us;
    --Rx <= '0';
    wait for 104 us;
    Go <= '1';

    wait;
  end process;

  Receiver: entity work.UART_Reception port map(clk => Clock, rst => Reset, Dav => Dav,
                                      SEL => Baudsel, Dout => Dout,
                                      Rx_Err => Rx_Error, Rx => Rx);

  Emiter: entity work.UART_Emission port map(clk => Clock, rst => Reset, go => Go,
                                      SEL => Baudsel, din => Data,
                                      Tx_Busy => Busy, Tx => Rx);
end architecture Bench;
