/*------------------------------------------------------------------------------
--      File Name = prg_rom.v                                                 --
--                                                                            --
--      Design    = Programing ROM Module                                     --
--                                                                            --
--      Revision  = 1.0         Date: 2011.6.15                               --
--      Revision  = 4.0         Date: 2016.05.09                              --
--                                                                            --
--      Copyright (C) 2011 MITSUBISHI ELECTRIC                                --
--                         MICRO-COMPUTER APPLICATION SOFTWARE                --
--                         COMPANY LIMITED                                    --
--                         All Rights Reserved.                               --
------------------------------------------------------------------------------*/
module prg_rom(
        // input
          PCNT,
        // output
          MC_CODE
);

//----- input --------------------------------------------
input  [3:0] PCNT;     // Program Counter

//----- output -------------------------------------------
output  [7:0] MC_CODE; // Machine Code

//----- reg ----------------------------------------------
reg  [7:0] MC_CODE;    // Machine Code


//******************** Start of Module ********************

//---------------------------
//  USER PROGRAM(MACHINE CODE)
//---------------------------
    always @( PCNT )
    begin
        case( PCNT )
//***************************************    sample               [DISPLAY]R0,R1  ,C,D     [LED]0,1,2,3
            // MY TEST PROGRAM by BITOU YUSUKE
            4'h0: MC_CODE    <= {4'h5, 4'hD};//   MOV R0,@Im     [DISPLAY]0,X    ,0,0     [LED]0,0,0,0
            4'h1: MC_CODE    <= {4'h1, 4'h2};//   MOV R1,2     [DISPLAY]2,X,   ,0,0     [LED]0,0,0,0
            4'h2: MC_CODE    <= {4'hF, 4'h1};//   SUB R0,R1     [DISPLAY]+1,0,   ,0,0     [LED]0,0,0,0
            4'h3: MC_CODE    <= {4'b1110, 4'h2};//   JNC 2        ketaage made add
            4'h4: MC_CODE    <= {4'b1010, 4'h0};//   ADD R0,0     [DISPLAY],+1,   ,0,0     [LED]0,0,0,0
            4'h5: MC_CODE    <= {4'h1, 4'h1};//   MOV R1,1     [DISPLAY]2,X,   ,0,0     [LED]0,0,0,0
            4'h6: MC_CODE    <= {4'b1110, 4'h8};//   JNC 8        ketaage made add
            4'h7: MC_CODE    <= {4'hB, 4'h0};//   ADD R1,0     [DISPLAY],+1,   ,0,0     [LED]0,0,0,0
            4'h8: MC_CODE    <= {4'hB, 4'h1};//   ADD R1,1     [DISPLAY],+1,   ,0,0     [LED]0,0,0,0
            4'h9: MC_CODE    <= {4'h6, 4'hE};//   MOV R1.OUT    [DISPLAY]5,1,   ,1,0?     [LED]0,0,0,0
            4'hA: MC_CODE    <= {4'b1101, 4'h0};//   JMP START    [DISPLAY]5,1,   ,1,4?     [LED]0,0,0,0
            4'hB: MC_CODE    <= 8'b11011111; //
            4'hC: MC_CODE    <= 8'b11011111; //
            4'hD: MC_CODE    <= 8'b11011111; //
            4'hE: MC_CODE    <= 8'b11011111; //
            4'hF: MC_CODE    <= 8'b11011111; //
            default: MC_CODE <= 8'b11011111;

        endcase
    end

endmodule


