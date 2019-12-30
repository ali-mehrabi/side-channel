----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2019 11:49:21
-- Design Name: 
-- Module Name: ARITH - Behavioral
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

entity ARITH is
Port (CLK   :     in  std_logic;
      ARESETN:    in  std_logic;
      DRESETN:    in  std_logic;
      XP,YP,ZP:   in  type_RNS;
      X1A,Y1A,Z1A:   in  type_RNS;
      X2A,Y2A,Z2A:   in  type_RNS;
      XOP,YOP,ZOP:   out type_RNS;
      XOA,YOA,ZOA:   out type_RNS
      );
end ARITH;

architecture Behavioral of ARITH is


constant n : integer := 22;
type   TYPE_STATE is 
(S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20,S21,S22,S23,S24,S25,S26,S27,S28,S29,S30,S31,S32,S33,
S34,S35,S36,S37,S38,S39,S40,S41,S42,S43,S44,S45,S46,S47,S48,S49,S50,S51,S52,S53,S54,S55,S56,S57,S58,S59,S60,S61,S62,S63,S64,S65,
S66,S67,S68,S69,S70,S71,S72,S73,S74,S75,S76,S77,S78,S79,S80,S81,S82,S83);
type TYPE_P is (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,
P31,P32,P33,P34,P35,P36,P37,P38,P39,P40,P41,P42,P43,P44,P45);


signal  STATE: TYPE_STATE;
signal  PS:     TYPE_P;
signal  X1,Y1,Z1,Z12,Z13   :    type_RNS;
signal  X2,Y2,Z2,Z22,Z23   :    type_RNS;
signal  X11,Y11,Z11        :    type_RNS;
signal  X21,Y21            :    type_RNS;
signal  M1Ai,M1Bi,M1Mi     :    type_RNS;   
signal  M2Ai,M2Bi          :    type_RNS;
signal  A1Ai,A1Bi,A1Ci     :    TYPE_RNS;
signal  S1Ai,S1Bi,S1Si     :    TYPE_RNS;
signal  A2Ai,A2Bi          :    TYPE_RNS;
signal  S2Ai,S2Bi          :    TYPE_RNS;
signal  M1A,M1B            :    type_RNS;
signal  A1A,A1B            :    type_RNS;
signal  S1A,S1B            :    type_RNS;
signal  XIND,XINA,XIN,XOUT1:    TYPE_RNS;
signal  RUNPMRD,RUNPMRA,RUNPMR: std_logic;



component RNSMULT is
Port (A:    in  TYPE_RNS;
      B:    in  TYPE_RNS;
      M:    out TYPE_RNS
     );
end component RNSMULT;

component RNSSUM is
Port (A:    in  TYPE_RNS;
      B:    in  TYPE_RNS;
      S:    out TYPE_RNS
     );
end component RNSSUM;

component RNSSUB is
Port (A:    in  TYPE_RNS;
      B:    in  TYPE_RNS;
      S:    out type_RNS
     );
end component RNSSUB;

component SMR is
Port ( 
      CLK   : IN std_logic;
      RESETN: IN std_logic;
      Ai    : IN type_RNS;
      Zi    : OUT type_RNS
      );
end component SMR;

begin
UMRR1 : SMR port map(CLK=>CLK,RESETN=>RUNPMR,AI=>XIN,ZI=>XOUT1);   -- Modular reduction X
UMUL1 : RNSMULT   port map (A=>M1A,B=>M1B,M=>M1Mi);
UADD1 : RNSSUM    port map (A=>A1A,B=>A1B,S=>A1Ci);
USUB1 : RNSSUB    port map (A=>S1A,B=>S1B,S=>S1Si);
--UMUL2 : RNSMULT   port map (A=>M2Ai,B=>M2Bi,M=>M2Mi);
--UADD2 : RNSSUM    port map (A=>A2Ai,B=>A2Bi,S=>A2Ci);
--USUB2 : RNSSUB    port map (A=>S2Ai,B=>S2Bi,S=>S2Si);
XIN   <= XIND     when ARESETN='0' else XINA;
M1A   <= M1Ai     when ARESETN='0' else M2Ai;
M1B   <= M1Bi     when ARESETN='0' else M2Bi;
A1B   <= A1Bi     when ARESETN='0' else A2Bi; 
A1A   <= A1Ai     when ARESETN='0' else A2Ai;
S1B   <= S1Bi     when ARESETN='0' else S2Bi; 
S1A   <= S1Ai     when ARESETN='0' else S2Ai; 
RUNPMR <= RUNPMRD when ARESETN='0' else RUNPMRA;

