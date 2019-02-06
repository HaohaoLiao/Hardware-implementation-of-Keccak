library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity counter_1m is
  port(clk, rst_b, done_24, in_valid: in std_logic;
    done_1m: out std_logic);
end entity;

architecture rtl of counter_1m is
  signal cnt_1m: std_logic_vector(19 downto 0);
begin
  count24:process(rst_b, clk)
  begin
  if (rst_b='0') then
    cnt_1m<=(others=>'0');
  elsif (clk='1' and clk'event and in_valid='1') then
    cnt_1m<=(others=>'0');
  elsif (clk='1' and clk'event and cnt_1m="11110100001000111111") then--999999
    cnt_1m<=(others=>'0');
  elsif (clk='1' and clk'event and done_24='1') then
    cnt_1m<="00000000000000000001";
  elsif (clk='1' and clk'event and cnt_1m/="00000000000000000000") then
    cnt_1m<=cnt_1m+"00000000000000000001";
  else
    null;
  end if;
end process;
  done_1m<=cnt_1m(19) and cnt_1m(18) and cnt_1m(17) and cnt_1m(16) 
          and (not cnt_1m(15)) and cnt_1m(14) and (not cnt_1m(13))and (not cnt_1m(12))
          and (not cnt_1m(11)) and (not cnt_1m(10)) and cnt_1m(9)and (not cnt_1m(8))
          and (not cnt_1m(7)) and (not cnt_1m(6)) and cnt_1m(5)and cnt_1m(4)
          and cnt_1m(3) and cnt_1m(2) and cnt_1m(1) and cnt_1m(0);
end rtl;
