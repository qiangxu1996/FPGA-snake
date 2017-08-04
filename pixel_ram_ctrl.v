`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    09:47:18 12/05/2015
 * Description:
 *
 * Dependencies:
 * attention: apple position is not stored in the memory.
 * Revision:
 *
 */

module pixel_ram_ctrl(
	output douta, doutb,
	input [5:0] head_x, head_y, tail_x, tail_y,
	input [5:0] check_x, check_y,
	input [5:0] pixel_x, pixel_y,
	input clk_25M, clk_5, rst
    );

	parameter WIDTH = 6'd40;
	parameter HEIGHT = 6'd30;

	wire [10:0] pixel_pos_a, pixel_pos_b;
	reg [10:0] rst_pos;
	reg wea, web;
	reg [1:0] w_pd_counter;
	reg dina;

	assign pixel_pos_a = rst ? rst_pos
		: (wea ? head_y*WIDTH+head_x : check_y*WIDTH+check_x);
	assign pixel_pos_b = web ? tail_y*WIDTH+tail_x : pixel_y*WIDTH+pixel_x;

	pixel_ram pr0 (
		.clka(clk_25M),
		.wea(wea),
		.addra(pixel_pos_a),
		.dina(dina),
		.douta(douta),
		.clkb(clk_25M),
		.web(web),
		.addrb(pixel_pos_b),
		.dinb(1'b0),
		.doutb(doutb)
		);

	always @ (posedge clk_25M)
		if (rst)
		begin
			web <= 1'b0;
			if (rst_pos == 11'd1200)
				wea <= 1'b0;
			else
				wea <= 1'b1;
			// should be the position where body appear - 1
			if (rst_pos == 11'd607 || rst_pos == 11'd608 || rst_pos == 11'd609
				|| rst_pos == 11'd1200)
				dina <= 1'b1;
			else
				dina <= 1'b0;
		end
		else
		begin
			dina <= 1'b1;
//			if (w_pd_counter == 2'b11 || w_pd_counter == 2'b00)
			if (~^w_pd_counter)
			begin
				wea <= 1'b0;
				web <= 1'b0;
			end
			else
			begin
				wea <= 1'b1;
				web <= 1'b1;
			end
		end

	always @ (posedge clk_25M)
		if (clk_5 && w_pd_counter != 2'b11)
			w_pd_counter <= w_pd_counter + 2'b01;
		else if (~clk_5)
			w_pd_counter <= 2'b00;

	always @ (posedge clk_25M)
		if (!rst)
			rst_pos <= 11'hFFF;
		else if (rst_pos != 11'd1200)
			rst_pos <= rst_pos + 11'd1;

endmodule
