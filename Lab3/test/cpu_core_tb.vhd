----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
--
-- Create Date: 10/29/2020 07:18:24 PM
-- Design Name:
-- Module Name: cpu _core test bench
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: CPU LAB 3 - ECE 410 (2021)
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu_core_tb is
end cpu_core_tb;

architecture behavior of cpu_core_tb is

  -- Component Declaration for the Unit Under Test (UUT)

  component cpu_ctrl_dp port (
    clk_cpu : in std_logic;
    rst_cpu : in std_logic;
    entered_ip : in std_logic;
    input_cpu : in std_logic_vector(7 downto 0);
    output_cpu : out std_logic_vector(7 downto 0);
    PC_output : out std_logic_vector(4 downto 0);
    OPCODE_ouput : out std_logic_vector(3 downto 0);
    done_cpu : out std_logic);
  end component;

  signal clk_tb : std_logic := '0';
  signal rst_tb : std_logic := '0';
  signal in_tb : std_logic_vector(7 downto 0);
  signal opcode_tb : std_logic_vector(3 downto 0);
  signal pc_tb : std_logic_vector(4 downto 0);
  signal output_tb : std_logic_vector(7 downto 0);
  signal enter : std_logic;
  signal done : std_logic;

  -- Clock period definitions
  constant clk_period : time := 8 ns;

begin
  -- Instantiate the Unit Under Test (UUT)
  uut : cpu_ctrl_dp port map(
    clk_cpu => clk_tb,
    rst_cpu => rst_tb,
    entered_ip => enter,
    input_cpu => in_tb,
    output_cpu => output_tb,
    PC_output => pc_tb,
    OPCODE_ouput => opcode_tb,
    done_cpu => done);
  -- Clock process definitions
  clk_process : process
  begin
    clk_tb <= '0';
    wait for clk_period/2;
    clk_tb <= '1';
    wait for clk_period/2;
  end process;
  -- Stimulus process
  stim_proc : process
  begin

    --*********************************
    -- provide the required input stimulus here for the design under test

    ----------------------------------- Part-1
    rst_tb <= '1';
    enter <= '0';

    wait for clk_period;
    
    enter <= '1';
    
    -- Case 1: user input is zero
    -- in_tb <= "00000000";
    -- WAIT UNTIL done = '1';
    -- Case 2: user input is nonzero
    -- IN A
    in_tb <= "10000000";
    wait until rising_edge(clk_tb);
    rst_tb <= '0';
    
    wait until done = '1';
    wait ; 
    -----------------------------------
  end process;

end behavior;