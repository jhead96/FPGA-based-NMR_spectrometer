`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:05:30 09/10/2018
// Design Name:   pulsers
// Module Name:   C:/brendan-spectrometer/modules/Simulations/pulsers_uut.v
// Project Name:  SDR14_DevKit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pulsers
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pulsers_uut;

	// Inputs
	reg [4:0] tx_phase;
	reg [31:0] pulse_gap;
	reg [31:0] record_len;
	reg [31:0] period90;
	reg [31:0] period180;
	reg [31:0] time_scale_factors;
	reg clk;
	reg enable;

	// Outputs
	wire [1:0] tx;
	wire tx_val;
	wire rx;
	wire u_blank;

	// Instantiate the Unit Under Test (UUT)
	pulsers uut (
		.tx_phase(tx_phase), 
		.pulse_gap(pulse_gap), 
		.record_len(record_len), 
		.period90(period90), 
		.period180(period180), 
		.time_scale_factors(time_scale_factors), 
		.clk(clk), 
		.enable(enable), 
		.tx(tx), 
		.tx_val(tx_val), 
		.rx(rx), 
		.u_blank(u_blank)
	);

   always
      #2.5 clk = ~clk;

	initial begin
		// Initialize Inputs
		tx_phase = 5'd9;
		pulse_gap = 32'd200;
		record_len = 32'd400;
		period90 = 32'd50;
		period180 = 32'd100;
		time_scale_factors = {16'd0, 16'd0};
		clk = 0;
		enable = 1'b1;
      
		#1000;
        
		// Add stimulus here

	end
      
endmodule

