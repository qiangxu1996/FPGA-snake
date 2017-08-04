`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    18:38:35 12/04/2015
 * Description:
 * resolution 640*480
 * Dependencies:
 *
 * Revision:
 *
 */

module vga_ctrl(
	output reg [2:0] vgaRed, vgaGreen,
	output reg [2:1] vgaBlue,
	output reg Hsync, Vsync,
	output [5:0] pixel_x, pixel_y,
	input [5:0] head_x, head_y, apple_x, apple_y,
	input pixel_data,
	input clk_25M
    );

	parameter WIDTH = 6'd40;
	parameter HEIGHT = 6'd30;
//	parameter TVpw = 19'd1600, TVbp = 19'd23200, TVdisp = 19'd384000; //clocks
//	parameter TVs = 19'd416800; //clocks
	parameter TVpw = 10'd2, TVbp = 10'd29, TVdisp = 10'd480, TVs = 10'd521; //lines
	parameter THpw = 10'd96, THbp = 10'd48, THdisp = 10'd640, THs = 10'd800; //clocks

//	reg [18:0] V_counter;
	reg [9:0] V_counter;
	reg [9:0] H_counter;
//	reg [8:0] line_counter;
//	reg H_pause;
//	wire [10:0] pixel_pos;
	reg [2:0] next_vgaRed, next_vgaGreen;
	reg [1:0] next_vgaBlue;
	wire [5:0] real_pixel_x;

//	assign pixel_pos = ((V_counter - TVpw - TVbp) >> 4) * WIDTH
//		+ (H_counter - THpw - THbp) >> 4;
	assign pixel_x = (H_counter - THpw - THbp + 10'd1) >> 4;
	assign pixel_y = (V_counter - TVpw - TVbp) >> 4;
	/* pixel_y is already the real one, while pixel_x is the coming one.*/
	assign real_pixel_x = (H_counter - THpw - THbp) >> 4;

	always @ (posedge clk_25M)
		if (H_counter == THs)
		begin
			H_counter <= 10'b0;
			Hsync <= 1'b0;
		end
		else
		begin
			H_counter <= H_counter + 10'd1;
			if (H_counter == THpw - 10'd2)
				Hsync <= 1'b1;
		end

	always @ (posedge clk_25M)
		if (H_counter == THs)
			if (V_counter == TVs)
			begin
				V_counter <= 10'd0;
				Vsync <= 1'b0;
			end
			else
			begin
				V_counter <= V_counter + 10'd1;
				if (V_counter == TVpw - 10'd2)
					Vsync <= 1'b1;
			end

	always @ (posedge clk_25M)
		{vgaRed, vgaGreen, vgaBlue} <= {next_vgaRed, next_vgaGreen, next_vgaBlue};

	always @ (*)
		if (V_counter > TVpw + TVbp - 10'd1 && V_counter <= TVpw + TVbp + TVdisp - 10'd1
			&& H_counter >= THpw + THbp - 10'd1 && H_counter < THpw + THbp + THdisp - 10'd1)
			if (pixel_data)
				if (real_pixel_x == head_x && pixel_y == head_y)
					{next_vgaRed, next_vgaGreen, next_vgaBlue} = 8'b00011100;
				else
					{next_vgaRed, next_vgaGreen, next_vgaBlue} = 8'b11111100;
			else if (real_pixel_x == apple_x && pixel_y == apple_y)
				{next_vgaRed, next_vgaGreen, next_vgaBlue} = 8'b11100000;
			else
				{next_vgaRed, next_vgaGreen, next_vgaBlue} = 8'b01101101;
		else
			{next_vgaRed, next_vgaGreen, next_vgaBlue} = 8'b0;

endmodule
