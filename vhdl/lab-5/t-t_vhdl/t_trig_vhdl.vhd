LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY t_trig_vhdl IS
PORT (
	t : IN std_logic;
	q  : OUT std_logic;
	qi : OUT std_logic
);
END t_trig_vhdl;

ARCHITECTURE behav OF t_trig_vhdl IS
SIGNAL q_s, q_out:std_logic := 'X';
BEGIN
	PROCESS(t)
	BEGIN
			IF (t = '1') THEN
				q_s <= NOT q_s;
			ELSE
				q_s <= q_s;
			END IF;
    END PROCESS;
q <= q_s;
qi <= NOT q_s;
END behav;
