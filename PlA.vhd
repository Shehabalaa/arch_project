library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY PlA is 
	port ( 
	nextAddress : in std_logic_vector(5 downto 0);
    instruction :in std_logic_vector(31 downto 0);
	microARin : in std_logic_vector(5 downto 0);
    microARout: out std_logic_vector(5 downto 0);
	status : in std_logic_vector (4 downto 0);
    adModeSrc,adModeDst,Orvector:in std_logic_vector(7 downto 0);
	plaEn:in std_logic;
	initMicroAr:in std_logic;
	clk: in std_logic
	);
end Entity PlA;

architecture pla_arch1 of PlA is 
	signal oldoffset: std_logic_vector(5 downto 0);
	signal twoOp,oneOp : boolean;
	signal ORdst,ORsrcind,ORdstind,ORresult,OROperation,Branchcheck,Nooperation,end_signal: std_logic;
begin
    twoOp <= not(instruction(8 downto 0) = '0'&x"00");
    oneOp <= not(instruction(19 downto 9) = "000"&x"00");
    oldoffset <= microARin;
    ORdst <= Orvector(0); ORsrcind <= Orvector(1); ORdstind <= Orvector(2); ORresult <= Orvector(3); 
    OROperation <= Orvector(4); Branchcheck <= Orvector(5); Nooperation <= Orvector(6); end_signal<= Orvector(7);  
	process(oldoffset,plaEn,twoOp,oneOp,nextAddress,adModeSrc,adModeDst,initMicroAr)
	Variable count : integer :=0;
	begin
		if(rising_edge(initMicroAr)) then
			microARout<= "101100";
		elsif (plaEn='1'and initMicroAr='1') then 
            if (twoOp or oneOp) then
				if(twoOp) then
                    if ((oldoffset = "000000") or (oldoffset = "001001")) then
                        if (adModeDst(0)='1') then  
                            microARout<= "001010";   --- dircet
                        elsif ((adModeDst(1)or adModeDst(5))='1') then  
                            microARout<= "001011"; ----- auto inc
                        elsif ((adModeDst(2) or adModeDst(6))='1') then  
                            microARout<= "001101"; ---- auto dec
                        elsif ((adModeDst(3)or adModeDst(7))='1') then  
                            microARout<= "001111";---- indexed
                        elsif (adModeDst(4)='1') then  
                            microARout<= "001110";---- indirect 
						end if;
					elsif (oldoffset="101110")  then 
						if (adModeDst(0)='1') then  
                            microARout<= "000000";   --- dircet
                        elsif ((adModeDst(1)or adModeDst(5))='1') then  
                            microARout<= "000001"; ----- auto inc
                        elsif ((adModeDst(2) or adModeDst(6))='1') then  
                            microARout<= "000011"; ---- auto dec
                        elsif ((adModeDst(3)or adModeDst(7))='1') then  
                            microARout<= "000101";---- indexed
                        elsif (adModeDst(4)='1') then  
                            microARout<= "000100";---- indirect 
						end if;
                    end if;
				elsif(oneOp) then
					if (oldoffset="101110")  then 
						 if (adModeDst(0)='1') then  
                            microARout<= "001010";   --- dircet
                        elsif ((adModeDst(1)or adModeDst(5))='1') then  
                            microARout<= "001011"; ----- auto inc
                        elsif ((adModeDst(2) or adModeDst(6))='1') then  
                            microARout<= "001101"; ---- auto dec
                        elsif ((adModeDst(3)or adModeDst(7))='1') then  
                            microARout<= "001111";---- indexed
                        elsif (adModeDst(4)='1') then  
                            microARout<= "001110";---- indirect 
						end if;

                    end if;
				end if;

---------------------------------------------------------------------------------------------------
				if ((oldoffset = "001010" )or(oldoffset = "010011") ) then
					if not((instruction(19 downto 1)=("000"&x"0000"))) then  
						count:=0;
                        for i in 1 to 19 loop
                            if(instruction(i)='1') then
                                microARout<=std_logic_vector(to_unsigned(count+20,6));
                                exit; -- break loop
                            end if;
							count:=count+1;
						end loop;
					elsif(instruction(0)='1') then
						if(adModeDst(0)='1') then
							microARout<=std_logic_vector(to_unsigned(40,6));
						else 
							microARout<=std_logic_vector(to_unsigned(41,6));
						end if;
					end if;
				end if;
				if (to_integer(unsigned(oldoffset)) >=20 and to_integer(unsigned(oldoffset)) <=38) then
					if(adModeDst(0)='1') then
						microARout<=std_logic_vector(to_unsigned(39,6));
					else 
						microARout<=std_logic_vector(to_unsigned(40,6));
					end if;
				end if;
			end if;
		elsif(initMicroAr='1') then
			if (ORsrcind='1') then 
				microARout <= nextAddress or "00000"& not (adModeSrc(5) or adModeSrc(6) or adModeSrc(7));
			elsif (ORdstind='1') then
				microARout <= nextAddress or "00000"& not (adModeDst(5) or adModeDst(6) or adModeDst(7));
			elsif (plaEn='0' and initMicroAr ='1') then
				microARout <= nextAddress;
			end if;
		end if;
	end process;

end pla_arch1;