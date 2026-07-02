[org 0]                         ; When we jumped from bootloader into kernal the offset is 0 since its a different sector, this is just an offset not location
[bits 32]

kernel_start:
    mov edi, 0xB8000            ; EDI = VGA text mode video memory address
                                ; Writing to 0xB8000 displays characters on the screen

    mov byte [edi], 'H'         ; Store 'H' in the first screen cell
    mov byte [edi + 1], 0x07    ; Set the attribute byte for 'H', 0x07 = Light gray text on a black background

    mov byte [edi + 2], 'i'
    mov byte [edi + 3], 0x07

.loop:
    jmp .loop                   ; Loop so it doesnt crash

times 512-($-$$) db 0