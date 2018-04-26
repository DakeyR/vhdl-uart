
library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

-------------------------------
entity MAE_Reception is
-------------------------------
port (clk, rst, tick_bit, Rx :in std_logic;
      Dout :out std_logic_vector (7 downto 0);
      Dav, Rx_Error :out std_logic);
end entity MAE_Reception;

-----------------------------------
architecture MAE of MAE_Reception is
-----------------------------------
  type StateType is (E0, E1, E2, E3, E4, E5, E6, E7, E8, ER);
  signal State: StateType;
  signal i: natural;
  signal ticks: natural;
  signal reg: std_logic_vector (7 downto 0);
begin
  process (clk, rst)
  begin
    if rst = '1' then
      State <= E0;
      i <= 0;
      Dav <= '0';
    elsif rising_edge(clk) then
      if tick_bit = '1' then
        ticks <= ticks + 1;
        case State is
          when E0 =>  if Rx = '0' then
                        State <= E1;
                        Rx_Error <= '0';
                      end if;
          when E1 =>  State <= E2;
          when E2 =>  State <= E3;
          when E3 =>  if Rx = '1' then
                        State <= ER;
                        Rx_Error <= '1';
                      else
                        State <= E4;
                        i <= 0;
                      end if;
          when E4 =>  State <= E5;
                      reg(i) <= Rx;
                      i <= i + 1;
          when E5 =>  if i > 7 then
                        State <= E6;
                      else
                        reg(i) <= Rx;
                        i <= i + 1;
                      end if;
          when E6 =>  State <= E7;
          when E7 =>  if Rx = '1' then
                        State <= E8;
                        Dout <= reg;
                        Dav <= '1';
                      else
                        State <= ER;
                        Rx_Error <= '1';
                      end if;
          when E8 =>  if Rx = '0' then
                        State <= E0;
                        Dav <= '0';
                      end if;
          when ER => Rx_Error <= '1';
        end case;
      end if;
    end if;
  end process;
end architecture;
