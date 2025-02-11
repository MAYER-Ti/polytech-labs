LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY memory_r_vhdl IS
PORT (
	x1 	   : IN  std_logic;
	x2     : IN  std_logic;
	x3     : IN  std_logic;
	x4     : IN  std_logic;
	write  : IN  std_logic;
	reset  : IN  std_logic;
	read   : IN  std_logic;
	Q1     : OUT std_logic;
	Q2     : OUT std_logic;
	Q3     : OUT std_logic;
	Q4     : OUT std_logic
);
END memory_r_vhdl ;
ARCHITECTURE behav OF memory_r_vhdl IS
	SIGNAL Q1S, Q2S, Q3S, Q4S : std_logic := '0';
BEGIN

	PROCESS (write, reset) 
	BEGIN
		IF (reset = '0') THEN
			Q1S <= '0';
			Q2S <= '0';
			Q3S <= '0';
			Q4S <= '0';
		ELSIF (write'event and write = '1') THEN
			Q1S <= x1;
			Q2S <= x2;
			Q3S <= x3;
			Q4S <= x4;
		END IF;
	END PROCESS;
	PROCESS (read, reset)
	BEGIN
		IF (read = '1') THEN
			Q1 <= Q1S;
			Q2 <= Q2S;
			Q3 <= Q3S;
			Q4 <= Q4S;
		ELSE
			Q1 <= '0';
			Q2 <= '0';
			Q3 <= '0';
			Q4 <= '0';

		END IF;
	END PROCESS;

END behav;
