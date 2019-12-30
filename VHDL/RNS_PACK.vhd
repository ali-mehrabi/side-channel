----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.06.2018 10:37:29
-- Design Name: 
-- Module Name: RNS_PACKAGE - Behavioral
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use IEEE.std_logic_arith.all; --for converting from integer to std_logic_vector
use IEEE.std_logic_unsigned.all; -- for multiply operation

package RNS_PACKAGE is

constant w              : INTEGER := 66;
constant channel_width  : INTEGER := w;
constant total_channels : INTEGER := 8; 
constant c              : INTEGER := 4;  -- counter bit length for range 1 to 28

constant KEY            : std_logic_vector(255 downto 0) := X"8000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001";
--------------------------------------- TYPE declaration ----------------------------------
type     type_RNS       is array (1 to total_channels) of std_logic_vector(w-1 downto 0);  -- 66 bits
type     type_UDIM      is array (1 to total_channels) of std_logic_vector(w-15 downto 0); -- 52 bits
type     type_RNS_Table is array (1 to total_channels) of type_RNS;
type     type_YSUM      is array (1 to total_channels) of std_logic_vector(w downto 0);
type     type_YACU      is array (1 to total_channels) of std_logic_vector(w+2 downto 0);
type     type_DRNS      is array (1 to total_channels) of std_logic_vector(2*w-1 downto 0);

---------------------------------------------------------------------------------------------
--moduli set:
--2^66-1     ;  2^66-2^2-1 ;
--2^66-2^3-1 ;  2^66-2^4-1 ;
--2^66-2^5-1 ;  2^66-2^6-1 ;
--2^66-2^8-1;   2^66-2^9-1 ;
--
constant Moduli : type_RNS := ( 
"11"&X"FFFFFFFFFFFFFFFF","11"&X"FFFFFFFFFFFFFFFB",
"11"&X"FFFFFFFFFFFFFFF7","11"&X"FFFFFFFFFFFFFFEF",
"11"&X"FFFFFFFFFFFFFFDF","11"&X"FFFFFFFFFFFFFFBF",
"11"&X"FFFFFFFFFFFFFEFF","11"&X"FFFFFFFFFFFFFDFF"
);

constant DModuli : type_YSUM := ( 
"111"&X"FFFFFFFFFFFFFFFE","111"&X"FFFFFFFFFFFFFFF6",
"111"&X"FFFFFFFFFFFFFFEE","111"&X"FFFFFFFFFFFFFFDE",
"111"&X"FFFFFFFFFFFFFFBE","111"&X"FFFFFFFFFFFFFF7E",
"111"&X"FFFFFFFFFFFFFDFE","111"&X"FFFFFFFFFFFFFBFE"
);
-------------------------------------------------------------------------------------------
constant CModuli : type_RNS := ( 
"00"&X"0000000000000001","00"&X"0000000000000005",
"00"&X"0000000000000009","00"&X"0000000000000011",
"00"&X"0000000000000021","00"&X"0000000000000041",
"00"&X"0000000000000101","00"&X"0000000000000201"
);
-------------------------------------------------------------------------------------------

constant DINV : type_RNS := ( 
"11"&X"FFFFFFFFDFFFFFFF","10"&X"6C1A715B1820059F",
"11"&X"5AA88C14660AFF87","11"&X"6E0A065AC70CC8D4",
"00"&X"B7773DD32BC5056F","01"&X"13815F1861ADB944",
"00"&X"73AA4CA0D49099CD","00"&X"8C9012A978C4D8F2"
);

constant DiMmj : type_Rns_Table:=(
("10"&X"BE698F14B22F6A6B","10"&X"CC87376D7EC5D27F","10"&X"DA365FBC3307AB13","10"&X"F44F315789611FBB","11"&X"2394E04B6D33350B","11"&X"6FC0AB540F94FFAB","11"&X"D3F081BEF90DBF6B","11"&X"EA8E98DC1B2C146B"),
("10"&X"CC87376A914F74C3","10"&X"DA6D5FAC057452D7","10"&X"E7E587EF0DC942EB","11"&X"0191D9793E846B13","11"&X"30048799D8C75963","11"&X"7AA247E9B4BB9E03","11"&X"D819EB5728A119C3","11"&X"ECA81E79CECABEC3"),
("10"&X"DA365F9ECAB96D9B","10"&X"E7E587D5AEE3E12F","10"&X"F52730164E4BB843","11"&X"0E680199DFD9C2EB","11"&X"3C09AEEE351AA83B","11"&X"851D64EAE18AA2DB","11"&X"DBF524AA04D8429B","11"&X"EE9611EB2E67179B"),
("10"&X"F44F3002635124CB","11"&X"0191D8376AD381DF","11"&X"0E68007E2ABF7573","11"&X"26D4D1F8A85B121B","11"&X"52DA7DA86A51BF6B","11"&X"98E6202986C1DA0B","11"&X"E2C70067B5FFF9CB","11"&X"F1F4E188784ECECB"),
("11"&X"2394D0B6CBD97F2B","11"&X"300478E83CE2493F","11"&X"3C09A127BF17CFD3","11"&X"52DA7247DD7B847B","11"&X"7BC01A4CCF46A9CB","11"&X"BBEB9B6BEFF4D46B","11"&X"ED02319A9ED6D42B","11"&X"F6E57E69E5D4292B"),
("11"&X"6FC011D97C9C93EB","11"&X"7AA1BA0448D99FFF","11"&X"851CE23750B8B493","11"&X"98E5B2F9EA4E693B","11"&X"BBEB57CC25721E8B","11"&X"F116BD7BC06BA92B","11"&X"F525259BA7B0E8EB","11"&X"FACD84AD9F853DEB"),
("11"&X"D3C393572D94106B","11"&X"D7F13B678172087F","11"&X"DBD0637985B5D113","11"&X"E2A933B56BBA45BB","11"&X"ECEED51043C6DB0B","11"&X"F51A1F6ED46FA5AB","11"&X"6920A191848A656B","11"&X"FE904BEC7CC0BA6B"),
("11"&X"E91D93A8A9F8B66B","11"&X"EB5B3BB169963E7F","11"&X"ED6A63BAEF53F713","11"&X"F10333D9E6F36BBB","11"&X"F648D48ABB1A810B","11"&X"FA7419D199CA4BAB","11"&X"FE7922910F070B6B","11"&X"13DE3137DB55626C")
);
------------------- BM:= 2^14*M^2 ----------------------------------------------------------
constant BM : type_RNS:=(
"11"&X"FFFFBFFFFF0BC03F","11"&X"FFFFBFFFFF0C5C3B",
"11"&X"FFFFBFFFFF122837","11"&X"FFFFBFFFFF5D502F",
"11"&X"FFFFC0000391E01F","11"&X"FFFFC0004323FFFF",
"11"&X"FFFFC041008CBF3F","11"&X"FFFFC408050DBE3F"

);
--------------------------------------------------------------------------------------
constant UDIM :type_UDIM :=(
X"8017AF3C497FF",X"8015484AC17FF",
X"80131815D97FF",X"800F51B5E97FF",
X"8009E889897FF",X"8005A73EC97FF",
X"80019106497FF",X"8000CCD0497FF"
);
-----------------  M mod mi  ----------------------------------------------------------------
constant MI : type_RNS := (
"00"&X"03FFFFFEFFFFFC2F","01"&X"F3FFFFFEFFFFFC2F",
"11"&X"63FFFFFEFFFFFC41","00"&X"C3FFFFFEFFFFFD72",
"01"&X"83FFFFFF00000E3B","11"&X"03FFFFFF00010C5F",
"00"&X"03FFFFFF01040232","00"&X"03FFFFFF10201435"
);
--------------------------   -M mod mi    ---------------------------------------------------
constant NI : type_RNS := (
"11"&X"FC000001000003D0","10"&X"0C000001000003CC",
"00"&X"9C000001000003B6","11"&X"3C0000010000027D",
"10"&X"7C000000FFFFF1A4","00"&X"FC000000FFFEF360",
"11"&X"FC000000FEFBFCCD","11"&X"FC000000EFDFE9CA"
);
-------------------------------------------------------------------------------------------
function Read_Moduli(i: std_logic_vector)              return   std_logic_vector; 
function Read_Moduli(i: integer         )              return   std_logic_vector; 
function Read_CModuli(i: std_logic_vector)             return   std_logic_vector; 
function Read_CModuli(i: integer         )             return   std_logic_vector;
function Read_Dinv(I :std_logic_vector)                return   std_logic_vector;
function Read_UDIM(I: std_logic_vector)                return   std_logic_vector;
function Read_DiMmj(I:std_logic_vector)                return   type_RNS;
function BLOCK_SUM(ARNS,BRNS: in type_RNS)             return   type_RNS;
function BLOCK_SUB(ARNS,BRNS: in type_RNS)             return   type_RNS;
function BLOCK_MULTIPLICATION(ARNS,BRNS: in type_RNS)  return   type_RNS; 
function Read_MDMmi(I : std_logic_vector)              return   type_RNS; 
function MSBB(A: std_logic_vector )                    return   integer;
function CSA_ADDER(X,Y,Z: std_logic_vector )           return   std_logic_vector;
function BSI(X: std_logic_vector; I:integer)           return   std_logic_vector;
function ModuliMult(A: type_RNS; B: std_logic_vector)  return   type_DRNS;
function KMULT(K : std_logic_vector)                   return   type_RNS;    
function BLOCK_3SUM(ARNS,BRNS,CRNS: in type_RNS)       return   type_RNS; 
              
