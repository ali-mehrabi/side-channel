----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.07.2018 13:30:02
-- Design Name: 
-- Module Name: CSA8b - Behavioral
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

entity CSA is
generic( N : integer := 66);
Port (A1,A2,A3,A4,A5,A6,A7,A8 : in std_logic_vector(N-1 downto 0);
      S                       : out std_logic_vector(N+2 downto 0)
      );
end CSA;

architecture Behavioral of CSA is

signal P10,P11,P20,P21,G10,G11,G20,G21 :std_logic_vector(N-1 downto 0);
signal S1,S2   :std_logic_vector(N+1 downto 0);
signal C10,C20 :std_logic_vector(N+1 downto 0);
signal C11,C21 :std_logic_vector(N+1 downto 0);
signal S3,S4   :std_logic_vector(N+2 downto 0); 

begin
P10 <=  (A1 xor A2);
P11 <=  (A3 xor A4);
G10 <=  (A1 and A2);
G11 <=  (A3 and A4);
S1  <= "00"&(P10 xor P11);
C10 <= '0'&((P10 and P11) or ((not G10) and G11) or (G10 and (not G11)))&'0' ;
C11 <= (G10 and G11) &"00";

P20 <=  (A5 xor A6);
P21 <=  (A7 xor A8);
G20 <=  (A5 and A6);
G21 <=  (A7 and A8);
S2  <= "00"&(P20 xor P21);
C20 <= '0'&((P20 and P21) or ((not G20) and G21) or (G20 and (not G21)))&'0' ;
C21 <= (G20 and G21) &"00";

S3 <= '0'&S1 + C10 + C11;
S4 <= '0'&S2 + C20 + C21;
S <= S3+S4;

end Behavioral;
