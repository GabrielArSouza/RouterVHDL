library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity arbitro is 
	generic ( w: natural := 8);

	port ( clk:                in  bit;  -- clock
	       in1, in2, in3, in4: in  std_logic_vector  (w-1 downto 0); -- entrada de dados
	       write_b:            in  std_logic_vector( 1 downto 0 );  -- escrever no buffer 
	       output:             out std_logic_vector (w-1 downto 0)); --mesma saída do MUX
end arbitro;

architecture arch_arb of arbitro is
	type memory is array(0 to 3) of bit;
	signal buffer_arb : memory; -- memória
	signal ctrl_1, ctrl_2: std_logic; -- sinal controlador para o mux
	
	-- pos = 0 -> Dado da entrada norte espera para sair
	-- pos = 1 -> Dado da entrada sul espera para sair
	-- pos = 2 -> Dado da entrada leste espera para sair
	-- pos = 3 -> Dado da emtrada oeste espera para sair

	component mux_4x1_Wbits
 
		port(
		a0, a1, a2, a3 : in  std_logic_vector  (w-1 downto 0); -- entrada de dados
	   	s0, s1         : in  std_logic;       		       -- seletores
	   	s              : out std_logic_vector (w-1 downto 0)); -- saida
	end component;

	-- s0 = 1 and s1 = 0 -> libera a primeira entrada do MUX (a0 norte)
	-- s0 = 0 and s1 = 1 -> libera a segunda entrada do MUX (a1 sul)
	-- s0 and s1 = 0 -> libera a terceira entrada do MUX (a2 leste)
	-- s0 and s1 = 1 -> libera a quarta entrada do MUX (a3 oeste)
	
begin
	process(clk)
	variable ptr_rd: natural;
	begin
		if ( clk'EVENT AND clk='1' ) then
			-- escreve no buffer

			-- write_b = 00 -> Escreve na posição 0(norte)
			-- write_b = 01 -> Escreve na posição 1(sul)
			-- write_b = 10 -> Escreve na posição 2(leste)
			-- write_b = 11 -> Escreve na posição 3(oeste)
	 
			if ((write_b = "00") and (buffer_arb(0) = '0')) then
			    buffer_arb(0) <= '1';
			elsif ((write_b = "01") and (buffer_arb(1) = '0')) then
			    buffer_arb(1) <= '1';
			elsif ((write_b = "10") and (buffer_arb(2) = '0')) then
			    buffer_arb(2) <= '1';
			elsif ((write_b = "11") and (buffer_arb(3) = '0')) then
			    buffer_arb(3) <= '1';
			end if;
			
			if ( (ptr_rd = 0) and (buffer_arb(ptr_rd) = '1') ) then
				ctrl_1 <= '0';
				ctrl_2 <= '0';
				buffer_arb(ptr_rd) <= '0';
			-- sai o sul
			elsif ( (ptr_rd = 1) and (buffer_arb(ptr_rd) = '1')) then
				ctrl_1 <= '0';
				ctrl_2 <= '1';
				buffer_arb(ptr_rd) <= '0';
			-- sai o leste
			elsif ( (ptr_rd = 2) and (buffer_arb(ptr_rd) = '1')) then
				ctrl_1 <= '1';
				ctrl_2 <= '0';
				buffer_arb(ptr_rd) <= '0';
			-- sai o oeste
			elsif ( (ptr_rd = 3) and (buffer_arb(ptr_rd) = '1')) then
				ctrl_1 <= '1';
				ctrl_2 <= '1';
				buffer_arb(ptr_rd) <= '0';
			else
				ctrl_1 <= 'U';
				ctrl_2 <= 'U';
			end if;

			ptr_rd := (ptr_rd+1) rem 4;
		end if;
		
	end process;
		-- aplicando dados no mux
		mux1 : mux_4x1_Wbits port map (in1, in2, in3, in4, ctrl_1, ctrl_2, output);
end arch_arb;