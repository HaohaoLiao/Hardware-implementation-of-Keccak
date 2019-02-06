library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.all;
entity keccak_memory is
port(data_in         : in std_logic_vector(63 downto 0);
     data_vld        : in std_logic;
     done            : in std_logic;
     rst_b,clk       : in std_logic;
     data_out        : out std_logic_vector(1023 downto 0);
     data_out_vld    : out std_logic);
end entity;
architecture dataflow of keccak_memory is
component keccak_fifo
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (1023 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (1023 DOWNTO 0);
		usedw		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
	);
end component;
signal buffer_data : std_logic_vector(1023 downto 0);
signal counter: integer range 0 to 16;
signal wen,empty,full,ren : std_logic;
signal rd_empty_warning, wr_full_warning : std_logic;
signal fifo_clr : std_logic;
signal depth_of_fifo: std_logic_vector(2 downto 0);
signal data_out_vld_0dly : std_logic;
for all : keccak_fifo use entity work.keccak_fifo(SYN);
begin
fifo_clr <= not rst_b;
G0 : keccak_fifo port map(fifo_clr, clk, buffer_data, ren, wen, empty, full, data_out, depth_of_fifo);
-- counter the number of data from input
  process(clk, rst_b)
  begin
  if (rst_b ='0') then
  counter<=0;
  elsif ((counter = 16) and (clk='1' and clk'event)) then
  counter <= 0;
  elsif ((data_vld ='1') and (clk='1' and clk'event)) then
  counter<= counter + 1;
  else null;
  end if;
  end process;
-- buffer_data : combine 64 data_in into 1 1024 length data; 
process(clk, rst_b)
  begin
  if (rst_b ='0') then
  buffer_data<= X"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  elsif ((clk='1' and clk'event) and(data_vld ='1')) then
  case counter is
  when 15 => buffer_data<= data_in & buffer_data(959 downto 0);
  when 14 => buffer_data<= buffer_data(1023 downto 960) & data_in & buffer_data(895 downto 0);
  when 13 => buffer_data<= buffer_data(1023 downto 896) & data_in & buffer_data(831 downto 0);
  when 12 => buffer_data<= buffer_data(1023 downto 832) & data_in & buffer_data(767 downto 0);
  when 11 => buffer_data<= buffer_data(1023 downto 768) & data_in & buffer_data(703 downto 0);
  when 10 => buffer_data<= buffer_data(1023 downto 704) & data_in & buffer_data(639 downto 0);
  when 9  => buffer_data<= buffer_data(1023 downto 640) & data_in & buffer_data(575 downto 0);
  when 8  => buffer_data<= buffer_data(1023 downto 576) & data_in & buffer_data(511 downto 0);
  when 7  => buffer_data<= buffer_data(1023 downto 512) & data_in & buffer_data(447 downto 0);
  when 6  => buffer_data<= buffer_data(1023 downto 448) & data_in & buffer_data(383 downto 0);
  when 5  => buffer_data<= buffer_data(1023 downto 384) & data_in & buffer_data(319 downto 0);
  when 4  => buffer_data<= buffer_data(1023 downto 320) & data_in & buffer_data(255 downto 0);
  when 3  => buffer_data<= buffer_data(1023 downto 256) & data_in & buffer_data(191 downto 0);
  when 2  => buffer_data<= buffer_data(1023 downto 192) & data_in & buffer_data(127 downto 0);
  when 1  => buffer_data<= buffer_data(1023 downto 128) & data_in & buffer_data(63 downto 0) ;
  when 0  => buffer_data<= buffer_data(1023 downto 64)  & data_in ;
  when others => null;
  end case;
  else  null;
  end if;
  end process;
-- fifo wen 
process( clk, rst_b)
begin
  if(rst_b ='0') then
    wen<='0';
    elsif((counter = 16) and (clk='1' and clk'event)) then
    wen<= '1';
    elsif (clk='1' and clk'event) then
    wen<='0';
    else null;
    end if;
end process;
-- fifo ren
process( clk, rst_b)
  begin
  if(rst_b ='0') then
  ren<='0';
  elsif((ren ='1') and (clk='1' and clk'event)) then
  ren<= '0';
  elsif((done ='1') and (empty ='0') and (clk ='1' and clk'event)) then
  ren<= '1';
  else null;
  end if;
end process;
-- data_out_vld ;
process(clk, rst_b)
  begin
  if(rst_b ='0') then
  data_out_vld_0dly <='0';
  elsif ((ren ='1') and (clk ='1' and clk'event)) then
  data_out_vld_0dly <='1';
  elsif (clk='1' and clk'event) then
  data_out_vld_0dly <='0';
  else null;
  end if;
  end process;
  process(clk, rst_b)
    begin
      if (rst_b = '0') then
        data_out_vld <= '0';
      elsif(clk='1' and clk'event) then
      data_out_vld <= data_out_vld_0dly;
    else 
      null;
    end if;
  end process;
  rd_empty_warning<=ren and empty;
  wr_full_warning<= wen and full;
end architecture;










