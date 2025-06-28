; Bootloader code to load a kernel from disk
ORG 0x7c00 
; Boot sector starts at 0x7c00
; ideadlly it should start at 0x0000, but BIOS loads it to 0x7c00
BITS 16 
; Use 16-bit mode   

start:
    mov ah, 0eh 
    ; Function to read sectors
    mov al, 'A' 
    ; Character to print
    mov bx, 0x0000 
    ; Set BX to 0 (video memory)
    int 0x10 
    ; BIOS interrupt to print character
    ; thats why bios is like a kernel itself

    jmp $

; signature 
times 510-($ - $$) db 0 ; Fill the rest of the boot sector with zeros
dw 0xAA55 ; Boot sector signature