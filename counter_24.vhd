library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity counter_24 is
  port(clk, rst_b, permutation_start: in std_logic;
    done_24: out std_logic;
    parallel_out: out std_logic_vector(4 downto 0));
end entity;

architecture rtl of counter_24 is
  signal cnt_24: std_logic_vector(4 downto 0);
begin
  count24:process(rst_b, clk)
  begin
  if (rst_b='0') then
    cnt_24<=(others=>'0');
  elsif (clk='1' and clk'event and cnt_24="10111") then
    cnt_24<=(others=>'0');
  elsif (clk='1' and clk'event and permutation_start='1') then
    cnt_24<="00001";
  elsif (clk='1' and clk'event and cnt_24/="00000") then
    cnt_24<=cnt_24+"00001";
  else
    null;
  end if;
end process;
  done_24<=cnt_24(4) and (not cnt_24(3)) and cnt_24(2) and cnt_24(1) and cnt_24(0);
  parallel_out<=cnt_24;
end rtl;
