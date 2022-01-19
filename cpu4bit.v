/*--------------------------------------------------------------------
--      File Name = cpu4bit.v                                      --
--                                                                 --
--      Design    = 4bitMicroProsesser Main Block                  --
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
module cpu4bit(
//input
     CLK,
     RSTN,
     MODESET,
     CPURST,
     STEPINC,
     RSW,
     SEC_SIG,

//output
     LED,
     SEG_A_VAL,
     SEG_B_VAL,
     SEG_C_VAL,
     SEG_D_VAL
);

parameter MEMNUM   = 16;

//--- input --------------------------------------------------------------------
input  CLK;            // System Clock
input  RSTN;           // System Reset
input  MODESET;        // Mode Set
input  CPURST;         // CPU reset
input  STEPINC;        // Step Executing
input  [3:0] RSW;      // Rotary switch 
input  SEC_SIG;        // Second Signal

//--- output -------------------------------------------------------------------
output  [7:0] LED;      // LED out
output  [3:0] SEG_A_VAL,SEG_B_VAL,SEG_C_VAL,SEG_D_VAL;    // 7seg out

//--- reg ----------------------------------------------------------------------
reg        MOVE_FLG;                       // 0:Stop Mode   1:Moveing Mode
reg        PLUS_A;                         // Count Up Signal
reg  [3:0] PCNT;                           // ProgramCount Register

reg  [3:0] R0_REG_VAL, R1_REG_VAL, LED_VAL;  // A B OUTport Register

reg        CARRY;                          // Carry ALU Signal

reg  [3:0] mem [0:MEMNUM-1];               // MEMORY
reg  [3:0] MEMIN;                          // MEMORY READ DATA

//--- wire ----------------------------------------------------------------------
wire [3:0] SUM;                            // ALU SUM
wire       CO;                             // ALU CARRY OUT
wire [7:0] MC_CODE;                        // Machine Code
wire [3:0] Im;                             // Immediate value

wire [3:0] ALU_SEL;                        // ALU SELCT
wire       R0_LD,R1_LD,OUT_LD,PRG_CNT_LD;  // Load Pulse
wire       CARRY_LD;                       // Load Pulse
wire       MEMW_LD,MEMR_LD;                // Load Pulse
wire [3:0] MEM_A;                          // Memory Address


//****************************** Start of Module ******************************

//-------------------
//    Change Mode
//-------------------
always@( posedge CLK or negedge RSTN) begin
      if( !RSTN ) begin
          MOVE_FLG <= 1'b0;
      end
      else if( MODESET == 1'b1) begin
          MOVE_FLG <= ~MOVE_FLG;
      end
      else if( CPURST == 1'b1 )begin
          MOVE_FLG <= 1'b0;
      end
      else begin
          MOVE_FLG <= MOVE_FLG;
      end
end

//-------------------------
// Count Up Signal Create
//-------------------------
always@( posedge CLK or negedge RSTN) begin
     if( !RSTN )begin
         PLUS_A  <= 1'b0;
     end
     else if( STEPINC == 1'b1 )begin
         PLUS_A  <= 1'b1;
     end
     else begin
         PLUS_A  <= 1'b0;
     end
end

//-------------------------------------
//  Program COUNT
//-------------------------------------
always@( posedge CLK or negedge RSTN) begin
	if( !RSTN )begin
		PCNT <= 4'd0;
	end
	else if( CPURST == 1'b1 )begin
		PCNT <= 4'd0;
	end

// Stop Mode
	else if( MOVE_FLG == 1'b0 )begin
		if( PLUS_A == 1'b1 )begin
			if( PRG_CNT_LD == 1'b1 )begin
				PCNT <= SUM;
			end
			else begin
				PCNT <= PCNT + 4'd1;
			end
		end
		else begin
			PCNT <= PCNT;
		end
	end

// Moving Mode
	else begin
		if( SEC_SIG == 1'b1 )begin
			if( PRG_CNT_LD == 1'b1 )begin
				PCNT <= SUM;
			end
			else begin
				PCNT <= PCNT + 4'd1;
			end
		end
		else begin
			PCNT <= PCNT;
		end
	end
end

//-------------------------------------
//  R0reg 
//-------------------------------------
always@( posedge CLK or negedge RSTN) begin
	if( !RSTN )begin
		R0_REG_VAL <= 4'd0;
	end
	else if( CPURST == 1'b1 )begin
		R0_REG_VAL <= R0_REG_VAL;
	end

// Stop Mode
	else if( MOVE_FLG == 1'b0 )begin
		if( PLUS_A == 1'b1 )begin
			if( R0_LD == 1'b1 )begin
				R0_REG_VAL <= SUM;
			end
			else begin
				R0_REG_VAL <= R0_REG_VAL;
				end
			end
			else begin
				R0_REG_VAL <= R0_REG_VAL;
			end
		end

// Moving Mode
		else begin
			if( SEC_SIG == 1'b1 )begin
				if( R0_LD == 1'b1 )begin
					R0_REG_VAL <= SUM;
				end
				else begin
					R0_REG_VAL <= R0_REG_VAL;
				end
			end
		else begin
			R0_REG_VAL <= R0_REG_VAL;
		end
	end
end

//-------------------------------------
//  R1reg 
//-------------------------------------
always@( posedge CLK or negedge RSTN) begin
    if( !RSTN )begin
        R1_REG_VAL <= 4'd0;
    end
    else if( CPURST == 1'b1 )begin
        R1_REG_VAL <= R1_REG_VAL;
    end

// Stop Mode
    else if( MOVE_FLG == 1'b0 )begin
        if( PLUS_A == 1'b1 )begin
            if( R1_LD == 1'b1 )begin
                R1_REG_VAL <= SUM;
            end
            else begin
                R1_REG_VAL <= R1_REG_VAL;
            end
        end
        else begin
            R1_REG_VAL <= R1_REG_VAL;
        end
    end

// Moving Mode
    else begin
        if( SEC_SIG == 1'b1 )begin
            if( R1_LD == 1'b1 )begin
                R1_REG_VAL <= SUM;
            end
            else begin
                R1_REG_VAL <= R1_REG_VAL;
            end
        end
        else begin
            R1_REG_VAL <= R1_REG_VAL;
        end
    end
end

//-------------------------------------
//  Memory
//-------------------------------------
always@( posedge CLK or negedge RSTN) begin

/*
	integer i;

    if( !RSTN )begin
        for(i=0; i<MEMNUM; i=i+1)
            mem[i] <= 4'h0;
    end
*/

	if( !RSTN )begin
		mem[ 0] <= 4'h0;
		mem[ 1] <= 4'h0;
		mem[ 2] <= 4'h0;
		mem[ 3] <= 4'h0;
		mem[ 4] <= 4'h0;
		mem[ 5] <= 4'h0;
		mem[ 6] <= 4'h0;
		mem[ 7] <= 4'h0;
		mem[ 8] <= 4'h0;
		mem[ 9] <= 4'h0;
		mem[10] <= 4'h0;
		mem[11] <= 4'h0;
		mem[12] <= 4'h0;
		mem[13] <= 4'h0;
		mem[14] <= 4'h0;
		mem[15] <= 4'h0;
	end

