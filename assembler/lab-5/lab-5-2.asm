.model  small
.stack 100h

.data
  
    num1_low  dw 5677h ; младшее слово первого числа
    num1_high dw 1234h ; старшее слово первого числа
    num2_low  dw 5676h ; младшее слово второго числа
    num2_high dw 1234h ; старшее слово второго числа
    
    msg_equal db 'Numbers are equal', 0Dh, 0Ah, '$'
    msg_greater db 'First number is greater', 0Dh, 0Ah, '$'
    msg_less db 'Second number is greater', 0Dh, 0Ah, '$'
.code
; Указать, что используем команды 286
.286
start:
    ; запись сегмента памяти
    mov ax, @data
    mov ds, ax 

    ; ==== Передача через глобальные переменные ====
    call CompareGlobals
    
    ; проверка полученных флагов после сравнения
    je NumbersEqualGlobals       ; равны
    jg FirstIsGreaterGlobals     ; больше
    jl SecondIsGreaterGlobals    ; меньше
    
NumbersEqualGlobals:
    lea dx, msg_equal
    jmp PrintGlobals
FirstIsGreaterGlobals:
    lea dx, msg_greater
    jmp PrintGlobals
SecondIsGreaterGlobals:
    lea dx, msg_less
PrintGlobals:
    ; вывод сообщения
    mov ah, 09h
    int 21h
    
    
    ; ==== Передача через регистры ====
    mov ax, num1_low
    mov bx, num1_high
    mov cx, num2_low
    mov dx, num2_high
    
    call CompareUsingRegisters
    

    ; ==== Передача через стек ====
    ; запись двух чисел long long (по два слова)
    push word ptr 1234h ; старшее слово первого числа
    push word ptr 5676h ; младшее слово первого числа
    
    push word ptr 1234h ; старшее слово второго числа
    push word ptr 5676h ; младшее слово второго числа

    ; вызов подпрограммы сравнения
    call CompareLongs
    
    ; проверка полученных флагов после сравнения
    je NumbersEqual       ; равны
    jg FirstIsGreater     ; больше
    jl SecondIsGreater    ; меньше

NumbersEqual:
    lea dx, msg_equal
    jmp Print
FirstIsGreater:
    lea dx, msg_greater
    jmp Print
SecondIsGreater:
    lea dx, msg_less
Print:
    ; вывод сообщения
    mov ah, 09h
    int 21h
    
    ; ==== Передача через регистры ====
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
    
        
    ; завершение программы
    mov ah, 4Ch
    int 21h

; ==== Подпрограмма сравнения двух чисел long long стек ====
; адреса операндов функции лежат в стеке
CompareLongs proc
    ; создание стекового кадра
    enter 0, 0
    ; стековый кадр хранит:
    ; параметры функций,
    ; адрес возврата, 
    ; базовый указатель bp (указывало на стековый кадр вызывающей функции)
    ; локальные переменные
    ; доп пространство для временных данных
    
    ; сохранить значения регистров перед использованием
    push ax
    push dx
    push bx
    push cx
    
    push ds
    mov ax, @data
    mov ds, ax

    ; извлечение чисел из стека
    mov ax, [bp+4]       ; младшее слово второго числа
    mov dx, [bp+6]       ; старшее слово второго числа
    mov bx, [bp+8]       ; младшее слово первого числа
    mov cx, [bp+10]      ; старшее слово первого числа

    ; сравнение старших слов
    cmp cx, dx           
    jne CompareEnd        ; если не равны

    ; сравнение младших слов
    cmp bx, ax
CompareEnd:
    
    ; вернуть занчения регистров после использования
    pop cx
    pop bx
    pop dx
    pop ax
    
    ; Восстановить значение sp = bp
    ; Восстановить предыдущее значение bp, записанное в стековом кадре
    leave ; Удалить текущий стековый кадр              
    ret 8               ; удаляем параметры из стека (4 слова по 2 байта)
CompareLongs endp       ; адреса размером два байта (слово), параметры - адреса


; === Подпрограмма передачи значений через глобальные переменные  ===
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

; === Подпрограмма сравнения через регистры ===
; AX — младшее слово первого числа
; BX — старшее слово первого числа
; CX — младшее слово второго числа
; DX — старшее слово второго числа
CompareUsingRegisters PROC
    enter 0, 0
    ; Сравнение старших слов
    cmp bx, dx
    jne CompareEndRegisters

    ; Сравнение младших слов
    cmp ax, cx
CompareEndRegisters:
    leave
    ret
CompareUsingRegisters ENDP

end start
