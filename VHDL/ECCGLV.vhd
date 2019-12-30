----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2019 23:10:56
-- Design Name: 
-- Module Name: ECGLV - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 1.01 - File Created
-- Additional Comments:
-- 28/05/2018
----------------------------------------------------------------------------------
library IEEE;
library WORK; 
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.RNS_PACKAGE.all;
entity  ECCGLV is
   Port (CLK:        in  std_logic;
      RESETN:        in  std_logic;
      A:             in  std_logic_vector(3 downto 0);
      XO:            out std_logic_vector(65 downto 0);
      SEL_O:         in std_logic_vector(4 downto 0);
      DO:            out std_logic;
      AD:            out std_logic;
      DONE:          out std_logic
     );
end  ECCGLV;

architecture Behavioral of ECCGLV is
type   TYPE_STATE is (S0,S1,S2,S3,S4,S5,S6);
constant DPERIOD: integer:= 155;
constant APERIOD: integer:= 370;
 
signal STATE: TYPE_STATE;
signal  X0,Y0,Z0           : type_RNS;
signal  X1,Y1,Z1           : type_RNS;
signal  X2,Y2,Z2           : type_RNS;
signal  X3,Y3,Z3           : type_RNS;
signal  XR,YR,ZR           : type_RNS;
signal  XS,YS,ZS           : type_RNS;
signal  DRESET,ARESET,SEL  : std_logic;
signal  ADDR, KADDR        : std_logic_vector(3 downto 0);
signal  X,Y,Z              : std_logic_vector(527 downto 0);
signal  K,K2               : std_logic_vector(515 downto 0);
signal SELD,SELA           : std_logic; 
--signal V     : integer; --test point

component SMR is
Port ( 
      CLK   : IN std_logic;
      RESETN: IN std_logic;
      Ai    : IN type_RNS;
      Zi    : OUT type_RNS
      );
end component SMR ;

component ARITH is
Port (CLK   :     in  std_logic;
      ARESETN:    in  std_logic;
      DRESETN:    in  std_logic;
      XP,YP,ZP:   in  type_RNS;
      X1A,Y1A,Z1A:   in  type_RNS;
      X2A,Y2A,Z2A:   in  type_RNS;
      XOP,YOP,ZOP:   out type_RNS;
      XOA,YOA,ZOA:   out type_RNS
      );
end component ARITH;

component  ECPD is
Port (CLK:           in  std_logic;
      RESETN:        in  std_logic;
      X1i,Y1i,Z1i:   in  type_RNS;
      X2i,Y2i,Z2i:   out type_RNS
     );
end component ECPD;

component ECPA is
Port (CLK   :    in  std_logic;
      RESETN:    in  std_logic;
      X1i,Y1i,Z1i:   in  type_RNS;
      X2i,Y2i,Z2i:   in  type_RNS;
      XOi,YOi,ZOi:   out type_RNS
      );
end component ECPA;

component MUX is
 Port (
 SEL:           in  std_logic;
 X1i,Y1i,Z1i:   in  type_RNS;
 X2i,Y2i,Z2i:   in  type_RNS;
 XOi,YOi,ZOi:   out type_RNS 
 );
end component MUX;

component RAMX IS
 port (
   a   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
   spo : OUT STD_LOGIC_VECTOR(527 DOWNTO 0)
 );
end component RAMX;

component RAMY IS
 port (
   a   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
   spo : OUT STD_LOGIC_VECTOR(527 DOWNTO 0)
 );
end component RAMY;
component RAMZ IS
 port (
   a   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
   spo : OUT STD_LOGIC_VECTOR(527 DOWNTO 0)
 );
end component RAMZ;

component RAMK IS
 port (
   a   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
   spo : OUT STD_LOGIC_VECTOR(515 DOWNTO 0)
 );
