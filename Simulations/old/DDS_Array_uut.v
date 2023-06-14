`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:10:11 06/18/2018
// Design Name:   DDS_Array
// Module Name:   C:/Users/btg635/Desktop/devel/xilinx_ISE/DDS_Array_uut.v
// Project Name:  NMR_Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DDS_Array
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DDS_Array_uut;

	// Inputs
	reg clk;
	reg [31:0] frq;
   reg red_sin;
   reg red_cos;
   reg red_all;

	// Outputs
	wire [15:0] sin_com_out;
	wire [15:0] cos_com_out;
	wire val;
	
	// Instantiate the Unit Under Test (UUT)
	DDS_Array uut (
		.clk(clk), 
		.frq(frq), 
		.sin_com_out(sin_com_out), 
		.cos_com_out(cos_com_out),
		.val(val)
	);

	always begin #2.5 clk = ~clk; end

   // Checks for redundant bits in output - If red_all == 1 for all time, sin0, sin1 etc likely have extra bit
   always @(sin_com_out or cos_com_out) begin
      if (sin_com_out[15] == sin_com_out[14]) red_sin = 1;
      else red_sin = 0;
      if (cos_com_out[15] == cos_com_out[14]) red_cos = 1;
      else red_cos = 0;
      red_all = red_sin & red_cos;
   end

	initial begin
		// Initialize Inputs
		clk = 0;
		frq = 5000000;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

