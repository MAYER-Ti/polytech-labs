LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux_64in_1out IS

	PORT
	(
		x	: IN	STD_LOGIC_VECTOR (63 downto 0);
		a	: IN	STD_LOGIC_VECTOR (5 downto 0);
		EN	: IN	STD_LOGIC;
		res : OUT   STD_LOGIC
	);
	
END mux_64in_1out;

ARCHITECTURE behav OF mux_64in_1out IS

    COMPONENT mux_vhdl
        port (
 		x	: IN	STD_LOGIC_VECTOR (3 downto 0);
		a	: IN	STD_LOGIC_VECTOR (1 downto 0);
		EN	: IN	STD_LOGIC;
		res	: OUT	STD_LOGIC
        );
    end component;

    SIGNAL out16mux_s : STD_LOGIC_VECTOR(15 downto 0);
    SIGNAL out4mux_s : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL outLastMux_s : STD_LOGIC;

BEGIN

	initFirst16Mux: FOR i IN 0 TO 15 GENERATE
		firstMuxes : mux_vhdl
			port map (
				x(0) => x(i * 4),
				x(1) => x(i * 4 + 1),
				x(2) => x(i * 4 + 2),
				x(3) => x(i * 4 + 3),
				a => a(1 downto 0),
				EN => EN,
				res => out16mux_s(i)
			);
	END GENERATE;
	
	initSecond4Mux : FOR i in 0 TO 3 GENERATE
		secondMuxes: mux_vhdl
			port map (
				x(0) => out16mux_s(i * 4),
				x(1) => out16mux_s(i * 4 + 1),
				x(2) => out16mux_s(i * 4 + 2),
				x(3) => out16mux_s(i * 4 + 3),
				a => a(3 downto 2),
				EN => EN,
				res => out4mux_s(i)
			);
	END GENERATE;
	
	muxLast : mux_vhdl
		port map (
			x => out4mux_s,
			a => a(5 downto 4),
			EN => EN,
			res => outLastMux_s
		);
		
	res <= outLastMux_s;
	
END behav;
