library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity buffer_r is 
	generic ( w: natural := 8);
	
	port ( input:  in  bit_vector (w-1 downto 0); --entrada
	       action: in  bit; -- 1 - leitura, 0 - escrita
	       clk:    in  bit; --clock
	       output: out bit_vector (w-1 downto 0)  --saída 
	      );
end buffer_r;

--------------------------------------
architecture arch_buffer of buffer_r is  

type memory is array(0 to 3) of std_logic_vector(w-1 downto 0);
signal mem : memory; -- memória

begin
			
	process (clk)
	variable wr_ptr: natural;
	variable rd_ptr: natural;
	wr_ptr := 0;
	rd_ptr := 0;
	begin
	    if ( clk'EVENT AND clk='1' ) then  
	    	if ( action = '1') then 	
			output <= mem(rd_ptr);
			rd_ptr
		elsif ( action = '1' 
		end if;
	end if;	
	end process;


	

end arch_buffer;