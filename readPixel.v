module readPix(reset, clk,
	       hcount, vcount, // Used for write_addr1
	       two_pixel_data, // Data output
	       vram_read_data, // Physical data from ZBT bank 0
	       write_addr1
	       );
   input reset, clk;
   input [10:0] hcount;
   input [9:0] 	vcount;
   output [35:0] two_pixel_data;
   output [18:0] write_addr1; // done
   input [35:0]  vram_read_data;

   // Address to read from ZBT bank 0
   wire [18:0] 	 vram_addr;
   
   // Same code from vram_display
   //forecast hcount & vcount 8 clock cycles ahead to get data from ZBT
   wire [10:0] hcount_f = (hcount >= 1048) ? (hcount - 1048) : (hcount + 8);
   wire [9:0] vcount_f = (hcount >= 1048) ? ((vcount == 805) ? 0 : vcount + 1) : vcount;

   // Change of address scheme to compensate for reading color
   assign vram_addr = {vcount_f, hcount_f[9:1]};


   // Unlike naive initial thought that no data needs to be latched,
   // maybe latching data helps
   wire       hc2 = hcount[0];
   reg [35:0] vr_data_latched;
   reg [35:0] last_vr_data;

   always @(posedge clk)
     last_vr_data <= (hc2 == 1'd1) ? vr_data_latched : last_vr_data;

   always @(posedge clk)
     vr_data_latched <= (hc2 ==1'd0) ? vram_read_data : vr_data_latched;

   // Address to write to ZBT bank 1 is the same address
   wire [18:0] write_addr1 = vram_addr;
   wire [35:0] two_pixel_data = last_vr_data;

endmodule // readPix

