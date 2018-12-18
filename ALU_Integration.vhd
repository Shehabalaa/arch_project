
library ieee;
use ieee.std_logic_1164.all;
entity ALU is 
	port (A,B : in std_logic_vector(15 downto 0);
		CIN: in std_logic;
		F: out std_logic_vector(15 downto 0);
		COUT : out std_logic;
		S : in std_logic_vector(3 downto 0));
end entity ALU ;

architecture arch1 of ALU is 
        component partA is
		Port(	A,B	:in	std_logic_vector(15 downto 0);
	Cin,S0,S1 :in  std_logic;
	F:	out	std_logic_vector(15 downto 0) ;
	 cout :out std_logic);
	end component;

	component partB is
		port (A,B : in std_logic_vector(15 downto 0);
	SEL : in std_logic_vector(1 downto 0);
	F : out std_logic_vector(15 downto 0));
	end component ; 

        component partC is
                 port(
	A : in std_logic_vector(15 downto 0);
	Cin : in std_logic;
	SEL: in std_logic_vector(1 downto 0);
	F : out std_logic_vector(15 downto 0);
	Cout : out std_logic
     );
	end component ;

	component partD is
 		port(
	A: in std_logic_vector(15 downto 0);
	CIN: in std_logic;
	SEL: in std_logic_vector(1 downto 0);
	F: out std_logic_vector(15 downto 0);
	COUT: out std_logic
    );

	end component ;
        
        signal x1,x2,x3,x4: std_logic_vector(15 downto 0);
        signal c1,c2,c3 :std_logic ;
begin 
	u0: partB PORT MAP (A,B,S(1 downto 0),x1);

	u1: partC PORT MAP (A,CIN,S(1 downto 0),x2,c1);

	u2: partD PORT MAP (A,CIN,S(1 downto 0),x3,c2);
        
        u3: partA PORT MAP (A,B,CIN,s(0),s(1),x4,c3);

	F <= x1 when (S(3)='0' and S(2)='1')
	else x2 when (S(3)='1' and S(2)='0')
	else x3 when (S(3)='1' and S(2)='1')
        else x4 when (S(3)='0' and S(2)='0');


	Cout <= '0' when (S(3)='0' and S(2)='1')
	else c1 when (S(3)='1' and S(2)='0')
	else c2 when (S(3)='1' and S(2)='1')
	else c3 when (S(3)='0' and S(2)='0') ;
  
end arch1 ;