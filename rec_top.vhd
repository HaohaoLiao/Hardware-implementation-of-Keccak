library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.all;
entity rec_top is
port ( data_in : in std_logic;
      clk, rst_b : in std_logic;
      data_out: out std_logic_vector(63 downto 0);
    data_out_vld, led: out std_logic);
end entity;
architecture struct of rec_top is
  component detect_rec 
    port( data_in : in std_logic;
    clk,rst_b : in std_logic;
    h2l_sig, led   : out std_logic);
  end component;
  component rec_bps
    port( clk, rst_b: in std_logic;
          cnt_en : in std_logic;
          bps_clk : out std_logic);
  end component;
  component rec_ctr 
   port(
   clk,rst_b : in std_logic;
    h2l_sig : in std_logic;
    bps_clk : in std_logic;
    data_in : in std_logic;
    cnt_en  : out std_logic;
    data_out: out std_logic_vector(63 downto 0);
    -- data_out: out std_logic_vector(63 downto 0);
    data_out_vld : out std_logic );
  end component;
  for all : rec_ctr use entity work.rec_ctr(behavior);
  for all : detect_rec use entity work.detect_rec(behavior);
  for all : rec_bps use entity work.rec_bps(behavior);
  signal h2l_sig, cnt_en, bps_clk, led_temp: std_logic;
  begin
    G0: rec_ctr port map( clk, rst_b, h2l_sig, bps_clk, data_in, cnt_en, data_out, data_out_vld);
    G1: detect_rec port map(data_in, clk, rst_b, h2l_sig, led_temp);
    G2: rec_bps port map(clk, rst_b, cnt_en, bps_clk);
led<=led_temp;
end architecture;

