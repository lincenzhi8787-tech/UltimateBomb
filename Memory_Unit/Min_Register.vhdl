library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Min_Register is
    Port (
        clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;  -- 接 New_Bomb 或 系統 Reset
        en  : in  STD_LOGIC;  -- 接 Load_Min
        D   : in  STD_LOGIC_VECTOR(7 downto 0); -- 接玩家輸入的數字
        Q   : out STD_LOGIC_VECTOR(7 downto 0)  -- 輸出給顯示器
    );
end Min_Register;

architecture Behavioral of Min_Register is
    -- 預設為 BCD 碼的 00 (0000 0000)
    signal reg_data : STD_LOGIC_VECTOR(7 downto 0) := "00000000"; 
begin
    process(clk, rst)
    begin
        -- 當 rst=1 (收到 New_Bomb 訊號) 時，強制恢復成 00
        if rst = '1' then
            reg_data <= "00000000"; 
        elsif rising_edge(clk) then
            if en = '1' then
                if unsigned(D) > unsigned(reg_data) then
                    reg_data <= D; -- 只有輸入數字比當前範圍大時，才會更新
                end if;
            end if;
        end if;
    end process;
    
    Q <= reg_data;
end Behavioral;
