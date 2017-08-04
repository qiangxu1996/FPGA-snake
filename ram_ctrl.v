`timescale 1ns / 1ps
/*
 * Engineer: Minstrel Hall
 * Create Date:    11:16:27 12/03/2015
 * Description:
 * Micron M45W8MW16
 * Used as VGA display ram, in 32 words burst mode.
 * CRT resolution: 640*480
 * Dependencies:
 *
 * Revision:
 *
 */

module ram_ctrl(
	output [26:1] MemAdr,
	inout [15:0] MemDB,
	output MemOE, MemWR,
	output RamAdv, RamCS, RamClk_25M,
			RamCRE, RamLB, RamUB, RamWait
    );


endmodule
