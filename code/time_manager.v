/*------------------------------------------------------------------------------
--      File Name = time_manager.v                                            --
--                                                                            --
--      Design    = Second Signal Create                                      --
--                                                                            --
--      Revision  = 1.0         Date: 2011.6.15                               --
--                                                                            --
--      Copyright (C) 2011 MITSUBISHI ELECTRIC                                --
--                         MICRO-COMPUTER APPLICATION SOFTWARE                --
--                         COMPANY LIMITED                                    --
--                         All Rights Reserved.                               --
------------------------------------------------------------------------------*/
module time_manager(
//input
	CLK,
	RSTN,
//output
	SEC_SIG
);

//--- input --------------------------------------------------------------------
input  CLK;              // System Clock
input  RSTN;             // System Reset

//--- output -------------------------------------------------------------------
output  SEC_SIG;         // Second Signal

//--- reg ----------------------------------------------------------------------
reg  [27:0] SEC_COUNT;   // Second Counter
reg  SEC_SIG;            // Second Signal


parameter CLK_COUNT = 28'd100_000_000 -28'd1;   //for100MHz -> 1Hz


//******************** Start of Module ********************

//---------------------------
//  SEC_COUNT
//---------------------------
always@( posedge CLK or negedge RSTN) begin
	if( !RSTN )begin
		SEC_COUNT <= 28'd0;
	end
	else if( SEC_COUNT >= CLK_COUNT)begin
		SEC_COUNT <= 28'd0;
	end
	else begin
		SEC_COUNT <= SEC_COUNT + 28'd1;
	end
end

//---------------------------
//  SEC_SIG
//---------------------------
always@( posedge CLK or negedge RSTN) begin
	if( !RSTN )begin
		SEC_SIG <= 1'b0;
	end
	else if( SEC_COUNT >= CLK_COUNT )begin
		SEC_SIG <= 1'b1;
	end
	else begin
		SEC_SIG <= 1'b0;
	end
end

endmodule

