`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    21:57:27 12/07/2015
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 *
 */

module freq_devider(
	output reg clk_25M,
	output reg clk_400,
	output reg clk_5,
	input clk_100M
    );

	reg [22:0] counter;

	always @ (posedge clk_100M)
		counter <= counter + 1;

	always @ (posedge clk_100M)
	begin
		if (counter[0])
			clk_25M <= ~clk_25M;
		if (counter[16:0] == 17'hFFFFF)
			clk_400 <= ~clk_400;
		if (counter == 23'hFFFFFF)
			clk_5 <= ~clk_5;
	end

endmodule
