.model  huge  ; small
.stack  100h

.data
    array DB 10 DUP(5 DUP('0')) 
    newline DB 0Dh, 0Ah, '$'  

.code
start:
    mov ax, @data
    mov ds, ax  
    
   
    call incEven

    
    call printMatrix
    
    
    ; Завершение работы программы
    mov ax, 4c00h
    int 21h


incEven:
    lea bx, array
    mov si, 0 
column_loop:   
row_loop:
    add [bx][si], 1     
    inc si
    cmp si, 5
    jne row_loop

    add bx, 10 
    cmp bx, offset array + 50 
    jae done
    mov si, 0
    jne column_loop

done:
    ret


printMatrix:
    lea si, array
    mov cx, 10
print_matrix_loop:
    push cx
    mov cx, 5
print_row:
    mov al, [si]     
    mov ah, 0Eh      
    int 10h
    inc si
    loop print_row

    mov ah, 09h
    lea dx, newline
    int 21h

    pop cx
    loop print_matrix_loop
    ret
    
    

end start
