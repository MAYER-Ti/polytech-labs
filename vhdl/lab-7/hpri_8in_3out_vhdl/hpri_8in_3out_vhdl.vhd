library ieee;
use ieee.std_logic_1164.all;
entity hpri_8in_3out_vhdl is
port (
  ei : in std_logic;
  r  : in std_logic_vector (7 downto 0);
  a  : out std_logic_vector (2 downto 0);
  g  : out std_logic;
  eo : out std_logic
);
end hpri_8in_3out_vhdl;
architecture behav of hpri_8in_3out_vhdl is
begin
  process(r, ei)
  begin
      --  r <= "000";
      -- eo <= '1';
       -- G <= '0';

        if ei = '1' then
            if r /= "00000000" then
                eo <= '0'; 
                g <= '1'; 

                if r(7) = '1' then
                    a <= "111";
                elsif r(6) = '1' then
                    a <= "110";
                elsif r(5) = '1' then
                    a <= "101";
                elsif r(4) = '1' then
                    a <= "100";
                elsif r(3) = '1' then
                    a <= "011";
                elsif r(2) = '1' then
                    a <= "010";
                elsif r(1) = '1' then
                    a <= "001";
                elsif r(0) = '1' then
                    a <= "000";
                end if;
			else 
				a <= (others => '0');
            	eo <= '1';
				g  <= '0';
            end if;
        else 
   		    a <= (others => '0');
            eo <= '1';
			g  <= '0';
        end if;
  end process;
end behav;
