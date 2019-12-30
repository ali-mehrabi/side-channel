----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.07.2018 21:15:08
-- Design Name: 
-- Module Name: KSUM - Behavioral
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

entity KSUM is
Port ( A1,A2: in   std_logic_vector(2*w-15 downto 0);
       S    : out  std_logic_vector(2*w-14 downto 0)
       );
end KSUM;

architecture Behavioral of KSUM is

begin
S<= '0'&A1+A2;
end Behavioral;
