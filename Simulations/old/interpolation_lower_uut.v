
module interploation_lower_uut;

   reg clk,
   input [15:0] sin_in,
   input [15:0] cos_in,
   input input_val,
   output reg signed [15:0] sin_out,
   output reg signed [15:0] cos_out,
   output val
   );
   
   reg [31:0] s_axis_data_tdata;
   wire [31:0] m_axis_data_tdata;
   wire clk_8x;

   clk_super clk_super(
      .clk(clk),
      .clk_8x(clk_8x)
      );

   always @(sin_in or cos_in) begin
      s_axis_data_tdata = {sin_in, cos_in};
   end
   
   always @(m_axis_data_tdata) begin
      sin_out = m_axis_data_tdata[31:16];
      cos_out = m_axis_data_tdata[15:0];
   end

   interpolate_FIR interpolate_FIR (
      .aclk(clk_8x), // input aclk
      .s_axis_data_tvalid(input_val), // input s_axis_data_tvalid
      .s_axis_data_tdata(s_axis_data_tdata), // input [31 : 0] s_axis_data_tdata
      .m_axis_data_tvalid(val), // output m_axis_data_tvalid
      .m_axis_data_tdata(m_axis_data_tdata) // output [31 : 0] m_axis_data_tdata
      );
      
   always #2.5 clk = ~clk;
   
   initial begin
      clk = 0;
      
     
endmodule
