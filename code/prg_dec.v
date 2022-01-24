/*--------------------------------------------------------------------
--      File Name = prg_dec.v                                      --
--                                                                 --
--      Design    = Program Dec Block                              --
--                                                                 --
--      Revision  = 1.0         Date: 2011.6.15                    --
--      Revision  = 3.0         Date: 2015.11.22                   --
--      Revision  = 4.0         Date: 2016.05.09                   --
--  Ver  4.0         Date: 2016.05.09                              --
--  Ver  4.1         Date: 2020.11.09                              --
--                                                                 --
--  Copyright (C) 2011-2020                                        --
--      MITSUBISHI ELECTRIC                                        --
--                     MICRO-COMPUTER APPLICATION SOFTWARE         --
--                     COMPANY LIMITED                             --
--                     All Rights Reserved.                        --
---------------------------------------------------------------------*/

module prg_dec(
//input
      CARRY,
      MC_CODE,
      R0_REG,
      R1_REG,

//output
      R0_LD,
      R1_LD,
      MEM_A,
      MEMW_LD,
      MEMR_LD,
      OUT_LD,
      PRG_CNT_LD,
      CARRY_LD,
      ALU_SEL
);

parameter P_MEM   = 4'hC;                  // maximum address of USER MEMORY(1)
parameter P_IOIN  = 4'hD;                  // address of IOIN(memory mapped I/O)
parameter P_IOOUT = 4'hE;                  // address of IOOUT(memory mapped I/O)

//--- input --------------------------------------------------------------------
input        CARRY;                        // ALU CARRYOUT
input  [7:0] MC_CODE;                      // MACHINE CODE
input  [3:0] R0_REG;                       // R0 REG
input  [3:0] R1_REG;                       // R1 REG

//--- output -------------------------------------------------------------------
output       R0_LD,R1_LD,MEMW_LD,MEMR_LD;   // REG LOAD PULSE
output       OUT_LD,PRG_CNT_LD;             // REG LOAD PULSE
output       CARRY_LD;                      // REG LOAD PULSE
output [3:0] ALU_SEL;                       // ALU SELECTER
output [3:0] MEM_A;                         // MEMORY ADDRESS

//----- reg ----------------------------------------------
reg    [3:0] ALU_SEL;                        // ALU SELECT
reg          R0_LD,R1_LD,OUT_LD,PRG_CNT_LD;  // ALU LOAD PULSE
reg          CARRY_LD;                       // ALU LOAD PULSE
reg          MEMW_LD,MEMR_LD;                // MEMORY LOAD PULSE
reg    [3:0] MEM_A;                          // MEMORY ADDRESS


//****************************** Start of Module ******************************

