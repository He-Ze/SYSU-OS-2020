org 07C00H

Start:
	mov ax, cs
	mov ds, ax
	mov bp, Message
	mov ax, ds
	mov es, ax
	mov cx, MessageLength
	mov ax, 1301H
	mov bx, 001FH
	mov dx, 0
	int 10H

Load:
	mov ax, 1000h
    mov es, ax
    mov bx, 100h
    mov ah, 02H
    mov al, 13
    mov ch, 00H
    mov cl, 02H
    mov dh, 00H
    mov dl, 00H
    int 13H
    jmp 1000H:0100H

Message:
	db "18340052 HeZe's OS ", 0DH, 0AH
	db "Waiting......"
	MessageLength  equ ($-Message)
	times 510-($-$$) db 0
	dw 0xaa55
	   