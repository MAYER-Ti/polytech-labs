LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY dmx_vhdl IS

	PORT
	(
		x	: IN	STD_LOGIC_VECTOR(1 downto 0);
		e	: IN	STD_LOGIC;
		f	: OUT	STD_LOGIC_VECTOR(3 downto 0)
	);
	
END dmx_vhdl;

ARCHITECTURE behav OF dmx_vhdl IS
	
BEGIN

	PROCESS (x,e)
	BEGIN
	
	    f <= (others => '0');
	
		CASE x IS
			
			WHEN "00" => f(0) <= e;
			WHEN "01" => f(1) <= e;
			WHEN "10" => f(2) <= e;
			WHEN "11" => f(3) <= e;
			WHEN OTHERS => f <= (others => '0');
				
		END CASE; 
		
	END PROCESS;
	
END behav;
