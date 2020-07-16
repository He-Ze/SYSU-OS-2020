extrn  _main:near
extrn _in:near
extrn _hour:near
extrn _min:near
extrn _sec:near
extrn _num:near

.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT
DGROUP group _TEXT,_DATA,_BSS
org 100h

start:
    xor ax,ax			; AX = 0
	mov es,ax			; ES = 0
	mov ax,offset Timer
	mov word ptr es:[20h],offset Timer		        ; 设置时钟中断向量的偏移地址
	mov ax,cs
	mov word ptr es:[22h],cs				        ; 设置时钟中断向量的段地址=CS

	call setINT

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

;*************** ********************
; 清屏
public _clean
_clean proc
	mov ax,0003H
	int	10h		; 显示中断
	ret
_clean endp


; 字符输出
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


; 读入一个字符
public _getchar
_getchar proc
	mov ah,0
	int 16h
	mov byte ptr[_in],al
	ret
_getchar endp


; 获取时间
public _gettime
_gettime proc
    push ax
    push bx
    push cx
    push dx

    mov ah,2h
    int 1ah
	mov byte ptr[_hour], ch      ;将时放到hour
	mov byte ptr[_min], cl       ;将分放到min
	mov byte ptr[_sec], dh       ;将秒放到sec

	pop dx
	pop cx
	pop bx
	pop ax
	ret
_gettime endp



; 加载并运行程序
public _run
_run proc
    push ax
    push bx
    push cx
    push dx
	push es

	xor ax,ax
	mov es,ax
	push word ptr es:[9*4]                  ; 保存 9h 中断
	pop word ptr ds:[0]
	push word ptr es:[9*4+2]
	pop word ptr ds:[2]

	mov word ptr es:[24h],offset keyDo		; 设置键盘中断向量的偏移地址
	mov ax,cs
	mov word ptr es:[26h],ax
	mov ax, 1000h
	mov es, ax
	mov bx, 1c00h           ;ES:BX=读入数据到内存中的存储地址
	mov ah, 2 		        ;功能号
	mov al, 1 	            ;要读入的扇区数1
	mov dl, 0               ;软盘驱动器号
	mov dh, 0 		        ;磁头号
	mov ch, 0               ;柱面号
	mov cl, byte ptr[_num]  ;起始扇区号（编号从1开始）
	int 13H 		        ;调用13H号中断
	mov bx, 1c00h           ;将偏移量放到 bx
	call 1000h:bx           ;跳转到该内存地址

	xor ax,ax
	mov es,AX
	push word ptr ds:[0]                     ; 恢复 9h 中断
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


;设置时钟中断向量（08h），初始化段寄存器
;系统时钟中断，自动执行，无需调用
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
		mov ah,13h 	                        ; 功能号
		mov al,0                     		; 光标放到串尾
		mov bl,0fh 	                        ; 亮白
		mov bh,0 	                    	; 第0页
		mov cx,1 	                        ; 串长为 1
		mov dh,0 	                        ; 第0行
		mov dl,79							; 第79列
	loop1:
		int 10h								; 调用10H号中断
		add dh,2
		cmp dh,24
		jne loop1
		mov byte ptr es:[count],delay
int_end:
	mov al,20h					        ; AL = EOI
	out 20h,al						    ; 发送EOI到主8529A
	out 0A0h,al					        ; 发送EOI到从8529A
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	iret

OUCH:
    string db "OUCH!OUCH!"
	row dw 0
	col dw 0
	pos dw 0; 位置;1-5分别对应上中下左右
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
    mov ah,13h 	                    ; 功能号
	mov al,0                 		; 光标放到串尾
	mov bl,0ah 	                    ; 亮绿
	mov bh,0 	                	; 第0页
	mov dh,byte ptr[row] 	        ; 第 c 行
	mov dl,byte ptr[col]  	        ; 第35列
	mov bp, offset string 	        ; BP=串地址
	mov cx,10  	                    ; 串长为 10
	int 10h 		                ; 调用10H号中断

keyin:
	in al,60h
	mov al,20h					    ; AL = EOI
	out 20h,al						; 发送EOI到主8529A
	out 0A0h,al					    ; 发送EOI到从8529A
	pop es
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	iret							; 从中断返回

