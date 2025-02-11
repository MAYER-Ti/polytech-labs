.model	small
.stack	100h
.data
    a DW 1234h, 5678h       ; Исходные данные (low, high)
    b_stack DW 0, 0         ; Результат (low, high) через стек
    b_regs DW 0, 0          ; Результат (low, high) через регистры
    b_global DW 0, 0        ; Результат (low, high) через глобальные переменные
    shiftCount DW 3         ; Количество битов для сдвига
    mesStack DB "Result (Stack): $"
    mesRegs DB "Result (Regs): $"
    mesGlobal DB "Result (Global): $"
    decimalBuffer DB 21 dup(0), '$' ; Буфер для хранения строки числа
.code
start:
    mov ax,@data
    mov	ds,ax
    xor	ax,ax

    ; ====== Вызов подпрограммы c передачей аргументов через стек ======
    lea ax, a               ; взять адрес a (третий аргумент)
    push ax
    lea ax, b_stack         ; взять адрес b_stack (второй аргумент)
    push ax
    mov ax, shiftCount      ; количество битов сдвига (третий аргумент)
    push ax
    call LogicalShiftLeftStack
    
    ; вывод сообщения 
    lea dx, mesStack
    mov ah, 09h
    int 21h
    
    ; вывод полученных данных
    mov ax, [b_stack]
    mov dx, [b_stack+4]
    call PrintLongLongDecimal
    
                      
    ; Завершение программы
    mov	ax,4c00h
    int	21h


; ====== Подпрограмма с аргументами через стек ======
LogicalShiftLeftStack proc
    push bp             ; Сохранить BP
    mov bp, sp          ; Настроить стековый кадр
    ; стековый кадр хранит:
    ; параметры функций,
    ; адрес возврата, 
    ; базовый указатель bp (указывало на стековый кадр вызывающей функции)
    ; локальные переменные
    ; доп пространство для временных данных

    ; получение аргументов
                        ; [bp+0] указывает на сохраненный старый bp
                        ; [bp+2] указывает на сохраненный адрес возврата
    mov cx, [bp+4]      ; количество сдвигов
    mov si, [bp+6]      ; адрес a
    mov di, [bp+8]      ; адрес b_stack

    ; выполнение сдвига
    mov ax, [si]        ; Младшие два байта(слово) a
    mov dx, [si+2]      ; Старшие два байта(слово) a

    push cx
    call ShiftLeftManual
    pop cx

    ; Сохранение результата
    mov [di], ax        ; Записать младшее слово в b
    mov [di+2], dx      ; Записать старшее слово в b

    pop bp              ; Восстановить BP
    ret
LogicalShiftLeftStack endp

; ====== Подпрограмма с аргументами через регистры ======
LogicalShiftLeftRegs proc
    ; выполнение сдвига
    mov ax, [si]        ; младшие два байта(слово) a
    mov dx, [si+2]      ; старшие два байта(слово) a

    push cx
    call ShiftLeftManual
    pop cx          ; Сдвинуть младшее слово

    ; Сохранение результата
    mov [di], ax        ; записать младшее слово в b
    mov [di+2], dx      ; записать старшее слово в b

    ret
LogicalShiftLeftRegs endp

; ====== Подпрограмма с аргументами через глобальные переменные ======
LogicalShiftLeftGlobal proc
    ; выполнение сдвига
    mov ax, [si]        ; младшие два байта(слово) a
    mov dx, [si+2]      ; старшие два байта(слово) a

    push cx
    call ShiftLeftManual
    pop cx

    ; Сохранение результата
    mov b_global, ax        ; записать младшее слово в b
    mov b_global+2, dx      ; записать старшее слово в b

    ret
LogicalShiftLeftGlobal endp

ShiftLeftManual proc
    ; Вход: AX — младшее слово, DX — старшее слово, CL — количество сдвигов
    ; Выход: AX и DX сдвинуты влево на CL бит
    push cx
    push bx

    mov bx, cx          ; сохранить количество сдвигов
ShiftLoop:
    shl ax, 1           ; Сдвинуть младшее слово влево
    rcl dx, 1           ; Сдвинуть старшее слово с учетом переноса
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