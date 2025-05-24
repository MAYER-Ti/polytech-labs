LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY jk_rstrig_vhdl IS
PORT (
	s : IN std_logic;
	j : IN std_logic;
	
	r : IN std_logic;
	k : IN std_logic;

	q  : OUT std_logic;
	qi : OUT std_logic
);
END jk_rstrig_vhdl;

ARCHITECTURE behav OF jk_rstrig_vhdl IS
SIGNAL q_s:std_logic := 'X';
BEGIN
	PROCESS(s, r)
	BEGIN
			IF(r = '0') THEN
				q_s <= '0';
			ELSIF(s = '0') THEN
				q_s <= '1';
			ELSIF(j = '1' AND k = '1') THEN
				q_s <= NOT q_s;
			ELSIF(j = '0' AND k = '1') THEN
				q_s <= '0';
			ELSIF(j = '1' AND k = '0') THEN
				q_s <= '1';		
			ELSE
				q_s <= q_s;
			END IF;
    END PROCESS;
	q <= q_s;
	qi <= NOT q_s;
END behav;
