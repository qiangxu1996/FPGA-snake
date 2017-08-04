`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    20:46:32 12/04/2015
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module apple_gen(
	output reg [5:0] avaliable_apple_x, avaliable_apple_y,
	input [5:0] pixel_x, pixel_y, apple_x, apple_y,
	input pixel_data,
	input clk_25M, rst
    );

	parameter WIDTH = 6'd40;
	parameter HEIGHT = 6'd30;

	always @ (posedge clk_25M)
		if (!pixel_data && pixel_x < WIDTH && pixel_y < HEIGHT && !rst
			&& pixel_x != apple_x && pixel_y != apple_y)
		begin
			avaliable_apple_x <= pixel_x;
			avaliable_apple_y <= pixel_y;
		end

endmodule
