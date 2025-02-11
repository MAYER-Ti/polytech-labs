.model	tiny ; huge
.stack	100h
.data
      baseMes DB 'Model: ', '$'
      mesTiny DB 'Tiny', '$'
      mesOther DB 'Other', '$'
      newline DB 0Dh, 0Ah, '$'
.code
start:
      mov ax,@data
      mov ds,ax

      ; � tiny ��� ��������� � ����� ��������
      mov bx, cs
      cmp ax, bx
      je printTiny
      
      
      jne printOther
      ; � small ��� � ������ ��������� � ������ ���������
      ; � medium ������ � ����� ��������, � ��� �������� �� ��������� ���������

      ; � compact ��� ��������� � ����� ��������, 
      ; � ������ ����� ���� ��������� �� ��������� ���������

      ; � large ��� � ������ ����� �������� ��������� ���������, 
      ; ����� ������������ �� 1 ��

      ; � huge ��� � large, ������ ������� ��������� ������ ������ 
      ; (��������� 64 ��)


      
printTiny:
      lea dx, baseMes
      mov ah, 09h
      int 21h             
      lea dx, mesTiny
      int 21h             
      jmp finish 
 
printOther:
      lea dx, baseMes
      mov ah, 09h
      int 21h             
      lea dx, mesOther
      int 21h             
  
finish:
      lea dx, newline
      int 21h      
      mov ax,4c00h
      int 21h
      
end	start