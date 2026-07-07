global keyboard_translate

extern shift_pressed
extern caps_lock

extern normal_keymap
extern shift_keymap

section .text

; AL = Scan Code
; AL = ASCII Character
; AL = 0 if not printable
keyboard_translate:
    ; Determine whether to use normal or shift/caps keymap.
    mov bl, [shift_pressed]
    xor bl, [caps_lock]

    test bl, bl
    jnz .shift          ; If shift/caps then use shift_keymap

    .normal:
        movzx ebx, al
        mov al, [normal_keymap + ebx]
        ret

    .shift:
        movzx ebx, al
        mov al, [shift_keymap + ebx]
        ret