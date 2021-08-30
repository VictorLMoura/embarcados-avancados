library IEEE;
use IEEE.std_logic_1164.all;

entity Lab1_FPGA_RTL is
    port (
        -- Globals
        fpga_clk_50   : in  std_logic;        
		  
        -- I/Os
		  button : in  std_logic;
		  sw: in std_logic_vector(2 downto 0);
		  fpga_led_pio  : out std_logic_vector(5 downto 0)
  );
end entity Lab1_FPGA_RTL;

architecture rtl of Lab1_FPGA_RTL is

-- signal
signal blink : std_logic := '0';
signal current_state : std_logic := '0';

shared variable current_multiplier: integer range 1 to 4 := 1;

begin
	process(sw)
		begin
			current_multiplier := 1;
			if (sw(0) = '1') then
				current_multiplier := current_multiplier + 1;
			end if;
			if (sw(1) = '1') then
				current_multiplier := current_multiplier + 1;
			end if;
			if (sw(2) = '1') then
				current_multiplier := current_multiplier + 1;
			end if;
	end process;
			
	process(button)
		begin
		if (button = '1') then
			current_state <= not current_state;
		end if;
	end process;
	
  process(fpga_clk_50, current_state) 
      variable counter : integer range 0 to 25000000 := 0;
      begin
        if (rising_edge(fpga_clk_50) and current_state = '1') then
				if (counter < 25000000/current_multiplier) then
					 counter := counter + 1;
				else
					 blink <= not blink;
					 counter := 0;
				end if;
        end if;
  end process;

  fpga_led_pio(0) <= blink;
  fpga_led_pio(1) <= blink;
  fpga_led_pio(2) <= blink;
  fpga_led_pio(3) <= blink;
  fpga_led_pio(4) <= blink;
  fpga_led_pio(5) <= blink;

end rtl;