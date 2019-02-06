library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity sha3_sponge is
  port( clk, rst_b, in_valid: in std_logic;
    in_block: in std_logic_vector(1023 downto 0);
    out_block: out std_logic_vector(255 downto 0);
    read_request, sponge_finish: out std_logic);
end entity;

architecture struct of sha3_sponge is
  component sha3_sponge_control
    port(clk, rst_b, in_valid, done_24_in, done_1m_in: in std_logic;
    reg_sel: out std_logic_vector(1 downto 0);
    permutation_start, read_request: out std_logic);
  end component;
  component state_register
    port(clk, rst_b: in std_logic;
    sel: in std_logic_vector(1 downto 0);
    input1600: in std_logic_vector(1599 downto 0);
    input1024: in std_logic_vector(1023 downto 0);
    output: out std_logic_vector(1599 downto 0));
  end component;
  component counter_24
    port(clk, rst_b, permutation_start: in std_logic;
    done_24: out std_logic;
    parallel_out: out std_logic_vector(4 downto 0));
  end component;
  component counter_1m
    port(clk, rst_b, done_24, in_valid: in std_logic;
    done_1m: out std_logic);
  end component;
  component sha3_round
    port (

    round_in     : in  std_logic_vector(1599 downto 0);
    round_constant_signal    : in std_logic_vector(63 downto 0);
    round_out    : out std_logic_vector(1599 downto 0));
  end component;
  component sha3_round_constants_generator
    port(round_number: in std_logic_vector(4 downto 0);
      round_constant_out: out std_logic_vector(63 downto 0));
  end component;
  
  for all: sha3_sponge_control use entity work.sha3_sponge_control(rtl);
  for all: state_register use entity work.state_register(rtl);
  for all: counter_24 use entity work.counter_24(rtl);
  for all: counter_1m use entity work.counter_1m(rtl);
  for all: sha3_round use entity work.sha3_round(rtl);
  for all: sha3_round_constants_generator use entity work.sha3_round_constants_generator(rtl);
  
  signal permutation_start_signal: std_logic;
  signal reg_sel_signal: std_logic_vector(1 downto 0);
  signal round_out_signal: std_logic_vector(1599 downto 0);
  signal round_in_signal: std_logic_vector(1599 downto 0);
  signal done_24_signal: std_logic;
  signal done_1m_signal: std_logic;
  signal counter_24_out: std_logic_vector(4 downto 0);
  signal round_constant_signal_signal: std_logic_vector(63 downto 0);
  
begin
  i0: sha3_sponge_control port map (clk=>clk, 
                                    rst_b=>rst_b, 
                                    in_valid=>in_valid, 
                                    done_24_in=>done_24_signal, --permutation_finish_signal
                                    done_1m_in=>done_1m_signal, --stop_signal
                                    reg_sel=>reg_sel_signal, 
                                    permutation_start=>permutation_start_signal, 
                                    read_request=>read_request);
  i1: state_register port map (     clk=>clk, 
                                    rst_b=>rst_b, 
                                    sel=>reg_sel_signal, 
                                    input1600=>round_out_signal, 
                                    input1024=>in_block, 
                                    output=>round_in_signal);
  i2: counter_24 port map (         clk=>clk, 
                                    rst_b=>rst_b, 
                                    permutation_start=>permutation_start_signal, 
                                    done_24=>done_24_signal, 
                                    parallel_out=>counter_24_out);
  i3: counter_1m port map (         clk=>clk, 
                                    rst_b=>rst_b, 
                                    done_24=>done_24_signal, 
                                    in_valid=>in_valid, 
                                    done_1m=>done_1m_signal);
  i4: sha3_round port map (         round_in=>round_in_signal, 
                                    round_constant_signal=>round_constant_signal_signal, 
                                    round_out=>round_out_signal);
  i5: sha3_round_constants_generator port map ( round_number=>counter_24_out, 
                                                round_constant_out=>round_constant_signal_signal);
  
  out_block<=round_in_signal(255 downto 0);
  sponge_finish<=done_1m_signal;
end struct;