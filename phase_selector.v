`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Birmingham
// Engineer: Jake Head
// 
// Create Date: 01/06/23
// Design Name: 	
// Module Name: phase_selector 
// Project Name: FPGA-based NMR spectrometer
// Target Devices: SP Devices SDR14
// Tool versions: ISE Design Suite 14.7
// Description: 
//
//	Selects a given phase from an array of phases.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module phase_selector(
    input [5:0] phase_list,
    input [1:0] phase_selector,
    output reg [1:0] active_phase
    );
	 
	always @* begin
		if (phase_selector == 2'd0) begin
			active_phase = phase_list[1:0];
			
		end else if (phase_selector == 2'd1) begin
			active_phase = phase_list[3:2];
			
		end else if (phase_selector == 2'd2) begin
			active_phase = phase_list[5:4];
			
		end else begin
			active_phase = 2'b0;
		end
		
	end
	
endmodule
