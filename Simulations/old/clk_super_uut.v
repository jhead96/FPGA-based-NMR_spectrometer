`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:00:38 07/04/2018
// Design Name:   clk_super
// Module Name:   C:/Users/btg635/Desktop/brendan-spectrometer/modules/simulations/clk_super_uut.v
// Project Name:  NMR_Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clk_super
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clk_super_uut;

	// Inputs
	reg clk;

	// Outputs
	wire clk_8x;

	// Instantiate the Unit Under Test (UUT)
	clk_x8 uut (
		.clk(clk), 
		.clk_8x(clk_8x)
	);

   always #2.5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

