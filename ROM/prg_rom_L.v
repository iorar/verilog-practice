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
//*************************************** sample              
            4'h0: MC_CODE    <= 8'b00000000; //    START: MOV R0,0     
            4'h1: MC_CODE    <= 8'b01001110; //           MOV @0xE,R0  
            4'h2: MC_CODE    <= 8'b00001010; //           MOV R0,0xA   
            4'h3: MC_CODE    <= 8'b01001110; //           MOV @0xE,R0  
            4'h4: MC_CODE    <= 8'b00000101; //           MOV R0,0x5   
            4'h5: MC_CODE    <= 8'b01001110; //           MOV @0xE,R0  
            4'h6: MC_CODE    <= 8'b11010000; //           JMP START    
            4'h7: MC_CODE    <= 8'b11011111; //
            4'h8: MC_CODE    <= 8'b11011111; //
            4'h9: MC_CODE    <= 8'b11011111; //
            4'hA: MC_CODE    <= 8'b11011111; //
            4'hB: MC_CODE    <= 8'b11011111; //
            4'hC: MC_CODE    <= 8'b11011111; //
            4'hD: MC_CODE    <= 8'b11011111; //
            4'hE: MC_CODE    <= 8'b11011111; //
            4'hF: MC_CODE    <= 8'b11011111; //
            default: MC_CODE <= 8'b11011111;
        endcase
    end

endmodule


