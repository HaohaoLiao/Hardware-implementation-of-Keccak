library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;	
use ieee.std_logic_unsigned.all;
use work.all;

entity sha3_permutation is
  port( clk, permutation_start: in std_logic;
    input: in std_logic_vector(1599 downto 0);
    output: out std_logic_vector(1599 downto 0);
    permutation_finish: out std_logic);
end entity;

architecture rtl of sha3_permutation is
  component sha3_round
    port(round_in: in std_logic_vector(1599 downto 0);
      round_constant_signal: in std_logic_vector(63 downto 0);
      round_out: out std_logic_vector(1599 downto 0));
  end component;
  --component sha3_state_register
  --  port(clk,`: in std_logic;
  --    din_load : in std_logic_vector(1599 downto 0);
  --    dout : out std_logic_vector(1599 downto 0));
  --end component;
  component sha3_round_constants_generator is
    port(round_number: in unsigned(4 downto 0);
      round_constant_out: out std_logic_vector(63 downto 0));
  end component;
  
  for all: sha3_round use entity work.sha3_round(rtl);
  for all: sha3_round_constants_generator use entity work.sha3_round_constants_generator(rtl);
  --for all: sha3_state_register use entity work.sha3_state_register(rtl);
  
  --signal temp_register: std_logic_vector(1599 downto 0);
  signal round_in: std_logic_vector(1599 downto 0);
  signal round_out: std_logic_vector(1599 downto 0);
  signal rc_temp: std_logic_vector(63 downto 0);
  signal counter: unsigned(4 downto 0);
  
  signal state: std_logic_vector(2 downto 0);
  
  begin
    i0: sha3_round port map (round_in=>round_in, round_constant_signal=>rc_temp, round_out=>round_out);
    i1: sha3_round_constants_generator port map (round_number=>counter, round_constant_out=>rc_temp);
    
    trans: process(permutation_start, clk)
    begin
      if (permutation_start='1') then
        state<="010";
        counter<=(others => '0');
      elsif (clk='1' and clk'event) then
        
        case state is
      when "010"=>
        round_in<=input;
        state<="100";
        counter<=(others => '0');
      when "100"=>
        if (counter<23) then
          round_in<=round_out;
          counter <= counter + 1;
          state<="100";
        elsif (counter=23) then
          --round_in<=round_out;
          permutation_finish<='1';
          state<="001";
        end if;
      when "001"=>
        permutation_finish<='0';
        counter<=(others => '0'); 
      when others=>
        null;   
      end case;
      
      else
        null;
      end if;
    end process trans;
    
    output<=round_out;
end rtl;     
          
          
          
        
        