procedure MODULI_ADD( 
signal    A :     IN  std_logic_vector(w-1 downto 0);
signal    B :     IN  std_logic_vector(w-1 downto 0);
signal    I :     IN  std_logic_vector(c-1 downto 0);
signal    ARNS :  OUT std_logic_vector(w-1 downto 0)    
                     );  
-------------------------------------------------------------------------------------------                
procedure MODULI_SUB( 
signal    A :     IN  std_logic_vector(w-1 downto 0);
signal    B :     IN  std_logic_vector(w-1 downto 0);
signal    I :     IN  std_logic_vector(c-1 downto 0);
signal    ARNS :  OUT std_logic_vector(w-1 downto 0)
                    );    

-------------------------------------------------------------------------------------------    
-------------------------------------------------------------------------------------------    
procedure KOM( 
signal    A :     IN  std_logic_vector(w-1 downto 0);
signal    B :     IN  std_logic_vector(w-1 downto 0);
signal    C :     OUT std_logic_vector(2*w-1 downto 0)
             );  
-------------------------------------------------------------------------------------------    
procedure BRTR(
             signal A: in  std_logic_vector(2*w-1 downto 0);
             signal I: in  integer;
             signal R: out std_logic_vector(w-1 downto 0)
             ); 
             
procedure BRTR(
             signal A: in  std_logic_vector(2*w-1 downto 0);
             signal I: in  std_logic_vector(3   downto 0);
             signal R: out std_logic_vector(w-1 downto 0)
             );     
procedure MMR(
             signal A: in  std_logic_vector(2*w-1 downto 0);
             signal I: in  std_logic_vector(3 downto 0);
             signal R: out std_logic_vector(w-1 downto 0)
             );     
procedure MMR(
             signal A: in  std_logic_vector(2*w-1 downto 0);
                    I: in  integer;
             signal R: out std_logic_vector(w-1 downto 0)
              );
-----------------------------------------------------------------------------                
procedure MMR_M1(
              signal A: in  std_logic_vector(2*w-1 downto 0);
              signal R: out std_logic_vector(w-1 downto 0));
procedure MMR_M2(
              signal A: in  std_logic_vector(2*w-1 downto 0);
              signal R: out std_logic_vector(w-1 downto 0));             
procedure MMR_M3(
              signal A: in  std_logic_vector(2*w-1 downto 0);
              signal R: out std_logic_vector(w-1 downto 0));
procedure MMR_M4(
              signal A: in  std_logic_vector(2*w-1 downto 0);
              signal R: out std_logic_vector(w-1 downto 0));                
procedure MMR_M5(
              signal A: in  std_logic_vector(2*w-1 downto 0);
              signal R: out std_logic_vector(w-1 downto 0));
procedure MMR_M6(
              signal A: in  std_logic_vector(2*w-1 downto 0);
              signal R: out std_logic_vector(w-1 downto 0));             
procedure MMR_M7(
              signal A: in  std_logic_vector(2*w-1 downto 0);
              signal R: out std_logic_vector(w-1 downto 0));
procedure MMR_M8(
              signal A: in  std_logic_vector(2*w-1 downto 0);
              signal R: out std_logic_vector(w-1 downto 0));               
-------------------------------------------------------------------------     
procedure YRNS(
              signal K : IN  type_YACU;
              signal XI: OUT type_RNS);  
-------------------------------------------------------------------------                                                                                                                                                                                     
end package;


package body RNS_PACKAGE is 

--------------------------------------------------------
function Read_Moduli(i: std_logic_vector)
return std_logic_vector is
variable j: integer range 1 to total_channels;
begin
if I >=1 and I<= total_channels then
   j:=conv_integer(I);
else
   j:=1;
end if;
return Moduli(j);
end function Read_Moduli;
-------------------------------------------------------
function Read_CModuli(i: std_logic_vector)
return std_logic_vector is
variable j: integer range 1 to total_channels;
begin
if I >=1 and I<= total_channels then
   j:=conv_integer(I);
else
   j:=1;
end if;
return CModuli(j);
end function Read_CModuli;
---------------------------------------------------------
function Read_Moduli(i: integer)
return std_logic_vector is
variable j: integer range 1 to total_channels;
begin
if I >=1 and I<= total_channels then
   j:=I;
else
   j:=1;
