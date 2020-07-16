BIN = boot.bin prog1.bin prog2.bin prog3.bin prog4.bin
IMG = heze.img
all: clear $(BIN) $(IMG)
clear:
	rm -f $(BIN) $(IMG)
%.bin: %.asm
	nasm -fbin $< -o $@
%.img:
	/sbin/mkfs.msdos -C $@ 1440
	dd if=boot.bin of=$@ conv=notrunc
	dd if=MYOS.COM of=$@ seek=1 conv=notrunc
	dd if=prog1.bin of=$@ seek=25 conv=notrunc
	dd if=prog2.bin of=$@ seek=26 conv=notrunc
	dd if=prog3.bin of=$@ seek=27 conv=notrunc
	dd if=prog4.bin of=$@ seek=28 conv=notrunc
clean:
	rm *.bin
