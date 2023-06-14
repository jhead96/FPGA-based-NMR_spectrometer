`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:48:37 07/04/2018
// Design Name:   downsample
// Module Name:   C:/Users/btg635/Desktop/brendan-spectrometer/modules/simulations/downsampleuut.v
// Project Name:  NMR_Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: downsample
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module downsampleuut;

	// Inputs
   reg clk;
	reg val;
   reg [31:0] frq;
	reg [23:0] mixed_signal_i;
	reg [23:0] mixed_signal_q;
   wire clk_8x;


	// Outputs
	wire [15:0] data_out_i, sin, cos;
	wire [15:0] data_out_q;

	// Instantiate the Unit Under Test (UUT)
	DDS_Source DDS_Source(
      .clk(clk_8x),
      .frq(frq),
      .sin_out(sin),
      .cos_out(cos)
//      .val(val)
      );   
   
   downsample uut (
		.clk_8x(clk_8x), 
		.rx(~val), 
		.mixed_signal_i(mixed_signal_i), 
		.mixed_signal_q(mixed_signal_q), 
		.data_out_i(data_out_i), 
		.data_out_q(data_out_q)
	);

   clk_super clk_s (
      .clk(clk),
      .clk_8x(clk_8x)
      );

   always #2.5 clk = ~clk;

   always @(sin or cos) begin
      mixed_signal_i = {sin, 8'b0};
      mixed_signal_q = {cos, 8'b0};
   end
      
	initial begin
		// Initialize Inputs
      clk = 0;
      frq = 32'd640600;
      val = 1;
		// Wait 100 ns for global reset to finish
		#500;
      
      val = 0;
      
      #500;
      
      val = 1;
      
      #500;
		// Add stimulus here

	end
      
endmodule

