----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
--
-- Create Date: 10/29/2020 07:18:24 PM
-- Design Name: CONTROLLER FOR THE CPU
-- Module Name: 
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: CPU OF LAB 3 - ECE 410 (2021)
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Additional Comments:
--*********************************************************************************
-- This the seven segment that will display the current Program counter on any one of the two display(seven-segment)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
entity sev_segment is
  port (
    --output of PC from cpu
    DispVal : in std_logic_vector (4 downto 0);
    anode : out std_logic;
    --controls which digit to display
    segOut : out std_logic_vector (6 downto 0));
end sev_segment;

architecture Behavioral of sev_segment is
begin

  anode <= '1';

  with DispVal select
    segOut <=
    "1111110" when "00000", --0
    "0110000" when "00001", --1
    "1101101" when "00010", --2
    "1111001" when "00011", --3
    "0110011" when "00100", --4
    "1011O11" when "00101", --5
    "1011111" when "00110", --6
    "1110000" when "00111", --7
    "1111111" when "01000", --8
    "1110011" when "01001", --9

    -- ***************************************
    -- write the remaining lines to display from A to F, when "others" is provided to you...
    "1110111" when "01010",
    "0011111" when "01011",
    "1001110" when "01100",
    "0111101" when "01101",
    "1001111" when "01110",
    "1000111" when "01111",
    ------------------------------------------

    "1000000" when others;

end Behavioral;