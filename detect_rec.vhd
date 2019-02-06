library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.all;
entity detect_rec is
port( data_in : in std_logic;
    clk,rst_b : in std_logic;
    h2l_sig, led   : out std_logic); --h2l means high2low
end entity;
architecture behavior of detect_rec is
signal data_in_1dly: std_logic;
signal data_in_2dly: std_logic;
signal h2l_temp : std_logic;
begin
process(clk,rst_b)
  begin
  if(rst_b='0') then
  data_in_1dly <= '0';
  data_in_2dly <= '0';
  elsif(clk='1' and clk'event) then
  data_in_1dly<= data_in;
  data_in_2dly<= data_in_1dly;
  else 
  null;
  end if;
  end process;
  h2l_temp <=data_in_2dly and (not data_in_1dly);
  		process (h2l_temp)
		begin
		if(rst_b ='0') then
		led <= '0';
		elsif(h2l_temp='1') then
		led <= '1';
		else 
		null;
		end if;
		end process;
	h2l_sig<=h2l_temp;
  end architecture;
