`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:38:23 09/28/2018
// Design Name:   Signal_Generator
// Module Name:   C:/brendan-spectrometer/modules/Simulations/Signal_Generator_uut.v
// Project Name:  SDR14_DevKit
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

module Signal_Generator_uut;

	// Inputs
	reg clk;
	reg enable;
	reg [31:0] frq;
	reg [1:0] TX;

	// Outputs
	wire [111:0] signal_out;
	wire [127:0] dds_i;
	wire [127:0] dds_q;
	wire signal_val;
   wire signed [13:0] sin1, sin2, sin3, sin4, sin5, sin6, sin7, sin8;


	// Instantiate the Unit Under Test (UUT)
	Signal_Generator uut (
		.clk(clk), 
		.enable(enable), 
		.frq(frq), 
		.TX(TX), 
		.signal_out(signal_out), 
		.dds_i(dds_i), 
		.dds_q(dds_q), 
		.signal_val(signal_val)
	);
   
   assign {sin8, 
           sin7, 
           sin6, 
           sin5, 
           sin4, 
           sin3, 
           sin2, 
           sin1} = signal_out;
   
   always #2.5 clk = ~clk;
   
   always @(posedge clk) begin
      $display(sin1); 
      $display(sin2); 
      $display(sin3);
      $display(sin4);
      $display(sin5);
      $display(sin6);
      $display(sin7);
      $display(sin8);
   end

	initial begin
		// Initialize Inputs
		clk = 0;
		enable = 1;
		frq = 32'd400000000;
		TX = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

