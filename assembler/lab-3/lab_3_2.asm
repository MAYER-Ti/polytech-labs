.model small
.stack 100h
.data 
A DB 0,1,2,3,4,5,6,7,8,9
B DB 10 DUP(0) ; ODh - ������� ������� ; OAh - ����� ������
.code
start:
; ��� ������ A � B
mov ax, @data
mov ds, ax
mov es, ax

; ����������� �� A � B
lea si, A
lea di, B
mov cx, 10
rep movsb

; ����� ����� B � si
lea si, B
; 10 ��������� B ���� ������
mov cx, 10

print_simbol:
mov al, [si]
; ��������� ���������
; = - ���� ���� ���� ZF
; < - ���� ���� SF != OF
; > - ���� ���� ZF = 0 � SF = OF
; != - ���� ���� ����� ZF
;cmp al, 0Dh
; jump equal
;JE  print_simbols_newline
; ������� � ������� ASCII ������ � al
add al, 30h
; ������ � dl ��� ������
mov dl, al
; ����� ������� DOS ��� ������ dl
mov ah, 02h
int 21h

inc si
loop print_simbol

;JMP end_program

print_simbols_newline:
; �������� �������� �� ������� DOS, ������� ������� ���� ������ �� dl
mov ah, 02h
; �������� ������ ����� ������
mov dl, 0Ah
; ���������� ��� ���������� �������� � ah
int 21h

; �������� �������� �� ������� DOS, ������� ������� ���� ������ �� dl
mov ah, 02h
; �������� ������ �������� ������� � ������ ������
mov dl, 0Dh
; ���������� ��� ���������� �������� � ah
int 21h

end_program:
; ���������� ���������
mov ah, 4ch
int 21h

end start