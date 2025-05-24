LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY r4_counter IS
PORT (
	jk  : IN std_logic;
	clk : IN std_logic;
	r   : IN std_logic;

	q0 : OUT std_logic;
	q1 : OUT std_logic;
	q2 : OUT std_logic;
	q3 : OUT std_logic
);
END r4_counter;

ARCHITECTURE behav OF r4_counter IS
SIGNAL q0_s, q1_s, q2_s, q3_s:std_logic := '0';
BEGIN
	PROCESS(jk, r, clk)
	BEGIN
		
		IF (r = '0') THEN
			q0_s <= '0';
			q1_s <= '0';
			q2_s <= '0';
			q3_s <= '0';
		ELSIF (clk'event AND clk = '1') THEN
			IF (jk = '1') THEN
				IF (q0_s = '1') THEN
					IF(q1_s = '1') THEN
						IF (q2_s = '1') THEN
							IF(q3_s = '1') THEN
								q3_s <= '0';
								q2_s <= '0';
								q1_s <= '0';
								q0_s <= '0';
							ELSE
								q3_s <= '1';
								q2_s <= '0';
								q1_s <= '0';
								q0_s <= '0';
							END IF; -- q3
						ELSE
							q2_s <= '1';
							q1_s <= '0';
							q0_s <= '0';
						END IF; -- q2
					ELSE
						q1_s <= '1';
						q0_s <= '0';
					END IF; -- q1
				ELSE
					q0_s <= '1';
				END IF; -- q0
			END IF; -- jk
		END IF; -- clk

    END PROCESS;

q0 <= q0_s;
q1 <= q1_s;
q2 <= q2_s;
q3 <= q3_s;

END behav;
