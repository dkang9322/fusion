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

   // Undelayed processed pixels, we need to hold the value
   // for max_hcount - process_latency = 1344 - 24 = 1320
   wire [35:0] 	 two_undel_proc_pixs;

   colWrapper col_abstr(reset, clk, two_pixel_vals,
		       two_undel_proc_pixs,
		       switch_vals, switch_sels, change);
   

   // For delaying by the latency, we use a BRAM
   // We actually need only 1320/2=660 address in BRAM
   // since we're storing two pixels per two-cycles
   parameter LOGSIZE = 10;
   parameter WIDTH = 36;

   // Caution, this might be off, start writing on even hcount
   wire       bram_we = ~hcount[0];

   // So the BRAM structure is as follows
   // It stores the col_proc_pixel as a row
   // On one cycle, it writes the two_pixel_worth data
   // On the other cycle, it reads from location hcount>>1+12
   // Note that end effects are negligible, since we have power_of_2
   // Also, we want to have different addresses for read/write
   wire [LOGSIZE-1:0] bram_writ_addr=hcount>>1;
   wire [LOGSIZE-1:0] bram_read_addr=(hcount>>1)+12;
   wire [LOGSIZE-1:0] bram_addr = bram_we ? bram_writ_addr : bram_read_addr;
   
   // 1024 by 36 bits address delay
   // Higher addresses are mostly junk, and unused
   mybram #(.LOGSIZE(LOGSIZE), .WIDTH(WIDTH)) (bram_addr,
					       clk,
					       two_undel_proc_pixs,
					       two_del_proc_pixs,
					       bram_we);

   //forecast hcount & vcount 8 clock cycles ahead
   //Same as hcount_f/vcount_f in vram_display_module
   wire [10:0] 	 hcount_f = (hcount >= 1048) ? (hcount - 1048) : (hcount + 8);
   wire [9:0] vcount_f = (hcount >= 1048) ? ((vcount == 805) ? 0 : vcount + 1) : vcount;

   assign proc_pix_addr = {vcount_f, hcount_f[9:1]};

endmodule // colProc
