library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- для to_unsigned
entity dc_6in_64out is
port ( 
  en : IN std_logic;
  a  : IN std_logic_vector (5 downto 0);
  q  : OUT std_logic_vector (63 downto 0)
);
end dc_6in_64out;

architecture behav of dc_6in_64out is

  component dc_3in_8out
    port (
   	  en : IN std_logic;
      a  : IN std_logic_vector (2 downto 0);
	  q  : OUT std_logic_vector (7 downto 0) 
    );
  end component;

  signal enable_s : std_logic_vector (7 downto 0);
  signal q_s	  : std_logic_vector (63 downto 0);

begin

  -- командующий дешифратор (обработка старших трех битов)
  gen_top_enable: for i in 0 to 7 generate
    enable_s(i) <= '1' when ( en = '1' and a(5 downto 3) = std_logic_vector(to_unsigned(i, 3)) ) else '0';
  end generate;

  -- остальные 8 dc
  gen_top_decoders: for i in 0 to 7 generate
    dec_top_inst : dc_3in_8out
      port map (
		a => a(2 downto 0),
		en => enable_s(i),
		q => q_s(i*8+7 downto i*8)
	  );
  end generate;
  
  q <= q_s when en = '1' else (others => '0');

end behav;
