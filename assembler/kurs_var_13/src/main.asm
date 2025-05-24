%include "src/io_macro.asm"
%include "src/decline_lastname_macro.asm"

section .data
    input_msg db "Введите фамилию: ", 0
    nominative_msg db "Именительный(Кто? Что?): ", 0
    roditive_msg db "Родительный(Кого? Чего?): ", 0
    dative_msg db "Дательный(Кому? Чему?): ", 0
    vinitive_msg db "Винительный(Кого? Что?): ", 0
    tvoritive_msg db "Творительный(Кем? Чем?): ", 0
    predlositive_msg db "Предложный(О Ком? О Чем?): ", 0
    newline db 0xA, 0
    err_msg db "Неверный падеж", 0

    ; Буферы для работы
    buffer times 100 dw 0; Буфер для ввода фамилии
    output_buffer times 100 dw 0   ; Буфер для вывода результата

section .text
    global _start

%macro mZeroArray 2
    mov rdi, %1         ; Адрес массива
    mov rcx, %2         ; Длина массива
    xor rax, rax        ; Устанавливаем значение для записи (0)
%%zero_loop:
    mov byte [rdi], al  ; Зануляем текущий байт
    inc rdi             ; Переходим к следующему элементу
    loop %%zero_loop     ; Уменьшаем rcx и повторяем, если не 0
%endmacro


%macro EndProgram 0
    mov rax, 60        ; Системный вызов: exit
    xor rdi, rdi       ; Код возврата 0
    syscall            ; Вызов ядра
%endmacro

_start:

    ; ввод фамилии
    mPrintString input_msg
    mInputString buffer, 100
    mTrimString buffer
    mPrintString buffer
    mPrintString newline
     
    ; Вывод в иминительном падеже 
    mPrintString nominative_msg                 ; Вывод строки падежа
    mDeclineLastname buffer, output_buffer, 1   ; Склонение фамилии
    mPrintString output_buffer                  ; вывод фамилии
    mPrintString newline                        ; Переход на новую строку 
    mZeroArray output_buffer, 100               ; Занулить буфер фамилии
   
    ; Вывод в родительном падеже 
    mPrintString roditive_msg                   ; Вывод строки падежа
    mDeclineLastname buffer, output_buffer, 2   ; Склонение фамилии
    mPrintString output_buffer                  ; вывод фамилии
    mPrintString newline                        ; Переход на новую строку
    mZeroArray output_buffer, 100               ; Занулить буфер фамилии

    ; Вывод в дательном падеже 
    mPrintString dative_msg                     ; Вывод строки падежа
    mDeclineLastname buffer, output_buffer, 3   ; Склонение фамилии
    mPrintString output_buffer                  ; вывод фамилии
    mPrintString newline                        ; Переход на новую строку
    mZeroArray output_buffer, 100               ; Занулить буфер фамилии

    ; Вывод в винительном падеже 
    mPrintString vinitive_msg                   ; Вывод строки падежа
    mDeclineLastname buffer, output_buffer, 4   ; Склонение фамилии
    mPrintString output_buffer                  ; вывод фамилии
    mPrintString newline                        ; Переход на новую строку
    mZeroArray output_buffer, 100               ; Занулить буфер фамилии

    ; Вывод в творительном падеже 
    mPrintString tvoritive_msg                  ; Вывод строки падежа
    mDeclineLastname buffer, output_buffer, 5   ; Склонение фамилии
    mPrintString output_buffer                  ; вывод фамилии
    mPrintString newline                        ; Переход на новую строку
    mZeroArray output_buffer, 100               ; Занулить буфер фамилии; Занулить буфер фамилии

    ; Вывод в предложном падеже 
    mPrintString predlositive_msg
    mDeclineLastname buffer, output_buffer, 6
    mPrintString output_buffer
    mPrintString newline
    mZeroArray output_buffer, 100               ; Занулить буфер фамилии; Занулить буфер фамилии

    ; Завершение программы
    EndProgram
