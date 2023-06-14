`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:51:51 06/11/2018
// Design Name:   Quad_Mixer
// Module Name:   U:/Internship/brendan-spectrometer/xilinx_ISE/Quad_Mix_utt.v
// Project Name:  NMR_Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Quad_Mixer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Quad_Mix_utt;

	// Inputs
	reg [15:0] signal_in;
	reg [15:0] dds_i;
	reg [15:0] dds_q;

	// Outputs
	wire [23:0] mixed_signal_q;
	wire [23:0] mixed_signal_i;

	// Instantiate the Unit Under Test (UUT)
	Quad_Mixer uut (
		.signal_in(signal_in), 
		.dds_i(dds_i), 
		.dds_q(dds_q), 
		.mixed_signal_q(mixed_signal_q), 
		.mixed_signal_i(mixed_signal_i)
	);

	initial begin
		// Initialize Inputs
		signal_in = 0;
		dds_i = 0;
		dds_q = 0;
		
		#10;
		
		#10;
		
		#10;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

