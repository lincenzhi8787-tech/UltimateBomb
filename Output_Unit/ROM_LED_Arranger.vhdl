library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM_LED_Arranger is
    Port (
        EN       : in  STD_LOGIC;
        Mode     : in  STD_LOGIC_VECTOR(1 downto 0);
        Progress : in  STD_LOGIC_VECTOR(3 downto 0);
        Data     : out STD_LOGIC_VECTOR(47 downto 0)  -- 48 LED, upper row then lower row
    );
end ROM_LED_Arranger;

architecture Behavioral of ROM_LED_Arranger is

    -------------------------------------------------------------------------
    -- 24‑bit ROM type – one row (左到右編號：左端為高位元，右端為低位元)
    -------------------------------------------------------------------------
    type rom24_type is array (0 to 15) of std_logic_vector(23 downto 0);

    -- Row‑wise helper constants
    constant ALL_ON_24  : std_logic_vector(23 downto 0) := x"FFFFFF";  -- 24 個 1
    constant ALL_OFF_24 : std_logic_vector(23 downto 0) := x"000000";  -- 24 個 0

    -------------------------------------------------------------------------
    -- Mode 0 : idle – both rows always off
    -------------------------------------------------------------------------
    constant MODE0_UP_ROM  : rom24_type := (others => ALL_OFF_24);
    constant MODE0_LOW_ROM : rom24_type := (others => ALL_OFF_24);

    -------------------------------------------------------------------------
    -- Mode 1 : Fin = 3 – 右側每次清除 8 顆 LED (共 3 步)
    -------------------------------------------------------------------------
    constant MODE1_UP_ROM : rom24_type := (
        0 => ALL_ON_24,   -- 111111111111111111111111
        1 => x"FFFF00",   -- 右側 8 顆熄滅
        2 => x"FF0000",   -- 右側 16 顆熄滅
        3 => ALL_OFF_24,
        others => ALL_OFF_24
    );
    constant MODE1_LOW_ROM : rom24_type := (
        0 => ALL_ON_24,
        1 => x"FFFF00",
        2 => x"FF0000",
        3 => ALL_OFF_24,
        others => ALL_OFF_24
    );

    -------------------------------------------------------------------------
    -- Mode 2 : Fin = 6 – 右側每次清除 4 顆 LED (共 6 步)
    -------------------------------------------------------------------------
    constant MODE2_UP_ROM : rom24_type := (
        0 => ALL_ON_24,
        1 => x"FFFFF0",   -- clear 4 LSB
        2 => x"FFFF00",   -- clear 8 LSB
        3 => x"FFF000",   -- clear 12 LSB
        4 => x"FF0000",   -- clear 16 LSB
        5 => x"F00000",   -- clear 20 LSB
        6 => x"000000",   -- clear 24 LSB (全部熄滅)
        others => ALL_OFF_24
    );
    constant MODE2_LOW_ROM : rom24_type := (
        0 => ALL_ON_24,
        1 => x"FFFFF0",
        2 => x"FFFF00",
        3 => x"FFF000",
        4 => x"FF0000",
        5 => x"F00000",
        6 => x"000000",
        others => ALL_OFF_24
    );

    -------------------------------------------------------------------------
    -- Mode 3 : Fin = 12 – 右側每次清除 2 顆 LED (共 12 步)
    -------------------------------------------------------------------------
    constant MODE3_UP_ROM : rom24_type := (
        0  => ALL_ON_24,   -- 111111111111111111111111
        1  => x"FFFFFC",   -- clear 2 LSB
        2  => x"FFFFF0",   -- clear 4 LSB
        3  => x"FFFFC0",   -- clear 6 LSB
        4  => x"FFFF00",   -- clear 8 LSB
        5  => x"FFFC00",   -- clear 10 LSB
        6  => x"FFF000",   -- clear 12 LSB
        7  => x"FFC000",   -- clear 14 LSB
        8  => x"FF0000",   -- clear 16 LSB
        9  => x"FC0000",   -- clear 18 LSB
        10 => x"F00000",   -- clear 20 LSB
        11 => x"C00000",   -- clear 22 LSB
        others => ALL_OFF_24
    );
    constant MODE3_LOW_ROM : rom24_type := (
        0  => ALL_ON_24,
        1  => x"FFFFFC",
        2  => x"FFFFF0",
        3  => x"FFFFC0",
        4  => x"FFFF00",
        5  => x"FFFC00",
        6  => x"FFF000",
        7  => x"FFC000",
        8  => x"FF0000",
        9  => x"FC0000",
        10 => x"F00000",
        11 => x"C00000",
        others => ALL_OFF_24
    );

begin

    process(EN, Mode, Progress)
        variable idx : integer range 0 to 15;
        variable up_row  : std_logic_vector(23 downto 0);
        variable low_row : std_logic_vector(23 downto 0);
    begin
        idx := to_integer(unsigned(Progress));
        if EN = '0' then
            Data <= (others => '0');
        else
            case Mode is
                when "00" =>
                    up_row  := MODE1_UP_ROM(idx);
                    low_row := MODE1_LOW_ROM(idx);
                when "01" =>
                    up_row  := MODE2_UP_ROM(idx);
                    low_row := MODE2_LOW_ROM(idx);
                when "10" =>
                    up_row  := MODE3_UP_ROM(idx);
                    low_row := MODE3_LOW_ROM(idx);
                when "11" =>
                    up_row  := ALL_ON_24;
                    low_row := ALL_ON_24;
                when others =>
                    up_row  := ALL_OFF_24;
                    low_row := ALL_OFF_24;
            end case;
            Data <= up_row & low_row;  -- upper row (bits 47..24) + lower row (bits 23..0)
        end if;
    end process;

end Behavioral;
