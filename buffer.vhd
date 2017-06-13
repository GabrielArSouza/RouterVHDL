library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity buffer_r is 
	generic ( w: natural := 8);
	
	port ( input:  in  std_logic_vector (w-1 downto 0); --entrada
	       action: in  bit; -- 1 - leitura, 0 - escrita
	       clk:    in  bit; --clock
	       output: out std_logic_vector (w-1 downto 0)  --saída 
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
	
	begin
	
	    if ( clk'EVENT AND clk='1' ) then  
	    	if ( action = '1' ) then 	
			if (mem(rd_ptr) = "UUUUUUUU") then
			    output <= "UUUUUUUU";
			else 
			    output <= mem(rd_ptr);
			    mem(rd_ptr) <= "UUUUUUUU";
			    rd_ptr := (rd_ptr+1) rem 4;
			end if;
		elsif ( action = '0' and (mem(wr_ptr) = "UUUUUUUU") ) then
			mem(wr_ptr) <= input;
			wr_ptr := (wr_ptr+1) rem 4;
		        	
		end if;
	     end if;	
	end process;

end arch_buffer;