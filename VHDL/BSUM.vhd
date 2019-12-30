----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.07.2018 16:53:31
-- Design Name: 
-- Module Name: BSUM - Behavioral
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


entity BSUM is
Port (A1,A2 : in  type_RNS;
      S     : out type_YSUM );
end BSUM;

architecture Behavioral of BSUM is
begin
MULT: for i in 1 to total_channels generate
      S(i) <= '0'&A1(i) + A2(i);
end generate;

end Behavioral;
