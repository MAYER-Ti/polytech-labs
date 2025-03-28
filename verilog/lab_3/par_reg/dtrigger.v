// ������ D-�������
 module DTrigger (Result, Data, Clock, Reset, Ewr);
	// ����������� ����������:
	// ������� � ��������
	input Data, Clock, Reset, Ewr; //������� ������, �������� ������,
 	// �����, ������ ��������� ���������-�������
 	output Result; // ����� ��������
	// �����������:
 	reg Res, Buf; // ����������� ����������

	// ������ ��������� D - ��������, ���� �������� ���� �� ��������
 	always @(Clock or Reset or Ewr)
 	begin
		// ���� RESET==1, �� ������������� � ���� ������� Res
 		if (Reset)
 			Res = 0;
 		else
		// �����:
 		begin
			// ���� Ewr==0, ������ ������ � ������� �� ����� Data
			// � � ������� Buf ��� ���������� �������� � ����������:
 			if (!Ewr)
 			begin
 				Res = Data;
 				Buf = Data;
 			end
 		else
			// ���� Ewr==1, �� ������ � �������������� �� �������� Buf
 			Res = Buf;
 		end
 	end
	// ������ �� ����� �������� ���������� ����������� ����������
	assign Result = !Res;
endmodule
// ����� ������