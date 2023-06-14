//////////////////////////////////////////////////////////////////////////////////
//
// Copyright © 2010 Signal Processing Devices Sweden AB. All rights reserved.
//
// Module Name:    user_logic
// Project Name:   ADQ
// Revision:
// Description:    Module for SDR14 DevKit
//
/////////////////////////////////////////////////////////////////////////////////

module sdr14_user_logic
  #(
    parameter NofBits = 16,
    parameter NofDacBits = 14
    )
   (
	// INPUT/OUTPUTS
    input wire [3:0]                   ext_trig_i,

    // Clocks and reset
    input wire                         clk_1_4, // 200MHz clock
    input wire                         clk_1_2, // 400 MHz clock
    input wire                         clk50, // 50MHz clock
    input wire                         rst_i, // Reset signal

    // Trig signals
    input wire [15:0]                  ext_trig_vector_i, // External trigger in
    output reg [15:0]                  ext_trig_vector_o, // External trigger out
    input wire                         internal_trig_i, // Internal trigger
    output wire                        host_trig_o, // Software trigger to acquisition logic
    input wire                         host_trig_i, // Software trigger from PC

    // Data from ADC
	// CH A (IN 1)
    input wire signed [NofBits-1:0]    data_a0_i,
    input wire signed [NofBits-1:0]    data_a1_i,
    input wire signed [NofBits-1:0]    data_a2_i,
    input wire signed [NofBits-1:0]    data_a3_i,
	// CH B (IN 2) (unused)
    input wire signed [NofBits-1:0]    data_b0_i,
    input wire signed [NofBits-1:0]    data_b1_i,
    input wire signed [NofBits-1:0]    data_b2_i,
    input wire signed [NofBits-1:0]    data_b3_i,
    input wire                         data_valid_i,

    // Data from DRAM (unused)
	// CH A 
    input wire signed [NofDacBits-1:0] dac_a0_i,
    input wire signed [NofDacBits-1:0] dac_a1_i,
    input wire signed [NofDacBits-1:0] dac_a2_i,
    input wire signed [NofDacBits-1:0] dac_a3_i,
    input wire signed [NofDacBits-1:0] dac_a4_i,
    input wire signed [NofDacBits-1:0] dac_a5_i,
    input wire signed [NofDacBits-1:0] dac_a6_i,
    input wire signed [NofDacBits-1:0] dac_a7_i,
    input wire                         dac_a_valid_i,
    output wire                        dac_a_read_en_o,
	// CH B
    input wire signed [NofDacBits-1:0] dac_b0_i,
    input wire signed [NofDacBits-1:0] dac_b1_i,
    input wire signed [NofDacBits-1:0] dac_b2_i,
    input wire signed [NofDacBits-1:0] dac_b3_i,
    input wire signed [NofDacBits-1:0] dac_b4_i,
    input wire signed [NofDacBits-1:0] dac_b5_i,
    input wire signed [NofDacBits-1:0] dac_b6_i,
    input wire signed [NofDacBits-1:0] dac_b7_i,
    input wire                         dac_b_valid_i,
    output wire                        dac_b_read_en_o,

    // Data to DRAM
	// CH A
    output reg signed [NofBits-1:0]    data_a0_o,
    output reg signed [NofBits-1:0]    data_a1_o,
    output reg signed [NofBits-1:0]    data_a2_o,
    output reg signed [NofBits-1:0]    data_a3_o,
	// CH B
    output reg signed [NofBits-1:0]    data_b0_o,
    output reg signed [NofBits-1:0]    data_b1_o,
    output reg signed [NofBits-1:0]    data_b2_o,
    output reg signed [NofBits-1:0]    data_b3_o,
    output reg                         data_valid_o,

    // Data to DAC
	// CH A (OUT 1)
    output signed [NofDacBits-1:0] dac_a0_o,
    output signed [NofDacBits-1:0] dac_a1_o,
    output signed [NofDacBits-1:0] dac_a2_o,
    output signed [NofDacBits-1:0] dac_a3_o,
    output signed [NofDacBits-1:0] dac_a4_o,
    output signed [NofDacBits-1:0] dac_a5_o,
    output signed [NofDacBits-1:0] dac_a6_o,
    output signed [NofDacBits-1:0] dac_a7_o,
    output dac_a_valid_o,
	
	// CH B (OUT 2) (unused)
    output signed [NofDacBits-1:0] dac_b0_o,
    output signed [NofDacBits-1:0] dac_b1_o,
    output signed [NofDacBits-1:0] dac_b2_o,
    output signed [NofDacBits-1:0] dac_b3_o,
    output signed [NofDacBits-1:0] dac_b4_o,
    output signed [NofDacBits-1:0] dac_b5_o,
    output signed [NofDacBits-1:0] dac_b6_o,
    output signed [NofDacBits-1:0] dac_b7_o,
    output dac_b_valid_o,

    // AWG segment switch status registers
    input wire [7:0]                   awg_segment_status_a_i,
    input wire [7:0]                   awg_segment_status_b_i,

    // User registers
    input wire [32*16-1:0]             user_register_i,
    output wire [32*16-1:0]            user_register_o,

    // GPIO port HW side
    input wire [4:0]                   com_gpio_i,
    output wire [4:0]                  com_gpio_o,
    output wire [4:0]                  com_gpio_oen_o,

    // GPIO port processor side
    output wire [4:0]                  com_gpio_mcu_o,
    input wire [4:0]                   com_gpio_mcu_i,
    input wire [4:0]                   com_gpio_oen_mcu_i,

    // Trigger signal to/from Trig ports
    input wire                         trigout_i,
    output wire                        trigout_o,
    output wire                        trigout_oen_o,

    // Trigger output to/from PC
    output wire                        trigout_mcu_o,
    input wire                         trigout_mcu_i,
    input wire                         trigout_oen_mcu_i,

    output wire [31:0]                 ul_partnumber_1_o,
    output wire [31:0]                 ul_partnumber_2_o
   );


   // -----------------------------------------------------------------------------------------------
   // PART NUMBER SET-UP
   // This section sets the user logic part number, which can be set in the user logic build script
   // using set_userlogicpartnumber and read out through the API using GetUserLogicPartNumber().
   // Either rebuild the project or modify the include file, in order to change part number.
   `include "userlogicpartnumber.v"
   assign ul_partnumber_1_o = {`USER_LOGIC_PARTNUM_2 , `USER_LOGIC_PARTNUM_1};
   assign ul_partnumber_2_o = {`USER_LOGIC_PARTNUM_REV , `USER_LOGIC_PARTNUM_3};
   // -----------------------------------------------------------------------------------------------
	
	
   // -----------------------------------------------------------------------------------------------
   // USER REGISTER SET-UP
   // This section initialises the user register. It assigns values from the user register, which can
   // be accesssed using ADQAPI functions from Python, into the Verilog code.
   

   // Variables for user register
   wire enable_PC;
   wire [191:0] pulse_timing_data;
   wire [63:0] pulse_timing_SF;
   wire [31:0] frq_out;
   wire [14:0] TX_phase_data;
	wire [4:0] RX_phase_data;

   // Default user register set-up
   wire [31:0] user_register_in [15:0];
   wire [31:0] user_register_out [15:0];
   assign user_register_o = {user_register_out[15],user_register_out[14],
                             user_register_out[13],user_register_out[12],
                             user_register_out[11],user_register_out[10],
                             user_register_out[ 9],user_register_out[ 8],
                             user_register_out[ 7],user_register_out[ 6],
                             user_register_out[ 5],user_register_out[ 4],
                             user_register_out[ 3],user_register_out[ 2],
                             user_register_out[ 1],user_register_out[ 0]};

   // Synchronizing
   (* SHREG_EXTRACT="NO" *) (* ASYNC_REG="TRUE" *) reg [32*16-1:0] user_register_capture;
   (* SHREG_EXTRACT="NO" *) reg [32*16-1:0] user_register_sync;
   always @(posedge clk_1_4)
     begin
        user_register_capture <= user_register_i;
        user_register_sync    <= user_register_capture;
     end

   assign {user_register_in[15],user_register_in[14],
           user_register_in[13],user_register_in[12],
           user_register_in[11],user_register_in[10],
           user_register_in[ 9],user_register_in[ 8],
           user_register_in[ 7],user_register_in[ 6],
           user_register_in[ 5],user_register_in[ 4],
           user_register_in[ 3],user_register_in[ 2],
           user_register_in[ 1],user_register_in[ 0]} = user_register_sync;

		
   // Pull values from user register into code (see manual for definition of register contents)
   // enable_PC flag
   assign enable_PC  = user_register_in[0][0];
   // TTL Pulse timing data
   assign pulse_timing_data  = {user_register_in[2], user_register_in[3], user_register_in[4], user_register_in[5], user_register_in[6], user_register_in[7]};
   assign pulse_timing_SF = {user_register_in[8], user_register_in[9]};
   // Output RF frequency
   assign frq_out = user_register_in[1];
   // TX phase -  P1 = bits 31:27, P2 = 26:22, P3 = bits 21:17  
   assign TX_phase_data = user_register_in[0][31:17];
	// RX phase
	assign RX_phase_data = user_register_in[10][4:0];
   
   // -----------------------------------------------------------------------------------------------
   
   // -----------------------------------------------------------------------------------------------
   // AWG SET-UP
   // This section handles the AWG set-up (unused).
   //   
   // AWG segment switch status registers (in clk_1_4 domain)
   // Bit 0 - strobes first data of segment (new lap or segment switch)
   // Bit 1 - strobes last data of segment
   // Bit 2 - strobes when first data of segment, and it is a segment switch (not just lap switch)
   // Bit 3 - reserved
   // Bit 4 - strobes first data of segment for ul enabled segments (playlist mode only)
   // Bit 5 - strobes on segment switch (not wrap) for ul enabled segments (playlist mode only)
   // Bit 6 - reserved
   // Bit 7 - reserved
   (* S = "TRUE" *) reg    awg_segswitch_a;
   (* S = "TRUE" *) reg    awg_segswitch_b;
   (* S = "TRUE" *) reg    awg_lapswitch_a;
   (* S = "TRUE" *) reg    awg_lapswitch_b;
   always @(posedge clk_1_4)
     begin
        awg_lapswitch_a <= ~awg_segment_status_a_i[2] && awg_segment_status_a_i[0];
        awg_lapswitch_b <= ~awg_segment_status_b_i[2] && awg_segment_status_b_i[0];
        awg_segswitch_a <= awg_segment_status_a_i[2];
        awg_segswitch_b <= awg_segment_status_b_i[2];
     end

   // -----------------------------------------------------------------------------------------------
   // TRIGGER SET-UP
   // This section handles the triggers
   // Pass through these signals when not used in user logic
   
   // Software trigger (must be passed through to use software trigger mode)
   assign host_trig_o = host_trig_i;
   // Trigout port
   assign trigout_mcu_o = trigout_i;
   assign trigout_o = trigout_mcu_i;
   assign trigout_oen_o = trigout_oen_mcu_i;
   
   // External trigger (must have same latency through UL as the ADC data)
	// Generated in three_pulse.v
   always @(posedge clk_1_4)
      begin
         //ext_trig_vector_o <= ext_trig_vector_i;
			ext_trig_vector_o <= {16{ADC_enable}};
      end

   // -----------------------------------------------------------------------------------------------
   
   // -----------------------------------------------------------------------------------------------
   // GPIO SET-UP
   // This section assigns the amplifier unblank signal to GPIO 0. ALl unused signals are either
   // passed through or set to 0.
 
   // Passes amplifier enable signal to GPIO
   assign com_gpio_o[0] = amp_enable;
	// Passes ADC enable signal to GPIO
	assign com_gpio_o[3] = ADC_enable;
	// Passes unused GPIO lines through
   assign com_gpio_o[2:1] = com_gpio_mcu_i[2:1];
	// Passes software trigger to GPIO
   assign com_gpio_o[4] = host_trig_i;
	
   // Enable GPIO output
   assign com_gpio_oen_o[4:0] = {5{enable_PC}};
   // GPIO to PC 
   assign com_gpio_mcu_o[2:0] = 3'b0;
   assign com_gpio_mcu_o[4:3] = com_gpio_i[4:3];
   
   // -----------------------------------------------------------------------------------------------
   
   // -----------------------------------------------------------------------------------------------
   // OUTPUT DATA TO DAC SET-UP
   // This section sets up the signal path to DAC A (OUT 1) and turns DAC B (OUT 2) off.
   wire [14*8-1:0] signal_out; 
	
   // Split signal_out into 14-bit samples and send to DAC A (if enable_PC == 1 & signal_valid from signal generator == 1).
   assign {dac_a7_o, dac_a6_o, dac_a5_o, dac_a4_o, dac_a3_o, dac_a2_o, dac_a1_o, dac_a0_o} = signal_out;
   assign dac_a_valid_o = enable_PC & RF_signal_valid;	
	
   // Turn DAC B off
   assign {dac_b7_o, dac_b6_o, dac_b5_o, dac_b4_o, dac_b3_o, dac_b2_o, dac_b1_o, dac_b0_o} = 112'b0;
   assign dac_b_valid_o = 1'b0;
   
	// Disable DAC data from DRAM read
   assign dac_a_read_en_o = 1'b1;
   assign dac_b_read_en_o = 1'b1;
	
   // -----------------------------------------------------------------------------------------------

   // -----------------------------------------------------------------------------------------------
   // INPUT DATA FROM ADC SET-UP
   // This section sets up the signal path for incoming data.
   reg [14*4-1:0] signal_in;
   
   // Combine 4 incoming samples into single variable on every clock cycle
   always @(posedge clk_1_4)
     begin
        signal_in <= {data_a3_i[15:2],data_a2_i[15:2],data_a1_i[15:2],data_a0_i[15:2]};
     end
   // -----------------------------------------------------------------------------------------------
   
   // -----------------------------------------------------------------------------------------------
   // OUTPUT DATA TO DRAM/PC SET-UP
   // This section sets up the signal path from sending data to the DRAM to be sent to the host PC.
   wire [16*4-1:0] data_out_I;
   wire [16*4-1:0] data_out_Q;
   
   // On every clock cycle
   always @(posedge clk_1_4)
      begin
	    // Send data_out_I to DRAM A
        data_a0_o <= data_out_I[15:0];
        data_a1_o <= data_out_I[31:16];
        data_a2_o <= data_out_I[47:32];
        data_a3_o <= data_out_I[63:48];
		// Send data_out_Q to DRAM B
	    data_b0_o <= data_out_Q[15:0];
        data_b1_o <= data_out_Q[31:16];
        data_b2_o <= data_out_Q[47:32];
        data_b3_o <= data_out_Q[63:48];
		// Data is valid when enable_PC == 1 and when data from filter is valid.
        data_valid_o <= enable_PC & filter_valid;
      end
	// -----------------------------------------------------------------------------------------------

	// -----------------------------------------------------------------------------------------------
	// OPERATIONS CALL
	// This section instantiates the 'operations' module and any internal valid flags.

	wire RF_signal_valid;
	wire filter_valid;

	operations operations (
        .signal_in(signal_in), // from ADC 
        .signal_out(signal_out), // to DAC
        .amp_enable(amp_enable), // to GPIO
		  .ADC_enable(ADC_enable), // to GPIO
        .clk(clk_1_4), // from clock source
        .enable_PC(enable_PC), // from user reg 0 bit 0
        .TX_phase_data(TX_phase_data), // from user reg 0 bits 12-8
		  .RX_phase_data(RX_phase_data), // from user reg 10 bits 4-0
        .frq_out(frq_out), // from user reg 1 bits 31-0
        .pulse_timing_data(pulse_timing_data), // from user reg
        .data_out_i(data_out_I), // to DRAM A
        .data_out_q(data_out_Q), // to DRAM B
        .RF_signal_valid(RF_signal_valid), // from signal generator
		  .filter_valid(filter_valid) // from signal analysis
        );
		
	// -----------------------------------------------------------------------------------------------
	
endmodule
