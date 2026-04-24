`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 14:13:05
// Design Name: 
// Module Name: mul_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mul_unit (
   input  wire              clk,
   input  wire signed [10:0] A,
   input  wire signed [10:0] B,
   output reg  signed [10:0] result,
   output reg               overflow
);

   reg signed [21:0] mult_full;

   always @(posedge clk) begin
       mult_full = A * B;
       result    <= mult_full[10:0];
       overflow  <= (mult_full > 22'sd1023) || (mult_full < -22'sd1024);
   end

endmodule
