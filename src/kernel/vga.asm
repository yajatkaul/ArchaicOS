; VGA Text Mode Constants
VGA_MEMORY equ 0xB8000          ; VGA text mode video memory address 
VGA_WIDTH  equ 80               ; Each row has 80 chars
VGA_HEIGHT equ 25               ; 25 is the number of rows on a standard VGA text-mode screen

; Default text attribute (like color)
VGA_COLOR  equ 0x07

; Current cursor position
cursor_x:
    dd 0

cursor_y:
    dd 0

print_char:
    push eax                    ; Save all regs
    push ebx
    push edi

    mov bl, al

    mov eax, [cursor_y]         ; Put cursor_t val in EAX

    imul eax, VGA_WIDTH         ; Signed multiple 80 * EAX
    add eax, [cursor_x]         ; Add val of cursor_x into EAX
    shl eax, 1                  ; Left shift EAX once, each left shift = x2

    lea edi, [eax + VGA_MEMORY] ; Put EAX + vga_mem value into eax

    mov [edi], bl
    mov byte [edi + 1], VGA_COLOR

    inc dword [cursor_x]

    pop edi
    pop ebx
    pop eax

    ret

print_string:
    .loop:
        mov al, [esi]               ; Load character

        cmp al, 0                   ; Check if EDI is 0 meaning string finished
        je .done                    ; If its equal to 0 then jump to done

        call print_char

        inc esi
        
        jmp .loop                   ; Loop again until the string ends(0)

    .done:
        ret                         ; Once loop is finished return back