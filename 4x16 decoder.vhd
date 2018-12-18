library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder4x16 is
    Port ( decSel  : in  STD_LOGIC_VECTOR (3 downto 0);  
           decOut  : out STD_LOGIC_VECTOR (15 downto 0);  
           decEn : in  STD_LOGIC);                     
end Decoder4x16;

architecture Behavioral of Decoder4x16 is
begin
process (decSel, decEn)
begin
    decOut <= "0000000000000000";        -- default output value
    if (decEn = '1') then  -- active high enable pin
        case decSel is
            when "0000" =>  decOut(0) <= '1';
            when "0001" =>  decOut(1) <= '1';
            when "0010" =>  decOut(2) <= '1';
            when "0011" =>  decOut(3) <= '1';
	    when "0100" =>  decOut(4) <= '1';
	    when "0101" =>  decOut(5) <= '1';
	    when "0110" =>  decOut(6) <= '1';
	    when "0111" =>  decOut(7) <= '1';
	    when "1000" =>  decOut(8) <= '1';
            when "1001" =>  decOut(9) <= '1';
            when "1010" =>  decOut(10) <= '1';
            when "1011" =>  decOut(11) <= '1';
            when "1100" =>  decOut(12) <= '1';
            when "1101" =>  decOut(13) <= '1';
            when "1110" =>  decOut(14) <= '1';
            when "1111" =>  decOut(15) <= '1';
            when others =>  decOut <= "0000000000000000";
        end case;
    end if;
end process;
end Behavioral;
