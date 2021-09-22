
module niosLab2 (
	clk_clk,
	leds_export,
	reset_reset_n,
	stepmotor_pio_export,
	sw_export);	

	input		clk_clk;
	output	[5:0]	leds_export;
	input		reset_reset_n;
	output	[3:0]	stepmotor_pio_export;
	input	[3:0]	sw_export;
endmodule
