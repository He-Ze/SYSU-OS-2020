OUCH:
    string db "OUCH!OUCH!"
	row dw 0
	col dw 0
	pos dw 0
	rem dw 0


keyDo:
    push ax
    push bx
    push cx
    push dx
	push bp
	push es

	
	cmp word ptr[rem],1
	jnz farjmp
	mov word ptr[rem],0
	inc word ptr[pos]
	cmp word ptr[pos],6
	jnz change_pos
	mov word ptr[pos],1
change_pos:	
	cmp word ptr[pos],1
	je up_pos
	cmp word ptr[pos],2
	je mid_pos
	cmp word ptr[pos],3
	je down_pos
	cmp word ptr[pos],4
	je left_pos
	cmp word ptr[pos],5
	je right_pos
	
farjmp:	
	mov word ptr[rem],1
	jmp keyin	

up_pos:
	mov word ptr[row],4
	mov word ptr[col],35
	jmp printOUCH
mid_pos:
	mov word ptr[row],12
	mov word ptr[col],35
	jmp printOUCH	
down_pos:
	mov word ptr[row],20
	mov word ptr[col],35
	jmp printOUCH	
left_pos:
	mov word ptr[row],12
	mov word ptr[col],10
	jmp printOUCH	
right_pos:
	mov word ptr[row],12
	mov word ptr[col],60
	jmp printOUCH	


printOUCH:
    mov ah,13h
	mov al,0
	mov bl,0ah
	mov bh,0
	mov dh,byte ptr[row]
	mov dl,byte ptr[col]
	mov bp, offset string
	mov cx,10
	int 10h
 
keyin: 
	in al,60h
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