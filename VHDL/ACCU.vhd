----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.07.2018 17:14:11
-- Design Name: 
-- Module Name: ACCU - Behavioral
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
library IEEE;
library WORK; 
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.RNS_package.all;


entity ACCU is
Port ( CLK : in std_logic;
       RST : in std_logic;
       A   : in type_YSUM;
       ACC : inout type_YACU
      );
end ACCU;

architecture Behavioral of ACCU is

begin

process(CLK,RST)
begin
if RST = '0' then 
   ACC <= (others=>(others=>'0'));
elsif CLK='1'and CLK'event then 
  for i in 1 to total_channels loop  
     ACC(i) <= ACC(i) + A(i); 
  end loop;
end if;
end process;
     
end Behavioral;