//---------------------------
//  DECODER
//---------------------------
    always @( MC_CODE or CARRY or R1_REG )
    begin
        case( MC_CODE[7:4] )
        4'h0:                // MOV R0,Im
            begin
                R0_LD       = 1'b1;
                R1_LD       = 1'b0;
                MEM_A       = 4'h0;
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'h0;
            end
        4'h1:                // MOV R1,Im
            begin
                R0_LD       = 1'b0;
                R1_LD       = 1'b1;
                MEM_A       = 4'h0;
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'h0;
            end

        4'h2:                // MOV @R1,R0
            begin
                R0_LD       = 1'b0;
                R1_LD       = 1'b0;
                MEM_A       = R1_REG;
                MEMW_LD     = 1'b1;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'h3;
            end

        4'h3:                // MOV R0,@R1
            begin
                R0_LD       = 1'b1;
                R1_LD       = 1'b0;
                MEM_A       = R1_REG;
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b1;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'h1;
            end

        4'h4:                // MOV @Im,R0
            begin
                R0_LD       = 1'b0;
                R1_LD       = 1'b0;
                MEM_A       = MC_CODE[3:0];
                MEMW_LD     = 1'b1;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'h3;
            end

        4'h5:                // MOV R0,@Im
            begin
                R0_LD       = 1'b1;
                R1_LD       = 1'b0;
                MEM_A       = MC_CODE[3:0];
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b1;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'h1;
            end

        4'h6:                // MOV @Im,R1
            begin
                R0_LD       = 1'b0;
                R1_LD       = 1'b0;
                MEM_A       = MC_CODE[3:0];
                MEMW_LD     = 1'b1;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b1;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'h4;
            end

        4'h7:                // MOV R1,@Im
            begin
                R0_LD       = 1'b0;
                R1_LD       = 1'b1;
                MEM_A       = MC_CODE[3:0];
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b1;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'h1;
            end

        4'h8:                // MOV R1,R0
            begin
                R0_LD       = 1'b0;
                R1_LD       = 1'b1;
                MEM_A       = 4'h0;
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'h3;
            end

        4'h9:                // IIN R0
            begin
                R0_LD       = 1'b1;
                R1_LD       = 1'b0;
                MEM_A       = 4'h0;
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'h2;
            end
        // 4'h9:                // MOV R0,R1
        //     begin
        //         R0_LD       = 1'b1;
        //         R1_LD       = 1'b0;
        //         MEM_A       = 4'h0;
        //         MEMW_LD     = 1'b0;
        //         MEMR_LD     = 1'b0;
        //         OUT_LD      = 1'b0;
        //         PRG_CNT_LD  = 1'b0;
        //         CARRY_LD    = 1'b0;
        //         ALU_SEL     = 4'h4;
        //     end
        4'hA:                // ADD R0,Im
            begin
                R0_LD       = 1'b1;
                R1_LD       = 1'b0;
                MEM_A       = 4'h0;
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b1;
                ALU_SEL     = 4'h5;
            end

        4'hB:                // ADD R1,Im
            begin
                R0_LD       = 1'b0;
                R1_LD       = 1'b1;
                MEM_A       = 4'h0;
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b1;
                ALU_SEL     = 4'h6;
            end

        4'hC:                // ADD R0,R1
            begin
                R0_LD       = 1'b1;
                R1_LD       = 1'b0;
                MEM_A       = 4'h0;
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b1;
                ALU_SEL     = 4'h7;
            end

        4'hD:                // JMP Im
            begin
                R0_LD       = 1'b0;
                R1_LD       = 1'b0;
                MEM_A       = 4'h0;
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b1;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'h0;
            end

        4'hE:                // JNC Im
            begin
                case(CARRY)
                1'b0:
                begin
                    R0_LD       = 1'b0;
                    R1_LD       = 1'b0;
                    MEM_A       = 4'h0;
                    MEMW_LD     = 1'b0;
                    MEMR_LD     = 1'b0;
                    OUT_LD      = 1'b0;
                    PRG_CNT_LD  = 1'b1;
                    CARRY_LD    = 1'b0;
                    ALU_SEL     = 4'h0;
                end
                1'b1:
                begin
                    R0_LD       = 1'b0;
                    R1_LD       = 1'b0;
                    MEM_A       = 4'h0;
                    MEMW_LD     = 1'b0;
                    MEMR_LD     = 1'b0;
                    OUT_LD      = 1'b0;
                    PRG_CNT_LD  = 1'b0;
                    CARRY_LD    = 1'b0;
                    ALU_SEL     = 4'h0;
                end
                endcase
            end

        // 4'hF:                // SUB R0,R1
        //     begin
        //         R0_LD       = 1'b1;
        //         R1_LD       = 1'b0;
        //         MEM_A       = 4'h0;
        //         MEMW_LD     = 1'b0;
        //         MEMR_LD     = 1'b0;
        //         OUT_LD      = 1'b0;
        //         PRG_CNT_LD  = 1'b0;
        //         CARRY_LD    = 1'b1;
        //         ALU_SEL     = 4'h8;
        //     end
        4'hF:                // MOD R0,R1
            begin
                R0_LD       = 1'b1;
                R1_LD       = 1'b0;
                MEM_A       = 4'h0;
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b0;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'h9;
            end

        default:              // 
            begin
                R0_LD       = 1'b0;
                R1_LD       = 1'b0;
                MEM_A       = 4'h0;
                MEMW_LD     = 1'b0;
                MEMR_LD     = 1'b0;
                OUT_LD      = 1'b0;
                PRG_CNT_LD  = 1'b1;
                CARRY_LD    = 1'b0;
                ALU_SEL     = 4'hF;
            end
        endcase
    end

endmodule