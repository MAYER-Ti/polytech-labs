.model small
.stack 100h
.data 
A DB 0,1,2,3,4,5,6,7,8,9
B DB 10 DUP(0) ; ODh - возврат каретки ; OAh - новая строка
.code
start:
; Для чтения A и B
mov ax, @data
mov ds, ax
mov es, ax

; Перемещение из A в B
lea si, A
lea di, B
mov cx, 10
rep movsb

; Взять адрес B в si
lea si, B
; 10 элементов B надо пройти
mov cx, 10

print_simbol:
mov al, [si]
; сравнение операндов
; = - Если есть флаг ZF
; < - Если флаг SF != OF
; > - Если флаг ZF = 0 и SF = OF
; != - Если нету флага ZF
;cmp al, 0Dh
; jump equal
;JE  print_simbols_newline
; Перевод в таблицу ASCII символ в al
add al, 30h
; Запись в dl для вывода
mov dl, al
; Вызов функции DOS для вывода dl
mov ah, 02h
int 21h

inc si
loop print_simbol

;JMP end_program

print_simbols_newline:
; записать указание на функцию DOS, которая выводит один символ из dl
mov ah, 02h
; записать символ новой строки
mov dl, 0Ah
; Прерывание для выполнения операции в ah
int 21h

; записать указание на функцию DOS, которая выводит один символ из dl
mov ah, 02h
; записать символ переноса каретки в начало строки
mov dl, 0Dh
; Прерывание для выполнения операции в ah
int 21h

end_program:
; Завершение программы
mov ah, 4ch
int 21h

end start