`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:49:07 07/06/2018
// Design Name:   operations
// Module Name:   C:/Users/btg635/Desktop/brendan-spectrometer/modules/simulations/operations_uut.v
// Project Name:  NMR-Spec
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

module operations_uut;

	// Inputs
	wire [63:0] signal_in;
   wire [15:0] signal_in_fast;
   wire [127:0] signal_in_full;
	reg clk;
   reg clk_625;
	reg enable_PC;
	reg [31:0] frq;
	reg [4:0] tx_phase_data;
	reg [31:0] pulse_gap_data;
	reg [31:0] record_len_data;
	reg [31:0] pulse_90_len;
	reg [31:0] pulse_180_len;

	// Outputs
	wire [111:0] signal_out;
	wire u_blank;
	wire signed [15:0] data_out_i;
	wire signed [15:0] data_out_q;

	// Instantiate the Unit Under Test (UUT)
	operations uut (
		.signal_in(signal_in), 
		.signal_out(signal_out), 
		.u_blank(u_blank), 
		.clk(clk), 
		.enable_PC(enable_PC), 
		.frq(frq), 
		.tx_phase_data(tx_phase_data), 
		.pulse_gap_data(pulse_gap_data), 
		.record_len_data(record_len_data), 
		.pulse_90_len(pulse_90_len), 
		.pulse_180_len(pulse_180_len), 
		.data_out_i(data_out_i), 
		.data_out_q(data_out_q)
	);

   // Input signal simulation
   reg clk_125;
   reg clk_super;
   initial clk_125 = 1;
   initial clk_super = 1;
   DDS_com_wrap DDS_com_wrap (
      .clk(clk_super),
      .frq_valid(1'b1),
      .frq(32'd1000),
      .sin_out(signal_in_fast)
      );

   vinput_buffer buffer_vInput (
      .clk(clk_125),
      .clk_8x(clk_super),
      .dds_i(signal_in_fast),
      .dds_q(signal_in_fast),
      .dds_com(signal_in_full)
      );
      
   assign signal_in = signal_in_full[63:0];

   always #2.5 clk = ~clk;
   always #1.25 clk_125 = ~clk_125;
   always begin
      if (clk_super) 
         #0.312 clk_super = ~clk_super;
      else
         #0.313 clk_super = ~clk_super;
   end
      
//   always @(data_out_i) begin
//      $display(data_out_i, ", ", data_out_q);
//   end
   
	initial begin
		// Initialize Inputs
		clk = 0;
      clk_625 = 0;
		enable_PC = 0;
		frq = 32'd1000000;
		tx_phase_data = 5'd9;
		pulse_gap_data = 32'd500;
		record_len_data = 32'd10000000;
		pulse_90_len = 32'd100;
		pulse_180_len = 32'd250;
      
      #100;
      enable_PC = 1;

      // Wait 100 ns for global reset to finish
		#5000;
      
        
		// Add stimulus here

	end
      
endmodule


// an old version of output_buffer for use with input simulation
module vinput_buffer(
   input clk,
   input clk_8x,
   input signed [15:0] dds_i, dds_q,
   input signed [13:0] signal_out_fast,
   output reg [127:0] dds_com,
   output reg [111:0]signal_out
   );

   reg [3:0] pos;
   reg [13:0] sig0a, sig1a, sig2a, sig3a, sig4a, sig5a, sig6a, sig7a;
   reg [13:0] sig0b, sig1b, sig2b, sig3b, sig4b, sig5b, sig6b, sig7b;
   reg [15:0] dds_i0a, dds_i1a, dds_i2a, dds_i3a;
   reg [15:0] dds_i0b, dds_i1b, dds_i2b, dds_i3b;
   reg [15:0] dds_q0a, dds_q1a, dds_q2a, dds_q3a;
   reg [15:0] dds_q0b, dds_q1b, dds_q2b, dds_q3b;

   
   initial begin
      pos <= 4'd0;
      sig0a = 14'd0; sig1a = 14'd0; sig2a = 14'd0; sig3a = 14'd0;
      sig4a = 14'd0; sig5a = 14'd0; sig6a = 14'd0; sig7a = 14'd0;
      sig0b = 14'd0; sig1b = 14'd0; sig2b = 14'd0; sig3b = 14'd0;
      sig4b = 14'd0; sig5b = 14'd0; sig6b = 14'd0; sig7b = 14'd0;
      dds_i0a = 16'd0; dds_i1a = 16'd0; dds_i2a = 16'd0; dds_i3a = 16'd0;
      dds_i0b = 16'd0; dds_i1b = 16'd0; dds_i2b = 16'd0; dds_i3b = 16'd0;
      dds_q0a = 16'd0; dds_q1a = 16'd0; dds_q2a = 16'd0; dds_q3a = 16'd0;
      dds_q0b = 16'd0; dds_q1b = 16'd0; dds_q2b = 16'd0; dds_q3b = 16'd0;

   end

   always @(negedge clk_8x) begin
      if (|signal_out_fast | |dds_i | |dds_q) begin
         if (pos == 4'd15) 
            pos <= 4'd0;
         else
            pos <= pos + 1'd1;
      end
      else
         pos <= 0;
   end
   
   always @(posedge clk_8x) begin
      if (pos == 4'd0) begin
         sig0a = signal_out_fast;
         dds_i0a = dds_i;
         dds_q0a = dds_q;
      end
      else if (pos == 4'd1) begin
         sig1a = signal_out_fast;
      end
      else if (pos == 4'd2) begin
         sig2a = signal_out_fast;
         dds_i1a = dds_i;
         dds_q1a = dds_q;
      end
      else if (pos == 4'd3) begin
         sig3a = signal_out_fast;
      end
      else if (pos == 4'd4) begin
         sig4a = signal_out_fast;
         dds_i2a = dds_i;
         dds_q2a = dds_q;
      end
      else if (pos == 4'd5) begin
         sig5a = signal_out_fast;
      end
      else if (pos == 4'd6) begin
         sig6a = signal_out_fast;
         dds_i3a = dds_i;
         dds_q3a = dds_q;
      end
      else if (pos == 4'd7) begin
         sig7a = signal_out_fast;
      end
      else if (pos == 4'd8) begin
         sig0b = signal_out_fast;
         dds_i0b = dds_i;
         dds_q0b = dds_q;
      end
      else if (pos == 4'd9) begin
         sig1b = signal_out_fast;
      end
      else if (pos == 4'd10) begin
         sig2b = signal_out_fast;
         dds_i1b = dds_i;
         dds_q1b = dds_q;
      end
      else if (pos == 4'd11) begin
         sig3b = signal_out_fast;
      end
      else if (pos == 4'd12) begin
         sig4b = signal_out_fast;
         dds_i2b = dds_i;
         dds_q2b = dds_q;
      end
      else if (pos == 4'd13) begin
         sig5b = signal_out_fast;
      end
      else if (pos == 4'd14) begin
         sig6b = signal_out_fast;
         dds_i3b = dds_i;
         dds_q3b = dds_q;
      end
      else if (pos == 4'd15) begin
         sig7b = signal_out_fast;
      end
   end
   
   always @(posedge clk) begin
      if (pos[3]) begin
         signal_out <= {sig0a, sig1a, sig2a, sig3a, sig4a, sig5a, sig6a, sig7a};
         dds_com <= {dds_i0a, dds_i1a, dds_i2a, dds_i3a, dds_q0a, dds_q1a, dds_q2a, dds_q3a};
      end
      else begin
         signal_out <= {sig0b, sig1b, sig2b, sig3b, sig4b, sig5b, sig6b, sig7b};
         dds_com <= {dds_i0b, dds_i1b, dds_i2b, dds_i3b, dds_q0b, dds_q1b, dds_q2b, dds_q3b};
      end
   end
      
endmodule
