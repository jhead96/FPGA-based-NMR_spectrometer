`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:53:02 06/11/2018
// Design Name:   QPSK
// Module Name:   U:/Internship/brendan-spectrometer/xilinx_ISE/QPSK_uut.v
// Project Name:  NMR_Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: QPSK
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module QPSK_uut;

	// Inputs
	reg [15:0] sin;
	reg [15:0] cos;
	reg [1:0] TX;
//	reg clk;

	// Outputs
	wire [15:0] signal_out;

	// Instantiate the Unit Under Test (UUT)
	QPSK uut (
//		.clk(clk),
		.sin(sin), 
		.cos(cos), 
		.TX(TX), 
		.signal_out(signal_out)
	);

//	always begin
//		#1 clk = ~clk;
//	end
	
	initial begin
		// Initialize Inputs
//		clk = 0;
		#100
		sin = 15'd100;
		cos = 15'd50;
		TX = 2'b00;
		#100;
		sin = 15'd100;
		cos = 15'd100;
		TX = 2'b10;
		#100;
		sin = 15'd75;
		cos = 15'd50;
		TX = 2'b01;
		#100;
		sin = 15'd100;
		cos = 15'd50;
		TX = 2'b11;
		#100;
		// MIRROR TX
		sin = 15'd100;
		cos = 15'd50;
		TX = 2'b00;
		#100;
		sin = 15'd100;
		cos = 15'd100;
		TX = 2'b01;
		#100;
		sin = 15'd75;
		cos = 15'd50;
		TX = 2'b10;
		#100;
		sin = 15'd100;
		cos = 15'd50;
		TX = 2'b11;
		
		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here

	end
      
endmodule

