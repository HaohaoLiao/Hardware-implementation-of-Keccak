library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity sha3_sponge_control is
  port(clk, rst_b, in_valid, done_24_in, done_1m_in: in std_logic;
    reg_sel: out std_logic_vector(1 downto 0);
    permutation_start, read_request: out std_logic);
end entity;

architecture rtl of sha3_sponge_control is
  signal cstate, nstate: std_logic_vector(4 downto 0);
  --idle: 00001
  --absorbing: 00010
  --squeezing: 00100
  --permutation: 01000
  --permutation_wait: 10000
begin
  sponge:process(clk, rst_b)
  begin
    if (rst_b='0') then
      cstate<="00001";
    elsif (clk='1' and clk'event) then
      cstate<=nstate;
    else
      null;
    end if;
  end process;
  
  decoding:process(cstate, in_valid, done_24_in, done_1m_in)
  begin
    case cstate is
    when "00001"=>
      if (in_valid='1') then
        nstate<="00010";
      --elsif (done_24_in='1') then--permutation finished
        --nstate<="00001";
      elsif (done_1m_in='1') then--20ms counting finished
        nstate<="00100";
      else
        nstate<="00001";
      end if;
    when "00010"=>
      nstate<="01000";
    when "00100"=>
      nstate<="00001";
    when "01000"=>
      nstate<="10000";
    when "10000"=>
      if (done_24_in='1') then
        nstate<="00001";
      else
        nstate<="10000";
      end if;
    when others=>
      null;
    end case;
  end process;
  
  output:process(cstate)
  begin
    case cstate is
    when "00001"=>
      reg_sel<="00";
      permutation_start<='0';
    when "00010"=>
      reg_sel<="10";--xor_load
      permutation_start<='0';
    when "00100"=>
      reg_sel<="11";--clear
      permutation_start<='0';
    when "01000"=>
      reg_sel<="01";--load_1600bit
      permutation_start<='1';--enable counter_24
    when "10000"=>
      reg_sel<="01";--load_1600bit
      permutation_start<='0';
    when others=>
      null;
    end case;
  end process;
  
  rd: process(clk, rst_b, in_valid, done_24_in)
  begin
    if(rst_b='0') then
      read_request<='1';
    elsif (clk='1' and clk'event and in_valid='1') then
      read_request<='0';
    elsif (clk='1' and clk'event and done_24_in='1') then
      read_request<='1';
    else
      null;
    end if;
  end process;

end rtl;