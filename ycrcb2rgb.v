/**************************************************************************
 ** 
 ** Module: ycrcb2rgb
 **
 ** Generic Equations:
 *  R’ = 1.164 ( Y’ – 64 ) + 1.596 ( Cr – 512 )
    G' = 1.164 ( Y' – 64 ) – ( 0.813 ) ( Cr – 512 ) – 0.392 ( Cb – 512 )
    B' = 1.164 ( Y' – 64 ) + 2.017 ( Cb – 512 )
 ***************************************************************************/

module YCrCb2RGB ( R, G, B, clk, rst, Y, Cr, Cb );

   output [7:0]  R, G, B;

   input 	 clk,rst;
   input [9:0] 	 Y, Cr, Cb;

   wire [7:0] 	 R,G,B;
   reg [20:0] 	 R_int,G_int,B_int,X_int,A_int,B1_int,B2_int,C_int; 
   reg [9:0] 	 const1,const2,const3,const4,const5;
   reg [9:0] 	 Y_reg, Cr_reg, Cb_reg;
   
   //registering constants
   always @ (posedge clk)
     begin
	const1 = 10'b 0100101010; //1.164 = 01.00101010
	const2 = 10'b 0110011000; //1.596 = 01.10011000
	const3 = 10'b 0011010000; //0.813 = 00.11010000
	const4 = 10'b 0001100100; //0.392 = 00.01100100
	const5 = 10'b 1000000100; //2.017 = 10.00000100
     end

   always @ (posedge clk or posedge rst)
     if (rst)
       begin
	  Y_reg <= 0; Cr_reg <= 0; Cb_reg <= 0;
       end
     else  
       begin
	  Y_reg <= Y; Cr_reg <= Cr; Cb_reg <= Cb;
       end

   always @ (posedge clk or posedge rst)
     if (rst)
       begin
	  A_int <= 0; B1_int <= 0; B2_int <= 0; C_int <= 0; X_int <= 0;
       end
     else  
       begin
	  X_int <= (const1 * (Y_reg - 'd64)) ;
	  A_int <= (const2 * (Cr_reg - 'd512));
	  B1_int <= (const3 * (Cr_reg - 'd512));
	  B2_int <= (const4 * (Cb_reg - 'd512));
	  C_int <= (const5 * (Cb_reg - 'd512));
       end

   always @ (posedge clk or posedge rst)
     if (rst)
       begin
	  R_int <= 0; G_int <= 0; B_int <= 0;
       end
     else  
       begin
	  R_int <= X_int + A_int;  
	  G_int <= X_int - B1_int - B2_int; 
	  B_int <= X_int + C_int; 
       end
   

   /* limit output to 0 - 4095, <0 equals o and >4095 equals 4095*/

   assign R = (R_int[20]) ? 0 : (R_int[19:18] == 2'b0) ? R_int[17:10] : 8'b11111111;
   assign G = (G_int[20]) ? 0 : (G_int[19:18] == 2'b0) ? G_int[17:10] : 8'b11111111;
   assign B = (B_int[20]) ? 0 : (B_int[19:18] == 2'b0) ? B_int[17:10] : 8'b11111111;

endmodule


/*
//Unused Module
//Was developing, then found above code
module ycrcb_rgb(ycrcb, rgb, clk, reset);
   /*
    This module takes in the ycrcb values and gives
    out truncated rgb values (taking 6 MSB for each r,g,b)
    
    Algorithm: Y', Cr, Cb are 10 bit inputs
    
    Gotten from sample implementation
    (a_i are positive(toadd), b_i are negative)
    a1= 1.164 = 01.00101010
    a2 = 1.596 = 01.10011000
    b1 = 0.813 = 00.11010000
    b2 = 0.392 = 00.01100100
    a3 = 2.017 = 10.00000100
    
    R’ = 1.164 ( Y’ – 64 ) + 1.596 ( Cr – 512 )
    G' = 1.164 ( Y' – 64 ) – ( 0.813 ) ( Cr – 512 ) – 0.392 ( Cb – 512 )
    B' = 1.164 ( Y' – 64 ) + 2.017 ( Cb – 512 )

    To calculate decimals we do 2^8 scale up
    */
/*
   input clk;
   input reset;
   
   input [29:0] ycrcb;
   output [17:0] rgb;

   parameter a1 = 10'b0100101010;
   parameter a2 = 10'b0110011000;
   parameter a3 = 10'b1000000100;
   parameter b1 = 10'b0011010000;
   parameter b2 = 10'b0001100100;


endmodule // ycrcb_rgb*/