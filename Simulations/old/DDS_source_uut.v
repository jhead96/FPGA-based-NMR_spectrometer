`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:09:09 09/27/2018
// Design Name:   DDS_Source
// Module Name:   C:/brendan-spectrometer/modules/Simulations/DDS_source_uut.v
// Project Name:  SDR14_DevKit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DDS_Source
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DDS_source_uut;

	// Inputs
	reg clk;
	reg [31:0] frq;

	// Outputs
	wire [127:0] sin_out;
	wire [127:0] cos_out;
   wire signed [15:0] sin1, sin2, sin3, sin4, sin5, sin6, sin7, sin8, cos1, cos2, cos3, cos4, cos5, cos6, cos7, cos8;
	wire val;
   
	// Instantiate the Unit Under Test (UUT)
	DDS_Source uut (
		.clk(clk), 
		.frq(frq), 
		.sin_out(sin_out), 
		.cos_out(cos_out), 
		.val(val)
	);
   
   always #2.5 clk = ~clk;
   
   assign {sin8, 
           sin7, 
           sin6, 
           sin5, 
           sin4, 
           sin3, 
           sin2, 
           sin1} = sin_out;
           
   assign {cos8,
           cos7, 
           cos6, 
           cos5, 
           cos4, 
           cos3, 
           cos2, 
           cos1} = cos_out;
   
   always @(posedge clk) begin
   //   $display(sin1, ", ", sin2, ", ", sin3, ", ", sin4, ", ", sin5, ", ", sin6, ", ", sin7, ", ", sin8);
      $display(sin1, ", ", cos1);
      $display(sin2, ", ", cos2);
      $display(sin3, ", ", cos3);
      $display(sin4, ", ", cos4);
      $display(sin5, ", ", cos5);
      $display(sin6, ", ", cos6);
      $display(sin7, ", ", cos7);
      $display(sin8, ", ", cos8);
   end
      
	initial begin
		// Initialize Inputs
		clk = 0;
		frq = 32'd400000000;
      
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