ECPD:
process(CLK,DRESETN)
variable count : integer range 0 to 24;
begin
  if DRESETN='0' then  
     count:=0;
     PS <=P0;  
     RUNPMRD <= '0';   
  elsif CLK='1' and CLK'event then 
        case PS is 
            when P0 => 
                 X11<=XP;                       -- register input coordinates;
                 Y11<=YP;                       --
                 Z11<=ZP;                       --                         
                 PS <= P1;           
            when P1 =>                          
                 M1Ai<=Y11;  M1Bi<=Y11;           -- product Y11^2 in M1Mi
                 PS <= P2;
            when P2 =>  
                 PS <= P3;                   -- wait for results get ready;
            when P3 => 
                 XIND   <= M1Mi;                  -- Calculate (Y11^2)
                 PS <= P4;
            when P4 =>  
                 RUNPMRD <= '1'; 
                 M1Ai<=X11;  M1Bi<=X11;     
                 PS <= P5;           
            when P5 =>                  
                 PS <= P6;                   -- Wait
            when P6 => 
                 X21 <= M1Mi;                    -- X21= X11^2
                 PS <= P7;
            when P7 => 
                 A1Ai <= X21; A1Bi<= X21;         -- calculate 2*X21^2
                 M1Ai <= Y11; M1Bi<= Z11;         -- calculate  Y1Z1
                 PS <= P8; 
            when P8 =>                 
                 PS <= P9;   
            when P9 => 
                 X11 <= A1Ci; -- X11 = 2X^2    
                 Z11 <= M1Mi;                                      
                 PS <= P10;
            when P10 => 
                 A1Ai <= X21; 
                 A1Bi<= X11;         -- calculate 3*X21^2                                                    
                 PS <= P11;     
            when P11 =>  
                 X21 <= A1Ci;    ----- 3X^2 = A                
                 PS <= P12; 
            when P12 =>  
                 A1Ai <= Z11; 
                 A1Bi <= Z11;         -- calculate 2*Z1Y1     
                 PS <= P13;
            when P13 =>
                 Z11 <= A1Ci;
                 PS <=P14;     
            when P14 => 
                 if count <n-10 then    ---- count? 
                    count :=count+1;
                 else 
                    count :=0;
                    PS <= P15;    
                    Y11 <= XOUT1;                -- Y11^2 mod p  
                 end if; 
            when P15 =>   
                 RUNPMRD <='0';
                 XIND <= X21; 
                 A1Ai <= Y11; 
                 A1Bi  <= Y11;         -- calculate 2*Y11^2
                 PS <= P16;           
            when P16 => 
                 RUNPMRD <= '1';
                 Y11 <= A1Ci;
                 PS <= P17;
            when P17 => 
                 M1Ai <= X11;
                 M1Bi <= Y11;  --- 2X1Y1^2
                 PS <= P18;
           when  P18 =>    
                 PS<= P19;
           when  P19 => 
                 X11 <= M1Mi;
                 PS <= P20;      
           when  P20 =>  
                 A1Ai <= X11; 
                 A1Bi  <= X11; -- 4X1Y1^2
                 M1Ai <= Y11;
                 M1Bi <= Y11;  ---  4Y1^4
                 PS <= P21; 
           when P21 =>    
                X21 <= A1Ci;  -- 4X1Y1^2             
                PS <= P22;
           when P22 => 
                Y11 <=  M1Mi;  -- 4Y1^4               
                PS <= P23;
           when P23 => 
                A1Ai <= X21; 
                A1Bi  <= X21; -- 4X1Y1^2 
                PS <= P24; 
           when P24 => 
                X11 <= A1Ci; -- 8X1Y1^2
                PS <= P25; 
           when P25 => 
                A1Ai <= Y11; 
                A1Bi  <= Y11; -- 4Y1^4 
                PS <= P26; 
           when P26 => 
                Y11 <= A1Ci;
                PS <= P27;
           when P27 =>  
                 if count < 11 then    ---count ?   
                    count :=count+1;
                 else 
                    count :=0;
                    PS <= P28; 
                    Y21 <= XOUT1;       ---   A=3X1^2 in Y21
                 end if;                                       
            when P28 => 
                 RUNPMRD <='0';         
                 M1Ai <= Y21;
                 M1Bi <= Y21; --- A^2
                 PS <= P29;                         
            when P29 =>   
                 PS <= P30;
            when P30 =>  
                 S1Ai <= M1Mi;
                 S1Bi <= X11;
                 PS <= P31;
            when P31 =>  
                 XIND <= S1Si;
                 PS <= P32;                
            when P32 =>      
                 RUNPMRD <='1';                      -- wait for multiplication     
                 PS <= P33;
            when P33 =>   
                 if count < 21 then 
                    count :=count+1;
                 else 
                    count :=0;   
                    PS <= P34;  
                    X11 <= XOUT1;   ------ XO in X11
                 end if;        
             when P34 => 
                  RUNPMRD <='0'; 
                  S1Ai <= X21;  --- 4X1Y1^2 - XO
                  S1Bi <= X11;     
                  PS <= P35; 
             when P35 =>  
                   XIND <= S1Si; 
                   PS <= P36;                                  
             when P36 =>                             
                  RUNPMRD <='1';                
                  if count < 22 then 
                     count:=count+1;
                  else 
                     count :=0;      
                     X21<= XOUT1;  ------   D= C-XO  in X21            
                     PS <= P37; 
                  end if;
             when P37 => 
                  M1Ai <= Y21;
                  M1Bi <= X21;
                  PS <= P38;
                  RUNPMRD <= '0';
             when P38 => 
                  PS <= P39;
             when P39 => 
                  S1Ai <= M1Mi;
                  S1Bi <= Y11; 
                  PS <= P40;
             when P40 => 
                  XIND <= S1Si;
                  PS <= P41; 
             when P41 =>
                  RUNPMRD <= '1'; 
                  PS <= P42; 
             when P42 => 
                  if count < 21 then    ---count ?   
                     count :=count+1;
                  else 
                      count :=0;
                      PS <= P43; 
                      YOP <= XOUT1;       ---  
                      XOP <= X11;
                  end if;                    
             when P43 => 
                  RUNPMRD <= '0';
                  XIND <= Z11;
                  PS <= P44;
             when P44 =>   
                  RUNPMRD <= '1';   
                  if count < 22 then    ---count ?   
                     count :=count+1;
                  else 
                     count :=0;
                     PS <= P45; 
                     ZOP <= XOUT1;       --- 
                  end if;    
             when P45 =>
                   PS <= P45; 
             end case;                       
