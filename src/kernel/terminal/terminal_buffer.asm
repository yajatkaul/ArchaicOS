global terminal_buffer_clear
global terminal_buffer_push
global terminal_buffer_backspace
global terminal_buffer_get_ptr
global terminal_buffer_length

TERMINAL_BUFFER_SIZE equ 256

section .bss

terminal_buffer:
    resb TERMINAL_BUFFER_SIZE

terminal_length:
    resd 1

section .text

terminal_buffer_clear:
    mov byte [terminal_buffer], 0
    mov dword [terminal_length], 0
    ret

terminal_buffer_push:
    cmp dword [terminal_length], TERMINAL_BUFFER_SIZE - 1
    jge .done

    mov edx, [terminal_length]                                      ; Store length in EDX

    mov [terminal_buffer + edx], al                                 ; Put char in buffer at correct pos

    inc edx                                                         ; Inc length

    mov [terminal_length], edx                                      ; Put updated length

    mov byte [terminal_buffer + edx], 0                             ; Add null terminator after each char

    .done:
        ret

terminal_buffer_backspace:
    cmp dword [terminal_length], 0                                  ; Nothing to remove?
    je .done

    dec dword [terminal_length]                                     ; Decrement the length

    mov edx, [terminal_length]                                      ; Put length in EDX

    mov byte [terminal_buffer + edx], 0                             ; Add new null terminator

    .done:
        ret

; Returns pointer to buffer.
terminal_buffer_get_ptr:
    mov eax, terminal_buffer
    ret

; Returns current length.
terminal_buffer_length:
    mov eax, [terminal_length]
    ret