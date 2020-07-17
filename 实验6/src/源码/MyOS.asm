extrn  _cmain:near
extrn _print:near
extrn _HEX2DEC:near
extrn _BIN2DEC:near
extrn _upper:near
extrn _lower:near
extrn _in:near
extrn _ch1:near
extrn _ch2:near
extrn _ch3:near
extrn _ch4:near
extrn _p:near
extrn _pFile:near
extrn _fileSeg:near
extrn _insNum:near

.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT
DGROUP group _TEXT,_DATA,_BSS
org 100h
start:
	xor ax,ax
	mov es,ax
	mov word ptr es:[33*4],offset My21h
	mov word ptr es:[33*4+2],cs


	xor ax,ax
	mov es,ax
	mov word ptr es:[51*4],offset int0x33
	mov word ptr es:[51*4+2],cs

	xor ax,ax
	mov es,ax
	mov word ptr es:[52*4],offset int0x34
	mov word ptr es:[52*4+2],cs

	xor ax,ax
	mov es,ax
	mov word ptr es:[53*4],offset int0x35
	mov word ptr es:[53*4+2],cs

	xor ax,ax
	mov es,ax
	mov word ptr es:[54*4],offset int0x36
	mov word ptr es:[54*4+2],cs

	mov  ax,  cs
	mov  ds,  ax
	mov  es,  ax
	mov  ss,  ax
	mov  sp,  64*1024-4
	call near ptr _cmain
	jmp $

include lib.asm
include interr.asm

_TEXT ends
_DATA segment word public 'DATA'
_DATA ends
_BSS	segment word public 'BSS'
_BSS ends
end start

