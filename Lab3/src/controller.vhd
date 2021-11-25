----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
--
-- Create Date: 10/29/2020 07:18:24 PM
-- Updated Date: 01/11/2021
-- Design Name: CONTROLLER FOR THE CPU
-- Module Name: cpu - behavioral(controller)
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: CPU_LAB 3 - ECE 410 (2021)
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Additional Comments:
--*********************************************************************************
-- The controller implements the states for each instructions and asserts appropriate control signals for the datapath during every state.
-- For detailed information on the opcodes and instructions to be executed, refer the lab manual.
-----------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity controller is port (
  clk_ctrl : in std_logic;
  rst_ctrl : in std_logic;
  enter : in std_logic;
  muxsel_ctrl : out std_logic_vector(1 downto 0);
  imm_ctrl : buffer std_logic_vector(7 downto 0);
  accwr_ctrl : out std_logic;
  rfaddr_ctrl : out std_logic_vector(2 downto 0);
  rfwr_ctrl : out std_logic;
  alusel_ctrl : out std_logic_vector(2 downto 0);
  outen_ctrl : out std_logic;
  zero_ctrl : in std_logic;
  positive_ctrl : in std_logic;
  PC_out : out std_logic_vector(4 downto 0);
  OP_out : out std_logic_vector(3 downto 0);
  ---------------------------------------------------
  bit_sel_ctrl : out std_logic;
  bits_shift_ctrl : out std_logic_vector(1 downto 0);
  ---------------------------------------------------
  done : out std_logic);
end controller;

architecture Behavior of controller is

  type state_type is (Fetch, Decode, LDA_execute, STA_execute, LDI_execute, ADD_execute, SUB_execute, SHFL_execute, SHFR_execute,
    input_A, output_A, Halt_cpu, JZ_execute, flag_state, ADD_SUB_SL_SR_next);

  signal state : state_type;
  signal IR : std_logic_vector(7 downto 0);
  signal PC : integer range 0 to 31;
  -- Instructions and their opcodes (pre-decided)
  constant LDA : std_logic_vector(3 downto 0) := "0001";
  constant STA : std_logic_vector(3 downto 0) := "0010";
  constant LDI : std_logic_vector(3 downto 0) := "0011";

  constant ADD : std_logic_vector(3 downto 0) := "0100";
  constant SUB : std_logic_vector(3 downto 0) := "0101";

  constant SHFL : std_logic_vector(3 downto 0) := "0110";
  constant SHFR : std_logic_vector(3 downto 0) := "0111";

  constant INA : std_logic_vector(3 downto 0) := "1000";
  constant OUTA : std_logic_vector(3 downto 0) := "1001";
  constant HALT : std_logic_vector(3 downto 0) := "1010";

  constant JZ : std_logic_vector(3 downto 0) := "1100";

  type PM_BLOCK is array(0 to 31) of std_logic_vector(7 downto 0); -- program memory that will store the instructions sequentially from part 1 and part 2 test program

