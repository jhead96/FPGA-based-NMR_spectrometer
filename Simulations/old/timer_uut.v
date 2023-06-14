`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:09:01 06/19/2018
// Design Name:   timer
// Module Name:   C:/Users/Brendan/Documents/brendan-spectrometer/xilinx_ISE/timer_uut.v
// Project Name:  NMR_Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: timer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module timer_uut;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [63:0] time_elaps;

	// Instantiate the Unit Under Test (UUT)
	ns_timer uut (
		.clk(clk), 
		.reset(reset), 
		.time_elaps(time_elaps)
	);

	always begin
		#2.5 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		#1
		@(posedge clk) reset = 0;
		

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

