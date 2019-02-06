library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.all;
entity rec_bps is
port( clk, rst_b: in std_logic;
    cnt_en : in std_logic;
    bps_clk : out std_logic);
end entity;
architecture behavior of rec_bps is
signal cnt : std_logic_vector( 8 downto 0);
begin
process( clk, rst_b)
  begin
  if(rst_b ='0') then
  cnt <= "000000000";
  elsif ((clk='1' and clk'event) and (cnt="110110010")) then
  cnt <= "000000000";
  elsif ((clk='1' and clk'event) and (cnt_en ='1')) then
  cnt <= cnt +"000000001";
  elsif (clk='1' and clk'event) then
  cnt<= "000000000";
  else 
  null;
  end if;
  end process;
  bps_clk <= (not cnt(8)) and cnt(7) and cnt(6) and (not cnt(5)) and cnt(4) and cnt(3) and (not cnt(2)) and (not cnt(1)) and cnt(0);
  end architecture;
