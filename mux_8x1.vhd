library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mux_4x1_Wbits is
    generic ( w : natural := 8);
    
    port ( a0, a1, a2, a3 : in  std_logic_vector  (w-1 downto 0); -- entrada de dados
	   s0, s1         : in  bit;       		          -- seletores
	   s              : out std_logic_vector (w-1 downto 0));  -- saida
end mux_4x1_Wbits;

architecture arch_mux of mux_4x1_Wbits is
-- a0 norte
-- a1 sul 
-- a2 leste
-- a3 oeste 

begin

    -- s0 = 1 and s1 = 0 -> libera a primeira entrada do MUX (a0 norte)
    -- s1 = 1 and s0 = 0 -> libera a segunda entrada do MUX (a1 sul)
    -- s0 and s1 = 0 -> libera a terceira entrada do MUX (a2 leste)
    -- s0 and s1 = 1 -> libera a quarta entrada do MUX (a3 oeste)
   PROCESS(s0,s1, a0, a1, a2, a3)
   BEGIN 
      IF(s0='1' and s1='0') THEN  -- norte
         s <= a0;
      ELSIF(s0='0' and s1='1') THEN -- sul
  	 s <= a1;
      ELSIF(s0='0' and s1='0') THEN -- leste
	 s <= a2;
      ELSIF(s0='1' and s1='1') THEN -- oeste
	 s <= a3;
      END IF;
   END PROCESS; 
end arch_mux;
