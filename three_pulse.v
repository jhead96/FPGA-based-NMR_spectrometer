`timescale 1ns / 100ps


module three_pulse(
  	input clk,
	input [191:0] pulse_timing_data,
  	input RF_signal_valid,
	output reg [1:0] TX_active_phase,
  	output reg amp_enable,
	output reg ADC_enable
    );

    reg timer_reset; 
    wire [63:0] time_elaps;
	 wire [31:0] P1_end, P2_start, P2_end, P3_start, P3_end, rec_end;

	
  // Initialize timer, amplifier gate
  	initial begin
      timer_reset = 1;
		TX_active_phase = 0;
      amp_enable = 0;
		ADC_enable = 0;
    end
    
    // Generate timer
    ns_timer timer(
        .clk(clk),
        .reset(timer_reset),
        .time_elaps(time_elaps)
        );
  
  
  // pulse_timing_data bit layout:
  // P1 = 191:160
  // P2 = 159:128
  // P3 = 127:96
  // G1 = 95:32
  // G2 = 63:32
  // Rec = 31:0
  
  // P1_start = 0
  // P1_end = P1
  assign P1_end = pulse_timing_data[191:160];
  // P2_start = P1 + G1
  assign P2_start = pulse_timing_data[191:160] + pulse_timing_data[95:64];
  // P2_end = P1 + G1 + P2
  assign P2_end = pulse_timing_data[191:160] + pulse_timing_data[95:64] + pulse_timing_data[159:128];
  // P3_start = P1 + G1 + P2 + G2
  assign P3_start = pulse_timing_data[191:160] + pulse_timing_data[95:64] +
						  pulse_timing_data[159:128] + pulse_timing_data[63:32];
  // P3_end = P1 + G1 + P2 + G2 + P3
  assign P3_end = pulse_timing_data[191:160] + pulse_timing_data[95:64] +
						pulse_timing_data[159:128] + pulse_timing_data[63:32] +
						pulse_timing_data[127:96];
						
  // rec_start = P3_end
  // rec_end = P1 + G1 + P2 + G2 + P3 + rec_len
  assign rec_end = pulse_timing_data[191:160] + pulse_timing_data[95:64] +
						 pulse_timing_data[159:128] + pulse_timing_data[63:32] +
						 pulse_timing_data[127:96] + pulse_timing_data[31:0];
  
  
  
  always @* begin 
    
    if (RF_signal_valid) begin
	  
	 
		// AMPLIFIER ENABLE
		// If in pulse 1
		if (time_elaps < P1_end) begin
			timer_reset = 0;
         amp_enable = 1;
		   ADC_enable = 0;
			TX_active_phase = 2'd0;
			
		// If in pulse 2
		end else if ((time_elaps >= P2_start) && (time_elaps < P2_end)) begin
			timer_reset = 0;
         amp_enable = 1;
		   ADC_enable = 0;
			TX_active_phase = 2'd1;
			
		// If in pulse 3
		end else if ((time_elaps >= P3_start) && (time_elaps < P3_end)) begin
			timer_reset = 0;
         amp_enable = 1;
		   ADC_enable = 0;
			TX_active_phase = 2'd2;
			
		// ADC ENABLE
		// If in record period
		end else if ((time_elaps >= P3_end) && (time_elaps < rec_end)) begin
			ADC_enable = 1;
			amp_enable = 0;
			timer_reset = 0;
	
		// Else not in pulse or record period
		end else begin
			amp_enable = 0;
         ADC_enable = 0;
		   timer_reset = 0;
      end	
    end
	 
  	 else begin
	  
	   TX_active_phase = 2'b0;
		ADC_enable = 0;
		amp_enable = 0;
		timer_reset = 1;
    end
    
  end 
        
endmodule




module ns_timer(
    input clk,
    input reset,
    output reg [63:0] time_elaps //64 bit register for ns counter -> max time = 584.6 years 
    );
    
    `define INCREMENT 5
	 
	 reg delay = 0;
    
    // increment time_elaps by 5 on each clk rising edge, unless reset is high.
    always @(posedge clk) begin 
        if (reset) begin
				delay <= 1;
        end 
        else begin
			
			if (delay == 1) begin
				time_elaps <= 0;
				delay <= 0;
			end
			else time_elaps <= time_elaps + `INCREMENT;

		  end
		  
    end
endmodule
