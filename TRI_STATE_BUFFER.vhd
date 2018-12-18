library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tri_state_buffer is
    Port ( 
           triIn  : in  STD_LOGIC_VECTOR (15 downto 0);
           triEn  : in  STD_LOGIC;
           triOut : out STD_LOGIC_VECTOR (15 downto 0));
end tri_state_buffer;

architecture Behavioral of tri_state_buffer is
begin
    triOut <= triIn when (triEn = '1') else (others => 'Z');
end Behavioral;