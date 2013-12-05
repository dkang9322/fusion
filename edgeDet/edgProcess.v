module edgProc(reset, clk,
	       hcount, vcount, // Not used in processing for now
	       two_pixel_vals, // Data Input to be processed
	       write_addr, //Data Address to write in ZBT bank 1
	       two_proc_pixs, // Processed Pixel
	       proc_pix_addr,
	       gs_switch,
	       edg_sel
	       );
   input reset, clk;
   input [10:0] hcount;
   input [9:0] 	vcount;
   input [35:0] two_pixel_vals;
   input [18:0] write_addr; 
   output [35:0] two_proc_pixs;
   output [18:0] proc_pix_addr;
   input 	 gs_switch; //switch[4], true if we want grayscale
   output 	 edg_sel; //Sobel Operator edgeSelect Output
   
   
   // Three Outputs of this module
   wire [35:0] 	 two_proc_pixs;
   wire [18:0] 	 proc_pix_addr;
   wire 	 edg_sel;
   


   edgWrapper edg_abstr(reset, clk, two_pixel_vals,
			two_proc_pixs, hcount, gs_switch,
			edg_sel);
   
   //forecast hcount & vcount 8 clock cycles ahead
   //Same as hcount_f/vcount_f in vram_display_module
   wire [10:0] 	 hcount_f = (hcount >= 1048) ? (hcount - 1048) : (hcount + 8);
   wire [9:0] vcount_f = (hcount >= 1048) ? ((vcount == 805) ? 0 : vcount + 1) : vcount;

   
   assign proc_pix_addr = {vcount_f, hcount_f[9:1]};
   
   
endmodule // edgProc
