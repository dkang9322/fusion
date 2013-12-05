module hsvReduce(reset, clk,
		 two_pixel_vals, // Input two pixel worth of data
		 two_proc_pixs, // Output pixels
		 switch_vals,
		 switch_sels,
		 change
		 );
   /*
    This function is a wrapper for the colorReduce pixel written by
    Ariana, to be able to colorReduce two pixels in parallel
    
    */
   input reset, clk;
   input [35:0] two_pixel_vals;
   output [35:0] two_proc_pixs;

   input [2:0] 	 switch_vals;
   input [1:0] 	 switch_sels;
   input 	 change;
   

   // Input to colorReduce
   wire [23:0] 	 pix1RGB, pix2RGB;
   
   assign pix1RGB = {two_pixel_vals[17:12], 2'b0, two_pixel_vals[11:6], 2'b0, two_pixel_vals[5:0], 2'b0};
   assign pix2RGB = {two_pixel_vals[17+18:12+18], 2'b0, two_pixel_vals[11+18:6+18], 2'b0, two_pixel_vals[5+18:0+18], 2'b0};

   // Output to colorReduce
   wire [23:0] 	 tRGB1, tRGB2;
   
   colorReduce hsvRed1(pix1RGB, clk, reset, change,
		       switch_sels, switch_vals, tRGB1);

   colorReduce hsvRed2(pix2RGB, clk, reset, change,
		       switch_sels, switch_vals, tRGB2);

   // We really need to change proc_pixs every other clock cycle
   wire [35:0] 	 two_proc_pixs;

   assign two_proc_pixs = {tRGB2[23:18], tRGB2[7:2], tRGB2[15:10], tRGB1[23:18], tRGB1[7:2], tRGB1[15:10]};
   
   /* Switched Green and Blue*/
    /*
   assign two_proc_pixs = {tRGB2[23:18], tRGB2[15:10], tRGB2[7:2], tRGB1[23:18], tRGB1[15:10], tRGB1[7:2]};
    */
     
   
endmodule // hsvReduce
