LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux_vhdl IS

	PORT
	(
		x	: IN	STD_LOGIC_VECTOR (3 downto 0);
		a	: IN	STD_LOGIC_VECTOR (1 downto 0);
		EN	: IN	STD_LOGIC;
		res	: OUT	STD_LOGIC
	);
	
END mux_vhdl;

ARCHITECTURE behav OF mux_vhdl IS
	
BEGIN

	PROCESS (EN, x, a)
	BEGIN
	
		IF EN = '1' THEN
		
			CASE a IS
			
				WHEN "00" => res <= x(0);
				WHEN "01" => res <= x(1);
				WHEN "10" => res <= x(2);
				WHEN "11" => res <= x(3);
				WHEN OTHERS => res <= '0';
				
			END CASE;
			
		ELSE
		
			res <= '0';
			
		END IF;
		
	END PROCESS;
	
END behav;
