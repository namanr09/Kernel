
ORG 0
BITS 16  
; 16-bit mode ( Real Mode ) only 1MB of RAM is accessible
_start:
    jmp short start
    nop

times 33 db 0
; Fill the first 33 bytes with zeros to align the code to 512 bytes
; This is necessary for the boot sector to be valid and to ensure that the BIOS can load
; the bootloader correctly.
start:
    jmp 0x7c00:step
    ; Jump to the step of the bootloader code
step:
    cli ; clears interrupts
    ; Disable interrupts to prevent any interruptions during boot
    ; This is important for bootloaders to ensure they can execute without interference
    ; from other processes or hardware interrupts.

    mov ax, 0x7c0
    ; Set the data segment to the boot sector address
    mov ds, ax
    ; Set the data segment register to point to the boot sector address
    mov es, ax
    ; Set the extra segment register to the same address
    ; This is necessary for accessing the boot sector data
    mov ss, ax
    ; Set the stack segment to the boot sector address
    mov sp, 0x7c00
    ; Set the stack pointer to the top of the boot sector
    ; This is where the stack will be located in memory

    sli ; Set the direction flag to clear the carry flag
    ; This is a common practice in bootloaders to ensure that string operations work correctly
    mov si, message
    call print
    jmp $ 
; Infinite loop to keep the bootloader running

print:
    ; move bx, 0
.loop:
    lodsb
    cmp al,0
    je .done
    call print_char
    jmp .loop
.done :
    ret
print_char:
    mov ah, 0eh
    int 0x10
    ; BIOS interrupt to print character
    ret
message:
    db  'updated bootloader loaded successfully!', 0x0D, 0x0A
    db 'Hello World!!!', 0x0D, 0x0A

times 510 - ($ -$$) db 0 ; Fill the rest of the boot sector with zeros
dw 0xAA55 ; Boot sector signature