end if;
return Moduli(j);
end function Read_Moduli;
-----------------------------------------------------------
function Read_CModuli(i: integer)
return std_logic_vector is
variable j: integer range 1 to total_channels;
begin
if I >=1 and I<= total_channels then
   j:=I;
else
   j:=1;
end if;
return CModuli(j);
end function Read_CModuli;
-------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------------------------------------------------------
function Read_Dinv(I :std_logic_vector)
return std_logic_vector is
variable j: integer range 1 to total_channels;
begin 
if I >=1 and I<=total_channels then
   j:=conv_integer(I);
else
   j:=1;
end if;
return DINV(j);
end function Read_Dinv;
-------------------------------------------------------------------------
function Read_DiMmj(I:std_logic_vector) 
return type_RNS is 
--variable Rom_DiMmj: type_RNS_Table; 
variable j: integer range 1 to total_channels;
begin
if I >=1 and I<=total_channels then
   j:=conv_integer(I);
else
   j:=1;
end if;
return DiMmj(j);
end function Read_DiMmj; 
-------------------------------------------------------------------------
function Read_MDMmi(I : std_logic_vector) return type_RNS is
variable Rom_AlphaDMm : type_RNS_Table;
variable j: integer range 1 to total_channels-1;
begin
Rom_AlphaDMm(1)  :=("00"&X"9DB5B938A5353587","01"&X"6B9B4BF62062D19C","01"&X"CC1C6014E1C79339","01"&X"5A09201E34488F0B","00"&X"3D3588F803A6A0EE","01"&X"BE1E4A87A7C4ECD0","00"&X"E35509A9308955D3","10"&X"9463CB9AEE1D079A");
Rom_AlphaDMm(2)  :=("01"&X"3B6B72714A6A6B0E","10"&X"D73697EC40C5A338","11"&X"9838C029C38F2672","10"&X"B412403C68911E16","00"&X"7A6B11F0074D41DC","11"&X"7C3C950F4F89D9A0","01"&X"C6AA13526112ABA6","01"&X"28C79735DC3A1135");
Rom_AlphaDMm(3)  :=("01"&X"D9212BA9EF9FA095","00"&X"42D1E3E2612874D9","01"&X"6455203EA556B9B4","00"&X"0E1B605A9CD9AD32","00"&X"B7A09AE80AF3E2CA","01"&X"3A5ADF96F74EC6B1","10"&X"A9FF1CFB919C0179","11"&X"BD2B62D0CA5718CF");
Rom_AlphaDMm(4)  :=("10"&X"76D6E4E294D4D61C","01"&X"AE6D2FD8818B4675","11"&X"30718053871E4CED","01"&X"68248078D1223C3D","00"&X"F4D623E00E9A83B8","10"&X"F8792A1E9F13B381","11"&X"8D5426A4C225574C","10"&X"518F2E6BB874226A");
Rom_AlphaDMm(5)  :=("11"&X"148C9E1B3A0A0BA3","11"&X"1A087BCEA1EE1811","00"&X"FC8DE06868E5E02F","10"&X"C22DA097056ACB48","01"&X"320BACD8124124A6","00"&X"B69774A646D8A092","00"&X"70A9304DF2AEAE20","00"&X"E5F2FA06A6912C05");
Rom_AlphaDMm(6)  :=("11"&X"B2425753DF3F412A","00"&X"85A3C7C4C250E9B2","10"&X"C8AA407D4AAD7368","00"&X"1C36C0B539B35A64","01"&X"6F4135D015E7C594","10"&X"74B5BF2DEE9D8D62","01"&X"53FE39F7233803F3","11"&X"7A56C5A194AE339F");
Rom_AlphaDMm(7)  :=("00"&X"4FF8108C847476B2","01"&X"F13F13BAE2B3BB4E","00"&X"94C6A0922C7506AA","01"&X"763FE0D36DFBE96F","01"&X"AC76BEC8198E6682","00"&X"32D409B596627A73","10"&X"375343A053C159C6","10"&X"0EBA913C82CB3D3A");
if I >= 1 and I<= total_channels-1 then
   j:=conv_integer(I);
else
   j:=1;
end if;
return Rom_AlphaDMm(j);
end function Read_MDMmi;
-------------------------------------------------------------------------
function Read_UDIM(I: std_logic_vector)
return   std_logic_vector is
variable j: integer range 1 to total_channels;
begin 
if I >=1 and I<=total_channels then
   j:=conv_integer(I);
else
   j:=1;
end if;
return UDIM(j);
end function Read_UDIM;
-------------------------------------------------------------------------
function BLOCK_SUM(ARNS,BRNS: in type_RNS)
return type_RNS is 
variable j: integer; 
variable C: type_RNS;
variable Sum,S,A,B: std_logic_vector(w downto 0):=(others=>'0');
begin
for j in 1 to total_channels loop
A:=('0'& ARNS(j));
B:=('0'& BRNS(j));
Sum:= A+B;
if Sum >= Moduli(j) then 
   S:= Sum - Moduli(j);
else
   S:= Sum;
end if;
C(j):= S(w-1 downto 0);
end loop;      
return C;
end function;
-------------------------------------------------------------------------
function BLOCK_3SUM(ARNS,BRNS,CRNS: in type_RNS)
return type_RNS is 
variable j: integer; 
variable DRNS     : type_RNS;
variable A,B,N,S1    : std_logic_vector(w downto 0);
variable C           : std_logic_vector(w downto 0);
variable X,Y      : std_logic_vector(w+1 downto 0);
variable S,SUM    : std_logic_vector(w+1 downto 0);
begin

for j in 1 to total_channels loop
N:= (Moduli(j))&'0';
A:=('0'& ARNS(j));
B:=('0'& BRNS(j));
C:=('0'& CRNS(j));
S1(w downto 0):= A(w downto 0)+B(w downto 0);
SUM(w+1 downto 0) := '0'&S1(w downto 0)+ C;

if (Sum >= N) then 
   S:= Sum - N;
elsif (SUM > Moduli(j)) then 
   S:= Sum - Moduli(j);
else
   S:= Sum;
end if;
DRNS(j):= S(w-1 downto 0);
end loop;      
return DRNS;
end function;
-------------------------------------------------------------------------
function BLOCK_SUB(ARNS,BRNS: in type_RNS)
return type_RNS is 
variable j: integer; 
variable C: type_RNS;
variable Sub,S,A,B: std_logic_vector(w downto 0);
variable E: std_logic_vector(w-1 downto 0);
begin
for j in 1 to total_channels loop
A:=('0'& ARNS(j));
B:=('0'& BRNS(j));
S:= A + BM(j);
Sub := S - B; 
if Sub > Moduli(j) then
   Sub(w downto 0):= Sub(w downto 0)+ CModuli(j); 
end if;
C(j):= Sub(w-1 downto 0);    
end loop;
return C;
end function;
-------------------------------------------------------------------------

