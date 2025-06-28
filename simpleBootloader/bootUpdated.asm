
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
    jmp 0x7c0:step
    ; Jump to the step of the bootloader code

handle_zero:
    mov ah, 0eh
    mov al, 'A'
    mov bx, 0x00
    int 0x10
    iret
    ; Interrupt handler for zeroth interrupt
    ; This is a placeholder for the zeroth interrupt handler 
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
    mov ax, 0x00
    mov ss, ax
    ; Set the stack segment to the boot sector address
    mov sp, 0x7c00
    ; Set the stack pointer to the top of the boot sector
    ; This is where the stack will be located in memory

    sti ; Enable interrupts
    ; Enable interrupts after setting up the bootloader environment
    ;   create interrupts ourself

    mov word[ss:0x00], handle_zero
    mov word[ss:0x02], 0x7c0
    int 0
    ; Set the direction flag to clear the carry flag
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
    ; Function to print a character to the screen
    ; BIOS interrupt to print character
    ret
message:
    db  'updated bootloader loaded successfully!', 0x0D, 0x0A
    db 'Hello World!!!', 0x0D, 0x0A

times 510 - ($ -$$) db 0 ; Fill the rest of the boot sector with zeros
dw 0xAA55 ; Boot sector signature