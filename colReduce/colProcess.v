module colProc(reset, clk,
	       hcount, vcount, // Not used in processing for now
	       two_pixel_vals, // Data Input to be processed
	       write_addr, //Data Address to write in ZBT bank 1
	       two_proc_pixs, // Processed Pixel
	       proc_pix_addr,
	       switch_vals, // switches to choose num_shifts
	       switch_sels, // switches to choose HSV
	       change //Button to re-write color
	       );
   input reset, clk;
   input [10:0] hcount;
   input [9:0] 	vcount;
   input [35:0] two_pixel_vals;
   input [18:0] write_addr; 
   output [35:0] two_proc_pixs;
   output [18:0] proc_pix_addr;

   input [2:0] 	 switch_vals;
   input [1:0] 	 switch_sels;
   input 	 change;
   
   
   // Two Outputs of this module
   wire [35:0] 	 two_proc_pixs;
   wire [18:0] 	 proc_pix_addr;

   colWrapper col_abstr(reset, clk, two_pixel_vals,
		       two_proc_pixs,
		       switch_vals, switch_sels, change);
   
   //forecast hcount & vcount 8 clock cycles ahead
   //Same as hcount_f/vcount_f in vram_display_module
   wire [10:0] 	 hcount_f = (hcount >= 1048) ? (hcount - 1048) : (hcount + 8);
   wire [9:0] vcount_f = (hcount >= 1048) ? ((vcount == 805) ? 0 : vcount + 1) : vcount;

   
   assign proc_pix_addr = {vcount_f, hcount_f[9:1]};

endmodule // colProc
