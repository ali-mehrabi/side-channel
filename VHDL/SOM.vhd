----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.06.2018 12:46:57
-- Design Name: 
-- Module Name: SOMR - Behavioral
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


entity SMR is
Port ( 
      CLK   : IN std_logic;
      RESETN: IN std_logic;
      Ai    : IN type_RNS;
      Zi    : OUT type_RNS
      );
end SMR;

architecture Behavioral of SMR is
type     type_STATE is (T01,T02,T03,T04,T05,T06,T07,T08,T09,T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T20,T21,T22);
type     type_ST    is (S01,S02,S03,S04,S05,S06,S07,S08,S09,S10,S11,S12,S13,S14,S15,S16,S17);--,S18,S19,S20,S21,S22);
constant DELTA               :  std_logic_vector(4 downto 0) :="10000";
signal   STATE               :  type_STATE;
signal   ST                  :  type_ST;
signal   G1,G2               :  std_logic_vector(w-1   downto 0);
signal   Alpha               :  std_logic_vector(c-2   downto 0);
signal   ENY,CLKY            :  std_logic;
signal   AL,ALP              :  std_logic_vector(10     downto 0);
signal   K1_REG,K2_REG,K1,K2 :  std_logic_vector(2*w-15 downto 0);  -- 118 bits
signal   K_SUM               :  std_logic_vector(2*w-14 downto 0);  -- 132 bits
signal   K_ACCU              :  std_logic_vector(2*w-11 downto 0);  -- 121 bits
--signal   K                   :  std_logic_vector(w-15   downto 0);  --just for test
signal   UD1,UD2             :  std_logic_vector(w-15    downto 0);
signal   AlphaD,KM           :  type_RNS;
signal   SU                  :  type_RNS;
signal   A1,A2,B1,B2,M1,M2   :  type_RNS;
signal   Gamma               :  type_RNS;
signal   YI1,YI2             :  type_RNS;
signal   ARNS,BRNS,SRNS      :  type_RNS;
signal   Y_ACCU              :  type_YACU;
signal   YI_REG              :  type_YSUM;
----------------------------------------------------------------------------
component RNSMULT is 
Port ( A,B: IN  type_RNS;
       M  : OUT type_RNS
      );
end component RNSMULT;
----------------------------------------------------------------------------
component ACCU is
Port ( CLK : in std_logic;
       RST :  in std_logic;
       A   :  in type_YSUM;
       ACC :  inout type_YACU
      );
end component ACCU;
----------------------------------------------------------------------------
component CSA is
generic( N : integer := 66);
Port (A1,A2,A3,A4,A5,A6,A7,A8 : in std_logic_vector(N-1 downto 0);
      S                       : out std_logic_vector(N+2 downto 0)
      );
end component CSA;
----------------------------------------------------------------------------
component BSUM is
Port (A1,A2 : in  type_RNS;
      S     : out type_YSUM );
end component BSUM;
----------------------------------------------------------------------------
component SCMULT is
Port ( A : in  std_logic_vector(w-1    downto 0);
       B : in  std_logic_vector(w-15   downto 0);
       E : out std_logic_vector(2*w-15 downto 0)
       );
end component SCMULT;
----------------------------------------------------------------------------
component KSUM  is
Port ( A1,A2: in   std_logic_vector(2*w-15 downto 0);
       S    : out  std_logic_vector(2*w-14 downto 0)
       );
end component KSUM;
----------------------------------------------------------------------------
component RNSSUM is
Port ( A,B: IN  type_RNS;
       S  : OUT type_RNS
     );
end component RNSSUM;
----------------------------------------------------------------------------

begin
----------------------------------------------
-- CUNCURRENT ASSIGNMENTS
----------------------------------------------

U01: RNSMULT  port map(A=> A1, B=>B1, M=>M1);
U02: RNSMULT  port map(A=> A2, B=>B2, M=>M2);
U03: CSA      generic map(8) port map(
     A1=> Gamma(1)(w-1 downto w-8), A2=> Gamma(2)(w-1 downto w-8), A3=> Gamma(3)(w-1 downto w-8),
     A4=> Gamma(4)(w-1 downto w-8), A5=> Gamma(5)(w-1 downto w-8), A6=> Gamma(6)(w-1 downto w-8),
     A7=> Gamma(7)(w-1 downto w-8), A8=> Gamma(8)(w-1 downto w-8), S=> AL);      
