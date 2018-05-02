library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

-------------------------------
entity Ultrasound is
-------------------------------
port (clk, rst, go, mic, echo:in std_logic;
      s:out std_logic_vector(3 downto 0);
      trigger:out std_logic;
      e_o :out std_logic;
      d:out std_logic_vector(15 downto 0));
end entity Ultrasound;

architecture MAE of Ultrasound is
  type StateType is (E0, E1, E2, E3);
  signal State: StateType;
  signal i: natural;
  signal j: natural;
begin
  process(clk,rst)
  begin
    if rst = '1' then
      State <= E0;
      s <= (others => '0');
      trigger <= '0';
      --echo <= '0';
      i <= 0;
      d <= (others => '0');
    elsif rising_edge(clk) then
      e_o <= echo;
      case State is
        when E0 =>  if go = '1' then
                      State <= E1;
                      i <= 0;
                      trigger <= '1';
                    end if;
                    s <= "0000";
        when E1 =>  if i < 500 then
                      i <= i + 1;
                    elsif i > 500 then
                      trigger <= '0';
                    end if;
                    if echo = '1' then
                      State <= E2;
                      i <= 0;
                    end if;
                    s <= "0001";
        when E2 =>  if echo = '1' then
                      i <= i + 1;
                    elsif echo = '0' then
                      State <= E3;
                    end if;
                    s <= "0010";
        when E3 =>  
                    d <= std_logic_vector(to_unsigned(17 * i / 100000, 16));
                    s <= "0011";
      end case;
    end if;
  end process;
end architecture;