end component RAMK;
--- RAM MAPPED AS 
--  P   000
--  Q   001
-- -P   010
-- -Q   011
--  P+Q 100
-- -P+Q 101
--  P-Q 110
-- -P-Q 111 
begin
XO <= XR(1) when SEL_O = "00000"  else
      XR(2) when SEL_O = "00001"  else 
      XR(3) when SEL_O = "00010"  else 
      XR(4) when SEL_O = "00011"  else 
      XR(5) when SEL_O = "00100"  else                    
      XR(6) when SEL_O = "00101"  else 
      XR(7) when SEL_O = "00110"  else       
      XR(8) when SEL_O = "00111"  else 
      YR(1) when SEL_O = "01000"  else
      YR(2) when SEL_O = "01001"  else 
      YR(3) when SEL_O = "01010"  else 
      YR(4) when SEL_O = "01011"  else 
      YR(5) when SEL_O = "01100"  else                    
      YR(6) when SEL_O = "01101"  else 
      YR(7) when SEL_O = "01110"  else       
      YR(8) when SEL_O = "01111"  else       
      ZR(1) when SEL_O = "10000"  else
      ZR(2) when SEL_O = "10001"  else 
      ZR(3) when SEL_O = "10010"  else 
      ZR(4) when SEL_O = "10011"  else 
      ZR(5) when SEL_O = "10100"  else                    
      ZR(6) when SEL_O = "10101"  else 
      ZR(7) when SEL_O = "10110"  else       
      ZR(8) when SEL_O = "10111"  else
      (others=>'0');
                      
URAMX: RAMX    port map ( a => ADDR,  spo => X);
URAMY: RAMY    port map ( a => ADDR,  spo => Y);
URAMZ: RAMZ    port map ( a => ADDR,  spo => Z);
URAMK: RAMK    port map ( a => KADDR, spo => K);
UMUX1: MUX     port map ( SEL=> SELD, X1i => XS,Y1i=> YS, Z1i=> ZS, X2i=> XR, Y2i=>YR, Z2i=>ZR, Xoi=> X1, Yoi=>Y1, Zoi=>Z1);  
UMUX2: MUX     port map ( SEL=> SELA, X1i => X2,Y1i=> Y2, Z1i=> Z2, X2i=> X3, Y2i=>Y3, Z2i=>Z3, Xoi=> XR, Yoi=>YR, Zoi=>ZR);
UAR  : ARITH   port map ( CLK=>CLK ,ARESETN=> ARESET,DRESETN=> DRESET,XP => X1, YP => Y1, ZP => Z1, X1A => XS, Y1A => YS, Z1A => ZS, X2A => X2, Y2A => Y2, Z2A =>Z2, 
                        XOP=> X2, YOP => Y2, ZOP => Z2,XOA=> X3, YOA => Y3, ZOA => Z3); 
KADDR <= A;                                                   
DO    <= DRESET;
AD    <= ARESET;
XS(1) <= X(  w-1 downto 0);
XS(2) <= X(2*w-1 downto w);
XS(3) <= X(3*w-1 downto 2*w);
XS(4) <= X(4*w-1 downto 3*w);
XS(5) <= X(5*w-1 downto 4*w);
XS(6) <= X(6*w-1 downto 5*w);
XS(7) <= X(7*w-1 downto 6*w);
XS(8) <= X(8*w-1 downto 7*w);
YS(1) <= Y(  w-1 downto 0);
YS(2) <= Y(2*w-1 downto w);
YS(3) <= Y(3*w-1 downto 2*w);
YS(4) <= Y(4*w-1 downto 3*w);
YS(5) <= Y(5*w-1 downto 4*w);
YS(6) <= Y(6*w-1 downto 5*w);
YS(7) <= Y(7*w-1 downto 6*w);
YS(8) <= Y(8*w-1 downto 7*w);
ZS(1) <= Z(  w-1 downto 0);
ZS(2) <= Z(2*w-1 downto w);
ZS(3) <= Z(3*w-1 downto 2*w);
ZS(4) <= Z(4*w-1 downto 3*w);
ZS(5) <= Z(5*w-1 downto 4*w);
ZS(6) <= Z(6*w-1 downto 5*w);
ZS(7) <= Z(7*w-1 downto 6*w);
ZS(8) <= Z(8*w-1 downto 7*w);

