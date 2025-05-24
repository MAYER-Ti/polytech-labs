.model	small
.stack	100h
.data
Hello DB "Hello, world!", 0Dh, 0Ah,'$'
.code
start:
; Для чтения A и B
mov ax, @data
mov ds, ax
mov es, ax
; записать указание на функцию DOS, которая выводит строку,
; начинает с dx, заканчивает когда встречает $
mov	ah,9
lea     dx, Hello
int     21h

; Завершение программы
mov ah, 4ch
int 21h
end	start