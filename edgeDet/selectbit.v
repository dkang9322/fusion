`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:40:26 11/26/2013 
// Design Name: 
// Module Name:    selectbit 
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
module selectbit(
		 input 	       clock,
		 input [7:0]   edgein,
		 output [23:0] edgeout,
		 output reg    select
		 );

   always @ (posedge clock)
     begin
	if(edgein==8'hFF)
	  select<=0;
	else
	  select<=1;
     end

   assign edgeout = {edgein,edgein,edgein};
endmodule
