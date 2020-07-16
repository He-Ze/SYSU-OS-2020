extrn _run33:near
extrn _run34:near
extrn _run35:near
extrn _run36:near

.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT
DGROUP group _TEXT,_DATA,_BSS
start:

;调用0号功能
public _showOUCH
_showOUCH proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call Clear

	mov ah,0
    int 21h

	call DelaySome
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_showOUCH endp

;调用1号功能 
public _upper
_upper proc 
    push bp
	mov	bp,sp
	push si
	mov	si,word ptr [bp+4]

    push ax
    push bx
    push cx
    push dx
	push es

	mov ah,1
	mov dx,si
    int 21h
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax

	pop si
	pop bp
	ret
_upper endp


;调用2号功能 
public _lower
_lower proc 
    push bp
	mov	bp,sp
	push si
	mov	si,word ptr [bp+4]

    push ax
    push bx
    push cx
    push dx
	push es

	mov ah,2
	mov dx,si
    int 21h
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax

	pop si
	pop bp
	ret
_lower endp

;调用3号功能 
public _int21h_call33h
_int21h_call33h proc 
	push ax
    push bx
    push cx
    push dx
	push es
		call Clear
		mov ah,3
		int 21h
		call DelaySome
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_int21h_call33h endp

;调用4号功能
public _int21h_call34h
_int21h_call34h proc 
	push ax
    push bx
    push cx
    push dx
	push es
		call Clear
		mov ah,4
		int 21h
		call DelaySome
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_int21h_call34h endp

;调用5号功能
public _int21h_call35h
_int21h_call35h proc 
	push ax
    push bx
    push cx
    push dx
	push es
		call Clear
		mov ah,5
		int 21h
		call DelaySome
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_int21h_call35h endp

;调用6号功能
public _int21h_call36h
_int21h_call36h proc 
	push ax
    push bx
    push cx
    push dx
	push es
		call Clear
		mov ah,6
		int 21h
		call DelaySome
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_int21h_call36h endp

;调用7号功能
public _int21h_run4prog
_int21h_run4prog proc 
	push ax
    push bx
    push cx
    push dx
	push es
		call Clear
		mov ah,7
		int 21h
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_int21h_run4prog endp

;调用8号功能
public _int21h_showdata
_int21h_showdata proc 
    push ax
    push bx
    push cx
    push dx
	push es

	call Clear

	mov ah,8
    int 21h

	call DelaySome
   
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_int21h_showdata endp

 

DelaySome:
    mov cx,delayTime      
toDelay:
	mov word ptr es:[t],cx
	mov cx,delayTime
	loop1:loop loop1 
	mov cx,word ptr es:[t]
	loop toDelay
	ret

Clear:
    MOV AX,0003H
    INT 10H
	ret

	delayTime equ 40000
	t dw 0

_TEXT ends
_DATA segment word public 'DATA'
_DATA ends
_BSS	segment word public 'BSS'
_BSS ends
end start
