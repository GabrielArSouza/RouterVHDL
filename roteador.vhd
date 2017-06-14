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
signal bufn_out, bufs_out, bufe_out, bufw_out : std_logic_vector(w-1 downto 0) := "00000000";
signal zero : bit := '0';

component buffer_r

        port ( input:  in  std_logic_vector(w-1 downto 0); --entrada
	       action: in  bit; -- 1 - leitura, 0 - escrita
	       clk:    in  bit; --clock
	       output: out std_logic_vector(w-1 downto 0)  --saída 
	);
	
end component;

begin
 
    --escreve o que está nas entradas
    buffer_north : buffer_r port map (in_north, zero, clk, bufn_out );
    buffer_south : buffer_r port map (in_south, zero, clk, bufs_out );
    buffer_east  : buffer_r port map (in_east, zero, clk, bufe_out );
    buffer_west  : buffer_r port map (in_west, zero, clk, bufw_out );

    --recupera
    buffer_north_r : buffer_r port map (in_north, '1', clk, bufn_out );
    buffer_south_r : buffer_r port map (in_south, '1', clk, bufs_out );
    buffer_east_r  : buffer_r port map (in_east, '1', clk, bufe_out );
    buffer_west_r  : buffer_r port map (in_west, '1', clk, bufw_out );

    --roteamento decide

    out_north <= bufn_out;
    out_south <= bufs_out;
    out_east <= bufe_out;
    out_west <= bufw_out;
end arch_router;
