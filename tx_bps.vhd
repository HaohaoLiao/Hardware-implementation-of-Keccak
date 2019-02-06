library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.all;

entity tx_bps is
  port (clk, rst_b, enable: in std_logic;
    bps_clk: out std_logic);
end entity;

architecture rtl of tx_bps is
  signal count_bps: std_logic_vector(8 downto 0);

  signal state: std_logic_vector(1 downto 0);
begin
  p0: process(clk, rst_b, enable)
  begin
    if (rst_b='0') then
      count_bps<=(others=>'0');
      state<="01";
    elsif (enable='1') then
      state<="10";
      count_bps<=(others=>'0');
    elsif (clk='1' and clk'event) then
      
      case state is
      when "10"=>
        if (count_bps="110110001") then--count_bps=433
          count_bps<=(others=>'0');
        else
          count_bps<=count_bps+"000000001";
        end if;
      when "01"=>
        null;
      when others=>
        null;
      end case;
    else 
      null;
    end if;
  end process p0;
  --count_bps=217
  bps_clk<=(not count_bps(8)) and count_bps(7) and count_bps(6) and 
            (not count_bps(5)) and count_bps(4) and count_bps(3) and 
            (not count_bps(2)) and (not count_bps(1)) and count_bps(0);
end rtl;
      