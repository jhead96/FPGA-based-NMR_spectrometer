`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:37:15 11/18/2022
// Design Name:   signal_generator
// Module Name:   C:/UoBFNS/modules_v0.6.3 - receiver_phase/Simulations/Testbenches/signal_generator_tb.v
// Project Name:  SDR14_DevKit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: signal_generator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module signal_generator_tb;

	// Inputs
	reg clk;
	reg enable_gen;
	reg [31:0] frq_out;
	reg [14:0] TX_phase;
	reg [4:0] RX_phase;
	reg [1:0] TX_active_phase;

	// Outputs
	wire [111:0] signal_out;
	wire [63:0] LO_I;
	wire [63:0] LO_Q;
	wire RF_signal_valid;
	
	// File I/O
	integer f_LO_I_out, f_LO_Q_out, f_RF_out;
	
	// Instantiate the Unit Under Test (UUT)
	signal_generator uut (
		.clk(clk), 
		.enable_gen(enable_gen),
		.frq_out(frq_out), 
		.TX_phase_data(TX_phase), 
		.RX_phase_data(RX_phase),
		.TX_active_phase(TX_active_phase),
		.signal_out(signal_out), 
		.LO_I(LO_I), 
		.LO_Q(LO_Q), 
		.RF_signal_valid(RF_signal_valid)
	);
	
	// Clock
	always #2.5 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		enable_gen = 0;
		frq_out = 0;
		TX_phase = 0;
		TX_active_phase = 0;
		RX_phase = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// TEST SET 1 - f = 10MHz, TX_phase = 00, RX_phase = 00
/*		f_LO_I_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\signal_generator\\outputs\\testset4_LO_I.txt");
		f_LO_Q_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\signal_generator\\outputs\\testset4_LO_Q.txt");
		f_RF_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\signal_generator\\outputs\\testset4_RF.txt");
		$fmonitor(f_LO_I_out, "%b", LO_I);
		$fmonitor(f_LO_Q_out, "%b", LO_Q);
		;*/
		
		f_RF_out = $fopen("C:\\UoBFNS\\modules_v0.6.4 - TX_phase\\Simulations\\sim_data\\signal_generator\\outputs\\TX_P2_cycling.txt");
		$fmonitor(f_RF_out, "%b", signal_out);
		// TX = [0, 0, 0]
		frq_out = 32'd10000000;
		TX_phase = {5'd0, 5'd0, 5'd0};
		TX_active_phase = 2'd0;
		RX_phase = 5'd0;
		enable_gen = 1'b1;
		#100;
		TX_active_phase = 2'd1;
		#100;
		TX_active_phase = 2'd2;
		#100;
		//$fclose(f_LO_I_out);
		//$fclose(f_LO_Q_out);

		// Emulate enable PC reset
		enable_gen = 0;
		TX_phase = 0;
		RX_phase = 0;
		#400;
		// TX = [0, 90, 0]
		TX_phase = {5'd0, 5'd9, 5'd0};
		TX_active_phase = 2'd0;
		enable_gen = 1'b1;
		#100;
		TX_active_phase = 2'd1;
		#100;
		TX_active_phase = 2'd2;
		#100;
		
		// Emulate enable PC reset
		enable_gen = 0;
		TX_phase = 0;
		RX_phase = 0;
		#400;
		
		// TX = [0, 180, 0]
		TX_phase = {5'd0, 5'd18, 5'd0};
		TX_active_phase = 2'd0;
		enable_gen = 1'b1;
		#100;
		TX_active_phase = 2'd1;
		#100;
		TX_active_phase = 2'd2;
		#100;
		
		// Emulate enable PC reset
		enable_gen = 0;
		TX_phase = 0;
		RX_phase = 0;
		#400;
		
		// TX = [0, 270, 0]
		TX_phase = {5'd0, 5'd27, 5'd0};
		TX_active_phase = 2'd0;
		enable_gen = 1'b1;
		#100;
		TX_active_phase = 2'd1;
		#100;
		TX_active_phase = 2'd2;
		#100;
		
		// Emulate enable PC reset
		enable_gen = 0;
		TX_phase = 0;
		RX_phase = 0;
		#400;
		$fclose(f_RF_out);
	   $finish;
/*	
		// TEST SET 2 - f = 10MHz, TX_phase = 00, RX_phase = 01
		f_LO_I_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\signal_generator\\outputs\\testset2_LO_I.txt");
		f_LO_Q_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\signal_generator\\outputs\\testset2_LO_Q.txt");
		f_RF_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\signal_generator\\outputs\\testset2_RF.txt");
		$fmonitor(f_LO_I_out, "%b", LO_I);
		$fmonitor(f_LO_Q_out, "%b", LO_Q);
		$fmonitor(f_RF_out, "%b", signal_out);
		
		frq_out = 32'd10000000;
		TX_phase = 2'd0;
		RX_phase = 2'd1;
		enable_gen = 1'b1;
		#400;
		$fclose(f_LO_I_out);
		$fclose(f_LO_Q_out);
		$fclose(f_RF_out);
		// reset
		clk = 0;
		enable_gen = 0;
		frq_out = 0;
		TX_phase = 0;
		RX_phase = 0;
		#50;
		
		// TEST SET 3 - f = 10MHz, TX_phase = 00, RX_phase = 11
		f_LO_I_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\signal_generator\\outputs\\testset3_LO_I.txt");
		f_LO_Q_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\signal_generator\\outputs\\testset3_LO_Q.txt");
		f_RF_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\signal_generator\\outputs\\testset3_RF.txt");
		$fmonitor(f_LO_I_out, "%b", LO_I);
		$fmonitor(f_LO_Q_out, "%b", LO_Q);
		$fmonitor(f_RF_out, "%b", signal_out);
		
		frq_out = 32'd10000000;
		TX_phase = 2'd0;
		RX_phase = 2'd3;
		enable_gen = 1'b1;
		#400;
		$fclose(f_LO_I_out);
		$fclose(f_LO_Q_out);
		$fclose(f_RF_out);
		// reset
		clk = 0;
		enable_gen = 0;
		frq_out = 0;
		TX_phase = 0;
		RX_phase = 0;
		#50;
		
		// TEST SET 4 - f = 10MHz, TX_phase = 00, RX_phase = 10
		f_LO_I_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\signal_generator\\outputs\\testset4_LO_I.txt");
		f_LO_Q_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\signal_generator\\outputs\\testset4_LO_Q.txt");
		f_RF_out = $fopen("C:\\UoBFNS\\modules_v0.6.3 - receiver_phase\\Simulations\\sim_data\\signal_generator\\outputs\\testset4_RF.txt");
		$fmonitor(f_LO_I_out, "%b", LO_I);
		$fmonitor(f_LO_Q_out, "%b", LO_Q);
		$fmonitor(f_RF_out, "%b", signal_out);
		
		frq_out = 32'd10000000;
		TX_phase = 2'd0;
		RX_phase = 2'd2;
		enable_gen = 1'b1;
		#400;
		$fclose(f_LO_I_out);
		$fclose(f_LO_Q_out);
		$fclose(f_RF_out);
		// reset
		clk = 0;
		enable_gen = 0;
		frq_out = 0;
		TX_phase = 0;
		RX_phase = 0;
		#50;*/
		


	end
      
endmodule

