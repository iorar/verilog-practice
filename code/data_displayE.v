/*************************************************************************
 * System Name : 論理回路の基礎講座
 * File Name   : data_displayE.v
 * Contents    : 演習2,3,4
 * Model       : MU500-RZX対応
 * FPGA        : Spartan7
 * Author      : MMS
 * History     : 2020.11.11 作成
 * Memo        : 7セグメントLED表示回路 拡張機能あり
 *
 *  Copyright (C) 2020
 *  Mitsubishi Electric Micro-Computer Application Software Co.,Ltd
 *  All rights reserved.
 **************************************************************************/

module data_displayE(
// input
	CLK,
	RSTN,
	SEG_DATA_1,	SEG_DATA_2,	SEG_DATA_3,	SEG_DATA_4,
	SEG_DATA_5,	SEG_DATA_6,	SEG_DATA_7,	SEG_DATA_8,

// output
	SEG_PAT_1,SEG_PAT_2,SEG_PAT_3,SEG_PAT_4,
	SEG_PAT_5,SEG_PAT_6,SEG_PAT_7,SEG_PAT_8
);


// ------ input --------------------------------------------
input  	CLK;				// System Clock
input  	RSTN;				// System Reset

// 表示させたい値 数値の場合は下位4Bitを使用する。上位の1Bitは文字表示時の拡張用
input  	[4:0] SEG_DATA_1,SEG_DATA_2,SEG_DATA_3,SEG_DATA_4;
input  	[4:0] SEG_DATA_5,SEG_DATA_6,SEG_DATA_7,SEG_DATA_8;



// ------ output -------------------------------------------
// 表示させるパターン
output [7:0] SEG_PAT_1,SEG_PAT_2,SEG_PAT_3,SEG_PAT_4;
output [7:0] SEG_PAT_5,SEG_PAT_6,SEG_PAT_7,SEG_PAT_8;


// ------ wire ----------------------------------------------


//---------------------------
//  パターン変換
//---------------------------

display_module dm1(.CLK(CLK),.RSTN(RSTN),.SEG_VAL(SEG_DATA_1),.SEG(SEG_PAT_1));
display_module dm2(.CLK(CLK),.RSTN(RSTN),.SEG_VAL(SEG_DATA_2),.SEG(SEG_PAT_2));
display_module dm3(.CLK(CLK),.RSTN(RSTN),.SEG_VAL(SEG_DATA_3),.SEG(SEG_PAT_3));
display_module dm4(.CLK(CLK),.RSTN(RSTN),.SEG_VAL(SEG_DATA_4),.SEG(SEG_PAT_4));
display_module dm5(.CLK(CLK),.RSTN(RSTN),.SEG_VAL(SEG_DATA_5),.SEG(SEG_PAT_5));
display_module dm6(.CLK(CLK),.RSTN(RSTN),.SEG_VAL(SEG_DATA_6),.SEG(SEG_PAT_6));
display_module dm7(.CLK(CLK),.RSTN(RSTN),.SEG_VAL(SEG_DATA_7),.SEG(SEG_PAT_7));
display_module dm8(.CLK(CLK),.RSTN(RSTN),.SEG_VAL(SEG_DATA_8),.SEG(SEG_PAT_8));

endmodule



/*---------------------------------------------------------------
--                                                             --
--  Design = 7SEG Display Module                               --
--                                                             --
-----------------------------------------------------------------*/
module display_module(
// input
	CLK,
	RSTN,
	SEG_VAL,

// output
	SEG
);

//----- input --------------------------------------------
input  	CLK;			// System Clock
input  	RSTN;			// System Reset
input  	[4:0] SEG_VAL;	// Display Value

//----- output -------------------------------------------
output 	[7:0] SEG;		// Display 7SEG

//----- reg ----------------------------------------------
reg    	[7:0] SEG;		// Display 7SEG Register

//------------------
//  7SEG DISPLAY
//------------------

always@( posedge CLK or negedge RSTN ) begin    //always文での作成例
  	if( !RSTN )begin
    	SEG <= 8'b00000010;			//
	end
	else begin
    	case( SEG_VAL )
			5'h0: SEG <= 8'b11111100; // 0
			5'h1: SEG <= 8'b01100000; // 1
			5'h2: SEG <= 8'b11011010; // 2
			5'h3: SEG <= 8'b11110010; // 3
			5'h4: SEG <= 8'b01100110; // 4
			5'h5: SEG <= 8'b10110110; // 5
			5'h6: SEG <= 8'b10111110; // 6
			5'h7: SEG <= 8'b11100000; // 7
			5'h8: SEG <= 8'b11111110; // 8
			5'h9: SEG <= 8'b11110110; // 9
			5'hA: SEG <= 8'b11101110; // A
			5'hB: SEG <= 8'b00111110; // b
			5'hC: SEG <= 8'b00011010; // c
			5'hD: SEG <= 8'b01111010; // d
			5'hE: SEG <= 8'b10011110; // E
			5'hF: SEG <= 8'b10001110; // F

			5'h10: SEG <= 8'b00000010; // -
			5'h11: SEG <= 8'b01101110; // H
			5'h12: SEG <= 8'b00001100; // I
			5'h13: SEG <= 8'b01110000; // J
			5'h14: SEG <= 8'b00011100; // L
			5'h15: SEG <= 8'b00111010; // o
			5'h16: SEG <= 8'b11001110; // P
			5'h17: SEG <= 8'b10110110; // S
			5'h18: SEG <= 8'b10001100; // T
			5'h19: SEG <= 8'b01111100; // U

//ここ表示させたいパターンを追加できます
	//		5'h1A: SEG <= 		 // -
	//		5'h1B: SEG <= 		 // -
	//		5'h1C: SEG <= 		 // -
	//		5'h1D: SEG <= 		 // -
//ここ表示させたいパターンを追加できます

			5'h1E: SEG <= 8'b00000001; // dot
			5'h1F: SEG <= 8'b00000000; // 消す

			default : SEG <= 8'b00000000;
		endcase
	end
end

endmodule


