//ICE40 generalization of SB RAM
module SB_RAM40_4K #(
	parameter INIT_FILE  = "",
	parameter WRITE_MODE = 0,
	parameter READ_MODE  = 0 //CURRENTLY UNUSED
)(
	input [15:0] WDATA,	//write data input
	input [15:0] MASK,	//Bit line write enable input, active low (applicable only when 
				//write mode parameter is set to 0)
	input [7:0]  WADDR,	//write address input
	input        WE,	//write enable input, active high
	input        WCLK,	//write clock input, rising-edge active
	input        WCLKE,	//write clock enable input
	input   [7:0]  RADDR,	//read address input
	input        RE,	//read enable input, active high
	input        RCLK,	//read clock input, rising edge active
	input        RCLKE,	//read clock enable input
	output [15:0] RDATA	//read data output
);
	parameter DATA_WIDTH = 	(WRITE_MODE == 0) ? 16 :
				(WRITE_MODE == 1) ?  8 :
				(WRITE_MODE == 2) ?  4 :
				(WRITE_MODE == 3) ?  2 : 
				16;
	parameter DATA_LEN = 	(WRITE_MODE == 0) ?  256 :
				(WRITE_MODE == 1) ?  512 :
				(WRITE_MODE == 2) ? 1024 :
				(WRITE_MODE == 3) ? 2048 :
				256;
	ram #(
		.MEM_INIT_FILE(INIT_FILE),
		.DATA_WIDTH(DATA_WIDTH),
		.DATA_LEN(DATA_LEN)
	)raminst(
		.w_clk(WCLK),
		.r_clk(RCLK),
		.w_en(WE),
		.r_en(RE),
		.w_addr(WADDR),
		.r_addr(RADDR),
		.r_data(RDATA),
		.w_data(WDATA)
	);
endmodule

//inferred block ram
module ram #( 
	parameter DATA_LEN         = 256,
	parameter DATA_WIDTH       = 16,
	parameter MEM_INIT_FILE    = ""
)(
	input                             w_clk,
	input                             r_clk,
	input                             w_en,
	input                             r_en,
	input      [$clog2(DATA_LEN)-1:0] r_addr,
	input      [$clog2(DATA_LEN)-1:0] w_addr,
	output reg [DATA_WIDTH-1:0] r_data,
	input      [DATA_WIDTH-1:0] w_data
);

	// memory is laid out as:
	reg [DATA_WIDTH-1:0] mem [0:DATA_LEN-1];
	initial begin
		if( MEM_INIT_FILE != "" ) begin
			$readmemh(MEM_INIT_FILE, mem);
		end
	end
	always @(posedge w_clk) begin
		if( w_en ) begin
			mem[w_addr] <= w_data;
		end
	end
	always @(posedge r_clk) begin
		if( r_en ) begin
			r_data <= mem[r_addr];
		end
	end

endmodule
