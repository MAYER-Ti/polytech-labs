.model	small
.stack	100h
.data
Hello DB "Hello, world!", 0Dh, 0Ah,'$'
.code
start:
; ��� ������ A � B
mov ax, @data
mov ds, ax
mov es, ax
; �������� �������� �� ������� DOS, ������� ������� ������,
; �������� � dx, ����������� ����� ��������� $
mov	ah,9
lea     dx, Hello
int     21h

; ���������� ���������
mov ah, 4ch
int 21h
end	start