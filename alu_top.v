`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 14:14:31
// Design Name: 
// Module Name: alu_top
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

module alu_top (
   input  wire              clk,
   input  wire signed [10:0] A,
   input  wire signed [10:0] B,
   input  wire [1:0]        mode,   // 00 add, 01 sub, 10 div, 11 mul
   output reg  signed [10:0] result,
   output reg               overflow,
   output reg               div_by_zero
);

   wire signed [10:0] add_result;
   wire signed [10:0] sub_result;
   wire signed [10:0] mul_result;
   wire signed [10:0] div_result;

   wire add_overflow;
   wire sub_overflow;
   wire mul_overflow;
   wire div_zero;

   add_unit u_add (
       .clk(clk),
       .A(A),
       .B(B),
       .result(add_result),
       .overflow(add_overflow)
   );

   sub_unit u_sub (
       .clk(clk),
       .A(A),
       .B(B),
       .result(sub_result),
       .overflow(sub_overflow)
   );

   mul_unit u_mul (
       .clk(clk),
       .A(A),
       .B(B),
       .result(mul_result),
       .overflow(mul_overflow)
   );
   
   divd_unit u_div (
       .clk(clk),
       .A(A),
       .B(B),
       .result(div_result),
       .div_by_zero(div_zero)
   ); 

  

   always @(posedge clk) begin
       case (mode)
           2'b00: begin
               result      <= add_result;
               overflow    <= add_overflow;
               div_by_zero <= 1'b0;
           end

           2'b01: begin
               result      <= sub_result;
               overflow    <= sub_overflow;
               div_by_zero <= 1'b0;
           end

           2'b10: begin
               result      <= div_result;
               overflow    <= 1'b0;
               div_by_zero <= div_zero;
           end

           2'b11: begin
               result      <= mul_result;
               overflow    <= mul_overflow;
               div_by_zero <= 1'b0;
           end

           default: begin
               result      <= 11'sd0;
               overflow    <= 1'b0;
               div_by_zero <= 1'b0;
           end
       endcase
   end

endmodule

