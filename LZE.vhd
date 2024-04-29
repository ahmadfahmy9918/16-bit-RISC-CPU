LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY LZE IS
PORT(
	LZE_in	: in std_logic_vector(31 DOWNTO 0);
	LZE_out  : OUT STD_logic_vector(31 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE Behavior OF LZE IS 
SIGNAL zeros: STD_logic_vector(15 DOWNTO 0) := (OTHERS => '0');
BEGIN 
	LZE_out <= zeros & LZE_in(15 DOWNTO 0);
END Behavior;