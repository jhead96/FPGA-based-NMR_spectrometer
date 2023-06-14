`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Birmingham
// Engineer: Brendan Gann
// 
// Create Date: 01/06/23
// Design Name: 
// Module Name: signal_analysis 
// Project Name: FPGA based NMR Spectrometer 
// Target Devices: SP Devices SDR14
// Tool versions: ISE Design Suite 14.7
// Description:
//	A wrapper module encompassing all DSP operations on the received NMR data.
//	The current implemented operations are Quad mixer > FIR 200MHz LPF.	
//
// Dependencies: 
//    - quad_mixer.v or eqv.
//    - generic_para_fir.v or eqv.
//
// Revision: 0.01
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module signal_analysis(
	 input clk,
    input signed [4*14-1 : 0] signal_in,
    input dds_val,
    input signed [4*16-1 : 0] dds_i,
    input signed [4*16-1 : 0] dds_q,
    output signed [4*16-1 : 0] data_out_i,
    output signed [4*16-1 : 0] data_out_q,
	 output filter_valid
    );

	localparam samples = 4;
	localparam taps = 19;
	localparam bits = 16;
	localparam CoeffFracBits = 17;

	wire [4*16-1:0] mixed_i, mixed_q;
	wire [19*18-1:0] coeffs_in;
	wire valid_o_q, valid_o_i;
	
	// 200MHz LPF coefficients
	reg [19*18 - 1:0] coeffs_i = {18'd69, -18'd0, -18'd823, 18'd0, 18'd3348, -18'd0, -18'd10182, 18'd0, 18'd40345, 18'd65558, 18'd40345, 18'd0, -18'd10182, -18'd0, 18'd3348, 18'd0, -18'd823, -18'd0, 18'd69};
	
	// Quad mixer
	quad_mixer quad_mixer(
		  .clk(clk),
        	  .signal_in(signal_in),
        	  .dds_val(dds_val),
        	  .LO_i(dds_i),
        	  .LO_q(dds_q),
        	  .out_i(mixed_i),
        	  .out_q(mixed_q)
        	);

	// 200MHz LPF for I
	 generic_para_fir #(
		.samp(samples),
		.taps(taps),
		.bits(bits),
		.CoeffFracBits(CoeffFracBits)
		)
		FIR_filter_200MHz_i
		(
		.clk_i(clk),
		.x_i(mixed_i),
		.y_out(data_out_i),
		.coeff_i(coeffs_in),
		.valid_i(dds_val),
		.valid_o(valid_o_i)
		);
		  
	// 200MHz LPF for Q	  
	 generic_para_fir #(
		.samp(samples),
		.taps(taps),
		.bits(bits),
		.CoeffFracBits(CoeffFracBits)
		)
		FIR_filter_200MHz_q
		(
		.clk_i(clk),
		.x_i(mixed_q),
		.y_out(data_out_q),
		.coeff_i(coeffs_in),
		.valid_i(dds_val),
		.valid_o(valid_o_q)
		);
	 

		
	assign coeffs_in = coeffs_i;
	assign filter_valid = valid_o_i & valid_o_q;
	
endmodule

