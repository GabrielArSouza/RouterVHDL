library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity buffer_r is 
	generic ( w: natural := 8);
	
	port ( input:  in  std_logic_vector (w-1 downto 0); --entrada
	       action: in  std_logic_vector (1 downto 0); -- 10 - leitura, 00 - escrita, 11 - clear
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
	    	if ( action = "10" ) then 	
			output <= mem(rd_ptr);
		elsif ( action = "11" ) then
			mem(rd_ptr) <= "UUUUUUUU";
			rd_ptr := (rd_ptr+1) rem 4;
		elsif ( action = "00" and (mem(wr_ptr) = "UUUUUUUU") ) then
			mem(wr_ptr) <= input;
			wr_ptr := (wr_ptr+1) rem 4;
		end if;
	     end if;	
	end process;

end arch_buffer;