// Stop Mode
    else if( MOVE_FLG == 1'b0 )begin
        if( PLUS_A == 1'b1 )begin
            if( MEMW_LD == 1'b1 )begin
                mem[MEM_A] <= SUM;
            end
            else begin
                mem[MEM_A] <= mem[MEM_A];
            end
        end
        else begin
            mem[MEM_A] <= mem[MEM_A];
        end
    end

// Moving Mode
    else begin
        if( SEC_SIG == 1'b1 )begin
            if( MEMW_LD == 1'b1 )begin
                mem[MEM_A] <= SUM;
            end
            else begin
                mem[MEM_A] <= mem[MEM_A];
            end
        end
        else begin
            mem[MEM_A] <= mem[MEM_A];
        end
    end
end

//-------------------------------------
//  Memory read data
//-------------------------------------
always@( posedge CLK or negedge RSTN) begin
    if( !RSTN )begin
        MEMIN <= 4'h0;
    end
    else if( MEMR_LD == 1'b1 )begin
        MEMIN <= mem[MEM_A];
    end
    else begin
        MEMIN <= MEMIN;
    end
end

//-------------------------------------
//  OUTport reg LED
//-------------------------------------
always@( posedge CLK or negedge RSTN) begin
    if( !RSTN )begin
        LED_VAL <= 4'd0;
    end
    else if( CPURST == 1'b1 )begin
        LED_VAL <= LED_VAL;
    end

// Stop Mode
    else if( MOVE_FLG == 1'b0 )begin
        if( PLUS_A == 1'b1 )begin
            if( OUT_LD == 1'b1 )begin
                LED_VAL <= SUM;
            end
            else begin
                LED_VAL <= LED_VAL;
            end
        end
        else begin
            LED_VAL <= LED_VAL;
        end
    end

// Moving Mode
    else begin
        if( SEC_SIG == 1'b1 )begin
            if( OUT_LD == 1'b1 )begin
                LED_VAL <= SUM;
            end
            else begin
                LED_VAL <= LED_VAL;
            end
        end
        else begin
            LED_VAL <= LED_VAL;
        end
    end
end


//--- Program ROM Block ---
//  for ROM DATA
/*
i_rom    u_i_rom(
//input
      .address({1'b0,PCNT[3:0]}),
      .clock(CLK),

//output
      .q(MC_CODE)
);
*/

//  for HDL DATA
prg_rom    u_prg_rom(
//input
      .PCNT(PCNT),

//output
      .MC_CODE(MC_CODE)
);


assign Im = MC_CODE[3:0];


//--- Program Dec Block ---
prg_dec    u_prg_dec(
//input
     .MC_CODE(MC_CODE),
     .CARRY(CARRY),
     .R0_REG(R0_REG_VAL),
     .R1_REG(R1_REG_VAL),

//output
     .ALU_SEL(ALU_SEL),
     .R0_LD(R0_LD),
     .R1_LD(R1_LD),
     .MEM_A(MEM_A),
     .MEMW_LD(MEMW_LD),
     .MEMR_LD(MEMR_LD),
     .OUT_LD(OUT_LD),
     .PRG_CNT_LD(PRG_CNT_LD),
     .CARRY_LD(CARRY_LD)
);

//--- ALU Block ---
alu_blk    u_alu_blk(
//input
     .R0_REG(R0_REG_VAL),
     .R1_REG(R1_REG_VAL),
     .Im(Im),
     .IOIN(RSW),
     .MEMIN(MEMIN),
     .ALU_SEL(ALU_SEL),

//output
     .CARRY(CO),
     .SUM(SUM)
);


//-------------------------------------
//  Co 1delay Carryout
//-------------------------------------
always@( posedge CLK or negedge RSTN) begin
    if( !RSTN )begin
        CARRY <= 1'b0;
    end
    else if( CPURST == 1'b1 )begin
        CARRY <= 1'b0;
    end

// Stop Mode
    else if( MOVE_FLG == 1'b0 )begin
        if( PLUS_A == 1'b1 )begin
            if( CARRY_LD == 1'b1 )begin
                CARRY <= CO;
            end
        end
        else begin
            CARRY <= CARRY;
        end
    end

// Moving Mode
    else begin
        if( SEC_SIG == 1'b1 )begin
            if( CARRY_LD == 1'b1 )begin
                CARRY <= CO;
            end
        end
        else begin
            CARRY <= CARRY;
        end
    end
end




assign SEG_D_VAL = Im;
assign SEG_C_VAL = R1_REG_VAL;
assign SEG_B_VAL = R0_REG_VAL;
assign SEG_A_VAL = PCNT;

assign LED[3:0] = LED_VAL;
assign LED[7]   = CARRY;
assign LED[6:4] = 3'b0;

endmodule

