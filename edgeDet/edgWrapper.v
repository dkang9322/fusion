module edgWrapper(reset, clk,
		  two_pixel_vals,
		  two_proc_pixs,
		  hcount,
		  gs_switch,
		  edg_sel
		  );
   /*
    This function is a wrapper for the edgeDetect pixel written by
    Tarun, to be able to edgeDetect two pixels in cascade
    */
   input reset, clk;
   input [35:0] two_pixel_vals;
   output [35:0] two_proc_pixs;


   input [10:0]  hcount;
   input 	 gs_switch; //True if we want to display grayscale data
   output 	 edg_sel; //Edge Selector
   
   //Input to edgedetection
   wire [23:0] 	 pix1RGB, pix2RGB;
   
   assign pix1RGB = {two_pixel_vals[17:12], 2'b0, two_pixel_vals[11:6], 2'b0, two_pixel_vals[5:0], 2'b0};
   assign pix2RGB = {two_pixel_vals[17+18:12+18], 2'b0, two_pixel_vals[11+18:6+18], 2'b0, two_pixel_vals[5+18:0+18], 2'b0};

   //Outputs of edgedetection
   wire [23:0] 	 edgRGB;
   wire 	 edg_sel;

   /* Various Test Comments for Switching Order of pixel passing *
   /*
    first RGb -> lower pixels
    lower pixels go to shift_register on hcount[0] == 0
    We have two degrees of freedom hcount[0] =0,1 in edgedetection.v
    and counter in edgWrapper.v

    Switching of pix1RGB, pix2RGB order does not affect output of system
    Original Pixel Passing, lower pixels, then higher
    All sort of image defragmentation happened
   */
   edgedetection edgDetect(reset, clk, pix1RGB, pix2RGB, hcount,
			   edgRGB, edg_sel, gs_switch);

   
   /* All under the assumption that we get an edge output
    every clock cycle

    We want to hold our output, two_proc_pixs, for two clock cycles
    since we want to output two NEW pixel data every two clock cycles
    */
   parameter DELAY = 2;
   parameter EDG_BUF = DELAY * 24 - 1;
   
   reg [EDG_BUF:0] 	 del_edgRGB;
   reg 			 counter; 
   // For outputting processed pixels every other cycle
   
   
   /* This is where we store the edgRGB values*/
   always @(posedge clk)
     begin
	del_edgRGB <= {del_edgRGB[EDG_BUF-24:0], edgRGB};

     end

   /*  This is where we output the processed pixels*/
   // Outputting proc_pixels counter = 0, which we're assuming to be
   // such when two pixels are finished processing
   wire [35:0] trunc_pixels;
   assign trunc_pixels = {del_edgRGB[47:42], del_edgRGB[39:34], del_edgRGB[31:26], del_edgRGB[23:18], del_edgRGB[15:10], del_edgRGB[7:2]};
   
   assign two_proc_pixs = hcount[0] ? two_proc_pixs:trunc_pixels;

endmodule // edgWrapper

     

