`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:58:44 02/19/2025 
// Design Name: 
// Module Name:    MemoryController 
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
module MemoryController(
    output [63:0] R1,R2,
    output [63:0] G1,G2,
    output [63:0] B1,B2,
    input d_rdy_flag,
    input clk,
    input [7:0] uart_op_buffer,
	 output memory_access_performed,
	 input [6:0] dataPointer
    ); 


endmodule
