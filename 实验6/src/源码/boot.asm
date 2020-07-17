org  07c00h		               ;
Start:
    mov	ax, cs
    mov	ds, ax
    mov	bp, Message
    mov	ax, ds
    mov	es, ax
    mov	cx, MessageLength
    mov	ax, 1301h
    mov	bx, 0007h
    mov dh, 0
    mov	dl, 0
    int	10h
Load:
    mov ax,baseOfSeg
    mov es,ax
    mov bx, OffSetOfKernel
    mov ah,2
    mov al, SegNumOfKernel
    mov dl,0
    mov dh,0
    mov ch,0
    mov cl,2
    int 13H
    jmp baseOfSeg:OffSetOfKernel
    jmp $

Message:
    db 'Loading HeZe OS kernal...'
    MessageLength  equ ($-Message)
    OffSetOfKernel  equ 100h
    baseOfSeg    equ 800h
    SegNumOfKernel equ 17
    times 510-($-$$)	db	0
    db 	0x55, 0xaa