function BLOCK_MULTIPLICATION(ARNS,BRNS: in type_RNS)
return type_RNS is 
variable i: integer; 
variable Ci: type_RNS;
variable A: std_logic_vector(2*w-1 downto 0);
variable AL,AH,AAL,AAH : std_logic_vector(w-1 downto 0);
variable AM,N,Z : std_logic_vector(w downto 0);
variable M   :  std_logic_vector(w-1  downto 0);
constant Z0:  std_logic_vector(47 downto 0):=(others=>'0');
begin
for i in 1 to total_channels loop
A:= ARNS(i)*BRNS(i);
AH:= A(2*w-1 downto w);
AL:= A(w-1 downto 0);
AM:= '0'&AH+AL;
M:= Moduli(i);
case i is
   when 2 =>  
       AAL:= AH(w-3 downto 0)&"00";
       AAH:= "00000000000000"&Z0&AH(w-1 downto w-2)&AH(w-1 downto w-2);
   when 3 =>  
       AAL:= AH(w-4 downto 0)&"000";
       AAH:= "000000000000"&Z0&AH(w-1 downto w-3)&AH(w-1 downto w-3);
   when 4 =>  
       AAL:= AH(w-5 downto 0)&"0000";
       AAH:= "0000000000"&Z0&AH(w-1 downto w-4)&AH(w-1 downto w-4);
   when 5 =>  
       AAL:= AH(w-6 downto 0)&"00000";
       AAH:= "00000000"&Z0&AH(w-1 downto w-5)&AH(w-1 downto w-5);      
   when 6 =>  
       AAL:= AH(w-7 downto 0)&"000000";
       AAH:= "000000"&Z0&AH(w-1 downto w-6)&AH(w-1 downto w-6);     
   when 7 =>  
       AAL:= AH(w-9 downto 0)&"00000000";
       AAH:= "00"&Z0&AH(w-1 downto w-8)&AH(w-1 downto w-8);    
   when 8 =>  
       AAL:= AH(w-10 downto 0)&"000000000";
       AAH:= Z0&AH(w-1 downto w-9)&AH(w-1 downto w-9);   
   when others =>
       AAL:= (others=>'0');
       AAH:= (others=>'0'); 
   end case;
   N:= AAL+AAH+AM;
 if (N>= M) then 
    Z(w downto 0):= N(w downto 0)-M(w-1 downto 0);
 else 
    Z(w downto 0):= N(w downto 0);   
 end if;    
 Ci(i) := Z(w-1 downto 0); 
end loop;    
return Ci;
end function BLOCK_MULTIPLICATION;
-------------------------------------------------------------------------
function ModuliMult(A: type_RNS; B: std_logic_vector)  
return   type_DRNS is
variable V : type_DRNS;
begin
for i in 1 to total_channels loop
V(i):= A(i)*B;
end loop;
return V;
end function ModuliMult;

function KMULT(K : std_logic_vector) 
return type_RNS is
variable Ki: type_RNS;
variable A: std_logic_vector(2*w-15 downto 0);  
variable AL,AH,AAL,AAH : std_logic_vector(w-1 downto 0);
variable AM,N,Z : std_logic_vector(w downto 0);
variable M   :  std_logic_vector(w-1  downto 0);
constant Z0:  std_logic_vector(47 downto 0):=(others=>'0');
begin
for i in 1 to total_channels loop
A:= K(w-15 downto 0)*NI(i);
AH:= "00000000000000"&A(2*w-15 downto w);
AL:= A(w-1 downto 0);
AM:= '0'&AH+AL;
M:= Moduli(i);
case i is
   when 2 =>  
       AAL:= AH(w-3 downto 0)&"00";
       AAH:= "00000000000000"&Z0&AH(w-1 downto w-2)&AH(w-1 downto w-2);
   when 3 =>  
       AAL:= AH(w-4 downto 0)&"000";
       AAH:= "000000000000"&Z0&AH(w-1 downto w-3)&AH(w-1 downto w-3);
   when 4 =>  
       AAL:= AH(w-5 downto 0)&"0000";
       AAH:= "0000000000"&Z0&AH(w-1 downto w-4)&AH(w-1 downto w-4);
   when 5 =>  
       AAL:= AH(w-6 downto 0)&"00000";
       AAH:= "00000000"&Z0&AH(w-1 downto w-5)&AH(w-1 downto w-5);      
   when 6 =>  
       AAL:= AH(w-7 downto 0)&"000000";
       AAH:= "000000"&Z0&AH(w-1 downto w-6)&AH(w-1 downto w-6);     
   when 7 =>  
       AAL:= AH(w-9 downto 0)&"00000000";
       AAH:= "00"&Z0&AH(w-1 downto w-8)&AH(w-1 downto w-8);    
   when 8 =>  
       AAL:= AH(w-10 downto 0)&"000000000";
       AAH:= Z0&AH(w-1 downto w-9)&AH(w-1 downto w-9);   
   when others =>
       AAL:= (others=>'0');
       AAH:= (others=>'0'); 
   end case;
   N:= AAL+AAH+AM;
 if (N>= M) then 
    Z(w downto 0):= N(w downto 0)-M(w-1 downto 0);
 else 
    Z(w downto 0):= N(w downto 0);   
 end if;    
  Ki(i) := Z(w-1 downto 0);   
end loop;
return Ki;
end function KMULT;
-------------------------------------------------------------------------

function MSBB(A: std_logic_vector ) return integer is 
  variable n : integer;
  begin 
  for i in A'range loop
     if A(i)='1' then 
     n:= i;
     exit;
     end if;   
  end loop;
  return n;
end function MSBB;

-------------------------------------------------------------------------
function CSA_ADDER(X,Y,Z: std_logic_vector)
return std_logic_vector is
variable S,C,D: std_logic_vector(2*w downto 0);
begin
S := '0' & ((X(2*w-1 downto 0) XOR Y(2*w-1 downto 0)) XOR Z(2*w-1 downto 0));
C := (((X(2*w-1 downto 0) AND Y(2*w-1 downto 0)) OR (X(2*w-1 downto 0) AND Z(2*w-1 downto 0))) OR (Y(2*w-1 downto 0) AND Z(2*w-1 downto 0)))& '0';
D := S+C;
return D;
end function CSA_ADDER;
-------------------------------------------------------------------------
-------------------------------------------------------------------
function BSI(X:std_logic_vector; I: integer)  return   std_logic_vector is
variable Z0: std_logic_vector(w-10 downto 0):= (others=>'0');
variable Z1: std_logic_vector(w+8 downto 0);
variable Z : std_logic_vector(2*w-1 downto 0);
begin
Z(2*w-1 downto w+9) := (others =>'0');
if  i = 2 then
Z(w+1  downto 2) := X(w-1 downto 0);
Z(1 downto 0) := (others=>'0');
Z(w+8 downto w+2) := (others=>'0');
elsif i = 3 then 
Z(w+2  downto 3) := X(w-1 downto 0);
Z(2 downto 0) := (others=>'0');
Z(w+8 downto w+3) := (others=>'0');
elsif i = 4 then 
Z(w+3  downto 4) := X(w-1 downto 0);
Z(3 downto 0) := (others=>'0');
Z(w+8 downto w+4) := (others=>'0');
elsif i = 5 then 
Z(w+4  downto 5) := X(w-1 downto 0);
Z(4 downto 0) := (others=>'0');
Z(w+8 downto w+5) := (others=>'0');
elsif i = 6 then 
Z(w+5  downto 6) := X(w-1 downto 0);
Z(5 downto 0) := (others=>'0');
Z(w+8 downto w+6) := (others=>'0');
elsif i = 7 then 
Z(w+6  downto 7) := X(w-1 downto 0);
Z(7 downto 0) := (others=>'0');
Z(w+8 downto w+7) := (others=>'0');
elsif i = 8 then 
Z(w+8 downto 9) := X(w-1 downto 0);
Z(8 downto 0) := (others=>'0');
else
Z(w+8 downto 0):=(others=>'0');
end if;
return Z;
end function BSI;
-------------------------------------------------------------------
----------------------------------------------

