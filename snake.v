module snake(
    input clk,
    input rst,
	input grow,
    input up, input down, input left, input right,
    output reg [2999:0] output_x,
    output reg [2999:0] output_y,
    output reg [6:0] snake_length
);
	reg grew;
    reg [9:0] snake_x [0:100];
    reg [9:0] snake_y [0:100];
    reg [1:0] direction;
    reg snake_end;
    integer i;
    
    // Snake movement logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            snake_x[0] <= 300;
            snake_y[0] <= 300;
            snake_length = 1;
            snake_end = 0;
            
        end 
		else begin
            if (right && (direction != 2'b01))
                direction <= 2'b00;
            else if (left && (direction != 2'b00))
                direction <= 2'b01;
            else if (up && (direction != 2'b11))
                direction <= 2'b10;
            else if (down && (direction != 2'b10))
                direction <= 2'b11;

            case (direction)
                2'b00: begin 
                    if(snake_x[0] <= 784 && snake_end == 0) 
                    snake_x[0] = snake_x[0] + 5;                        
                end
                2'b01: begin 
                        if(snake_x[0] >= 143 && snake_end == 0) 
                        snake_x[0] = snake_x[0] - 5;     
                end
                2'b10: begin 
                     if(snake_y[0] >= 34 && snake_end == 0) 
                        snake_y[0] = snake_y[0] - 5; 
                end
                2'b11: begin 
                        if(snake_y[0] <= 514 && snake_end == 0) 
                        snake_y[0] = snake_y[0] + 5;     
                end
            endcase
			if(grow && grew)
			begin
				grew = 0;
			    snake_length <= snake_length + 1;
                snake_x[snake_length] <= snake_x[snake_length - 1];
                snake_y[snake_length] <= snake_y[snake_length - 1];
			end
			else if(grow != 1)
				grew = 1;
            for (i = 30; i > 0; i = i - 1) begin
                if(i < snake_length)
                begin
                    snake_x[i] <= snake_x[i-1];
                    snake_y[i] <= snake_y[i-1];
                end
            end
        end
    end
    
    always @(posedge clk) begin
        if (snake_end == 0) begin
            for (i = 1; i < snake_length; i = i + 1) begin
                if (snake_x[0] == snake_x[i] && snake_y[0] == snake_y[i]) begin
                    snake_end <= 1;
                end
            end

            if (snake_x[0] < 200 || snake_x[0] > 500 || snake_y[0] < 200 || snake_y[0] > 500) begin
                snake_end <= 1;
            end
        end
    end
    always @(posedge clk) begin
        for (i = 0; i < 30; i = i + 1) begin
            if(i < snake_length)
            begin
                output_x[i*10 +: 10] <= snake_x[i];
                output_y[i*10 +: 10] <= snake_y[i];
            end
        end
    end
    
endmodule
