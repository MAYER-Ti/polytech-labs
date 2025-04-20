module insertion_sorter (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in_0, data_in_1, data_in_2, data_in_3,
    output reg done,
    output reg [7:0] data_out_0, data_out_1, data_out_2, data_out_3,
	inout reg [2:0] state
);

parameter [2:0] 
    IDLE = 3'b000,
    LOAD = 3'b001,
    SORT_OUTER = 3'b010,
    SORT_INNER = 3'b011,
    DONE = 3'b100;

reg [7:0] array [0:3];
reg [7:0] key;
reg [1:0] i, j;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        done <= 1'b0;
        array[0] <= 8'b0;
        array[1] <= 8'b0;
        array[2] <= 8'b0;
        array[3] <= 8'b0;
        data_out_0 <= 8'b0;
        data_out_1 <= 8'b0;
        data_out_2 <= 8'b0;
        data_out_3 <= 8'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= LOAD;
                    done <= 1'b0;
                end
            end
            
            LOAD: begin
                array[0] <= data_in_0;
                array[1] <= data_in_1;
                array[2] <= data_in_2;
                array[3] <= data_in_3;
                i <= 2'b01; // ???????? ? 1-?? ????????
                state <= SORT_OUTER;
            end
            
            SORT_OUTER: begin
                if (i != 2'b11) begin // ???????? ??????? ?? i != 3
                    key <= array[i];
                    j <= i - 1'b1;
                    state <= SORT_INNER;
                end
                else begin
                    // ???????????? ????????? ??????? (i=3)
                    key <= array[3];
                    j <= 2'b10; // j = 2
                    state <= SORT_INNER;
                end
            end
            
            SORT_INNER: begin
                if (j != 2'b11 && array[j] > key) begin // j != 3 (???????? ?? ?????????)
                    array[j + 1'b1] <= array[j];
                    j <= j - 1'b1;
                end
                else begin
                    array[j + 1'b1] <= key;
                    if (i == 2'b11) begin // ???? ??? ???? ????????? ????????
                        state <= DONE;
                    end
                    else begin
                        i <= i + 1'b1;
                        state <= SORT_OUTER;
                    end
                end
            end
            
            DONE: begin
                data_out_0 <= array[0];
                data_out_1 <= array[1];
                data_out_2 <= array[2];
                data_out_3 <= array[3];
                done <= 1'b1;
                state <= IDLE;
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule