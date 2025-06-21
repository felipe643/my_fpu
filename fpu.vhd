library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


entity fpu is PORT(
reset 		: in STD_LOGIC; 
clk_100kHz	: in STD_LOGIC; 
op_a		: in STD_LOGIC_VECTOR(31 downto 0);
op_b		: in STD_LOGIC_VECTOR(31 downto 0); 

data_out	: out STD_LOGIC_VECTOR(31 downto 0);
status_out	: out STD_LOGIC_VECTOR(3 downto 0)

);
end entity;

architecture FPU of fpu is
	SIGNAL signal_a		:STD_LOGIC := '0';
	SIGNAL exp_a		:signed(10 downto 0) := (others => '0');
	SIGNAL mantisa_a	:unsigned(20 downto 0) := (others => '0');
	SIGNAL signal_b		:STD_LOGIC := '0';
	SIGNAL exp_b		:signed(10 downto 0) := (others => '0');
	SIGNAL mantisa_b	:unsigned(20 downto 0) := (others => '0');
	SIGNAL status		:STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
begin
main: process(clk_100kHz)
	variable  signal_temp   : std_logic := '0';
	variable  mantisa_temp  : unsigned(20 downto 0) := (others => '0');
	variable  exp_temp   	: signed(10 downto 0) := (others => '0');
	variable  out_status 	: std_logic_vector(3 downto 0) := (others => '0');
	begin
		if (reset = '0') then
			data_out <= (OTHERS => '0');
			status_out <= (others => '0'); 
			signal_a <= '0';
			exp_a <= (others => '0');
			mantisa_a <= (others => '0');
			signal_b <= '0';
			exp_b <= (others => '0');
			mantisa_b <= (others => '0');
			status <= (others => '0');
		elsif (rising_edge(clk_100kHz)) then
			case status is
			when "000" =>			
				signal_a <= op_a(31);
				exp_a <= signed(unsigned(op_a(30 downto 20)));
				mantisa_a <= '0' & unsigned(op_a(19 downto 0));
				signal_b <= op_b(31);
				exp_b <= signed(unsigned(op_b(30 downto 20)));
				mantisa_b <= '0' & unsigned(op_b(19 downto 0));
				status_out <= (others => '0');
				status <= "001";
			when "001" =>
				if(exp_a - exp_b > 7) then
					mantisa_temp   := mantisa_a;
					signal_temp   := signal_a;
					exp_temp   := exp_a;
	  				status <= "100";
				elsif (exp_b - exp_a > 7) then
					mantisa_temp   := mantisa_b;
					signal_temp   := signal_b;
					exp_temp   := exp_b;
	  				status <= "100";
	 			else
	  				status <= "010";
	  				exp_b <= exp_b - 1027;
	  				exp_a <= exp_a - 1027;
				 end if;

			when "010" =>
	 			if(exp_a > exp_b) then
	  				exp_b <= exp_b + 1;
	   				if (mantisa_b(0) = '1') then
	    					out_status(0) := '1';
	   				end if;
					mantisa_b <= '0' & mantisa_b(20 downto 1);
	 			elsif(exp_b > exp_a) then
	 				 exp_a <= exp_a + 1;
	   				if (mantisa_b(0) = '1') then
	    					out_status(0) := '1';
	   				end if;
	  				mantisa_a <= '0' & mantisa_a(20 downto 1);
	 			elsif (exp_b = exp_a) then
	   				status <= "011";
	   				exp_temp := exp_a + 1027;
	 			end if;
			when "011" =>
				if (mantisa_a > mantisa_b) then 
					if (signal_a = signal_b) then 
						signal_temp := signal_a;
						mantisa_temp := mantisa_a + mantisa_b;
					else
						signal_temp := signal_a;
						mantisa_temp := mantisa_a - mantisa_b;
					end if;
				elsif (mantisa_b > mantisa_a) then
					if (signal_a = signal_b) then 
						signal_temp := signal_b;
						mantisa_temp := mantisa_a + mantisa_b;
					else
						signal_temp := signal_b;
						mantisa_temp := mantisa_b - mantisa_a;
					end if;
				else
					if (signal_a /= signal_b) then
						mantisa_temp := (others => '0'); 	
					else
						signal_temp := signal_a;
						mantisa_temp := mantisa_a + mantisa_b;
					end if;
				end if;
				status <= "100";
			when "100" => 
  				if ((mantisa_temp(20 downto 19) = "00") and (mantisa_temp /= 0)) then
					exp_temp := exp_temp - 1;
					mantisa_temp := mantisa_temp(19 downto 0) & '0';
  				else
					if( mantisa_temp(20) = '1') then
	 					data_out(31) <= signal_temp;
	 					data_out(30 downto 20) <= std_logic_vector(exp_temp + 1);
	 					data_out(19 downto 0) <= std_logic_vector(mantisa_temp(20 downto 1));
					else
	 					data_out <= signal_temp & std_logic_vector(exp_temp) & std_logic_vector(mantisa_temp(19 downto 0));
					end if;
  				end if;	
			when others =>
			end case;
		end if;
	end process;
end architecture;
