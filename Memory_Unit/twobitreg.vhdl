library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity twobitreg is
    Port ( 
        clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        en  : in  STD_LOGIC;
        d   : in  STD_LOGIC_VECTOR(1 downto 0);
        q   : out STD_LOGIC_VECTOR(1 downto 0));
end twobitreg;

architecture Behavioral of twobitreg is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            q <= "00";
        elsif rising_edge(clk) then
            if en = '1' then
                q <= d;
            end if;
        end if;
    end process;
end Behavioral;
