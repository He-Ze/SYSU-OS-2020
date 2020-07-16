extrn  _myos:near       
extrn _in:near          
extrn _hour:near            
extrn _min:near       
extrn _sec:near       
extrn _num:near  
extrn  _to_upper:near
extrn  _to_lower:near
extrn  _to_run_myprogram:near

.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT
DGROUP group _TEXT,_DATA,_BSS
org 100h

start:
    xor ax,ax
	mov es,ax
	mov ax,offset Timer
	mov word ptr es:[20h],offset Timer
	mov ax,cs 
	mov word ptr es:[22h],cs
	
	call setINT

	mov ax, cs
	mov ds, ax           
	mov es, ax           
	mov ss, ax  
	mov sp, 0FFFCH      
	call near ptr _myos   
	jmp $

include function.asm 
include ouch.asm 
include int.asm     
  
_TEXT ends
_DATA segment word public 'DATA'
_DATA ends
_BSS segment word public 'BSS'
_BSS ends
end start