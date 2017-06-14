library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity router_logic is 
	generic ( w: natural := 8);
	
	port ( input:  in  std_logic_vector (w-1 downto 0); --entrada = primeiro pacote do buffer
	       clk:    in  bit; --clock
	       output: out std_logic_vector (1 downto 0)  --saída 
	      );
end router_logic;

architecture arch_router of router_logic is  

begin
			
	process (clk)
	
	begin
	    if ( clk'EVENT AND clk='1' ) then  
		--se x != 0
	    	if ( input(w-1 downto 4) /= "0000" ) then
		    -- x > 0  
		    if( input(w-1) = '0') then
			output <= "10"; --set Leste do buffer do arbitro
		    -- x < 0
		    else
			output <= "11"; --set Oeste do buffer do arbitro
		    end if;
	        else
		    --y > 0
		    if( input(3) = '0') then
			output <= "01"; --set Sul do buffer do arbitro
		    --y < 0
		    else
			output <= "00"; --set Norte do buffer do arbitro
		    end if;
		end if;
	     end if;	
	end process;

end arch_router;
