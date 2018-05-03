LIBRARY ieee;
USE ieee.std_logic_1164.all; 


ENTITY DE2_top IS 
	PORT
	(
		CLOCK_50 :  IN  STD_LOGIC;
		KEY :  IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		SW :  IN  STD_LOGIC_VECTOR(17 DOWNTO 0);
    LEDG: OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
    LEDR: out  STD_LOGIC_VECTOR(17 DOWNTO 0);
    UART_RXD: IN STD_LOGIC;
    UART_TXD: OUT STD_LOGIC;
    GPIO_0: inout STD_LOGIC_VECTOR(35 DOWNTO 0);
    HEX0: out STD_LOGIC_VECTOR(0 to 6);
    HEX1: out STD_LOGIC_VECTOR(0 to 6);
    HEX2: out STD_LOGIC_VECTOR(0 to 6);
    HEX3: out STD_LOGIC_VECTOR(0 to 6);
    HEX4: out STD_LOGIC_VECTOR(0 to 6);
    HEX5: out STD_LOGIC_VECTOR(0 to 6));
END entity;

ARCHITECTURE struct OF DE2_top IS 

SIGNAL	rst :  STD_LOGIC;
SIGNAL	go :  STD_LOGIC;
SIGNAL	pol :  STD_LOGIC;
SIGNAL  state: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL  echo: std_logic;
SIGNAL  trigg: std_logic;
SIGNAL  data: std_logic_vector(15 downto 0);
SIGNAL  drec: std_logic_vector(7 downto 0);
signal  ticks: std_logic_vector(3 downto 0);

BEGIN 

  LOW: entity work.SEVEN_SEG(COMB) port map (Data => data(3 downto 0), Pol => pol, Segout => HEX0);
  MIDL: entity work.SEVEN_SEG(COMB) port map (Data => data(7 downto 4), Pol => pol, Segout => HEX1);
  MIDH: entity work.SEVEN_SEG(COMB) port map (Data => data(11 downto 8), Pol => pol, Segout => HEX2);
  HIGH: entity work.SEVEN_SEG(COMB) port map (Data => data(15 downto 12), Pol => pol, Segout => HEX3);

RECL: entity work.SEVEN_SEG(COMB) port map (Data => drec(3 downto 0), Pol => pol, Segout => HEX4);
RECH: entity work.SEVEN_SEG(COMB) port map (Data => drec(7 downto 4), Pol => pol, Segout => HEX5);

  FDIV: entity work.FDIV
        port map (CLK   => CLOCK_50,
                  RST   => rst,
                  ticks => ticks);

  Ultra: entity work.Ultrasound
         port map(clk     => CLOCK_50,
                  rst     => rst,
                  go      => go,
                  mic     => ticks(0),
                  echo    => GPIO_0(9),
                  s       => state,
                  trigger => trigg,
                  e_o     => LEDG(1),
                  d       => data);

  EMIT: entity work.UART_Emission
        port map (clk     => CLOCK_50,
            rst     => rst,
            go      => go,
            din     => data(7 downto 0),
            SEL     => SW(10 downto 9),
            Tx      => UART_TXD,
            Tx_Busy => LEDR(17));

  REC: entity work.UART_Reception
       port map (clk     => CLOCK_50,
            rst     => rst,
            Rx      => UART_RXD,
            SEL     => SW(10 downto 9),
            Dout    => drec,
            Dav     => LEDR(15),
            Rx_err  => LEDR(16));

  go <= not(KEY(1));
  rst <= not(KEY(0));
  pol <= SW(17);
  trigg <= GPIO_0(8);
  LEDG(7 downto 4) <= state;
  LEDG(0) <= go;

END architecture;
