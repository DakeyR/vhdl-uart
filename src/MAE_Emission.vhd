library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

-------------------------------
entity MAE_Emission is
-------------------------------
port (tick_bit, clk, rst, go :in std_logic;
      din :in std_logic_vector (7 downto 0);
      Tx, Tx_Busy :out std_logic);
end entity MAE_Emission;

-----------------------------------
architecture MAE of MAE_Emission is
-----------------------------------
  type StateType is (E0, E1, E2, E3);
  signal State: StateType;
  signal i: natural;
  signal reg: std_logic_vector (9 downto 0);
begin
  process (clk, rst)
  begin
    if rst = '1' then
      State <= E0;
      Tx <= '1';
      Tx_Busy <= '0';
      i <= 0;
      reg <= (others => '1');
    elsif rising_edge(clk) then
        case State is
          when E0 =>  if go = '1' then
                        State <= E1;
                      end if;
          when E1 =>  reg <= '1' & Din & '0';
                      i <= 0;
                      Tx_Busy <= '1';
                      if tick_bit = '1' then
                        State <= E2;
                      end if;
          when E2 =>  if tick_bit = '1' then
                        Tx <= reg(i);
                        i <= i + 1;
                      end if;
                      if i > 9 then
                        State <= E3;
                      end if;
          when E3 =>  i <= 0;
                      Tx_Busy <= '0';
                      if go = '0' then
                        State <= E0;
                      end if;
        end case;
    end if;
  end process;
end architecture;
