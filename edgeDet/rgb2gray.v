`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:30:38 11/24/2013 
// Design Name: 
// Module Name:    rgb2gray 
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
module rgb2gray(
    input clock,
    input [0:23] rgb,
    output reg [0:7] gray
    );

wire [7:0] rvalue;
wire [7:0] gvalue;
wire [7:0] bvalue;


//reg [7:0] gb_sum;
//reg [7:0] r_val;

assign rvalue = rgb[16:23];
assign gvalue = rgb[8:15];
assign bvalue = rgb[0:7];

	always @ (posedge clock)
	begin
		//r_val <= (rvalue >> 2);
		//gb_sum <= (gvalue>>1)+(bvalue>>2);
		//gray <= r_val + gb_sum;
		
	
		gray<= (rvalue>>2)+(gvalue>>1)+(bvalue>>2);//Test bvalue with 4
		//http://www.had2know.com/technology/rgb-to-gray-scale-converter.html
		//With RGB as all F's. Output is 255(FFFF)
		
	end
endmodule
