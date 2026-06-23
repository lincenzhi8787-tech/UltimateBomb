LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity reg is
   port (
        D: in std_logic_vector(7 downto 0);
        Q: out std_logic_vector(7 downto 0);
        en: in std_logic;
        clk: in std_logic
    );
end reg;

architecture reg_behaviour of reg is
    signal reg_internal : std_logic_vector(7 downto 0) := "00000000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                reg_internal <= D; -- 只有在 en 為 1 時才存入新資料
            -- 這裡隱含了 else reg_internal <= reg_internal; 的保持邏輯
            end if;
        end if;
    end process;
    Q <= reg_internal;
end reg_behaviour;