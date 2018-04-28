

LIBRARY ieee;
USE ieee.std_logic_1164.all; 


ENTITY DE2_top IS 
	PORT
	(
		CLOCK_50 :  IN  STD_LOGIC;
		KEY :  IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		SW :  IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
    UART_RXD: IN STD_LOGIC;
    UART_TXD: OUT STD_LOGIC;
    LEDG: OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
    LEDR: out  STD_LOGIC_VECTOR(17 DOWNTO 0));
END entity;

ARCHITECTURE struct OF DE2_top IS 

SIGNAL	rst :  STD_LOGIC;
SIGNAL	go :  STD_LOGIC;
SIGNAL  data: STD_LOGIC_VECTOR(7 downto 0);

BEGIN 

  --LEDR(10 downto 3) <= SW(7 downto 0);

EMIT: entity work.UART_Emission
  port map (clk     => CLOCK_50,
            rst     => rst,
            go      => go,
            din     => SW(7 downto 0),
            SEL     => SW(10 downto 9),
            Tx      => UART_TXD,
            Tx_Busy => LEDR(17));
REC: entity work.UART_Reception
  port map (clk     => CLOCK_50,
            rst     => rst,
            Rx      => UART_RXD,
            SEL     => SW(10 downto 9),
            Dout    => LEDG,
            Dav     => LEDR(15),
            Rx_err  => LEDR(16));
rst <= NOT(KEY(0));
go <= NOT(KEY(1));

END architecture;
