library IEEE;
use IEEE.std_logic_1164.all;

entity LAB1_FPGA_RTL is
    port (
        -- Globals
        fpga_clk_50        : in  std_logic;             -- clock.clk

        -- I/Os
		  sw		: in std_logic_vector(3 downto 0);
        fpga_led_pio       : out std_logic_vector(5 downto 0);
        stepmotor_pio : out std_logic_vector(3 downto 0)
  );
end entity LAB1_FPGA_RTL;

architecture rtl of LAB1_FPGA_RTL is

component niosLab2 is
  port (
		clk_clk       : in  std_logic                    := 'X';             -- clk
		leds_export   : out std_logic_vector(5 downto 0);                    -- export
		reset_reset_n : in  std_logic                    := 'X';             -- reset_n
		sw_export     : in  std_logic_vector(3 downto 0) := (others => 'X');  -- export
      stepmotor_pio_export : out std_logic_vector(3 downto 0)                     -- export
  );
end component niosLab2;

begin
u0 : component niosLab2
  port map (
		clk_clk       => fpga_clk_50,       --   clk.clk
		leds_export   => fpga_led_pio,   --  leds.export
		reset_reset_n => '1', -- reset.reset_n
		sw_export     => sw,      --    sw.export
		stepmotor_pio_export => stepmotor_pio
  );
end rtl;