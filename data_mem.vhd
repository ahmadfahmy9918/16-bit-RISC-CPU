LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY data_mem IS
PORT(
	clk		: in std_logic;
	addr		: in unsigned(7 downto 0);
	data_in	: in std_logic_vector(31 downto 0);
	wen		: in std_logic;
	en			: in std_logic;
	data_out	: out std_logic_vector(31 downto 0)
	);
END data_mem;

ARCHITECTURE Behavior OF data_mem IS
	TYPE RAM IS ARRAY(0 to 255) OF std_logic_vector(31 downto 0);
	SIGNAL DATAMEM : RAM;
BEGIN
	PROCESS(clk, en, wen)
	BEGIN
		IF(clk'event AND clk='0') THEN
			IF (en = '0') THEN
				data_out<= (OTHERS => '0');
			ELSE 
				IF (wen = '0') THEN
					data_out <= DATAMEM(to_integer(addr));
				END IF;

				IF (wen = '1') THEN	
					DATAMEM(to_integer(addr)) <= data_in;
					data_out <= (OTHERS => '0');
				END IF;
			END IF;
		END IF;
	END PROCESS;
END Behavior;