procedure MODULI_ADD( 
signal	A :     IN  std_logic_vector(w-1 downto 0);
signal	B :     IN  std_logic_vector(w-1 downto 0);
signal	I :     IN  std_logic_vector(c-1 downto 0);
signal	ARNS :  OUT std_logic_vector(w-1 downto 0)) is
Variable SUM1: std_logic_vector(w downto 0);
Variable SUM2: std_logic_vector(w downto 0);
Variable Mi  : std_logic_vector(w-1 downto 0);
begin
Mi(w-1 downto 0) := Read_CModuli(I);
SUM2(w downto 0) := '0'&A + B;
SUM1(w downto 0) := '0'&A + B + Mi;
if SUM1(w)='1' then 
   ARNS(w-1 downto 0) <= SUM1(w-1 downto 0);
else 
   ARNS(w-1 downto 0) <= SUM2(w-1 downto 0);  
end if;    
end procedure MODULI_ADD;
-------------------------------------------------------------------------

procedure MODULI_SUB( 
signal	A :     IN  std_logic_vector(w-1 downto 0);
signal	B :     IN  std_logic_vector(w-1 downto 0);
signal	I :     IN  std_logic_vector(c-1 downto 0);
signal	ARNS :  OUT std_logic_vector(w-1 downto 0)) is
Variable Mi  : std_logic_vector(w-1 downto 0);
begin
Mi(w-1 downto 0) := Read_Moduli(I);

if A >= B then 
   ARNS(w-1 downto 0) <= A-B;
else 
   ARNS(w-1 downto 0) <= A+Mi-B;  
end if;    
end procedure MODULI_SUB;

-------------------------------------------------------------------------  
-------------------------------------------------------------------------

procedure KOM( 
signal    A :     IN  std_logic_vector(w-1 downto 0);
signal    B :     IN  std_logic_vector(w-1 downto 0);
signal    C :     OUT std_logic_vector(2*w-1 downto 0)
             ) is
variable X0,Y0,X1,Y1:     std_logic_vector(w/2-1 downto 0);
variable XX,YY:           std_logic_vector(w/2-1 downto 0);
variable XY0,XY1:         std_logic_vector(w-1   downto 0); 
variable XY2:             std_logic_vector(w     downto 0);  
variable XY:              std_logic_vector(w-1   downto 0); 
variable XY3:             std_logic_vector(w+1   downto 0); 

variable LXY0,LXY1,LXY2:  std_logic_vector(2*w-1 downto 0);
variable Z1 :             std_logic_vector(w-1   downto 0) := (others=>'0');    
variable Z2 :             std_logic_vector(w/2-1 downto 0) := (others=>'0'); 
variable Z3 :             std_logic_vector(w/2-3 downto 0) := (others=>'0');
variable CC :             std_logic_vector(2*w   downto 0);    
begin
X0(w/2-1 downto 0) := A(w/2-1 downto 0);
Y0(w/2-1 downto 0) := B(w/2-1 downto 0);
X1(w/2-1 downto 0) := A(w-1 downto w/2);
Y1(w/2-1 downto 0) := B(w-1 downto w/2);

XX(w/2-1 downto 0)  := (X1(w/2-1 downto 0) - X0(w/2-1 downto 0));
YY(w/2-1 downto 0)  := (Y0(w/2-1 downto 0) - Y1(w/2-1 downto 0));
XY0(w-1 downto 0)   := X0(w/2-1 downto 0)* Y0(w/2-1 downto 0); -- 66 bits
XY1(w-1 downto 0)   := X1(w/2-1 downto 0)* Y1(w/2-1 downto 0); -- 66 bits
XY(w-1 downto 0)    := XX(w/2-1 downto 0)* YY(w/2-1 downto 0);
XY2(w downto 0)     := '0'&XY0(w-1 downto 0)+XY1(w-1 downto 0); -- 67 bits
XY3(w+1 downto 0)   := '0'&XY2(w downto 0) + XY(w-1 downto 0);
LXY0 := (Z1&XY0);
LXY1 := ((Z3&XY3)&Z2);
LXY2 := (XY1&Z1);
CC := CSA_ADDER(LXY0,LXY1,LXY2);
C  <=CC(2*w-1 downto 0);
end procedure KOM;  

procedure BRTR(
signal A: in  std_logic_vector(2*w-1 downto 0);
signal I: in  integer;
signal R: out std_logic_vector(w-1 downto 0)) is 

variable S,S2: std_logic_vector(2*w downto 0);
variable TL,TH,SL,SH,TM,SM,RZ : std_logic_vector(2*w-1 downto 0);
variable A2,A3,A4,A5,A6,A7,A8   : std_logic_vector(2*w-1 downto 0);
variable B2,B3,B4,B5,B6,B7,B8   : std_logic_vector(2*w-1 downto 0);
constant Z :  std_logic_vector(w-1  downto 0):=(others=>'0');
constant Z0:  std_logic_vector(w-10 downto 0):=(others=>'0');
 
begin
A2:= "0000000"&Z0&A(2*w-1 downto w)&"00";
A3:=  "000000"&Z0&A(2*w-1 downto w)&"000";
A4:=   "00000"&Z0&A(2*w-1 downto w)&"0000";
A5:=    "0000"&Z0&A(2*w-1 downto w)&"00000";
A6:=     "000"&Z0&A(2*w-1 downto w)&"000000";
A7:=       '0'&Z0&A(2*w-1 downto w)&"00000000";
A8:=           Z0&A(2*w-1 downto w)&"000000000";
TH:=  Z& A(2*w-1 downto w);
TM := A(2*w-1 downto w)& Z;
if i=2 then 
   TL:=A2;
elsif i=3 then 
   TL:=A3;
elsif i=4 then 
   TL:=A4;
elsif i=5 then 
   TL:=A5;  
elsif i=6 then 
   TL:=A6; 
elsif i=7 then 
   TL:=A7; 
elsif i=8 then 
   TL:=A8;  
else
   TL:=(others=>'0');  
end if;                                      
S := CSA_ADDER(TH,TM,TL);
SM:= S(2*w-1 downto w) &Z;
SH:= Z &S(2*w-1 downto w);

