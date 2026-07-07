[bits 32]

global print_char
global print_string
global clear_screen

; VGA Text Mode Constants
VGA_MEMORY equ 0xB8000          ; VGA text mode video memory address 
VGA_WIDTH  equ 80               ; Each row has 80 chars
VGA_HEIGHT equ 25               ; 25 is the number of rows on a standard VGA text-mode screen

ASCII_NEWLINE equ 10

; Default text attribute (like color)
VGA_COLOR  equ 0x07
BLANK_SPACE equ 0x0720          ; 0x20 = ' ', 0x07 = White on Black

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

    call update_cursor

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
    push eax                        ; Save
    push ecx
    push esi
    push edi

    cld                             ; Clear Direction flag, tells that it needs 
                                    ; to move forward in mem during loops
    
    ; Moving each row
    mov esi, VGA_MEMORY + (VGA_WIDTH * 2)   ; Row 1 starts 160 bytes after Row 0

    mov edi, VGA_MEMORY                     ; Row 0 starts at VGA memory

    mov ecx, ((VGA_HEIGHT - 1) * VGA_WIDTH * 2) / 4 ; Copy 24 rows (3840 bytes / 4 = 960 dwords)

    rep movsd                       ; Repeat until ECX is 0, works on ESI and EDI (source, dest)
                                    ; movs(d), dword meaning moves 4 bytes every loop

    ; Clearing last row
    mov edi, VGA_MEMORY + ((VGA_HEIGHT - 1) * VGA_WIDTH * 2)        ; Load last line memory

    mov ax, BLANK_SPACE                                             ; Put blank space in reg ax

    mov ecx, VGA_WIDTH                                              ; 80 character cells to clear

    rep stosw                               ; Repeat until ECX is 0, this does AX to EDI (ax to dest)
                                            ; stos(w), word meaning moves 2 bytes every loop

    mov dword [cursor_y], VGA_HEIGHT - 1    ; Cursor should stay on the final row

    pop edi
    pop esi
    pop ecx
    pop eax                         ; Restore
    ret

clear_screen:
    push eax                        ; Save
    push ecx
    push edi

    cld                             ; Clear Direction flag, tells that it needs 
                                    ; to move forward in mem during loops
    
    mov ax, BLANK_SPACE             ; Source is blank space

    mov edi, VGA_MEMORY             ; Row 0 starts at VGA memory

    mov ecx, VGA_HEIGHT * VGA_WIDTH ; Copy 25 rows (25 x 80 = 2000 characters)

    rep stosw                       ; Repeat until ECX is 0, this does AX to EDI (ax to dest)
                                    ; movs(w), word meaning moves 2 bytes every loop

    pop edi
    pop ecx
    pop eax                         ; Restore
    ret

update_cursor:
    push eax
    push ebx
    push edx

    ; Calculate cursor position, pos = y * 80 + x, 2000 cells
    mov eax, [cursor_y]
    imul eax, VGA_WIDTH
    add eax, [cursor_x]

    ; eax -> ax (16-bit)
    mov bx, ax                  ; Save the 16-bit position, value is not more that 2000

    ; Send high byte, Here we select
    mov dx, 0x3D4               ; VGA Index register
    mov al, 14                  ; 14 stores upper 8 bits of cursor pos
    out dx, al                  ; Sends 14 to port 0x3D4

    ; Write upper 8 bits, Here we write
    mov dx, 0x3D5               ; Wtv is written here goes into reg we select  
    mov al, bh                  ; BX = BH | BL
    out dx, al                  ; Puts value into reg 14

    ; Send low byte, Here we select
    mov dx, 0x3D4
    mov al, 15                  ; 15 stores lower 8 bits of cursor pos
    out dx, al                  ; Sends 15 to port 0x3D4

    ; Write lower 8 bits, Here we write
    mov dx, 0x3D5
    mov al, bl
    out dx, al                  ; Puts value into reg 15

    pop edx
    pop ebx
    pop eax
    ret