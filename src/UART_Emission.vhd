library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

-------------------------------
entity UART_Emission is
-------------------------------
port (clk, rst, go :in std_logic;
      din :in std_logic_vector (7 downto 0);
      ticks :in std_logic_vector (3 downto 0);
      SEL :in std_logic_vector (1 downto 0);
      Tx, Tx_Busy :out std_logic);
end entity MAE_Emission;

architecture RTL of UART_Emission is
  signal ticks : std_logic_vector (3 downto 0);
  signal rate, tx, busy : std_logic;
begin
  FDIV: entity FDIV port map(clk => clk, rst => rst, ticks => ticks);
  MUX: entity MUX4V1 port map(I => ticks, selector => SEL, Y => rate)
  MAE: entity MAE_Emission port map(clk => clk, rst => rst, go => go,
                                    din => din, tick_bit => rate,
                                    Tx => tx, Tx_busy => busy);
end architecture;
