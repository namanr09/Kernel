; Bootloader code to load a kernel from disk
ORG 0x7c00 
; Boot sector starts at 0x7c00
; ideadlly it should start at 0x0000, but BIOS loads it to 0x7c00
BITS 16 
; Use 16-bit mode   

start:
    mov si, message
    call print
    ; Print the message
    jmp $

print: 
    mov bx, 0
    ; Set BX to 0 (video memory)
.loop:
    lodsb 
    ; Load the string address into SI
    cmp al,0
    je .done
    ; Check if the character is null (end of string)
    call print_char
    ; Call the function to print the character
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh 
    ; Function to read sectors
    ; mov al, 'A' 
    ; Character to print
    mov bx, 0x0000 
    int 0x10 
    ; BIOS interrupt to print character
    ; thats why bios is like a kernel itself
    ret

message:
    db 'Hello, World!', 0x0D, 0x0A ; Message to print
    db 'Bootloader loaded successfully!', 0x0D, 0x0A
; signature 
times 510-($ - $$) db 0 ; Fill the rest of the boot sector with zeros
dw 0xAA55 ; Boot sector signature