global print_char
global print_string

; VGA Text Mode Constants
VGA_MEMORY equ 0xB8000          ; VGA text mode video memory address 
VGA_WIDTH  equ 80               ; Each row has 80 chars
VGA_HEIGHT equ 25               ; 25 is the number of rows on a standard VGA text-mode screen

ASCII_NEWLINE equ 10

; Default text attribute (like color)
VGA_COLOR  equ 0x07

section .data

; Current cursor position
cursor_x:
    resd 1                      ; Reserve one doubleword (4 bytes), since this initializes with 0

cursor_y:
    resd 1

section .text

print_char:
    push eax                    ; Save all regs
    push edx
    push edi

    mov dl, al                  ; We will perform operations on eax so we put data in bl to be safe

    cmp dl, ASCII_NEWLINE       ; If the char is of ASCII new line then check
    je .next_line               ; If its new line perform next line

    mov eax, [cursor_y]         ; Put cursor_y val in EAX

    imul eax, VGA_WIDTH         ; Signed multiple 80 * EAX
    add eax, [cursor_x]         ; Add val of cursor_x into EAX
    shl eax, 1                  ; Left shift EAX once, each left shift = x2

    lea edi, [eax + VGA_MEMORY] ; Put EAX + vga_mem value into eax
    
    mov [edi], dl                       ; Char to print
    mov byte [edi + 1], VGA_COLOR       ; Cell attribute (like color)

    inc dword [cursor_x]                ; Move x axis by 1

    cmp dword [cursor_x], VGA_WIDTH     ; If it has reached 80 (limit) check
    jl .continue                        ; If its less than 80 then continue

    .next_line:
        mov dword [cursor_x], 0         ; Once line changes x axis is 0
        inc dword [cursor_y]            ; Y axis is increased by 1

    cmp dword [cursor_y], VGA_HEIGHT
    jl .continue

    call scroll_screen
    mov dword [cursor_y], VGA_HEIGHT - 1

    .continue:

    pop edi
    pop edx
    pop eax                     ; Restore all flags

    ret

print_string:
    .loop:
        mov al, [esi]               ; Load character

        cmp al, 0                   ; Check if EDI is 0 meaning string finished
        je .done                    ; If its equal to 0 then jump to done

        call print_char

        inc esi                     ; Next byte
        
        jmp .loop                   ; Loop again until the string ends(0)

    .done:
        ret                         ; Once loop is finished return back

scroll_screen:
    push eax
    push ecx
    push esi
    push edi

    ; Row 1 starts 160 bytes after Row 0
    mov esi, VGA_MEMORY + (VGA_WIDTH * 2)

    ; Row 0 starts at VGA memory
    mov edi, VGA_MEMORY

    ; Copy 24 rows (3840 bytes / 4 = 960 dwords)
    mov ecx, ((VGA_HEIGHT - 1) * VGA_WIDTH * 2) / 4

    .copy:
        ; Copy 4 bytes (2 character cells)
        mov eax, [esi]
        mov [edi], eax

        ; Move to the next 4 bytes
        add esi, 4
        add edi, 4

        ; One less copy remaining
        dec ecx
        jnz .copy                   ; If not zero

        ; Clear the last row
        ; Point EDI at the first character of row 24
        mov edi, VGA_MEMORY + ((VGA_HEIGHT - 1) * VGA_WIDTH * 2)

        ; AX contains one blank VGA cell
        ; 0x20 = ' '
        ; 0x07 = White on Black
        mov ax, 0x0720

        ; 80 character cells to clear
        mov ecx, VGA_WIDTH

    .clear:
        ; Write one blank character + colour
        mov [edi], ax

        ; Next character cell (2 bytes)
        add edi, 2

        ; Continue until all 80 cells are cleared
        dec ecx
        jnz .clear

        ; Cursor should stay on the final row
        mov dword [cursor_y], VGA_HEIGHT - 1

        pop edi
        pop esi
        pop ecx
        pop eax
        ret