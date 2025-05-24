.model  small
.stack  100h

.data
   newline db 0Dh, 0Ah, '$'
   text_msg db "Text: ", 0Dh, 0Ah, '$' 
   input_msg db "Print order rows: ",'$'
   error_msg db "Invalid input! example: 13245", 0Dh, 0Ah,'$'
   help_msg db "To exit program just press enter", 0Dh, 0Ah, '$'
    
   rows  db "1) sample row1 to example text", 0Dh, 0Ah, '$'   ; ������ ������
         db "2) row2 example text          ", 0Dh, 0Ah, '$'   ; ��� ������
         db "3) text for example row3      ", 0Dh, 0Ah, '$'
         db "4) example text for row4      ", 0Dh, 0Ah, '$'
         db "5) last row5 for example text ", 0Dh, 0Ah, '$'
         db "6) Six row in the example text", 0Dh, 0Ah, '$'
         db "7) Seven is sum one and six   ", 0Dh, 0Ah, '$'
         db "7) Seven is sum one and six   ", 0Dh, 0Ah, '$'
         
   row_len equ 33          ; ������ ������
   row_count equ 7         ; ���-�� ����� � ������
   buffer db "00000", '$'  ; ����� ��� ������ �����
.code


mPrintString MACRO string
; ������ ������ ������ �� ������� '$'
   lea dx, string
   mov ah, 9
   int 21h
endm

mPrintChar MACRO char
; ������ ������ �������
   mov dl, char
   mov ah, 02h
   int 21h
endm

mInputString MACRO string_, string_len_
; ������ ����� ������ � ����� � �������� ������� 
   mov ah, 0Ah
   mov al, byte ptr string_len_
   add al, 1
   mov byte ptr string_, al   ; ������ �����
   lea dx, string_
   int 21h
endm

mPrintRows MACRO rows_, row_len_, row_count_
   local loopPrintRows
; ������ ������ ����� ������ ���������
; ��������� ������ �����, ������ ������ � ���������� �����
   
   mov cx, row_count_
   mov si, 1
loopPrintRows:
   ;push si
   
   mPrintRow rows_, row_len_, si
   
   ;pop si
   add si, 1
   loop loopPrintRows
endm

mPrintRow MACRO rows_, row_len_, row_index_
; ������ ������ ����� ������ �� ������ ������ ������� � �������
; ��������� ������ �����, ������ ������ � ����� ������ ��� ������ 
   mov bx, row_len_                       ; ����� ������
   mov ax, row_index_                     ; ����� ������ ��� ������
   sub ax, 1                              ; ������ ������ � ����   
   mul bx                                 ; �������� ������ ������ �� ������ ������  
   mov bx, ax
   mPrintString rows_[bx]                 ; ������� ������ �� �������
endm

mEndProgram MACRO
    mov ah, 4Ch
    int 21h
endm

start:

   mov ax, @data
   mov ds, ax
   mov es, ax
   
startProgram:

   mPrintString newline                   ;������� �� ����� ������
   mPrintString text_msg                  ;��������� � ������
   mPrintString newline                   ;������� �� ����� ������
   
   mPrintRows rows, row_len, row_count    ;����� ������
   mPrintString newline                   ;������� ������
   
   mPrintString input_msg                 ;����������� ��� ����� ������� �����
   mInputString buffer, row_count         ;���� ������� ����� � ������
   mPrintString newline                   ;������� ������

   mov al, buffer[1]                      ;���� ���� ������ - ����� ���������
   cmp al, 0
   je endProgram
   xor ah, ah
   mov cx, ax
   lea si, buffer
   add si, 2
   
loopBuf:                                  ;�������� �� ������� ���������� �������
   xor ax, ax
   mov al, [si]                           ;�������� ������ ������� ���� 
   cmp ax, '0'
   jl error
   mov bx, row_count
   add bx, 30h
   cmp ax, bx                             ;�������� ������ ������� ���������� �����
   jg error
   
   sub ax, 30h                            ;��������� �� ASCII � �����  
   
   mPrintRow rows, row_len, ax            ;���������� ������ ������ �� ������
   add si, 1
   loop loopBuf
   
   jmp startProgram
   
error:
   mPrintString newline
   mPrintString error_msg                 ;����� ��������� � ������������ �����
   mPrintString help_msg                  ;����� ���������
   jmp startProgram
     
endProgram:                               ;���������� ���������
  mEndProgram
end start