module DTrigger (
    output reg Result,
    input Data, 
    input Clock, 
    input Reset, 
    input Ewr
);
    always @(posedge Clock or posedge Reset) begin
        if (Reset)
            Result <= 0;  
        else if (!Ewr) 
            Result <= Data;
    end
endmodule
/*
// модуль D-триггер
 module DTrigger (Result, Data, Clock, Reset, Ewr);
	// определение параметров:
	// входных и выходных
	input Data, Clock, Reset, Ewr; //входные данные, тактовый сигнал,
 	// сброс, сигнал упрвления хранением-записью
 	output Result; // выход триггера
	// регистровые:
 	reg Res, Buf; // регистровые переменные

	// меняем состояние D - триггера, если меняется один из сигналов
 	always @(posedge Clock or posedge Reset)
 	begin
		// если RESET==1, то устанавливаем в ноль регистр Res
 		if (Reset)
 			Res = 0;
 		else
		// иначе:
 		begin
			// если Ewr==0, запись данных в регистр со входа Data
			// и в регистр Buf для временного хранения и перезаписи:
 			if (!Ewr)
 			begin
 				Res = Data;
 				Buf = Data;
 			end
 		else
			// если Ewr==1, то храним и перезаписываем из регистра Buf
 			Res = Buf;
 		end
 	end
	// подаем на выход тригерра содержимое регистровой переменной
	assign Result = !Res;
endmodule
// конец модуля
*/