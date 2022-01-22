/*************************************************************************
 * System Name : プロセッサ設計講座
 * File Name   : top_cpu.v
 * Contents    : 
 * Model       : MU500-RZX対応
 * FPGA        : Spartan-7
 * Author      : MMS
 * History     : 2020.12.4 作成
 * Memo        : 
 *
 *  Copyright (C) 2020
 *  Mitsubishi Electric Micro-Computer Application Software Co.,Ltd
 *  All rights reserved.
 **************************************************************************/
module top_cpu(
//--- System ---
	CLK,
	RSTN,

//--- Switch ---
	PSW,
	RSW,

//--- 7SEG-LED ---
	SEG_7A,SEG_7B,SEG_7C,SEG_7D,	//7SEG-LED A,B,C,D
	SEG_7E,SEG_7F,SEG_7G,SEG_7H,	//7SEG-LED E,F,G,H
	LED_OUT

);

//--- input -------------------------------------------------------------------
input         CLK;      // System Clock
input         RSTN;     // System Reset

input  [2:0]  PSW;      // Push Switch
input  [3:0]  RSW;      // Rorary Switch


//--- output ------------------------------------------------------------------
output [ 7:0] SEG_7A,SEG_7B,SEG_7C,SEG_7D;	//７セグメントLED上段
output [ 7:0] SEG_7E,SEG_7F,SEG_7G,SEG_7H;	//７セグメントLED下段
output [ 7:0] LED_OUT;						//LED


//--- wire --------------------------------------------------------------------
wire   [2:0] PSW_SIG;   // Push Switch

wire   [3:0] SEG_A_VAL; // 7SEG_0_Value
wire   [3:0] SEG_B_VAL; // 7SEG_1_value
wire   [3:0] SEG_C_VAL; // 7SEG_2_value
wire   [3:0] SEG_D_VAL; // 7SEG_3_value

wire         SEC_SIG;   // Second Signal



//****************************** Start of Module ******************************

//---------------------------
//  Remove Chataring Block
//---------------------------
key    u_key(
//input
	.CLK(CLK),
	.RSTN(RSTN),
	.PSW(PSW),
//output
	.PSW_SIG(PSW_SIG)
);

//---------------------------
//  Time Manager
//---------------------------
time_manager    u_time_manager(
//input
	.CLK(CLK),
	.RSTN(RSTN),
//output
	.SEC_SIG(SEC_SIG)
);

//---------------------------
//  td4cpu Body
//---------------------------
cpu4bit        u_cpu4bit(
//input
	.CLK(CLK),
	.RSTN(RSTN),
	.MODESET(PSW_SIG[1]),
	.CPURST(PSW_SIG[0]),
	.STEPINC(PSW_SIG[2]),
	.RSW(~RSW),
	.SEC_SIG(SEC_SIG),
//output
	.LED(LED_OUT),
	.SEG_A_VAL(SEG_A_VAL),
	.SEG_B_VAL(SEG_B_VAL),
	.SEG_C_VAL(SEG_C_VAL),
	.SEG_D_VAL(SEG_D_VAL)
);




data_displayE	u_data_displayE(
//---- input -------
	.CLK(CLK),
	.RSTN(RSTN),
	.SEG_DATA_1({1'b0,SEG_A_VAL}),			//A
	.SEG_DATA_2({1'b0,SEG_B_VAL}),			//B
	.SEG_DATA_3({1'b0,SEG_C_VAL}),			//C
	.SEG_DATA_4({1'b0,SEG_D_VAL}),			//D
	.SEG_DATA_5(5'h1F),		//E
	.SEG_DATA_6(5'h1F),		//F
	.SEG_DATA_7(5'h1F),		//G
	.SEG_DATA_8(5'h1F),		//H

//---- output ------
	.SEG_PAT_1(SEG_7A),
	.SEG_PAT_2(SEG_7B),
	.SEG_PAT_3(SEG_7C),
	.SEG_PAT_4(SEG_7D),
	.SEG_PAT_5(SEG_7E),
	.SEG_PAT_6(SEG_7F),
	.SEG_PAT_7(SEG_7G),
	.SEG_PAT_8(SEG_7H)
);


endmodule
