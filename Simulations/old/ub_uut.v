`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:04:39 06/21/2018
// Design Name:   pulser_UBlank
// Module Name:   C:/Users/btg635/Desktop/devel/xilinx_ISE/ub_uut.v
// Project Name:  NMR_Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pulser_UBlank
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ub_uut;

	// Inputs
	reg [7:0] record_len;
	reg [7:0] pulse_gap;
	reg [7:0] high;
	reg clk;
	reg enable;

	// Outputs
	wire u_blank;

	// Instantiate the Unit Under Test (UUT)
	pulser_UBlank uut (
		.record_len(record_len), 
		.pulse_gap(pulse_gap), 
		.high(high), 
		.clk(clk), 
		.enable(enable), 
		.u_blank(u_blank)
	);
	
	always #2.5 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		record_len = 8'd100;
		pulse_gap = 8'd50;
		high = 8'd10;
		clk = 0;
		enable = 1;

		// Wait 100 ns for global reset to finish
		#500;
        
		// Add stimulus here

	end
      
endmodule

