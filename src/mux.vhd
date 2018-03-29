library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

-------------------------------
entity MUX4V1 is
-------------------------------
port (I :in std_logic_vector (3 downto 0);
      selector :in std_logic_vector (1 downto 0);
      Y :out std_logic);
end entity MUX4V1;

-------------------------------
architecture RTL of MUX4V1 is
-------------------------------
begin
  Y <= I(to_integer(unsigned(selector)));
end architecture;
