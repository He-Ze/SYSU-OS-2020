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


public _cls
_cls proc 
	mov ax,0003H
	int	10h		; 显示中断
	ret
_cls endp


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
	
	xor ax,ax
	mov es,ax
	push word ptr es:[9*4]
	pop word ptr ds:[0]
	push word ptr es:[9*4+2]
	pop word ptr ds:[2]

	mov word ptr es:[24h],offset keyDo
	mov ax,cs 
	mov word ptr es:[26h],ax
	
		mov ax, 1000h
		mov es, ax 		                
		mov bx, 7e00h
		mov ah, 2
		mov al, 1
		mov dl, 0
		mov dh, 1
		mov ch, 0
		mov cl, byte ptr[_num]
		int 13H
		mov bx, 7e00h
		call bx
		
	xor ax,ax
	mov es,AX
	push word ptr ds:[0]
	pop word ptr es:[9*4]
	push word ptr ds:[2]
	pop word ptr es:[9*4+2]
	int 9h	
		
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_run endp


delay equ 3
count db delay				
ch1 db '|'
ch2 db '/'
ch3 db '\'        
remark db 3
Timer:
    push ax
	push bx
	push cx
	push dx
	push bp
    push es
		dec byte ptr [count]				
		jnz int_end						                   
		cmp byte ptr [remark],3             
		jz first
		cmp byte ptr [remark],2            
		jz second
		mov byte ptr [remark],4             
		jmp third
	first:
		mov bp,offset ch1
		jmp show
	second:
		mov bp,offset ch2
		jmp show
	third:
		mov bp,offset ch3
		jmp show

	show:
		dec byte ptr [remark]
		mov ah,13h
		mov al,0
		mov bl,0fh
		mov bh,0
		mov cx,1
		mov dh,0
		mov dl,79
	loop1:	
		int 10h
		add dh,2	
		cmp dh,24
		jne loop1                    	
		mov byte ptr es:[count],delay
int_end:
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop es
	pop bp
	pop dx 
	pop cx
	pop bx
	pop ax
	iret