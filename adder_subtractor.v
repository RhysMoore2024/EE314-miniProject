// ============================================================
// Module  : adder_subtractor_divider
// Purpose : 10-bit signed add / subtract / divide / multiply
//
// mode:
// 00 -> Add
// 01 -> Subtract
// 10 -> Divide
// 11 -> Multiply
//
// Notes:
// - 10-bit signed range is -512 to +511
// - Multiply uses a 20-bit temporary result
// - overflow is used for add/subtract/multiply
// - div_by_zero is used for divide
// ============================================================

module adder_subtractor_divider (
   input  wire signed [9:0] A,
   input  wire signed [9:0] B,
   input  wire [1:0]        mode,   // 00=ADD, 01=SUB, 10=DIV, 11=MUL
   output reg  signed [9:0] result,
   output reg               overflow,
   output reg               div_by_zero
);

   reg signed [19:0] mult_full;

   always @(*) begin
       result      = 10'sd0;
       overflow    = 1'b0;
       div_by_zero = 1'b0;
       mult_full   = 20'sd0;

       case (mode)

           // ---------------- ADD ----------------
           2'b00: begin
               result   = A + B;
               overflow = (~A[9] & ~B[9] &  result[9]) |
                          ( A[9] &  B[9] & ~result[9]);
           end

           // ---------------- SUB ----------------
           2'b01: begin
               result   = A - B;
               overflow = (~A[9] &  B[9] &  result[9]) |
                          ( A[9] & ~B[9] & ~result[9]);
           end

           // ---------------- DIV ----------------
           2'b10: begin
               if (B == 10'sd0) begin
                   result      = 10'sd0;
                   div_by_zero = 1'b1;
               end
               else begin
                   result = A / B;   // signed integer division
               end
           end

           // ---------------- MUL ----------------
           2'b11: begin
               mult_full = A * B;

               // Check whether 20-bit result fits in signed 10-bit range
               // Valid sign-extension means bits [19:10] must all equal bit [9]
               if (mult_full[19:10] != {10{mult_full[9]}}) begin
                   overflow = 1'b1;
                   result   = mult_full[9:0];   // truncated result
               end
               else begin
                   result = mult_full[9:0];
               end
           end

           // -------------- DEFAULT --------------
           default: begin
               result = 10'sd0;
           end

       endcase
   end

endmodule
