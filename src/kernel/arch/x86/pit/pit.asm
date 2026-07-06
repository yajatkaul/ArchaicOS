global pit_init

PIT_CHANNEL0 equ 0x40           ; The data port for Timer Channel 0
PIT_COMMAND  equ 0x43           ; This tells the PIT how we want it to operate

section .text

; Initialize Programmable Interval Timer
pit_init:
    mov al, 00110110b           ; Bits 7-6 -> Select Channel 0, Bits 5-4 -> Send the divisor in two bytes,
                                ; Bits 3-1 -> This selects Mode 3 (Square Wave Generator), Bit 0 -> Means binary counting
    out PIT_COMMAND, al

    ; Divisor for 100 Hz
    mov ax, 11931

    ; Since we send in 2 bytes since number is big
    ; We send low byte and high byte
    ; Low byte
    out PIT_CHANNEL0, al

    ; High byte
    mov al, ah
    out PIT_CHANNEL0, al

    ret