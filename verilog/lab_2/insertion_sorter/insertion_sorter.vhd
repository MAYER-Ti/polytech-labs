library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity insertion_sorter is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        start    : in  STD_LOGIC;
        data_in0 : in  STD_LOGIC_VECTOR(7 downto 0);
        data_in1 : in  STD_LOGIC_VECTOR(7 downto 0);
        data_in2 : in  STD_LOGIC_VECTOR(7 downto 0);
        data_in3 : in  STD_LOGIC_VECTOR(7 downto 0);
        done_out : out STD_LOGIC;
        data_out0: out STD_LOGIC_VECTOR(7 downto 0);
        data_out1: out STD_LOGIC_VECTOR(7 downto 0);
        data_out2: out STD_LOGIC_VECTOR(7 downto 0);
        data_out3: out STD_LOGIC_VECTOR(7 downto 0)
    );
end insertion_sorter;

architecture Behavioral of insertion_sorter is
    type state_type is (IDLE, LOAD, SORT_OUTER, SORT_INNER, DONE);
    signal current_state : state_type := IDLE;
    
    type data_array is array (0 to 3) of STD_LOGIC_VECTOR(7 downto 0);
    signal data_reg : data_array;
    signal key      : STD_LOGIC_VECTOR(7 downto 0);
    
    signal i, j : unsigned(1 downto 0) := "00";
begin

process(clk, reset)
begin
    if reset = '1' then
        current_state <= IDLE;
        done_out <= '0';
        data_reg <= (others => (others => '0'));
        data_out0 <= (others => '0');
        data_out1 <= (others => '0');
        data_out2 <= (others => '0');
        data_out3 <= (others => '0');
        i <= "00";
        j <= "00";
        key <= (others => '0');
    elsif rising_edge(clk) then
        case current_state is
            when IDLE =>
                if start = '1' then
                    current_state <= LOAD;
                    done_out <= '0';
                end if;
                
            when LOAD =>
                data_reg(0) <= data_in0;
                data_reg(1) <= data_in1;
                data_reg(2) <= data_in2;
                data_reg(3) <= data_in3;
                i <= "01"; -- ???????? ? 1-?? ????????
                current_state <= SORT_OUTER;
                
            when SORT_OUTER =>
                if i /= "11" then -- ???????????? i=0,1,2
                    key <= data_reg(to_integer(i));
                    j <= i - 1;
                    current_state <= SORT_INNER;
                else -- ?????? ?????? ??? ?????????? ???????? (i=3)
                    key <= data_reg(3);
                    j <= "10"; -- j = 2
                    current_state <= SORT_INNER;
                end if;
                
            when SORT_INNER =>
                if j /= "11" and data_reg(to_integer(j)) > key then
                    data_reg(to_integer(j + 1)) <= data_reg(to_integer(j));
                    j <= j - 1;
                else
                    data_reg(to_integer(j + 1)) <= key;
                    if i = "11" then -- ???? ??? ???? ????????? ????????
                        current_state <= DONE;
                    else
                        i <= i + 1;
                        current_state <= SORT_OUTER;
                    end if;
                end if;
                
            when DONE =>
                data_out0 <= data_reg(0);
                data_out1 <= data_reg(1);
                data_out2 <= data_reg(2);
                data_out3 <= data_reg(3);
                done_out <= '1';
                current_state <= IDLE;
                
            when others =>
                current_state <= IDLE;
        end case;
    end if;
end process;

end Behavioral;