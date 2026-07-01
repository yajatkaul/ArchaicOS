.PHONY: build run plainRun debug clean

build:
	@mkdir -p build
	nasm -f bin ./src/boot/boot.asm -o ./build/boot.bin
	nasm -f bin ./src/kernel/kernel.asm -o ./build/kernel.bin

	cat build/boot.bin build/kernel.bin > build/os.img

plainRun:
	qemu-system-x86_64 -drive format=raw,file=./build/os.img

run: build plainRun

# can use commands like info registers to see all register info
debug: build
	qemu-system-x86_64 \
	-drive format=raw,file=build/os.img \
	-monitor stdio

clean:
	rm -rf build