B2:= "0000000"&Z0&S(2*w-1 downto w)&"00";
B3:=  "000000"&Z0&S(2*w-1 downto w)&"000";
B4:=   "00000"&Z0&S(2*w-1 downto w)&"0000";
B5:=    "0000"&Z0&S(2*w-1 downto w)&"00000";
B6:=     "000"&Z0&S(2*w-1 downto w)&"000000";
B7:=       '0'&Z0&S(2*w-1 downto w)&"00000000";
B8:=           Z0&S(2*w-1 downto w)&"000000000";

if i=2 then 
   SL:=B2;
elsif i=3 then 
   SL:=B3;
elsif i=4 then 
   SL:=B4;
elsif i=5 then 
   SL:=B5;  
elsif i=6 then 
   SL:=B6; 
elsif i=7 then 
   SL:=B7; 
elsif i=8 then 
   SL:=B8;  
else
   SL:=(others=>'0');  
end if;             
S2 := CSA_ADDER(A,SL,SH);
RZ(2*w-1 downto 0) := S2(2*w-1 downto 0)-SM(2*w-1 downto 0);
R <= RZ(w-1 downto 0);
end procedure BRTR;

procedure BRTR(
signal A: in  std_logic_vector(2*w-1 downto 0);
signal I: in  std_logic_vector(3 downto 0);
signal R: out std_logic_vector(w-1 downto 0)) is 

variable S,S2: std_logic_vector(2*w downto 0);
variable TL,TH,SL,SH,TM,SM,RZ : std_logic_vector(2*w-1 downto 0);
variable A2,A3,A4,A5,A6,A7,A8   : std_logic_vector(2*w-1 downto 0);
variable B2,B3,B4,B5,B6,B7,B8   : std_logic_vector(2*w-1 downto 0);
constant Z :  std_logic_vector(w-1  downto 0):=(others=>'0');
constant Z0:  std_logic_vector(w-10 downto 0):=(others=>'0');
 
begin
A2:= "0000000"&Z0&A(2*w-1 downto w)&"00";
A3:=  "000000"&Z0&A(2*w-1 downto w)&"000";
A4:=   "00000"&Z0&A(2*w-1 downto w)&"0000";
A5:=    "0000"&Z0&A(2*w-1 downto w)&"00000";
A6:=     "000"&Z0&A(2*w-1 downto w)&"000000";
A7:=       '0'&Z0&A(2*w-1 downto w)&"00000000";
A8:=           Z0&A(2*w-1 downto w)&"000000000";
TH:=  Z& A(2*w-1 downto w);
TM := A(2*w-1 downto w)& Z;
if i="0010" then 
   TL:=A2;
elsif i="0011" then 
   TL:=A3;
elsif i="0100" then 
   TL:=A4;
elsif i="0101" then 
   TL:=A5;  
elsif i="0110" then 
   TL:=A6; 
elsif i="0111" then 
   TL:=A7; 
elsif i="1000" then 
   TL:=A8;  
else
   TL:=(others=>'0');  
end if;                                      
S := CSA_ADDER(TH,TM,TL);
SM:= S(2*w-1 downto w) &Z;
SH:= Z &S(2*w-1 downto w);

B2:= "0000000"&Z0&S(2*w-1 downto w)&"00";
B3:=  "000000"&Z0&S(2*w-1 downto w)&"000";
B4:=   "00000"&Z0&S(2*w-1 downto w)&"0000";
B5:=    "0000"&Z0&S(2*w-1 downto w)&"00000";
B6:=     "000"&Z0&S(2*w-1 downto w)&"000000";
B7:=       '0'&Z0&S(2*w-1 downto w)&"00000000";
B8:=           Z0&S(2*w-1 downto w)&"000000000";

if i="0010" then 
   SL:=B2;
elsif i="0011" then 
   SL:=B3;
elsif i="0100" then 
   SL:=B4;
elsif i="0101" then 
   SL:=B5;  
elsif i="0110" then 
   SL:=B6; 
elsif i="0111" then 
   SL:=B7; 
elsif i="1000" then 
   SL:=B8;  
else
   SL:=(others=>'0');  
end if;             
S2 := CSA_ADDER(A,SL,SH);
RZ(2*w-1 downto 0) := S2(2*w-1 downto 0)-SM(2*w-1 downto 0);
if( RZ < Read_Moduli(I)) then
R <= RZ(w-1 downto 0);
else
R <= RZ(w-1 downto 0)- READ_MODULI(I);
end if;

end procedure BRTR;        


procedure MMR(
signal A: in  std_logic_vector(2*w-1 downto 0);
signal I: in  std_logic_vector(3 downto 0);
signal R: out std_logic_vector(w-1 downto 0)) is    
variable AL,AH,AAL,AAH : std_logic_vector(w-1 downto 0);
variable AM    : std_logic_vector(w downto 0);
variable N     : std_logic_vector(w+1 downto 0);
variable M     : std_logic_vector(w-1  downto 0);
constant Z0:  std_logic_vector(47 downto 0):=(others=>'0');
begin
M:= Read_Moduli(I);
AH:= A(2*w-1 downto w);
AL:= A(w-1 downto 0);
AM:= '0'&AH+AL;
if AM >= M then 
   AM:= AM-M;
end if; 
case I is
   when "0010" =>  
       AAL:= AH(w-3 downto 0)&"00";
       AAH:= "00000000000000"&Z0&AH(w-1 downto w-2)&AH(w-1 downto w-2);
   when "0011" =>  
       AAL:= AH(w-4 downto 0)&"000";
       AAH:= "000000000000"&Z0&AH(w-1 downto w-3)&AH(w-1 downto w-3);
   when "0100" =>  
       AAL:= AH(w-5 downto 0)&"0000";
       AAH:= "0000000000"&Z0&AH(w-1 downto w-4)&AH(w-1 downto w-4);
   when "0101" =>  
       AAL:= AH(w-6 downto 0)&"00000";
       AAH:= "00000000"&Z0&AH(w-1 downto w-5)&AH(w-1 downto w-5);      
   when "0110" =>  
       AAL:= AH(w-7 downto 0)&"000000";
       AAH:= "000000"&Z0&AH(w-1 downto w-6)&AH(w-1 downto w-6);     
   when "0111" =>  
       AAL:= AH(w-9 downto 0)&"00000000";
       AAH:= "00"&Z0&AH(w-1 downto w-8)&AH(w-1 downto w-8);    
   when "1000" =>  
       AAL:= AH(w-10 downto 0)&"000000000";
       AAH:= Z0&AH(w-1 downto w-9)&AH(w-1 downto w-9);   
   when others =>
       AAL:= (others=>'0');
       AAH:= (others=>'0'); 
   end case;
   N:= '0'&AM+AAL+AAH;
 if (N>= M) then 
    N(w+1 downto 0):= N(w+1 downto 0)-M(w-1 downto 0);   
 end if;    
  R(w-1 downto 0) <= N(w-1 downto 0);                                                                                                                                                                          
