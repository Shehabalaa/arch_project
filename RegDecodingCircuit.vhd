library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DecodingCircuit is
    Port ( OutA : in STD_LOGIC;
	   OutB : in STD_LOGIC;
           InC : in  STD_LOGIC;
	   decSel   : in  STD_LOGIC_VECTOR (2 downto 0);  
           --decOut   : out STD_LOGIC_VECTOR (15 downto 0);
           Output : out STD_LOGIC_VECTOR (17 downto 0);  
           decEn    : in  STD_LOGIC);                     
end DecodingCircuit;

architecture Behavioral of DecodingCircuit is
Signal decOut : STD_LOGIC_VECTOR (7 downto 0);
begin
process (decSel, decEn)
begin
    decOut <= "00000000";        -- default output value
    if (decEn = '1') then  -- active high enable pin
        case decSel is
            when "000" =>  decOut(0) <= '1';
            when "001" =>  decOut(1) <= '1';
            when "010" =>  decOut(2) <= '1';
            when "011" =>  decOut(3) <= '1';
	    when "100" =>  decOut(4) <= '1';
	    when "101" =>  decOut(5) <= '1';
	    when "110" =>  decOut(6) <= '1';
	    when "111" =>  decOut(7) <= '1';
            when others =>  decOut <= "00000000";
        end case;
    end if;
end process;
------------------------------------------
Output(0)<=decOut(0) and OutA;
Output(1)<=decOut(0) and OutB;
Output(2)<=decOut(0) and InC;
------------------------------------------
Output(3)<=decOut(1) and OutA;
Output(4)<=decOut(1) and OutB;
Output(5)<=decOut(1) and InC;
-----------------------------------------
Output(6)<=decOut(2) and OutA;
Output(7)<=decOut(2) and OutB;
Output(8)<=decOut(2) and InC;
------------------------------------------
Output(9)<=decOut(3) and OutA;
Output(10)<=decOut(3) and OutB;
Output(11)<=decOut(3) and InC;
------------------------------------------
Output(12)<=decOut(4) and OutA;
Output(13)<=decOut(4) and OutB;
Output(14)<=decOut(4) and InC;
------------------------------------------
Output(15)<=decOut(5) and OutA;
Output(16)<=decOut(5) and OutB;
Output(17)<=decOut(5) and InC;
end Behavioral;
