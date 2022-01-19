/*************************************************************************
 * System Name : プロセッサ設計講座
 * File Name   : key.v
 * Contents    : 
 * Model       : MU500-RZX対応
 * FPGA        : Spartan-7
 * Author      : MMS
 * History     : 2020.12.4 作成
 * Memo        : キー入力制御(チャタリング吸収あり)
 *
 *  Copyright (C) 2020
 *  Mitsubishi Electric Micro-Computer Application Software Co.,Ltd
 *  All rights reserved.
 **************************************************************************/
module key( 
// input
	CLK, 
	RSTN,
	PSW,

// output
	PSW_SIG
);

//------ input --------------------------------------------
input  CLK;            // System Clock
input  RSTN;           // System Reset
input  [2:0] PSW;      // Push Switch

//------ output -------------------------------------------
output [2:0] PSW_SIG;  // High Pulse Switch Signal

//------ reg ----------------------------------------------
reg  [2:0] PSW_1D;      // Delay Push Switch


//******************** Start of Module ********************

//---------------------------
//         System Reset
//---------------------------
always@( posedge CLK or negedge RSTN ) begin
    if( RSTN == 1'b0 )begin
        PSW_1D <= 3'b000;
    end
    else begin
        PSW_1D <= PSW;
    end
end


// Push Switch
key_module key_module1(.CLK(CLK),.RSTN(RSTN),.PSW_1D(PSW_1D[0]),.PSW_SIG(PSW_SIG[0]));
key_module key_module2(.CLK(CLK),.RSTN(RSTN),.PSW_1D(PSW_1D[1]),.PSW_SIG(PSW_SIG[1]));
key_module key_module3(.CLK(CLK),.RSTN(RSTN),.PSW_1D(PSW_1D[2]),.PSW_SIG(PSW_SIG[2]));


endmodule



module key_module(
//input
	CLK, 
    RSTN,
    PSW_1D,

//output
    PSW_SIG
);

//------ input ----------------------------------------------------------------
input  CLK;                 // System Clock
input  RSTN;                // System Reset
input  PSW_1D;              // Push Switch 1 Delay

//------ output ---------------------------------------------------------------
output  PSW_SIG;            // Remove Chattering Signal(High pulse Signal)

//------ reg ------------------------------------------------------------------
reg  PSW_2D;                // Push Switch 2 Delay
reg  [1:0] PSW_DIFF;        // Check Push Switch Change
reg  [18:0] PSW_COUNT;      // 500,000 Clock Counter
reg  PSW_SIG;               // Push-SW Signal

parameter CLK_COUNT   =   19'd500000; 
//******************** Start of Module ********************

//---------------------------
// Delay Push Switch Signal
//---------------------------
always@( posedge CLK or negedge RSTN) begin
    if( !RSTN )begin
        PSW_2D <= 1'b0;
    end
    else begin
        PSW_2D <= PSW_1D;
    end
end

//---------------------------
// Check Push Switch Change
//---------------------------
always@( posedge CLK or negedge RSTN) begin
    if( !RSTN )begin
        PSW_DIFF <= 2'd0;
    end
    else if(PSW_1D == 1 && PSW_2D == 1)begin
        PSW_DIFF <= 2'd0;
    end
    else if(PSW_1D == 0 && PSW_2D == 1)begin
        PSW_DIFF <= 2'd1;
    end
    else if(PSW_1D == 0 && PSW_2D == 0)begin
        PSW_DIFF <= 2'd2;
    end
    else begin
        PSW_DIFF <= 2'd3;
    end
end

//---------------------------
//  Push Switch Counter
//---------------------------
always@( posedge CLK or negedge RSTN) begin
    if( !RSTN )begin
        PSW_COUNT <= 19'd0;
    end
    else if( PSW_DIFF == 2'd0)begin
        PSW_COUNT <= 19'd0;
    end
    else if( PSW_DIFF == 2'd1)begin
        PSW_COUNT <= 19'd1;
    end
    else if( PSW_DIFF == 2'd2)begin
        if( 19'd1 <= PSW_COUNT && PSW_COUNT < CLK_COUNT )begin    //normal
            PSW_COUNT <= PSW_COUNT + 19'd1;
        end
        else begin
            PSW_COUNT <= 19'd0;
        end
    end
    else begin
        PSW_COUNT <= 19'd0;
    end
end

//---------------------------
// Output Switch High pulse
//---------------------------
always@( posedge CLK or negedge RSTN) begin
    if( RSTN == 1'b0 )begin
        PSW_SIG <= 1'b0;
    end
    else if( PSW_COUNT >= CLK_COUNT )begin			//normal
        PSW_SIG <= 1'b1;
    end
    else begin
        PSW_SIG <= 1'b0;
    end
end

endmodule



