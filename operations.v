`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Birmingham 
// Engineer: Jake Head
// 
// Create Date:  01/06/2023
// Design Name: 
// Module Name:  operations 
// Project Name: FPGA based NMR Spectrometer 
// Target Devices: SP Devices SDR14
// Tool versions: ISE Design Suite 14.7 
// Description:
//
//	 Main computational logic HDL for NMR spectrometer. Broken
//       into 3 parts:
//	- Signal generator: Generates a RF signal at the specified frequency.
//	- Signal analyzer: Implements quadrature mixing and FIR LPF on RX signal from NMR setup.
//	- Pulsers: Controls output RF phase and enable signsl for external amplifier.

// Dependencies: 
//    - signal_generator.v or eqv.
//    - signal_analysis.v or eqv.
//    - pulsers.v or eqv.
//
// Revision: 0.01
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module operations(
    input [4*14-1:0] signal_in, //external device IO - front panel -- NEEDS TO BE BLOCKED INTO 200MS/s GROUPS
    output [111:0] signal_out, //external device IO - front panel -- NEEDS TO BE BLOCKED INTO 200MS/s GROUPS
    output amp_enable, //GPIO - front panel
	 output ADC_enable, // ADC enable
    output RF_signal_valid,
    input clk,
    input enable_PC,
    input [191:0] pulse_timing_data,
    input [31:0] frq_out, //desired output frequency
    input [14:0] TX_phase_data, //from memory #1
	 input [4:0] RX_phase_data,
    output [16*4-1 : 0] data_out_i, data_out_q, //in-phase & quadrature phase to memory bank #2 - to be striped for sequential read and write
	 output filter_valid
    );

	 wire [4*16-1:0] LO_I, LO_Q;	
	 wire [8*14-1: 0] RF_out;
	 wire [1:0] TX_active_phase;
		

    signal_generator signal_generator(
        .clk(clk),
        .enable_gen(enable_PC),
        .frq_out(frq_out),
        .TX_phase_data(TX_phase_data),
		  .RX_phase_data(RX_phase_data),
		  .TX_active_phase(TX_active_phase),
        .signal_out(RF_out),
        .LO_I(LO_I),
        .LO_Q(LO_Q),
        .RF_signal_valid(RF_signal_valid)
        );
	
    signal_analysis signal_analysis(
		 .clk(clk),
       .signal_in(signal_in),
       .dds_val(RF_signal_valid),
       .dds_i(LO_I),
       .dds_q(LO_Q),
       .data_out_i(data_out_i),
       .data_out_q(data_out_q),
		 .filter_valid(filter_valid)
       );

    pulsers pulsers(
        .pulse_timing_data(pulse_timing_data),
        .clk(clk),
        .RF_signal_valid(RF_signal_valid),
		  .TX_active_phase(TX_active_phase),
        .amp_enable(amp_enable),
		  .ADC_enable(ADC_enable)
        );

// Apply pulse to RF output
assign signal_out = RF_out * amp_enable;

endmodule
