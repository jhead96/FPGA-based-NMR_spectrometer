`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:03:50 06/14/2018
// Design Name:   sin_source
// Module Name:   C:/Users/btg635/Desktop/devel/xilinx_ISE/sin_source_uut.v
// Project Name:  NMR_Spec
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sin_source
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module dec_FIR_Experiment_uut;

	// Inputs
	reg clk;
//   reg aclk;
	reg [31:0] frq;
   
  // for sin_source
   reg frq_valid;
   reg [31:0] phase_target;
   

	// Outputs
	wire out_valid, m_axis_data_tvalid;
	wire [15:0] out, cos_out;
   wire [15:0] m_axis_data_tdata;
   wire s_axis_data_tready;
	
	// Instantiate the Unit Under Test (UUT)
   
//   DDS_Array instance_name (
//    .clk(clk), 
//    .frq(frq), 
//    .sin_com_out(out),
//    .cos_com_out(cos_out),
//    .val(out_valid)
//    );
   
   dec_FIR dec_FIR (
      .aclk(clk), // input aclk
      .s_axis_data_tvalid(out_valid), // input s_axis_data_tvalid
      .s_axis_data_tready(s_axis_data_tready), // output s_axis_data_tready
      .s_axis_data_tdata(out), // input [15 : 0] s_axis_data_tdata
      .m_axis_data_tvalid(m_axis_data_tvalid), // output m_axis_data_tvalid
      .m_axis_data_tdata(m_axis_data_tdata) // output [15 : 0] m_axis_data_tdata
   );

   sin_source uut (
      .clk(clk), 
      .frq_valid(frq_valid), 
      .phase_offset(phase_target), 
      .frq(frq), 
      .out_valid(out_valid), 
      .out(out)
   );
   
//	always begin
//		#2.5 aclk <= ~aclk;
//  end
   
   always begin
      #2.5 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
//      aclk = 1;
		frq = 32'd5000000;
      phase_target = 32'd0;

		// Wait 100 ns for global reset to finish
		#200;
        
		// Add stimulus here

	end
      
endmodule
