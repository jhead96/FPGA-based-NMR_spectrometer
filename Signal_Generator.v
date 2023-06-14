`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Birmingham
// Engineer: Jake Head
// 
// Create Date: 01/06/23
// Design Name:
// Module Name: signal_generator 
// Project Name: FPGA based NMR Spectrometer
// Target Devices: SP Devices SDR14
// Tool versions: ISE Design Suite 14.7 
// Description:
//	 Generates I,Q signals at a specified frequency using DDS.
//	 Determines current active phase based off signal from pulsers.v.
//	 Applies phase shift to I,Q signals.
//
// Dependencies: 
//    - DDS_Array.v or eqv.
//    - QPSK.v or eqv.
//
//
// Revision: 0.01
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module signal_generator(
    input clk,
    input enable_gen,
    input [31:0] frq_out,
    input [14:0] TX_phase_data,
	 input [4:0] RX_phase_data,
	 input [1:0] TX_active_phase,
    output reg signed [8*14-1:0] signal_out,
    output signed [4*16-1:0] LO_I, LO_Q,
    output RF_signal_valid
    );   

    wire dds_valid, TX_phase_valid, RX_phase_valid;
    wire [8*14-1:0] RF_signal;
	 wire [8*16-1:0] dds_I, dds_Q;
	 wire [5:0] TX_phase_binary;
	 wire [1:0] current_TX_phase, current_RX_phase;
	
	 localparam N_PHASES_TX = 2'd3;
	
	 // GENERATE I,Q SIGNALS
    DDS_source DDS_source(
        .clk(clk),
        .frq_out(frq_out),
        .dds_i(dds_I),
        .dds_q(dds_Q),
        .dds_valid(dds_valid)
        );
	
	
	 // CONVERT TX PHASES TO BINARY
    phase_decoder #(.N_phases(N_PHASES_TX)) TX(
        .phase_decimal(TX_phase_data),
        .phase_binary(TX_phase_binary)
        );
		  
	// CONVERT RX PHASE TO BINARY
    phase_decoder RX(
        .phase_decimal(RX_phase_data),
        .phase_binary(current_RX_phase)
        );
		  
	 // SELECT TX PHASE DEPENDING ON PULSE NUMBER
	 phase_selector TX_selector(
		.phase_list(TX_phase_binary),
		.phase_selector(TX_active_phase),
		.active_phase(current_TX_phase)
	 );
	 
	 
	 // PHASE SHIFT TX AND RX
    phase_shifter phase_shifter( 
        .I_in(dds_I),
        .Q_in(dds_Q),
        .TX_phase(current_TX_phase),
		  .RX_phase(current_RX_phase),
		  .phases_valid(TX_RX_phases_valid),
        .LO_I_out(LO_I),
		  .LO_Q_out(LO_Q),
		  .RF_out(RF_signal)
        ); 
		
	 // Determine if output RF signal is valid = DDS valid
    assign RF_signal_valid = (enable_gen & dds_valid);
    // Output RF signal if valid
    always @(posedge clk) begin 
        if (RF_signal_valid)
            signal_out = RF_signal;
        else
            signal_out = 8*14'b0;
    end
	 
	 
   

endmodule

