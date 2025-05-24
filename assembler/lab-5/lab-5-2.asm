.model  small
.stack 100h

.data
  
    num1_low  dw 5677h ; ������� ����� ������� �����
    num1_high dw 1234h ; ������� ����� ������� �����
    num2_low  dw 5676h ; ������� ����� ������� �����
    num2_high dw 1234h ; ������� ����� ������� �����
    
    msg_equal db 'Numbers are equal', 0Dh, 0Ah, '$'
    msg_greater db 'First number is greater', 0Dh, 0Ah, '$'
    msg_less db 'Second number is greater', 0Dh, 0Ah, '$'
.code
; �������, ��� ���������� ������� 286
.286
start:
    ; ������ �������� ������
    mov ax, @data
    mov ds, ax 

    ; ==== �������� ����� ���������� ���������� ====
    call CompareGlobals
    
    ; �������� ���������� ������ ����� ���������
    je NumbersEqualGlobals       ; �����
    jg FirstIsGreaterGlobals     ; ������
    jl SecondIsGreaterGlobals    ; ������
    
NumbersEqualGlobals:
    lea dx, msg_equal
    jmp PrintGlobals
FirstIsGreaterGlobals:
    lea dx, msg_greater
    jmp PrintGlobals
SecondIsGreaterGlobals:
    lea dx, msg_less
PrintGlobals:
    ; ����� ���������
    mov ah, 09h
    int 21h
    
    
    ; ==== �������� ����� �������� ====
    mov ax, num1_low
    mov bx, num1_high
    mov cx, num2_low
    mov dx, num2_high
    
    call CompareUsingRegisters
    

    ; ==== �������� ����� ���� ====
    ; ������ ���� ����� long long (�� ��� �����)
    push word ptr 1234h ; ������� ����� ������� �����
    push word ptr 5676h ; ������� ����� ������� �����
    
    push word ptr 1234h ; ������� ����� ������� �����
    push word ptr 5676h ; ������� ����� ������� �����

    ; ����� ������������ ���������
    call CompareLongs
    
    ; �������� ���������� ������ ����� ���������
    je NumbersEqual       ; �����
    jg FirstIsGreater     ; ������
    jl SecondIsGreater    ; ������

NumbersEqual:
    lea dx, msg_equal
    jmp Print
FirstIsGreater:
    lea dx, msg_greater
    jmp Print
SecondIsGreater:
    lea dx, msg_less
Print:
    ; ����� ���������
    mov ah, 09h
    int 21h
    
    ; ==== �������� ����� �������� ====
    mov ax, num1_low
    mov bx, num1_high
    mov cx, num2_low
    mov dx, num2_high
    call CompareUsingRegisters

    
    je NumbersEqualReg
    jg FirstIsGreaterReg
    jl SecondIsGreaterReg

NumbersEqualReg:
    lea dx, msg_equal
    jmp PrintReg
FirstIsGreaterReg:
    lea dx, msg_greater
    jmp PrintReg
SecondIsGreaterReg:
    lea dx, msg_less

PrintReg:
    mov ah, 09h
    int 21h
    
        
    ; ���������� ���������
    mov ah, 4Ch
    int 21h

; ==== ������������ ��������� ���� ����� long long ���� ====
; ������ ��������� ������� ����� � �����
CompareLongs proc
    ; �������� ��������� �����
    enter 0, 0
    ; �������� ���� ������:
    ; ��������� �������,
    ; ����� ��������, 
    ; ������� ��������� bp (��������� �� �������� ���� ���������� �������)
    ; ��������� ����������
    ; ��� ������������ ��� ��������� ������
    
    ; ��������� �������� ��������� ����� ��������������
    push ax
    push dx
    push bx
    push cx
    
    push ds
    mov ax, @data
    mov ds, ax

    ; ���������� ����� �� �����
    mov ax, [bp+4]       ; ������� ����� ������� �����
    mov dx, [bp+6]       ; ������� ����� ������� �����
    mov bx, [bp+8]       ; ������� ����� ������� �����
    mov cx, [bp+10]      ; ������� ����� ������� �����

    ; ��������� ������� ����
    cmp cx, dx           
    jne CompareEnd        ; ���� �� �����

    ; ��������� ������� ����
    cmp bx, ax
CompareEnd:
    
    ; ������� �������� ��������� ����� �������������
    pop cx
    pop bx
    pop dx
    pop ax
    
    ; ������������ �������� sp = bp
    ; ������������ ���������� �������� bp, ���������� � �������� �����
    leave ; ������� ������� �������� ����              
    ret 8               ; ������� ��������� �� ����� (4 ����� �� 2 �����)
CompareLongs endp       ; ������ �������� ��� ����� (�����), ��������� - ������


; === ������������ �������� �������� ����� ���������� ����������  ===
CompareGlobals PROC
    enter 0, 0
    mov ax, num1_high
    cmp ax, num2_high
    jne CompareEndGlobals

    mov ax, num1_low
    cmp ax, num2_low
CompareEndGlobals:
    leave
    ret
CompareGlobals ENDP

; === ������������ ��������� ����� �������� ===
; AX � ������� ����� ������� �����
; BX � ������� ����� ������� �����
; CX � ������� ����� ������� �����
; DX � ������� ����� ������� �����
CompareUsingRegisters PROC
    enter 0, 0
    ; ��������� ������� ����
    cmp bx, dx
    jne CompareEndRegisters

    ; ��������� ������� ����
    cmp ax, cx
CompareEndRegisters:
    leave
    ret
CompareUsingRegisters ENDP

end start