U05: BSUM     port map (A1=> YI1, A2=> YI2, S => YI_REG);
U06: ACCU     port map (CLK => CLKY, RST =>RESETN, A => YI_REG, ACC=> Y_ACCU);
U07: SCMULT   port map (A => G1, B => UD1, E=> K1); 
U08: SCMULT   port map (A => G2, B => UD2, E=> K2); 
U09: KSUM     port map (A1=> K1_REG, A2=> K2_REG, S=> K_SUM);
U10: RNSSUM   port map (A => ARNS, B=> BRNS, S => SRNS);
Alpha <= ALP(10 downto 8);  
----------------------------------------------------------------------------
STATE_MACHINE:  
process(CLK,RESETN)
begin 
if RESETN='0' then 
   STATE  <= T01;
   A1     <= (others=>(others=>'0'));
   A2     <= (others=>(others=>'0'));
   B1     <= (others=>(others=>'0'));
   B2     <= (others=>(others=>'0'));
   AlphaD <= (others=>(others=>'0'));
   SU     <= (others=>(others=>'0'));
   ARNS   <= (others=>(others=>'0'));
   BRNS   <= (others=>(others=>'0'));
   Zi     <= (others=>(others=>'0'));
   ALP    <= (others=>'0');
   G1     <= (others=>'0');
   G2     <= (others=>'0');
   UD1    <= (others=>'0');
   UD2    <= (others=>'0');
   ENY    <= '0';
 --  CLKY   <= '0';
elsif CLK='1' and CLK'event then 
  case STATE is 
       when T01 => 
            A1 <= Ai;
            B1 <= DINV;
            ENY<='1';
            STATE <= T02;
       when T02 => 
            STATE <= T03;
       when T03 =>
           -- Gamma<= M1; 
            STATE <= T04;     
       when T04 =>      
            A1  <= (others => Gamma(1));
            B1  <= DiMmj(1);
            A2  <= (others => Gamma(2));
            B2  <= DiMmj(2);
            G1  <= Gamma(1);
            G2  <= Gamma(2);
            UD1 <= UDIM(1);
            UD2 <= UDIM(2);       
            STATE <= T05;  
       when T05 => -------------------------------------------      
            STATE <= T06; 
       when T06 =>  
          --  CLKY <= '1';  
            ALP <= AL + DELTA;       
            STATE <= T07; 
       when T07 => 
            A1  <= (others => Gamma(3));
            B1  <= DiMmj(3);
            A2  <= (others => Gamma(4));
            B2  <= DiMmj(4);
            G1  <= Gamma(3);
            G2  <= Gamma(4);
            UD1 <= UDIM(3);
            UD2 <= UDIM(4);  
          --  CLKY <= '0';  
            STATE <= T08;   
       when T08 =>    
            STATE <= T09; 
       when T09 => 
            if (Alpha = "000" or Alpha > "111" ) then 
                alphaD <= (others=>(others=>'0')); 
            else 
                alphaD <= Read_MDMmi(Alpha);  
            end if;    
          --  CLKY  <= '1';                                  
            STATE <= T10;    
       when T10 => 
            A1  <= (others => Gamma(5));
            B1  <= DiMmj(5);
            A2  <= (others => Gamma(6));
            B2  <= DiMmj(6); 
            G1  <= Gamma(5);
            G2  <= Gamma(6);
            UD1 <= UDIM(5);
            UD2 <= UDIM(6);  
          --  CLKY <= '0';        
            STATE <= T11; 
       when T11 =>                              
            STATE <= T12;            
       when T12 =>   
         --   CLKY <= '1';
            STATE <= T13; 
       when T13 => ------------------------------------------- 
            A1  <= (others => Gamma(7));
            B1  <= DiMmj(7);
            A2  <= (others => Gamma(8));
            B2  <= DiMmj(8);
            G1  <= Gamma(7);
            G2  <= Gamma(8);
            UD1 <= UDIM(7);
            UD2 <= UDIM(8);  
         --   CLKY <= '0';         
            STATE <= T14; 
       when T14 =>           
            STATE <= T15;          
       when T15 =>      
         --   CLKY <= '1';
            STATE <= T16;
       when T16 =>    
          --  CLKY <= '0';
            STATE <= T17;       
       when T17 => --------------------------------------------  
            A2 <= (others =>("00000000000000"&K_ACCU(2*w-12 downto w+3)));
            B2 <= NI;   --------- calculate -KM
            STATE <= T18;       
       when T18 =>
            YRNS(Y_ACCU,SU); 
            STATE <= T19;       
       when T19 => 
            ARNS <= AlphaD;
            BRNS <= SU;
            STATE <= T20; 
       when T20 =>
            ARNS <= SRNS;
            BRNS <= M2;
            STATE <= T21;       
       when T21 => --------------------------------------------
            Zi <= SRNS;
            STATE <= T22;                  
       when T22 =>
            STATE <= T22;    
 end case;                              
