`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2026 14:05:01
// Design Name: 
// Module Name: seven_seg_display
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


module seven_seg_display (
   input  wire              clk,
   input  wire signed [10:0] value,
   output reg  [6:0]        seg,
   output reg  [3:0]        an
);

   reg [15:0] refresh_cnt = 16'd0;
   reg [1:0]  digit_sel   = 2'd0;

   reg signed [10:0] abs_val = 11'sd0;
   reg               is_negative = 1'b0;

   reg [3:0] ones     = 4'd0;
   reg [3:0] tens     = 4'd0;
   reg [3:0] hundreds = 4'd0;
   reg [3:0] digit    = 4'hF;

   always @(posedge clk) begin
       refresh_cnt <= refresh_cnt + 1'b1;
       digit_sel   <= refresh_cnt[15:14];

       if (value < 0) begin
           abs_val     <= -value;
           is_negative <= 1'b1;
       end
       else begin
           abs_val     <= value;
           is_negative <= 1'b0;
       end

       ones     <= abs_val % 10;
       tens     <= (abs_val / 10) % 10;
       hundreds <= (abs_val / 100) % 10;

       case (digit_sel)
           2'b00: begin
               an    <= 4'b1110;
               digit <= ones;
           end

           2'b01: begin
               an    <= 4'b1101;
               digit <= tens;
           end

           2'b10: begin
               an    <= 4'b1011;
               digit <= hundreds;
           end

           2'b11: begin
               an <= 4'b0111;
               if (is_negative)
                   digit <= 4'hA;
               else
                   digit <= 4'hF;
           end
       endcase

       case (digit)
           4'd0: seg <= 7'b1000000;
           4'd1: seg <= 7'b1111001;
           4'd2: seg <= 7'b0100100;
           4'd3: seg <= 7'b0110000;
           4'd4: seg <= 7'b0011001;
           4'd5: seg <= 7'b0010010;
           4'd6: seg <= 7'b0000010;
           4'd7: seg <= 7'b1111000;
           4'd8: seg <= 7'b0000000;
           4'd9: seg <= 7'b0010000;
           4'hA: seg <= 7'b0111111; // minus
           default: seg <= 7'b1111111; // blank
       endcase
   end

endmodule