----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2019 17:41:42
-- Design Name: 
-- Module Name: MUX - Behavioral
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


entity MUX is
 Port (
 SEL:           in  std_logic;
 X1i,Y1i,Z1i:   in  type_RNS;
 X2i,Y2i,Z2i:   in  type_RNS;
 XOi,YOi,ZOi:   out type_RNS 
 );
end MUX;

architecture Behavioral of MUX is
begin
XOi <= X1i when SEL='0' else X2i;
YOi <= Y1i when SEL='0' else Y2i;
ZOi <= Z1i when SEL='0' else Z2i;
end Behavioral;
