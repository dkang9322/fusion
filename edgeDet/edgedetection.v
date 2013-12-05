`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:56:14 11/26/2013 
// Design Name: 
// Module Name:    edgedetection 
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

module edgedetection(
		     input 	   reset,
		     input 	   clock,
		     input [23:0]  rgb, // This corresponds to the lower_pixels in ZBT [ZBT[17:0]]
		     input [23:0]  rgb1, // This corresponds to the higher_pixels in ZBT
		     input [10:0]  hcount,
		     output [23:0] edgeoutputsel,
		     output 	   select,
		     input grayscale
		     );

   // Intermediate grayscale outputs that will be multiplexed
   // and passed into the shift register
   wire [7:0] 	  grayout, grayout1;
   wire [7:0] 	  sr_grayout;
   

   wire [71:0] 	   matrixout;
   wire 	   swi = 0;
   wire [7:0] 	   edgeoutputsobel;


   //--------------------------------------------------------------------------------
   // Grayscale Module: Parallel Calculation of Two Pixels at a time
   //--------------------------------------------------------------------------------
   rgb2gray converter(clock,rgb,grayout);
   rgb2gray converter2(clock, rgb1, grayout1);

   assign sr_grayout = hcount[0] ? grayout : grayout1;

   shiftregister #(.cols(1344)) shifter(clock,hcount,sr_grayout,matrixout);
   wire [7:0] 	   shifted_gs = matrixout[23:16];

   //--------------------------------------------------------------------------------
   // Sobel Module
   //--------------------------------------------------------------------------------
   wire [7:0] 	   sobel_out;
   sobel edgedetect(clock,matrixout[71:64],matrixout[63:56],
		    matrixout[55:48],matrixout[47:40],matrixout[39:32],
		    matrixout[31:24],matrixout[23:16],matrixout[15:8],
		    matrixout[7:0],swi,sobel_out);

   

   
   //--------------------------------------------------------------------------------
   // SelectBit Generation
   //--------------------------------------------------------------------------------
   wire [23:0] 	   sobel_rgb;
   
   selectbit selector(clock, sobel_out, sobel_rgb, select);

   assign  edgeoutputsel = grayscale ? {shifted_gs, shifted_gs, shifted_gs} :~sobel_rgb;
   // To be visually pleasant, let's display the inversion of actual
   

endmodule