;中断设置
setINT:
	push ax
	push es

	xor ax,ax
	mov es,ax
	mov word ptr es:[51*4],offset int_33h		;33h
	mov ax, cs
	mov word ptr es:[51*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[52*4],offset int_34h		; 34h
	mov ax, cs
	mov word ptr es:[52*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[53*4],offset int_35h		; 35h
	mov ax, cs
	mov word ptr es:[53*4+2],ax

	xor ax,ax
	mov es,ax
	mov word ptr es:[54*4],offset int_36h		; 36h
	mov ax, cs
	mov word ptr es:[54*4+2],ax

	pop es
	pop ax
ret

;**************** *******************
;调用33h中断
public _run33
_run33 proc
    push ax
    push bx
    push cx
    push dx
	push es

	call _clean

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

;***********************************
; 调用34h中断
public _run34
_run34 proc
    push ax
    push bx
    push cx
    push dx
	push es

	call _clean

    int 34h
  call DelaySome
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_run34 endp

;***********************************
; 调用35h中断
public _run35
_run35 proc
    push ax
    push bx
    push cx
    push dx
	push es

	call _clean

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

;***********************************
; 调用36h中断
public _run36
_run36 proc
    push ax
    push bx
    push cx
    push dx
	push es

	call _clean

    int 36h
 call DelaySome
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_run36 endp



;*****************************************
int_33h:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h 	                ; 功能号
	mov al,0 	            	; 光标放到串尾
	mov bl,05h 	                ; 亮绿
	mov bh,0 		            ; 第0页
	mov dh,0 	                ; 第0行
	mov dl,0 	                ; 第0列
	mov bp,offset message33 	; BP=串地址
	mov cx,356 	                ; 串长4
	int 10h 		            ; 调用10H号中断

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,33h					; AL = EOI
	out 33h,al					; 发送EOI到主8529A
	out 0A0h,al					; 发送EOI到从8529A
	iret						; 从中断返回

message33:
    db "  ************     ************",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "           ***              ***",0ah,0dh
	db "           ***              ***",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "           ***              ***",0ah,0dh
	db "           ***              ***",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "  ************     ************",0ah,0dh
	db 0ah,0dh
    db "        This is INT 33H!",'$'

int_34h:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h 	                ; 功能号
	mov al,0             		; 光标放到串尾
	mov bl,0ch 	                ; 亮绿
	mov bh,0             		; 第0页
	mov dh,0 	                ; 第5行
	mov dl,40 	                ; 第44列
	mov bp,offset message34     ; BP=串地址
	mov cx,756 	                ; 串长
	int 10h 		            ; 调用10H号中断

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,34h					; AL = EOI
	out 34h,al					; 发送EOI到主8529A
	out 0A0h,al					; 发送EOI到从8529A
	iret						; 从中断返回

message34:
    db "  ************     ***      ***",0ah,0dh
	db "                                        "
	db "  ************     ***      ***",0ah,0dh
	db "                                        "
	db "           ***     ***      ***",0ah,0dh
	db "                                        "
	db "           ***     ***      ***",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db "                                        "
	db "           ***              ***",0ah,0dh
	db "                                        "
	db "           ***              ***",0ah,0dh
	db "                                        "
	db "  ************              ***",0ah,0dh
	db "                                        "
	db "  ************              ***",0ah,0dh
	db 0ah,0dh
	db "                                        "
    db "        This is INT 34H!",'$'


int_35h:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h 	                 ; 功能号
	mov al,0 		             ; 光标放到串尾
	mov bl,0eh 	                 ; 黄色
	mov bh,0 	                 ; 第0页
	mov dh,13 	                 ; 第13行
	mov dl,0 	                 ; 第0列
	mov bp,offset message35 	 ; BP=串地址
	mov cx,356 	                 ; 串长
	int 10h 		             ; 调用10H号中断

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,35h					; AL = EOI
	out 35h,al					; 发送EOI到主8529A
	out 0A0h,al					; 发送EOI到从8529A
	iret						; 从中断返回

message35:
    db "  ************     ************",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "           ***     ***         ",0ah,0dh
	db "           ***     ***         ",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "           ***              ***",0ah,0dh
	db "           ***              ***",0ah,0dh
	db "  ************     ************",0ah,0dh
	db "  ************     ************",0ah,0dh
	db 0ah,0dh
    db "        This is INT 35H!",'$'



int_36h:
    push ax
	push bx
	push cx
	push dx
	push bp

	mov ah,13h 	                ; 功能号
	mov al,01h 	             	; 光标放到串尾
	mov bl,09h
	mov bh,0 	                ; 第0页
	mov dh,13 	                ; 第13行
	mov dl,40 	                ; 第40列
	mov bp,offset message36 	; BP=串地址
	mov cx,756 	                ; 串长
	int 10h 		            ; 调用10H号中断

	pop bp
	pop dx
	pop cx
	pop bx
	pop ax

	mov al,36h					; AL = EOI
	out 36h,al					; 发送EOI到主8529A
	out 0A0h,al					; 发送EOI到从8529A
	iret						; 从中断返回

message36:
    db "  ************     ************",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db "                                        "
	db "           ***     ***         ",0ah,0dh
	db "                                        "
	db "           ***     ***         ",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db "                                        "
	db "           ***     ***      ***",0ah,0dh
	db "                                        "
	db "           ***     ***      ***",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db "                                        "
	db "  ************     ************",0ah,0dh
	db 0ah,0dh
	db "                                        "
    db "        This is INT 36H!",'$'


DelaySome:                          ; 延迟一段时间
    mov cx,40000
toDelay:
	push cx
	mov cx,40000
	looptime:loop looptime
	pop cx
	loop toDelay
	ret

_TEXT ends
_DATA segment word public 'DATA'
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
end start