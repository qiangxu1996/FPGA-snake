`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    19:42:35 12/07/2015
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module score_disp(
	output [7:0] seg,
	output reg [3:0] an,
	input [10:0] score,
	input clk_400
    );

	wire [3:0] num[3:0];
	reg [3:0] bcd;

	assign num[0] = score % 10'd10;
	assign num[1] = (score / 10'd10) % 10'd10;
	assign num[2] = (score / 10'd100) % 10'd10;
	assign num[3] = (score / 10'd1000) % 10'd10;

	seven_seg_decoder ssd0 (seg, bcd);

	always @ (posedge clk_400)
		case (an)
		4'b1110:
		begin
			an <= 4'b1101;
			bcd <= num[1];
		end
		4'b1101:
		begin
			an <= 4'b1011;
			bcd <= num[2];
		end
		4'b1011:
		begin
			an <= 4'b0111;
			bcd <= num[3];
		end
		default:
		begin
			an <= 4'b1110;
			bcd <= num[0];
		end
		endcase

endmodule
