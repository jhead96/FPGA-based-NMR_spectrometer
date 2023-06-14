`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:02:29 11/16/2022
// Design Name:   rx_QPSK
// Module Name:   C:/UoBFNS/modules_v0.6.3 - receiver_phase/Simulations/Testbenches/rx_QPSK_tb.v
// Project Name:  SDR14_DevKit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: rx_QPSK
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module rx_QPSK_tb;

	// Inputs
	reg [63:0] I_in;
	reg [63:0] Q_in;
	reg [1:0] phase;

	// Outputs
	wire [63:0] I_out;
	wire [63:0] Q_out;
		
	// File I/O
	integer f_I_out, f_Q_out;
	reg [15:0] i_test_signal [799:0];
	reg [15:0] q_test_signal [799:0];
	reg [4*16-1:0] i_test_signal_parallel [199:0];
	reg [4*16-1:0] q_test_signal_parallel [199:0];
	integer i;

	
	// Instantiate the Unit Under Test (UUT)
	rx_QPSK uut (
		.I_in(I_in), 
		.Q_in(Q_in), 
		.phase(phase), 
		.I_out(I_out), 
		.Q_out(Q_out)
	);

	initial begin
		// Initialize Inputs
		I_in = 0;
		Q_in = 0;
		phase = 0;
		
		// Load test signals
		$readmemb("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK_rx\\test_signals\\16bit_sin_test_signal_10MHz.txt", i_test_signal);
		$readmemb("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK_rx\\test_signals\\16bit_cos_test_signal_10MHz.txt", q_test_signal);
		
		
		// Parallelize signals
		for (i = 0; i < 200; i = i + 1) begin
			i_test_signal_parallel[i] = {i_test_signal[4*i+3], i_test_signal[4*i+2], i_test_signal[4*i+1], i_test_signal[4*i]};
			q_test_signal_parallel[i] = {q_test_signal[4*i+3], q_test_signal[4*i+2], q_test_signal[4*i+1], q_test_signal[4*i]};
		end
		
		// Wait 100 ns for global reset to finish
		#100;
		
   
		// TEST SET 1 - PHASE = 00
		f_I_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK_rx\\outputs\\testset1_I.txt");
		f_Q_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK_rx\\outputs\\testset1_Q.txt");
		$fmonitor(f_I_out, "%b", I_out);
		$fmonitor(f_Q_out, "%b", Q_out);
		phase = 0;	
		for (i = 0; i < 200; i = i + 1) begin	
			I_in = q_test_signal_parallel[i];
			Q_in = i_test_signal_parallel[i];
			#5;		
		end
		$fclose(f_I_out);
		$fclose(f_Q_out);
		// reset
		I_in = 0;
		Q_in= 0;
		phase = 0;
		i = 0;
		#50;
		
		// TEST SET 2 - PHASE = 01
		f_I_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK_rx\\outputs\\testset2_I.txt");
		f_Q_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK_rx\\outputs\\testset2_Q.txt");
		$fmonitor(f_I_out, "%b", I_out);
		$fmonitor(f_Q_out, "%b", Q_out);
		phase = 2'd1;	
		for (i = 0; i < 200; i = i + 1) begin	
			I_in = q_test_signal_parallel[i];
			Q_in = i_test_signal_parallel[i];
			#5;		
		end
		$fclose(f_I_out);
		$fclose(f_Q_out);
		// reset
		I_in = 0;
		Q_in= 0;
		phase = 0;
		i = 0;
		#50;
		
		// TEST SET 3 - PHASE = 11
		f_I_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK_rx\\outputs\\testset3_I.txt");
		f_Q_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK_rx\\outputs\\testset3_Q.txt");
		$fmonitor(f_I_out, "%b", I_out);
		$fmonitor(f_Q_out, "%b", Q_out);
		phase = 2'd3;	
		for (i = 0; i < 200; i = i + 1) begin	
			I_in = q_test_signal_parallel[i];
			Q_in = i_test_signal_parallel[i];
			#5;		
		end
		$fclose(f_I_out);
		$fclose(f_Q_out);
		// reset
		I_in = 0;
		Q_in= 0;
		phase = 0;
		i = 0;
		#50;
		
		// TEST SET 4 - PHASE = 10
		f_I_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK_rx\\outputs\\testset4_I.txt");
		f_Q_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\QPSK_rx\\outputs\\testset4_Q.txt");
		$fmonitor(f_I_out, "%b", I_out);
		$fmonitor(f_Q_out, "%b", Q_out);
		phase = 2'd2;	
		for (i = 0; i < 200; i = i + 1) begin	
			I_in = q_test_signal_parallel[i];
			Q_in = i_test_signal_parallel[i];
			#5;		
		end
		$fclose(f_I_out);
		$fclose(f_Q_out);
		// reset
		I_in = 0;
		Q_in= 0;
		phase = 0;
		i = 0;
		#50;
		$finish;

	end
      
endmodule

