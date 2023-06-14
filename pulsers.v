`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Birmingham
// Engineer: Jake Head
// 
// Create Date: 01/06/23
// Design Name:	
// Module Name pulsers
// Project Name: FPGA based NMR Spectrometer
// Target Devices: SP Devices SDR14
// Tool versions: ISE Design Suite 14.7
// Description:
//	Wrapper for pulse generating modules.
//
// Dependencies: 
//    - three_pulse.v or eqv.
//
// Revision: 0.01 
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module pulsers(
    input [191:0] pulse_timing_data,
    input clk,
    input RF_signal_valid,
	 output [1:0] TX_active_phase,
    output amp_enable,
	 output ADC_enable
    );
		  
	 three_pulse three_pulse (
		.clk(clk),
		.pulse_timing_data(pulse_timing_data),
		.RF_signal_valid(RF_signal_valid),
		.TX_active_phase(TX_active_phase),
		.amp_enable(amp_enable),
		.ADC_enable
	 );

endmodule

