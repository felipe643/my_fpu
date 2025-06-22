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
	SIGNAL mantisa_a	:unsigned(21 downto 0) := (others => '0');
	SIGNAL signal_b		:STD_LOGIC := '0';
	SIGNAL exp_b		:signed(10 downto 0) := (others => '0');
	SIGNAL mantisa_b	:unsigned(21 downto 0) := (others => '0');
	SIGNAL status		:STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
begin
main: process(clk_100kHz)
	variable  signal_t   	: std_logic := '0';
	variable  mantisa_t  	: unsigned(21 downto 0) := (others => '0');
	variable  exp_t  	: signed(10 downto 0) := (others => '0');
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
				mantisa_a <= '0' & unsigned(op_a(20 downto 0));
				signal_b <= op_b(31);
				exp_b <= signed(unsigned(op_b(30 downto 20)));
				mantisa_b <= '0' & unsigned(op_b(20 downto 0));
				status_out <= (others => '0');
				status <= "001";
			when "001" =>
				if(exp_a - exp_b > 7) then
					mantisa_t   := mantisa_a;
					signal_t   := signal_a;
					exp_t   := exp_a;
	  				status <= "100";
					status_out <= "0001";
				elsif (exp_b - exp_a > 7) then
					mantisa_t   := mantisa_b;
					signal_t   := signal_b;
					exp_t   := exp_b;
	  				status <= "100";
					status_out <= "0001";
	 			else
	  				status <= "010";
				 end if;

			when "010" =>
	 			if(exp_a > exp_b) then
	  				exp_b <= exp_b + 1;
	   				if (mantisa_b(0) = '1') then
	    					out_status(0) := '1';
	   				end if;
					mantisa_b <= '0' & mantisa_b(21 downto 1);
	 			elsif(exp_b > exp_a) then
	 				 exp_a <= exp_a + 1;
	   				if (mantisa_b(0) = '1') then
	    					status_out(0) <= '1';
	    					status_out(3) <= '0';
	   				end if;
	  				mantisa_a <= '0' & mantisa_a(21 downto 1);
	 			elsif (exp_b = exp_a) then
	   				status <= "011";
	   				exp_t := exp_a;
	 			end if;
			when "011" =>
				if (mantisa_a > mantisa_b) then 
					if (signal_a = signal_b) then 
						signal_t := signal_a;
						mantisa_t := mantisa_a + mantisa_b;
					else
						signal_t := signal_a;
						mantisa_t := mantisa_a - mantisa_b;
					end if;
				elsif (mantisa_b > mantisa_a) then
					if (signal_a = signal_b) then 
						signal_t := signal_b;
						mantisa_t := mantisa_a + mantisa_b;
					else
						signal_t := signal_b;
						mantisa_t := mantisa_b - mantisa_a;
					end if;
				else
					if (signal_a /= signal_b) then
						mantisa_t := (others => '0');
						exp_t := (others => '0');
					else
						signal_t := signal_a;
						mantisa_t := mantisa_a + mantisa_b;
					end if;
				end if;
				status <= "100";
			when "100" => 
    				if (mantisa_t(21) = '1') then
        				data_out(31) <= signal_t;
        				if (exp_t = "11111111111") then
            					status_out(2) <= '1';
            					status_out(3) <= '1';
            					mantisa_t := (others => '0');
            					signal_t := '0';
            					exp_t := (others => '0');
            					status <= "000";
        				else
        			    		exp_t := exp_t + 1;
            					data_out(30 downto 20) <= std_logic_vector(exp_t);
            					data_out(19 downto 0) <= std_logic_vector(mantisa_t(20 downto 1));
            					 status <= "101";
        				end if;
    				elsif ((mantisa_t(21 downto 20) = "01") and (mantisa_t /= 0)) then
        				if (exp_t = "00000000000") then
           					status_out(1) <= '1';
            					status_out(3) <= '0';
            					mantisa_t := (others => '0');
            					signal_t := '0';
            					exp_t := (others => '0');
            					data_out <= (others => '0');
            					status <= "000";
        				else
            					exp_t := exp_t - 1;
           					 mantisa_t := mantisa_t(20 downto 0) & '0';
        				end if;
    				else
        				data_out(31) <= signal_t;
        				data_out(30 downto 20) <= std_logic_vector(exp_t);
        				data_out(19 downto 0) <= std_logic_vector(mantisa_t(19 downto 0));
    				end if;
			when others =>
			end case;
		end if;
	end process;
end architecture;
