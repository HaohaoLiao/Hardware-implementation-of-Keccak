library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.all;

entity tx_control is
  port(clk, rst_b, enable, bps_clk: in std_logic;
    tx_data: in std_logic_vector(255 downto 0);
    tx_pin_out: out std_logic);
end entity;

architecture rtl of tx_control is
  signal counter: std_logic_vector(3 downto 0);
  signal counter256: std_logic_vector(8 downto 0);
  signal data_register: std_logic_vector(255 downto 0);
  --signal rtx, done: std_logic;
  
  --type state_tx_bps is (idle, working);
  --signal state: state_tx_bps;
  --idle:"01"
  --working:"10"
  signal state: std_logic_vector(1 downto 0);
  
begin
  p1: process(clk, rst_b, enable)
  begin
    if (rst_b='0') then
      counter<=(others=>'0');
      counter256<=(others=>'0');
      tx_pin_out<='1';
      data_register<=(others=>'0');
      state<="01";
    elsif (enable='1') then
      counter<=(others=>'0');
      counter256<=(others=>'0');
      --data_register<=tx_data;
      data_register(199 downto 192)<=tx_data(255 downto 248);
      data_register(207 downto 200)<=tx_data(247 downto 240);
      data_register(215 downto 208)<=tx_data(239 downto 232);
      data_register(223 downto 216)<=tx_data(231 downto 224);
      data_register(231 downto 224)<=tx_data(223 downto 216);
      data_register(239 downto 232)<=tx_data(215 downto 208);
      data_register(247 downto 240)<=tx_data(207 downto 200);
      data_register(255 downto 248)<=tx_data(199 downto 192);
      
		data_register(135 downto 128)<=tx_data(191 downto 184);
      data_register(143 downto 136)<=tx_data(183 downto 176);
      data_register(151 downto 144)<=tx_data(175 downto 168);
      data_register(159 downto 152)<=tx_data(167 downto 160);
      data_register(167 downto 160)<=tx_data(159 downto 152);
      data_register(175 downto 168)<=tx_data(151 downto 144);
      data_register(183 downto 176)<=tx_data(143 downto 136);
      data_register(191 downto 184)<=tx_data(135 downto 128);
      
		data_register(71 downto 64)<=tx_data(127 downto 120);
      data_register(79 downto 72)<=tx_data(119 downto 112);
      data_register(87 downto 80)<=tx_data(111 downto 104);
      data_register(95 downto 88)<=tx_data(103 downto 96);
      data_register(103 downto 96)<=tx_data(95 downto 88);
      data_register(111 downto 104)<=tx_data(87 downto 80);
      data_register(119 downto 112)<=tx_data(79 downto 72);
      data_register(127 downto 120)<=tx_data(71 downto 64);
      
		data_register(7 downto 0)<=tx_data(63 downto 56);
      data_register(15 downto 8)<=tx_data(55 downto 48);
      data_register(23 downto 16)<=tx_data(47 downto 40);
      data_register(31 downto 24)<=tx_data(39 downto 32);
      data_register(39 downto 32)<=tx_data(31 downto 24);
      data_register(47 downto 40)<=tx_data(23 downto 16);
      data_register(55 downto 48)<=tx_data(15 downto 8);
      data_register(63 downto 56)<=tx_data(7 downto 0);
		
      state<="10";
    elsif (clk='1' and clk'event) then
      
      case state is
      when "10"=>
        
        case counter is
        when "0000"=>
          if (bps_clk='1') then 
            counter<=counter+"0001";
            tx_pin_out<='0';
          end if;
        when "0001"|"0010"|"0011"|"0100"|"0101"|"0110"|"0111"|"1000"=>
          if (bps_clk='1') then
            counter<=counter+"0001";
            --tx_pin_out<=data_register(255);
            --data_register<=data_register(254 downto 0) & '0';
            tx_pin_out<=data_register(0);
            data_register<='0' & data_register(255 downto 1);
            counter256<=counter256+"000000001";
          end if;
        when "1001"=>
          if (bps_clk='1') then
            counter<=(others=>'0');
            tx_pin_out<='1';
          end if;
        when others=>
          null;
        end case;
        
        if (counter256="100000000" and counter="0000") then
          state<="01";
        end if;
          
      when "01"=>
        null;
      when others=>
        null;
      end case;
    else
      null;
    end if;
  end process p1;
end rtl;