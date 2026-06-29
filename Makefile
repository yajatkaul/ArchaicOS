.PHONY: build run buildRun

build:
	@mkdir -p build
	nasm -f bin boot.asm -o ./build/boot.bin

run:
	qemu-system-x86_64 -drive format=raw,file=./build/boot.bin

buildRun: build run