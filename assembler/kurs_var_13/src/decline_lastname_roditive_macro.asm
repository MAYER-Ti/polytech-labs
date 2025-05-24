%macro mDeclineRoditive 2

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
    je %%replace_on_ogo
    cmp dword [rsi + rbx - 2], 'ий'
    je %%replace_on_ogo
    cmp dword [rsi + rbx - 2], 'ой'
    je %%replace_on_ogo
    
    ;последний символ а/я
    cmp word [rsi + rbx], 'а'
    je %%replace_on_ii
    cmp word [rsi + rbx], 'я'
    je %%replace_on_i

    ; последние два символа ов/ев/ин/ын
    cmp dword [rsi + rbx - 2], 'ов' 
    je %%append_a
    cmp dword [rsi + rbx - 2], 'ев' 
    je %%append_a
    cmp dword [rsi + rbx - 2], 'ин' 
    je %%append_a
    cmp dword [rsi + rbx - 2], 'ын' 
    je %%append_a
    jmp %%done

%%replace_on_ogo:
    ;  
    mov dword [rsi + rbx - 2], 'ог'
    mov word [rsi + rbx - 2 + 4], 'о'
    mov word [rsi + rbx + 4], 0
    jmp %%done

%%replace_on_ii:
    mov word [rsi + rbx], 'ы'
    mov word [rsi + rbx + 2], 0
    jmp %%done

%%replace_on_i:
    mov word [rsi + rbx], 'и'
    mov word [rsi + rbx + 2], 0
    jmp %%done

%%append_a:
    mov word [rsi + rbx + 2], 'а'    
    mov word [rsi + rbx + 4], 0     
%%done: 
%endmacro