end procedure MMR;

procedure MMR(
signal A: in  std_logic_vector(2*w-1 downto 0);
       i: in  integer;
signal R: out std_logic_vector(w-1 downto 0)) is    
variable AL,AH,AAL,AAH : std_logic_vector(w-1 downto 0);
variable AM    : std_logic_vector(w downto 0);
variable N     : std_logic_vector(w+1 downto 0);
variable M     :  std_logic_vector(w-1  downto 0);
constant Z0:  std_logic_vector(47 downto 0):=(others=>'0');
begin
M:= Moduli(i);
AH:= A(2*w-1 downto w);
AL:= A(w-1 downto 0);
AM:= '0'&AH+AL;
if AM >= M then 
   AM:= AM-M;
end if;   
case i is
   when 2 =>  
       AAL:= AH(w-3 downto 0)&"00";
       AAH:= "00000000000000"&Z0&AH(w-1 downto w-2)&AH(w-1 downto w-2);
   when 3 =>  
       AAL:= AH(w-4 downto 0)&"000";
       AAH:= "000000000000"&Z0&AH(w-1 downto w-3)&AH(w-1 downto w-3);
   when 4 =>  
       AAL:= AH(w-5 downto 0)&"0000";
       AAH:= "0000000000"&Z0&AH(w-1 downto w-4)&AH(w-1 downto w-4);
   when 5 =>  
       AAL:= AH(w-6 downto 0)&"00000";
       AAH:= "00000000"&Z0&AH(w-1 downto w-5)&AH(w-1 downto w-5);      
   when 6 =>  
       AAL:= AH(w-7 downto 0)&"000000";
       AAH:= "000000"&Z0&AH(w-1 downto w-6)&AH(w-1 downto w-6);     
   when 7 =>  
       AAL:= AH(w-9 downto 0)&"00000000";
       AAH:= "00"&Z0&AH(w-1 downto w-8)&AH(w-1 downto w-8);    
   when 8 =>  
       AAL:= AH(w-10 downto 0)&"000000000";
       AAH:= Z0&AH(w-1 downto w-9)&AH(w-1 downto w-9);   
   when others =>
       AAL:= (others=>'0');
       AAH:= (others=>'0'); 
   end case;
 N:= '0'&AM+AAL+AAH;
 if (N>= M) then 
    N(w+1 downto 0):= N(w+1 downto 0)-M(w-1 downto 0);
 end if;    
  R(w-1 downto 0) <= N(w-1 downto 0);                                                                                                                                                                          
end procedure MMR;
-------------------------------------------------------------------------
procedure MMR_M1(
signal A: in  std_logic_vector(2*w-1 downto 0);
signal R: out std_logic_vector(w-1 downto 0)) is    
variable AL,AH : std_logic_vector(w-1 downto 0);
variable N     : std_logic_vector(w downto 0);
variable M     : std_logic_vector(w-1  downto 0);
constant Z0:  std_logic_vector(47 downto 0):=(others=>'0');
begin
M:= Moduli(1);
AH:= A(2*w-1 downto w);
AL:= A(w-1 downto 0);
N:= '0'&AH+AL;
 if (N>= M) then 
    N(w downto 0):= N(w downto 0)-M(w-1 downto 0); 
 end if;    
R(w-1 downto 0) <= N(w-1 downto 0);                                                                                                                                                                          
end procedure MMR_M1;
-------------------------------------------------------------------------
procedure MMR_M2(
signal A: in  std_logic_vector(2*w-1 downto 0);
signal R: out std_logic_vector(w-1 downto 0)) is    
variable AL,AH,AAL,AAH : std_logic_vector(w-1 downto 0);
variable AM  : std_logic_vector(w downto 0);
variable N,Z : std_logic_vector(w+1 downto 0);
variable M   :  std_logic_vector(w-1  downto 0);
constant Z0:  std_logic_vector(61 downto 0):=(others=>'0');
begin
M:= Moduli(2); 
AH(w-1 downto 0) := A(2*w-1 downto w);
AL(w-1 downto 0) := A(w-1 downto 0);
AAL(w-1 downto 0):= A(2*w-3 downto w)&"00";
AAH(w-1 downto 0):= Z0&(A(2*w-1 downto 2*w-2)&A(2*w-1 downto 2*w-2));
AM:= '0'&AH+AL;  
if AM >= M then 
   AM:= AM - M;
end if; 
N:= '0'&AM+AAL+AAH;
 if (N>=Moduli(2)) then 
    N(w+1 downto 0):= N(w+1 downto 0)-moduli(2);   
 else 
    N(w+1 downto 0):= N(w+1 downto 0);   
 end if;    
R(w-1 downto 0) <= N(w-1 downto 0);                                                                                                                                                                          
end procedure MMR_M2;

-------------------------------------------------------------------------
procedure MMR_M3(
signal A: in  std_logic_vector(2*w-1 downto 0);
signal R: out std_logic_vector(w-1 downto 0)) is    
variable AL,AH,AAL,AAH : std_logic_vector(w-1 downto 0);
variable AM : std_logic_vector(w downto 0);
variable N  : std_logic_vector(w+1 downto 0);
variable M   :  std_logic_vector(w-1  downto 0);
constant Z0:  std_logic_vector(59 downto 0):=(others=>'0');
begin
AH:= A(2*w-1 downto w);
AL:= A(w-1 downto 0);
AM:= '0'&AH+AL;
M:= Moduli(3);
if AM >= M then 
   AM:= AM - M;
end if;
AAL:= AH(w-4 downto 0)&"000";
AAH:= Z0&AH(w-1 downto w-3)&AH(w-1 downto w-3);
N:= '0'&AM+ AAH+AAL;
 if (N>= M) then 
    N(w+1 downto 0):= N(w+1 downto 0)-Moduli(3);   
 end if;    
R(w-1 downto 0) <= N(w-1 downto 0);                                                                                                                                                                          
end procedure MMR_M3;
---------------------------------------------------------------------------------------
procedure MMR_M4(
signal A     :  in  std_logic_vector(2*w-1 downto 0);
signal R     :  out std_logic_vector(w-1 downto 0)) is    
variable AL,AH,AAL,AAH : std_logic_vector(w-1 downto 0);
variable AM  :  std_logic_vector(w   downto 0);
variable N   :  std_logic_vector(w+1 downto 0);
variable M   :  std_logic_vector(w-1 downto 0);
constant Z0  :  std_logic_vector(w-9 downto 0):=(others=>'0');
begin
M:= Moduli(4);
AH:= A(2*w-1 downto w);
AL:= A(w-1 downto 0);
AM:= '0'&AH+AL;
if AM >= M then 
   AM:= AM - M;
end if;
AAL:= A(2*w-5 downto w)&"0000";
AAH:= Z0&A(2*w-1 downto 2*w-4)&A(2*w-1 downto 2*w-4);
N(w+1 downto 0) := '0'&AM+AAL+AAH;
 if (N>= M) then 
    N(w+1 downto 0):= N(w+1 downto 0)-M(w-1 downto 0); 
 end if;    
