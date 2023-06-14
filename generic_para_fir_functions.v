
//////////////////////////////////////////////////////////////////////////////////
// Company: 		 SP Devices
// Engineer: 		 Daniel Björklund (daniel.bjorklund@spdevices.com)
// 
// Create Date:    09:50:21 02/22/2012 
// Design Name: 	 
// Module Name:    generic_para_fir_functions 
// Project Name:   SDR14 transmitter/receiver example modules
// Target Devices: SDR14
// Tool versions:  ISE 12.4
//
// Description:    
// 
//		Include file for use with generic_para_fir, calculates the latency of the FIR instantiation
// 
// Revision: 
//
//////////////////////////////////////////////////////////////////////////////////

	function integer generic_para_fir_delay;
		input integer taps;
	begin:genfirdel
		integer add_del;
		taps = (taps + 1)/2;
		for(add_del = 0; taps > 1; add_del = add_del + 1) begin
			taps = (taps + 1)/2;
		end
		generic_para_fir_delay = 3 + add_del +2;
	end
	endfunction
	
	
	