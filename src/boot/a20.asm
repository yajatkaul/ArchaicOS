; Allows the system to go above 1mb limit(backwards compatiblity), Address 20
enable_a20:
    mov ax, 0x2401                  ; AX = AH, AL. So here we put AH=24 and AL=01
    int 0x15                        ; Then we call the interrupt to enable A20

    jc .failed                      ; Jump if carry flag is 1, meaning if interrupt 0x15 failed it puts 1 in the carry flag

    call check_a20

    cmp ax, 1                       ; When it returns from check_a20 if its 0 then it failed if its 1 then it succeded
    je .a20_ok                      ; If it is 1 then return

    call .failed

    .a20_ok:
        ret

.failed:
    mov si, a20_failed_msg
    call print_string
    jmp $

check_a20:
    pushf                               ; Save the FLAGS register
    cli                                 ; Disable interrupts

    push ds                             ; Save DS
    push es                             ; Save ES

    xor ax, ax                          ; AX = 0
    mov ds, ax                          ; DS = 0x0000

    mov ax, 0xFFFF                      ; AX = 0xFFFF
    mov es, ax                          ; ES = 0xFFFF

    mov si, 0x0500                      ; SI = 0x0500
    mov di, 0x0510                      ; DI = 0x0510. DS:SI and ES:DI resolve to addresses exactly 1 MiB apart.

    mov al, [si]                        ; Save the original byte at DS:SI into AL
    mov bl, [es:di]                     ; Save the original byte at ES:DI into BL

    mov byte [si], 0                    ; Write 0x00 to DS:SI (byte specifies a 1-byte memory write)
    mov byte [es:di], 0xFF              ; Write 0xFF to ES:DI (if A20 was disabled then this would write to si only)

    mov cl, [si]                        ; Read the byte at DS:SI into CL

    mov [si], al                        ; Restore the original byte at DS:SI
    mov [es:di], bl                     ; Restore the original byte at ES:DI

    cmp cl, 0xFF                        ; If CL == 0xFF, both addresses referred to the same memory
    je .disabled                        ; Therefore A20 is disabled

    mov ax, 1                           ; Return 1 (A20 enabled)
    jmp .done

.disabled:
    xor ax, ax                          ; Return 0 (A20 disabled)

.done:
    pop es                              ; Restore ES
    pop ds                              ; Restore DS

    popf                                ; Restore FLAGS
    ret