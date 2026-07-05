.PHONY: build run plainRun debug clean

build:
	@mkdir -p build
	nasm -f bin ./src/boot/boot.asm -o ./build/boot.bin

	nasm -f elf32 ./src/kernel/kernel.asm -o ./build/kernel.o

	nasm -f elf32 src/kernel/drivers/vga.asm -o build/vga.o

	nasm -f elf32 src/kernel/arch/x86/idt/idt.asm -o build/idt.o
	nasm -f elf32 src/kernel/arch/x86/idt/iloader.asm -o build/iloader.o
	nasm -f elf32 src/kernel/arch/x86/idt/stubs.asm -o build/stubs.o
	nasm -f elf32 src/kernel/arch/x86/idt/common_exception.asm -o build/common_exception.o
	
	nasm -f elf32 src/kernel/arch/x86/idt/exceptions/divide_by_zero.asm -o build/divide_by_zero.o
	nasm -f elf32 src/kernel/arch/x86/idt/exceptions/invalid_opcode.asm -o build/invalid_opcode.o
	nasm -f elf32 src/kernel/arch/x86/idt/exceptions/general_protection.asm -o build/general_protection.o
	nasm -f elf32 src/kernel/arch/x86/idt/exceptions/page_fault.asm -o build/page_fault.o

	ld -m elf_i386 \
	-T src/kernel/linker.ld \
	-o build/kernel.bin \
	--oformat binary \
	build/kernel.o \
	build/vga.o \
	build/idt.o \
	build/divide_by_zero.o \
	build/invalid_opcode.o \
	build/general_protection.o \
	build/page_fault.o \
	build/common_exception.o \
	build/stubs.o \
	build/iloader.o 

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