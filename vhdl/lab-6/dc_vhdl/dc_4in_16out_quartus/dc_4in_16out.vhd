library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity dc_4in_16out is
port ( 
  en : IN std_logic;
  a  : IN std_logic_vector (3 downto 0);
  q  : OUT std_logic_vector (15 downto 0)
);
end dc_4in_16out ;
architecture behav of dc_4in_16out is
  signal shiftedQ : std_logic_vector (15 downto 0) := "0000000000000001";
begin
  process (en, a, shiftedQ)
  begin
    if (en = '1') THEN
      q <=  std_logic_vector(unsigned(shiftedQ) sll to_integer(unsigned(a))); 
    else
      q <= "0000000000000000";
    end if;
  end process;
end behav;
