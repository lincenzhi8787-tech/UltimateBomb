library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mode_Selector is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        btn_mode : in  STD_LOGIC;
        Mode_Out : out STD_LOGIC_VECTOR(1 downto 0)
    );
end Mode_Selector;

architecture Behavioral of Mode_Selector is
    signal mode_reg : unsigned(1 downto 0) := "00";
    signal btn_prev : std_logic := '0';
begin

    process(clk, rst)
    begin
        if rst = '1' then
            mode_reg <= "00";
            btn_prev <= '0';
        elsif rising_edge(clk) then
            -- 按鍵上升緣偵測 (避免按住時連續瘋狂跳動)
            if btn_mode = '1' and btn_prev = '0' then
                mode_reg <= mode_reg + 1;
            end if;
            btn_prev <= btn_mode;
        end if;
    end process;

    Mode_Out <= std_logic_vector(mode_reg);

end Behavioral;
