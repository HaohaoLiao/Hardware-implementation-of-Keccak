library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;	
use work.all;


entity sha3_round is

port (

    round_in     : in  std_logic_vector(1599 downto 0);
    round_constant_signal    : in std_logic_vector(63 downto 0);
    round_out    : out std_logic_vector(1599 downto 0));

end entity;

architecture rtl of sha3_round is


  ----------------------------------------------------------------------------
  -- Internal signal declarations
  ----------------------------------------------------------------------------

 
  signal theta_in,theta_out,pi_in,pi_out,rho_in,rho_out,chi_in,chi_out,iota_in,iota_out : std_logic_vector(1599 downto 0);
  signal sum_sheet: std_logic_vector(0 to 319);
 
  
begin  -- Rtl




--connecitons

--order theta, pi, rho, chi, iota
theta_in<=round_in;
pi_in<=rho_out;
rho_in<=theta_out;
chi_in<=pi_out;
iota_in<=chi_out;
round_out<=iota_out;


--chi
i0000: for y in 0 to 4 generate
	i0001: for x in 0 to 2 generate
		i0002: for i in 63 downto 0 generate
			chi_out(64*(5*y+x)+i)<=chi_in(64*(5*y+x)+i) xor  ( not(chi_in (64*(5*y+x+1)+i))and chi_in (64*(5*y+x+2)+i));
		
		end generate;	
	end generate;
end generate;

	i0011: for y in 0 to 4 generate
		i0021: for i in 63 downto 0 generate
			chi_out(64*(5*y+3)+i)<=chi_in(64*(5*y+3)+i) xor  ( not(chi_in (64*(5*y+4)+i))and chi_in (64*(5*y)+i));
		
		end generate;	
	end generate;
	
	i0012: for y in 0 to 4 generate
		i0022: for i in 63 downto 0 generate
			chi_out(64*(5*y+4)+i)<=chi_in(64*(5*y+4)+i) xor  ( not(chi_in (64*(5*y)+i))and chi_in (64*(5*y+1)+i));
		
		end generate;	
	end generate;


--theta

--compute sum of columns

i0101: for x in 0 to 4 generate
	i0102: for i in 63 downto 0 generate
		sum_sheet(64*x+i)<=theta_in(64*x+i) xor theta_in(320+64*x+i) xor theta_in(640+64*x+i) xor theta_in(960+64*x+i) xor theta_in(1280+64*x+i);
	
	end generate;	
end generate;


i0200: for y in 0 to 4 generate
	i0201: for x in 1 to 3 generate
		theta_out(64*(5*y+x))<=theta_in(64*(5*y+x)) xor sum_sheet(64*(x-1)) xor sum_sheet(64*(x+1)+63);
		i0202: for i in 1 to 63 generate
			theta_out(64*(5*y+x)+i)<=theta_in(64*(5*y+x)+i) xor sum_sheet(64*(x-1)+i) xor sum_sheet(64*(x+1)+i-1);
		end generate;	
	end generate;
end generate;

i2001: for y in 0 to 4 generate
	theta_out(64*5*y)<=theta_in(64*5*y) xor sum_sheet(256) xor sum_sheet(127);
	i2021: for i in 1 to 63 generate
		theta_out(64*5*y+i)<=theta_in(64*5*y+i) xor sum_sheet(256+i) xor sum_sheet(i+63);
	end generate;	

end generate;

i2002: for y in 0 to 4 generate
	theta_out(64*(5*y+4))<=theta_in(64*(5*y+4)) xor sum_sheet(192) xor sum_sheet(63);
	i2022: for i in 1 to 63 generate
		theta_out(64*(5*y+4)+i)<=theta_in(64*(5*y+4)+i) xor sum_sheet(192+i) xor sum_sheet(i-1);--used to has error here
	end generate;	

end generate;

-- pi
i3001: for y in 0 to 4 generate
	i3002: for x in 0 to 4 generate
		i3003: for i in 63 downto 0 generate
			--pi_out(y)(x)(i)<=pi_in((y +2*x) mod 5)(((4*y)+x) mod 5)(i);
		--	pi_out((2*x+3*y) mod 5)(0*x+1*y)(i)<=pi_in(y) (x)(i);
                        pi_out(64*(5*((2*x+3*y)mod 5)+y)+i)<=pi_in(64*(5*y+x)+i);
		end generate;	
	end generate;
