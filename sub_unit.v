`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 14:03:50
// Design Name: 
// Module Name: sub_unit
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

module sub_unit (
   input  wire              clk,
   input  wire signed [10:0] A,
   input  wire signed [10:0] B,
   output reg  signed [10:0] result,
   output reg               overflow
);

   reg signed [11:0] diff_ext;

   always @(posedge clk) begin
       diff_ext  = A - B;
       result    <= diff_ext[10:0];
       overflow  <= (diff_ext > 12'sd1023) || (diff_ext < -12'sd1024);
   end

endmodule