`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:57:41 07/23/2018
// Design Name:   sdr14_user_logic
// Module Name:   C:/brendan-spectrometer/modules/Simulations/sdr14_user_logic_uut.v
// Project Name:  SDR14_DevKit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sdr14_user_logic
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sdr14_user_logic_uut;

	// Inputs
	reg clk_1_4;
	reg [15:0] data_a0_i;
	reg [15:0] data_a1_i;
	reg [15:0] data_a2_i;
	reg [15:0] data_a3_i;
	reg data_valid_i;
	reg [511:0] user_register_i;

	// Outputs
	wire [15:0] data_a0_o;
	wire [15:0] data_a1_o;
	wire [15:0] data_a2_o;
	wire [15:0] data_a3_o;
	wire [15:0] data_b0_o;
	wire [15:0] data_b1_o;
	wire [15:0] data_b2_o;
	wire [15:0] data_b3_o;
	wire [13:0] dac_a0_o;
	wire [13:0] dac_a1_o;
	wire [13:0] dac_a2_o;
	wire [13:0] dac_a3_o;
	wire [13:0] dac_a4_o;
	wire [13:0] dac_a5_o;
	wire [13:0] dac_a6_o;
	wire [13:0] dac_a7_o;
	wire dac_a_valid_o;
	wire [4:0] com_gpio_o;
	wire [4:0] com_gpio_oen_o;
	wire [31:0] ul_partnumber_1_o;
	wire [31:0] ul_partnumber_2_o;

	// Instantiate the Unit Under Test (UUT)
	sdr14_user_logic uut (
		.clk_1_4(clk_1_4), 
		.data_a0_i(data_a0_i), 
		.data_a1_i(data_a1_i), 
		.data_a2_i(data_a2_i), 
		.data_a3_i(data_a3_i), 
		.data_valid_i(data_valid_i), 
		.data_a0_o(data_a0_o), 
		.data_a1_o(data_a1_o), 
		.data_a2_o(data_a2_o), 
		.data_a3_o(data_a3_o), 
		.data_b0_o(data_b0_o), 
		.data_b1_o(data_b1_o), 
		.data_b2_o(data_b2_o), 
		.data_b3_o(data_b3_o), 
		.dac_a0_o(dac_a0_o), 
		.dac_a1_o(dac_a1_o), 
		.dac_a2_o(dac_a2_o), 
		.dac_a3_o(dac_a3_o), 
		.dac_a4_o(dac_a4_o), 
		.dac_a5_o(dac_a5_o), 
		.dac_a6_o(dac_a6_o), 
		.dac_a7_o(dac_a7_o), 
		.dac_a_valid_o(dac_a_valid_o), 
		.user_register_i(user_register_i), 
		.com_gpio_o(com_gpio_o), 
		.com_gpio_oen_o(com_gpio_oen_o), 
		.ul_partnumber_1_o(ul_partnumber_1_o), 
		.ul_partnumber_2_o(ul_partnumber_2_o)
	);


   always #2.5 clk_1_4 = ~clk_1_4;
   
   // simulated input
   
//   reg clk_625;
//   initial clk_625 = 1;
//   always #0.625 clk_625 = ~clk_625;
//   wire [15:0] signal_in_fast;
//   wire [63:0] signal_in_full;
   
//   DDS_com_wrap DDS_com_wrap (
//      .clk(clk_625),
//      .frq_valid(1'b1),
//      .frq(32'd5000000),
//      .sin_out(signal_in_fast)
//      );

//   output_buffer buffer_vInput (
//      .clk(clk_1_4),
//      .clk_8x(clk_625),
//      .dds_i(signal_in_fast),
//      .dds_q(signal_in_fast),
//      .dds_com(signal_in_full)
//      );

   
//   always @(signal_in_full) begin
//      {data_a0_i, data_a1_i, data_a2_i, data_a3_i} = signal_in_full[63:0];
//   end


	initial begin
		// Initialize Inputs
		clk_1_4 = 1;
		data_a0_i = 0;
		data_a1_i = 0;
		data_a2_i = 0;
		data_a3_i = 0;
		data_valid_i = 1;
      
		user_register_i[511:192] = 0;
		user_register_i[191:160] = 32'd300; // reg[5] pulse_180
		user_register_i[159:128] = 32'd130; // reg[4] pulse_90
		user_register_i[127:96] = 32'd1000; // reg[3] record_len
		user_register_i[95:64] = 32'd400; // reg[2] pulse_gap
		user_register_i[63:32] = 32'd10000000; // reg[1] frq
		user_register_i[31:13] = 0; // reg[0][31:8] empty
		user_register_i[12:8] = 5'd18; // reg[0][12:8] tx_phase
		user_register_i[7:1] = 0; // reg[0][7:1] empty
		user_register_i[0] = 1'b1; // reg[0][0] enable_PC

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

