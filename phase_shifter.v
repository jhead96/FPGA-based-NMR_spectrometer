`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Birmingham
// Engineer: Jake Head
// 
// Create Date: 01/06/23
// Design Name: 
// Module Name: phase_shifter 
// Project Name: FPGA-based NMR spectrometer 
// Target Devices: SP Devices SDR14 
// Tool versions: ISE Design Suite 14.7 
// Description: 
//
//	Wrapper module for TX and I,Q phase shifters making use of the QPSK modules.
//	Returns a phase-shifted TX signal and I,Q signals given an input TX and RX phase.
//
// Dependencies: 
//
// Revision: 0.01
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module phase_shifter(
    input [8*16-1:0] I_in,
    input [8*16-1:0] Q_in,
    input [1:0] TX_phase,
    input [1:0] RX_phase,
	 input phases_valid,
    output [4*16-1:0] LO_I_out,
    output [4*16-1:0] LO_Q_out,
    output [8*14-1:0] RF_out
    );
	
	localparam [5:0] N_BITS_TX = 5'd14;
	localparam [4:0] N_PARA_TX = 4'd8;
	
	// TX PHASE SHIFT SIGNAL (14-BIT OUTPUT, 8 PARALLEL SAMPLES)
    QPSK #(.N_bits(N_BITS_TX), .N_para(N_PARA_TX))QPSK_tx( 
        .dds_i(I_in),
        .dds_q(Q_in),
        .RF_phase(TX_phase),
        .signal_out(RF_out)
        ); 
		  
	 // RX PHASE SHIFT SIGNAL (16-BIT OUTPUT, 4 PARALLEL SAMPLES)
	 rx_QPSK rx_QPSK(
		.I_in({I_in[111:96], I_in[79:64], I_in[47:32], I_in[15:0]}),
		.Q_in({Q_in[111:96], Q_in[79:64], Q_in[47:32], Q_in[15:0]}),
		.phase(RX_phase),
		.I_out(LO_I_out),
		.Q_out(LO_Q_out)
		);
		
endmodule
