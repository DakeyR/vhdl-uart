
library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

-------------------------------
entity UART_Reception is
-------------------------------
port (clk, rst, Rx :in std_logic;
      SEL :in std_logic_vector (1 downto 0);
      Dout :out std_logic_vector (7 downto 0);
      Dav, Rx_err :out std_logic);
end entity UART_Reception;

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

---------------------------------
entity OR_Reset is
---------------------------------
port (i, j:in std_logic;
      Y:out std_logic);
end entity OR_Reset;

architecture RTL of OR_Reset is
begin
  Y <= i or j;
end architecture;


---------------------------------

architecture RTL of UART_Reception is
  signal ticks : std_logic_vector (3 downto 0);
  signal Clear: std_logic;
  signal res_fdiv: std_logic;
begin
  RES: entity work.OR_Reset port map(i => rst, j => Clear,Y => res_fdiv);
  FDIV: entity work.FDIV port map(clk => clk, rst => res_fdiv, ticks => ticks);
  MAE: entity work.MAE_Reception port map(clk => clk, rst => rst, Rx => Rx,
                                    tick_bit => ticks(2), Dout => Dout, Clear => Clear,
                                    Dav => Dav, Rx_Error => Rx_err);
end architecture;
