%macro mPrintString 1
    ; Вывод строки (длина вычисляется автоматически)
    xor rdx, rdx        ; Обнуляем длину строки
    mov rsi, %1         ; Адрес строки
    xor rax, rax        ; Сбрасываем регистр
%%calculate_length:
    mov al, byte [rsi + rdx]
    cmp al, 0           ; Ищем конец строки (нулевой байт)
    je %%print_now
    inc rdx             ; Увеличиваем длину
    jmp %%calculate_length
%%print_now:
    mov rax, 1          ; syscall write
    mov rdi, 1          ; stdout
    syscall
%endmacro

%macro mPrintChar 1 
    push rsi
    push rax
    push rdi
    push rdx
    ; Вывод символа 
    mov rsi, %1
    mov rax, 1
    mov rdi, 1
    mov rdx, 1 
    syscall

    pop rdx
    pop rdi 
    pop rax 
    pop rsi
%endmacro

%macro mStringLength 1
    push rax
    mov rsi, %1         ; Адрес строки
    xor rbx, rbx        ; Обнуляем счетчик длины
%%count_loop:
    lodsb               ; Загружаем текущий байт из строки
    test al, al         ; Проверяем, не конец строки ли это
    jz %%done            ; Если нашли конец строки, завершаем
    inc rbx             ; Увеличиваем счетчик
    jmp %%count_loop     ; Продолжаем цикл
%%done:
    pop rax
%endmacro

%macro mCopyString 2
    mov rsi, %1         ; Адрес исходной строки (откуда)
    mov rdi, %2         ; Адрес целевой строки (куда)
%%copy_loop:
    lodsb               ; Загружаем байт из исходной строки
    stosb               ; Сохраняем байт в целевую строку
    test al, al         ; Проверяем, не нулевой ли байт (конец строки)
    jnz %%copy_loop      ; Если не конец строки, продолжаем копирование
    mov byte [rdi], 0
%endmacro

%macro mInputString 2
    ; Чтение строки
    mov rax, 0          ; syscall read
    mov rdi, 0          ; stdin
    mov rsi, %1         ; адрес буфера
    mov rdx, %2         ; максимальная длина
    syscall
%endmacro

%macro mTrimString 1
    ; Удаление символа новой строки ('\n') из конца строки
    mov rsi, %1
    xor rax, rax
%%trim_loop:
    lodsb
    cmp al, 0xA         ; проверка на '\n'
    je %%trim_remove
    cmp al, 0
    je %%trim_end
    jmp %%trim_loop
%%trim_remove:
    dec rsi
    mov byte [rsi], 0
%%trim_end:
%endmacro
