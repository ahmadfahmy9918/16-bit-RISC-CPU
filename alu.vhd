LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY alu is
PORT(
		a		:	in std_logic_vector(31 downto 0);
		b		:	in std_logic_vector(31 downto 0);
		op		:	in std_logic_vector(2 downto 0);
		result:	out std_logic_vector(31 downto 0);
		zero	:	out std_logic;
		cout	:	out std_logic
		);
END alu;

ARCHITECTURE Behavior OF alu IS
	COMPONENT adder32
		port(
			Cin	: in std_logic;
			X,Y	: in std_logic_vector(31 downto 0);
			S		: out std_logic_vector(31 downto 0);
			Cout	: out std_logic
		);
	END COMPONENT;
	
	SIGNAL result_s	: std_logic_vector(31 downto 0) := (others => '0');
	SIGNAL result_add : std_logic_vector(31 downto 0) := (others => '0');
	SIGNAL result_sub : std_logic_vector(31 downto 0) := (others => '0');
	SIGNAL cout_s		: std_logic := '0';
	SIGNAL cout_add	: std_logic := '0';
	SIGNAL cout_sub	: std_logic := '0';
	SIGNAL zero_s		: std_logic;
	
BEGIN
		add0 : adder32 port map (op(2), a, b, result_add, cout_add);
		sub0 : adder32 port map (op(2), a, NOT b, result_sub, cout_sub);
		
		PROCESS (a, b, op)
		BEGIN 
			CASE(op) IS
				when "000" =>
					result_s<= a AND b;
					cout_s  <= '0';
				when "001" =>
					result_s<= a OR b;
					cout_s  <= '0';
				when "010" =>
					result_s<= result_add;
					cout_s  <= cout_add;
				when "011" =>
					result_s<= b;
					cout_s  <= '0';
				when "110" =>
					result_s<= result_sub;
					cout_s  <= cout_sub;
				when "100" =>
					result_s<= a(30 downto 0) & '0';
					cout_s  <= a(31);
				when "101" =>
					result_s<= '0' & a(31 downto 1);
					cout_s  <= '0';
				when others =>
					result_s<= a;
					cout_s  <= '0';
			END CASE;
			
			CASE (result_s) IS
				when (others => '0')=>
					zero_s <= '1';
				when others =>
					zero_s <= '0';
			END CASE;
		END PROCESS;
		
		result <= result_s;
		cout <= cout_s;
		zero <= zero_s;
	END Behavior;
		
		