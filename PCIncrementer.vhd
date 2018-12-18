LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PCIncrementer IS
	PORT (
		PCInput : IN  std_logic_vector (15 downto 0);
		PCoutput : out  std_logic_vector (15 downto 0);
		En: In std_logic
);
END PCIncrementer;

ARCHITECTURE DataFlow OF PCIncrementer IS
signal firstOp : std_logic_vector(15 downto 0);
signal secondOp : std_logic_vector(15 downto 0);
signal cout: std_logic;
component nadder is 
        Generic (n:integer :=8);
  port (a,b :in std_logic_vector(n-1 downto 0);
       cin :in std_logic;
       s:out std_logic_vector (n-1 downto 0);
       cout :out std_logic);
end component ;
Begin
process(En)
begin
 if rising_edge(En) then 

secondOp<="0000000000000001";
else 
secondOp<="0000000000000000";
end if;
end process;
firstOp<=PCInput;
n: nadder GENERIC MAP (16) port map (firstOp ,secondOp,'0',PCOutput,cout);
END DataFlow;
