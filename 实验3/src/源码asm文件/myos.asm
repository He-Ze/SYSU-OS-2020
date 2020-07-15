extrn  _main:near
extrn _hour:near            
extrn _min:near       
extrn _sec:near       
extrn _num:near
extrn _in:near


.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT
DGROUP group _TEXT,_DATA,_BSS
org 100h


start:
	mov ax, cs
	mov ds, ax           
	mov es, ax           
	mov ss, ax  
	mov sp, 0FFFCH      
	call near ptr _main
	jmp $


public SCOPY@
SCOPY@ proc
	arg_0 = dword ptr 6
	arg_4 = dword ptr 0ah
	push bp
	mov bp,sp
	push si
	push di
	push ds
	lds si,[bp+arg_0]
	les di,[bp+arg_4]
	cld
	shr cx,1
	rep movsw
	adc cx,cx
	rep movsb
	pop ds
	pop di
	pop si
	pop bp
	retf 8
SCOPY@ endp


public _clean
_clean proc
	mov ax,0003H
	int	10h
	ret
_clean endp


public _printchar
_printChar proc
	push bp

	mov bp,sp
	mov al,[bp+4]
	mov bl,0
	mov ah,0eh
	int 10h
	mov sp,bp

	pop bp
	ret
_printchar endp


public _getchar
_getchar proc
	mov ah,0
	int 16h
	mov byte ptr[_in],al
	ret
_getchar endp


public _gettime
_gettime proc
    push ax
    push bx
    push cx
    push dx

    mov ah,2h
    int 1ah
	mov byte ptr[_hour], ch
	mov byte ptr[_min], cl
	mov byte ptr[_sec], dh

	pop dx
	pop cx
	pop bx
	pop ax
	ret
_gettime endp


public _run
_run proc
    push ax
    push bx
    push cx
    push dx
    push es

    mov ax, 1000h
    mov es, ax
    mov bx, 1400h
    mov ah, 2
    mov al, 1
    mov dl, 0
    mov dh, 0
    mov ch, 0
    mov cl, byte ptr[_num]
    int 13H
    mov bx, 1400h
    call 1000h:bx

    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret
    _run endp


_TEXT ends
_DATA segment word public 'DATA'
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
end start