`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 14:24:40
// Design Name: 
// Module Name: divd_unit
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

module divd_unit (
   input  wire              clk,
   input  wire signed [10:0] A,
   input  wire signed [10:0] B,
   output reg  signed [10:0] result,
   output reg               div_by_zero
);
   always @(posedge clk) begin
       if (B == 0) begin
           result      <= 11'sd0;
           div_by_zero <= 1'b1;
       end
       else begin
           result      <= A / B;
           div_by_zero <= 1'b0;
       end
   end
endmodule