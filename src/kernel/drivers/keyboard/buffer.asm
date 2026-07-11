global keyboard_push
global keyboard_get_char

BUFFER_SIZE equ 256
BUFFER_MASK equ BUFFER_SIZE - 1

section .bss

keyboard_buffer:
    resb BUFFER_SIZE

keyboard_head:
    resd 1

keyboard_tail:
    resd 1

section .text

; AL = Character to push
; Character added to the buffer
; If the buffer is full, character is discarded.
keyboard_push:
    push ebx
    push ecx

    ; Current head
    mov ebx, [keyboard_head]

    ; Calculate next head
    mov ecx, ebx
    inc ecx
    and ecx, BUFFER_MASK                ; x % BUFFER_MASK, to impliment the overwrite

    ; Is buffer full?
    cmp ecx, [keyboard_tail]
    je .done

    ; Store character
    mov [keyboard_buffer + ebx], al

    ; Advance head
    mov [keyboard_head], ecx

    .done:
        pop ecx
        pop ebx

        ret

keyboard_get_char:
    push ebx

    ; Is buffer empty?
    mov ebx, [keyboard_tail]
    cmp ebx, [keyboard_head]
    je .empty

    ; Read character
    mov al, [keyboard_buffer + ebx]

    ; Advance tail
    inc ebx
    and ebx, BUFFER_MASK                    ; x % BUFFER_MASK

    mov [keyboard_tail], ebx

    pop ebx
    ret

    .empty:
        xor al, al                          ; Returns 0 incase invalid/empty
        pop ebx
        ret