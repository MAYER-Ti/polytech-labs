LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY r2_t1_shift_vhdl IS
PORT (
	d 	 : IN  std_logic;
	c 	 : IN  std_logic;
	reload 	 : IN  std_logic;
	Q1   : OUT std_logic;
	Q2   : OUT std_logic


);
END r2_t1_shift_vhdl ;
ARCHITECTURE behav OF r2_t1_shift_vhdl IS
	SIGNAL Q1S, Q2S : std_logic := '0';
BEGIN
	-- Первый dff
	PROCESS (c, reload) 
	BEGIN
		IF (reload = '0') THEN
			Q1S <= '0';
		ELSIF (c'event and c = '1') THEN
			Q1S <= d;
		END IF;
	END PROCESS;

	-- Второй dff
	PROCESS (c, reload) 
	BEGIN
		IF (reload = '0') THEN
			Q2S <= '0';
		ELSIF (c'event and c = '1') THEN
			Q2 <= Q1S;

		END IF;
	END PROCESS;

	Q1 <= Q1S;

END behav;

