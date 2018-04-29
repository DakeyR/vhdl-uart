-- SevenSeg.vhd
-- ------------------------------
--   squelette de l'encodeur sept segment
-- ------------------------------

--
-- Notes :
--  * We don't ask for an hexadecimal decoder, only 0..9
--  * outputs are active high if Pol='1'
--    else active low (Pol='0')
--  * Order is : Segout(1)=Seg_A, ... Segout(7)=Seg_G
--
--  * Display Layout :
--
--       A=Seg(1)
--      -----
--    F|     |B=Seg(2)
--     |  G  |
--      -----
--     |     |C=Seg(3)
--    E|     |
--      -----
--        D=Seg(4)


library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- ------------------------------
    Entity SEVEN_SEG is
-- ------------------------------
  port ( Data   : in  std_logic_vector(3 downto 0); -- Expected within 0 .. 9
         Pol    : in  std_logic;                    -- '0' if active LOW
         Segout : out std_logic_vector(1 to 7) );   -- Segments A, B, C, D, E, F, G
end entity SEVEN_SEG;

-- -----------------------------------------------
Architecture COMB of SEVEN_SEG is
-- ------------------------------------------------
	signal seg: std_logic_vector(1 to 7);
begin
  process(Data, Pol)
  begin
    case Data is
      when x"0" => seg <= "1111110";
      when x"1" => seg <= "0110000";
      when x"2" => seg <= "1101101";
      when x"3" => seg <= "1111001";
      when x"4" => seg <= "0110011";
      when x"5" => seg <= "1011011";
      when x"6" => seg <= "1011111";
      when x"7" => seg <= "1110000";
      when x"8" => seg <= "1111111";
      when x"9" => seg <= "1111011";
      when x"a" => seg <= "1111101";
      when x"b" => seg <= "0011111";
      when x"c" => seg <= "1001110";
      when x"d" => seg <= "0111101";
      when x"e" => seg <= "1001111";
      when x"f" => seg <= "1000111";
      when others => seg <= "0000000";
    end case;
	 if Pol = '1' then
		Segout <= seg;
	 else
		Segout <= not seg;
    end if;
  end process;
end architecture COMB;

