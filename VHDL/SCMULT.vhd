----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.07.2018 12:55:11
-- Design Name: 
-- Module Name: SCMULT - Behavioral
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


entity SCMULT is
Port ( A : in  std_logic_vector(w-1    downto 0);
       B : in  std_logic_vector(w-15   downto 0);
       E : out std_logic_vector(2*w-15 downto 0)
       );
end SCMULT;

architecture Behavioral of SCMULT is

begin
E(2*w-15 downto 0) <= A*B;
end Behavioral;
