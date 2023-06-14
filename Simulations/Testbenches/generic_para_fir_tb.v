`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:06:11 11/14/2012
// Design Name:   generic_para_fir
// Module Name:   P:/ADQ/Libs/source/generic_parallel_FIR/examples/generic_para_fir_tb.v
// Project Name:  generic_para_fir_tb
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: generic_para_fir
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module generic_para_fir_tb;

   parameter bits = 14;
   parameter CoeffFracBits = 17;
   parameter taps = 19;
   parameter parallelization = 4;
   
	// 51 taps 25MHz 
   //reg [taps*18 - 1:0] coeff_i = {18'd647, 18'd999, 18'd1950, 18'd3541, 18'd5676, 18'd8128, 18'd10577, 18'd12666, 18'd14070, 18'd14565, 18'd14070, 18'd12666, 18'd10577, 18'd8128, 18'd5676, 18'd3541, 18'd1950, 18'd999, 18'd647};
	// 19 taps 25MHz
	//reg [taps*18 - 1:0] coeff_i = {-18'd25, -18'd49, -18'd80, -18'd116, -18'd152, -18'd181, -18'd193, -18'd177, -18'd117, 18'd0, 18'd189, 18'd463, 18'd831, 18'd1298, 18'd1862, 18'd2516, 18'd3245, 18'd4027, 18'd4834, 18'd5634, 18'd6392, 18'd7072, 18'd7641, 18'd8071, 18'd8338, 18'd8428, 18'd8338, 18'd8071, 18'd7641, 18'd7072, 18'd6392, 18'd5634, 18'd4834, 18'd4027, 18'd3245, 18'd2516, 18'd1862, 18'd1298, 18'd831, 18'd463, 18'd189, 18'd0, -18'd117, -18'd177, -18'd193, -18'd181, -18'd152, -18'd116, -18'd80, -18'd49, -18'd25};
	// 19 taps 200MHz
	reg [taps*18 - 1:0] coeff_i = {18'd69, -18'd0, -18'd823, 18'd0, 18'd3348, -18'd0, -18'd10182, 18'd0, 18'd40345, 18'd65558, 18'd40345, 18'd0, -18'd10182, -18'd0, 18'd3348, 18'd0, -18'd823, -18'd0, 18'd69};

	// Inputs
	reg clk_i = 0;
	reg [bits*parallelization - 1:0] x_i = 112'd0;	
	reg valid_i;

	// Outputs
	wire [bits*parallelization - 1:0] y_o;
	wire valid_o;

	// Instantiate the Unit Under Test (UUT)
	generic_para_fir  #(parallelization, taps, bits, CoeffFracBits) uut (
		.clk_i(clk_i), 
		.x_i(x_i), 
		.y_out(y_o), 
		.coeff_i(coeff_i), 
		.valid_i(valid_i), 
		.valid_o(valid_o)
	);
   
   always
      #2.5 clk_i = ~clk_i;

   reg [bits*parallelization - 1:0] impulse = { {(parallelization*bits - bits){1'b0}} , {(bits-1){1'b0}} , 1'b1};
   
   reg [bits-1:0] x_deparallelized[parallelization-1:0];
   reg [bits-1:0] y_deparallelized[parallelization-1:0];
	
	reg [bits-1:0] signal_data [1000:0];
	
	integer j;
	integer f;
	
   
   always @* begin:deparallelize
      integer i;
      for(i = 0; i < parallelization; i = i + 1) begin
         x_deparallelized[i] = x_i[i*bits +: bits];
         y_deparallelized[i] = y_o[i*bits +: bits];
      end
   end

	initial begin:mainblock
   
	$readmemb("C:\\UoBFNS\\modules_FIR_filter_25MHz\\Simulations\\sim_data\\FIR_filter\\test_signals\\FIR_filter_test_signal_180MHz_50MHz.txt", signal_data);
      
		
		
      
		// Initialize Inputs
		clk_i = 1;
		x_i = 0;
		valid_i = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		// Set valid
      valid_i = 1;
		#100;
		f = $fopen("C:\\UoBFNS\\modules_FIR_filter_25MHz\\Simulations\\sim_data\\FIR_filter\\outputs\\output_180MHz_50MHz.txt");
		
		$monitor("%b", y_o);
		$fmonitor(f, "%b", y_o);
		
		
		
		// Input signal
		for (j=0; j < 250; j=j+1) begin
			x_i = {signal_data[4*j+3], signal_data[4*j+2], signal_data[4*j+1], signal_data[4*j]};		
			#5;

		end
		
		
		#600;
		
		$fclose(f);
		$finish;
		
		
		
      /*
		integer i = 0;
      for(i = 0; i < parallelization; i = i + 1) begin
         @(posedge clk_i);
         x_i = impulse;
         
         @(posedge clk_i);
         x_i = 112'd0;
         
         #(taps*10); // Wait for response to ring out
         
         // Shift impulse to next parallel sample
         impulse = { impulse[parallelization*bits - bits - 1: 0], {bits{1'b0}}};
      end
	*/
	
	
	
	
	
	end
      
		
endmodule

