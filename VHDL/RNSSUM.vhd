----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.07.2018 22:01:44
-- Design Name: 
-- Module Name: RNSSUM - Behavioral
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
use WORK.RNS_PACKAGE.all;

entity RNSSUM is
Port ( A,B: IN  type_RNS;
       S  : OUT type_RNS
     );
end RNSSUM;

architecture Behavioral of RNSSUM is
begin
S <= BLOCK_SUM(A,B);     
end Behavioral;
