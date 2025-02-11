.model small
.stack 100h

.data
    array DW 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 
    value DW 15                             
    timer_start DW ?                       
    timer_end DW ?                          
    msg1 DB 'Direct Addressing Time: ', '$'
    msg2 DB 'Register Addressing Time: ', '$'
    msg3 DB 'InDirect register addressing Time: ', '$'
    msg4 DB 'Base Addressing Time: ', '$'
    msg5 DB 'Base index Addressing Time: ', '$'
    msg6 DB 'Base index Addressing Time with offset: ', '$'
    newline DB 0Dh, 0Ah, '$'

.code
start:
    
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; ===== Прямая адресация =====
    call rdtsc_start                         ; засечь начало измерения времени
    
    mov ax, [value]                            
    
    call rdtsc_end                           ; засечь конец измерения времени
    lea dx, msg1
    call print_string
    call print_time                          
    call print_newline

    ; ===== Регистровая адресация =====
    mov bx, 15
    call rdtsc_start
    
    mov ax, bx 
                                  
    call rdtsc_end
    lea dx, msg2
    call print_string
    call print_time
    call print_newline
    
    ; ===== Косвенно-регистровая адресация =====
    mov bx, value
    call rdtsc_start
    
    mov ax, [bx] 
                                  
    call rdtsc_end
    lea dx, msg2
    call print_string
    call print_time
    call print_newline

    ; ===== Базовая адресация =====
    lea bx, array
    call rdtsc_start
    
    mov ax, [bx+2]
    
    call rdtsc_end
    lea dx, msg3
    call print_string
    call print_time
    call print_newline

    ; ===== Базово-индексная адресация =====
    lea bx, array
    lea si, array
    call rdtsc_start
    
    mov ax, [bx+si]
    
    call rdtsc_end
    lea dx, msg3
    call print_string
    call print_time
    call print_newline

    ; ===== Базово-индексная адресация со смещением =====
    lea bx, array
    lea si, array
    call rdtsc_start
    
    mov ax, [bx+si+2]
    
    call rdtsc_end
    lea dx, msg3
    call print_string
    call print_time
    call print_newline


    ; ===== Завершение работы программы =====
    mov ah, 4Ch
    int 21h

; ===== Измерение времени =====
rdtsc_start:
    db 0Fh, 31h                              ; команда RDTSC
    mov word ptr timer_start, ax             ; word ptr - взять слово вместо байта
    ret                                      ; возвращение назад

rdtsc_end:
    db 0Fh, 31h                              
    mov word ptr timer_end, ax
    ret

; ===== Вывод времени =====
print_time:
    mov ax, timer_end
    sub ax, timer_start                      
    call print_number                        
    ret

; ===== Вывод строки =====
print_string:
    mov ah, 09h     ; вывод строки с адреса в dx до '$' 
    int 21h
    ret

; ===== Напечатать число =====
print_number:
    ; ?????????????? ????? ? ?????? ? ?????
    mov bx, 0                               ; счетчик цифр
    mov cx, 10                               ; делитель
convert_loop:
    mov dx, 0                                ; поготовить для остатка DX
    div cx                                   ; AX / 10, остаток в DX
    push dx                                  ; полученную цифру в стек
    inc bx                                   ; увеличить счетчик цифр
    test ax, ax                              ; Если ax = 0, все цифры извлечены
    jz output_digits
    jmp convert_loop
output_digits:
    pop dx                                   ; взять цифру из стека
    add dl, '0'                              ; преобразовать в ASCII
    mov ah, 02h                              ; Вывод символа
    int 21h
    dec bx                                   ; Уменьшить счетчик цифр
    jnz output_digits                        ; Пока не 0
    ret

; ===== Вывод новой строки =====
print_newline:
    lea dx, newline
    call print_string
    ret

end start
