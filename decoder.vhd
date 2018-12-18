library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
	generic (s:integer :=2);
	port(
        sel_dec: in std_logic_vector(s-1 downto 0);
        out_dec: out std_logic_vector(2**s-1 downto 0);
        en_dec: in std_logic
	);
end decoder;

architecture decoder_arch of decoder is
begin
	process(sel_dec,en_dec)
	begin
		out_dec <= (others => '0');
		if en_dec ='1' then 
			out_dec(to_integer(unsigned(sel_dec))) <= '1';
		end if;
		
	end process;
end decoder_arch;