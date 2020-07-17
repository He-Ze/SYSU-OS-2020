My21h:
	push bx
	push cx
	push dx
	push bp

	cmp ah,0
	jnz _1
	call My21h_0
_1:
    cmp ah,1
	jnz _2
	call My21h_1
_2:
    cmp ah,2
	jnz _3
	call My21h_2
_3:
    cmp ah,3
	jnz _4
	call My21h_3
_4:
    cmp ah,4
	jnz _5
	call My21h_4
_5:
    cmp ah,5
	jnz exit
	call My21h_5
exit:
	pop bp
	pop dx
	pop cx
	pop bx

	iret
My21h_0:

    call Clear

	mov ax,cs
	mov es,ax
	mov ah,13h
	mov al,0
	mov bl,0eh
	mov bh,0
	mov dh,12
	mov dl,38
	mov bp,offset OUCH_MSG
	mov cx,5
	int 10h

	ret
OUCH_MSG:
    db "OUCH!"

My21h_1:
	push dx
	call near ptr _print
	pop dx

	ret

My21h_2:
	push dx
	call near ptr _upper
	pop dx

	ret
My21h_3:

    push dx
	call near ptr _lower
	pop dx
	ret

My21h_4:

	push dx
	call near ptr _BIN2DEC
	pop dx
	ret


My21h_5:

	push dx
	call near ptr _HEX2DEC
	pop dx

	ret


Timer:
    push ax
	push bx
	push cx
	push dx
	push bp
    push es

	dec byte ptr es:[count]
	jnz End1
	inc byte ptr es:[dir]
	cmp byte ptr es:[dir],1              
	jz dir1
	cmp byte ptr es:[dir],2              
	jz dir2
	cmp byte ptr es:[dir],3              
	jz dir3
	jmp show
dir1:
    mov bp,offset str1
	mov bl,0ah
	jmp show
dir2:
    mov bp,offset str2
	mov bl,09h
	jmp show
dir3:
	mov byte ptr es:[dir],0
	mov bp,offset str3
	mov bl,0dh
    jmp show

show:
	mov ah,13h
	mov al,0
	mov bh,0
	mov dh,24
	mov dl,74
	mov cx,5
	int 10h
	mov byte ptr es:[count],delayT
End1:
	mov al,20h
	out 20h,al
	out 0A0h,al

	pop ax
	mov es,ax
	pop bp
	pop dx 
	pop cx
	pop bx
	pop ax
	iret		

	str1 db '/ | \'
	str2 db '| \ /'
	str3 db '\ / |'
	delayT equ 5
	count db delayT
	dir db 0



kbInt:
    push ax
    push bx
    push cx
    push dx
	push bp

	inc byte ptr es:[col]
	cmp byte ptr es:[col],48
	jnz changeRow
	call colInit
changeRow:
	inc byte ptr es:[row]
	cmp byte ptr es:[row],24
	jnz continue
	call rowInit

continue:
	inc byte ptr es:[odd]
	cmp byte ptr es:[odd],1
	je print
	mov byte ptr es:[odd],0
	jmp next

print:
    mov ah,13h
	mov al,0
	mov bl,0ah
	mov bh,0
	mov dh,byte ptr es:[row]
	mov dl,byte ptr es:[col]
	mov bp, offset OUCH
	mov cx,10
	int 10h
    
next:
	in al,60h

	mov al,20h
	out 20h,al
	out 0A0h,al
	
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	
	iret

rowInit:
    mov byte ptr es:[row],0
	ret
colInit:
	mov byte ptr es:[col],0
	ret
OUCH:
    db "OUCH!OUCH!"
	row db 1
	col db 1
	odd db 1

int0x33:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ax,cs
	mov es,ax
	mov ah,13h
	mov al,0
	mov bl,0ah
	mov bh,0
	mov dh,0
	mov dl,0
	mov bp,offset MES1
	mov cx,Mes1Length
	int 10h

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	;push ax
	;mov al,33h
	;out 33h,al
	;out 0A0h,al
	;pop ax
	iret

MES1:
    db "      This is int 33h            ",0ah, 0dh
	Mes1Length  equ ($-MES1) 

