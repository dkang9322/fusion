`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:16:18 11/13/2013 
// Design Name: 
// Module Name:    hsv2rgb 
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
module hsv2rgb(
    input [23:0] tHSV,
    input clk,
    output [23:0] tRGB
    );
	 
	 wire[7:0] H;
	 wire[7:0] S;
	 wire[7:0] V;
	 
	 assign H = tHSV[23:16];
	 assign S = tHSV[15:8];
	 assign V = tHSV[7:0];
	 
	 parameter quad0 = 0;			//0
	 parameter quad1 = 1;			//60
	 parameter quad2 = 2;			//120
	 parameter quad3 = 3;		//180
	 parameter quad4 = 4;		//240
	 parameter quad5 = 5;		//300

   // Should be commented out with Arianas
   //wire [7:0] 	   hQuadrant;
   /* Arianas code without the divider*/
   
    
	 wire [7:0] hQuadrant1;
	 wire [7:0] hOffset;
	 
	 assign hQuadrant1 = (H*6)/256;
   

      // Should be commented out with Arianas
   /*
   n_divider hue_div1(
		.clk(clk),
		.dividend(H),
		.divisor(43),
		.quotient(hQuadrant),
	        // note: the "fractional" output was originally named "remainder" in this
		// file -- it seems coregen will name this output "fractional" even if
		// you didn't select the remainder type as fractional.
		.fractional(hOffset),
		.rfd(s_rfd)
		);
    */
	 
	 wire [7:0] P;
	 wire [7:0] Q;
	 wire [7:0] T;

   /* Arianas code without the divider */

	 wire [15:0] hFract1;
	 wire [15:0] hFract2;
	 wire [7:0] hFract3;
	 assign hFract1 = H*6;
	 assign hFract2 = hFract1<<8;
	 assign hFract3 = hFract2[15:8];

	 
	 
	 assign P = (V * (255-S))/256;
   
   /* Arianas code without the divider */

    	 assign Q = (V * (255-(S*hFract3/256)))/256;
	 assign T = (V * (255-(S*(255-hFract3))/256))/256;


	 reg[7:0] tR;
	 reg[7:0] tG;
	 reg[7:0] tB;
	 
	 always @(posedge clk) begin
		if(S == 0) begin
			tR <= V;
			tG <= V;
			tB <= V;
		end
		else begin
		      /* Arianas code without the divider */
		   case(hQuadrant1)

				quad0: begin
					tR <= V;
					tG <= T;
					tB <= P;
				end
				quad1: begin
					tR <= Q;
					tG <= V;
					tB <= P;
				end
				quad2: begin
					tR <= P;
					tG <= V;
					tB <= T;
				end
				quad3: begin
					tR <= P;
					tG <= Q;
					tB <= V;
				end
				quad4: begin
					tR <= T;
					tG <= P;
					tB <= V;
				end
				quad5: begin
					tR <= V;
					tG <= P;
					tB <= Q;
				end
				default: begin
					tR <= 0;
					tG <= 0;
					tB <= 0;
				end
			endcase
		end
	end
	assign tRGB = {tR,tB,tG};


endmodule
