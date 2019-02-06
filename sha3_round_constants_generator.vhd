library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;	
use ieee.std_logic_unsigned.all;
use work.all;

entity sha3_round_constants_generator is
  port(round_number: in std_logic_vector(4 downto 0);
      round_constant_out: out std_logic_vector(63 downto 0));
end entity;

architecture rtl of sha3_round_constants_generator is
  
  signal rc: std_logic_vector(63 downto 0);
  
begin
  rc_proc: process(round_number)
  begin
    case round_number is
      when "00000" => rc <= X"0000000000000001";
	    when "00001" => rc <= X"0000000000008082";
	    when "00010" => rc <= X"800000000000808A";
	    when "00011" => rc <= X"8000000080008000";
	    when "00100" => rc <= X"000000000000808B";
	    when "00101" => rc <= X"0000000080000001";
	    when "00110" => rc <= X"8000000080008081";
	    when "00111" => rc <= X"8000000000008009";
	    when "01000" => rc <= X"000000000000008A";
	    when "01001" => rc <= X"0000000000000088";
	    when "01010" => rc <= X"0000000080008009";
	    when "01011" => rc <= X"000000008000000A";
	    when "01100" => rc <= X"000000008000808B";
	    when "01101" => rc <= X"800000000000008B";
	    when "01110" => rc <= X"8000000000008089";
	    when "01111" => rc <= X"8000000000008003";
	    when "10000" => rc <= X"8000000000008002";
	    when "10001" => rc <= X"8000000000000080";
	    when "10010" => rc <= X"000000000000800A";
	    when "10011" => rc <= X"800000008000000A";
	    when "10100" => rc <= X"8000000080008081";
	    when "10101" => rc <= X"8000000000008080";
	    when "10110" => rc <= X"0000000080000001";
	    when "10111" => rc <= X"8000000080008008";	    	    
	    when others => rc <=(others => '0');
	  end case;
	end process rc_proc;
	
	round_constant_out<=rc;
	
end rtl;