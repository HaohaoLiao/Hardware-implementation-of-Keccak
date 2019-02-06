library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;	
use work.all;

entity sha3_sponge_counter is
  port(permutation_finish, clk, rst_b, in_valid: in std_logic;
    stop: out std_logic);
end entity;

architecture rtl of sha3_sponge_counter is
  signal counter_waiting: std_logic_vector(19 downto 0);

  signal state: std_logic_vector(1 downto 0);
  
begin
  p0: process(clk, rst_b)
  begin
    if (rst_b='0') then
      counter_waiting<=(others=>'0');
      stop<='0';
      state<="01";
    elsif (clk='1' and clk'event) then
      
      case state is
      when "10"=>
        if (in_valid='1') then
          counter_waiting<=(others=>'0');
          state<="01";
        elsif (counter_waiting="11110100001001000001") then
          counter_waiting<=counter_waiting+"00000000000000000001";
          stop<='1';
        elsif (counter_waiting="11110100001001000010") then
          counter_waiting<=(others=>'0');
          state<="01";
        else
          counter_waiting<=counter_waiting+"00000000000000000001";
        end if;
      when "01"=>
        stop<='0';
        if (permutation_finish='1') then
          state<="10";
        else
          null;
        end if;
      when others=>
        null;
      end case;
    else
      null;
    end if;
  end process;
end rtl;