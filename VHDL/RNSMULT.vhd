----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.06.2018 11:14:43
-- Design Name: 
-- Module Name: RNSMULT - Behavioral
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

entity RNSMULT is
Port ( A,B: IN  type_RNS;
       M  : OUT type_RNS
      );
end RNSMULT;

architecture Behavioral of RNSMULT is
--signal Z,W: type_RNS;
signal V  : type_DRNS;
begin
UM: for i in 1 to 8 generate
V(i) <= A(i)*B(i);
--MMR(V(i),i,M(i));
end generate;
MMR_M1(V(1),M(1));
MMR_M2(V(2),M(2));
MMR_M3(V(3),M(3));
MMR_M4(V(4),M(4));
MMR_M5(V(5),M(5));
MMR_M6(V(6),M(6));
MMR_M7(V(7),M(7));
MMR_M8(V(8),M(8));
end Behavioral;

