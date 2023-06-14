// Verilog Test Fixture Template

  `timescale 1 ns / 1 ps

module TEST_gate;

   reg clk_1_4;
   reg [1:0] trig_count;
   reg out;
   reg pc_enable;
   
   initial clk_1_4 = 0;
   always #2.5 clk_1_4 = ~clk_1_4;
   
   initial out = 0;
   initial trig_count = 0;
   
   always @(posedge clk_1_4) begin
      if (trig_count != 3) begin
         trig_count <= trig_count + 1;
         out <= 0;
      end
      else begin
         trig_count <= 0;
         out <= 1&~pc_enable;
      end
   end
   
   initial begin
      pc_enable = 1;
      #50 pc_enable = 0;
      #50 pc_enable = 1;
   end
   
endmodule
