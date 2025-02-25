`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:41:29 02/19/2025 
// Design Name: 
// Module Name:    pointerRegister 
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
module pointerRegister(clk,rst_n,address);
	 
	input clk,rst_n;
	output reg [7:0] address;
	
	
	initial address = 8'd0;
	
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			address = 8'd0;
		else
			address = address + 1'b1;
	end	


endmodule
