`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:39:46 07/15/2019
// Design Name:   operations
// Module Name:   C:/brendan-spectrometer/SDR14_DevKit/FPGA/implementation/xilinx/full_system_test.v
// Project Name:  SDR14_DevKit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: operations
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module full_operations_test;

	// Inputs
   wire [63:0] signal_in;
	reg clk;
	reg enable_PC;
	reg [191:0] time_len_data;
	reg [63:0] time_scale_factors;
	reg [31:0] frq;
	reg [4:0] tx_phase_data;

	// Outputs
	wire [111:0] signal_out;
	wire u_blank;
	wire signal_val;
	wire signed [15:0] data_out_i;
	wire signed [15:0] data_out_q;

	// Instantiate the Unit Under Test (UUT)
	operations uut (
		.signal_in(signal_in), 
		.signal_out(signal_out), 
		.u_blank(u_blank), 
		.signal_val(signal_val), 
		.clk(clk), 
		.enable_PC(enable_PC), 
		.time_len_data(time_len_data), 
		.time_scale_factors(time_scale_factors), 
		.frq(frq), 
		.tx_phase_data(tx_phase_data), 
		.data_out_i(data_out_i), 
		.data_out_q(data_out_q)
	);
   
   
   // Input simulation
   
   reg [31:0] input_frq;
   wire [8*16-1:0] gen_input;
   
   DDS_Source input_gen (
      .clk(clk),
      .frq(input_frq),
      .sin_out(gen_input),
      .cos_out(),
      .val()
   );
   
   for (genvar i=1; i <= 4; i = i+1) begin
      assign signal_in[i*16-1 -: 16] = gen_input[2*i*16-1 -: 16];
   end
   
   always #2.5 clk = ~clk;
  


`define DATA 1
       
`ifdef OUTPUT   
   wire signed [0:13] sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8;
   
   assign {sig8,
           sig7,
           sig6,
           sig5,
           sig4,
           sig3,
           sig2,
           sig1} = signal_out;
   always @(signal_out) begin
      $display(sig8);
      $display(sig7);
      $display(sig6);
      $display(sig5);
      $display(sig4);
      $display(sig3);
      $display(sig2);
      $display(sig1);
   end
`endif

`ifdef DATA
   always @(data_out_i) begin
      $display(data_out_i, ",", data_out_q);
   end
`endif

	initial begin
		// Initialize Inputs
		clk = 0;
		enable_PC = 1;
        time_len_data = {
            32'd200, // pulse 1
            32'd400, // pulse 2
            32'd0,   // pulse 3
            32'd200, // gap 1
            32'd0,   // gap 2
            32'd500 // record len
            };
		time_scale_factors = {
            16'd1, // gap 1 SF
            16'd1, // gap 2 SF
            32'd1 // record len SF
            };
		frq = 32'd3000000;
		tx_phase_data = 5'b0;
      
      input_frq = 32'd1000000;

		// Wait 100 ns for global reset to finish

	end
      
endmodule

