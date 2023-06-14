`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:01:34 11/08/2022
// Design Name:   QPSK
// Module Name:   C:/UoBFNS/modules_v0.6.3 - receiver_phase/QPSK_tb.v
// Project Name:  SDR14_DevKit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: QPSK
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module QPSK_tb;

	// Inputs
	reg [127:0] dds_i;
	reg [127:0] dds_q;
	reg [1:0] RF_phase;
	localparam [5:0] N_bits = 5'd16;
	localparam [4:0] N_para = 4'd4;
	
	// Outputs
	wire [(N_para*N_bits)-1:0] signal_out;
	
	// File I/O
	integer f_out;
	reg [15:0] i_test_signal [799:0];
	reg [15:0] q_test_signal [799:0];
	reg [N_para*16-1:0] i_test_signal_parallel [(800/N_para)-1:0];
	reg [N_para*16-1:0] q_test_signal_parallel [(800/N_para)-1:0];
	integer i;

	// Instantiate the Unit Under Test (UUT)
	QPSK #(.N_bits(N_bits), .N_para(N_para)) uut (
		.dds_i(dds_i), 
		.dds_q(dds_q), 
		.RF_phase(RF_phase), 
		.signal_out(signal_out)
	);

	initial begin
		// Initialize Inputs
		i = 0;
		dds_i = 0;
		dds_q = 0;
		RF_phase = 0;
		
			
		// Load test signals
		$readmemb("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK\\test_signals\\16bit_sin_test_signal_10MHz.txt", i_test_signal);
		$readmemb("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK\\test_signals\\16bit_cos_test_signal_10MHz.txt", q_test_signal);
		
		// Parallelize signals
		for (i = 0; i < (800/N_para); i = i + 1) begin
			// For 8-parallel input
			if (N_para == 4'd8) begin
				i_test_signal_parallel[i] = {i_test_signal[8*i+7], i_test_signal[8*i+6], i_test_signal[8*i+5], i_test_signal[8*i+4], i_test_signal[8*i+3], i_test_signal[8*i+2], i_test_signal[8*i+1], i_test_signal[8*i]};
				q_test_signal_parallel[i] = {q_test_signal[8*i+7], q_test_signal[8*i+6], q_test_signal[8*i+5], q_test_signal[8*i+4], q_test_signal[8*i+3], q_test_signal[8*i+2], q_test_signal[8*i+1], q_test_signal[8*i]};
			// For 4-parallel input
			end else if (N_para == 4'd4) begin
				i_test_signal_parallel[i] = {i_test_signal[4*i+3], i_test_signal[4*i+2], i_test_signal[4*i+1], i_test_signal[4*i]};
				q_test_signal_parallel[i] = {q_test_signal[4*i+3], q_test_signal[4*i+2], q_test_signal[4*i+1], q_test_signal[4*i]};
			end
		end
		
		
		// Wait 100 ns for global reset to finish
		#100;

		// TEST SET 1 - RF_phase = 00 (0d)
		f_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK\\outputs\\testset1_16bitoutput_4parallel.txt");
		$fmonitor(f_out, "%b", signal_out);
		RF_phase = 0;	
		for (i = 0; i < 800/N_para; i = i + 1) begin	
			dds_i = q_test_signal_parallel[i];
			dds_q = i_test_signal_parallel[i];
			#5;		
		end
		$fclose(f_out);
	
		// reset
		dds_i = 0;
		dds_q = 0;
		RF_phase = 0;
		i = 0;
		#50;
		
		// TEST SET 2 - RF_phase = 01 (90d)
		f_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK\\outputs\\testset2_16bitoutput_4parallel.txt");
		$fmonitor(f_out, "%b", signal_out);
		RF_phase = 2'd1;	
		for (i = 0; i < 800/N_para; i = i + 1) begin	
			dds_i = q_test_signal_parallel[i];
			dds_q = i_test_signal_parallel[i];
			#5;		
		end
		$fclose(f_out);
		// reset
		dds_i = 0;
		dds_q = 0;
		RF_phase = 0;
		i = 0;
		#50;
		
		// TEST SET 3 - RF_phase = 11 (180d)
		f_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK\\outputs\\testset3_16bitoutput_4parallel.txt");
		$fmonitor(f_out, "%b", signal_out);
		RF_phase = 2'd3;
		for (i = 0; i < 800/N_para; i = i + 1) begin	
			dds_i = q_test_signal_parallel[i];
			dds_q = i_test_signal_parallel[i];
			#5;		
		end
		$fclose(f_out);
		
		// reset
		dds_i = 0;
		dds_q = 0;
		RF_phase = 0;
		i = 0;
		#50;
		
		// TEST SET 4 - RF_phase = 10 (270d)
		f_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK\\outputs\\testset4_16bitoutput_4parallel.txt");
		$fmonitor(f_out, "%b", signal_out);
		RF_phase = 2'd2;
		for (i = 0; i < 800/N_para; i = i + 1) begin	
			dds_i = q_test_signal_parallel[i];
			dds_q = i_test_signal_parallel[i];
			#5;		
		end
		$fclose(f_out);
		$finish;

	end
      
endmodule

