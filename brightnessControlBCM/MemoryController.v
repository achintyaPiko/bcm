`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:47:31 02/19/2025 
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
    input uart_flag,
    input clk,
    input [7:0] uart_op_buffer,
	 output memory_access_performed, //acts as a clk for the address counter. increments at 2 sequence accesses
	 input [5:0] dataPointer, //gives a offset pointer from start bound and end bound
    input read, //read operation is 1, idle operation is 0
	 input cleanReset
	 ); 
	 
	 //the controller will put data into correct sections when it see it has arrived 
	 //if data is needed it will give it too otherwise it remains idle
	 
	 parameter idle = 2'b00;
	 parameter read_uart_for_command = 2'b01;//when flag observed
	 parameter start_reading_for_data = 2'b10;
	 
	 wire RAM_rst;
	 
	 initial begin
		cleanReset = 0;
	 end
	 
	 always@(posedge cleanReset) begin
	 
		RAM_rst <= 1;
		
	 
	 end
	 
	 RAM_core your_instance_name (
		  .clka(clk), // input clka
		  .rsta(rsta), // input rsta
		  .wea(wea), // input [0 : 0] wea
		  .addra(addra), // input [6 : 0] addra
		  .dina(dina), // input [63 : 0] dina
		  .douta(douta) // output [63 : 0] douta
	 );
	
		
	
	

endmodule