int0x34:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ax,cs
	mov es,ax
	mov ah,13h
	mov al,0
	mov bl,0ch
	mov bh,0
	mov dh,5
	mov dl,44
	mov bp,offset MES2
	mov cx,Mes2Length
	int 10h

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,34h
	out 34h,al
	out 0A0h,al
	iret

MES2:
    db "      This is int 34h            ",0ah, 0dh
	Mes2Length  equ ($-MES2) 

int0x35:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ax,cs
	mov es,ax
	mov ah,13h
	mov al,0
	mov bl,0eh
	mov bh,0
	mov dh,13
	mov dl,0
	mov bp,offset MES3
	mov cx,Mes3Length
	int 10h

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,35h
	out 35h,al
	out 0A0h,al
	iret

MES3:
    db "      This is int 35h            ",0ah, 0dh
	Mes3Length  equ ($-MES3)

int0x36:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ax,cs
	mov es,ax
	mov ah,13h
	mov al,0
	mov bl,09h
	mov bh,0
	mov dh,18
	mov dl,39
	mov bp,offset MES4
	mov cx,Mes4Length
	int 10h

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,36h
	out 36h,al
	out 0A0h,al
	iret

MES4:
    db "      This is int 36h            ",0ah, 0dh
	Mes4Length  equ ($-MES4)

	Runtime dw 0	

Pro_Timer:

;* Save *

    cmp word ptr[_processNum],0
	jnz Save
	jmp No_Process
Save:
	inc word ptr[Runtime]
	cmp word ptr[Runtime],512
	jnz Save_continue 
    mov word ptr[_CurPCBNum],0
	mov word ptr[Runtime],0
	mov word ptr[_processNum],0
	mov word ptr[_Segment],2000h
	jmp Pre
Save_continue:
    push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086

	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _SavePCB
	call near ptr _Schedule 
	
Pre:
	mov ax, cs
	mov ds, ax
	mov es, ax
	
	call near ptr _Current_Process
	mov bp, ax

	mov ss,word ptr ds:[bp+0]     ;mov ss,curPCB->ss       
	mov sp,word ptr ds:[bp+16]    ;mov sp,curPCB->sp

	cmp word ptr ds:[bp+32],0     ;判断curPCB->ProcessStatus==NEW?
	jnz No_First_Time

;*  Restart*

Restart:
    call near ptr _special
	
	push word ptr ds:[bp+30]      ;push curPCB->flag
	push word ptr ds:[bp+28]	  ;push curPCB->CS
	push word ptr ds:[bp+26]	  ;push curPCB->IP
	
	push word ptr ds:[bp+2] 	  ;push curPCB->GS
	push word ptr ds:[bp+4] 	  ;push curPCB->FS
	push word ptr ds:[bp+6] 	  ;push curPCB->ES
	push word ptr ds:[bp+8] 	  ;push curPCB->DS
	push word ptr ds:[bp+10]	  ;push curPCB->DI
	push word ptr ds:[bp+12]	  ;push curPCB->SI
	push word ptr ds:[bp+14]	  ;push curPCB->BP
	push word ptr ds:[bp+18]	  ;push curPCB->BX
	push word ptr ds:[bp+20]	  ;push curPCB->DX
	push word ptr ds:[bp+22]	  ;push curPCB->CX
	push word ptr ds:[bp+24]	  ;push curPCB->AX

	pop ax
	pop cx
	pop dx
	pop bx
	pop bp
	pop si
	pop di
	pop ds
	pop es
	.386
	pop fs
	pop gs
	.8086

	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret

No_First_Time:	
	add sp,16 
	jmp Restart
	
No_Process:
    call another_Timer
	
	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret

another_Timer:
    push ax
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	
	mov ax,cs
	mov ds,ax

	cmp byte ptr [ds:tcount],0
	jz case1
	cmp byte ptr [ds:tcount],1
	jz case2
	cmp byte ptr [ds:tcount],2
	jz case3
	
case1:	
    inc byte ptr [ds:tcount]
	mov al,'/'
	jmp another_show
case2:	
    inc byte ptr [ds:tcount]
	mov al,'\'
	jmp another_show
case3:	
    mov byte ptr [ds:tcount],0
	mov al,'|'
	jmp another_show
	
another_show:
    mov bx,0b800h
	mov es,bx
	mov ah,0ah
	mov es:[((80*24+78)*2)],ax
	
	pop ds
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	ret

	tcount db 0