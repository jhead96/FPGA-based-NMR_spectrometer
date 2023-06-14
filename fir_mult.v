`timescale 1ns / 1ps


//////////////////////////////////////////////////////////////////////////////////
// Company: 		 SP Devices
// Engineer: 		 Daniel Björklund (daniel.bjorklund@spdevices.com)
// 
// Create Date:    12:27:35 02/09/2012 
// Design Name: 	 
// Module Name:    fir_mult
// Project Name:   SDR14 transmitter/receiver example modules
// Target Devices: SDR14
// Tool versions:  ISE 12.4
//
// Description:    
// 
//		DSP slice multiplier with preadder, for use in FIR filter modules.
// 
// Revision: 
//
//////////////////////////////////////////////////////////////////////////////////

module fir_mult #(parameter bits = 14, parameter CoeffFracBits = 17)
	(
    input [bits-1:0] x1_i,
	 input [bits-1:0] x2_i,
	 input [17:0] coeff_i,
    output [bits-1:0] y_o,
    input clk_i
    );

	wire [41:0] mult_out;
	reg [24-1:0] mult_inp;
	
   // MULT_MACRO: Multiply Function implemented in a DSP48E
   //             Virtex-6
   // Xilinx HDL Language Template, version 12.4
   
   MULT_MACRO #(
      .DEVICE("VIRTEX6"), // Target Device: ""VIRTEX5", "VIRTEX6", "SPARTAN6" 
      .LATENCY(3),        // Desired clock cycle latency, 0-4
      .WIDTH_A(24),       // Multiplier A-input bus width, 1-25
      .WIDTH_B(18)        // Multiplier B-input bus width, 1-18
   ) fir_mult_dsp48e_inst (
      .P(mult_out),     // Multiplier output bus, width determined by WIDTH_P parameter 
      .A(mult_inp),     // Multiplier input A bus, width determined by WIDTH_A parameter 
      .B(coeff_i),     // Multiplier input B bus, width determined by WIDTH_B parameter 
      .CE(1'b1),   // 1-bit active high input clock enable
      .CLK(clk_i), // 1-bit positive edge clock input
      .RST(1'b0)  // 1-bit input active high reset
   );
	
	assign y_o = mult_out[CoeffFracBits +: bits];
	
	always @(posedge clk_i) begin
		mult_inp <= {{(24-bits){x1_i[bits-1]}}, x1_i} + {{(24-bits){x2_i[bits-1]}}, x2_i};
	end
   
   // End of MULT_MACRO_inst instantiation
				

endmodule
