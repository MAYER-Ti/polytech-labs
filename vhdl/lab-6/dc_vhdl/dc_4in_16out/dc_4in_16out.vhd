library IEEE;
use IEEE.std_logic_1164.all;
entity dc_4in_16out is
port ( 
  en : IN std_logic;
  a  : IN std_logic_vector (3 downto 0);
  q  : OUT std_logic_vector (15 downto 0)
);
end dc_4in_16out ;
architecture behav of dc_4in_16out is
begin
  process (a, en)
  begin
    if (en = '1') then
      case a is
       when "0000"  => q <= "0000000000000001";
       when "0001"  => q <= "0000000000000010";
       when "0010"  => q <= "0000000000000100";
       when "0011"  => q <= "0000000000001000";
       when "0100"  => q <= "0000000000010000";
       when "0101"  => q <= "0000000000100000";
       when "0110"  => q <= "0000000001000000";
       when "0111"  => q <= "0000000010000000";
	   when "1000"  => q <= "0000000100000000";
       when "1001"  => q <= "0000001000000000";
       when "1010"  => q <= "0000010000000000";
       when "1011"  => q <= "0000100000000000";
       when "1100"  => q <= "0001000000000000";
       when "1101"  => q <= "0010000000000000";
       when "1110"  => q <= "0100000000000000";
       when "1111"  => q <= "1000000000000000";
       when others  => q <= "0000000000000000";
    end case;
	else 
      q <= "0000000000000000";
	end if;
  end process;
end behav;
