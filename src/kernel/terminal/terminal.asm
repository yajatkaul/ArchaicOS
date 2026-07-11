global terminal_init
global terminal_update

extern keyboard_get_char

extern terminal_buffer_clear
extern terminal_buffer_push
extern terminal_buffer_backspace
extern terminal_buffer_get_ptr
extern terminal_buffer_length

extern print_char
extern backspace_char
extern print_string
extern clear_screen
extern newline
extern print_hex_byte

section .rodata

prompt db "> ", 0

section .text

terminal_init:
    call clear_screen
    call terminal_buffer_clear
    call terminal_print_prompt

    ret

terminal_update:
    call keyboard_get_char      ; Puts char into AL reg

    cmp al, 0                   ; If invalid char pressed
    je .done

    cmp al, 8                   ; If backspace pressed
    je .backspace

    cmp al, 10                  ; If enter pressed
    je .enter

    call terminal_handle_char
    jmp .done

    .backspace:
        call terminal_handle_backspace
        jmp .done

    .enter:
        call terminal_handle_enter

    .done:
        ret

terminal_handle_char:
    call print_char
    call terminal_buffer_push       ; Update buffer
    ret

terminal_handle_backspace:
    call terminal_buffer_length     ; Puts length in EAX reg
    test eax, eax                   ; Check if EAX is 0
    jz .done                        ; If its 0 then it is empty return

    call backspace_char
    call terminal_buffer_backspace

    .done:
        ret

terminal_handle_enter:
    call newline

    ; TODO
    ; call command_dispatcher

    call terminal_buffer_clear
    call terminal_print_prompt
    ret

terminal_print_prompt:
    mov esi, prompt
    call print_string
    ret