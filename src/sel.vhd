library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

-------------------------------
entity MUX8V2 is
-------------------------------
port (I :in std_logic_vector (7 downto 0);
      Y :out std_logic;
      Z :out std_logic);
end entity MUX8V2;

-------------------------------
architecture RTL of MUX8V2 is
-------------------------------
begin
  Y <= not(I(0));
  Z <= I(0);
end architecture;
