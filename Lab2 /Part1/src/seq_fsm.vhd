---- Company: Department of Electrical and Computer Engineering, University of Alberta
---- Engineer: Shyama Gandhi and Bruce Cockburn
---- 
---- Create Date: 10/10/2021 03:41:32 PM
---- Design Name: 
---- Module Name: seq_fsm - Behavioral
---- Project Name: 
---- Target Devices: Zybo Z7-10 
---- Tool Versions: 
---- Description: SEQUENCE DETECTOR : 11011 - OVERLAPPING CASE : MEALY FSM
---- 
---- Dependencies: 
---- 
---- Revision:
---- Revision 0.01 - File Created

------------------------------------------------------------------------------------
---- Additional Comments:
---- ADD THE CODE IN THE COMMENTED SECTION. THERE ARE TWO INTENTIONAL MISTAKES TOO IN THIS CODE TEMPLATE! 
---- CORRECT THE MISTAKES TO ENSURE CORRECT WORKING OF FSM.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity seq_fsm is
Port (clk           : in std_logic;
      reset         : in std_logic;
      seq_in        : in std_logic;
      output_detect : out std_logic);
end seq_fsm;

architecture Behavioral of seq_fsm is

signal clk_o : std_logic;

type states is (A,B,C,D,E);
signal state_reg, state_next: states;

---------------------------------------------
-- Add the clk_divider component here
-- Remember, you want to add this component here and then use it later when you wish to have the divided clock by a factor of 62500000
--component clk_divider is
--    port (
--        clk_in  : in std_logic;
--        clk_out : out std_logic        
--    );
--end component;

---------------------------------------------
  
begin
---------------------------------------------
-- port map the clk_divider here
--clkdiv: component clk_divider
--    port map (
--        clk_in    => clk,
--        clk_out   => clk_o    
--    );

---------------------------------------------
    
    -- the process below uses the 'clk' i.e. the undivided clock , i.e. the clock signal from the entity.
    -- you can replace it with the divided clock signal later on when you add the 'clk_divider' component.
    -- same way, you will need to change the clock signal in the 'elsif' statement inside the process below, later on!
    process(clk)
        begin
           if(reset='1')then
                state_reg <= A;
           elsif(rising_edge(clk))then
                state_reg <= state_next;
           end if; 
    end process;
    
    process(state_reg) -- complete the sensitivity list
        begin
        case state_reg is
            when A =>                    
                    if seq_in = '0' then
                        state_next <= A;
                        output_detect <= '0';
                    else
                        state_next <= B;
                        output_detect <= '0';
                    end if;
                    
            --- Add the remaining cases for other states here!
            when B =>                    
                    if seq_in = '0' then
                        state_next <= A;
                        output_detect <= '0';
                    else
                        state_next <= C;
                        output_detect <= '0';
                    end if;

            when C =>                    
                    if seq_in = '0' then
                        state_next <= D;
                        output_detect <= '0';
                    else
                        state_next <= C;
                        output_detect <= '0';
                    end if;

            when D =>                    
                    if seq_in = '0' then
                        state_next <= A;
                        output_detect <= '0';
                    else
                        state_next <= E;
                        output_detect <= '0';
                    end if;

            when E =>                    
                    if seq_in = '0' then
                        state_next <= A;
                        output_detect <= '0';
                    else
                        state_next <= C;
                        output_detect <= '1';
                    end if;                                                                                                             
        end case;
    end process;
    
end Behavioral;