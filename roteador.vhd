library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity roteador is
generic (w : natural := 8);

port (  in_north, in_south, in_east, in_west     : in  std_logic_vector(w-1 downto 0); -- entradas
	clk                                      : in bit;
	out_north, out_south, out_east, out_west : out std_logic_vector(w-1 downto 0)); -- saidas

end roteador;


architecture arch_router of roteador is  

--sinais de saida para os buffers
signal bufn_out, bufs_out, bufe_out, bufw_out : std_logic_vector(w-1 downto 0);

--saídas do roteamento
signal rotn_out, rots_out, rote_out, rotw_out : std_logic_vector (1 downto 0);

component buffer_r

        port ( input:  in  std_logic_vector(w-1 downto 0); --entrada
	       action: in  bit; -- 1 - leitura, 0 - escrita
	       clk:    in  bit; --clock
	       output: out std_logic_vector(w-1 downto 0)  --saída 
	);
	
end component;

signal a: bit := '0';

component arbitro 
	port ( clk:                in  bit;  -- clock
	       in1, in2, in3, in4: in  std_logic_vector  (w-1 downto 0); -- entrada de dados
	       write_b:            in  std_logic_vector( 1 downto 0 );  -- escrever no buffer 
	       output:             out std_logic_vector (w-1 downto 0)); --mesma saída do MUX
end component;


component roteamento
	port ( input:  in  std_logic_vector (w-1 downto 0); --entrada = primeiro pacote do buffer
	       clk:    in  bit; --clock
	       output: out std_logic_vector (1 downto 0)  --saída 
	      );
end component;

begin
   
    --escreve o que está nas entradas
    buffer_north : buffer_r port map (in_north, a, clk, bufn_out );
    buffer_south : buffer_r port map (in_south, a, clk, bufs_out );
    buffer_east  : buffer_r port map (in_east, a, clk, bufe_out );
    buffer_west  : buffer_r port map (in_west, a, clk, bufw_out );

    --recupera
    process (clk)
    begin
	if ( clk'EVENT AND clk='1' ) then
	    a <= '1';
	end if;
    end process;

    --roteamento decide
    rot_north : roteamento port map (bufn_out, clk, rotn_out);
    rot_south : roteamento port map (bufs_out, clk, rots_out);
    rot_east  : roteamento port map (bufe_out, clk, rote_out);
    rot_west  : roteamento port map (bufw_out, clk, rotw_out);

    -- usar o arbitro
    arb_north : arbitro port map (clk, "00000000", bufs_out, bufe_out, bufw_out, rotn_out, out_north);
    arb_south : arbitro port map (clk, bufn_out, "00000000", bufe_out, bufw_out, rots_out, out_south);
    arb_east  : arbitro port map (clk, bufn_out, bufs_out, "00000000", bufw_out, rote_out, out_east);
    arb_west  : arbitro port map (clk, bufn_out, bufs_out, bufe_out, "00000000", rotw_out, out_west);

end arch_router;