process(CLK,RESETN)
variable i     : integer range 3 to 515;
variable count : integer;
begin
  if RESETN = '0' then 
     count  := 0;
     STATE  <= S0;
     ARESET <= '0';
     DRESET <= '0';
     SELA   <= '0';
     SELD   <= '0';
     ADDR   <= "0000"; 
     DONE <= '0';
  elsif CLK='1' and CLK'event then 
        case STATE is 
            when S0 =>                
                i:= 515; 
                K2 <=K;
                STATE <= S1; 
            when S1 =>   
                -- U <= K(i downto i-3);      
                 case (K2(515 downto 512)) is 
                    when "0100" =>       --- select P at ADDR = 000
                         ADDR   <= "0000";
                         STATE  <= S2;
                    when "0001" =>       -- select Q at ADDR 001
                         ADDR   <= "0001";               
                         STATE  <= S2; 
                    when "0101" =>       -- select P+Q at ADDR 100
                          ADDR  <= "0100"; 
                          STATE <= S2;
                    when others =>
                          STATE <= S1; 
                    end case;                
                    if i >=4 then
                       i:= i -4;
                       K2(515 downto 0) <= K2(511 downto 0)&"0000";
                    else
                       STATE <= S6;  
                    end if;
            when S2 =>           ----- first doubling
                 SELD  <='0';    ----- ROM OUTPUT to ECPD 
                 STATE <= S3;
            when S3 => 
                 DRESET  <= '1'; ------ START DOUBLING
                 if count = DPERIOD  then 
                    count := 0;
                    STATE <= S4;
                 else 
                   count := count+1;
                 end if;
            when S4 =>   
                   SELD   <= '1'; 
                   DRESET <='0'; 
                   --U <= K(i downto i-3);
                   --V    <= i;       
                   case K2(515 downto 512) is
                           when "0000" =>
                                SELA <= '0'; 
                               -- DRESET <='0'; 
                                if i>= 4 then 
                                   i:=i-4; 
                                   K2(515 downto 0) <= K2(511 downto 0)&"0000";
                                   STATE <= S3;
                                else 
                                  STATE <= S6;
                                end if;      
                           when "0100"=> 
                                 SELA <= '1';
                                 ADDR <= "0000";     
                                 STATE <= S5;
                           when "0001"  => 
                                 SELA <= '1';
                                 ADDR <= "0001";
                                 STATE <= S5;
                           when "1000" =>
                                 SELA <= '1';
                                 ADDR <= "0010";
                                 STATE <= S5;
                           when "0010"=> 
                                 SELA <= '1';
                                 ADDR <= "0011";
                                 STATE <= S5;
                           when "0101" => 
                                 SELA <= '1';
                                 ADDR <= "0100";
                                 STATE <= S5;
                           when "0110" =>
                                 SELA <= '1'; 
                                 ADDR <= "0101";
                                 STATE <= S5;
                          when "1001" => 
                                 SELA <= '1';
                                 ADDR <= "0110";
                                 STATE <= S5;
                          when "1010" =>  
                                 SELA <= '1';                               
                                 ADDR <= "0111";
                                 STATE <= S5;
                          when others=> 
                                 ADDR <= "1111";
                   end case;   
                                                          
            when S5 => 
                -- V<= i;
                 --DRESET <= '0';
                 ARESET <= '1'; 
                 if count = APERIOD  then 
                    count := 0;
                    if i >= 4 then
                       i:=i-4;
                        K2(515 downto 0) <= K2(511 downto 0)&"0000";
                       SELA <= '1';
                       SELD <= '1';
                       STATE <= S3;
                       ARESET <= '0';
                    else 
                       STATE <= S6;
                    end if;    
                 else 
                   count := count+1;
                 end if;
             when S6 => 
                ARESET <='0';
                DRESET <='0';
                DONE <= '1';                
     end case;           
end if;
end process;
end Behavioral;
