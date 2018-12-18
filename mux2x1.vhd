library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2x1 is
    Port ( muxSel :in  STD_LOGIC;
           a   :in  STD_LOGIC_VECTOR (15 downto 0);
           b   :in  STD_LOGIC_VECTOR (15 downto 0);
           muxOut :out STD_LOGIC_VECTOR (15 downto 0));
end mux2x1;

architecture Behavioral of mux2x1 is
begin
    muxOut <= a when (muxSel = '1') else b;
end architecture;
