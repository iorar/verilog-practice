/*------------------------------------------------------------------------------
--      File Name = test_cpu4bit.v                                            --
--                                                                            --
--      v1.1        2.21.12.20 ktakagi                                        --
------------------------------------------------------------------------------*/
`timescale 1 ns/ 1 ps

module test_cpu4bit ();

reg CLK;
reg RSTN;
reg SEC_SIG;

reg [2:0] PSW_SIG;
reg [3:0] RSW;

wire [7:0] LED_OUT;
wire [3:0] SEG_A_VAL;
wire [3:0] SEG_B_VAL;
wire [3:0] SEG_C_VAL;
wire [3:0] SEG_D_VAL;

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


always begin
    #2.5 CLK = ~CLK;
end

always begin
    #5 SEC_SIG = ~SEC_SIG;
end

initial begin
    CLK = 1; RSTN = 1; SEC_SIG = 1;
    PSW_SIG = 3'b000;
    RSW = 0;

    // reset
    #25 RSTN = 0;
    #10 RSTN = 1;

    // start @50
    #15 PSW_SIG[1] = 1;
    #5 PSW_SIG[1] = 0;

    #300 $finish;
end

endmodule