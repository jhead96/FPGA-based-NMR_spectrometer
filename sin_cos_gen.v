`timescale 1ns/100ps
/*
TO DO
	- Refactor variable list.
	- Implement Generate block + loop.
*/

module sin_cos_gen(
input clk,
input [31:0] frq_out,
output [127:0] dds_i,
output [127:0] dds_q,
output dds_valid
);

wire [31:0] phase_inc;
wire [31:0] scaled_phase_inc;

reg [31:0] phase_off_temp = 32'b0;
reg [31:0] phase_off, phase_off_2, phase_off_3, phase_off_4, phase_off_5, phase_off_6;
wire signal_valid, signal_valid_2, signal_valid_3, signal_valid_4, signal_valid_5, signal_valid_6, signal_valid_7, signal_valid_8;
wire [31:0] DDS_out, DDS_out_2, DDS_out_3, DDS_out_4, DDS_out_5, DDS_out_6, DDS_out_7, DDS_out_8;
wire [63:0] phase_inc_out, phase_inc_out_2, phase_inc_out_3, phase_inc_out_4, phase_inc_out_5, phase_inc_out_6, phase_inc_out_7, phase_inc_out_8;

reg [31:0] frq_reg = 32'b0;
reg [31:0] scaled_frq = 32'b0;

wire [31:0] scaled_frq_in;
wire [31:0] original_frq_in;

wire [31:0] frq_to_div3;
wire [46:0] frq_from_div3;

wire [31:0] phase_off_to_mult3;
wire [31:0] phase_off_from_mult3;

wire [31:0] scaled_phase_inc_reg_p;


reg [63:0] phase_inc_reg = 64'b0;
reg [63:0] phase_inc_reg_2 = 64'b0;
reg [63:0] phase_inc_reg_3 = 64'b0;
reg [63:0] phase_inc_reg_4 = 64'b0;
reg [63:0] phase_inc_reg_5 = 64'b0;
reg [63:0] phase_inc_reg_6 = 64'b0;
reg [63:0] phase_inc_reg_7 = 64'b0;
reg [63:0] phase_inc_reg_8 = 64'b0;

reg [31:0] scaled_phase_inc_reg;

reg signal_valid_reg, signal_valid_reg_2, signal_valid_reg_3, signal_valid_reg_4, signal_valid_reg_5, signal_valid_reg_6, signal_valid_reg_7, signal_valid_reg_8;
reg [31:0] DDS_out_reg, DDS_out_reg_2, DDS_out_reg_3, DDS_out_reg_4, DDS_out_reg_5, DDS_out_reg_6, DDS_out_reg_7, DDS_out_reg_8;
reg [15:0] sin_out_reg, sin_out_reg_2, sin_out_reg_3, sin_out_reg_4, sin_out_reg_5, sin_out_reg_6, sin_out_reg_7, sin_out_reg_8;
reg [15:0] cos_out_reg, cos_out_reg_2,cos_out_reg_3, cos_out_reg_4, cos_out_reg_5, cos_out_reg_6,cos_out_reg_7, cos_out_reg_8;
reg [127:0] signal_out_sin_reg;
reg [127:0] signal_out_cos_reg;

	// Multiplier for phase increment
	multiplier phase_increment (
	.clk(clk), // input clk
	.a(original_frq_in), // input [31 : 0] Frequency
	.p(phase_inc) // output [55 : 0] Phase increment
	);

	// Multiplier for scaled phase increment
	multiplier scaled_phase_increment (
	.clk(clk), // input clk
	.a(scaled_frq_in), // input [31 : 0] Frequency
	.p(scaled_phase_inc) // output [55 : 0] Phase increment
	);
	
	
	// Multiplier for dividing frq_reg by 3
	divide3_multiplier div3_frq_reg (
	.clk(clk), // input clk
	.a(frq_to_div3), // input [31 : 0] Frequency
	.p(frq_from_div3) // output [46 : 0] Frequency / 3
	);
	
	// Multiplier for multiplying phase offset by 3
	times3_multiplier times3_phase_offset (
	.clk(clk), // input clk
	.a(phase_off_to_mult3), // input [31 : 0] Phase offset 
	.p(phase_off_from_mult3) // output [31 : 0] Phase offset * 3
	);
	
	always @(posedge clk) begin
		// Store frequency in reg
		frq_reg <= frq_out;
		
		// Store phase inc in reg
		phase_inc_reg[31:0] <= phase_inc;
		
		
		// Calculate phase offset depending on what frequency is being generated
		// (200 < f <= 400) MHz 
		if (frq_reg <= 32'd400000000 && frq_reg > 32'd200000000) begin
			scaled_frq <= frq_reg >> 1;
			scaled_phase_inc_reg <=  scaled_phase_inc;
			phase_off <= scaled_phase_inc >> 2;	
		end
		// (400 < f <= 600) MHz 
		else if (frq_reg <= 32'd600000000 && frq_reg > 32'd400000000) begin
			scaled_frq <= frq_from_div3 >> 16;
			scaled_phase_inc_reg <=  scaled_phase_inc;
			phase_off_temp <= scaled_phase_inc >> 3;
			phase_off <= phase_off_from_mult3;
		end
		// (600 < f <= 800) MHz 
		else if (frq_reg <= 32'd800000000 && frq_reg > 32'd600000000) begin
			scaled_frq <= frq_reg >> 2;
			scaled_phase_inc_reg <=  scaled_phase_inc;
			phase_off <= scaled_phase_inc >> 1;
	
		end
		// (f < 200) MHz 
		else begin
			phase_off <= phase_inc_reg >> 3;
		end
			
	
		phase_off_2 <= phase_off;
		phase_off_3 <= phase_off;
		phase_off_4 <= phase_off;
		phase_off_5 <= phase_off;
		phase_off_6 <= phase_off;
		
		phase_inc_reg_2[31:0] <= phase_inc;
		phase_inc_reg_2[63:32] <= phase_off;

		phase_inc_reg_3[31:0] <= phase_inc;
		phase_inc_reg_3[63:32] <= phase_off << 1; 
		
		phase_inc_reg_4[31:0] <= phase_inc;
		phase_inc_reg_4[63:32] <= 3*phase_off_2; 
		
		phase_inc_reg_5[31:0] <= phase_inc;
		phase_inc_reg_5[63:32] <= phase_off_3 << 2; 
		
		phase_inc_reg_6[31:0] <= phase_inc;
		phase_inc_reg_6[63:32] <= 5*phase_off_4;
		
		phase_inc_reg_7[31:0] <= phase_inc;
		phase_inc_reg_7[63:32] <= 6*phase_off_5; 
		
		phase_inc_reg_8[31:0] <= phase_inc;
		phase_inc_reg_8[63:32] <= 7*phase_off_6;
		
		
		signal_valid_reg <= signal_valid;
		signal_valid_reg_2 <= signal_valid_2;
		signal_valid_reg_3 <= signal_valid_3;
		signal_valid_reg_4 <= signal_valid_4;
		signal_valid_reg_5 <= signal_valid_5;
		signal_valid_reg_6 <= signal_valid_6;
		signal_valid_reg_7 <= signal_valid_7;
		signal_valid_reg_8 <= signal_valid_8;
		
		DDS_out_reg <= DDS_out;
		sin_out_reg <= DDS_out_reg[31:16];
		cos_out_reg <= DDS_out_reg[15:0];
		
		DDS_out_reg_2 <= DDS_out_2;
		sin_out_reg_2 <= DDS_out_reg_2[31:16];
		cos_out_reg_2 <= DDS_out_reg_2[15:0];
		
		DDS_out_reg_3 <= DDS_out_3;
		sin_out_reg_3 <= DDS_out_reg_3[31:16];
		cos_out_reg_3 <= DDS_out_reg_3[15:0];
		
		DDS_out_reg_4 <= DDS_out_4;
		sin_out_reg_4 <= DDS_out_reg_4[31:16];
		cos_out_reg_4 <= DDS_out_reg_4[15:0];
		
		DDS_out_reg_5 <= DDS_out_5;
		sin_out_reg_5 <= DDS_out_reg_5[31:16];
		cos_out_reg_5 <= DDS_out_reg_5[15:0];
		
		DDS_out_reg_6 <= DDS_out_6;
		sin_out_reg_6 <= DDS_out_reg_6[31:16];
		cos_out_reg_6 <= DDS_out_reg_6[15:0];
		
		DDS_out_reg_7 <= DDS_out_7;
		sin_out_reg_7 <= DDS_out_reg_7[31:16];
		cos_out_reg_7 <= DDS_out_reg_7[15:0];
		
		DDS_out_reg_8 <= DDS_out_8;
		sin_out_reg_8 <= DDS_out_reg_8[31:16];
		cos_out_reg_8 <= DDS_out_reg_8[15:0];
		
		signal_out_sin_reg <= {sin_out_reg_8, sin_out_reg_7, sin_out_reg_6, sin_out_reg_5, sin_out_reg_4, sin_out_reg_3, sin_out_reg_2, sin_out_reg};
		signal_out_cos_reg <= {cos_out_reg_8, cos_out_reg_7, cos_out_reg_6, cos_out_reg_5, cos_out_reg_4, cos_out_reg_3, cos_out_reg_2, cos_out_reg};
			
	end
	
	// Send effective frequency to phase increment multiplier
	assign original_frq_in = frq_reg;
	assign scaled_frq_in = scaled_frq;
	
	// Send frequency to divide 3 multiplier
	assign frq_to_div3 = frq_reg;

	
	assign phase_off_to_mult3 = phase_off_temp;
	
	assign phase_inc_out = phase_inc_reg;
	assign phase_inc_out_2 = phase_inc_reg_2;
	assign phase_inc_out_3 = phase_inc_reg_3;
	assign phase_inc_out_4 = phase_inc_reg_4;
	assign phase_inc_out_5 = phase_inc_reg_5;
	assign phase_inc_out_6 = phase_inc_reg_6;
	assign phase_inc_out_7 = phase_inc_reg_7;
	assign phase_inc_out_8 = phase_inc_reg_8;
	
	/*
	assign DDS_out_reg_p = DDS_out_reg;
	assign DDS_out_reg_2_p = DDS_out_reg_2;
	
	assign cos_out_reg_p = cos_out_reg;
	assign cos_out_reg_2_p = cos_out_reg_2;
	*/
	
	assign sin_out_reg_p = sin_out_reg;
	assign sin_out_reg_2_p = sin_out_reg_2;
	assign sin_out_reg_3_p = sin_out_reg_3;
	assign sin_out_reg_4_p = sin_out_reg_4;
	assign sin_out_reg_5_p = sin_out_reg_5;
	assign sin_out_reg_6_p = sin_out_reg_6;
	assign sin_out_reg_7_p = sin_out_reg_7;
	assign sin_out_reg_8_p = sin_out_reg_8;
	
	assign phase_off_p = phase_off;
	
	
	dds_compiler_v4_0 DDS_1 (
	.clk(clk), // input clk
	.pinc_in(phase_inc_out[31:0]), // input [31 : 0] pinc_in
	.poff_in(phase_inc_out[63:32]), // input [31 : 0] poff_in
	.rdy(signal_valid), // output rdy
	.cosine(DDS_out[15:0]), // output [15 : 0] cosine
	.sine(DDS_out[31:16]) // output [15 : 0] sine
	);
	
	dds_compiler_v4_0 DDS_2 (
	.clk(clk), // input clk
	.pinc_in(phase_inc_out_2[31:0]), // input [31 : 0] pinc_in
	.poff_in(phase_inc_out_2[63:32]), // input [31 : 0] poff_in
	.rdy(signal_valid_2), // output rdy
	.cosine(DDS_out_2[15:0]), // output [15 : 0] cosine
	.sine(DDS_out_2[31:16]) // output [15 : 0] sine
	);
	
	dds_compiler_v4_0 DDS_3 (
	.clk(clk), // input clk
	.pinc_in(phase_inc_out_3[31:0]), // input [31 : 0] pinc_in
	.poff_in(phase_inc_out_3[63:32]), // input [31 : 0] poff_in
	.rdy(signal_valid_3), // output rdy
	.cosine(DDS_out_3[15:0]), // output [15 : 0] cosine
	.sine(DDS_out_3[31:16]) // output [15 : 0] sine
	);
	
	dds_compiler_v4_0 DDS_4 (
	.clk(clk), // input clk
	.pinc_in(phase_inc_out_4[31:0]), // input [31 : 0] pinc_in
	.poff_in(phase_inc_out_4[63:32]), // input [31 : 0] poff_in
	.rdy(signal_valid_4), // output rdy
	.cosine(DDS_out_4[15:0]), // output [15 : 0] cosine
	.sine(DDS_out_4[31:16]) // output [15 : 0] sine
	);
	
	dds_compiler_v4_0 DDS_5 (
	.clk(clk), // input clk
	.pinc_in(phase_inc_out_5[31:0]), // input [31 : 0] pinc_in
	.poff_in(phase_inc_out_5[63:32]), // input [31 : 0] poff_in
	.rdy(signal_valid_5), // output rdy
	.cosine(DDS_out_5[15:0]), // output [15 : 0] cosine
	.sine(DDS_out_5[31:16]) // output [15 : 0] sine
	);
	
	dds_compiler_v4_0 DDS_6 (
	.clk(clk), // input clk
	.pinc_in(phase_inc_out_6[31:0]), // input [31 : 0] pinc_in
	.poff_in(phase_inc_out_6[63:32]), // input [31 : 0] poff_in
	.rdy(signal_valid_6), // output rdy
	.cosine(DDS_out_6[15:0]), // output [15 : 0] cosine
	.sine(DDS_out_6[31:16]) // output [15 : 0] sine
	);
	
	dds_compiler_v4_0 DDS_7 (
	.clk(clk), // input clk
	.pinc_in(phase_inc_out_7[31:0]), // input [31 : 0] pinc_in
	.poff_in(phase_inc_out_7[63:32]), // input [31 : 0] poff_in
	.rdy(signal_valid_7), // output rdy
	.cosine(DDS_out_7[15:0]), // output [15 : 0] cosine
	.sine(DDS_out_7[31:16]) // output [15 : 0] sine
	);
	
	dds_compiler_v4_0 DDS_8 (
	.clk(clk), // input clk
	.pinc_in(phase_inc_out_8[31:0]), // input [31 : 0] pinc_in
	.poff_in(phase_inc_out_8[63:32]), // input [31 : 0] poff_in
	.rdy(signal_valid_8), // output rdy
	.cosine(DDS_out_8[15:0]), // output [15 : 0] cosine
	.sine(DDS_out_8[31:16]) // output [15 : 0] sine
	);
	
	assign dds_valid = signal_valid_reg;
	assign out_valid_2 = signal_valid_reg_2;
	assign out_valid_3 = signal_valid_reg_3;
	assign out_valid_4 = signal_valid_reg_4;
	assign out_valid_5 = signal_valid_reg_5;
	assign out_valid_6 = signal_valid_reg_6;
	assign out_valid_7 = signal_valid_reg_7;
	assign out_valid_8 = signal_valid_reg_8;
	
	
	assign dds_i = signal_out_sin_reg;
	assign dds_q = signal_out_cos_reg;
	
	
endmodule