R(w-1 downto 0) <= N(w-1 downto 0);                                                                                                                                                                          
end procedure MMR_M4;
---------------------------------------------------------------------------------------------
procedure MMR_M5(
signal A: in  std_logic_vector(2*w-1 downto 0);
signal R: out std_logic_vector(w-1 downto 0)) is    
variable AL,AH,AAL,AAH : std_logic_vector(w-1 downto 0);
variable AM: std_logic_vector(w downto 0);
variable N : std_logic_vector(w+1 downto 0);
variable M   :  std_logic_vector(w-1  downto 0);
constant Z0:  std_logic_vector(w-11 downto 0):=(others=>'0');
begin
M:= Moduli(5);
AH:= A(2*w-1 downto w);
AL:= A(w-1 downto 0);
AM:= '0'&AH+AL;
if AM >= M then 
   AM:= AM - M;
end if;
AAL:= A(2*w-6 downto w)&"00000";
AAH:= Z0&A(2*w-1 downto 2*w-5)&A(2*w-1 downto 2*w-5);      
N:= '0'&AM+AAL+AAH;
 if (N>= M) then 
    N(w+1 downto 0):= N(w+1 downto 0)-M(w-1 downto 0);
 else 
    N(w+1 downto 0):= N(w+1 downto 0);   
 end if;    
R(w-1 downto 0) <= N(w-1 downto 0);                                                                                                                                                                          
end procedure MMR_M5;
-------------------------------------------------------------------------------------
procedure MMR_M6(
signal A: in  std_logic_vector(2*w-1 downto 0);
signal R: out std_logic_vector(w-1 downto 0)) is    
variable AL,AH,AAL,AAH : std_logic_vector(w-1 downto 0);
variable AM  : std_logic_vector(w downto 0);
variable N   : std_logic_vector(w+1 downto 0);
variable M   : std_logic_vector(w-1  downto 0);
constant Z0:  std_logic_vector(w-13 downto 0):=(others=>'0');
begin
M:= Moduli(6); 
AH:= A(2*w-1 downto w);
AL:= A(w-1 downto 0);
AM:= '0'&AH+AL;
if AM >= M then 
   AM:= AM-M;
end if;   
AAL:= A(2*w-7 downto w)&"000000";
AAH:= Z0&A(2*w-1 downto 2*w-6)&A(2*w-1 downto 2*w-6);     
N:= '0'&AM+AAL+AAH;
if (N>= M) then 
    N(w+1 downto 0):= N(w+1 downto 0)-M(w-1 downto 0);  
end if;    
R(w-1 downto 0) <= N(w-1 downto 0);                                                                                                                                                                          
end procedure MMR_M6;
-------------------------------------------------------------------------------------------------
procedure MMR_M7(
signal A: in  std_logic_vector(2*w-1 downto 0);
signal R: out std_logic_vector(w-1 downto 0)) is    
variable AL,AH,AAL,AAH : std_logic_vector(w-1 downto 0);
variable AM  : std_logic_vector(w downto 0);
variable N   : std_logic_vector(w+1 downto 0);
variable M   :  std_logic_vector(w-1  downto 0);
constant Z0:  std_logic_vector(w-17 downto 0):=(others=>'0');
begin
M := Moduli(7);
AH:= A(2*w-1 downto w);
AL:= A(w-1 downto 0);
AM:= '0'&AH+AL;
if AM >= M then 
   AM := AM-M;
end if;   
AAL:= A(2*w-9 downto w)&"00000000";
AAH:= Z0&A(2*w-1 downto 2*w-8)&A(2*w-1 downto 2*w-8);    
N:= '0'&AM+AAL+AAH;
if (N>= M) then 
    N(w+1 downto 0):= N(w+1 downto 0)-M(w-1 downto 0);  
end if;    
R(w-1 downto 0) <= N(w-1 downto 0);                                                                                                                                                                          
end procedure MMR_M7;
------------------------------------------------------------------------------------------------
procedure MMR_M8(
signal A: in  std_logic_vector(2*w-1 downto 0);
signal R: out std_logic_vector(w-1 downto 0)) is    
variable AL,AH,AAL,AAH : std_logic_vector(w-1 downto 0);
variable AM  : std_logic_vector(w downto 0);
variable N   : std_logic_vector(w+1 downto 0);
variable M   :  std_logic_vector(w-1  downto 0);
constant Z0:  std_logic_vector(w-19 downto 0):=(others=>'0');
begin
M:= Moduli(8); 
AH:= A(2*w-1 downto w);
AL:= A(w-1 downto 0);
AM:= '0'&AH+AL;
if AM >= M then 
   AM := AM-M;
end if; 
AAL:= A(2*w-10 downto w)&"000000000";
AAH:= Z0&A(2*w-1 downto 2*w-9)&A(2*w-1 downto 2*w-9);   
N:= '0'&AM+AAL+AAH;
if (N>= M) then 
    N(w+1 downto 0):= N(w+1 downto 0)-M(w-1 downto 0);   
end if;    
R(w-1 downto 0) <= N(w-1 downto 0);                                                                                                                                                                          
end procedure MMR_M8;
                 
procedure YRNS (
signal K : IN  type_YACU;
signal XI: OUT type_RNS)  is 
variable Ki    : std_logic_vector(w+2 downto 0);
variable AL    : std_logic_vector(w-1 downto 0);
variable AH    : std_logic_vector(2 downto 0);
variable AAL : std_logic_vector(11 downto 0);
variable N,Z : std_logic_vector(w downto 0);
variable AM  : std_logic_vector(w downto 0);
variable M   :  std_logic_vector(w-1  downto 0);
begin
for i in 1 to total_channels loop
   M:= read_moduli(I);
   Ki := K(i);
   AH:= Ki(w+2 downto w);
   AL:= Ki(w-1 downto 0);
   AM:= '0'&AL + AH;
   case I is
      when 2 =>  
          AAL:=   "0000000"& Ki(w+2 downto w)&"00";
      when 3 =>  
          AAL:=    "000000"& Ki(w+2 downto w)&"000";
      when 4 =>  
          AAL:=     "00000"& Ki(w+2 downto w)&"0000";
      when 5 =>  
          AAL:=      "0000"& Ki(w+2 downto w)&"00000";
      when 6 =>  
          AAL:=       "000"& Ki(w+2 downto w)&"000000";
      when 7 =>  
          AAL:=         "0"& Ki(w+2 downto w)&"00000000";
      when 8 =>  
          AAL:=              Ki(w+2 downto w)&"000000000";
      when others =>
          AAL:= (others=>'0');
      end case;
      N:= AM + AAL;
    if (N>= M) then 
       Z(w downto 0):= N(w downto 0)-M(w-1 downto 0);
    else 
       Z(w downto 0):= N(w downto 0);   
    end if;    
    XI(i) <= Z(w-1 downto 0);     
end loop;
end procedure;

end package body RNS_PACKAGE;