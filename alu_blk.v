/*-------------------------------------------------------------------
--      File Name = alu_blk.v                                      --
--                                                                 --
--      Design    = ALU Block                                      --
--                                                                 --
--  Ver  1.0         Date: 2011.6.15                               --
--  Ver  3.0         Date: 2015.11.22                              --
--  Ver  4.0         Date: 2016.05.09                              --
--  Ver  4.1         Date: 2020.11.09                              --
--                                                                 --
--  Copyright (C) 2011-2020                                        --
--      MITSUBISHI ELECTRIC                                        --
--                     MICRO-COMPUTER APPLICATION SOFTWARE         --
--                     COMPANY LIMITED                             --
--                     All Rights Reserved.                        --
---------------------------------------------------------------------*/

module alu_blk(
//input
      R0_REG,
      R1_REG,
      Im,
      IOIN,
      MEMIN,
      ALU_SEL,

//output
      CARRY,
      SUM
);

//--- input --------------------------------------------------------------------
input  [3:0] R0_REG,R1_REG;           // R0_REG,R1_REG
input  [3:0] Im;                      // Immediate value
input  [3:0] IOIN;                    // I/O Input
input  [3:0] MEMIN;                   // Memory Read Data
input  [3:0] ALU_SEL;                 // ALU SELCT

//--- output -------------------------------------------------------------------
output       CARRY;                   // CARRYOUT out
output [3:0] SUM;                     // SUM out

//--- reg ----------------------------------------------------------------------
reg    [3:0] ALU_Q0,ALU_Q1;           // ALU Q0,Q1
reg    [4:0] ALU_SUM;                 // ALU SUM

//--- wrire ----------------------------------------------------------------------
wire   [3:0] SUM;                     // ALU INPUT,OUTPUT
wire         CARRY;                   // ALU CARRY OUT


//****************************** Start of Module ******************************


//---------------------------
//  ALU_SEL
//---------------------------
always @( ALU_SEL or R0_REG or R1_REG or Im or IOIN or MEMIN ) begin
    case( ALU_SEL )
        4'h0:begin
            ALU_Q0 <= Im;
            ALU_Q1 <= 4'h0;
        end
        4'h1:begin
            ALU_Q0 <= MEMIN;
            ALU_Q1 <= 4'h0;
        end
        4'h2:begin
            ALU_Q0 <= IOIN;
            ALU_Q1 <= 4'h0;
        end
        4'h3:begin
            ALU_Q0 <= R0_REG;
            ALU_Q1 <= 4'h0;
        end
        4'h4:begin
            ALU_Q0 <= R1_REG;
            ALU_Q1 <= 4'h0;
        end
        4'h5:begin
            ALU_Q0 <= R0_REG;
            ALU_Q1 <= Im;
        end
        4'h6:begin
            ALU_Q0 <= R1_REG;
            ALU_Q1 <= Im;
        end
        4'h7:begin
            ALU_Q0 <= R0_REG;
            ALU_Q1 <= R1_REG;
        end

        4'h8:begin                   //V3.0
            ALU_Q0 <= R0_REG;
            ALU_Q1 <= R1_REG;
        end

        default:begin
            ALU_Q0 <= 4'h0;
            ALU_Q1 <= 4'h0;
        end
        endcase
    end

//---------------------------
//  ADDITIONAL
//---------------------------
always @( ALU_Q0 or ALU_Q1 or ALU_SEL )
     if( ALU_SEL == 4'h8)   //V3.0
       begin
         ALU_SUM <= {1'b0,ALU_Q0} - {1'b0,ALU_Q1}; 
       end
     else  begin
         ALU_SUM <= {1'b0,ALU_Q0} + {1'b0,ALU_Q1};
     end


assign CARRY = ALU_SUM[4];
assign SUM   = ALU_SUM[3:0];


endmodule
