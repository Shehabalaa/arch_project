library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------
--ir , el decoder enables ,flag enable ,el read -> mux,  wmfc ,mfc
---------------------------------------------------------
Entity system is
port (  SelectOutA : in std_logic_vector (3 downto 0);
	SelectOutB : in std_logic_vector (3 downto 0);
	SelectInCRnTemp : in std_logic_vector (3 downto 0);
	SelectDistMARMDRFlag : in std_logic_vector (1 downto 0);
	SelectReadWrite : in std_logic_vector (1 downto 0);
	DecoderEnSrcA: in std_logic;
    DecoderEnSrcB: in std_logic;
	DecoderEnRnTemp: in std_logic;
	DecoderEnMARMDRFlag: in std_logic;
	DecoderEnReadWrite: in std_logic;
	DecodingCircuitEn: in std_logic;
	clk,rst,clkram: in std_logic;
	muxselect:in std_logic;
	busA,busB,busC : inout std_logic_vector (15 downto 0);
	aluSel :in std_logic_vector (4 downto 0));
end system;
------------------------------------------------------------
Architecture myRegisterFile of system is--------------------
-----------------------------------------------------------

Signal RnTempInDecoder: std_logic_vector (15 downto 0); -->(0)Rn src  (8) temp1   (9) temp2 (10) IR (11) no operation
Signal MARMdrFlagINDecoder: std_logic_vector (3 downto 0); -->  (0) Mar (1) mdr (2) flag (3) no operation
Signal ReadWriteDecoder: std_logic_vector (3 downto 0);  --->  (0) read(muxselect) (1) write (2) no operatin  
signal parityBit: std_logic;  
----------------------------------------------------------
signal OutA : std_logic_vector(15 downto 0); 
signal OutB : std_logic_vector(15 downto 0);  -- reg
signal InC : std_logic_vector(15 downto 0); 

