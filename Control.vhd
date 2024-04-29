LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Control IS
	port(
			clk, mclk        : IN STD_LOGIC;
			enable 			  : IN STD_LOGIC;
			statusC, statusZ : IN STD_LOGIC;
			INST 				  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			A_Mux, B_Mux     : OUT STD_LOGIC;
			IM_MUX1, REG_Mux : OUT STD_LOGIC;
			IM_MUX2, DATA_Mux: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			ALU_op 			  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			inc_PC, ld_PC    : OUT STD_LOGIC;
			clr_IR			  : OUT STD_LOGIC;
			ld_IR 			  : OUT STD_LOGIC;
			clr_A, clr_B, clr_C, clr_Z : OUT STD_LOGIC;
			ld_A, ld_B, ld_C, ld_Z     : OUT STD_LOGIC;
			T					  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			wen, en			  : OUT STD_LOGIC
	);
END Control;

ARCHITECTURE description OF Control IS 
	TYPE STATETYPE IS (state_0, state_1, state_2);
	SIGNAL present_state : STATETYPE;
	SIGNAL Instruction_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Instruction_sig2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	Instruction_sig<= INST(31 DOWNTO 28);
	Instruction_sig2<= INST(31 DOWNTO 24);
	
	--- OPERATION DECODER ---
	PROCESS (present_state, INST, statusC, statusZ, enable, Instruction_sig, Instruction_sig2)
	BEGIN
		IF enable = '1' THEN 
			IF present_state = state_0 THEN
				DATA_Mux <="00"; --Fetch Address of next instruction_sig
				clr_IR<='0';
				ld_IR<='1';
				ld_PC<='0';
				inc_PC<='0';
				clr_A<='0';
				ld_A<='0';
				ld_B<='0';
				clr_B<='0';
				clr_C<='0';
				ld_C<='0';
				clr_Z<='0';
				ld_Z<='0';
				en<='0';
				wen<='0';
				
			ELSIF present_state = state_1 THEN
				clr_IR<='0';--INCREMENT PC COUNTER
				ld_IR<='0';
				ld_PC<='1';
				inc_PC<='1';
				clr_A<='0';
				ld_A<='0';
				ld_B<='0';
				clr_B<='0';
				clr_C<='0';
				ld_C<='0';
				clr_Z<='0';
				ld_Z<='0';
				en<='0';
				wen<='0';
			
				IF Instruction_sig = "0010" THEN --STA
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='1';
					inc_PC<='1';
					clr_A<='0';
					ld_A<='0';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					REG_Mux<='0';
					DATA_Mux<="00";
					en<='1';
					wen<='1';
					
				ELSIF Instruction_sig = "0011" THEN --STB
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='1';
					inc_PC<='1';
					clr_A<='0';
					ld_A<='0';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					REG_Mux<='1';
					DATA_Mux<="00";
					en<='1';
					wen<='1';
			
				ELSIF Instruction_sig = "1001" THEN --LDA
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='1';
					inc_PC<='1';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					DATA_Mux<="01";
					en<='1';
					wen<='0';
	
				ELSIF Instruction_sig = "1010" THEN --LDB
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='1';
					inc_PC<='1';
					clr_A<='0';
					ld_A<='0';
					ld_B<='1';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					DATA_Mux<="01";
					en<='1';
					wen<='0';
				END IF; --END IF FOR LOAD STORE IN STAGE 1
			
			ELSIF present_state = state_2 THEN	
				
				IF instruction_sig = "0101" THEN --JUMP
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='1';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='0';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					
				ELSIF instruction_sig = "0110" THEN --BEQ
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='1';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='0';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					
				ELSIF instruction_sig = "1000" THEN --BNE
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='1';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='0';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					
				
				ELSIF Instruction_sig = "1001" THEN --LDA
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					REG_Mux<='0';
					DATA_Mux<="01";
					en<='1';
					wen<='0';
					
				ELSIF Instruction_sig = "1010" THEN --LDB
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='0';
					ld_B<='1';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					REG_Mux<='0';
					DATA_Mux<="01";
					en<='1';
					wen<='0';
					
				ELSIF Instruction_sig = "0010" THEN --STA
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='0';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					REG_Mux<='0';
					DATA_Mux<="00";
					en<='1';
					wen<='1';
					
				ELSIF Instruction_sig = "0011" THEN --STB
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='0';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					REG_Mux<='1';
					DATA_Mux<="00";
					en<='1';
					wen<='1';
					
				ELSIF Instruction_sig = "0000" THEN --LDAI
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					A_Mux <='1';
					
				ELSIF Instruction_sig = "0001" THEN --LDBI
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='0';
					ld_B<='1';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					B_Mux <='1';
					
				ELSIF Instruction_sig = "0100" THEN --LUI
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='1';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					ALU_op<="001";
					REG_Mux<='1';
					A_Mux<='0';
					DATA_Mux<="10";
					IM_MUX1<='1';
					
				ELSIF Instruction_sig2 = "01111001" THEN --ANDI
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='1';
					clr_C<='0';
					ld_C<='1';
					clr_Z<='0';
					ld_Z<='1';
					ALU_op<="000";
					A_Mux<='0';
					DATA_Mux<="10";
					IM_MUX1<='0';
					IM_MUX2<="01";
					
				ELSIF Instruction_sig2 = "01111110" THEN --DECA
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='1';
					clr_Z<='0';
					ld_Z<='1';
					ALU_op<="110";
					A_Mux<='0';
					DATA_Mux<="10";
					IM_MUX1<='0';
					IM_MUX2<="10";
	
				ELSIF Instruction_sig2 = "01110000" THEN --ADD
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='1';
					clr_Z<='0';
					ld_Z<='1';
					ALU_op<="010";
					A_Mux<='0';
					DATA_Mux<="10";
					IM_MUX1<='0';
					IM_MUX2<="00";
	
				ELSIF Instruction_sig2 = "01110010" THEN --SUB
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='1';
					clr_Z<='0';
					ld_Z<='1';
					ALU_op<="110";
					A_Mux<='0';
					DATA_Mux<="10";
					IM_MUX1<='0';
					IM_MUX2<="00";
					
				ELSIF Instruction_sig2 = "01110011" THEN --INCA
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='1';
					clr_Z<='0';
					ld_Z<='1';
					ALU_op<="010";
					A_Mux<='0';
					DATA_Mux<="10";
					IM_MUX1<='0';
					IM_MUX2<="10";
					
				ELSIF Instruction_sig2 = "01111011" THEN --AND
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='1';
					clr_Z<='0';
					ld_Z<='1';
					ALU_op<="000";
					A_Mux<='0';
					DATA_Mux<="10";
					IM_MUX1<='0';
					IM_MUX2<="00";
					
				ELSIF Instruction_sig2 = "01110001" THEN --ADDI
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='1';
					clr_Z<='0';
					ld_Z<='1';
					ALU_op<="010";
					A_Mux<='0';
					DATA_Mux<="10";
					IM_MUX1<='0';
					IM_MUX2<="01";
					
				ELSIF Instruction_sig2 = "01111101" THEN --ORI
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='1';
					clr_Z<='0';
					ld_Z<='1';
					ALU_op<="001";
					A_Mux<='0';
					DATA_Mux<="10";
					IM_MUX1<='0';
					IM_MUX2<="01";
					
				ELSIF Instruction_sig2 = "01110100" THEN --ROL
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='1';
					clr_Z<='0';
					ld_Z<='1';
					ALU_op<="100";
					A_Mux<='0';
					DATA_Mux<="10";
					IM_MUX1<='0';
					
				ELSIF Instruction_sig2 = "01111111" THEN --ROR
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='1';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='1';
					clr_Z<='0';
					ld_Z<='1';
					ALU_op<="101";
					A_Mux<='0';
					DATA_Mux<="10";
					IM_MUX1<='0';
					
				ELSIF Instruction_sig2 = "01110101" THEN --CLR_A
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='1';
					ld_A<='0';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					
				ELSIF Instruction_sig2 = "01110110" THEN --CLR_B
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='0';
					ld_B<='0';
					clr_B<='1';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					
				ELSIF Instruction_sig2 = "01110111" THEN --CLR_C
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='0';
					ld_B<='0';
					clr_B<='0';
					clr_C<='1';
					ld_C<='0';
					clr_Z<='0';
					ld_Z<='0';
					
				ELSIF Instruction_sig2 = "01111000" THEN --CLR_Z
					clr_IR<='0';
					ld_IR<='0';
					ld_PC<='0';
					inc_PC<='0';
					clr_A<='0';
					ld_A<='0';
					ld_B<='0';
					clr_B<='0';
					clr_C<='0';
					ld_C<='0';
					clr_Z<='1';
					ld_Z<='0';
					
				ELSIF Instruction_sig2 = "01111010" THEN --TSTZ
					IF(statusZ='1')THEN
						clr_IR<='0';--INCREMENT PC COUNTER
						ld_IR<='0';
						ld_PC<='1';
						inc_PC<='1';
						clr_A<='0';
						ld_A<='0';
						ld_B<='0';
						clr_B<='0';
						clr_C<='0';
						ld_C<='0';
						clr_Z<='1';
						ld_Z<='0';
					END IF;
				
				ELSIF Instruction_sig2 = "01111100" THEN --TSTC
					IF(statusZ='1')THEN
						clr_IR<='0';--INCREMENT PC COUNTER
						ld_IR<='0';
						ld_PC<='1';
						inc_PC<='1';
						clr_A<='0';
						ld_A<='0';
						ld_B<='0';
						clr_B<='0';
						clr_C<='0';
						ld_C<='0';
						clr_Z<='1';
						ld_Z<='0';
					END IF;
				END IF; -- FOR state 2 OPS
			END IF;
		END IF; --For Enable
	END PROCESS;
	
	------STATE MACHINE------
	PROCESS(clk, enable)
	BEGIN
		IF enable = '1' THEN
			IF rising_edge (clk) THEN
				IF present_state = state_0 THEN present_state <= state_1;
				ELSIF present_state = state_1 THEN present_state<= state_2;
				ELSE present_state <= state_0;
				END IF;
			END IF;
		ELSE present_state <= state_0;
		END IF;
	END PROCESS;
	
	WITH present_state SELECT
		T <= "001" WHEN state_0,
			  "010" WHEN state_1,
			  "100" WHEN state_2,
			  "001" WHEN OTHERS;
  END Description;
	
					
					
					