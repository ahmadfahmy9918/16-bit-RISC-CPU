LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fulladd IS
PORT(
	Cin, x, y	: IN STD_LOGIC;
	s, Cout		: OUT STD_LOGIC
	);
END fulladd;

ARCHITECTURE Behavior OF fulladd IS
BEGIN
	s <= x XOR y XOR Cin;
	Cout <= (x AND y) OR (Cin AND x) OR (Cin AND y);
END Behavior;