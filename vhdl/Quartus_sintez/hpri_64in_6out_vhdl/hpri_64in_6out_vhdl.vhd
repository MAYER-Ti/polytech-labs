library ieee;
use ieee.std_logic_1164.all;

entity hpri_64in_6out_vhdl is
    port (
        r  : in std_logic_vector(63 downto 0);
        ei : in std_logic;
        a  : out std_logic_vector(5 downto 0);
        eo : out std_logic;
		g  : out std_logic
    );
end entity;

architecture behav of hpri_64in_6out_vhdl is
    component hpri_32in_5out_vhdl
        port (
            r  : in std_logic_vector(31 downto 0);
            ei : in std_logic;
            a  : out std_logic_vector(4 downto 0);
            eo : out std_logic;
			g  : out std_logic
        );
    end component;

    signal aFirst_s, aSecond_s : std_logic_vector(4 downto 0);
    signal eoFirst_s, eoSecond_s, gFirst_s, gSecond_s : std_logic;
begin
    hpri_first: hpri_32in_5out_vhdl
        port map (
            r => r(31 downto 0),
            ei => ei,
            a => aFirst_s,
            eo => eoFirst_s,
			g => gFirst_s
        );

    hpri_second: hpri_32in_5out_vhdl
        port map (
            r => r(63 downto 32),
            ei => eoFirst_s,
            a => aSecond_s,
            eo => eoSecond_s,
			g => gSecond_s
        );

    process(aFirst_s, aSecond_s, eoSecond_s, gFirst_s, gSecond_s)
    begin
        if eoSecond_s = '0' then
            a(5) <= '1';
            a(4 downto 0) <= aSecond_s;
			g <= gSecond_s;
			eo <= not gSecond_s;
        else
            a(5) <= '0';
            a(4 downto 0) <= aFirst_s;
			g <= gFirst_s;
			eo <= not gFirst_s;
        end if;
   --     eo <= eoSecond_s;
    end process;
end behav;
