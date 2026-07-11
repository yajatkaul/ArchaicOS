global keyboard_handler

extern keyboard_update_modifiers
extern keyboard_translate
extern keyboard_push

section .text

keyboard_handler:
    in al, 0x60 ; Read scan code from the keyboard controller
                ; Port 0x60 always contains the latest keyboard scan code
    
    ; Update keyboard state
    call keyboard_update_modifiers  ; Shift pressed  -> shift_pressed = 1 else 0

    ; Ignore break codes
    test al, 10000000b              ; Bit 7 = 1 means the key was released
    jnz .done

    ; Convert scan code into ASCII
    call keyboard_translate

    ; Some keys don't have ASCII like ctrl
    test al, al                     ; keyboard_translate returns AL = 0 for those
    jz .done

    ; Store character into the keyboard ring buffer.
    call keyboard_push              ; Nothing gets printed here.

.done:
    ret