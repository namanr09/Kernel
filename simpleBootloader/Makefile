all:
	nasm -f bin ./bootUpdated.asm -o ./bootUpdated.bin
	dd if=./message.txt >> ./bootUpdated.bin
	dd if=/dev/zero bs=512 count=1 >> ./bootUpdated.bin 
	qemu-system-x86_64 -hda ./bootUpdated.bin 