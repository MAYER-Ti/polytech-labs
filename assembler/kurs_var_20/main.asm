.model  small
.stack  100h

.data
   newline db 0Dh, 0Ah, '$'
   text_msg db "Text: ", 0Dh, 0Ah, '$' 
   input_msg db "Print order rows: ",'$'
   error_msg db "Invalid input! example: 13245", 0Dh, 0Ah,'$'
   help_msg db "To exit program just press enter", 0Dh, 0Ah, '$'
    
   rows  db "1) sample row1 to example text", 0Dh, 0Ah, '$'   ; строки текста
         db "2) row2 example text          ", 0Dh, 0Ah, '$'   ; для работы
         db "3) text for example row3      ", 0Dh, 0Ah, '$'
         db "4) example text for row4      ", 0Dh, 0Ah, '$'
         db "5) last row5 for example text ", 0Dh, 0Ah, '$'
         db "6) Six row in the example text", 0Dh, 0Ah, '$'
         db "7) Seven is sum one and six   ", 0Dh, 0Ah, '$'
         db "7) Seven is sum one and six   ", 0Dh, 0Ah, '$'
         
   row_len equ 33          ; Длинна строки
   row_count equ 7         ; кол-во строк в тексте
   buffer db "00000", '$'  ; Буфер для чтения ввода
.code


mPrintString MACRO string
; Макрос вывода строки до символа '$'
   lea dx, string
   mov ah, 9
   int 21h
endm

mPrintChar MACRO char
; Макрос вывода символа
   mov dl, char
   mov ah, 02h
   int 21h
endm

mInputString MACRO string_, string_len_
; Макрос ввода строки в буфер с заданной длинной 
   mov ah, 0Ah
   mov al, byte ptr string_len_
   add al, 1
   mov byte ptr string_, al   ; длинна ввода
   lea dx, string_
   int 21h
endm

mPrintRows MACRO rows_, row_len_, row_count_
   local loopPrintRows
; Макрос вывода всего текста построчно
; Принимает массив строк, длинну строки и количество строк
   
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
; Макрос Вывода одной строки по номеру строки начиная с единицы
; Принимает массив строк, длинну строки и номер строки для вывода 
   mov bx, row_len_                       ; Длина строки
   mov ax, row_index_                     ; Номер строки для вывода
   sub ax, 1                              ; Начать отсчет с нуля   
   mul bx                                 ; Умножить индекс строки на размер строки  
   mov bx, ax
   mPrintString rows_[bx]                 ; Вывести строку по индексу
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

   mPrintString newline                   ;Перевод на новую строку
   mPrintString text_msg                  ;Сообщение о тексте
   mPrintString newline                   ;Перевод на новую строку
   
   mPrintRows rows, row_len, row_count    ;Вывод текста
   mPrintString newline                   ;Перевод строки
   
   mPrintString input_msg                 ;Приглашение для ввода порядка строк
   mInputString buffer, row_count         ;Ввод порядка строк в буффер
   mPrintString newline                   ;Перевод строки

   mov al, buffer[1]                      ;Если ввод пустой - конец программы
   cmp al, 0
   je endProgram
   xor ah, ah
   mov cx, ax
   lea si, buffer
   add si, 2
   
loopBuf:                                  ;Проверка по каждому введенному символу
   xor ax, ax
   mov al, [si]                           ;Проверка больше символа нуля 
   cmp ax, '0'
   jl error
   mov bx, row_count
   add bx, 30h
   cmp ax, bx                             ;Проверка меньше символа количества строк
   jg error
   
   sub ax, 30h                            ;Перевести из ASCII в число  
   
   mPrintRow rows, row_len, ax            ;Напечатать строку текста по номеру
   add si, 1
   loop loopBuf
   
   jmp startProgram
   
error:
   mPrintString newline
   mPrintString error_msg                 ;Вывод сообщения о некорректном вводе
   mPrintString help_msg                  ;Вывод подсказки
   jmp startProgram
     
endProgram:                               ;Завершение программы
  mEndProgram
end start