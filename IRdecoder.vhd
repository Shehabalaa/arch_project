library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IRdecoder is 
    port(
        IR_in :in std_logic_vector(15 downto 0);
        instruction :out std_logic_vector(31 downto 0);
        IRdec_en:in std_logic
        );
end IRdecoder;


architecture IRdecoder_arch of IRdecoder is
    signal two_operands : std_logic_vector(15 downto 0);
    signal one_operand : std_logic_vector(15 downto 0);
    signal no_operand : std_logic_vector(1 downto 0);
    signal bransh : std_logic_vector(7 downto 0);
    signal branch_en : std_logic;
    signal bonus : std_logic_vector(3 downto 0);
begin
    two_opr_dec_c: entity work.decoder generic map(4) port map (IR_in(15 downto 12),two_operands,IRdec_en);
    one_opr_dec_c: entity work.decoder generic map(4) port map (IR_in(9 downto 6),one_operand,two_operands(9));
    no_opr_dec_c: entity work.decoder generic map(1) port map (IR_in(9 downto 9),no_operand,two_operands(10));
    branch_en <=   two_operands(12) or two_operands(13) or two_operands(14)or two_operands(15); 
    bransh_opr_dec_c: entity work.decoder generic map(3) port map (IR_in(13 downto 11),bransh,branch_en);
    bonus_dec_c: entity work.decoder generic map(2) port map (IR_in(7 downto 6),bonus,two_operands(11));
    instruction <= bonus(3) & bonus(1 downto 0)& bransh(6 downto 0) & no_operand & one_operand(10 downto 0)& two_operands(8 downto 0);
end IRdecoder_arch;
    