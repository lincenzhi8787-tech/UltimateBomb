library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity random is
    Port ( 
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        btn_start  : in  STD_LOGIC;
        rand_out   : out STD_LOGIC_VECTOR(7 downto 0));
end random;

architecture Behavioral of random is
    signal fast_counter : unsigned(7 downto 0) := "00000000";
    signal latched_val  : unsigned(7 downto 0) := "00000000";
begin

    process(clk, rst)
    begin
        if rst = '1' then
            fast_counter <= "00000000";
        elsif rising_edge(clk) then
            if fast_counter = 99 then
                fast_counter <= "00000000";
            else
                fast_counter <= fast_counter + 1;
            end if;
        end if;
    end process;

    process(clk, rst)
    begin
        if rst = '1' then
            latched_val <= "00000000";
        elsif rising_edge(clk) then
            if btn_start = '1' then
                latched_val <= fast_counter;
            end if;
        end if;
    end process;
    rand_out <= std_logic_vector(latched_val);

end Behavioral;
