----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.07.2018 15:35:36
-- Design Name: 
-- Module Name: RNSSUB - Behavioral
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

entity RNSSUB is
Port (A:    in  TYPE_RNS;
      B:    in  TYPE_RNS;
      S:    out type_RNS
     );
end RNSSUB;

architecture Behavioral of RNSSUB is
signal Ci: type_RNS;

begin
--Ci <= BLOCK_SUM(BM,A);
S  <= BLOCK_SUB(A,B);   
end architecture Behavioral;  