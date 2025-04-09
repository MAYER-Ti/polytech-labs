module par_reg (
    output [7:0] OUTRESULT,  
    input EWR, 
    input CLOCK, 
    input RESET, 
    input [7:0] DATA, 
    input EDY
);

    wire [7:0] Res;  
    reg [7:0] res;  

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dtrig_gen
            DTrigger Dtrig (
                .Result(Res[i]),
                .Data(DATA[i]),
                .Clock(CLOCK),
                .Reset(RESET),
                .Ewr(EWR)
            );
        end
    endgenerate

    always @(posedge CLOCK or posedge RESET) begin
        if (RESET)
            res <= 8'b0;  
        else if (!EDY)   
            res <= Res;   
        else
            res <= 8'bz;
    end

    assign OUTRESULT = res;
endmodule

/*
module par_reg (OUTRESULT, EWR, CLOCK, RESET, DATA, EDY);

	// объ€вление параметра:
	 parameter numbits=7; // разр€дность портов
	// объ€вление входов и выходов:
	// многоразр€дных:
 	input [numbits:0] DATA; // данные
	// одноразр€дных:
 	input EWR, CLOCK, RESET, EDY; //хранение-запись, синхронизаци€, сброс,
 	//разрешение чтени€ с выхода
	// выходных:
 	output [numbits:0] OUTRESULT;
	// регистровых:
 	reg [numbits:0] res;
 	wire[numbits:0] Res;
    // целочисленных:
	integer i;
	// вызов модулей Dtrigger:
 	DTrigger Dtrig1 (Res[1], DATA[1], CLOCK, RESET, EWR);
 	DTrigger Dtrig2 (Res[2], DATA[2], CLOCK, RESET, EWR);
 	DTrigger Dtrig3 (Res[3], DATA[3], CLOCK, RESET, EWR);
 	DTrigger Dtrig4 (Res[4], DATA[4], CLOCK, RESET, EWR);
 	DTrigger Dtrig5 (Res[5], DATA[5], CLOCK, RESET, EWR);
 	DTrigger Dtrig6 (Res[6], DATA[6], CLOCK, RESET, EWR);
 	DTrigger Dtrig7 (Res[7], DATA[7], CLOCK, RESET, EWR);
	// ≈сли мен€етс€ одна из переменных, то
 	always @ (posedge RESET or posedge CLOCK)
 	begin
		// если RESET==1, то сброс в 0 буферного регистра
 		if (RESET)
 			for (i=0; i<=7; i=i+1)
 				res[i] = 0;
 		else
		// иначе -
 			begin
				//если нет сброса в 0 и разрешен выход, то
				//читаем выход D-триггера (пишем в регистр)
 				if (~EDY)
 					res = ~Res;
				// иначе - выход заперт:
 				else res = 'bx;
				
 			end
	end
// назначаем результат на выход:
 assign OUTRESULT = res;
endmodule
*/