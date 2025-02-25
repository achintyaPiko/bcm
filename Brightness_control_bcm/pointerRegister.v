`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:05:00 02/19/2025 
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
module pointerRegister(
    input operation_dn,
    output reg [6:0] address
    );

	initial address = 7'd0;
	always@(posedge operation_dn)
		address <= address + 7'b0000001;

endmodule
