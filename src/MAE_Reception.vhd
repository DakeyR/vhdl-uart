library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity MAE_reception is
port (s_tick, clk, rst, rx: in std_logic;
      d_out: out std_logic_vector(7 downto 0);
      rx_done_tick: out std_logic);
end entity MAE_reception;

architecture MAE of MAE_reception is
    type StateType is (IDLE, START, DATA, STOP);
    signal state : StateType;
begin
    process(clk, rst)
        variable tick_cnt:  integer range 0 to 15;
        variable bit_cnt:   integer range 0 to 7;
    begin
        if rst = '1' then
            state <= IDLE;
            tick_cnt := 0;
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if rx = '0' then
                        tick_cnt := 0;
                        state <= START;
                    end if;
                when START =>
                    if s_tick = '1' then
                        if tick_cnt = 7 then
                            tick_cnt := 0;
                            bit_cnt := 0;
                            state <= DATA;
                        else
                            tick_cnt := tick_cnt + 1;
                        end if;
                    end if;
                when DATA =>
                    if s_tick = '1' then
                        if tick_cnt = 7 then
                            tick_cnt := 0;
                            d_out(bit_cnt) <= rx;
                            if bit_cnt = 7 then
                                bit_cnt := 0;
                                state <= STOP;
                            else
                                bit_cnt := bit_cnt + 1;
                            end if;
                        else
                            tick_cnt := tick_cnt + 1;
                        end if;
                    end if;
                when STOP =>
                    if s_tick = '1' then
                        if tick_cnt = 15 then
                            rx_done_tick <= '1';
                            state <= IDLE;
                        else
                            tick_cnt := tick_cnt + 1;
                        end if;
                    end if;
            end case;
        end if;
    end process;
end architecture;
