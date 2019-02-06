library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.all;
entity keccak_receive is
port ( data_in: in std_logic;
      clk,rst_b: in std_logic;
      done: in std_logic;
       data_out: out std_logic_vector(1023 downto 0);
       data_out_vld: out std_logic);
end entity;
architecture dataflow of keccak_receive is
  component keccak_memory
    port(data_in         : in std_logic_vector(63 downto 0);
     data_vld        : in std_logic;
     done            : in std_logic;
     rst_b,clk       : in std_logic;
     data_out        : out std_logic_vector(1023 downto 0);
     data_out_vld    : out std_logic);
end component;
  component detect_rec
    port( data_in : in std_logic;
    clk,rst_b : in std_logic;
    h2l_sig   : out std_logic);
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
    data_out_vld : out std_logic );
  end component;
  signal h2l_sig_top : std_logic;
  signal cnt_en_top : std_logic;
  signal bps_clk_top : std_logic;
  signal receive2mem_data_vld : std_logic;
  signal receive2mem_data :std_logic_vector(63 downto 0);
  for all : rec_ctr use entity work.rec_ctr(behavior);
  for all : rec_bps use entity work.rec_bps(behavior);
  for all : detect_rec use entity work.detect_rec(behavior);
  for all : keccak_memory use entity work.keccak_memory(dataflow);
begin
  G0: rec_ctr port map(clk, rst_b, h2l_sig_top, bps_clk_top, data_in, cnt_en_top, receive2mem_data, receive2mem_data_vld);
  G1: rec_bps port map(clk, rst_b, cnt_en_top, bps_clk_top);
  G2: detect_rec port map(data_in, clk, rst_b, h2l_sig_top);
  G3: keccak_memory port map(receive2mem_data, receive2mem_data_vld, done, rst_b, clk, data_out,data_out_vld);
end architecture;
