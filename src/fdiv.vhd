-- FDIV.vhd
-- ---------------------------------------
--   Frequency Divider
-- ---------------------------------------

-- Baudrates:
--
-- 9600   = 104us
-- 19200  = 52us
-- 56000  = 18us
-- 115200 = 9us


LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

-- ---------------------------------------
Entity FDIV is
   -- ---------------------------------------
    Generic (  Fclock : positive := 50E6); -- System Clock Freq in Hertz
    Port (     CLK : in  std_logic;
               RST : in  std_logic;
               ticks: out std_logic_vector(3 downto 0));
end FDIV;

    -- ---------------------------------------
Architecture RTL of FDIV is
-- ---------------------------------------

    constant Divisor_us : positive := Fclock  / 1E6;
    signal Count1       : integer range 0 to Divisor_us;
    signal Count9       : integer range 0 to 8;
    signal Count18      : integer range 0 to 1;
    signal Count52      : integer range 0 to 51;
    signal Count104     : integer range 0 to 1;
    signal Tick1us_i     : std_logic;
    signal Tick9us_i     : std_logic;
    signal Tick18us_i   : std_logic;
    signal Tick52us_i   : std_logic;
    signal Tick104us_i  : std_logic;

-- -------------------------------------

begin

    ticks(0) <= Tick9us_i;
    ticks(1) <= Tick18us_i;
    ticks(2) <= Tick52us_i;
    ticks(3) <= Tick104us_i;

    process (RST,CLK)
    begin
        if RST='1' then
            Count1      <= 0;
            Count9      <= 0;
            Count18     <= 0;
            Count52     <= 0;
            Count104    <= 0;
            Tick1us_i   <= '0';
            Tick9us_i   <= '0';
            Tick18us_i  <= '0';
            Tick52us_i  <= '0';
            Tick104us_i <= '0';

        elsif rising_edge (CLK) then
            Tick1us_i <= '0';
            Tick9us_i <= '0';
            Tick18us_i <= '0';
            Tick52us_i <= '0';
            Tick104us_i <= '0';

            if Count1 < Divisor_us-1 then
                Count1 <= Count1 + 1;
            else
                Count1 <= 0;
                Tick1us_i <= '1';
            end if;

            if Tick1us_i='1' then
                if Count9 < 8 then
                    Count9 <= Count9 + 1;
                else
                    Count9 <= 0;
                    Tick9us_i <= '1';
                end if;

                if Count52 < 51 then
                    Count52 <= Count52 + 1;
                else
                    Count52 <= 0;
                    Tick52us_i <= '1';
                end if;
            end if;

            if Tick9us_i = '1' then
                if Count18 = 0 then
                    Count18 <= 1;
                else
                    Count18 <= 0;
                    Tick18us_i <= '1';
                end if;
            end if;

            if Tick52us_i = '1' then
                if Count104 = 0 then
                    Count104 <= 1;
                else
                    Count104 <= 0;
                    Tick104us_i <= '1';
                end if;
            end if;
        end if;
    end process;
end RTL;

