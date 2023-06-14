`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:54:14 09/25/2018
// Design Name:   DDS_com
// Module Name:   C:/no-interpol-spectrometer/modules/Simulations/DDS_com.v
// Project Name:  SDR14_DevKit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DDS_com
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DDS_com_uut;
   reg clk;
   reg frq_valid;
   reg [31:0] frq; //in Hz
   wire out_valid;
   wire signed [15:0] sin_out1, sin_out2;
   wire signed [15:0] cos_out1, cos_out2;
	 
   reg [32:0] INPUT_LEN;
   reg [27:0] CLK_FRQ; 
   reg [4:0] FRQ_OFFSET_COEFF; //can be shortened
   reg [31:0] frq_offset;
   wire [8*32 - 1 :0] out;
   wire [7:0] phase_test;
	
   
   
   always @(frq) begin
      INPUT_LEN = 33'b1 << 32; // 2^32
      CLK_FRQ = 28'd200000000;
      FRQ_OFFSET_COEFF = INPUT_LEN/CLK_FRQ;
      frq_offset = FRQ_OFFSET_COEFF*frq;
   end

   for (genvar i = 1; i <= 8; i = i + 1) begin
      DDS_com  DDS_com_uut1(
         .aclk(clk), // input aclk
         .s_axis_config_tvalid(frq_valid), // input s_axis_config_tvalid
         .s_axis_config_tdata({(i*(frq_offset/8)), frq_offset}), // input [63 : 0] s_axis_config_tdata - [63:32] phase offset - [31:0] frq
         .m_axis_data_tvalid(out_valid), // output m_axis_data_tvalid
         .m_axis_data_tdata(out[i*32 -1 -: 32]) // output [31 : 0] m_axis_data_tdata
         );	
   end

   
   assign sin_out1 = out[31:16];
   assign cos_out1 = out[15:0];
   assign {sin_out2, cos_out2} = out[2*32 -1 -: 32];
   
   for (genvar i = 1; i <= 8; i = i+1)
      assign phase_test[i-1] = {out[i*32-1]};
   
   
   always #2.5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
      frq = 32'd800000000;
      frq_valid = 1;
      

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

