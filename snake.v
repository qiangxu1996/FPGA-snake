`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    11:28:46 12/03/2015
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module snake(
	output [2:0] vgaRed, vgaGreen,
	output [2:1] vgaBlue,
	output Hsync, Vsync,
	output [7:0] seg,
	output [3:0] an,
	input key_up, key_down, key_left, key_right, pause,
	input clk_100M, rst
    );

	parameter WIDTH = 40;
	parameter HEIGHT = 30;

	wire [5:0] head_x, head_y, tail_x, tail_y, apple_x, apple_y;
	wire [5:0] pixel_x, pixel_y;
	wire [5:0] next_head_x, next_head_y;
	wire [5:0] avaliable_apple_x, avaliable_apple_y;
	wire [10:0] score;
	wire [2:0] key_stroke;
	wire head_pos_data, pixel_data;
	wire clk_25M, clk_5;

	snake_state ss0 (head_x, head_y, tail_x, tail_y, apple_x, apple_y, score,
		key_stroke, avaliable_apple_x, avaliable_apple_y,
		next_head_x, next_head_y, head_pos_data, clk_25M, clk_5, rst);
	freq_devider fd0 (clk_25M, clk_400, clk_5, clk_100M);
	pixel_ram_ctrl prc0 (head_pos_data, pixel_data,
		head_x, head_y, tail_x, tail_y, next_head_x, next_head_y,
		pixel_x, pixel_y, clk_25M, clk_5, rst);
	input_ctrl ic0 (key_stroke,
		key_up, key_down, key_left, key_right, pause, clk_25M, rst);
	vga_ctrl vc0 (vgaRed, vgaGreen, vgaBlue, Hsync, Vsync,
		pixel_x, pixel_y, head_x, head_y, apple_x, apple_y, pixel_data, clk_25M);
	apple_gen ag0 (avaliable_apple_x, avaliable_apple_y,
		pixel_x, pixel_y, apple_x, apple_y, pixel_data, clk_25M, rst);
	score_disp sd0 (seg, an, score, clk_400);

endmodule
