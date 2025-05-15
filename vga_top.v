`timescale 1ns / 1ps

module vga_top(
	input ClkPort,
	input BtnC,
	input BtnU,
	input BtnR,
	input BtnL,
	input BtnD,
	//VGA signal
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	
	//SSG signal 
	output An0, An1, An2, An3, An4, An5, An6, An7,
	output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	
	//output MemOE, MemWR, RamCS,
	output  QuadSpiFlashCS
	);
	wire Reset;
	assign Reset=BtnC;
	wire bright;
	wire[9:0] hc, vc;
	wire[15:0] score;
	wire up,down,left,right;
	wire [3:0] anode;
	wire [11:0] rgb;
	wire rst;
	
	//snake related
	wire [2999:0] input_x;
	wire [2999:0] input_y;
	wire [6:0] snake_length;
	wire grow;
	wire [9:0] fruit_x;
	wire [9:0] fruit_y;

	reg [3:0]	SSD;
	wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	reg [7:0]  	SSD_CATHODES;
	wire [1:0] 	ssdscan_clk;
	
	reg [27:0]	DIV_CLK;
	always @ (posedge ClkPort, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
	  else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	wire move_clk;
	assign move_clk=DIV_CLK[19]; //slower clock to drive the movement of objects on the vga screen
	assign fruit_clk=DIV_CLK[20];
	display_controller dc(.clk(ClkPort), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));
	
	snake s(		
		.clk(move_clk),
		.rst(BtnC),
		.up(BtnU),
		.down(BtnD),
		.left(BtnL),
		.right(BtnR),
		.output_x(input_x),
		.output_y(input_y),
		.snake_length(snake_length),
		.grow(grow)
	);
	
	fruit f(
		.clk(fruit_clk),
		.rst(rst),
		.input_x(input_x),
		.input_y(input_y),
		.snake_length(snake_length),
		.grow(grow),
		.fruit_x(fruit_x),
		.fruit_y(fruit_y)
	);
		
	   wire [11:0] background;
	snake_drawer sc(
		.clk(ClkPort),
		.bright(bright),
		.rst(BtnC),
		.hCount(hc),
		.vCount(vc),
		.up(BtnU),
		.down(BtnD),
		.left(BtnL),
		.right(BtnR),
		.input_x(input_x),
		.input_y(input_y),
		.snake_length(snake_length),
		.fruit_x(fruit_x),
		.fruit_y(fruit_y),
		.rgb(rgb),
		.background(background)
		);	


	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	
	assign QuadSpiFlashCS = 1'b1;

endmodule
