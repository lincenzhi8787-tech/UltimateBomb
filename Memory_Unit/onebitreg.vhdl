library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity onereg is
    Port ( 
        clk : in  STD_LOGIC; 
        rst : in  STD_LOGIC; 
        en  : in  STD_LOGIC; 
        d   : in  STD_LOGIC; 
        q   : out STD_LOGIC);
end onereg;

architecture Behavioral of onereg is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            q <= '0';
        elsif rising_edge(clk) then
            if en = '1' then
                q <= d;
            end if;
        end if;
    end process;
end Behavioral;
