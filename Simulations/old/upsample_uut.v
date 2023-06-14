`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:02:40 07/03/2018
// Design Name:   upsample
// Module Name:   C:/Users/btg635/Desktop/brendan-spectrometer/modules/Simulations/upsample_uut.v
// Project Name:  NMR_Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: upsample
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module upsample_uut;

	// Inputs
	reg clk;
   reg [31:0] frq;
   reg [1:0] ERROR;
   reg [1:0] clk_8x_bundle;

	// Outputs
	wire [15:0] dds_i;
   wire [15:0] dds_q;

	// Instantiate the Unit Under Test (UUT)
   
   wire dds_val;
   wire [15:0] dds_i_slow, dds_q_slow;
   
   DDS_Source DDS_Source(
      .clk(clk),
      .frq(frq),
      .sin_out(dds_i_slow),
      .cos_out(dds_q_slow),
      .val(dds_val)
      );
	
   upsample upsample(
      .clk_8x_bundle(clk_8x_bundle),
      .sin_in(dds_i_slow),
      .cos_in(dds_q_slow),
      .input_val(dds_val),
      .sin_out(dds_i),
      .cos_out(dds_q),
      .val(signal_val)
      );

   always #2.5 clk = ~clk;
   
   always begin
      #0.3125 clk_8x_bundle = 2'b01;
      #0.3125 clk_8x_bundle = 2'b00;
   end
   
   always @(dds_i or dds_q) begin
      if (dds_i == 16'd0) begin
         if (dds_q == 16'd0) ERROR = 2'b11;
         else ERROR = 2'b10;
      end
      else begin
         if (dds_q == 16'd0) ERROR = 2'b01;
         else ERROR = 2'b00;
      end
   end

	initial begin
		// Initialize Inputs
		clk = 0;
      frq = 32'd5000000;

		// Wait 100 ns for global reset to finish
		#100;
       
		// Add stimulus here

	end
      
endmodule
