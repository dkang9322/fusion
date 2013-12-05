`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:39:44 11/20/2013 
// Design Name: 
// Module Name:    sobel 
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
module sobel(clock,z0,z1,z2,z3,z4,z5,z6,z7,z8,switch,edge_out);
   input clock;
   input [7:0] z0,z1,z2,z3,z4,z5,z6,z7,z8;
   input       switch;
   output [7:0] edge_out;
   
   reg signed [10:0] Gx;  //Result of mask+differentiation in x
   reg signed [10:0] Gy;  //Result of mask+differentiation in y
   reg signed [10:0] abs_Gx;
   reg signed [10:0] abs_Gy;

   
   reg [10:0] 	     sum; 
   
   always @ (posedge clock)
     begin
	Gx<=((z2-z0)+((z5-z3)<<1)+(z8-z6)); //masking in x direction
	Gy<=((z0-z6)+((z1-z7)<<1)+(z2-z8)); //masking in y direction
	abs_Gx <= (Gx[10]?~Gx+1:Gx);//if negative, then invert and add  to make pos.
	abs_Gy <= (Gy[10]?~Gy+1:Gy);//if negative, then invert and add  to make pos.
	sum <=abs_Gx+abs_Gy;
	
	//Yet to Apply Threshold
	//Threshold-

     end // always @ (posedge clock)
   
   assign edge_out =(sum > 160) ? 0 : 8'hff;

   // Below gives inversion of what we want
   // Below is visually more pleasing, when debugging
   // To be consistent with selectbit, we need above
   //assign edge_out =(sum > 160) ? 8'hff : 0;

   // 80 gives out lots of white output
   //assign edge_out =(sum > 80) ? 8'hff : 0;

   // 120 threshold gives lesser white output
   //assign edge_out =(sum > 120) ? 8'hff : 0;

   
endmodule
