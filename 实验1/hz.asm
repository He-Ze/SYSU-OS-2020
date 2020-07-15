    org 07c00h					; 程序加载到100h，可用于生成COM
	Dn_Rt equ 1                 ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2                  
    Up_Lt equ 3                  
    Dn_Lt equ 4   
    delay equ 50000				; 计时器延迟计数,用于控制画框的速度
    ddelay equ 580				; 计时器延迟计数,用于控制画框的速度
;以下一段为引导扇区程序
	mov ax,cs
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov ax,0b800h
	mov gs,ax
	call name	;显示学号和姓名
	call start	;显示数字
	jmp $

name:
	mov	bp, 0	 ; BP=当前串的偏移地址
	mov byte[gs:bp+0],'1'
	mov byte[gs:bp+2],'8'
	mov byte[gs:bp+4],'3'
	mov byte[gs:bp+6],'4'
	mov byte[gs:bp+8],'0'
	mov byte[gs:bp+10],'0'
	mov byte[gs:bp+12],'5'
	mov byte[gs:bp+14],'2'
	mov byte[gs:bp+16],'H'
	mov byte[gs:bp+18],'e'
	mov byte[gs:bp+20],'Z'
	mov byte[gs:bp+22],'e'
	ret 
	
start:
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax					; GS = B800h
    mov byte[char],'0'
	
loop1:
	dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
	mov word[count],delay		;延时
	
	dec word[dcount]			; 递减计数变量
    jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay		;延时

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
	jz  DnLt					;决定运动方向
    jmp $	

DnRt:							;向右下运动
	inc word[x]
	inc word[y]
	mov ax,word[x]
	cmp ax,81					;判断是否已经超界,x取值范围0-79
    jz  dr2dl
	mov ax,word[y]
	cmp ax,26					;判断是否已经超界,y取值范围1-25
    jz  dr2ur
	jmp show
	
dr2ur:
    mov word[y],24
    mov byte[rdul],Up_Rt	
    jmp show
    
dr2dl:
    mov word[x],79				;x-2=78
    mov byte[rdul],Dn_Lt	
    jmp show

UpRt:							;每走一步，x+1,y-1
	;mov al,'O'
	;mov byte[char],al
	inc word[x]
	dec word[y]
	mov ax,word[y]
	cmp ax,1
    jz  ur2dr
	mov ax,word[x]
	cmp ax,81
    jz  ur2ul
	jmp show
	
ur2ul:
    mov word[x],79
    mov byte[rdul],Up_Lt	
    jmp show
    
ur2dr:
    mov word[y],3
    mov byte[rdul],Dn_Rt	
    jmp show
	
UpLt:	
	dec word[x]
	dec word[y]
	mov ax,word[x]
	cmp ax,0
	jz  ul2ur
	mov ax,word[y]
	cmp ax,1
    jz  ul2dl
	jmp show

ul2dl:
    mov word[y],3
    mov byte[rdul],Dn_Lt	
    jmp show
    
ul2ur:
    mov word[x],2
    mov byte[rdul],Up_Rt	
    jmp show
	
DnLt:
	dec word[x]
	inc word[y]
	mov ax,word[x]
	cmp ax,0
    jz  dl2dr
	mov ax,word[y]
	cmp ax,26
    jz  dl2ul
	jmp show

dl2dr:
    mov word[x],2
    mov byte[rdul],Dn_Rt	
    jmp show
	
dl2ul:
    mov word[y],24
    mov byte[rdul],Up_Lt	
    jmp show
	
show:	
    ; 计算显存地址
	mov ax,word[y]
	dec ax
	mov bx,160
	mul bx
	mov cx,ax	;存储在cx
	mov ax,word[x]
	dec ax
	add ax,ax
	add ax,cx
	mov bp,ax
	mov ah,byte[color]			;  0000：黑底、1111：亮白字（默认值为07h）
	mov al,byte[char]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax  		;  显示字符的ASCII码值
	cmp ah,10
	jnz addColor
	mov byte[color],2
	jmp go
	
addColor:	
	inc byte[color]
	
go:	
    mov ah,byte[char]
    cmp ah,57
    jnz addchar
    mov byte[char],48
    jmp goway
    
addchar: 
	inc byte[char] 
	
goway:              
    jmp loop1
	
end:
    jmp $                   ; 停止画框，无限循环 
	
datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; 向右下运动
    x    dw 3
    y    dw 1
    char db 97
	color db 2