bits 16

mov ax, 0x07C0
mov ds, ax
mov ax, 0x07E0
mov ss, ax
mov sp, 0x2000

call clearscreen

push 0x0000
call movecursor
add sp, 2

push msg
call print
add sp, 2

cli
hlt

clearscreen:
	pusha

	mov ah, 0x07
	mov al, 0x00
	mov bh, 0x07
	mov cx, 0x00
	mov dh, 0x18		;24 rows
	mov dl, 0x4f		;79 cols
	int 10h

	popa
	ret

movecursor:
	push bp
	mov bp, sp
	pusha

	mov dx, [bp+4]		;get the argument from the stack. |bp| = 2, |arg| = 2
	mov ah, 0x02
	mov bh, 0x00
	int 10h

	popa
	mov sp, bp
	pop bp
	ret

print:
	push bp
	mov bp, sp
	pusha
	mov si, [bp+4]		;grab the ptr to the data
	mov bh, 0x00		;page number 0
	mov bl, 0x00		;foreground color
	mov ah, 0x0E		;print charaters to TTY

.char:
	mov al, [si]		;get current char from the ptr position
	inc si			;keep incrementing until null character
	or al, 0
	je .return
	int 10h
	jmp .char
.return:
	popa
	mov sp, bp
	pop bp
	ret

msg : db "This is a simple bootloader!!!", 0
times 510-($-$$) db 0
dw 0xAA55
