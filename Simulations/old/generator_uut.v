`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:34:15 07/06/2018
// Design Name:   Signal_Generator
// Module Name:   C:/Users/btg635/Desktop/brendan-spectrometer/modules/simulations/generator_uut.v
// Project Name:  NMR-Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Signal_Generator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module generator_uut;

	// Inputs
	reg clk;
   reg enable;
	wire clk_8x;
	reg [31:0] frq;
	reg [1:0] TX;

	// Outputs
	wire signed [13:0] signal_out;
	wire [15:0] dds_i;
	wire [15:0] dds_q;
	wire signal_val;

	// Instantiate the Unit Under Test (UUT)
	Signal_Generator uut (
      .enable(enable),
		.clk(clk), 
		.clk_8x(clk_8x), 
		.frq(frq), 
		.TX(TX), 
		.signal_out(signal_out), 
		.dds_i(dds_i), 
		.dds_q(dds_q), 
		.signal_val(signal_val)
	);

   clk_x8 clk_x8 (
      .clk(clk),
      .clk_8x(clk_8x)
      );
   
   always #2.5 clk = ~clk;
      
	initial begin
		// Initialize Inputs
      enable = 1;
		clk = 0;
		frq = 32'd5000000;
		TX = 2'b10;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

