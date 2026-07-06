.PHONY: build run plainRun debug clean

OBJS = \
build/kernel.o \
build/vga.o \
build/idt/idt.o \
build/idt/iloader.o \
build/idt/stubs.o \
build/idt/common_exception.o \
build/idt/divide_by_zero.o \
build/idt/invalid_opcode.o \
build/idt/general_protection.o \
build/idt/page_fault.o \
build/pic/pic.o \
build/pit/pit.o \
build/irq/stubs.o \
build/irq/common_irq.o \
build/irq/irq_loader.o \
build/irq/keyboard.o \
build/debug/print_hex_byte.o \
build/irq/timer.o

build:
	@mkdir -p build build/idt build/pic build/pit build/irq build/debug
	nasm -f bin ./src/boot/boot.asm -o ./build/boot.bin

	nasm -f elf32 ./src/kernel/kernel.asm -o ./build/kernel.o

	nasm -f elf32 ./src/kernel/debug/print_hex_byte.asm -o ./build/debug/print_hex_byte.o

	nasm -f elf32 src/kernel/drivers/vga.asm -o build/vga.o

	nasm -f elf32 src/kernel/arch/x86/idt/idt.asm -o build/idt/idt.o
	nasm -f elf32 src/kernel/arch/x86/idt/iloader.asm -o build/idt/iloader.o
	nasm -f elf32 src/kernel/arch/x86/idt/stubs.asm -o build/idt/stubs.o
	nasm -f elf32 src/kernel/arch/x86/idt/common_exception.asm -o build/idt/common_exception.o
	
	nasm -f elf32 src/kernel/arch/x86/idt/handlers/divide_by_zero.asm -o build/idt/divide_by_zero.o
	nasm -f elf32 src/kernel/arch/x86/idt/handlers/invalid_opcode.asm -o build/idt/invalid_opcode.o
	nasm -f elf32 src/kernel/arch/x86/idt/handlers/general_protection.asm -o build/idt/general_protection.o
	nasm -f elf32 src/kernel/arch/x86/idt/handlers/page_fault.asm -o build/idt/page_fault.o

	nasm -f elf32 src/kernel/arch/x86/pic/pic.asm -o build/pic/pic.o
	nasm -f elf32 src/kernel/arch/x86/pit/pit.asm -o build/pit/pit.o
	nasm -f elf32 src/kernel/arch/x86/irq/stubs.asm -o build/irq/stubs.o
	nasm -f elf32 src/kernel/arch/x86/irq/common_irq.asm -o build/irq/common_irq.o
	nasm -f elf32 src/kernel/arch/x86/irq/irq_loader.asm -o build/irq/irq_loader.o

	nasm -f elf32 src/kernel/arch/x86/irq/handlers/timer.asm -o build/irq/timer.o
	nasm -f elf32 src/kernel/arch/x86/irq/handlers/keyboard.asm -o build/irq/keyboard.o

	ld -m elf_i386 \
		-T src/kernel/linker.ld \
		-o build/kernel.bin \
		--oformat binary \
		$(OBJS)

	cat build/boot.bin build/kernel.bin > build/os.img

plainRun:
	qemu-system-x86_64 -drive format=raw,file=./build/os.img

run: build plainRun

debug: build
	qemu-system-x86_64 \
	-drive format=raw,file=build/os.img \
	-no-reboot -no-shutdown \
	-d int,cpu_reset \
	-D qemu.log \
	-monitor stdio

clean:
	rm -rf build