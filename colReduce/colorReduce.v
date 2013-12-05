`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:17 11/20/2013 
// Design Name: 
// Module Name:    colorReduce 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module colorReduce(
    input [23:0] RGB,
	 input clk,
	 input reset,
	 input select,
	 input [1:0]selector,
	 input [2:0] inputVal,
    output [23:0] tRGB
    );
	 
	 wire [7:0] R;
	 wire [7:0] G;
	 wire [7:0] B;
	 
	 assign R = RGB[23:16];
	 assign G = RGB[15:8];
	 assign B = RGB[7:0];
	 
	 wire [7:0] H;
	 wire [7:0] S;
	 wire [7:0] V;
	 wire [23:0] HSV;
	 wire [23:0] tHSV;
	 wire [7:0] hThreshold;
	 wire [7:0] sThreshold;
	 wire [7:0] vThreshold;

//  for initial testing, don't bother with inputs	 
	 reductionThresholds reductionThresholds1(
		.clk(clk), 
		.reset(reset), 
		.select(select), 
		.selector(selector), 
		.inputVal(inputVal), 
		.hThreshold(hThreshold), 
		.sThreshold(sThreshold), 
		.vThreshold(vThreshold)
		);

	 //comment out when using user inputs
	 //assign hThreshold = 8'b11110000;
//	 assign sThreshold = 8'b11100000;
//	 assign vThreshold = 8'b11100000;
	 
	 //convert rgb to hsv
	 rgb2hsv rgb2hsv1(
		.clock(clk), 
		.reset(reset), 
		.r(R), 
		.g(G), 
		.b(B), 
		.h(H), 
		.s(S), 
		.v(V)
	 );
	 
	 assign HSV = {H,S,V};
	 
	 //the color masking takes place here
	 colorReduction colorReduction1(
		.HSV(HSV), 
		.clk(clk), 
		.hThreshold(hThreshold), 
		.sThreshold(sThreshold), 
		.vThreshold(vThreshold), 
		.tHSV(tHSV)
	 );
	 
	 //convert hsv back to rgb
	 hsv2rgb hsv2rgb1(
		.tHSV(tHSV), 
		.clk(clk), 
		.tRGB(tRGB)
	 );


endmodule
