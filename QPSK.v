`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Birmingham
// Engineer: Jake Head
// 
// Create Date: 01/06/23
// Design Name:
// Module Name: QPSK 
// Project Name: FPGA based NMR Spectrometer
// Target Devices: SP Devices SDR14
// Tool versions: ISE Design Suite 14.7
// Description:
//	Applies a 0, 90, 180, 270 phase shift to the input I, Q signals.
//	Parameters:
//		- N_bits - Number of bits in output signal.
//		- N_para - Number of parallel input samples per clock cycle.
//	
//
// Dependencies: 
//    - 2-bit Gray code phase.
//
// Revision: 0.01
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module QPSK
	#(parameter N_bits = 16,
	  parameter N_para = 8)
	(
    input signed [N_para*16-1:0] dds_i,
    input signed [N_para*16-1:0] dds_q,
    input [1:0] RF_phase, // for QPSK phase assignment, from pulsers
    output signed [N_para*N_bits-1:0] signal_out
    );

    for (genvar i = 1; i <= N_para; i = i+1) begin : qpsk_split_array
        // 1 -> positive, 0 -> negative. TX -> sin:cos
        wire signed [15:0] signed_a;
        wire signed [15:0] signed_b;
        wire signed [16:0] signal_long;
        
        
        // XOR with 'sign' bit (~TX) to produce negative/positive
        assign signed_a = {16{~RF_phase[0]}}^dds_i[i*16-1 -: 16];
        assign signed_b = {16{~RF_phase[1]}}^dds_q[i*16-1 -: 16];
        
        assign signal_long = signed_a + signed_b;       
        assign signal_out[i*N_bits-1 -: N_bits] = signal_long[16 -: N_bits];
    end
    
endmodule

