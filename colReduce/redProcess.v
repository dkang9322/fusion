module pixProc(reset, clk,
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
   
   

   wire [35:0] 	 two_proc_pixs;
   

   // Removing THREE LSBs
   parameter R_MASK = 6'b110000;
   parameter G_MASK = 6'b111000;
   parameter B_MASK = 6'b110000;

   // We want to clock our processing
   //reg [35:0] 	 two_proc_pixs;
   reg [18:0] 	 proc_pix_addr;

   // Note actually delay is half of DELAY
   parameter DELAY = 80;
   parameter ADD_DEL = 19 * DELAY - 1;
   parameter DAT_DEL = 36 * DELAY - 1;
   

   reg [ADD_DEL:0] addr_del;
   reg [DAT_DEL:0] dat_del;

   hsvReduce hsv_abstr(reset, clk, dat_del[DAT_DEL:DAT_DEL-35],
		       two_proc_pixs,
		       switch_vals, switch_sels, change);
   
   
   
   // Simply RGB Thresholding
   always @(posedge clk)
     begin
	dat_del <= {dat_del[DAT_DEL - 36:0], two_pixel_vals};
	
	//two_proc_pixs <= dat_del[DAT_DEL:DAT_DEL-35] & {R_MASK, G_MASK, B_MASK,R_MASK, G_MASK, B_MASK};
	
	// Let's see what happens if we delay write_addr by more than appropriate
	addr_del <= {addr_del[ADD_DEL-19:0], write_addr};
	proc_pix_addr <= addr_del[ADD_DEL:ADD_DEL-18];
     end
   
endmodule // pixProc
