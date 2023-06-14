`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Birmingham
// Engineer: Jake Head 
// 
// Create Date: 01/06/23
// Design Name: 
// Module Name: rx_QPSK 
// Project Name: FPGA based NMR spectrometer 
// Target Devices: SP Devices SDR14
// Tool versions: ISE Design Suite 14.7 
// Description:
//	
//	Applies a 0,90,180,270 phase shift to a pair of I,Q input signals.
//	Outputs a pair of phase-shifted I,Q signals.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module rx_QPSK(
    input signed [63:0] I_in,
    input signed [63:0] Q_in,
    input [1:0] phase,
    output signed [63:0] I_out,
    output signed [63:0] Q_out
    );
	
	
	reg [1:0] adjusted_phase = 0;
	localparam [5:0] N_BITS_RX = 5'd16;
	localparam [4:0] N_PARA_RX = 4'd4;
	
	 // PHASE SHIFT LO_I
	 QPSK #(.N_bits(N_BITS_RX), .N_para(N_PARA_RX)) QPSK_I(
		.dds_i(I_in),
		.dds_q(Q_in),
		.RF_phase(phase),
		.signal_out(I_out)
	 );
	 
	 // PHASE SHIFT LO_Q
	 QPSK #(.N_bits(N_BITS_RX), .N_para(N_PARA_RX)) QPSK_Q(
		.dds_i(I_in),
		.dds_q(Q_in),
		.RF_phase(adjusted_phase),
		.signal_out(Q_out)
	 );
	 
	 
	// Hard code the 90d phase offset for QPSK_Q
	always@(phase) begin
		if (phase == 2'd0) begin
			adjusted_phase = 2'd2;
		end 
		else if (phase == 2'd1) begin
			adjusted_phase = 2'd0;
		end 
		else if (phase == 2'd2) begin
			adjusted_phase = 2'd3;
		end 
		else if (phase == 2'd3) begin
			adjusted_phase = 2'd1;
		end
	
	end
	 
	 
	 


endmodule
