.model	small
.stack	100h
.data
    a DW 1234h, 5678h       ; �������� ������ (low, high)
    b_stack DW 0, 0         ; ��������� (low, high) ����� ����
    b_regs DW 0, 0          ; ��������� (low, high) ����� ��������
    b_global DW 0, 0        ; ��������� (low, high) ����� ���������� ����������
    shiftCount DW 3         ; ���������� ����� ��� ������
    mesStack DB "Result (Stack): $"
    mesRegs DB "Result (Regs): $"
    mesGlobal DB "Result (Global): $"
    decimalBuffer DB 21 dup(0), '$' ; ����� ��� �������� ������ �����
.code
start:
    mov ax,@data
    mov	ds,ax
    xor	ax,ax

    ; ====== ����� ������������ c ��������� ���������� ����� ���� ======
    lea ax, a               ; ����� ����� a (������ ��������)
    push ax
    lea ax, b_stack         ; ����� ����� b_stack (������ ��������)
    push ax
    mov ax, shiftCount      ; ���������� ����� ������ (������ ��������)
    push ax
    call LogicalShiftLeftStack
    
    ; ����� ��������� 
    lea dx, mesStack
    mov ah, 09h
    int 21h
    
    ; ����� ���������� ������
    mov ax, [b_stack]
    mov dx, [b_stack+4]
    call PrintLongLongDecimal
    
                      
    ; ���������� ���������
    mov	ax,4c00h
    int	21h


; ====== ������������ � ����������� ����� ���� ======
LogicalShiftLeftStack proc
    push bp             ; ��������� BP
    mov bp, sp          ; ��������� �������� ����
    ; �������� ���� ������:
    ; ��������� �������,
    ; ����� ��������, 
    ; ������� ��������� bp (��������� �� �������� ���� ���������� �������)
    ; ��������� ����������
    ; ��� ������������ ��� ��������� ������

    ; ��������� ����������
                        ; [bp+0] ��������� �� ����������� ������ bp
                        ; [bp+2] ��������� �� ����������� ����� ��������
    mov cx, [bp+4]      ; ���������� �������
    mov si, [bp+6]      ; ����� a
    mov di, [bp+8]      ; ����� b_stack

    ; ���������� ������
    mov ax, [si]        ; ������� ��� �����(�����) a
    mov dx, [si+2]      ; ������� ��� �����(�����) a

    push cx
    call ShiftLeftManual
    pop cx

    ; ���������� ����������
    mov [di], ax        ; �������� ������� ����� � b
    mov [di+2], dx      ; �������� ������� ����� � b

    pop bp              ; ������������ BP
    ret
LogicalShiftLeftStack endp

; ====== ������������ � ����������� ����� �������� ======
LogicalShiftLeftRegs proc
    ; ���������� ������
    mov ax, [si]        ; ������� ��� �����(�����) a
    mov dx, [si+2]      ; ������� ��� �����(�����) a

    push cx
    call ShiftLeftManual
    pop cx          ; �������� ������� �����

    ; ���������� ����������
    mov [di], ax        ; �������� ������� ����� � b
    mov [di+2], dx      ; �������� ������� ����� � b

    ret
LogicalShiftLeftRegs endp

; ====== ������������ � ����������� ����� ���������� ���������� ======
LogicalShiftLeftGlobal proc
    ; ���������� ������
    mov ax, [si]        ; ������� ��� �����(�����) a
    mov dx, [si+2]      ; ������� ��� �����(�����) a

    push cx
    call ShiftLeftManual
    pop cx

    ; ���������� ����������
    mov b_global, ax        ; �������� ������� ����� � b
    mov b_global+2, dx      ; �������� ������� ����� � b

    ret
LogicalShiftLeftGlobal endp

ShiftLeftManual proc
    ; ����: AX � ������� �����, DX � ������� �����, CL � ���������� �������
    ; �����: AX � DX �������� ����� �� CL ���
    push cx
    push bx

    mov bx, cx          ; ��������� ���������� �������
ShiftLoop:
    shl ax, 1           ; �������� ������� ����� �����
    rcl dx, 1           ; �������� ������� ����� � ������ ��������
    dec bx              ; ????????? ??????? ???????
    jnz ShiftLoop       ; ?????????, ???? BX != 0

    pop bx
    pop cx
    ret
ShiftLeftManual endp

; ====== ???????????? ?????? 64-??????? ????? ? ?????????? ??????? ======
PrintLongLongDecimal proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    lea si, decimalBuffer + 20    ; ????????? ?? ????? ??????
    mov di, si

    xor cx, cx                  ; ???????? ??????? ??? ???????? ????
    mov bx, 10                  ; ???????? (10 ??? ?????????? ???????)

PrintDecimalLoop:
    xor dx, dx                  ; ???????? ??????? 16 ??? ??? ???????
    div bx                      ; ????? DX:AX ?? BX (10)
    add dl, '0'                 ; ????????????? ????? ? ASCII
    dec si                      ; ???????? ?????????
    mov [si], dl  
    or  ax, ax
    jnz PrintDecimalLoop
    
    ; ????? ????? ?? ?????
    lea dx, [si]
    mov ah, 09h
    int 21h

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PrintLongLongDecimal endp
end start