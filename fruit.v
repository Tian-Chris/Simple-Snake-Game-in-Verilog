module fruit(
  input clk,
  input rst,
  input [2999:0] input_x,
  input [2999:0] input_y,
	input [6:0] snake_length,
	output reg [9:0] fruit_x,
	output reg [9:0] fruit_y,
	output reg grow
);
  reg [9:0] snake_x [0:99];
  reg [9:0] snake_y [0:99];
	reg [6:0] index;
	
  integer i;
	always @(posedge clk) begin
        for (i = 0; i < 30; i = i + 1) begin
            if(i < snake_length) begin
				snake_x[i] <= input_x[i*10 +: 10];
				snake_y[i] <= input_y[i*10 +: 10];
            end
        end
    end
    
	integer j;
  always @(posedge clk or posedge rst) begin
  if (rst) begin
      index <= 7'b0;
      grow <= 0;
      fruit_x <= randx(index);
      fruit_y <= randy(index);
  end else begin
      grow <= 0;
      for(j = 0; j < snake_length; j = j+1) begin
          if (snake_x[j] + 5 >= randx(index) && 
              snake_x[j] - 5 <= randx(index) && 
               snake_y[j] + 5 >= randy(index) && 
              snake_y[j] - 5 <= randy(index)) begin
              grow <= 1;
              index <= (index + 1);
           end
       end
       fruit_x <= randx(index);
       fruit_y <= randy(index);
    end
end
function [9:0] randx;
        input [31:0] in;
        reg [31:0] mix1, mix2, mix3;
        begin
            mix1 = in ^ (in << 13);
            mix2 = mix1 ^ (mix1 >> 17);
            randx = (mix2 % 600) + 150;  
        end
    endfunction

    function [9:0] randy;
        input [31:0] in;
        reg [31:0] mix1, mix2, mix3;
        begin
            mix1 = in ^ (in << 13);
            mix2 = mix1 ^ (mix1 << 5);
            randy = (mix2 % 450) + 50;  
        end
    endfunction    
endmodule
