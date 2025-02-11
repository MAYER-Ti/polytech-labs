.model small
.stack 100h

.data
    array DW 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 
    value DW 15                             
    timer_start DW ?                       
    timer_end DW ?                          
    msg1 DB 'mov ax, 12 : ', '$'
    msg2 DB 'mov ax, bx : ', '$'
    msg3 DB 'mov ax, [bx] : ', '$'
    msg4 DB 'mov ax, [bx+2] : ', '$'
    msg5 DB 'mov ax, [bx+si] : ', '$'
    msg6 DB 'mov ax, [bx+si+2] : ', '$'
    newline DB 0Dh, 0Ah, '$'

.code
start:
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; ===== ���������������� ��������� =====
    call rdtsc_start                         ; ������ ������ ��������� �������
    
    mov ax, 12                            
    
    call rdtsc_end                           ; ������ ����� ��������� �������
    lea dx, msg1
    call print_string
    call print_time                          
    call print_newline

    ; ===== ����������� ��������� =====
    mov bx, 15
    call rdtsc_start
    
    mov ax, bx 
                                  
    call rdtsc_end
    lea dx, msg2
    call print_string
    call print_time
    call print_newline
    
    ; ===== ��������-����������� ��������� =====
    mov bx, value
    call rdtsc_start
    
    mov ax, [bx] 
                                  
    call rdtsc_end
    lea dx, msg3
    call print_string
    call print_time
    call print_newline

    ; ===== ������� ��������� =====
    lea bx, array
    call rdtsc_start
    
    mov ax, [bx+2]
    
    call rdtsc_end
    lea dx, msg4
    call print_string
    call print_time
    call print_newline

    ; ===== ������-��������� ��������� =====
    lea bx, array
    lea si, array
    call rdtsc_start
    
    mov ax, [bx+si]
    
    call rdtsc_end
    lea dx, msg5
    call print_string
    call print_time
    call print_newline

    ; ===== ������-��������� ��������� �� ��������� =====
    lea bx, array
    lea si, array
    call rdtsc_start
    
    mov ax, [bx+si+2]
    
    call rdtsc_end
    lea dx, msg6
    call print_string
    call print_time
    call print_newline


    ; ===== ���������� ������ ��������� =====
    mov ah, 4Ch
    int 21h

; ===== ��������� ������� =====
rdtsc_start:
    db 0Fh, 31h                              ; ������� RDTSC
    mov word ptr timer_start, ax             ; word ptr - ����� ����� ������ �����
    ret                                      ; ����������� �����

rdtsc_end:
    db 0Fh, 31h                              
    mov word ptr timer_end, ax
    ret

; ===== ����� ������� =====
print_time:
    mov ax, timer_end
    sub ax, timer_start                      
    call print_number                        
    ret

; ===== ����� ������ =====
print_string:
    mov ah, 09h     ; ����� ������ � ������ � dx �� '$' 
    int 21h
    ret

; ===== ���������� ����� =====
print_number:
    mov bx, 0                               ; ������� ����
    mov cx, 10                               ; ��������
convert_loop:
    mov dx, 0                                ; ���������� ��� ������� DX
    div cx                                   ; AX / 10, ������� � DX
    push dx                                  ; ���������� ����� � ����
    inc bx                                   ; ��������� ������� ����
    test ax, ax                              ; ���� ax = 0, ��� ����� ���������
    jz output_digits
    jmp convert_loop
output_digits:
    pop dx                                   ; ����� ����� �� �����
    add dl, '0'                              ; ������������� � ASCII
    mov ah, 02h                              ; ����� �������
    int 21h
    dec bx                                   ; ��������� ������� ����
    jnz output_digits                        ; ���� �� 0
    ret

; ===== ����� ����� ������ =====
print_newline:
    lea dx, newline
    call print_string
    ret

end start
