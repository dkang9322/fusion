`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:40:57 11/13/2013 
// Design Name: 
// Module Name:    colorReduction 
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
module colorReduction(
    input [23:0] HSV,
    input clk,
    input [7:0] hThreshold,
    input [7:0] sThreshold,
    input [7:0] vThreshold,
    output [23:0] tHSV
    );
	 
	 wire [7:0] H;
	 wire [7:0] S;
	 wire [7:0] V;
	 
	 assign H = HSV[23:16];
	 assign S = HSV[15:8];
	 assign V = HSV[7:0];
	 
	 reg[7:0] tH;
	 reg[7:0] tS;
	 reg[7:0] tV;
	 
	 always @(posedge clk) begin
		tH <= H&hThreshold;
		tS <= S&sThreshold;
		tV <= V&vThreshold;
	 end
	 
	 assign tHSV = {tH, tS, tV};


endmodule
