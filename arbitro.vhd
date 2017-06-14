library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity arbitro is 
	generic ( w: natural := 8);

	port ( input:  in  std_logic_vector (w-1 downto 0); -- entrada
	       clk:    in  bit; --clock
	       output: out std_logic_vector (w-1 downto 0)  --saída 
	      );
end arbitro;

architecture arch_arb of arbitro is
	type memory is array(0 to 3) of bit;
	signal buffer_arb : memory; --_ memória
	
	-- pos = 0 -> Dado da entrada norte espera para sair
	-- pos = 1 -> Dado da entrada sul espera para sair
	-- pos = 2 -> Dado da entrada leste espera para sair
	-- pos = 3 -> Dado da emtrada oeste espera para sair

	component mux_4x1_Wbits

		port ( 
		a0, a1, a2, a3 : in bit_vector (w-1 downto 0);  -- data inputs
	  	s0, s1         : in std_logic;		   	-- seletores
	   	s              : out bit_vector (w-1 downto 0));-- saida

	end component;

	-- s0 = 1 and s1 = 0 -> libera a primeira entrada do MUX (a0 norte)
	-- s1 = 1 and s0 = 0 -> libera a segunda entrada do MUX (a1 sul)
	-- s0 and s1 = 0 -> libera a terceira entrada do MUX (a2 leste)
	-- s0 and s1 = 1 -> libera a quarta entrada do MUX (a3 oeste)

begin
	process(clk)
	variable ptr_rd: natural;
	
	begin
		if ( clk'EVENT AND clk='1' ) then
			if ( (ptr_rd = 0) and (buffer_arb(ptr_rd) = '1') ) then
				s0 <= '1';
				s1 <= '0';
			elsif ( (ptr_rd = 1) and (buffer_arb(ptr_rd) = '1')) then
				s1 <= '1';
				s0 <= '0';
			elsif ( (ptr_rd = 2) and (buffer_arb(ptr_rd) = '1')) then
				s0 <= '0';
				s1 <= '0';
			elsif ( (ptr_rd = 3) and (buffer_arb(ptr_rd) = '1')) then
				s0 <= '1';
				s1 <= '1';
			end if;
			rd_ptr := (rd_ptr+1) rem 4;
		end if;

	end process;

end arch_arb;