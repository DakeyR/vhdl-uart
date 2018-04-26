
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

architecture RTL of UART_Reception is
  signal ticks : std_logic_vector (3 downto 0);
  signal rate: std_logic;
begin
  FDIV: entity work.FDIV port map(clk => clk, rst => rst, ticks => ticks);
  MUX: entity work.MUX4V1 port map(I => ticks, selector => SEL, Y => rate);
  MAE: entity work.MAE_Reception port map(clk => clk, rst => rst, Rx => Rx,
                                    tick_bit => rate, Dout => Dout,
                                    Dav => Dav, Rx_Error => Rx_err);
end architecture;
