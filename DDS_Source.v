`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Birmingham
// Engineer: Jake Head
// 
// Create Date:    01/06/23
// Design Name: 
// Module Name:    DDS_source 
// Project Name: FPGA Based NMR Spectrometer
// Target Devices: SP Devices SDR14
// Tool versions: ISE Design Suite 14.7
// Description: Generates 2 200 MS/s 16-bit quadrature signals at a requested
//                frequency.
//
// Dependencies: 
//    - 200 MHz clock
//    - 32-bit unsigned frequency
//    - DDS_com_wrap.v or eqv.
//
// Revision: 0.01
//
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module DDS_source(
    input clk,
    input [31:0] frq_out,
    output signed [8*16-1:0] dds_i,
    output signed [8*16-1:0] dds_q,
    output dds_valid
    );
	
	 sin_cos_gen sin_cos_gen(
	 .clk(clk),
	 .frq_out(frq_out),
	 .dds_i(dds_i),
	 .dds_q(dds_q),
	 .dds_valid(dds_valid)
	 );
	 
	 
	 
	 
    //DDS_com_wrap DDS_com_wrap(
    //    .clk(clk), 
    //    .frq_valid(|frq), 
    //    .frq(frq), 
    //    .out_valid(val), 
    //    .sin_out(sin_out),
    //    .cos_out(cos_out)
    //    );
  

endmodule
