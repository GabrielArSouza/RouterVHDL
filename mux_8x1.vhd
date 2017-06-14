library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux_4x1_Wbits is
    generic ( w : natural := 4);
    
    port ( a0, a1, a2, a3 : in bit_vector (w-1 downto 0);  -- data inputs
	   s0, s1         : in std_logic;		   -- seletores
	   s              : out bit_vector (w-1 downto 0)); -- saida
end mux_4x1_Wbits;

architecture arch_mux of mux_4x1_Wbits is
-- a0 igual (p)
-- a1 maior (p-m) 
-- a2 menor (m-p)
begin
   PROCESS(s0,s1, a0, a1, a2, a3)
   BEGIN 
      IF(s0='1') THEN  -- primeiro
         s <= a0;
      ELSIF(s1='1') THEN --segundo
  	 s <= a1;
      ELSE
	 s <= a2;
      END IF;
   END PROCESS; 
end arch_mux;
