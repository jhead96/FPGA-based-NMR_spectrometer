`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Birmingham
// Engineer: Jake Head
// 
// Create Date: 01/06/2023 
// Design Name: 
// Module Name: phase_decoder 
// Project Name: FPGA based NMR Spectrometer
// Target Devices: SP Devices SDR14
// Tool versions: ISE Design Suite 14.7
// Description:
//
//	 Converts array of decimal phase angles provided (either 0, 90, 180 or 270)
//       into array of 2-bit Gray code phase.
//
//	 Parameters:
//		- N_phases: Number of elements in decimal phase array input.
//
//
// Dependencies: 
//    - Input decimal phase data. 
//
// Revision: 
// Revision 0.01
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module phase_decoder
	#(parameter N_phases = 1)
    (
	  input [5*N_phases-1:0] phase_decimal,
     output [2*N_phases-1:0] phase_binary
     );
	  
	  

	// Decimal angle to Grey encoding using if conditions
	for (genvar i = 1; i <= N_phases; i = i + 1) begin: decode_phases
		assign phase_binary[2*i-1 -: 2] = decoded_phase(phase_decimal[5*i-1 -: 5]);
	end

function [2:0] decoded_phase;
	input [4:0] decimal;
	begin
	
		if (decimal == 5'd0) begin
			 decoded_phase = 2'b11;
	   end else if (decimal == 5'd9) begin
			 decoded_phase = 2'b10;
	   end else if (decimal == 5'd18) begin
			 decoded_phase = 2'b00;
	   end else if (decimal == 5'd27) begin
			 decoded_phase = 2'b01;
	   end else begin // Fallback to 00 with invalid input
			 decoded_phase = 2'b00;
	   end
	
	end	
endfunction

endmodule





	
	
	

