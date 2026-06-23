library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity State_Display_16seg is
    Port (
        State_In      : in  STD_LOGIC_VECTOR(2 downto 0);
        Invalid_Input : in  STD_LOGIC;
        Disp_1        : out STD_LOGIC_VECTOR(15 downto 0);
        Disp_2        : out STD_LOGIC_VECTOR(15 downto 0);
        Disp_3        : out STD_LOGIC_VECTOR(15 downto 0);
        Disp_4        : out STD_LOGIC_VECTOR(15 downto 0);
        Disp_5        : out STD_LOGIC_VECTOR(15 downto 0)
    );
end State_Display_16seg;

architecture Behavioral of State_Display_16seg is
    -- 16-Segment Bit Mapping (Based on typical Digital simulator layout)
    -- Bit 0: a1 (top left)
    -- Bit 1: a2 (top right)
    -- Bit 2: b  (top right vertical)
    -- Bit 3: c  (bottom right vertical)
    -- Bit 4: d2 (bottom right)
    -- Bit 5: d1 (bottom left)
    -- Bit 6: e  (bottom left vertical)
    -- Bit 7: f  (top left vertical)
    -- Bit 8: g1 (middle left horizontal)
    -- Bit 9: g2 (middle right horizontal)
    -- Bit 10: h (top left diagonal)
    -- Bit 11: i (top middle vertical)
    -- Bit 12: j (top right diagonal)
    -- Bit 13: k (bottom right diagonal)
    -- Bit 14: l (bottom middle vertical)
    -- Bit 15: m (bottom left diagonal)
    
    constant BLANK : std_logic_vector(15 downto 0) := x"0000";
    constant CHAR_E: std_logic_vector(15 downto 0) := x"03F3"; -- a1,a2, d1,d2, e,f, g1,g2 -> 0,1, 4,5, 6,7, 8,9
    constant CHAR_R: std_logic_vector(15 downto 0) := x"23C7"; -- a1,a2, b, e,f, g1,g2, k -> 0,1, 2, 6,7, 8,9, 13
    constant CHAR_O: std_logic_vector(15 downto 0) := x"00FF"; -- a1,a2, b,c, d1,d2, e,f -> 0,1, 2,3, 4,5, 6,7
    constant CHAR_L: std_logic_vector(15 downto 0) := x"00F0"; -- d1,d2, e,f -> 4,5, 6,7
    constant CHAR_S: std_logic_vector(15 downto 0) := x"03BB"; -- a1,a2, c, d1,d2, f, g1,g2 -> 0,1, 3, 4,5, 7, 8,9
    constant CHAR_W: std_logic_vector(15 downto 0) := x"A0FC"; -- b,c, d1,d2, e,f, m,k -> 2,3, 4,5, 6,7, 13,15
    constant CHAR_I: std_logic_vector(15 downto 0) := x"4800"; -- i, l -> 11, 14
    constant CHAR_N: std_logic_vector(15 downto 0) := x"24CC"; -- b,c, e,f, h,k -> 2,3, 6,7, 10,13
    constant CHAR_P: std_logic_vector(15 downto 0) := x"03C7"; -- a1,a2, b, e,f, g1,g2 -> 0,1, 2, 6,7, 8,9
    constant CHAR_U: std_logic_vector(15 downto 0) := x"00FC"; -- b,c, d1,d2, e,f -> 2,3, 4,5, 6,7
    constant CHAR_T: std_logic_vector(15 downto 0) := x"4803"; -- a1,a2, i, l -> 0,1, 11, 14
    constant CHAR_D: std_logic_vector(15 downto 0) := x"483F"; -- a1,a2, b,c, d1,d2, i,l -> 0,1, 2,3, 4,5, 11,14
    constant CHAR_X: std_logic_vector(15 downto 0) := x"B400"; -- h, j, k, m -> 10, 12, 13, 15

begin
    process(State_In, Invalid_Input)
    begin
        if Invalid_Input = '1' then
            -- ERROR
            Disp_1 <= CHAR_E;
            Disp_2 <= CHAR_R;
            Disp_3 <= CHAR_R;
            Disp_4 <= CHAR_O;
            Disp_5 <= CHAR_R;
        else
            case State_In is
                when "000" => -- idle (IDLE )
                    Disp_1 <= CHAR_I;
                    Disp_2 <= CHAR_D;
                    Disp_3 <= CHAR_L;
                    Disp_4 <= CHAR_E;
                    Disp_5 <= BLANK;
                    
                when "001" => -- next_bomb (NEXT )
                    Disp_1 <= CHAR_N;
                    Disp_2 <= CHAR_E;
                    Disp_3 <= CHAR_X;
                    Disp_4 <= CHAR_T;
                    Disp_5 <= BLANK;
                    
                when "010" => -- game / check_pass (INPUT)
                    Disp_1 <= CHAR_I;
                    Disp_2 <= CHAR_N;
                    Disp_3 <= CHAR_P;
                    Disp_4 <= CHAR_U;
                    Disp_5 <= CHAR_T;
                    
                when "011" => -- game_win ( WIN )
                    Disp_1 <= BLANK;
                    Disp_2 <= CHAR_W;
                    Disp_3 <= CHAR_I;
                    Disp_4 <= CHAR_N;
                    Disp_5 <= BLANK;
                    
                when "100" => -- game_lose (LOSE )
                    Disp_1 <= CHAR_L;
                    Disp_2 <= CHAR_O;
                    Disp_3 <= CHAR_S;
                    Disp_4 <= CHAR_E;
                    Disp_5 <= BLANK;
                    
                when others =>
                    Disp_1 <= BLANK;
                    Disp_2 <= BLANK;
                    Disp_3 <= BLANK;
                    Disp_4 <= BLANK;
                    Disp_5 <= BLANK;
            end case;
        end if;
    end process;
end Behavioral;
