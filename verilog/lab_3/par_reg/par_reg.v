module par_reg (OUTRESULT, EWR, CLOCK, RESET, DATA, EDY);

	// ���������� ���������:
	 parameter numbits=7; // ����������� ������
	// ���������� ������ � �������:
	// ��������������:
 	input [numbits:0] DATA; // ������
	// �������������:
 	input EWR, CLOCK, RESET, EDY; //��������-������, �������������, �����,
 	//���������� ������ � ������
	// ��������:
 	output [numbits:0] OUTRESULT;
	// �����������:
 	reg [numbits:0] res;
 	wire[numbits:0] Res;
    // �������������:
	integer i;
	// ����� ������� Dtrigger:
 	DTrigger Dtrig1 (Res[1], DATA[1], CLOCK, RESET, EWR);
 	DTrigger Dtrig2 (Res[2], DATA[2], CLOCK, RESET, EWR);
 	DTrigger Dtrig3 (Res[3], DATA[3], CLOCK, RESET, EWR);
 	DTrigger Dtrig4 (Res[4], DATA[4], CLOCK, RESET, EWR);
 	DTrigger Dtrig5 (Res[5], DATA[5], CLOCK, RESET, EWR);
 	DTrigger Dtrig6 (Res[6], DATA[6], CLOCK, RESET, EWR);
 	DTrigger Dtrig7 (Res[7], DATA[7], CLOCK, RESET, EWR);
	// ���� �������� ���� �� ����������, ��
 	always @ (RESET or CLOCK)
 	begin
		// ���� RESET==1, �� ����� � 0 ��������� ��������
 		if (RESET)
 			for (i=0; i<=7; i=i+1)
 				res[i] = 0;
 		else
		// ����� -
 			begin
				//���� ��� ������ � 0 � �������� �����, ��
				//������ ����� D-�������� (����� � �������)
 				if (~EDY)
 					res = ~Res;
				// ����� - ����� ������:
 				else res = 'bx;
				
 			end
	end
// ��������� ��������� �� �����:
 assign OUTRESULT = res;
endmodule