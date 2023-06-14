`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:54:35 06/29/2018
// Design Name:   FIR_Experiment
// Module Name:   C:/Users/btg635/Desktop/brendan-spectrometer/modules/Simulations/Fir_Experiment_uut.v
// Project Name:  NMR_Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FIR_Experiment
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Fir_Experiment_uut;

	// Inputs
	reg clk, aclk;
	reg [31:0] frq;

	// Outputs
	wire s_axis_data_tready;
	wire m_axis_data_tvalid;
	wire [15:0] m_axis_data_tdata;
   wire [15:0] sin_source_signal;

	// Instantiate the Unit Under Test (UUT)
	FIR_Experiment uut (
		.clk(clk),
		.frq(frq), 
		.s_axis_data_tready(s_axis_data_tready), 
		.m_axis_data_tvalid(m_axis_data_tvalid), 
		.m_axis_data_tdata(m_axis_data_tdata),
      .sin_source_signal(sin_source_signal)
	);

   always begin
      #2.5 aclk = ~clk;
   end

	initial begin
		// Initialize Inputs
		clk = 0;
		frq = 32'd5000000;

		// Wait 100 ns for global reset to finish
		#500;
        
		// Add stimulus here

	end
      
endmodule

