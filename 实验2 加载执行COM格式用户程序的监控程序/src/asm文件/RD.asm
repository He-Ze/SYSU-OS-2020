Dn_Rt equ 1
Up_Rt equ 2
Up_Lt equ 3
Dn_Lt equ 4
delay equ 50000
ddelay equ 800

org 0xD100

start:
    mov ax,cs
	mov es,ax
	mov ds,ax
	mov es,ax
	mov ax,0B800h
	mov gs,ax
clear:
    mov ah,0x06
    mov al,0
    mov ch,0
    mov cl,0
    mov dh,24
    mov dl,79
    mov bh,0x0
    int 10h
main:
	dec word[count]
	jnz main
	dec word[dcount]
    jnz main
	mov word[count],delay
	mov word[dcount],ddelay

    mov al,1
    cmp al,byte[rdul]
	jz  DnRt
    mov al,2
    cmp al,byte[rdul]
	jz  UpRt
    mov al,3
    cmp al,byte[rdul]
	jz  UpLt
    mov al,4
    cmp al,byte[rdul]
	jz  DnLt
    jmp $

DnRt:
    inc word[x]
	inc word[y]

	mov bx,word[x]
	mov ax,25
    sub ax,bx
    jz  dr2ur

	mov bx,word[y]
    mov ax,80
	sub ax,bx
    jz  dr2dl
    jmp show
dr2ur:
    mov word[x],23
    mov byte[rdul],Up_Rt
   	jmp changeColor
dr2dl:
    mov word[y],78
    mov byte[rdul],Dn_Lt
    jmp changeColor

UpRt:
	dec word[x]
	inc word[y]
	mov bx,word[y]
	mov ax,80
	sub ax,bx
    jz  ur2ul
	mov bx,word[x]
	mov ax,12
	sub ax,bx
    jz  ur2dr
	jmp show
ur2ul:
	mov word[y],78
    mov byte[rdul],Up_Lt
	jmp changeColor
ur2dr:
    mov word[x],14
    mov byte[rdul],Dn_Rt
    jmp changeColor

UpLt:
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,12
	sub ax,bx
    jz  ul2dl
	mov bx,word[y]
	mov ax,39
	sub ax,bx
    jz  ul2ur
	jmp show
ul2dl:
    mov word[x],14
    mov byte[rdul],Dn_Lt
    jmp changeColor
ul2ur:
    mov word[y],41
    mov byte[rdul],Up_Rt
    jmp changeColor

DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,39
	sub ax,bx
    jz  dl2dr
	mov bx,word[x]
	mov ax,25
	sub ax,bx
    jz  dl2ul
	jmp show

dl2dr:
    mov word[y],41
    mov byte[rdul],Dn_Rt
    jmp changeColor

dl2ul:
    mov word[x],23
    mov byte[rdul],Up_Lt
    jmp changeColor

changeColor:
	mov ax,word[color]
	sub ax,1
	mov byte[color],al
	jnz show
	mov byte[color],0Fh

show:
    mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	mov ah,byte[color]
	mov al,byte[char]
	mov word[gs:bp],ax

	xor ax,ax
	mov ah,1
	int 0x16
	cmp al,27
	jne main
	jmp 7c00h

end:
    jmp $

datadef:
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt
    x    dw 7
    y    dw 0
    char db '4'
    color db 06h
	times 510-($-$$) db 0
    db 0x55,0xaa