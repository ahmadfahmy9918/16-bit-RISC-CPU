LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY reset_circuit IS 
	PORT(
		Reset : IN STD_LOGIC;
		Clk   : IN STD_LOGIC;
		Enable_PD : OUT STD_LOGIC := '1';
		Clr_PC : OUT STD_LOGIC
		);
END reset_circuit;

ARCHITECTURE Behavior OF reset_circuit IS
	TYPE clkNum IS (clk0, clk1, clk2, clk3);
	SIGNAL present_clk: clkNum;
BEGIN
	PROCESS(clk)begin 
		IF rising_edge(clk) THEN 
			IF Reset = '1' THEN 
				Clr_PC <= '1';
				Enable_PD <= '0';
				present_clk <= clk0;
			ELSIF present_clk <= clk0 THEN 
				present_clk <= clk1;
			ELSIF present_clk <= clk1 THEN
				present_clk <= clk2;
			ELSIF present_clk <= clk2 THEN
				present_clk <= clk3;
			ELSIF present_clk <= clk3 THEN
				Clr_PC <= '0';
				Enable_PD <= '1';
			END IF;
		END IF;
	END PROCESS;
END Behavior;
				
				
				
				
				