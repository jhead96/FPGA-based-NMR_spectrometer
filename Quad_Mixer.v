`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Birmingham
// Engineer: Jake Head
// 
// Create Date: 01/06/23
// Design Name: 
// Module Name: quad_mixer
// Project Name: FPGA based NMR Spectrometer
// Target Devices: SP Devices SDR14
// Tool versions: ISE Design Suite 14.7
// Description:
	 Quadrature mixer to mix incoming NMR signal with quadrature Local Oscillator I, Q signals from DDS module using Multiplier IPCores.
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
		 // TO DO
		 // - Implement genvar loop.
//////////////////////////////////////////////////////////////////////////////////

module quad_mixer (
  input clk,
  input signed [63:0] LO_i,
  input signed [63:0] LO_q,
  input signed [14*4-1:0] signal_in,
  input dds_val,
  output signed [63:0] out_i,
  output signed [63:0] out_q
);
    
  // Define internal variables
	reg signed [15:0] LO_i_split [3:0];
	reg signed [15:0] LO_q_split [3:0];
   reg signed [13:0] sig_split [3:0];
   reg signed [15:0] out_i_split [3:0];
   reg signed [15:0] out_q_split [3:0];

	wire signed [15:0] LO_i_split_to_mult [3:0];
	wire signed [15:0] LO_q_split_to_mult [3:0];
	wire signed [13:0] sig_split_to_mult [3:0];
	
	wire signed [15:0] i_split_from_mult [3:0];
	wire signed [15:0] q_split_from_mult [3:0];
	
	//reg [29:0] out_i_long[3:0];
	
   always @(posedge clk) begin
	
		if (dds_val == 1) 
			begin
			// Separate into samples
			LO_i_split[0] = LO_i[15:0];
			LO_i_split[1] = LO_i[31:16];
			LO_i_split[2] = LO_i[47:32];
			LO_i_split[3] = LO_i[63:48];
		  
			LO_q_split[0] = LO_q[15:0];
			LO_q_split[1] = LO_q[31:16];
			LO_q_split[2] = LO_q[47:32];
			LO_q_split[3] = LO_q[63:48];
			 
			sig_split[0] = signal_in[13:0];
			sig_split[1] = signal_in[27:14];
			sig_split[2] = signal_in[41:28];
			sig_split[3] = signal_in[55:42];
		 
			/* 
			// Mix signals using multiplication operator
			out_i_split[0] = LO_i_split[0] * sig_split[0];
			out_i_split[1] = LO_i_split[1] * sig_split[1];
			out_i_split[2] = LO_i_split[2] * sig_split[2];
			out_i_split[3] = LO_i_split[3] * sig_split[3];
		 
			out_q_split[0] = LO_q_split[0] * sig_split[0];
			out_q_split[1] = LO_q_split[1] * sig_split[1];
			out_q_split[2] = LO_q_split[2] * sig_split[2];
			out_q_split[3] = LO_q_split[3] * sig_split[3];
			*/
			

			// Mix signals using multiplier core
		   out_i_split[0] = i_split_from_mult[0];
			out_i_split[1] = i_split_from_mult[1];
			out_i_split[2] = i_split_from_mult[2];
			out_i_split[3] = i_split_from_mult[3];
		 
			out_q_split[0] = q_split_from_mult[0];
			out_q_split[1] = q_split_from_mult[1];
			out_q_split[2] = q_split_from_mult[2];
			out_q_split[3] = q_split_from_mult[3];
			
			

			//out_i_long[0] = i_split_from_mult[0];
			//out_i_long[1] = i_split_from_mult[1];
			//out_i_long[2] = i_split_from_mult[2];
			//out_i_long[3] = i_split_from_mult[3];			
			
			
			end
		else 
			begin
			out_i_split[0] = 0;
			out_i_split[1] = 0;
			out_i_split[2] = 0;
			out_i_split[3] = 0;
			
			out_q_split[0] = 0;
			out_q_split[1] = 0;
			out_q_split[2] = 0;
			out_q_split[3] = 0;
			end
		
		
  end
  
  assign LO_i_split_to_mult[0] = LO_i_split[0];
  assign LO_i_split_to_mult[1] = LO_i_split[1];
  assign LO_i_split_to_mult[2] = LO_i_split[2];
  assign LO_i_split_to_mult[3] = LO_i_split[3];
  
  assign LO_q_split_to_mult[0] = LO_q_split[0];
  assign LO_q_split_to_mult[1] = LO_q_split[1];
  assign LO_q_split_to_mult[2] = LO_q_split[2];
  assign LO_q_split_to_mult[3] = LO_q_split[3];
  
  assign sig_split_to_mult[0] = sig_split[0];
  assign sig_split_to_mult[1] = sig_split[1];
  assign sig_split_to_mult[2] = sig_split[2];
  assign sig_split_to_mult[3] = sig_split[3];
  
  
  // Generate multiplier cores
  quadrature_mixer_mult i_mult0(
  .clk(clk),
  .a(LO_i_split_to_mult[0]),
  .b(sig_split_to_mult[0]),
  .p(i_split_from_mult[0])
  );
  
  quadrature_mixer_mult i_mult1(
  .clk(clk),
  .a(LO_i_split_to_mult[1]),
  .b(sig_split_to_mult[1]),
  .p(i_split_from_mult[1])
  );
  
  quadrature_mixer_mult i_mult2(
  .clk(clk),
  .a(LO_i_split_to_mult[2]),
  .b(sig_split_to_mult[2]),
  .p(i_split_from_mult[2])
  );
  
  quadrature_mixer_mult i_mult3(
  .clk(clk),
  .a(LO_i_split_to_mult[3]),
  .b(sig_split_to_mult[3]),
  .p(i_split_from_mult[3])
  );
  
    quadrature_mixer_mult q_mult0(
  .clk(clk),
  .a(LO_q_split_to_mult[0]),
  .b(sig_split_to_mult[0]),
  .p(q_split_from_mult[0])
  );
  
  quadrature_mixer_mult q_mult1(
  .clk(clk),
  .a(LO_q_split_to_mult[1]),
  .b(sig_split_to_mult[1]),
  .p(q_split_from_mult[1])
  );
  
  quadrature_mixer_mult q_mult2(
  .clk(clk),
  .a(LO_q_split_to_mult[2]),
  .b(sig_split_to_mult[2]),
  .p(q_split_from_mult[2])
  );
  
  quadrature_mixer_mult q_mult3(
  .clk(clk),
  .a(LO_q_split_to_mult[3]),
  .b(sig_split_to_mult[3]),
  .p(q_split_from_mult[3])
  );
  
  assign out_i = {out_i_split[3], out_i_split[2], out_i_split[1], out_i_split[0]};
  assign out_q = {out_q_split[3], out_q_split[2], out_q_split[1], out_q_split[0]};
  
	
endmodule

