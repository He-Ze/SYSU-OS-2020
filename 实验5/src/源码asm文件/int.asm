setINT:
	push ax
	push es
	
	xor ax,ax
	mov es,ax
	mov word ptr es:[33*4],offset int_21h
	mov ax,cs 
	mov word ptr es:[33*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[51*4],offset int_33h
	mov ax, cs
	mov word ptr es:[51*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[52*4],offset int_34h
	mov ax, cs
	mov word ptr es:[52*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[53*4],offset int_35h
	mov ax, cs
	mov word ptr es:[53*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[54*4],offset int_36h
	mov ax, cs
	mov word ptr es:[54*4+2],ax
	
	pop es
	pop ax
ret


public _run33
_run33 proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call _cls

    int 33h
call DelaySome
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_run33 endp


public _run34
_run34 proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call _cls

    int 34h
  call DelaySome
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_run34 endp


public _run35
_run35 proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call _cls

    int 35h
call DelaySome
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_run35 endp


public _run36
_run36 proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call _cls

    int 36h
 call DelaySome
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_run36 endp


int_21h:
	push bx
	push cx
	push dx
	push bp

	cmp ah,0
	jnz cmp1
	call int_21h_0
    jmp end_21h
cmp1:
    cmp ah,1
	jnz cmp2
	call int_21h_1
    jmp end_21h
cmp2:
    cmp ah,2
	jnz cmp3
	call int_21h_2
    jmp end_21h
cmp3:
    cmp ah,3
	jnz cmp4
	call int_21h_3
    jmp end_21h
cmp4:
    cmp ah,4
	jnz cmp5
	call int_21h_4
    jmp end_21h
cmp5:
    cmp ah,5
	jnz cmp6
	call int_21h_5
    jmp end_21h
cmp6:
    cmp ah,6
	jnz cmp7
	call int_21h_6
    jmp end_21h
cmp7:
    cmp ah,7
	jnz cmp8
	call int_21h_7
    jmp end_21h
cmp8:
    cmp ah,8
	jnz end_21h
	call int_21h_8
    jmp end_21h

end_21h:
	pop bp
	pop dx
	pop cx
	pop bx

	iret						


int_33h:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h
	mov al,0
	mov bl,05h
	mov bh,0
	mov dh,5
	mov dl,10
	mov bp,offset message33
	mov cx,16
	int 10h

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,33h
	out 33h,al
	out 0A0h,al
	iret

message33:
    db "This is INT 33H!",'$'

int_34h:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h
	mov al,0
	mov bl,0ch
	mov bh,0
	mov dh,5
	mov dl,50
	mov bp,offset message34
	mov cx,16
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

message34:                                 
    db "This is INT 34H!",'$'


int_35h:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h
	mov al,0
	mov bl,0eh
	mov bh,0
	mov dh,18
	mov dl,10
	mov bp,offset message35
	mov cx,16
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

message35:
    db "This is INT 35H!",'$'



int_36h:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h
	mov al,01h
	mov bl,09h 	                
	mov bh,0
	mov dh,18
	mov dl,50
	mov bp,offset message36
	mov cx,16
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

message36:             
    db "This is INT 36H!",'$'
	
	
DelaySome:
    mov cx,40000      
toDelay:
	push cx
	mov cx,40000
	looptime:loop looptime 
	pop cx
	loop toDelay
	ret	


int_21h_0:

    call _cls

	mov ah,13h
	mov al,0
	mov bl,0eh 	                
	mov bh,0
	mov dh,12
	mov dl,38
	mov bp,offset MES_OUCH
	mov cx,5
	int 10h

	ret

MES_OUCH:
    db "OUCH!"



int_21h_1:
    push dx
	call near ptr _to_upper
	pop dx
	ret


int_21h_2:
    push dx
	call near ptr _to_lower
	pop dx
	ret


int_21h_3:
	call _run33     
	ret


int_21h_4:
	call _run34     
	ret
	

int_21h_5:
	call _run35     
	ret


int_21h_6:
	call _run36     
	ret


int_21h_7:
	call near ptr _to_run_myprogram
	ret


int_21h_8:

    call _cls

	mov ah,13h
	mov al,0
	mov bl,09h
	mov bh,0
	mov dh,11
	mov dl,25
	mov bp,offset MES_data
	mov cx,70
	int 10h

	ret

MES_data:
    db "Name       : HeZe     ",0dh,0ah
	db "                         "
	db "StudentID  : 18340052"