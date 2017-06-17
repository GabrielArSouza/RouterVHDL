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
signal rotn_out, rots_out, rote_out, rotw_out : std_logic_vector (1 downto 0) := "UU";

component buffer_r

        port ( input:  in  std_logic_vector(w-1 downto 0); --entrada
	       action: in  std_logic_vector (1 downto 0); -- 10 - leitura, 00 - escrita, 11 - clear
	       clk:    in  bit; --clock
	       output: out std_logic_vector(w-1 downto 0)  --saída 
	);
	
end component;

signal a: std_logic_vector (1 downto 0) := "00";

component arbitro 
	port ( clk:                in  bit;  -- clock
	       in1, in2, in3, in4: in  std_logic_vector  (w-1 downto 0); -- entrada de dados
	       write_b:            in  std_logic_vector( 1 downto 0 );  -- escrever no buffer 
	       output:             out std_logic_vector (w-1 downto 0)); --mesma saída do MUX
end component;


component router_logic
	port ( input:  in  std_logic_vector (w-1 downto 0); --entrada = primeiro pacote do buffer
	       clk:    in  bit; --clock
	       output: out std_logic_vector (1 downto 0)  --saída 
	      );
end component;

signal lib_n, lib_s, lib_e, lib_w: std_logic_vector(1 downto 0);

begin
   
    --escreve o que está nas entradas
    buffer_north : buffer_r port map (in_north, a, clk, bufn_out );
    buffer_south : buffer_r port map (in_south, a, clk, bufs_out );
    buffer_east  : buffer_r port map (in_east, a, clk, bufe_out );
    buffer_west  : buffer_r port map (in_west, a, clk, bufw_out );
   
    --roteamento decide
    rot_north : router_logic port map (bufn_out, clk, rotn_out);
    rot_south : router_logic port map (bufs_out, clk, rots_out);
    rot_east  : router_logic port map (bufe_out, clk, rote_out);
    rot_west  : router_logic port map (bufw_out, clk, rotw_out);

    -- Para onde vai o norte?
    process(clk)
    begin
    if( clk'EVENT AND clk='1')then
        if ( rotn_out = "00" ) then
  		--Ele quer ir para norte
		lib_n <= "00";
    	elsif ( rotn_out = "01") then
		--Ele quer ir para o sul
		lib_s <= "00";
    	elsif ( rotn_out = "10") then
		--Ele quer ir para o leste
		lib_e <= "00";
    	elsif ( rotn_out = "11") then
		--ELe quer ir para o oeste
		lib_w <= "00";
	end if;

	if ( rots_out = "00" ) then
  		--Ele quer ir para norte
		lib_n <= "01";
    	elsif ( rots_out = "01") then
		--Ele quer ir para o sul
		lib_s <= "01";
    	elsif ( rots_out = "10") then
		--Ele quer ir para o leste
		lib_e <= "01";
    	elsif ( rots_out = "11") then
		--ELe quer ir para o oeste
		lib_w <= "01";
	end if;

	if ( rote_out = "00" ) then
  		--Ele quer ir para norte
		lib_n <= "10";
    	elsif ( rote_out = "01") then
		--Ele quer ir para o sul
		lib_s <= "10";
    	elsif ( rote_out = "10") then
		--Ele quer ir para o leste
		lib_e <= "10";
    	elsif ( rote_out = "11") then
		--ELe quer ir para o oeste
		lib_w <= "10";
	end if;

	if ( rotw_out = "00" ) then
  		--Ele quer ir para norte
		lib_n <= "11";
    	elsif ( rotw_out = "01") then
		--Ele quer ir para o sul
		lib_s <= "11";
    	elsif ( rotw_out = "10") then
		--Ele quer ir para o leste
		lib_e <= "11";
    	elsif ( rotw_out = "11") then
		--ELe quer ir para o oeste
		lib_w <= "11";
	end if;
    end if;
    end process;

    -- usar o arbitro
    arb_north : arbitro port map (clk, "00000000", bufs_out, bufe_out, bufw_out, lib_n, out_north);
    arb_south : arbitro port map (clk, bufn_out, "00000000", bufe_out, bufw_out, lib_s, out_south);
    arb_east  : arbitro port map (clk, bufn_out, bufs_out, "00000000", bufw_out, lib_e, out_east);
    arb_west  : arbitro port map (clk, bufn_out, bufs_out, bufe_out, "00000000", lib_w, out_west);

end arch_router;
