----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- 
-- Create Date: 08/10/2020 11:28:43 AM
-- Design Name: 
-- Module Name: s0_16_1_mux - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY S0_mux IS
  PORT (
    cin       : IN STD_LOGIC;
    select_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    y_s0      : OUT STD_LOGIC);
END S0_mux;

ARCHITECTURE Behavioral OF S0_mux IS

BEGIN
  PROCESS (cin, select_in)
  BEGIN
    -- write the input line functions generated for 16:1 to derive the S(0) output.
    -- The input lines can be '0' / '1' / Cin / (not) Cin.
    -- It is possible to use if...else or case statements here. 
    CASE select_in IS
      WHEN "0000" => y_s0 <= Cin;
      WHEN "0001" => y_s0 <= NOT Cin;
      WHEN "0010" => y_s0 <= Cin;
      WHEN "0011" => y_s0 <= NOT Cin;
      WHEN "0100" => y_s0 <= NOT Cin;
      WHEN "0101" => y_s0 <= Cin;
      WHEN "0110" => y_s0 <= NOT Cin;
      WHEN "0111" => y_s0 <= Cin;
      WHEN "1000" => y_s0 <= Cin;
      WHEN "1001" => y_s0 <= NOT Cin;
      WHEN "1010" => y_s0 <= Cin;
      WHEN "1011" => y_s0 <= NOT Cin;
      WHEN "1100" => y_s0 <= NOT Cin;
      WHEN "1101" => y_s0 <= Cin;
      WHEN "1110" => y_s0 <= NOT Cin;
      WHEN "1111" => y_s0 <= Cin;
      WHEN OTHERS => y_s0 <= '-';

        -- Write the VHDL codes for all the input cases.
    END CASE;
  END PROCESS;

END Behavioral;