`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:55:36 08/25/2022
// Design Name:   operations
// Module Name:   C:/UoBFNS/modules_double_pulse/operations_tb.v
// Project Name:  SDR14_DevKit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: operations
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module operations_tb;

	// File I/O
	integer i;
	integer f_RF_out;
	reg [13:0] signal_in_1MHz [200:0];
	reg [13:0] signal_in_5MHz [200:0];
	reg [13:0] signal_in_10MHz [200:0];
	
	// Inputs
	reg [55:0] signal_in;
	reg clk;
	reg enable_PC;
	reg [191:0] pulse_timing_data;
	reg [63:0] time_scale_factors;
	reg [31:0] frq_out;
	reg [14:0] TX_phase_data;
	reg [4:0] RX_phase_data;

	// Outputs
	wire [111:0] signal_out;
	wire amp_enable;
	wire ADC_enable;
	wire RF_signal_valid;
	wire [63:0] data_out_i;
	wire [63:0] data_out_q;
	wire filter_valid;

	// Instantiate the Unit Under Test (UUT)
	operations uut (
		.signal_in(signal_in), 
		.signal_out(signal_out), 
		.amp_enable(amp_enable),
		.ADC_enable(ADC_enable),
		.RF_signal_valid(RF_signal_valid), 
		.clk(clk), 
		.enable_PC(enable_PC), 
		.pulse_timing_data(pulse_timing_data), 
		.frq_out(frq_out),
		.TX_phase_data(TX_phase_data),
		.RX_phase_data(RX_phase_data),
		.data_out_i(data_out_i), 
		.data_out_q(data_out_q), 
		.filter_valid(filter_valid)
	);

	initial begin
		// Initialize Inputs
		signal_in = 0;
		clk = 0;
		enable_PC = 0;
		pulse_timing_data = 0;
		time_scale_factors = 0;
		frq_out = 0;
		TX_phase_data = 14'd0;
		RX_phase_data = 5'd18;
		
		f_RF_out = $fopen("C:\\UoBFNS\\modules_v0.6.4 - TX_phase\\Simulations\\sim_data\\operations\\TX_P2_cycling.txt");
		$fmonitor(f_RF_out, "%b", signal_out);
		

		// Wait 100 ns for global reset to finish
		#102.5;

		// Set fixed pulse length
		pulse_timing_data[191:160] = 32'd200;
		pulse_timing_data[159:128] = 32'd400;
		pulse_timing_data[127:96] = 0;
		pulse_timing_data[95:64] = 32'd100;
      pulse_timing_data[63:32] = 0;
		pulse_timing_data[31:0] = 32'd100;

		// Scan 1 TX_phase = [0, 0, 0]
		frq_out = 10000000;
		TX_phase_data = {5'd0, 5'd0, 5'd0};
		enable_PC = 1;
		#1000;
		
		// PC reset
		enable_PC = 0;
		#100;
		
		// Scan 2 TX_phase = [0, 90, 0]
		TX_phase_data = {5'd0, 5'd9, 5'd0};
		enable_PC = 1;
		#1000;
		
		// PC reset
		enable_PC = 0;
		#100;
		
		// Scan 3 TX_phase = [0, 180, 0]
		TX_phase_data = {5'd0, 5'd18, 5'd0};
		enable_PC = 1;
		#1000;
		
		// PC reset
		enable_PC = 0;
		#100;
		
		// Scan 2 TX_phase = [0, 270, 0]
		TX_phase_data = {5'd0, 5'd27, 5'd0};
		enable_PC = 1;
		#1000;
		
		// PC reset
		enable_PC = 0;
		$fclose(f_RF_out);
		$finish;
		
	end
      
	always #2.5 clk = ~clk;
	
endmodule

