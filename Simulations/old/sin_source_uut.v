`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:03:50 06/14/2018
// Design Name:   sin_source
// Module Name:   C:/Users/btg635/Desktop/devel/xilinx_ISE/sin_source_uut.v
// Project Name:  NMR_Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sin_source
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sin_source_uut;

	// Inputs
	reg clk;
	reg frq_valid;
	reg [31:0] phase_target;
	reg [31:0] phase_target1;
	reg [31:0] phase_target2;
	reg [32:0] frq;

	// Outputs
	wire out_valid;
	wire [15:0] out;
	wire out_valid1;
	wire [15:0] out1;
	wire out_valid2;
	wire [15:0] out2;
	
	// Instantiate the Unit Under Test (UUT)
	sin_source uut (
		.clk(clk), 
		.frq_valid(frq_valid), 
		.phase_offset(phase_target), 
		.frq(frq), 
		.out_valid(out_valid), 
		.out(out)
	);

	sin_source uut1 (
		.clk(clk), 
		.frq_valid(frq_valid), 
		.phase_offset(phase_target1), 
		.frq(frq), 
		.out_valid(out_valid1), 
		.out(out1)
	);

	sin_source uut2 (
		.clk(clk), 
		.frq_valid(frq_valid), 
		.phase_offset(phase_target2), 
		.frq(frq), 
		.out_valid(out_valid2), 
		.out(out2)
	);
	
	always begin
		#2.5 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		frq_valid = 1;
		phase_target = 0;
		frq = 32'd5000000;
		phase_target1 = 32'd13421773;
		phase_target2 = 32'd93952410;

		// Wait 100 ns for global reset to finish
		#200;
        
		// Add stimulus here

	end
      
endmodule