end if;         
end process;
----------------------------------------------------------------------------
STATE_MACHINE2:  
process(CLK,RESETN)
begin 
if RESETN='0' or ENY = '0' then 
   ST      <= S01;
   Gamma   <= (others=>(others=>'0'));
  -- Zi      <= (others=>(others=>'0'));
   YI1     <= (others=>(others=>'0'));
   YI2     <= (others=>(others=>'0'));
   KM      <= (others=>(others=>'0'));
   K1_REG   <= (others=>'0');
   K2_REG   <= (others=>'0');
   K_ACCU  <= (others=>'0');
   CLKY <='0';
  -- K       <= (others=>'0');
elsif CLK = '0' and CLK'event then 
case ST is 
     when S01 => 
          ST <= S02;
     when S02 => 
          ST <= S03;          
     when S03 => 
          Gamma <= M1; ----------------
          ST <= S04;
     when S04 => 
          ST <= S05;
     when S05 => 
          ST <= S06;
     when S06 => 
          YI1 <= M1;----------------------------
          YI2 <= M2;
          K1_REG<= K1;
          K2_REG<= K2;
          CLKY <='1';
          ST <= S07;  
     when S07 => 
          K_ACCU <= K_ACCU+ K_SUM;
          CLKY <='0';
          ST <= S08;
     when S08 => 
          ST <= S09;          
     when S09 => 
          YI1 <= M1;----------------------------
          YI2 <= M2;           
          K1_REG<= K1;
          K2_REG<= K2; 
          CLKY <='1';
          ST <= S10;
     when S10 => 
          K_ACCU <= K_ACCU+ K_SUM;
          CLKY <='0';
          ST <= S11;
     when S11 => 
          ST <= S12;
     when S12 => 
          YI1 <= M1;----------------------------
          YI2 <= M2;           
          K1_REG<= K1;
          K2_REG<= K2; 
          CLKY <='1';
          ST <= S13; 
     when S13 => 
          K_ACCU <= K_ACCU+ K_SUM; 
          CLKY <='0';
          ST <= S14; 
     when S14 => 
          ST <= S15;
     when S15 => 
          YI1 <= M1;----------------------------
          YI2 <= M2;           
          K1_REG<= K1;
          K2_REG<= K2; 
          CLKY <='1';
          ST <= S16; 
     when S16 => 
          K_ACCU <= K_ACCU+ K_SUM;
          CLKY <='0';
          ST <= S17;
     when S17 =>
        -- K <= K_ACCU(2*w-12 downto w+3);
          ST <= S17; 
 --    when S18 => 
 --         ST <= S19; 
 --    when S19 => 
 --         ST <= S20;
 --    when S20 => 
 --         ST <= S21; 
 --    when S21 => 
 --         ST <= S22;          
 --    when S22 => 
 --         ST<=S22;
end case;
end if;  
end process;
                                                                                                                                               
end Behavioral;
