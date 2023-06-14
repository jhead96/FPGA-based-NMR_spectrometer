`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:10:06 06/26/2018
// Design Name:   DDS_Array
// Module Name:   C:/Users/btg635/Desktop/brendan-spectrometer/modules/Simulations/DDS_Array_debug_uut.v
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

module DDS_Array_debug_uut;

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
	wire [25:0] sin0;
	wire [25:0] sin1;
	wire [25:0] sin2;
	wire [25:0] sin3;
	wire [25:0] sin4;
	wire [25:0] sin5;
	wire [25:0] sin6;
	wire [25:0] sin7;
	wire [25:0] cos0;
	wire [25:0] cos1;
	wire [25:0] cos2;
	wire [25:0] cos3;
	wire [25:0] cos4;
	wire [25:0] cos5;
	wire [25:0] cos6;
	wire [25:0] cos7;

	// Instantiate the Unit Under Test (UUT)
	DDS_Array uut (
		.clk(clk), 
		.frq(frq), 
		.sin_com_out(sin_com_out), 
		.cos_com_out(cos_com_out), 
		.val(val), 
		.sin0(sin0), 
		.sin1(sin1), 
		.sin2(sin2), 
		.sin3(sin3), 
		.sin4(sin4), 
		.sin5(sin5), 
		.sin6(sin6), 
		.sin7(sin7), 
		.cos0(cos0), 
		.cos1(cos1), 
		.cos2(cos2), 
		.cos3(cos3), 
		.cos4(cos4), 
		.cos5(cos5), 
		.cos6(cos6), 
		.cos7(cos7)
	);

   always #2.5 clk = ~clk;

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
		frq = 1000000;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

