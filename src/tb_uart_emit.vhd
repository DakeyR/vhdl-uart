-- Banc de test pour l'emission (UART)

entity emit_tb is
port( OK: out Boolean := True);
end entity emit_tb;

library IEEE;
use IEEE.Std_logic_1164.all;

architecture Bench of emit_tb is


  signal freq: positive := 50E6; -- 50MHz
  signal interval: time := 1 sec / freq;
  signal Clock, Reset, Go, Tx, Busy: Std_logic;
  signal Data: Std_logic_vector(7 downto 0);
  signal Baudsel: Std_logic_vector(1 downto 0);
  signal counter: integer;

  

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
    counter <= 0;
    wait for 10 ns;
    Reset <= '0';
    Data <= "01001111";
    Baudsel <= "11";
    Reset <= '0';
    Go <= '0';
    wait for 10 ns;
    Go <= '1';

    wait for 104 us;
    counter <= 0;
    if Tx /= '0' then
      OK <= False;
    else
      OK <= True;
    end if;

    wait for 104 us;
    counter <= 1;
    if Tx /= '0' then
      OK <= False;
    else
      OK <= True;
    end if;

    wait for 104 us;
    counter <= 2;
    if Tx /= '1' then
      OK <= False;
    else
      OK <= True;
    end if;

    wait for 104 us;
    counter <= 3;
    if Tx /= '0' then
      OK <= False;
    else
      OK <= True;
    end if;

    wait for 104 us;
    counter <= 4;
    if Tx /= '0' then
      OK <= False;
    else
      OK <= True;
    end if;

    wait for 104 us;
    counter <= 5;
    if Tx /= '1' then
      OK <= False;
    else
      OK <= True;
    end if;

    wait for 104 us;
    counter <= 6;
    if Tx /= '1' then
      OK <= False;
    else
      OK <= True;
    end if;

    wait for 104 us;
    counter <= 7;
    if Tx /= '1' then
      OK <= False;
    else
      OK <= True;
    end if;

    wait for 104 us;
    counter <= 8;
    if Tx /= '1' then
      OK <= False;
    else
      OK <= True;
    end if;

    wait for 104 us;
    counter <= 9;
    if Tx /= '1' then
      OK <= False;
    else
      OK <= True;
    end if;

    wait for 10 ns;
    Go <= '0';

    wait;
  end process;

  Emiter: entity work.UART_Emission port map(clk => Clock, rst => Reset, go => Go,
                                      SEL => Baudsel, din => Data,
                                      Tx_Busy => Busy, Tx => Tx);

end architecture Bench;