Signal DecodingCircuitSrcOutput : std_logic_vector (17 downto 0);
Signal DecodingCircuitDstOutput : std_logic_vector (17 downto 0);
---------------------------------------------------------------
signal R0outAEn : std_logic;
signal R0outBEn : std_logic;
signal R0InCEn : std_logic;
-----------
signal R1outAEn : std_logic;
signal R1outBEn : std_logic;
signal R1InCEn : std_logic;
-----------
signal R2outAEn : std_logic;
signal R2outBEn : std_logic;
signal R2InCEn : std_logic;
-----------
signal R3outAEn : std_logic;
signal R3outBEn : std_logic;
signal R3IncEn : std_logic;
-----------
signal R4outAEn : std_logic;
signal R4outBEn : std_logic;
signal R4IncEn : std_logic;
-----------
signal R5outAEn : std_logic;
signal R5outBEn : std_logic;
signal R5IncEn : std_logic;
signal PCEn:std_logic;
----------------------------------------------------------------
signal outReg0TriIn :std_logic_vector(15 downto 0);
signal outReg1TriIn :std_logic_vector(15 downto 0);
signal outReg2TriIn :std_logic_vector(15 downto 0);
signal outReg3TriIn :std_logic_vector(15 downto 0);
signal outReg4TriIn :std_logic_vector(15 downto 0);
signal outReg5TriIn :std_logic_vector(15 downto 0);
signal outRegPcTriIn : std_logic_vector(15 downto 0);
signal PCIncOut : std_logic_vector(15 downto 0);
signal outRegSpTriIn : std_logic_vector(15 downto 0);
signal outRegTemp1TriIn : std_logic_vector(15 downto 0);
signal outRegTemp2TriIn : std_logic_vector(15 downto 0);
signal outRegMDRTriIn : std_logic_vector(15 downto 0);
signal outRegFlagTriIn : std_logic_vector(15 downto 0);
signal outRegIRTriIn : std_logic_vector(15 downto 0);
--------------------------------------------------------
signal address : std_logic_vector(15 downto 0);
signal ramout:std_logic_vector(15 downto 0); --ram
signal muxout:std_logic_vector(15 downto 0);
signal muxout2:std_logic_vector(15 downto 0);---> l pc incrementer  
signal flags :std_logic_vector(15 downto 0); 
----------------------------------------------------------------
signal addressFieldOfIR : std_logic_vector(15 downto 0);
-----------------------------------------------------------------
Begin-------------------------------------------------------------
------------------------------------------------------------------
DecodingCircuitSrc : entity work.DecodingCircuit port map(outA(0),OutB(0),InC(0),outRegIRTriIn(8 downto 6),DecodingCircuitSrcOutput,DecodingCircuitEn);
DecodingCircuitDst : entity work.DecodingCircuit port map(outA(1),OutB(1),InC(1),outRegIRTriIn(2 downto 0),DecodingCircuitDstOutput,DecodingCircuitEn);
DecSrcA : entity work.Decoder4x16 port map (decSel=>SelectOutA,decOut=>OutA,decEn=>DecoderEnSrcA);
DecSrcB : entity work.Decoder4x16 port map (decSel=>SelectOutB,decOut=>OutB,decEn=>DecoderEnSrcB); --decoders
DecDistRTemp : entity work.Decoder4x16 port map (decSel=>SelectInCRnTemp,decOut=>InC,decEn=>DecoderEnRnTemp);
DecDistMARMDRFlagin : entity work.Decoder2x4 port map (SelectDistMARMDRFlag ,MARMdrFlagINDecoder,DecoderEnMARMDRFlag);
DecReadWrite: entity work.Decoder2x4 port map (SelectReadWrite,ReadWriteDecoder,DecoderEnReadWrite);
PCIncrementer : entity work.PCIncrementer port map (outRegPcTriIn,PCIncOut,InC(7));
--------------------------------------------------------------------------------------------
R0outAEn<=DecodingCircuitSrcOutput(0) or DecodingCircuitDstOutput(0);
R0outBEn<=DecodingCircuitSrcOutput(1) or DecodingCircuitDstOutput(1);
R0InCEn<=DecodingCircuitSrcOutput(2) or DecodingCircuitDstOutput(2);
----
R1outAEn<=DecodingCircuitSrcOutput(3) or DecodingCircuitDstOutput(3);
R1outBEn<=DecodingCircuitSrcOutput(4) or DecodingCircuitDstOutput(4);
R1InCEn<=DecodingCircuitSrcOutput(5) or DecodingCircuitDstOutput(5);
----
R2outAEn<=DecodingCircuitSrcOutput(6) or DecodingCircuitDstOutput(6);
R2outBEn<=DecodingCircuitSrcOutput(7) or DecodingCircuitDstOutput(7);
R2InCEn<=DecodingCircuitSrcOutput(8) or DecodingCircuitDstOutput(8);
----
R3outAEn<=DecodingCircuitSrcOutput(9) or DecodingCircuitDstOutput(9);
R3outBEn<=DecodingCircuitSrcOutput(10) or DecodingCircuitDstOutput(10);
R3InCEn<=DecodingCircuitSrcOutput(11) or DecodingCircuitDstOutput(11);
----
R4outAEn<=DecodingCircuitSrcOutput(12) or DecodingCircuitDstOutput(12);
R4outBEn<=DecodingCircuitSrcOutput(13) or DecodingCircuitDstOutput(13);
R4InCEn<=DecodingCircuitSrcOutput(14) or DecodingCircuitDstOutput(14);
----
R5outAEn<=DecodingCircuitSrcOutput(15) or DecodingCircuitDstOutput(15);
R5outBEn<=DecodingCircuitSrcOutput(16) or DecodingCircuitDstOutput(16);
R5InCEn<=DecodingCircuitSrcOutput(17) or DecodingCircuitDstOutput(17);
--------------------------------------------------------------------------------
Reg0:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg0TriIn,R0InCEn);
tri0A: entity work.tri_state_buffer port map (outReg0TriIn,R0outAEn,busA );
tri0B: entity work.tri_state_buffer port map (outReg0TriIn,R0outBEn,busB );
---
Reg1:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg1TriIn,R1InCEn);
tri1A: entity work.tri_state_buffer port map (outReg1TriIn,R1outAEn,busA );
tri1B: entity work.tri_state_buffer port map (outReg1TriIn,R1outBEn,busB );
--
Reg2:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg2TriIn,R2InCEn);
tri2A: entity work.tri_state_buffer port map (outReg2TriIn,R2outAEn,busA );
tri2B: entity work.tri_state_buffer port map (outReg2TriIn,R2outBEn,busB );
--
Reg3:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg3TriIn,R3InCEn); -- reg
tri3A: entity work.tri_state_buffer port map (outReg3TriIn,R3outAEn,busA );
tri3B: entity work.tri_state_buffer port map (outReg3TriIn,R3outBEn,busB );
--
Reg4:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg4TriIn,R4InCEn);
tri4A: entity work.tri_state_buffer port map (outReg4TriIn,R4outAEn,busA );
tri4B: entity work.tri_state_buffer port map (outReg4TriIn,R4outBEn,busB );
--
Reg5:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg5TriIn,R5InCEn);
tri5A: entity work.tri_state_buffer port map (outReg5TriIn,R5outAEn,busA );
tri5B: entity work.tri_state_buffer port map (outReg5TriIn,R5outAEn,busB );
-------------------------------------------------------------------------------------------------------------------
PCEn<=InC(2) or InC(7);
Reg6pc:entity work.my_nDFF  generic map (16) port map ( clk , rst ,muxout2, outRegPcTriIn,PCEn);
mux2 :entity work.mux2x1 port map(InC(7),PCIncOut,busC,muxout2);
tri6A: entity work.tri_state_buffer port map (outRegPcTriIn,OutA(2),busA );
--
Reg7sp:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegSpTriIn,InC(3));
tri7A: entity work.tri_state_buffer port map (outRegSpTriIn,OutA(3),busA );
tri7B: entity work.tri_state_buffer port map (outRegSpTriIn,OutB(2),busB );
-----------------------------------------------------------------------------------------------------------------
mar:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, address,MARMdrFlagINDecoder(0));
----
mdr:entity work.my_nDFF  generic map (16) port map ( clk , rst ,muxout, outRegMDRTriIn,MARMdrFlagINDecoder(1));    --ram components
tri9A: entity work.tri_state_buffer port map (outRegMDRTriIn,OutA(4),busA );
tri9B: entity work.tri_state_buffer port map (outRegMDRTriIn,OutB(3),busB );
----
mux:entity work.mux2x1 port map(ReadWriteDecoder(0),ramout,busC,muxout);
ram: entity work.ram port map (clkram, ReadWriteDecoder(1),address(10 downto 0),outRegMDRTriIn,ramout);
------------------------------------------------------------------------------------------------------------------.
Regtemp1:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegTemp1TriIn,InC(4));
tri10A: entity work.tri_state_buffer port map (outRegTemp1TriIn,OutA(5),busA );
tri10B: entity work.tri_state_buffer port map (outRegTemp1TriIn,OutB(4),busB );
--
Regtemp2:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegTemp2TriIn,InC(5));
tri11A: entity work.tri_state_buffer port map (outRegTemp2TriIn,OutA(6),busA );
tri11B: entity work.tri_state_buffer port map (outRegTemp2TriIn,OutB(5),busB );
--
RegIR: entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegIRTriIn,InC(6)); -- temp ,flag ,ir
addressFieldOfIR<="00000"&outRegIRTriIn(10 downto 0);
tri12B: entity work.tri_state_buffer port map (addressFieldOfIR,OutB(6),busB );
--
Regflag:entity work.my_nDFF  generic map (16) port map ( clk , rst ,flags, outRegFlagTriIn,MARMdrFlagINDecoder(2));
tri13A: entity work.tri_state_buffer port map (outRegFlagTriIn,OutA(7),busA);
tri13B: entity work.tri_state_buffer port map (outRegFlagTriIn,OutB(7),busB);
--------------------------------------------------------------------------------------------------------------------
alu : entity work.ALU port map (F => busC,A=>busA,B=>busB,Cin=>outRegFlagTriIn(0), cout=>flags(0),AluSelect=>aluSel); --alu
flags(1) <='1' when busC =x"0000" else '0';
flags(2) <='1' when busC(15) ='1' else '0';
parityBit <= not busC(0);
flags(3)<= parityBit;
flags(15 downto 5) <="00000000000";
---------------------------------------------------------------------------------------------------------------

end Architecture;



