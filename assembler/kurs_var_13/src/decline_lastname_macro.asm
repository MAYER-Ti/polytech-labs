%include "src/decline_lastname_nominative_macro.asm"
%include "src/decline_lastname_roditive_macro.asm"
%include "src/decline_lastname_dative_macro.asm"
%include "src/decline_lastname_vinitive_macro.asm"
%include "src/decline_lastname_tvoritive_macro.asm"
%include "src/decline_lastname_predlositive_macro.asm"

%macro mDeclineLastname 3
    ; Параметры:
    ; %1 - исходная фамилия
    ; %2 - буфер для результата
    ; %3 - номер падежа

    mov al , %3
    cmp al, 1            ; Именительный падеж
    je %%nominative
    cmp al, 2            ; Родительный падеж
    je %%roditive
    cmp al, 3            ; Дательный падеж
    je %%dative
    cmp al, 4            ; Винительный падеж
    je %%vinitive
    cmp al, 5            ; Творительный падеж
    je %%tvoritive
    cmp al, 6            ; Предложный падеж
    je %%predlositive
    jmp %%error          ; Ошибка, неправильный падеж

%%nominative:
    ; Копируем фамилию без изменений
    mDeclineNominative %1, %2
    jmp %%done

%%roditive:
    mDeclineRoditive %1, %2
    jmp %%done
 
%%dative:
    mDeclineDative %1, %2
    jmp %%done
 
%%vinitive:
    mDeclineVinitive %1, %2
    jmp %%done
%%tvoritive:
    mDeclineTvoritive %1, %2
    jmp %%done
 
%%predlositive:
    mDeclinePredlositive %1, %2
    jmp %%done
  
%%error:
    ; Обработка ошибки
    mov rsi, err_msg
    mov rdi, %2
    mCopyString err_msg, %2 
  
%%done:
%endmacro

