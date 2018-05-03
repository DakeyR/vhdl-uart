library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

-------------------------------
entity FILTER is
-------------------------------
port (I :in std_logic_vector (7 downto 0);
      J :in std_logic_vector (7 downto 0);
      SEL :in std_logic_vector (7 downto 0);
      Y :out std_logic_vector (7 downto 0));
end entity FILTER;

-------------------------------
architecture RTL of FILTER is
-------------------------------
begin
  choice: process(I,J,SEL)
  begin
    if SEL(0) = '1' then
      Y <= J;
    else
      Y <= I;
    end if;
  end process;
end architecture;
