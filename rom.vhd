LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY rom IS
	PORT(
		address : IN  std_logic_vector(7 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY rom;

ARCHITECTURE rom_arch OF rom IS
	TYPE rom_type IS ARRAY(0 TO 255) OF std_logic_vector(31 DOWNTO 0);
	SIGNAL rom : rom_type ;
begin
	dataout <= rom(to_integer(unsigned(address)));
END rom_arch;

