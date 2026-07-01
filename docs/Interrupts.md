# BIOS Interrupts

The BIOS provides a set of software interrupts that allow a bootloader or operating system to interact with hardware without needing to write device drivers. To use an interrupt, load the required values into the appropriate registers and execute the `int` instruction.

---

## `INT 0x10` — Video Services

Provides functions for interacting with the display, including printing characters, moving the cursor, changing video modes, and more.

### Common Functions

| AH | Function | Description |
|----|----------|-------------|
| `0x00` | Set Video Mode | Changes the current display mode. |
| `0x02` | Set Cursor Position | Moves the cursor to a specified row and column. |
| `0x03` | Get Cursor Position | Returns the current cursor location. |
| `0x06` | Scroll Up Window | Scrolls part or all of the screen upward. |
| `0x09` | Write Character & Attribute | Prints a character with a specified color attribute. |
| `0x0E` | Teletype Output | Prints a character at the cursor and advances the cursor. This is the most commonly used function in bootloaders. |
| `0x13` | Write String | Prints an entire string directly from memory. |

### Example: Print a Character

```asm
mov ah, 0x0E    ; Teletype output
mov al, 'A'     ; Character to print
int 0x10
```

---

## `INT 0x13` — Disk Services

Provides low-level access to storage devices such as floppy disks and hard drives. It is commonly used by bootloaders to load additional sectors into memory.

### Common Functions

| AH | Function | Description |
|----|----------|-------------|
| `0x00` | Reset Disk System | Resets the selected disk. |
| `0x02` | Read Sectors | Reads one or more sectors from disk into memory. |
| `0x03` | Write Sectors | Writes one or more sectors from memory to disk. |
| `0x08` | Get Drive Parameters | Returns information about the selected drive. |
| `0x41` | Check Extensions | Determines whether BIOS Enhanced Disk Drive (EDD) services are supported. |
| `0x42` | Extended Read | Reads sectors using Logical Block Addressing (LBA). |

### Example: Read One Sector

```asm
mov ah, 0x02      ; Read sectors
mov al, 0x01      ; Read 1 sector
mov ch, 0x00      ; Cylinder
mov cl, 0x02      ; Sector (starts at 1)
mov dh, 0x00      ; Head
mov dl, 0x80      ; First hard disk
mov bx, 0x7E00    ; Buffer (ES:BX)

int 0x13

jc disk_error     ; Carry flag set if an error occurred
```

---

## Notes

- BIOS interrupts are only available while running in **Real Mode (16-bit)**.
- Most bootloaders rely heavily on `INT 0x10` for text output and `INT 0x13` for loading additional sectors from disk.
- After switching to **Protected Mode** or **Long Mode**, BIOS interrupts are no longer available. Your operating system must provide its own hardware drivers.