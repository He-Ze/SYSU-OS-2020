org  7c00h

OffSetOfLU equ 0xA100
OffSetOfRU equ 0xB100
OffSetOfLD equ 0xC100
OffSetOfRD equ 0xD100

clear:
      mov ah,0x06
      mov al,0
      mov ch,0
      mov cl,0
      mov dh,24
      mov dl,79
      mov bh,0x0
      int 10h
      
Start:
mov    ax, cs
mov    ds, ax

;显示学号姓名
mov    bp, Name
mov    ax, ds
mov    es, ax
mov    cx, NameLength
mov    ax, 1301h
mov    bx, 0007h
mov    dh, 0
mov    dl, 1
int    10h

;显示信息1
mov    bp, Message1
mov    ax, ds
mov    es, ax
mov    cx, Message1Length
mov    ax, 1301h
mov    bx, 0007h
mov    dh, 1
mov    dl, 1
int    10h

;显示信息2
mov    bp, Message2
mov    ax, ds
mov    es, ax
mov    cx, Message2Length
mov    ax, 1301h
mov    bx, 0007h
mov    dh, 2
mov    dl, 1
int    10h

listen_keyboard:
      mov ah,0
      int 0x16
      cmp al,49
      je LU
      cmp al,50
      je RU
      cmp al,51
      je LD
      cmp al,52
      je RD

      jmp listen_keyboard

LU:   
      mov word[offset],OffSetOfLU
      mov byte[sectionNum],2
      jmp LoadnEx
RU:   
      mov word[offset],OffSetOfRU
      mov byte[sectionNum],3
      jmp LoadnEx
LD:   
      mov word[offset],OffSetOfLD
      mov byte[sectionNum],4
      jmp LoadnEx
RD:   
      mov word[offset],OffSetOfRD
      mov byte[sectionNum],5
      jmp LoadnEx
LoadnEx:

      mov ax,cs
      mov es,ax
      mov bx, word[offset]
      mov ah,2
      mov al,1
      mov dl,0
      mov dh,0
      mov ch,0
      mov cl,[sectionNum]
      int 13H ;
      jmp [offset]
AfterRun:
      jmp $                    ;无限循环

Message1:
      db 'This is the second OS of mine. Enter 1-4 to choose the program:'
      Message1Length  equ ($-Message1)
Message2:
      db '1:up-left  2:up-right  3:down-left  4:down-right  ESC:return dos'
      Message2Length  equ ($-Message2)
Name:
      db 'Name: HeZe  Student Number:18340052'
      NameLength  equ ($-Name)

datadef:      
      offset dw OffSetOfLU
      sectionNum db 1
      times 510-($-$$) db 0
      db 0x55,0xaa

