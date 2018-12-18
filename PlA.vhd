library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY PlA is 
	port (  
        nextAdd: in std_logic_vector (5 downto 0);
	    instruction :in std_logic_vector(31 downto 0);
	    status : in std_logic_vector (4 downto 0);
		marin : in std_logic_vector(15 downto 0);
		marout:out std_logic_vector(15 downto 0);
		adModeSrc,admodeDst: in std_logic_vector(7 downto 0);
		plaEn: in std_logic );
end Entity PlA ;


architecture pla_arch1 of PlA is 
	signal oldoffset: std_logic_vector(5 downto 0);
	signal twoOp : boolean;
begin
	twoOp<= not(instruction(7 downto 0) = x"00") ;
	oldoffset <= marin(5 downto 0);
	process
	Variable count : integer :=0;
	begin
		if (plaEn='1') then 
			if (twoOp) then 
				if ((oldoffset = "000000") or (oldoffset = "001001")) then
					if (admodeDst(0)='1') then  
						marout(5 downto 0)<= "001010";   --- dircet
				         elsif ((admodeDst(1)or admodeDst(5))='1') then  
						marout(5 downto 0)<= "001011"; ----- auto inc
					 elsif ((admodeDst(2) or admodeDst(6))='1') then  
						marout(5 downto 0)<= "001101"; ---- auto dec
					 elsif ((admodeDst(3)or admodeDst(7))='1') then  
						marout(5 downto 0)<= "001111";---- indexed
					 elsif (admodeDst(4)='1') then  
						marout(5 downto 0)<= "001110";---- indirect 
					end if;
				end if;

---------------------------------------------------------------------------------------------------
				if ((oldoffset = "001010" )or(oldoffset = "010011") ) then
					if not((instruction(18 downto 1)=("00"&x"0000"))) then  
						count:=0;
						for i in 0 to 18 loop
							marout(5 downto 0)<=std_logic_vector(to_unsigned(count+20,6));
							count:=count+1;
						end loop;
					elsif(instruction(0)='1') then
						if(admodeDst(0)='1') then
							marout(5 downto 0)<=std_logic_vector(to_unsigned(40,6));
						else 
							marout(5 downto 0)<=std_logic_vector(to_unsigned(41,6));
						end if;
					end if;
				end if;

				if (to_integer(unsigned(oldoffset)) >=20 and to_integer(unsigned(oldoffset)) <=39) then
					if(admodeDst(0)='1') then
						marout(5 downto 0)<=std_logic_vector(to_unsigned(40,6));
					else 
						marout(5 downto 0)<=std_logic_vector(to_unsigned(41,6));
					end if;
				end if;
			end if;
			
		end if;
	end process;

	

end pla_arch1;