`timescale 1ns / 100ps
module three_pulse_tb();
  
  reg clk;
  reg [191:0] pulse_data;
  reg enable;
  wire amp_enable;
  wire ADC_enable;
  wire [1:0] TX_active_phase;
  
  
  initial begin
    
    clk = 0;
    enable = 0;
    pulse_data = 0;  
    #102.5;
	 
	 // 20-10-40-10-40 REC = 20
	 pulse_data[191:160] = 32'd20;
    pulse_data[159:128] = 32'd40;
    pulse_data[127:96] = 32'd0;
	 pulse_data[95:64] = 32'd10;
    pulse_data[63:32] = 32'd0;
	 pulse_data[31:0] = 32'd20;
	 #10;
    enable = 1;
    #150;
	 enable = 0;
	 #100;
	 enable = 1;
	 #200;
	 enable = 0;
	 #10;
    $finish;
    
  end
  
 always #2.5 clk = ~clk;
  
  
  three_pulse uut (
    .clk(clk),
	 .pulse_timing_data(pulse_data),
    .RF_signal_valid(enable),
	 .TX_active_phase(TX_active_phase),
    .amp_enable(amp_enable),
	 .ADC_enable(ADC_enable)
  );
  
endmodule