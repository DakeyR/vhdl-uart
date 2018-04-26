
-- Banc de test pour l'emission (UART)

entity rec_tb is
port( OK: out Boolean := True);
end entity rec_tb;

library IEEE;
use IEEE.Std_logic_1164.all;

architecture Bench of rec_tb is


  signal freq: positive := 50E6; -- 50MHz
  signal interval: time := 1 sec / freq;
  signal Clock, Reset, Dav, Rx, Rx_Error: Std_logic;
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

  Emit: process
  begin
    Reset <= '1';
    wait for 10 ns;
    Reset <= '0';
    Data <= "01001111";
    Baudsel <= "11";
    Reset <= '0';
    wait for 10 ns;
    Rx <= '0';

    wait for 104 us;
    wait for 104 us;
    wait for 104 us;
    wait for 104 us;
    wait for 104 us;

    while i < 8 loop
      Rx <= Data(i);
      i <= i + 1;
      wait for 104 us;
    end loop;
    wait for 104 us;
    wait for 104 us;
    Rx <= '1';
    wait for 104 us;
    Rx <= '0';

    wait;
  end process;

  Emiter: entity work.UART_Reception port map(clk => Clock, rst => Reset, Dav => Dav,
                                      SEL => Baudsel, Dout => Dout,
                                      Rx_Err => Rx_Error, Rx => Rx);

end architecture Bench;
