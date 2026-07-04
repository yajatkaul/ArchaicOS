.PHONY: build run plainRun debug clean

build:
	@mkdir -p build
	nasm -f bin ./src/boot/boot.asm -o ./build/boot.bin

	nasm -f elf32 ./src/kernel/kernel.asm -o ./build/kernel.o
	nasm -f elf32 src/kernel/vga.asm -o build/vga.o

	nasm -f elf32 src/kernel/interrupt/idt.asm -o build/idt.o
	nasm -f elf32 src/kernel/interrupt/divide_by_zero.asm -o build/divide_by_zero.o
	nasm -f elf32 src/kernel/interrupt/iloader.asm -o build/iloader.o

	ld -m elf_i386 \
	-T src/kernel/linker.ld \
	-o build/kernel.bin \
	--oformat binary \
	build/kernel.o \
	build/vga.o \
	build/idt.o \
	build/divide_by_zero.o \
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