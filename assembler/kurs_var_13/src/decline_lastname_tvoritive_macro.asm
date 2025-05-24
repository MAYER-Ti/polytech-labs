%macro mDeclineTvoritive 2

    mCopyString %1, %2

    mStringLength %2 ; посчитать кол-во байт в строке до \0 записать в rbx
    sub rbx, 2 ; встать на последюю букву
    
    mov rsi, %2
    ; Последняя буква
    ; [rsi + rax]
    ; Предпоследняя буква
    ; push word [rsi + rax - 2]
     
    ; последние два символа ый/ий/ой
    cmp dword [rsi + rbx - 2], 'ый'
    je %%replace_im
    cmp dword [rsi + rbx - 2], 'ий'
    je %%replace_im
    cmp dword [rsi + rbx - 2], 'ой'
    je %%replace_im
    
    ;последний символ а/я
    cmp word [rsi + rbx], 'а'
    je %%replace_oi
    cmp word [rsi + rbx], 'я'
    je %%replace_ei

    ; последние два символа ов/ев/ин/ын
    cmp dword [rsi + rbx - 2], 'ов' 
    je %%append_iim
    cmp dword [rsi + rbx - 2], 'ев' 
    je %%append_iim
    cmp dword [rsi + rbx - 2], 'ин' 
    je %%append_iim
    cmp dword [rsi + rbx - 2], 'ын' 
    je %%append_iim
    jmp %%done

%%replace_iim:
    ;  
    mov dword [rsi + rbx - 2], 'ым'
    mov word [rsi + rbx + 2], 0
    jmp %%done

%%append_iim:
    mov dword [rsi + rbx + 2], 'ым'
    mov word [rsi + rbx + 6], 0
    jmp %%done

%%replace_oi:
    mov dword [rsi + rbx], 'ой'
    mov word [rsi + rbx + 4], 0
    jmp %%done

%%replace_ei:
    mov dword [rsi + rbx], 'ей'
    mov word [rsi + rbx + 4], 0
    jmp %%done

%%replace_im:
    mov dword [rsi + rbx - 2], 'им'
    mov word [rsi + rbx + 2], 0
    jmp %%done

%%append_a:
    mov word [rsi + rbx + 2], 'а'    
    mov word [rsi + rbx + 4], 0     
%%done:
%endmacro

