`timescale 1ns / 1ps

module snake_drawer(
	input clk,
	input bright,
	input rst,
	input [9:0] hCount, vCount,
	input up, input down, input left, input right,
	input wire [2999:0] input_x,
	input wire [2999:0] input_y,
	input wire [6:0] snake_length,
	input wire [9:0] fruit_x,
	input wire [9:0] fruit_y,	
	output reg [11:0] rgb,
	output reg [11:0] background
);
	wire block_fill;
	wire fruit_fill;
	reg [9:0] snake_x [0:99];
	reg [9:0] snake_y [0:99];

	integer i;

	function checkPixel;
		input [9:0] x, y;
		integer k;
		begin
			checkPixel = 0; 
			for (k = 0; k < snake_length; k = k + 1) begin
                if (x >= (snake_x[k] - 5) && x <= (snake_x[k] + 5) &&
                    y >= (snake_y[k] - 5) && y <= (snake_y[k] + 5)) begin
                    checkPixel = 1;
                end
			end
		end
	endfunction

	assign block_fill = checkPixel(hCount, vCount);
	assign fruit_fill = fruit_x + 5 >= hCount && 
	                   fruit_x - 5 <= hCount &&
	                   fruit_y + 5 >= vCount &&
	                   fruit_y - 5 <= vCount;

	parameter RED = 12'b1111_0000_0000;

	always @(*) begin
		if (~bright)
			rgb = 12'b0000_0000_0000;
		else if (block_fill)
			rgb = 12'b0000_0000_1111;
		else if(fruit_fill)
		    rgb = 12'b1111_0000_0000;
		else
			rgb = 12'b0000_1111_0000;
	end

	// Load input_x and input_y bits into snake_x and snake_y arrays
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			for (i = 0; i < snake_length; i = i + 1) begin
				snake_x[i] <= 10'd0;
				snake_y[i] <= 10'd0;
			end
		end else begin
			for (i = 0; i < snake_length; i = i + 1) begin
				snake_x[i] <= input_x[i*10 +: 10];
				snake_y[i] <= input_y[i*10 +: 10];
			end
		end
	end

	// Background color
	always @(posedge clk or posedge rst) begin
		if (rst)
			background <= 12'b1111_1111_1111;
		else if (right)
			background <= 12'b1111_1111_0000;
		else if (left)
			background <= 12'b0000_1111_1111;
		else if (down)
			background <= 12'b0000_1111_0000;
		else if (up)
			background <= 12'b0000_0000_1111;
	end

endmodule
