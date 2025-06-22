library IEEE;
use IEEE.STD_logic_1164.all;
use IEEE.numeric_STD.all;

entity fpu is port(
clk100 	: in STD_LOGIC;
op_a 	: in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
op_b 	: in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
reset 	: in STD_LOGIC := '1';

data_out	: out STD_LOGIC_VECTOR(31 downto 0);
status_out	: out STD_LOGIC_VECTOR(3 downto 0)
);
end entity;
architecture fpu of fpu is
signal signal_a 	: std_logic := '0';
signal expoente_a 	: signed(10 downto 0) := (others => '0');
signal mantisa_a 	: unsigned(21 downto 0) := (others => '0');

signal signal_b 	: std_logic := '0';
signal expoente_b 	: signed(10 downto 0) := (others => '0');
signal mantisa_b 	: unsigned(21 downto 0) := (others => '0');

signal status		: STD_LOGIC_VECTOR(2 downto 0):= (others => '0');

begin
main : process (clk100,reset)
variable signal_t  	: std_logic := '0';
variable mantisa_t   	: unsigned(21 downto 0) := (others => '0');
variable expoente_t   	: signed(10 downto 0) := (others => '0');

begin
	if ( reset = '0') then
		signal_a <= '0';
		expoente_a <= (others => '0');
		mantisa_a <= (others => '0');

		signal_b <= '0';
		expoente_b <= (others => '0');
		mantisa_b <= (others => '0');

		signal_t   := '0';
		expoente_t   := (others => '0');
		mantisa_t   := (others => '0');

		status <= "000";

	elsif (rising_edge(clk100)) then
		case status is
			when "000" =>
			signal_a <= op_a(31);
	 		expoente_a <= signed(unsigned(op_a(30 downto 20)));
	 		mantisa_a <= "01" & unsigned(op_a(19 downto 0));

	 		signal_b <= op_b(31);
	 		expoente_b <= signed(unsigned(op_b(30 downto 20)));
	 		mantisa_b <= "01" & unsigned(op_b(19 downto 0));
	
	 		status <= "001";
	 		status_out <= "1000";

		when "001" =>
	 		if(expoente_b - expoente_a > 7) then
				signal_t := signal_b;
				expoente_t   := expoente_b;
 				mantisa_t := mantisa_b;

	     			status_out <= "0001";
	  			status <= "100";
	 		elsif (expoente_a - expoente_b > 7) then
				signal_t := signal_a;
				expoente_t   := expoente_a;
 				mantisa_t := mantisa_a;

	     			status_out <= "0001";
		  		status <= "100";
	 		else
	  			status <= "010";
	 		end if;

		when "010" =>
	 		if(expoente_b > expoente_a) then
	  			expoente_a <= expoente_a + 1;
	   			if (mantisa_a(0) = '1') then
	    				status_out <= "0001";
	   			end if;
	  			mantisa_a <= '0' & mantisa_a(21 downto 1);

	 		elsif(expoente_a > expoente_b) then
	  			expoente_b <= expoente_b + 1;
	   			if (mantisa_b(0) = '1') then
	    				status_out <= "0001";
	   			end if;
	  			mantisa_b <= '0' & mantisa_b(21 downto 1);

	 		else
	  			status <= "011";
	  			expoente_t := expoente_a;
	 		end if;

		when "011" =>
			if(mantisa_a > mantisa_b)then
		 		if(signal_a = '1') then
		  			if(signal_b = '1') then
		   				mantisa_t := mantisa_a + mantisa_b;
		   				signal_t := '1';

		  			else
		  				mantisa_t := mantisa_a - mantisa_b;
		   				signal_t := '1';

		  			end if;
		 		elsif(signal_a = '0') then
		  			if(signal_b = '1') then
		   				mantisa_t := mantisa_a - mantisa_b;
		   				signal_t := '0';

		  			else
		  				mantisa_t := mantisa_a + mantisa_b;
		   				signal_t := '0';

		  			end if;
		 		end if;
			elsif(mantisa_b > mantisa_a) then
		 		if(signal_a = '1') then
		  			if(signal_b = '1') then
		   				mantisa_t := mantisa_b + mantisa_a;
		   				signal_t := '1';

		  			else
		  				mantisa_t := mantisa_b - mantisa_a;
		   				signal_t := '0';

		  			end if;
		 		elsif(signal_a = '0') then
		  			if(signal_b = '1') then
		   				mantisa_t := mantisa_b - mantisa_a;
		   				signal_t := '1';

		  			else
		  				mantisa_t := mantisa_b + mantisa_a;
		   				signal_t := '0';

		  			end if;
		 		end if;
		 
			elsif(mantisa_b = mantisa_a) then
		 		if(signal_a /= signal_b) then
		  			mantisa_t := (others => '0');
		  			expoente_t := "01111111111";
		 		else
		  			mantisa_t := mantisa_b + mantisa_a;
		  			signal_t := '0';
		 		end if;
			end if;
			status <= "100";
		when "100" =>
  			if( mantisa_t(21) = '1') then
	 			data_out(31) <= signal_t;
				if( expoente_t = "11111111111") then
	 				signal_t := '0';
					mantisa_t := (others => '0');
	 				expoente_t := (others => '0');

	 				status_out(2) <= '1';
	 				status_out(3) <= '0';

	 				data_out <= (others => '1');
	 				status <= "101";

				else
 					data_out(19 downto 0) <= std_logic_vector(mantisa_t(20 downto 1));
					expoente_t := expoente_t + 1;
	 				data_out(30 downto 20) <= std_logic_vector(expoente_t);
					status <= "101";

				end if;
  			elsif ((mantisa_t(21 downto 20) /= "01") and (mantisa_t /= 0)) then
				if( expoente_t = "00000000000") then
	 				status_out(1) <= '1';
	 				status_out(3) <= '0';

					signal_t := '0';
	 				mantisa_t := (others => '0');
	 				expoente_t := (others => '0');

	 				data_out <= (others => '0');
	 				status <= "101";

				else
	 				expoente_t := expoente_t - 1;
	 				mantisa_t := mantisa_t(20 downto 0) & '0';

				end if;
  			else
	 			data_out(31) <= signal_t;
	 			data_out(30 downto 20) <= std_logic_vector(expoente_t);
	 			data_out(19 downto 0) <= std_logic_vector(mantisa_t(19 downto 0));


  			end if;
		when others =>
 		end case;
	end if;
end process;
end architecture;
