`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:01:36 01/29/2020
// Design Name:   sin_cos_gen
// Module Name:   C:/UoBFNS/modules - DDS IPcore Multi-DDS 15  2 Core/sin_cos_gen_tb.v
// Project Name:  SDR14_DevKit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sin_cos_gen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sin_cos_gen_tb;

	// Inputs
	reg clk;
	reg [31:0] frq;
	
	wire [31:0] phase_inc_out;
	//wire [63:0] phase_inc_out_2;
	
	//wire [31:0] DDS_out_reg_p, DDS_out_reg_2_p;
   wire [15:0] sin_out_reg_p, sin_out_reg_2_p, sin_out_reg_3_p, sin_out_reg_4_p,sin_out_reg_5_p, sin_out_reg_6_p, sin_out_reg_7_p, sin_out_reg_8_p;
	//wire [15:0] cos_out_reg_p, cos_out_reg_2_p;
	wire [127:0] signal_out_sin;
	wire [127:0] signal_out_cos;
	wire out_valid, out_valid_2;

	// Instantiate the Unit Under Test (UUT)
	sin_cos_gen uut (
		.clk(clk), 
		.frq(frq),
		.phase_inc_out(phase_inc_out),
		//.phase_inc_out_2(phase_inc_out_2),
		//.DDS_out_reg_p(DDS_out_reg_p),
		//.DDS_out_reg_2_p(DDS_out_reg_2_p),
		.sin_out_reg_p(sin_out_reg_p),
		.sin_out_reg_2_p(sin_out_reg_2_p),
		.sin_out_reg_3_p(sin_out_reg_3_p),
		.sin_out_reg_4_p(sin_out_reg_4_p),
		.sin_out_reg_5_p(sin_out_reg_5_p),
		.sin_out_reg_6_p(sin_out_reg_6_p),
		.sin_out_reg_7_p(sin_out_reg_7_p),
		.sin_out_reg_8_p(sin_out_reg_8_p),
		//.cos_out_reg_p(cos_out_reg_p),
		//.cos_out_reg_2_p(cos_out_reg_2_p),
		.signal_out_sin(signal_out_sin),
		.signal_out_cos(signal_out_cos),
		.out_valid(out_valid)
		//.out_valid_2(out_valid_2)
	);



	initial begin
	 clk = 1'b0;
	end
	// Period is the time between succesive '0' values i.e. 200 MHz = 5ns period = #2.5 
	always #2.5 clk=~clk;
	
	
	initial begin
		// Initialize Inputs
		frq = 0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		frq = 700000000;
		#300;
		//frq = 50000000;
		//#100;
		//frq = 100000000;
		//#100;
		$finish;
	
	end
      
endmodule

