# ArchaicOS

ArchaicOS is a hobby operating system written entirely from scratch in **x86 NASM Assembly**.

The primary goal of the project is to gain a deep understanding of operating system internals by implementing every component manually, rather than relying on existing kernels, operating system libraries, or copied code. Every subsystem is designed and written from the ground up to explore how a computer actually boots, initializes hardware, handles interrupts, manages input, and interacts directly with the CPU.

## Philosophy

* Everything is written manually in x86 NASM Assembly.
* Build every subsystem from first principles.
* Prioritize understanding over convenience.
* Keep the architecture clean, modular, and maintainable.
* Write reusable code instead of quick hacks.

## Features

### Boot Process

* Custom bootloader
* A20 line initialization
* Global Descriptor Table (GDT)
* Transition to 32-bit Protected Mode

### Kernel

* Custom kernel entry point
* VGA text-mode driver
* Hardware cursor support
* Screen scrolling

### Interrupt Handling

* Interrupt Descriptor Table (IDT)
* CPU exception handling
* Common exception dispatcher
* Programmable Interrupt Controller (PIC) remapping
* Programmable Interval Timer (PIT) initialization

### Keyboard

* PS/2 keyboard driver
* Scancode processing
* Shift and Caps Lock state handling
* ASCII translation
* Ring buffer input system

### Terminal

* Interactive command-line terminal
* Input buffer
* Character echoing
* Backspace handling
* Enter handling
* Prompt support

## Build Requirements

* NASM
* GNU Make
* GNU LD
* QEMU (recommended for testing)

## License

Released under the MIT License.

---

**ArchaicOS** is an educational project focused on understanding operating systems at the lowest level by building every major component from scratch in raw x86 assembly.
