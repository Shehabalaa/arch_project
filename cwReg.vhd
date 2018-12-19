LIBRARY IEEE;
USE IEEE.std_Logic_1164.all;

entity cwReg is
generic(n: integer:= 32);
port( 
	clk,rst: in std_logic;
	input:in std_logic_vector(n-1 downto 0);
	output: out std_logic_vector(n-1 downto 0);
	en: in std_logic
);
end entity cwReg;

architecture a of cwReg is
begin
	-- output <= (others=>'0') when rst='1'
	-- else input when en='1' and rising_edge(clk);
	PROCESS( rst,input)
		BEGIN
			IF(rst = '1')  THEN output <= "01011100010001000111011011000000";
			ELSIF (en = '1' )  THEN output <= input;
			END IF;
	END PROCESS;

end architecture;

