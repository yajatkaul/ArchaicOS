global pic_remap

PIC1_COMMAND equ 0x20               ; Master PIC's Command Port
PIC1_DATA    equ 0x21               ; Master PIC's Data Port

PIC2_COMMAND equ 0xA0               ; Slave PIC's Command Port
PIC2_DATA    equ 0xA1               ; Slave PIC's Data Port

section .text

; Programmable Interrupt Controller
; This is a chip btwn hardware and CPU
; Requests to CPU for actions
pic_remap:
    ; ICW1, Initialization
    mov al, 0x11                    ; Start PIC initialization
    out PIC1_COMMAND, al            ; Master PIC, begin initialization
    out PIC2_COMMAND, al            ; Slave PIC, begin initialization

    ; ICW2
    mov al, 0x20                    ; Load 32 into al
    out PIC1_DATA, al               ; Tells master start your interrupts at 32, since 0-31 for CPU Int

    mov al, 0x28                    ; Load 40 into al
    out PIC2_DATA, al               ; Tells slave start your interrupts at 40

    ; ICW3
    mov al, 0x04                    ; 00000100, Bit 2 is set, uses bitmap
    out PIC1_DATA, al               ; Master, the Slave PIC is connected to IRQ2

    mov al, 0x02                    ; Uses ID
    out PIC2_DATA, al               ; You are connected to IRQ2 on the Master

    ; ICW4
    mov al, 0x01                    ; Use 8086/Protected Mode
    out PIC1_DATA, al               ; Tell master
    out PIC2_DATA, al               ; Tell slave

    ret