`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 14:17:04
// Design Name: 
// Module Name: add_unit
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
module add_unit (
   input  wire              clk,
   input  wire signed [10:0] A,
   input  wire signed [10:0] B,
   output reg  signed [10:0] result,
   output reg               overflow
);

   reg signed [11:0] sum_ext;

   always @(posedge clk) begin
       sum_ext   = A + B;
       result    <= sum_ext[10:0];
       overflow  <= (sum_ext > 12'sd1023) || (sum_ext < -12'sd1024);
   end

endmodule
