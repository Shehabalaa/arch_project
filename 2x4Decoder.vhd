library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder2x4 is
    Port ( A  : in  STD_LOGIC_VECTOR (1 downto 0);  -- 2-bit input
           X  : out STD_LOGIC_VECTOR (3 downto 0);  -- 4-bit output
           EN : in  STD_LOGIC);                     -- enable input
end decoder2x4;

architecture Behavioral of decoder2x4 is
begin
process (A, EN)
begin
    X <= "0000";        -- default output value
    if (EN = '1') then  -- active high enable pin
        case A is
            when "00" => X(0) <= '1';
            when "01" => X(1) <= '1';
            when "10" => X(2) <= '1';
            when "11" => X(3) <= '1';
            when others => X <= "0000";
        end case;
    end if;
end process;
end Behavioral;
