global keyboard_update_modifiers
global shift_pressed
global caps_lock

section .bss

shift_pressed:
    resb 1

; TODO
caps_lock:
    resb 1

section .text

; Updates keyboard state like if CAPS is on
keyboard_update_modifiers:
    cmp al, 0x2A            ; Left Shift Press
    je .shift_down          ; Enable Shift Down

    cmp al, 0x36            ; Right Shift Press
    je .shift_down          ; Enable Shift Down

    cmp al, 0xAA            ; Left Shift Release
    je .shift_up            ; Enable Shift Release

    cmp al, 0xB6            ; Right Shift Release
    je .shift_up            ; Enable Shift Release

    ret

    .shift_down:
        mov byte [shift_pressed], 1
        ret

    .shift_up:
        mov byte [shift_pressed], 0
        ret