end generate;

--rho


i4001: for i in 63 downto 0 generate
	rho_out(i)<=rho_in(i);
end generate;	
i4002: for i in 63 downto 0 generate
	rho_out(64+i)<=rho_in(64+((i-1)mod 64));
end generate;
i4003: for i in 63 downto 0 generate
	rho_out(128+i)<=rho_in(128+((i-62)mod 64));
end generate;
i4004: for i in 63 downto 0 generate
	rho_out(192+i)<=rho_in(192+((i-28)mod 64));
end generate;
i4005: for i in 63 downto 0 generate
	rho_out(256+i)<=rho_in(256+((i-27)mod 64));
end generate;

i4011: for i in 63 downto 0 generate
	rho_out(320+i)<=rho_in(320+((i-36)mod 64));
end generate;	
i4012: for i in 63 downto 0 generate
	rho_out(384+i)<=rho_in(384+((i-44)mod 64));
end generate;
i4013: for i in 63 downto 0 generate
	rho_out(448+i)<=rho_in(448+((i-6)mod 64));
end generate;
i4014: for i in 63 downto 0 generate
	rho_out(512+i)<=rho_in(512+((i-55)mod 64));
end generate;
i4015: for i in 63 downto 0 generate
	rho_out(576+i)<=rho_in(576+((i-20)mod 64));
end generate;

i4021: for i in 63 downto 0 generate
	rho_out(640+i)<=rho_in(640+((i-3)mod 64));
end generate;	
i4022: for i in 63 downto 0 generate
	rho_out(704+i)<=rho_in(704+((i-10)mod 64));
end generate;
i4023: for i in 63 downto 0 generate
	rho_out(768+i)<=rho_in(768+((i-43)mod 64));
end generate;
i4024: for i in 63 downto 0 generate
	rho_out(832+i)<=rho_in(832+((i-25)mod 64));
end generate;
i4025: for i in 63 downto 0 generate
	rho_out(896+i)<=rho_in(896+((i-39)mod 64));
end generate;

i4031: for i in 63 downto 0 generate
	rho_out(960+i)<=rho_in(960+((i-41)mod 64));
end generate;	
i4032: for i in 63 downto 0 generate
	rho_out(1024+i)<=rho_in(1024+((i-45)mod 64));
end generate;
i4033: for i in 63 downto 0 generate
	rho_out(1088+i)<=rho_in(1088+((i-15)mod 64));
end generate;
i4034: for i in 63 downto 0 generate
	rho_out(1152+i)<=rho_in(1152+((i-21)mod 64));
end generate;
i4035: for i in 63 downto 0 generate
	rho_out(1216+i)<=rho_in(1216+((i-8)mod 64));
end generate;

i4041: for i in 63 downto 0 generate
	rho_out(1280+i)<=rho_in(1280+((i-18)mod 64));
end generate;	
i4042: for i in 63 downto 0 generate
	rho_out(1344+i)<=rho_in(1344+((i-2)mod 64));
end generate;
i4043: for i in 63 downto 0 generate
	rho_out(1408+i)<=rho_in(1408+((i-61)mod 64));
end generate;
i4044: for i in 63 downto 0 generate
	rho_out(1472+i)<=rho_in(1472+((i-56)mod 64));
end generate;
i4045: for i in 63 downto 0 generate
	rho_out(1536+i)<=rho_in(1536+((i-14)mod 64));
end generate;

--iota
i5001: for y in 1 to 4 generate
	i5002: for x in 0 to 4 generate
		i5003: for i in 63 downto 0 generate
			iota_out(64*(5*y+x)+i)<=iota_in(64*(5*y+x)+i);
		end generate;	
	end generate;
end generate;


	i5012: for x in 1 to 4 generate
		i5013: for i in 63 downto 0 generate
			iota_out(64*x+i)<=iota_in(64*x+i);
		end generate;	
	end generate;



		i5103: for i in 63 downto 0 generate
			iota_out(i)<=iota_in(i) xor round_constant_signal(i);
		end generate;	



end rtl;

