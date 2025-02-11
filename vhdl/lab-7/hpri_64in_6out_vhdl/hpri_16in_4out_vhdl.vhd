library ieee;
use ieee.std_logic_1164.all;

entity hpri_16in_4out_vhdl is
    port (
        r  : in std_logic_vector(15 downto 0);
        ei : in std_logic;
        a  : out std_logic_vector(3 downto 0);
        eo : out std_logic;
		g  : out std_logic
    );
end entity;

architecture behav of hpri_16in_4out_vhdl is
    component hpri_8in_3out_vhdl
        port (
            r  : in std_logic_vector(7 downto 0);
            ei : in std_logic;
            a  : out std_logic_vector(2 downto 0);
            eo : out std_logic;
			g  : out std_logic
        );
    end component;

    signal aFirst_s, aSecond_s : std_logic_vector(2 downto 0);
    signal eoFirst_s, eoSecond_s, gFirst_s, gSecond_s : std_logic;
begin
    hpri_first: hpri_8in_3out_vhdl
        port map (
            r => r(7 downto 0),
            ei => ei,
            a => aFirst_s,
            eo => eoFirst_s,
			g => gFirst_s
        );

    hpri_second: hpri_8in_3out_vhdl
        port map (
            r => r(15 downto 8),
            ei => eoFirst_s,
            a => aSecond_s,
            eo => eoSecond_s,
			g => gSecond_s
        );

    process(aFirst_s, aSecond_s, eoSecond_s, gFirst_s, gSecond_s)
    begin
        if eoSecond_s = '0' then
            a(3) <= '1';
            a(2 downto 0) <= aSecond_s;
			g <= gSecond_s;
        else
            a(3) <= '0';
            a(2 downto 0) <= aFirst_s;
			g <= gFirst_s;
        end if;
        eo <= eoSecond_s;
    end process;
end behav;
