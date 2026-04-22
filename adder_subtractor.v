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
   input  wire signed [10:0] A,
   input  wire signed [10:0] B,
   input  wire [1:0]        mode,   // 00=ADD, 01=SUB, 10=DIV, 11=MUL
   output reg  signed [10:0] result,
   output reg               overflow,
   output reg               div_by_zero
);

   reg signed [21:0] mult_full;

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
                   result = mult_full[10:0];
               end
           end

           // -------------- DEFAULT --------------
           default: begin
               result = 10'sd0;
           end

       endcase
   end

endmodule

// ============================================================
// Module  : seven_seg_display
// Purpose : Display signed 11-bit value on 4-digit 7-seg (Basys 3)
//
// Display format:
//   [DIG3] [DIG2] [DIG1] [DIG0]
//     -      H      T      O
//
// - Handles signed numbers correctly
// - Extracts digits from absolute value
// - Displays '-' on leftmost digit if value < 0
// ============================================================

module seven_seg_display (
    input  wire        clk,
    input  wire signed [10:0] value,   // signed result to display
    output reg  [6:0]  seg,             // segment outputs (active low)
    output reg  [3:0]  an               // anode control (active low)
);

    // --------------------------------------------------------
    // Clock divider for multiplexing
    // --------------------------------------------------------
    reg [15:0] refresh_cnt = 0;
    reg [1:0]  digit_sel   = 0;

    always @(posedge clk) begin
        refresh_cnt <= refresh_cnt + 1;
        digit_sel   <= refresh_cnt[15:14];
    end

    // --------------------------------------------------------
    // Absolute value handling (CRITICAL FIX)
    // --------------------------------------------------------
    reg signed [10:0] abs_val;
    reg is_negative;

    always @(*) begin
        if (value < 0) begin
            abs_val     = -value;
            is_negative = 1'b1;
        end else begin
            abs_val     = value;
            is_negative = 1'b0;
        end
    end

    // --------------------------------------------------------
    // Digit extraction (unsigned only!)
    // --------------------------------------------------------
    reg [3:0] digit;

    wire [3:0] ones     =  abs_val % 10;
    wire [3:0] tens     = (abs_val / 10)  % 10;
    wire [3:0] hundreds = (abs_val / 100) % 10;

    always @(*) begin
        an = 4'b1111;         // default all digits off

        case (digit_sel)
            2'b00: begin
                an    = 4'b1110;  // rightmost digit
                digit = ones;
            end
            2'b01: begin
                an    = 4'b1101;
                digit = tens;
            end
            2'b10: begin
                an    = 4'b1011;
                digit = hundreds;
            end
            2'b11: begin
                an = 4'b0111;     // leftmost digit
                if (is_negative)
                    digit = 4'hA; // minus sign
                else
                    digit = 4'hF; // blank
            end
        endcase
    end

    // --------------------------------------------------------
    // 7-segment decoder (Basys 3, active low)
    // --------------------------------------------------------
    always @(*) begin
        case (digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            4'hA: seg = 7'b0111111; // '-' minus sign
            default: seg = 7'b1111111; // blank
        endcase
    end

endmodule
