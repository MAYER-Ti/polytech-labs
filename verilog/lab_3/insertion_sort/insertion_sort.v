module insertion_sort #(parameter WIDTH = 8, SIZE = 8) (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [WIDTH*SIZE-1:0] data_in, // ?????????? ?????? ??? ??????? ??????
    output reg [WIDTH*SIZE-1:0] data_out, // ?????????? ?????? ??? ???????? ??????
    output reg done,
	output reg [2:0] state
);

    reg [WIDTH-1:0] array [0:SIZE-1]; // ?????????? ?????? ??? ??????????
    reg [WIDTH-1:0] key;
    reg [3:0] i, j; // ???????
  //  reg [2:0] state; // ????????? ????????

    // ????????? ????????
    localparam IDLE = 3'b000;
    localparam COPY = 3'b001;
    localparam SORT = 3'b010;
    localparam INSERT = 3'b011;
    localparam DONE = 3'b100;

    // ?????????????? ???????? ??????? ? ??????
    integer k; // ????????? ?????????? ??? ??????????????
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (k = 0; k < SIZE; k = k + 1) begin
                array[k] <= 0;
            end
            state <= IDLE;
            done <= 0;
            i <= 0;
            j <= 0;
            key <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        for (k = 0; k < SIZE; k = k + 1) begin
                            array[k] <= data_in[WIDTH*k +: WIDTH];
                        end
                        state <= COPY;
                    end
                end

                COPY: begin
                    i <= 1; // ???????? ? ??????? ????????
                    state <= SORT;
                end

                SORT: begin
                    if (i < SIZE) begin
                        key <= array[i];
                        j <= i - 1;
                        state <= INSERT;
                    end else begin
                        state <= DONE;
                    end
                end

                INSERT: begin
                    if (j >= 0 && array[j] > key) begin
                        array[j + 1] <= array[j];
                        j <= j - 1;
                    end else begin
                        array[j + 1] <= key;
                        i <= i + 1;
                        state <= SORT;
                    end
                end

                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
				default: begin
					done <= 0;
					state <= state;
				end
            endcase
        end
    end

    // ?????????????? ??????? ? ???????? ??????
    always @(posedge clk) begin
        if (state == DONE) begin
            for (k = 0; k < SIZE; k = k + 1) begin
                data_out[WIDTH*k +: WIDTH] <= array[k];
            end
        end
    end

endmodule
/*module insertion_sort #(
    parameter W = 8, // Ширина числа 
    parameter S  = 2  // Кол-во чисел
)(
    input wire clk,   
    input wire reset,  
	input wire start,  
    input wire [W*S-1:0] data_in, 
	
    output reg [W*S-1:0] data_out,
	output reg done
);

    reg [W-1:0] array [0:S-1];
    reg [3:0] i, j;                  
    //reg [W-1:0] key;    
	reg condition;                              

 	// Схема работает всегда, когда
	always @(posedge clk or posedge reset or posedge start)
	begin 
		if (reset)
		begin
			data_out <= 64'd0;
			done <= 1'b0;
		end
		else
		begin
			if (start)
			begin
				for (j = 0; j < S; j = j + 1)
				begin
					array[j] <= data_in[(j+1)*W-1 -: W];
				end
				done <= 1'b0;
				i <= 3'b0;
				j <= 3'b0;
				data_out <= data_in;
			end
			else if (clk)
			begin
				j <= i;
				while ((j > 3'd0) && (array[j-1] > array[i]))
				begin
					array[j] <= array[j-1];
					j <= j - 1;
				end
				array[j] <= array[i];
			end
		/*
			if (start)
			begin
				array <= data_in;
				data_out <= data_in;
				i <= 1;
				j <= i;
			end
			else if (clk)
			begin
				if (i < S) 
				begin
					
				//	condition = (array[i*WIDTH+:WIDTH] > array[j*WIDTH+:WIDTH]) && (j < i);
					while ((j > 0) && (array[(j-1)*W +: W] > array[i*W +: W]))
					begin
						j <= j - 1;
						//condition <= (j > 0) && (array[(j-1)*W+:W] > array[i*W+:W]);
				//		condition = (array[i*WIDTH +: WIDTH] > array[j*WIDTH +: WIDTH]) && (j < i);
					end
					
					//array[j*W + (W-1) : i
					
					data_out <= array;
					done <= 1'd0;
				end
				else
				begin
					data_out <= array;
					done <= 1'd1;
				end
				
			end
		
		end
	end
	
endmodule*/