end if;   
end process;              


-------------------------------------------------------------------
-------------------------------------------------------------------
ECPA: 
process(CLK,ARESETN)
variable count : integer range 0 to 21;
begin
  if ARESETN = '0' then  
     count:=0;
     STATE<=S0;
     RUNPMRA <= '0';
  elsif CLK='1' and CLK'event then 
        case STATE is 
            when S0 => 
                 count := 0;
                 X1<=X1A;                       -- register input coordinates;
                 Y1<=Y1A;                       --
                 Z1<=Z1A;
                 X2<=X2A;
                 Y2<=Y2A;
                 Z2<=Z2A;                       --                         
                 STATE <= S1;           
            when S1 =>                          -- Z1^2
                 M2Ai<=Z1;  M2Bi<=Z1;           -- product Z1^2 in M1Mi     
                 STATE <= S2;
            when S2 =>  
                 STATE <= S3;                   -- wait for results get ready;
            when S3 => 
                 XINA  <= M1Mi;                  -- Calculate Z1^2 reduction
                 STATE <= S4;
            when S4 =>                          -- Start Modular reduction for Z1^2    
                 RUNPMRA <= '1';                 -- Calculate Z1^2 reduction
                 STATE <= S5; 
            when S5 => 
                 M2Ai<=Z2;  M2Bi<=Z2;            -- Z2^2 
                 STATE <= S6; 
            when S6 => 
                 STATE <= S7; 
            when S7 => 
                 Z22 <= M1Mi;                   -- Z22 <- Z2^2
                 STATE <= S8; 
            when S8 => 
                 M2Ai<=Z1;  M2Bi<=Z2;           -- Z1 <- Z1Z2 
                 STATE <= S9;
            when S9 => 
                 STATE <= S10;
            when S10 =>
                 Z1 <= M1Mi;                     
                 STATE <= S11;
            when S11 =>                                                      
                 if count < n-7 then     
                    count :=count+1;
                 else 
                    count :=0;
                    STATE <= S12; 
                    Z12 <= XOUT1;                 --  Z12 <- (Z1^2 mod M) 
                 end if;                
            when S12 => 
                 RUNPMRA <='0';
                 M2Ai<=Z1;  M2Bi<=Z12;           -- product Z1^3 in M1Mi
                 XINA<= Z22;
                 STATE <= S13;                   --- Z22 mod p
            when S13 => 
                 RUNPMRA <= '1';
                 STATE <= S14;                    -- Wait for multiplication result
            when S14 => 
                 Z13 <= M1Mi;                    -- Z13 <- Z1^3
                 STATE <= S15; 
            when S15 => 
                 if count < n-2 then     
                    count :=count+1;
                  else 
                    count :=0;
                    STATE <= S16; 
                    Z22 <= XOUT1;                 --  Z22 <- (Z2^2 mod p) 
                   end if;                  
            when S16 =>    
                 XINA <= Z13;                    --  Z13 <-- Z1^3
                 RUNPMRA <= '0';
                 STATE <= S17;
            when S17 => 
                 RUNPMRA <= '1'; 
                 M2Ai<=Z2;  M2Bi<=Z22;           
                 STATE <= S18;
            when S18 =>
                 STATE <= S19;
            when S19 =>
                 Z23 <= M1Mi;                   --  Z23 <- Z2^3 
                 STATE <= S20;
            when S20 => 
                 STATE <= S21;      
            when S21 => 
                 if count < n-4  then     
                    count :=count+1;
                  else 
                    count :=0;
                    STATE <= S22; 
                    Z13 <= XOUT1;                 --Z13 <- (Z2^3 mod M) 
                  end if;                 
              when S22 => 
                   RUNPMRA <= '0';
                   XINA <= Z23;                               
                   STATE <= S23; 
              when S23 =>    
                   RUNPMRA <='1';
                   STATE   <= S24;
              when S24 =>      
                   if count < n-1 then     
                      count :=count+1;
                   else 
                     count :=0;
                     STATE <= S25; 
                     Z23 <= XOUT1;              --Z23 <- (Z2^3 mod M) 
                   end if;                 
              when S25 => 
                   RUNPMRA <='0';
                   XINA <= Z1;                -- Z1 <- Z1Z2
                   M2Ai <= Y1;
                   M2Bi <= Z23;
                   STATE   <= S26; 
              when S26 => 
                   RUNPMRA <= '1';
                   STATE <= S27; 
              when S27 => 
                   Y1 <= M1Mi;   ---  Y1  = B1
                   STATE <= S28;
              when S28 => 
                   M2Ai <= X1;    ---- 
                   M2Bi <= Z22;
                   STATE <= S29;
              when S29 => 
                   STATE <= S30;
              when S30 => 
                   X1 <= M1Mi;    --- X1 = C1
                   STATE <= S31;
              when S31 => 
                   M2Ai <= X2;
                   M2Bi <= Z12;
                   STATE <= S32;
              when S32 => 
                   STATE <= S33;
              when S33 => 
                   X2 <= M1Mi;    --- X2 = C2
                   STATE <= S34;                   
              when S34=> 
                   M2Ai <= Y2;
                   M2Bi <= Z23;
                   STATE <= S35;
              when S35 => 
                   STATE <= S36;
              when S36=> 
                   Y2 <= M1Mi;   --- Y2 = B2
                   STATE <= S37;                  
              when S37 =>     
                   S2Ai <= X2;   ---  X2 = C2-C1 = D2
                   S2Bi <= X1; 
                   STATE <= S38;
              when S38 => 
                   X2 <= S1Si;
                   STATE <= S39; 
              when S39 => 
                   S2Ai <= Y2;
                   S2Bi <= Y1; 
                   STATE <= S40; 
              when S40 => 
                   Y2 <= S1Si;    -- Y2 = B2-B1 = D1
                   STATE <= S41; 
              when S41 =>                                                                                           
               if count < n-15 then     
                  count :=count+1;
               else 
                  count :=0;
                  STATE <= S42; 
                  Z1 <= XOUT1;  -----Z1.Z2 
               end if; 
            when S42 =>    
                 RUNPMRA <= '0'; 
                 XINA <= X2;   ------ (C2-C1) mod p 
                 STATE <= S43;
            when S43 => 
                  RUNPMRA <= '1';
                  if count < n then     
                     count :=count+1;
                   else 
                     count :=0;
                     STATE <= S44; 
                     X2 <= XOUT1;   -- X2 = D2 mod p               
                   end if; 
            when S44 =>
                   RUNPMRA <= '0';
                   XINA <= Y2;
                   STATE <= S45;
            when S45 =>  
                   RUNPMRA <= '1';
                   M2Ai <= Z1;
                   M2Bi <= X2;
                   STATE <= S46;                                                  
            when S46 => 
                   STATE <= S47;
            when S47 =>  
                   Z1 <= M1Mi;    ----- Z1 =  Z1 X2
                   STATE <= S48;                    
             when S48 => 
                  M2Ai <= X2;   -----  Z22 =  D2^2 
                  M2Bi <= X2;      
                  STATE <= S49;                      
             when S49 => 
                  STATE <= S50;
             when S50 => 
                  STATE <= S51; 
                  Z22 <= M1Mi; ----- Z22 <- D2 ^2                      
            when S51 =>              
                 if count < n-6 then     
                    count :=count+1;
                 else 
                    count :=0;
                    STATE <= S52; 
                    Y2 <= XOUT1;   ----  Y2 <-  D1 mod p               
                 end if;                
            when S52 =>  
                    RUNPMRA <= '0';
                    XINA <= Z22;      ---  E2 = D2^2  mod p
                    M2Ai <= Y2;
                    M2Bi <= Y2;
                    STATE <= S53;                                                  
              when S53=> 
                   RUNPMRA <= '1';
                   STATE <= S54;
              when S54 => 
                   Y2 <= M1Mi;   -----  E1 == D1^2  in Y2    
                   STATE <= S55;              
              when S55 => 
                      if count < n-2 then     
                         count :=count+1;
                      else 
                         count :=0;
                         STATE <= S56; 
                         Z22 <= XOUT1;   ----E2 == D2 ^2 mod p in Z22              
                      end if;                             
              when S56 =>
                      RUNPMRA <= '0';
                      M2Ai <= X2;   ---   F2 = D2 E2                             
                      M2Bi <= Z22; 
                      XINA <= X1;  ---  C1 mod p 
                      STATE <= S57; 
              when S57 =>
                      RUNPMRA <='1';
                      if count < n then 
                         count := count+1;
                      else 
                         count := 0;  
                         X1 <= XOUT1;  
                         STATE <= S58;
                      end if;                      
              when S58 => 
                      RUNPMRA <='0';
                      XINA <= M1Mi; 
                      STATE <= S59; 
              when S59 =>
                      RUNPMRA <= '1';
                      M2Ai <= X1; ---- F1  == C1 E2 
                      M2Bi <= Z22; 
                      STATE <= S60;                        
              when S60 => 
                      STATE <= S61;
              when S61 =>         
                      Z13 <= M1Mi;   ----  F1 = Z13
                      STATE <= S62;
              when S62 =>                        
                   if count < n- 3 then     
                      count :=count+1;
                    else 
                    count :=0;
                    STATE <= S63; 
                    Z23   <= XOUT1;             -- F2 in Z23, F1 in Z13 
                 end if;
            when S63 => 
                 RUNPMRA <='0';                 -- reset Modular reduction
                 A2Ai    <= Z13; 
                 A2Bi    <= Z13; 
                 STATE   <= S64; 
            when S64 => 
                 A2Ai <= A1Ci;   -----      
                 A2Bi <= Z23;    ----- F2 + 2F1
                 STATE <= S65;                  
            when S65  =>
                 S2Ai <= Z12;    ----   E1 - G1   
                 S2Bi <= A1Ci;   --- G1 in A1Ci
                 STATE <= S66; 
            when S66 => 
                 XINA <= S1Si;   --- E1-G1
                 STATE <= S67; 
            when S67 => 
                 RUNPMRA <= '1'; 
                 STATE <= S68; 
            when S68 =>                
                 if count < n-1  then 
                    count :=count+1;
                 else 
                    count :=0;   
                    STATE <= S69;  
                    X2 <= XOUT1;     ---- X2 == X3         
                 end if;        
             when S69 =>
                 RUNPMRA <='0';
                 S2Ai <= Z13;  ----- F2 -XO
                 S2Bi <= X2;
                 STATE <= S70; 
             when S70 => 
                  XINA <= S1Si;  ---- 
                  STATE <= S71; 
             when S71 =>         
                  RUNPMRA <='1'; 
                  if count < n then 
                     count:=count+1;
                  else 
                     count :=0;      
                     Z13 <= XOUT1;              -- G2 in Z13 
                     STATE <= S72; 
                  end if;                                     
             when S72  => 
                  RUNPMRA <= '0';
                  M2Ai <= Z13;   ---- D1 G2
                  M2Bi <= Y2; 
                  STATE <= S73;
             when S73 => 
                  XINA <= Y1;
                  STATE <= S74; 
             when S74 => 
                  RUNPMRA <= '1';
                  Y2 <= M1Mi;  ----- Y2 = D1 G2 
                  STATE <= S75; 
            when S75 => 
                  if count < n-1 then
                     count:=count+1; 
                  else 
                     count :=0;      
                      Y1 <= XOUT1;      ---- B1 = Y1 mod p 
                      STATE <= S76; 
                   end if;                  
            when S76 => 
                  RUNPMRA <= '0'; 
                  XINA <= Z1; 
                  M2Ai <= Y1;
                  M2Bi <= Z23;  -----  B1F2 
                  STATE <= S77; 
            when S77 => 
                 RUNPMRA <= '1'; 
                 STATE <= S78;
            when S78 => 
                 S2Ai <= Y2;  ----  D1G2 - B1F2
                 S2Bi <= M1Mi; 
                 STATE <= S79; 
           when  S79 =>   
                 Z2 <= S1Si;   ----- Z2 =  D1G2 - B1F2 
                 STATE <= S80; 
           when S80 =>         
           if count < n-3 then
              count:=count+1; 
           else 
              count :=0;      
              ZOA <= XOUT1;             
              STATE <= S81; 
           end if; 
           when S81 =>                 
                XINA <= Z2; 
                RUNPMRA <= '0';          
                STATE <= S82; 
           when S82 => 
                  RUNPMRA <= '1';          
                  if count < n then
                     count:=count+1; 
                  else 
                     count :=0;      
                     YOA <= XOUT1;   --Y3 in Y2
                     XOA <= X2;
                     STATE <= S83; 
                  end if; 
             when S83 => 
                  RUNPMRA <= '0';                                                                                                                                                                                 
  end case;     
end if;   
end process;              
end Behavioral;


--   Z12 <- (Z1Z1)    
--   Z13 <- (Z12 Z1)
--   Z22 <- (Z2Z2)   
--   Z23 <- (Z22 Z2)
--   Y1 <- (Y1Z23)    
--   Y2 <-   Y2Z13
--   X2 <- (X2 Z12)   
--   X1 <- (X1 Z22)
--   X2 <- (X2-X1)
--   Y2 <- (Y2-Y1)
--   Z12 <- Y2^2
--   Z22 <- (X2^2)
--   Z13 <- X1Z3
--   Z23 <- X2Z2
--   Z1 <- Z1Z2
--   Z1 <- Z1X2
--   Z2 <-  Z23 + 2 Z13
--   X2 <- Z12 - Z2
--   Z1 <- Z13 - X2)
--   Y2 <- Y2Z1
--   Y1 <- Y1Z23
---  YO <- Y2-Y1
---  XO <- X2
--   