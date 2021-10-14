----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/03/2021 11:20:10 AM
-- Design Name: 
-- Module Name: full_adder_2bit_tb - Behavioral
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
USE std.env.finish;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY full_adder_2bit_tb IS
  --  Port ( );
END full_adder_2bit_tb;

ARCHITECTURE Behavioral OF full_adder_2bit_tb IS

  COMPONENT full_adder_2bit IS
    PORT (
      A              : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      B              : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      c_in           : IN STD_LOGIC;
      sum            : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      c_out          : OUT STD_LOGIC;
      compare_result : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
  END COMPONENT;

  SIGNAL A, B           : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL c_in, c_out    : STD_LOGIC;
  SIGNAL sum            : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL compare_result : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
  Full_adder : full_adder_2bit PORT MAP(
    A              => A,
    B              => B,
    c_in           => c_in,
    sum            => Sum,
    c_out          => c_out,
    compare_result => compare_result
  );
  PROCESS
    CONSTANT time_period : TIME := 20 ns;

  BEGIN

    -- this is a self checking testbench written for few input combinations of the 2-bit half adder.
    -- Error in Sum and Cout will be reported using this self checking test bench
    -- On generation of the wrong outputs, error is reported in the tcl console window

    -- You must include reasonable number of test cases to verify the working of your design.

    ----------------
    A    <= "00";
    B    <= "00";
    c_in <= '0';
    WAIT FOR time_period;
    ASSERT ((sum = "00") AND (c_out = '0') AND (compare_result = "010")) --If for A=00 AND B=00, IF S!=00 AND C!=0, then there is an error
    REPORT "Error for input A_in=00 and B_in=00" SEVERITY error;
    ----------------
    ----------------
    A    <= "10";
    B    <= "01";
    c_in <= '0';
    WAIT FOR time_period;
    ASSERT ((sum = "11") AND (c_out = '0') AND (compare_result = "100")) --If for A=00 AND B=00, IF S!=00 AND C!=0, then there is an error
    REPORT "Error for input A_in=00 and B_in=00 " SEVERITY error;
    ----------------
    ----------------
    A    <= "01";
    B    <= "11";
    c_in <= '0';
    WAIT FOR time_period;
    ASSERT ((sum = "00") AND (c_out = '1') AND (compare_result = "001")) --If for A=00 AND B=00, IF S!=00 AND C!=0, then there is an error
    REPORT "Error for input A_in=00 and B_in=00" SEVERITY error;
    ----------------
    ----------------
    A    <= "01";
    B    <= "01";
    c_in <= '1';
    WAIT FOR time_period;
    ASSERT ((sum = "11") AND (c_out = '0') AND (compare_result = "010")) --If for A=00 AND B=00, IF S!=00 AND C!=0, then there is an error
    REPORT "Error for input A_in=00 and B_in=00" SEVERITY error;
    ----------------
    finish;
  END PROCESS;

END Behavioral;