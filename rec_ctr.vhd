library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.all;
entity rec_ctr is
port(
    clk,rst_b : in std_logic;
    h2l_sig : in std_logic;
    bps_clk : in std_logic;
    data_in : in std_logic;
    cnt_en  : out std_logic;
    data_out: out std_logic_vector(63 downto 0);
    data_out_vld : out std_logic );
end entity;
architecture behavior of rec_ctr is
signal i : integer range 0 to 12;
signal rec_data : std_logic_vector( 7 downto 0);
signal iscount : std_logic ;
signal isdone : std_logic;
signal counter : integer range 0 to 8; 
signal data_buffer: std_logic_vector(63 downto 0);
begin
process (clk, rst_b)
  begin
    if(rst_b= '0') then
      i<=0;
      rec_data<="00000000";
      iscount <='0';
      isdone <='0';
    elsif( clk='1' and clk'event) then
      case i is
      when 0 =>
        if(h2l_sig ='1') then
          i<=i+1;iscount<='1';
        else null;
         end if;
    when 1 =>
      if(bps_clk='1') then
        i<=i+1;
      
else null;
    
  end if;
    when 2 =>
      if(bps_clk ='1') then
        i<= i+1;
        rec_data(0) <= data_in;
      else null;
      end if;
    when 3 =>
      if(bps_clk ='1') then
        i<= i+1;
        rec_data(1) <= data_in;
        else null;
      end if;
        when 4 =>
      if(bps_clk ='1') then
        i<= i+1;
        rec_data(2) <= data_in;
      else null;
      end if;
      when 5 =>
      if(bps_clk ='1') then
        i<= i+1;
        rec_data(3) <= data_in;
      else null;
      end if;
      when 6 =>
      if(bps_clk ='1') then
        i<= i+1;
        rec_data(4) <= data_in;
      else null;
      end if;
        when 7 =>
      if(bps_clk ='1') then
        i<= i+1;
        rec_data(5) <= data_in;
      else null;
      end if;
      when 8 =>
      if(bps_clk ='1') then
        i<= i+1;
        rec_data(6) <= data_in;
      else null;
      end if;
      
when 9 =>
      if(bps_clk ='1') then
        i<= i+1;
        rec_data(7) <= data_in;
      else null;
      end if;
    when 10 =>
      if(bps_clk='1') then
        i<=i+1;
      else null;
      end if;
    when 11 =>
        i<=i+1; isdone<='1';iscount<='0';
    when 12=>
      i<=0; isdone<='0';
    when others =>
      null;
  end case;
end if;
end process;
process(clk,rst_b)
begin
  if(rst_b ='0') then
  counter<= 0;
  elsif(clk'event and clk ='1') and (isdone ='1') then
  counter <= counter + 1;
  elsif (clk'event and clk='1') and (counter=8) then
  counter <= 0;
  else null;
  end if;
end process;
process (clk,rst_b) 
begin
  if(rst_b='0') then
    data_buffer<= "0000000000000000000000000000000000000000000000000000000000000000";
  elsif (isdone<='1') and (clk ='1' and clk'event) then
    case counter is
      when 0 =>
        data_buffer <= rec_data & data_buffer(55 downto 0);
      when 1 =>
        data_buffer <= data_buffer(63 downto 56) & rec_data & data_buffer(47 downto 0);
      when 2 =>
        data_buffer <= data_buffer(63 downto 48) & rec_data & data_buffer(39 downto 0);
      when 3 =>
        data_buffer <= data_buffer(63 downto 40) & rec_data & data_buffer(31 downto 0);
      when 4 =>
        data_buffer <= data_buffer(63 downto 32) & rec_data & data_buffer(23 downto 0);
      when 5 =>
        data_buffer <= data_buffer(63 downto 24) & rec_data & data_buffer(15 downto 0);
      when 6 =>
        data_buffer <= data_buffer(63 downto 16) & rec_data & data_buffer(7 downto 0);
      when 7 =>
        data_buffer <= data_buffer(63 downto 8) & rec_data;
      when others =>
        null;
    end case;
  else null;
  end if;
end process;
process(clk,rst_b)
begin
  if(rst_b='0') then
    data_out_vld<='0';
  elsif((clk ='1' and clk'event) and (counter=8)) then
    data_out_vld <='1';
  elsif(clk ='1' and clk'event) then
   data_out_vld <='0';
  else 
  null;
  end if;
end process;
data_out<= data_buffer;
cnt_en<=iscount;
end architecture;

