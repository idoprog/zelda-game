IDEAL
MODEL small
STACK 100h
DATASEG
x_player dw 40
y_player dw 12

CODESEG
proc print_board
	push bp
	mov bp,sp
	push ax
	push di
	push si
	push dx
	push cx
	
	mov si, 25 ;si = y
downRow:
	mov ah,2
	mov di, 79 ;di = x
	mov dl, 0ah
	int 21h
row:
	mov ah,9
	mov bx,0
	mov cx,1
	int 10h
	mov ah,2
	mov dl,219
	int 21h
	mov cx,0
	dec di
	cmp di, 0
	jne row
	
	dec si
	cmp si, 0
	jne downRow
	
	pop cx
	pop dx 
	pop si
	pop di
	pop ax
	pop bp 
	ret
endp print_board

proc check_pos
x_pos equ [bp+4]
y_pos equ [bp+6]
x_board equ [bp+8]
y_board equ [bp+10]
	push bp
	mov bp,sp
	push ax
	mov ax,x_board
	cmp ax,x_pos
	je x_equ_chk_y
	jne not_equ
x_equ_chk_y:
	mov ax,y_board 
	cmp ax,y_pos
	je both_equ
	jne not_equ
both_equ:
	mov cx,1
	jmp popping
not_equ:
	mov cx,0
popping:
	pop ax
	pop bp
	ret 8
endp check_pos

proc player_mov
up equ 'w'
left equ 'a'
down equ 's'
right equ 'd'
x_offset equ [bp+6]
y_offset equ [bp+4]
	push bp
	mov bp,sp
	push bx
	push si
	call print_board
	mov bx,x_offset
	mov si,y_offset
waitForData:
	mov ah, 1
	int 16h
	jnz waitForData
	mov ah, 0
	int 16h
	cmp al, right
	je mov_right
	cmp al, left
	je mov_left
	cmp al, up
	je mov_up
	cmp al, down
	je mov_down
	
mov_right:
	dec [word ptr bx]
	jmp cont
mov_left:
	inc [word ptr bx]
	jmp cont
mov_up:
	inc [word ptr si]
	jmp cont
mov_down:
	dec [word ptr si]
cont:
	call print_board
	jmp waitForData
	pop bp
	ret 4 
endp player_mov

proc print_char
x equ [bp+8]
y equ [bp+6]
color equ [bp+4]	
	push bp
	mov bp,sp
	push dx
	push ax
	push cx
	push bx
	mov bx,x
	mov dl, [bx]
	mov bx,y
	mov dh, [bx]  
	mov bx, 0      
	mov ah, 02h    
	int 10h
	
	mov ah,9  
	mov bx,color
	mov cx,1
	mov al,219
	int 10h
	
	pop bx
	pop cx
	pop ax
	pop dx
	pop bp
	ret 6
endp print_char


proc timer
mil_sec_to_wait equ [bp+4]
	push bp
	mov bp,sp
	push cx
	push ax
	push dx
	push bx
	mov ah,2Ch
	int 21h
	mov bl,dl
	add bx,mil_sec_to_wait
check_agian:
	int 21h
	cmp bl,dl
	jne check_agian
	pop bx
	pop dx
	pop ax
	pop cx
	pop bp 
	ret 2
endp timer
start:
	mov ax,@data
	mov ds,ax
	call print_board
	push offset x_player
	push offset y_player
	push 2
	call print_char
jmping:
	jmp jmping
exit:
	mov ax, 4c00h
	int 21h
END start


