`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:51:19 11/13/2013 
// Design Name: 
// Module Name:    reductionThresholds 
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
module reductionThresholds(
	 input clk,
	 input reset,
	 input select,
    input [1:0] selector, // Selecting H/S/V to change, switch[1:0]
    input [2:0] inputVal, // Selecting number of shifts to the left
    output reg [7:0] hThreshold,
    output reg [7:0] sThreshold,
    output reg [7:0] vThreshold
    );
	 
	 parameter hue 			= 2'b00;
	 parameter saturation 	= 2'b01;
	 parameter value	 		= 2'b10;
		
	 
	 wire[7:0] ones = 8'b11111111;
	 wire[2:0] shift;
	 wire[7:0] threshold;
	 assign shift = 7-inputVal;
	 assign threshold = ones<<shift;
	 
	 
	 always @(posedge clk) begin
		if (reset) begin
			hThreshold <= 8'b11100000;
			sThreshold <= 8'b11000000;
			vThreshold <= 8'b11000000;
		end
		if (select) begin
			case(selector)
				hue: 			hThreshold <= threshold;
				saturation:	sThreshold <= threshold;
				value: 		vThreshold <= threshold;
				default: 	hThreshold <= 8'b11100000;
			endcase
		end
	end


endmodule
