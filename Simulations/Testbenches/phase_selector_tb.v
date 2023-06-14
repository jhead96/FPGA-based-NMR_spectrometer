`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:30:18 05/11/2023
// Design Name:   phase_selector
// Module Name:   C:/UoBFNS/modules_v0.6.4 - TX_phase/Simulations/Testbenches/phase_selector_tb.v
// Project Name:  SDR14_DevKit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: phase_selector
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module phase_selector_tb;

	// Inputs
	reg [5:0] phase_list;
	reg [1:0] phase_selector;

	// Outputs
	wire [1:0] active_phase;

	// Instantiate the Unit Under Test (UUT)
	phase_selector uut (
		.phase_list(phase_list), 
		.phase_selector(phase_selector), 
		.active_phase(active_phase)
	);

	initial begin
		// Initialize Inputs
		phase_list = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		phase_list = {2'd0, 2'd1, 2'd2};
		phase_selector = 0;
		#20;
		phase_selector = 1;
		#20;
		phase_selector = 2'd2;
		#30;
		phase_selector = 0;
		phase_list = {2'd1, 2'd2, 2'd0};
		#20;
		phase_selector = 1;
		#20;
		phase_selector = 2'd2;
		#20;
		$finish;
		
		

	end
      
endmodule

