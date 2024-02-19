`timescale 1ns/10ps

module sim_tb(
);
	//////////////////////////////////////////////////////////////////
	//              GLOBAL VARIABLES AND SIM CONSTANTS              //
	//Time constants in reference to timescale (ns)
	localparam SECOND       = 1_000_000_000;
	localparam MILLISECOND  = 1_000_000;
	localparam MICROSECOND  = 1_000;
	localparam NANOSECOND   = 1;
	localparam NANOSECOND_PER_SECOND = 1_000_000_000;

	//Frequency constants
	localparam CLOCK_FREQUENCY_HZ = 48_000_000; //12MHz
	localparam CLOCK_TIME_NS      = (1.0/CLOCK_FREQUENCY_HZ)*
					NANOSECOND_PER_SECOND;
	localparam PULSE_WIDTH_NS     = CLOCK_TIME_NS/2;
	//total sim time (in timescale units)
	localparam SIM_DURATION_NS    = 1*MILLISECOND;
	
	//#((1/48)*1000)/2
	localparam PERIOD = 10.41667;

	//////////////////////////////////////////////////////////////////
	//                           FPGA CLOCK                         //
	reg fpga_clk = 0;
	always begin
		#(PERIOD);
		fpga_clk = ~fpga_clk;
	end

	//////////////////////////////////////////////////////////////////
	//                         STORAGE ELEMENTS                     //
	wire [15:0] rdata;
	reg  [ 7:0] raddr;
	reg         we;
	reg  [ 7:0] waddr;
	reg  [15:0] wdata;

	initial begin
		we <= 1'b0;
		raddr <= 8'd1;
		#(11*PERIOD);
		waddr <= 8'd1;
		wdata <= 16'hcafe;
		we <= 1'b1;
		#(1);
		we <= 1'b0;
		#(2*PERIOD);
		raddr <= 8'd2;
		#(2*PERIOD);
		raddr <= 8'd1;
		#(3*PERIOD);
		raddr <= 8'd255;
	end

	//////////////////////////////////////////////////////////////////
	//                       MODULE INSTANTIATION                  //
	SB_RAM40_4K #(
		.INIT_FILE("ifilegen/init.dat"),
		.WRITE_MODE(0),
		.READ_MODE(0)
	) ebr_I (
		.RE(1'b1),
		.RCLK(fpga_clk),
		.RADDR(raddr),
		.RDATA(rdata),
		.WE(we),
		.WCLK(fpga_clk),
		.WADDR(waddr),
		.WDATA(wdata)
	);

	initial begin
		$dumpfile("sim.vcd");
		$dumpvars(0,sim_tb);
		#(SIM_DURATION_NS);
		$finish;
	end
endmodule
