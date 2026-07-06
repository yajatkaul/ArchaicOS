[bits 32]

global print_hex_byte

extern print_char

section .rodata

hex_table:
    db "0123456789ABCDEF"

section .text

; Prints the hex for "byte"
print_hex_byte:
    push eax
    push ebx
    push edx

    mov dl, al                  ; Save original byte

    ; High Nibble
    mov al, dl
    shr al, 4                   ; AL = High nibble (0-15)

    movzx ebx, al
    mov al, [hex_table + ebx]

    call print_char

    ; Low Nibble
    mov al, dl
    and al, 0x0F                ; AL = Low nibble (0-15)

    movzx ebx, al
    mov al, [hex_table + ebx]

    call print_char

    pop edx
    pop ebx
    pop eax

    ret