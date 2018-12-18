library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY PlA is 
	port (  
        nextAdd: in std_logic_vector (5 downto 0);
	    status : in std_logic_vector (4 downto 0);
		marin : in std_logic_vector(15 downto 0);
		marout: out std_logic_vector(15 downto 0);
		plaEn,ORsrcind,ORdstind: in std_logic );
end Entity PlA;

architecture pla_arch1 of PlA is 
    signal oldoffset: std_logic_vector(5 downto 0);
    signal instruction :std_logic_vector(31 downto 0);
    signal IR: std_logic_vector(15 downto 0); -- to be removed later
    signal adModeSrc,adModeDst: std_logic_vector(7 downto 0);
	signal twoOp,oneOp : boolean;
begin
    IRdecoder_c: entity work.IRdecoder port map(IR,instruction,adModeSrc,adModeDst,'1');
    twoOp <= not(instruction(8 downto 0) = '0'&x"00");
    oneOp <= not(instruction(19 downto 9) = "000"&x"00");
    oldoffset <= marin(5 downto 0);
	process
	Variable count : integer :=0;
	begin
		if (plaEn='1') then 
            if (twoOp or oneOp) then
                if(twoOp) then
                    if ((oldoffset = "000000") or (oldoffset = "001001")) then
                        if (adModeDst(0)='1') then  
                            marout(5 downto 0)<= "001010";   --- dircet
                        elsif ((adModeDst(1)or adModeDst(5))='1') then  
                            marout(5 downto 0)<= "001011"; ----- auto inc
                        elsif ((adModeDst(2) or adModeDst(6))='1') then  
                            marout(5 downto 0)<= "001101"; ---- auto dec
                        elsif ((adModeDst(3)or adModeDst(7))='1') then  
                            marout(5 downto 0)<= "001111";---- indexed
                        elsif (adModeDst(4)='1') then  
                            marout(5 downto 0)<= "001110";---- indirect 
                        end if;
                    end if;
				end if;
---------------------------------------------------------------------------------------------------
				if ((oldoffset = "001010" )or(oldoffset = "010011") ) then
					if not((instruction(19 downto 1)=("000"&x"0000"))) then  
						count:=0;
                        for i in 1 to 19 loop
                            if(instruction(i)='1') then
                                marout(5 downto 0)<=std_logic_vector(to_unsigned(count+20,6));
                                exit; -- break loop
                            end if;
							count:=count+1;
						end loop;
					elsif(instruction(0)='1') then
						if(adModeDst(0)='1') then
							marout(5 downto 0)<=std_logic_vector(to_unsigned(40,6));
						else 
							marout(5 downto 0)<=std_logic_vector(to_unsigned(41,6));
						end if;
					end if;
				end if;
				if (to_integer(unsigned(oldoffset)) >=20 and to_integer(unsigned(oldoffset)) <=39) then
					if(adModeDst(0)='1') then
						marout(5 downto 0)<=std_logic_vector(to_unsigned(40,6));
					else 
						marout(5 downto 0)<=std_logic_vector(to_unsigned(41,6));
					end if;
				end if;
			end if;
		end if;
    end process;
----------------------------
-- oring process
	process
	begin
        if (ORsrcind='1') then 
            marout(5 downto 0) <= marin(5 downto 0) or "0000"& not (adModeSrc(5) or adModeSrc(6) or adModeSrc(7));
        elsif (ORdstind='1') then
            marout(5 downto 0) <= marin(5 downto 0) or "0000"& not (adModeDst(5) or adModeDst(6) or adModeDst(7));
		end if;
	end process;
end pla_arch1;