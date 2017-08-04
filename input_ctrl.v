`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    21:05:17 12/04/2015
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module input_ctrl(
	output reg [2:0] key_stroke,
	input key_up, key_down, key_left, key_right, pause,
	input clk_25M, rst
    );

	parameter UP = 3'b000, DOWN = 3'b001, LEFT = 3'b010, RIGHT = 3'b011;
	parameter PAUSE = 3'b100;

	always @ (posedge clk_25M or posedge rst)
		if (rst)
			key_stroke <= RIGHT;
		else
			casex ({key_up, key_down, key_left, key_right, pause})
			5'b????1: key_stroke <= PAUSE;
			5'b???10: key_stroke <= RIGHT;
			5'b??100: key_stroke <= LEFT;
			5'b?1000: key_stroke <= DOWN;
			5'b10000: key_stroke <= UP;
			endcase

endmodule
