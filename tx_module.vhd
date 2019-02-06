library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.all;

entity tx_module is
  port(clk, rst_b, enable: in std_logic;
    tx_data: in std_logic_vector(255 downto 0);
    tx_pin_out: out std_logic);
end entity;

architecture struct of tx_module is
  component tx_bps
    port (clk, rst_b, enable: in std_logic;
    bps_clk: out std_logic);
  end component;
  component tx_control
    port(clk, rst_b, enable, bps_clk: in std_logic;
    tx_data: in std_logic_vector(255 downto 0);
    tx_pin_out: out std_logic);
  end component;
  
  for all: tx_bps use entity work.tx_bps(rtl);
  for all: tx_control use entity work.tx_control(rtl);
  
  signal bps_clk_signal: std_logic;
  
begin
  t0: tx_bps port map (clk=>clk, rst_b=>rst_b, enable=>enable, bps_clk=>bps_clk_signal);
  t1: tx_control port map (clk=>clk, rst_b=>rst_b, enable=>enable, bps_clk=>bps_clk_signal, 
                  tx_data=>tx_data, tx_pin_out=>tx_pin_out);
end struct;