begin

  --opcode is kept up-to-date
  OP_out <= IR(7 downto 4);

  process (clk_ctrl, rst_ctrl, zero_ctrl, positive_ctrl) -- complete the sensitivity list ********************************************

    -- "PM" is the program memory that holds the instructions to be executed by the CPU 
    variable PM : PM_BLOCK := (--Task 2
    "10000001", -- IN A (upper)
    "10000000", -- IN A (lower)
    "00100000", -- STA R[0], A
    "00110000", -- LDI A, 15
    "00001111", -- 15
    "01000000", -- ADD A, R[0]
    "10010000", -- OUT A 
    "10100000", -- HALT
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000",
    "00000000"
    );

    -- To decode the 4 MSBs from the PC content
    variable OPCODE : std_logic_vector(3 downto 0);

    -- Zero flag and positive flag
    variable zero_flag, positive_flag : std_logic;

  begin
    if (rst_ctrl = '1') then -- RESET initializes all the control signals to 0.
      PC <= 0;
      muxsel_ctrl <= "00";
      imm_ctrl <= (others => '0');
      accwr_ctrl <= '0';
      rfaddr_ctrl <= "000";
      rfwr_ctrl <= '0';
      alusel_ctrl <= "000";
      outen_ctrl <= '0';
      done <= '0';
      bit_sel_ctrl <= '0';
      bits_shift_ctrl <= "00";
      state <= Fetch;

      -- *************** assembly code for PART1/PART2 goes here
      -- for example this is how the instructions will be stored in the program memory
      --                PM(0) := "XXXXXXXX";    
      -- **************

    elsif (clk_ctrl'event and clk_ctrl = '1') then
      case state is
        when Fetch => -- fetch instruction
          if (enter = '1') then
            PC_out <= conv_std_logic_vector(PC, 5);
            -- ****************************************
            -- write one line of code to get the 8-bit instruction into IR                      
            IR <= PM(PC);
            -------------------------------------------
            PC <= PC + 1;
            muxsel_ctrl <= "00";
            imm_ctrl <= (others => '0');
            accwr_ctrl <= '0';
            rfaddr_ctrl <= "000";
            rfwr_ctrl <= '0';
            alusel_ctrl <= "000";
            outen_ctrl <= '0';
            done <= '0';
            zero_flag := zero_ctrl;
            positive_flag := positive_ctrl;
            state <= Decode;
          elsif (enter = '0') then
            state <= Fetch;
          end if;

        when Decode => -- decode instruction

          OPCODE := IR(7 downto 4);

          case OPCODE is
            when LDA => state <= LDA_execute;
            when STA => state <= STA_execute;
            when LDI => state <= LDI_execute;
            when ADD => state <= ADD_execute;
            when SUB => state <= SUB_execute;
            when SHFL => state <= SHFL_execute;
            when SHFR => state <= SHFR_execute;
            when INA => state <= input_A;
            when OUTA => state <= output_A;
            when HALT => state <= Halt_cpu;
            when JZ => state <= JZ_execute;
            when others => state <= Halt_cpu;

          end case;

          muxsel_ctrl <= "00";
          imm_ctrl <= PM(PC); --since the PC is incremented here, I am just doing the pre-fetching. Will relax the requirement for PM to be very fast for LDI to work properly.
          accwr_ctrl <= '0';
          rfaddr_ctrl <= IR(2 downto 0); --Decode pre-emptively sets up the register file, just to reduce the delay for waiting one more cycle
          rfwr_ctrl <= '0';
          alusel_ctrl <= "000";
          outen_ctrl <= '0';
          done <= '0';
          bit_sel_ctrl <= IR(0);
          bits_shift_ctrl <= IR(1 downto 0);

        when flag_state => -- set zero and positive flags and then goto next instruction
          muxsel_ctrl <= "00";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '0';
          rfaddr_ctrl <= "000";
          rfwr_ctrl <= '0';
          alusel_ctrl <= "000";
          outen_ctrl <= '0';
          done <= '0';
          state <= Fetch;
          zero_flag := zero_ctrl;
          positive_flag := positive_ctrl;

        when ADD_SUB_SL_SR_next => -- next state TO add, sub,shfl, shfr
          muxsel_ctrl <= "00";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '1';
          rfaddr_ctrl <= "000";
          rfwr_ctrl <= '0';
          alusel_ctrl <= "000";
          outen_ctrl <= '0';
          state <= flag_state;

        when LDA_execute => -- LDA 
          -- *********************************
          -- write the entire state for LDA_execute
          muxsel_ctrl <= "01";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '1';
          rfaddr_ctrl <= IR(2 downto 0);
          rfwr_ctrl <= '0';
          alusel_ctrl <= "000";
          outen_ctrl <= '0';
          done <= '0';
          state <= Fetch;
          ------------------------------------

        when STA_execute => -- STA 
          muxsel_ctrl <= "00";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '0';
          rfaddr_ctrl <= IR(2 downto 0);
          rfwr_ctrl <= '1';
          alusel_ctrl <= "000";
          outen_ctrl <= '0';
          done <= '0';
          state <= Fetch;

        when LDI_execute => -- LDI 
          -- *********************************
          -- write the entire state for LDI_execute
          muxsel_ctrl <= "11";
          imm_ctrl <= PM(PC);
          PC <= PC + 1;
          accwr_ctrl <= '1';
          rfaddr_ctrl <= "000";
          rfwr_ctrl <= '0';
          alusel_ctrl <= "000";
          outen_ctrl <= '0';
          done <= '0';
          state <= Fetch;
          ------------------------------------

        when JZ_execute => -- JZ
          -- *********************************
          -- write the entire state for JZ_execute 
          muxsel_ctrl <= "00";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '0';
          rfaddr_ctrl <= "000";
          rfwr_ctrl <= '0';
          alusel_ctrl <= "000";
          outen_ctrl <= '0';
          done <= '0';

          if zero_flag = '1' then
            -- If input is zero, jump to next instruction
            -- address, given by the next byte in PM
            PC <= CONV_INTEGER(imm_ctrl);
          else
            PC <= PC + 1;
          end if;

          state <= fetch;
          ------------------------------------

        when ADD_execute => -- ADD 
          -- *********************************
          -- write the entire state for ADD_execute 
          muxsel_ctrl <= "00";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '1';
          rfaddr_ctrl <= IR(2 downto 0);
          rfwr_ctrl <= '0';
          alusel_ctrl <= "100";
          outen_ctrl <= '0';
          done <= '0';
          state <= ADD_SUB_SL_SR_next;
          ------------------------------------

        when SUB_execute => -- SUB 
          -- *********************************
          -- write the entire state for SUB_execute 
          muxsel_ctrl <= "00";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '1';
          rfaddr_ctrl <= IR(2 downto 0);
          rfwr_ctrl <= '0';
          alusel_ctrl <= "101";
          outen_ctrl <= '0';
          done <= '0';
          state <= ADD_SUB_SL_SR_next;
          ------------------------------------

        when SHFL_execute => -- SHFL
          -- *********************************
          -- write the entire state for SHFL_execute 
          muxsel_ctrl <= "00";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '1';
          rfaddr_ctrl <= IR(2 downto 0);
          rfwr_ctrl <= '0';
          alusel_ctrl <= "010";
          outen_ctrl <= '0';
          done <= '0';
          state <= ADD_SUB_SL_SR_next;
          ------------------------------------

        when SHFR_execute => -- SHFR 
          -- *********************************
          -- write the entire state for SHFR_execute 
          muxsel_ctrl <= "00";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '1';
          rfaddr_ctrl <= IR(2 downto 0);
          rfwr_ctrl <= '0';
          alusel_ctrl <= "011";
          outen_ctrl <= '0';
          done <= '0';
          state <= ADD_SUB_SL_SR_next;
          ------------------------------------

        when input_A => -- INA
          muxsel_ctrl <= "10";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '1';
          rfaddr_ctrl <= "000";
          rfwr_ctrl <= '0';
          alusel_ctrl <= "000";
          outen_ctrl <= '0';
          done <= '0';
          state <= flag_state;
          bit_sel_ctrl <= IR(0);
          -------------------------------------

        when output_A => -- OUTA
          -- *********************************
          -- write the entire state for output_A
          muxsel_ctrl <= "00";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '0';
          rfaddr_ctrl <= "000";
          rfwr_ctrl <= '0';
          alusel_ctrl <= "000";
          outen_ctrl <= '1';
          done <= '0';
          state <= Fetch;
          ------------------------------------

        when Halt_cpu => -- HALT
          muxsel_ctrl <= "00";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '0';
          rfaddr_ctrl <= "000";
          rfwr_ctrl <= '0';
          alusel_ctrl <= "000";
          outen_ctrl <= '1';
          done <= '1';
          state <= Halt_cpu;

        when others =>
          muxsel_ctrl <= "00";
          imm_ctrl <= (others => '0');
          accwr_ctrl <= '0';
          rfaddr_ctrl <= "000";
          rfwr_ctrl <= '0';
          alusel_ctrl <= "000";
          outen_ctrl <= '1';
          done <= '1';
          state <= Halt_cpu;
      end case;
    end if;

  end process;
end Behavior;