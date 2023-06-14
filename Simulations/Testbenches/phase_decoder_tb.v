`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:09:11 05/10/2023
// Design Name:   phase_decoder
// Module Name:   C:/UoBFNS/modules_v0.6.4 - TX_phase/Simulations/Testbenches/phase_decoder_tb.v
// Project Name:  SDR14_DevKit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: phase_decoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module phase_decoder_tb;

	// Inputs
	localparam [1:0] N_phases = 2'd3;
	reg [5*N_phases-1:0] phase_decimal;

	// Outputs
	wire [2*N_phases-1:0] phase_binary;
	
	

	// Instantiate the Unit Under Test (UUT)
	phase_decoder #(.N_phases(N_phases))uut (
		.phase_decimal(phase_decimal), 
		.phase_binary(phase_binary)
	);

	initial begin
		// Initialize Inputs
		phase_decimal = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		//phase_decimal = 5'd0;
		//phase_decimal = {N_phases{5'd0}};
		phase_decimal = {5'd0, 5'd9, 5'd18};
		#20;
		//phase_decimal = 5'd9;
		//phase_decimal = {N_phases{5'd9}};
		phase_decimal = {5'd9, 5'd18, 5'd27};
		#20;
		//phase_decimal = 5'd18;
		//phase_decimal = {5'd27, 5'd9, 5'd18};
		phase_decimal = {5'd27, 5'd27, 5'd9};
		#20;
		//phase_decimal = 5'd27;
		//phase_decimal = {N_phases{5'd27}};
		phase_decimal = {5'd0, 5'd9, 5'd0};
		#20;
		$finish;
	end
      
endmodule
