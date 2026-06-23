library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCD_2_decoder is
    Port (
        EN    : in  STD_LOGIC;
        BCD   : in  STD_LOGIC_VECTOR(7 downto 0);
        Value : out STD_LOGIC_VECTOR(7 downto 0);
        Seg   : out STD_LOGIC_VECTOR(7 downto 0); -- High 4-bits: Tens, Low 4-bits: Units
        Err : out STD_LOGIC
    );
end BCD_2_decoder;

architecture Behavioral of BCD_2_decoder is
begin
    process(EN, BCD)
        variable tens_val  : integer range 0 to 15;
        variable units_val : integer range 0 to 15;
        variable bin_val   : integer range 0 to 255;
    begin
        tens_val  := to_integer(unsigned(BCD(7 downto 4)));
        units_val := to_integer(unsigned(BCD(3 downto 0)));
        
        if tens_val > 9 or units_val > 9 then
            Err <= '1';
        else
            Err <= '0';
        end if;
        
        bin_val   := (tens_val * 10) + units_val;
        
        if EN = '0' then
            Value <= (others => '0');
            Seg   <= (others => '0');
        else
            Value <= std_logic_vector(to_unsigned(bin_val, 8));
            Seg   <= BCD; -- Since BCD input is already two 4-bit numbers (tens & units)!
        end if;
    end process;
end Behavioral;
