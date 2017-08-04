`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    15:24:24 12/03/2015
 * Description:
 *
 * Dependencies:
 *
 * Revision:
 * Dec 5: 1200-register implementation discarded,
 * because of sourse shortage of Spantan 6.
 */

module snake_state(
	output reg [5:0] head_x, head_y, tail_x, tail_y,
	output reg [5:0] apple_x, apple_y,
	output reg [10:0] score,
	input [2:0] key_stroke,
	input [5:0] avaliable_apple_x, avaliable_apple_y,
	output reg [5:0] check_x, check_y,
	input body_exist,
	input clk_25M, clk_5, rst
    );

	parameter WIDTH = 6'd40;
	parameter HEIGHT = 6'd30;
	parameter UP = 3'b000, DOWN = 3'b001, LEFT = 3'b010, RIGHT = 3'b011;
	parameter PAUSE = 3'b100, STOPPED = 3'b111;

	/* the array based implementation is discarded temporarily*/
	/* the pixel info could also be put into the ram*/
//	reg pixel[HEIGHT-1:0][WIDTH-1:0];
//	/* convert each pixel_stream to pixel element for convinience.*/
//	integer i, j;
//	always @ (*)
//		for (i = 0; i < HEIGHT; i = i + 1)
//			for (j = 0; j < WIDTH; j = j + 1)
//				pixel_stream[i*WIDTH+j] = pixel[i][j];

	reg [2:0] head_dir, tail_dir;
	reg [5:0] next_head_x, next_head_y;
	reg [5:0] next_apple_x, next_apple_y;
	reg [2:0] next_head_dir;
	wire [2:0] next_tail_dir;
	reg [10:0] next_score;
	wire [10:0] pixel_pos_a, tail_pos;
	reg [10:0] rst_pos;

	/* game_state has been joined into head_dir/tail_dir for neat code */
//	reg game_state;
//	/* for game_state */
//	/* STOPPED stands for game over or passed, while clk_5 is still active*/
//	parameter ONGOING = 1'b1, STOPPED = 1'b0;


	assign pixel_pos_a = rst ? rst_pos : head_y*WIDTH+head_x;
	assign tail_pos = tail_y*WIDTH+tail_x;

	turn_info ti0 (
		.clka(clk_5),
		.wea(1'b1),
		.addra(pixel_pos_a),
		.dina(next_head_dir),
//		.douta(douta),
		.clkb(clk_25M),
		.web(1'b0),
		.addrb(tail_pos),
		.dinb(3'b000),
		.doutb(next_tail_dir)
		);

	always @ (posedge clk_5)
		case (rst_pos)
		11'd607, 11'd608: rst_pos <= rst_pos + 11'd1;
		default: rst_pos <= 11'd607;
		endcase

	always @ (posedge clk_5)// or posedge rst)
		if (rst)
		begin
			/* initial body of snake*/
			/* use global rst instead*/
//			rst_ram <= 1'b1;
			head_x <= 6'd10;
			head_y <= 6'd15;
			head_dir <= RIGHT;
			apple_x <= avaliable_apple_x;
			apple_y <= avaliable_apple_y;
			score <= 11'd0;
		end
		else
		begin
//			rst_ram <= 1'b0;
			head_x <= next_head_x;
			head_y <= next_head_y;
			head_dir <= next_head_dir;
			apple_x <= next_apple_x;
			apple_y <= next_apple_y;
			score <= next_score;
		end

		always @ (*)
			case (head_dir)
			LEFT:
				case (key_stroke)
				LEFT, RIGHT:
				begin
					check_x = head_x - 6'd1;
					check_y = head_y;
					next_head_y = head_y;
					if (head_x == 6'b0 || body_exist)
					begin
						next_head_x = head_x;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_x = head_x - 6'd1;
						next_head_dir = LEFT;
					end
					update_score_and_apple;
				end
				UP:
				begin
					check_x = head_x;
					check_y = head_y - 6'd1;
					next_head_x = head_x;
					if (head_y == 6'b0 || body_exist)
					begin
						next_head_y = head_y;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_y = head_y - 6'd1;
						next_head_dir = UP;
					end
					update_score_and_apple;
				end
				DOWN:
				begin
					check_x = head_x;
					check_y = head_y + 6'd1;
					next_head_x = head_x;
					if (head_y == HEIGHT - 6'b1 || body_exist)
					begin
						next_head_y = head_y;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_y = head_y + 6'd1;
						next_head_dir = DOWN;
					end
					update_score_and_apple;
				end
				default: //PAUSE:
				begin
					check_x = head_x;
					check_y = head_y;
					next_head_x = head_x;
					next_head_y = head_y;
					next_head_dir = PAUSE;
					next_score = score;
					next_apple_x = apple_x;
					next_apple_y = apple_y;
				end
				endcase
			RIGHT:
				case (key_stroke)
				LEFT, RIGHT:
				begin
					check_x = head_x + 6'd1;
					check_y = head_y;
					next_head_y = head_y;
					if (head_x == WIDTH - 6'b1 || body_exist)
					begin
						next_head_x = head_x;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_x = head_x + 6'd1;
						next_head_dir = RIGHT;
					end
					update_score_and_apple;
				end
				UP:
				begin
					check_x = head_x;
					check_y = head_y - 6'd1;
					next_head_x = head_x;
					if (head_y == 6'b0 || body_exist)
					begin
						next_head_y = head_y;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_y = head_y - 6'd1;
						next_head_dir = UP;
					end
					update_score_and_apple;
				end
				DOWN:
				begin
					check_x = head_x;
					check_y = head_y + 6'd1;
					next_head_x = head_x;
					if (head_y == HEIGHT - 6'b1 || body_exist)
					begin
						next_head_y = head_y;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_y = head_y + 6'd1;
						next_head_dir = DOWN;
					end
					update_score_and_apple;
				end
				default: //PAUSE:
				begin
					check_x = head_x;
					check_y = head_y;
					next_head_x = head_x;
					next_head_y = head_y;
					next_head_dir = PAUSE;
					next_score = score;
					next_apple_x = apple_x;
					next_apple_y = apple_y;
				end
				endcase
			UP:
				case (key_stroke)
				LEFT:
				begin
					check_x = head_x - 6'd1;
					check_y = head_y;
					next_head_y = head_y;
					if (head_x == 6'b0 || body_exist)
					begin
						next_head_x = head_x;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_x = head_x - 6'd1;
						next_head_dir = LEFT;
					end
					update_score_and_apple;
				end
				RIGHT:
				begin
					check_x = head_x + 6'd1;
					check_y = head_y;
					next_head_y = head_y;
					if (head_x == WIDTH - 6'b1 || body_exist)
					begin
						next_head_x = head_x;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_x = head_x + 6'd1;
						next_head_dir = RIGHT;
					end
					update_score_and_apple;
				end
				UP, DOWN:
				begin
					check_x = head_x;
					check_y = head_y - 6'd1;
					next_head_x = head_x;
					if (head_y == 6'b0 || body_exist)
					begin
						next_head_y = head_y;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_y = head_y - 6'd1;
						next_head_dir = UP;
					end
					update_score_and_apple;
				end
				default: //PAUSE:
				begin
					check_x = head_x;
					check_y = head_y;
					next_head_x = head_x;
					next_head_y = head_y;
					next_head_dir = PAUSE;
					next_score = score;
					next_apple_x = apple_x;
					next_apple_y = apple_y;
				end
				endcase
			DOWN:
				case (key_stroke)
				LEFT:
				begin
					check_x = head_x - 6'd1;
					check_y = head_y;
					next_head_y = head_y;
					if (head_x == 6'b0 || body_exist)
					begin
						next_head_x = head_x;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_x = head_x - 6'd1;
						next_head_dir = LEFT;
					end
					update_score_and_apple;
				end
				RIGHT:
				begin
					check_x = head_x + 6'd1;
					check_y = head_y;
					next_head_y = head_y;
					if (head_x == WIDTH - 6'b1 || body_exist)
					begin
						next_head_x = head_x;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_x = head_x + 6'd1;
						next_head_dir = RIGHT;
					end
					update_score_and_apple;
				end
				UP, DOWN:
				begin
					check_x = head_x;
					check_y = head_y + 6'd1;
					next_head_x = head_x;
					if (head_y == HEIGHT - 6'b1 || body_exist)
					begin
						next_head_y = head_y;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_y = head_y + 6'd1;
						next_head_dir = DOWN;
					end
					update_score_and_apple;
				end
				default: //PAUSE:
				begin
					check_x = head_x;
					check_y = head_y;
					next_head_x = head_x;
					next_head_y = head_y;
					next_head_dir = PAUSE;
					next_score = score;
					next_apple_x = apple_x;
					next_apple_y = apple_y;
				end
				endcase
			PAUSE:
				case (key_stroke)
				LEFT:
				begin
					check_x = head_x - 6'd1;
					check_y = head_y;
					next_head_y = head_y;
					if (head_x == 6'b0 || body_exist)
					begin
						next_head_x = head_x;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_x = head_x - 6'd1;
						next_head_dir = LEFT;
					end
					update_score_and_apple;
				end
				RIGHT:
				begin
					check_x = head_x + 6'd1;
					check_y = head_y;
					next_head_y = head_y;
					if (head_x == WIDTH - 6'b1 || body_exist)
					begin
						next_head_x = head_x;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_x = head_x + 6'd1;
						next_head_dir = RIGHT;
					end
					update_score_and_apple;
				end
				UP:
				begin
					check_x = head_x;
					check_y = head_y - 6'd1;
					next_head_x = head_x;
					if (head_y == 6'b0 || body_exist)
					begin
						next_head_y = head_y;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_y = head_y - 6'd1;
						next_head_dir = UP;
					end
					update_score_and_apple;
				end
				DOWN:
				begin
					check_x = head_x;
					check_y = head_y + 6'd1;
					next_head_x = head_x;
					if (head_y == HEIGHT - 6'b1 || body_exist)
					begin
						next_head_y = head_y;
						next_head_dir = STOPPED;
					end
					else
					begin
						next_head_y = head_y + 6'd1;
						next_head_dir = DOWN;
					end
					update_score_and_apple;
				end
				default: //PAUSE:
				begin
					check_x = head_x;
					check_y = head_y;
					next_head_x = head_x;
					next_head_y = head_y;
					next_head_dir = PAUSE;
					next_score = score;
					next_apple_x = apple_x;
					next_apple_y = apple_y;
				end
				endcase
			default: //STOPPED:
			begin
				check_x = head_x;
				check_y = head_y;
				next_head_x = head_x;
				next_head_y = head_y;
				next_score = score;
				next_apple_x = apple_x;
				next_apple_y = apple_y;
				next_head_dir = STOPPED;
			end
			endcase

	task update_score_and_apple;
	begin
		if (next_head_x == apple_x && head_y == apple_y)
		begin
			next_score = score + 11'd1;
			next_apple_x = avaliable_apple_x;
			next_apple_y = avaliable_apple_y;
		end
		else
		begin
			next_score = score;
			next_apple_x = apple_x;
			next_apple_y = apple_y;
		end
	end
	endtask

	always @ (posedge clk_5)
		if (rst)
		begin
			tail_x <= 6'd7;
			tail_y <= 6'd15;
		end
		else if (next_head_dir[2]
			|| (next_head_x == apple_x && next_head_y == apple_y))
		begin
			tail_x <= tail_x;
			tail_y <= tail_y;
		end
		else
		begin
			case (next_tail_dir)
			LEFT:
				tail_x <= tail_x - 6'd1;
			RIGHT:
				tail_x <= tail_x + 6'd1;
			UP:
				tail_y <= tail_y - 6'd1;
			DOWN:
				tail_y <= tail_y + 6'd1;
			endcase
		end

endmodule
