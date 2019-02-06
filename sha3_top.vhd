library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;	
use ieee.std_logic_unsigned.all;
use work.all;

entity sha3_top is
  port(clk, rst_b, rx_in, switch: in std_logic;
    tx_out, cts: out std_logic);
end entity;

architecture struct of sha3_top is
  component tx_module
    port(clk, rst_b, enable: in std_logic;
    tx_data: in std_logic_vector(255 downto 0);
    tx_pin_out: out std_logic);
  end component;
  component keccak_receive
    port ( data_in: in std_logic;
    clk,rst_b: in std_logic;
    done: in std_logic;
    data_out: out std_logic_vector(1023 downto 0);
    data_out_vld: out std_logic);
  end component;
  component sha3_sponge
    port( clk, rst_b, in_valid: in std_logic;
    in_block: in std_logic_vector(1023 downto 0);
    out_block: out std_logic_vector(255 downto 0);
    sponge_finish, read_request: out std_logic);
  end component;
  
  for all: tx_module use entity work.tx_module(struct);
  for all: keccak_receive use entity work.keccak_receive(dataflow);
  for all: sha3_sponge use entity work.sha3_sponge(struct);

  signal front_tx, read_request_signal, sponge_finish_tx, fifo_data_valid: std_logic;
  signal tx_data_tb_2048: std_logic_vector(2047 downto 0);
  signal fifo_data_1024: std_logic_vector(1023 downto 0);
  signal sponge_out_256: std_logic_vector(255 downto 0);
  
begin
  test0: keccak_receive port map (clk=>clk, rst_b=>rst_b, data_in=>rx_in, 
            done=>read_request_signal, data_out=>fifo_data_1024, data_out_vld=>fifo_data_valid);
  test1: sha3_sponge port map (clk=>clk, rst_b=>rst_b, in_valid=>fifo_data_valid, 
            in_block=>fifo_data_1024, out_block=>sponge_out_256, 
            sponge_finish=>sponge_finish_tx, read_request=>read_request_signal);
  test2: tx_module port map (clk=>clk, rst_b=>rst_b, enable=>sponge_finish_tx, 
            tx_data=>sponge_out_256, tx_pin_out=>tx_out);

	cts<=switch;


end struct;