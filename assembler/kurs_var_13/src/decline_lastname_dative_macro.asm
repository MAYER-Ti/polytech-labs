%macro mDeclineDative 2

    mCopyString %1, %2
    
    mStringLength %2      ; Посчитать кол-во байт до завершающего нуля и записать в rbx
    sub rbx, 2            ; Встать на последнюю букву

    mov rsi, %2

    ; Указатель на последний символ
    ; [rsi + rbx - 2] - предпоследний символ

    ; последние два символа ый/ий/ой
    cmp dword [rsi + rbx - 2], 'ый'
    je %%replace_y_with_omu
    cmp dword [rsi + rbx - 2], 'ий'
    je %%replace_y_with_omu
    cmp dword [rsi + rbx - 2], 'ой'
    je %%replace_y_with_omu

    ; последний символ а/я
    cmp word [rsi + rbx], 'а'
    je %%replace_e
    cmp word [rsi + rbx], 'я'
    je %%replace_e
    ; Окончание ов/ев, ин/ын - добавить у
    cmp dword [rsi + rbx - 2], 'ов'
    je %%append_u
    cmp dword [rsi + rbx - 2], 'ев'
    je %%append_u
    cmp dword [rsi + rbx - 2], 'ин'
    je %%append_u
    cmp dword [rsi + rbx - 2], 'ын'
    je %%append_u
    jmp %%done

%%replace_y_with_omu:
    mov dword [rsi + rbx - 2], 'ом'
    mov word [rsi + rbx + 2], 'у'
    mov word [rsi + rbx + 4], 0
    jmp %%done

%%replace_e:
    mov word [rsi + rbx], 'е'
    mov word [rsi + rbx + 2], 0
    jmp %%done

%%append_u:
    mov word [rsi + rbx + 2], 'у'
    mov word [rsi + rbx + 4], 0
%%done:
%endmacro

