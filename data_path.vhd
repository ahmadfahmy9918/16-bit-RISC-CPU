LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY data_path IS
	PORT(
		--CLOCK SIGNAL
		Clk, mClk	: IN STD_LOGIC;
		
		-- MEMORY SINGALS
		WEN, EN		: IN STD_LOGIC;
		
		--REGISTER CONTROL SIGNALS (CLR AND LD)
		Clr_A, Ld_A	: IN STD_LOGIC;
		Clr_B, Ld_B	: IN STD_LOGIC;
		Clr_C, Ld_C	: IN STD_LOGIC;
		Clr_Z, Ld_Z	: IN STD_LOGIC;
		Clr_PC, Ld_PC	: IN STD_LOGIC;
		Clr_IR, Ld_IR	: IN STD_LOGIC;
		
		--REGISTER OUTPUTS
		Out_A		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Out_B		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Out_C		: OUT STD_LOGIC;
		Out_Z		: OUT STD_LOGIC;
		Out_PC	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Out_IR 	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		
		--SPECIAL INPUTS TO PC
		Inc_PC : IN STD_LOGIC;
		
		--ADDRESS AND DATA BUS SIGNALS FOR DEBUGGING
		ADDR_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		DATA_IN  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		DATA_BUS,
		MEM_OUT,
		MEM_IN 	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		MEM_ADDR	: OUT UNSIGNED(7 DOWNTO 0);
		
		--VARIOUS MUX CONTROLS
		DATA_MUX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		REG_MUX	: IN STD_LOGIC;
		A_MUX,
		B_MUX		: IN STD_LOGIC;
		IM_MUX1	: IN STD_LOGIC;
		IM_MUX2	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		--ALU OPERATIONS
		ALU_Op	: IN STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
END ENTITY;

ARCHITECTURE Behavior OF Data_Path IS
	--COMPONENT INSTANTIATIONS
	--DATA MEMORY MODULE
	COMPONENT data_mem IS
		PORT(
			clk	 : IN STD_LOGIC;
			addr   : IN UNSIGNED(7 DOWNTO 0);
			data_in: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			wen    : IN STD_LOGIC;
			en		 : IN STD_LOGIC;
			data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	END COMPONENT;
	
	--REG32
	COMPONENT register32 IS
		PORT(
			d	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ld : IN STD_LOGIC;
			clr: IN STD_LOGIC;
			clk: IN STD_LOGIC;
			Q  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	END COMPONENT;
	
	--PROGRAM COUNTER
	COMPONENT pc IS
		PORT(
			clr : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			ld  : IN STD_LOGIC;
			inc : IN STD_LOGIC;
			d   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			q   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	END COMPONENT;
	
	--LZE
	COMPONENT LZE IS
		PORT(
			LZE_in  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			LZE_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	END COMPONENT;
	
	--UZE
	COMPONENT UZE IS
		PORT(
			UZE_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			UZE_out: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	END COMPONENT;
		
	--RED
	COMPONENT RED IS
		PORT(
			RED_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			RED_out: OUT UNSIGNED(7 DOWNTO 0)
			);
	END COMPONENT;
	
	--MUX2TO1
	COMPONENT mux2to1 IS
		PORT(
			s		: IN STD_LOGIC;
			w0, w1: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			f		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	END COMPONENT;
	
	--MUX4TO1
	COMPONENT mux4to1 IS
		PORT(
			s					: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			X1, X2, X3, X4 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			f					: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	END COMPONENT;
	
	--ALU
	COMPONENT alu IS
		PORT(
			a		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			b		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			op    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			result: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			zero	: OUT STD_LOGIC;
			cout : OUT STD_LOGIC
			);
	END COMPONENT;
	
	--SIGNAL INSTANTIATIONS
	SIGNAL IR_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL data_bus_s : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL LZE_out_PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL LZE_out_A_Mux : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL LZE_out_B_Mux : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL RED_out_Data_Mem : UNSIGNED(7 DOWNTO 0);
	SIGNAL A_Mux_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL B_Mux_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL reg_A_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL reg_B_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL reg_Mux_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL data_mem_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	SIGNAL UZE_IM_MUX1_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL IM_MUX1_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL LZE_MUX2_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL IM_MUX2_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL LZE_IM_MUX2_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL zero_flag: STD_LOGIC;
	SIGNAL carry_flag: STD_LOGIC;
	SIGNAL temp : STD_LOGIC_VECTOR(30 DOWNTO 0) := (OTHERS => '0');
	SIGNAL out_pc_sig : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
BEGIN
	IR: register32 Port map(
			data_bus_s,
			Ld_IR,
			Clr_IR,
			Clk,
			IR_OUT
			);
			
	LZE_PC: LZE PORT MAP(
			  IR_OUT,
			  LZE_out_PC
			  );
			  
	PC0: PC PORT MAP(
		  CLR_PC,
		  Clk,
		  ld_PC,
		  INC_PC,
		  LZE_out_PC,
		  --ADDR OUT 
		  out_Pc_sig
		  );
		  
   LZE_A_Mux: LZE PORT MAP(
			IR_OUT,
			LZE_out_A_Mux
			);
			
	A_Mux0: mux2to1 PORT MAP(
			A_MUX,
			data_bus_s, 
			LZE_out_A_Mux,
			A_Mux_out
			);
			
	Reg_A: register32 PORT MAP(
			A_Mux_out,
			Ld_A,
			Clr_A,
			Clk,
			reg_A_out
			);
			
	LZE_B_Mux: LZE PORT MAP(
			IR_OUT,
			LZE_out_B_Mux
			);
			
	B_Mux0: mux2to1 PORT MAP(
			B_MUX,
			data_bus_s,
			LZE_out_B_Mux,
			B_Mux_out
			);
			
	Reg_B: register32 PORT MAP(
			B_Mux_out,
			Ld_B,
			Clr_B,
			Clk,
			reg_B_out
			);
			
	Reg_Mux0: mux2to1 PORT MAP(
			REG_MUX,
			Reg_A_out,
			Reg_B_out,
			Reg_Mux_out
			);
			
	RED_Data_Mem: RED PORT MAP(
			IR_OUT,
			RED_out_Data_Mem
			);
			
	Data_Mem0: data_Mem PORT MAP(
			mClk,
			RED_out_Data_Mem,
			Reg_Mux_out,
			WEN,
			EN,
			data_mem_out
			);
			
	UZE_IM_MUX1: UZE PORT MAP(
			IR_OUT,
			UZE_IM_MUX1_out
			);
	
	IM_MUX1a: mux2to1 PORT MAP(
			IM_MUX1,
			reg_A_out,
			UZE_IM_MUX1_out,
			IM_MUX1_out
			);
			
	LZE_IM_MUX2: LZE PORT MAP(
			IR_OUT,
			LZE_IM_MUX2_out
			);
			
	IM_MUX2a: mux4to1 PORT MAP(
			IM_MUX2,
			reg_B_out,
			LZE_IM_MUX2_out,
			(temp & '1'),
			(OTHERS => '0'),
			IM_MUX2_out
			);
			
	ALU0: alu PORT MAP(
			IM_MUX1_out,
			IM_MUX2_out,
			ALU_OP,
			ALU_out,
			zero_flag,
			carry_flag
			);
			
	DATA_MUX0: mux4to1 PORT MAP(
			DATA_MUX,
			DATA_IN,
			data_mem_out,
			ALU_out,
			(OTHERS => '0'),
			data_bus_s
			);
			
	DATA_BUS <= data_bus_s;
	OUT_A <= reg_A_out;
	OUT_B <= reg_B_out;
	OUT_IR <= IR_OUT;
	ADDR_OUT <= out_pc_sig;
	OUT_PC <= out_pc_sig;
	
	MEM_ADDR <= RED_out_Data_Mem;
	MEM_IN <= Reg_Mux_out;
	MEM_OUT <= data_mem_out;
	
END Behavior;
			