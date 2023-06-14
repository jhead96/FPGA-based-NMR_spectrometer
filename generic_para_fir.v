
//////////////////////////////////////////////////////////////////////////////////
// Company: 		 SP Devices
// Engineer: 		 Daniel Björklund (daniel.bjorklund@spdevices.com)
// 
// Create Date:    10:48:46 02/09/2012
// Design Name: 	 
// Module Name:    generic_para_fir 
//
// Description:    
// 
//	This module is used for instantiating a generic parallelized FIR filter with
// a specified number of taps. This implementation does not utilize any symmetric
// properties in the coefficients, for symmetric filters, use generic_para_symm_fir
// instead.
//
// Inputs and outputs are taken as bit vectors of (#samples * #bits) in length, where
// chronological order is that the most significant sample comes after the least
// significant sample. 
//
// The instantiation takes three parameters: samp, taps, bits, CoeffFracBits
//
// samp           - The number of parallel samples that the filter
// 	              should use at input and output.
// taps           - The amount of taps in the FIR filter 
// bits           - Number of bits per data sample
// CoeffFracBits  - Number of fractional bits in the 18-bit coefficients (0-18)
//
//////////////////////////////////////////////////////////////////////////////////

 module generic_para_fir #(parameter samp = 8, taps = 9, bits = 14, CoeffFracBits = 17)
	(
    input clk_i,
	 input [bits*samp-1:0] x_i,
	 output [bits*samp-1:0] y_out,
	 input [18*taps-1:0] coeff_i,
	 input valid_i,
	 output valid_o
    );

   // Number of samples added per clock cycle in the pipelined adder tree
   `define ADDSPERSTAGE 2   

	`include "generic_para_fir_functions.v"

	 localparam odd = (taps % 2); // 1 if filter has an odd number of taps, 0 otherwise

    // Total number of x-values that are used in each
    // iteration (first output sample uses values 0 to (taps-1),
    // the last sample uses values (samp-1) to (taps-1+samp-1)
    // , for a total index range of 0 to (taps-1+samp-1) required
	 localparam x_tot = taps + samp - 1;

    // Number of pipeline stages necessary in order
    // to hold all of the previous x-values that are used to
    // calculate the last output sample:
	 localparam stages = ((taps - 1 + samp - 1) / samp);
    
    // The number of coefficient multipliers in the filter.
	 localparam coeffmults = taps;		


	 reg [bits*samp-1:0] x_pipe[stages-1:0];              // The x-value delay line, with length according to the number of filter taps

	 reg [bits-1:0] x_indiv[(x_tot-1):0];                 // Array of unpacked x-values, assigned from the input vector	 

	 reg [bits-1:0] y_indiv[samp-1:0];                    // Array of unpacked y-values, assigned to the output vector

	 reg [bits*samp-1:0] y_o;
	
	
	 integer i;

	 localparam VALID_DELAY = generic_para_fir_delay(taps); // Filter latency, used to forward the incoming valid flag to correct latency level
	 reg valid_del[VALID_DELAY-1:0];

	 always @(posedge clk_i) begin:validdelayloop
      integer i;
		for(i = VALID_DELAY-1; i > 0; i = i - 1) begin
			valid_del[i] <= valid_del[i-1];
		end
		valid_del[0] <= valid_i;
	 end

	 initial begin:validdelayreset
      integer i;
		for(i = 0; i < VALID_DELAY; i = i + 1) begin
			valid_del[i] = 0;
		end
	 end

	 assign valid_o = valid_del[VALID_DELAY-1];

	 always @* begin:outputassignloop
      integer i;
		for(i = 0; i < samp; i = i + 1) begin
			y_o[bits*(samp-i)-1 -: bits] = y_indiv[i];
		end
	 end
	 
	 assign y_out = y_o;

	always @* begin:xindiv_loop
      integer i;
		// First #samp number of samples come from input
		for ( i = 0; i < samp; i = i + 1)  begin
			x_indiv[i] = x_i[bits*(samp-i)-1 -: bits];
		end
		
		// and the rest are assigned from the delay line
		for ( i = 0; i < (x_tot - samp); i = i + 1) begin
			x_indiv[i + samp] = x_pipe[i / samp][bits*(samp - i % samp) - 1 -: bits];
		end	
	end
	
	reg [17:0] coeff[taps-1:0];
	 
	wire [bits-1:0] m_out[samp-1:0][taps-1:0];
	
	always @* begin:coeff_assign
      integer ci;
		for ( ci = 0; ci < coeffmults; ci = ci + 1) begin
			coeff[ci] = coeff_i[18*(coeffmults - ci) - 1 -: 18];
		end
	end
	
	
	always @(posedge clk_i) begin:data_pipelineshift
      integer pipeind;
		if(valid_i) begin
			for (pipeind = stages-1; pipeind > 0; pipeind = pipeind - 1) begin
				x_pipe[pipeind] <= x_pipe[pipeind-1];
			end
			x_pipe[0] <= x_i;
		end
	end
	
	initial begin:pipelineinit
      integer pipeind;
		for(pipeind = 0; pipeind < stages; pipeind = pipeind + 1) begin
			x_pipe[pipeind] = 0;
		end
	end
		
	
	// We need taps multipliers per output sample.
	genvar mult_i;
	genvar samplenum;
	
	generate
		for ( samplenum = 0; samplenum < samp; samplenum = samplenum + 1) begin:outsamp
			for ( mult_i = 0; mult_i < coeffmults; mult_i = mult_i + 1) begin:coeffsum
				fir_mult #(bits, CoeffFracBits) f(
								x_indiv[samplenum + mult_i], 
								{bits{1'b0}}, 
								coeff[mult_i], 
								m_out[samplenum][mult_i], 
								clk_i
							);				
			end
		end
	endgenerate
	
	reg [bits-1:0] sumnode[samp-1:0][calcregs(coeffmults)-1:0];

   always @* begin:yindiv_assignloop
      integer i;
      for(i = 0; i < samp; i = i + 1) begin
         y_indiv[i] = sumnode[i][startof(calcstages(coeffmults))-1];
      end
	end	  

	always @(posedge clk_i) begin:addertreeprocess
      integer addernum,inputsamp,pipe_index,samp_ind;
      
		for(samp_ind = 0; samp_ind < samp; samp_ind = samp_ind + 1) begin
			// For each output sample
			
			for(pipe_index = 0; pipe_index < calcstages(coeffmults); pipe_index = pipe_index + 1) begin
				// For each pipeline stage in the adder tree
            
				for(addernum = 0; addernum < (startof(pipe_index+1)-startof(pipe_index)); addernum = addernum + 1) begin:summingloop
					// For every adder in the pipeline stage
               integer sum;
               
					sum = 0;
               
					if(pipe_index == 0) 
               begin
                  // First stage, sum together `ADDSPERSTAGE samples at a time from the multiplier outputs
                  
                  // The lowestind() function is used to not sum past the last sample in previous stage ( in case of odd number of inputs)
                  for(inputsamp = `ADDSPERSTAGE*addernum; inputsamp < lowestind(`ADDSPERSTAGE*(addernum+1), coeffmults); inputsamp = inputsamp + 1) begin
                     sum = sum + m_out[samp_ind][inputsamp];
                  end
               end
					else 
               begin
                  // General adder tree pipeline stage, sum together `ADDSPERSTAGE samples at a time from the previous stage
						for(inputsamp = `ADDSPERSTAGE*addernum; 
                      inputsamp < lowestind(`ADDSPERSTAGE*(addernum+1), startof(pipe_index)-startof(pipe_index-1)); 
                      inputsamp = inputsamp + 1) 
                  begin
                     sum = sum + sumnode[samp_ind][startof(pipe_index-1) + inputsamp];
						end
					end
                  
					sumnode[samp_ind][startof(pipe_index) + addernum] <= sum;
				end
			end
		end
	end
	
	// Ex: 5 mult inputs gives 3 summing register output
	function integer calcregs;
		input integer multouts;
		begin
			for (calcregs=0; multouts > 1; calcregs = calcregs + multouts) begin
				multouts = (multouts + (`ADDSPERSTAGE-1))/`ADDSPERSTAGE;
			end
		end
	endfunction
	
	
	function integer startof;
		input integer fromstart;
		integer temp, multouts;
		begin
			startof = 0;
			multouts = coeffmults;
         
         for (temp = 0; temp < fromstart ; temp = temp + 1) begin
            multouts = (multouts+1)/2;
            startof = startof + multouts;
         end
		end
	endfunction
	
	// Ex: 5 mult inputs gives 2 as answer
	function integer calcstages;
		input integer multouts;
		begin			
			for (calcstages = 0; multouts > 1; multouts = (multouts + (`ADDSPERSTAGE-1))/`ADDSPERSTAGE) begin
				
				calcstages = calcstages + 1;
			end
		end
	endfunction
	
	
	function integer lowestind;
		input integer i1,i2;
		begin
			if(i1 < i2)
				lowestind = i1;
			else
				lowestind = i2;
		end
	endfunction
	
	function integer power;
		input integer inp,pow;
      integer loop;
		begin
			power = 1;
         for(loop = 0; loop < pow; loop = loop + 1) begin
            power = power * inp;
         end
		end
	endfunction
   
   function integer treeadderstotal;
      input integer treeinputs;
      begin
         treeadderstotal = 0;
         while(treeinputs > 0)
         begin
            treeadderstotal = treeadderstotal + treeinputs;
            treeinputs = (treeinputs + 1)/2;
         end
      end
   endfunction
endmodule

