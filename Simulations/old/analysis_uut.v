`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:37:26 07/06/2018
// Design Name:   Signal_Analysis
// Module Name:   C:/Users/btg635/Desktop/brendan-spectrometer/modules/simulations/analysis_uut.v
// Project Name:  NMR-Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Signal_Analysis
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module analysis_uut;


// Inputs
	reg [4:0] tx_phase;
	reg [7:0] pulse_gap;
	reg [7:0] record_len;
	reg [7:0] period90;
	reg enable;

	// Outputs
	wire [1:0] tx;
	wire rx;
	wire u_blank;

	// Inputs
	reg clk;
   reg clk_625;
   reg [31:0] frq;

	// Outputs
   wire clk_8x;
   wire [15:0] dds_i;
	wire [15:0] dds_q;
	wire [15:0] data_out_i;
	wire [15:0] data_out_q;
   wire [15:0] signal_in;

	// Instantiate the Unit Under Test (UUT)
	
   
   sin_source sin_source_vInput (
      .clk(clk_625),
      .frq_valid(1'b1),
      .frq(frq),
      .out(signal_in)
      );
      
   
   Signal_Generator gen (
		.clk(clk), 
		.clk_8x(clk_8x), 
		.frq(frq), 
		.TX(tx), 
//		.signal_out(signal_out), 
		.dds_i(dds_i), 
		.dds_q(dds_q) 
//		.signal_val(signal_val)
	);
   
   Signal_Analysis uut (
		.clk_8x(clk_8x), 
		.signal_in(signal_in), 
		.rx(rx), 
		.dds_i(dds_i), 
		.dds_q(dds_q), 
		.data_out_i(data_out_i), 
		.data_out_q(data_out_q)
	);

   clk_x8 clk_x8(
      .clk(clk),
      .clk_8x(clk_8x)
      );

   pulsers pulsers_uut (
		.tx_phase(tx_phase), 
		.pulse_gap(pulse_gap), 
		.record_len(record_len), 
		.period90(period90), 
		.clk(clk), 
		.enable(enable), 
		.tx(tx), 
		.rx(rx), 
		.u_blank(u_blank)
	);

   always #2.5 clk = ~clk;
   always #0.625 clk_625 = ~clk_625;

	initial begin
		// Initialize Inputs
		clk = 0;
      clk_625 = 0;
      frq = 32'd5000000;
      tx_phase = 5'd9;
		pulse_gap = 8'd50;
		record_len = 8'd100;
		period90 = 8'd10;
      enable = 1;
      
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

