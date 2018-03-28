library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

-------------------------------
entity MUX41 is
-------------------------------
port (tick_br0, tick_br1, tick_br2, tick_br3 :in std_logic;
      selector :in std_logic_vector (1 downto 0);
      tick_br :out std_logic);
end entity MUX41;

-------------------------------
architecture RTL of MUX41 is
-------------------------------
  signal rate : std_logic;
begin
  tick_br <= rate;
  process (selector, tick_br0, tick_br1, tick_br2, tick_br3)
begin
  case selector is
    when "00" => rate <= tick_br0;
    when "01" => rate <= tick_br1;
    when "10" => rate <= tick_br2;
    when "11" => rate <= tick_br3;
    when others => rate <= tick_br0;
  end case;
end process;
end architecture;
