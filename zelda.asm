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




proc check_for_press
x_player_offset equ [bp+6]
y_player_offset equ [bp+4]
	push bp
	mov bp,sp
	push ax
	mov ah,1h
	int 16h
	jnz pres
	jz ending_func
pres:
	cmp al,'w'
	je up_pressed
	jne keep_check1
keep_check1:
	cmp al,'a' 
	je left_pressed
	jne keep_check2
keep_check2:
	cmp al,'s'
	je down_pressed
	jne keep_check3
keep_check3:
	cmp al,'d'
	je right_pressed
	jne ending_func
up_pressed:
	push x_player_offset
	push y_player_offset
	call mov_up
	jmp ending_func
down_pressed:
	push x_player_offset
	push y_player_offset
	call mov_down
	jmp ending_func
right_pressed:
	push x_player_offset
	push y_player_offset
	call mov_right
	jmp ending_func
left_pressed:	
	push x_player_offset
	push y_player_offset
	call mov_left
ending_func:
	mov ah,0Ch
	mov al,0
	int 21h
	pop ax
	pop bp
	ret 4
endp check_for_press
	
	
proc mov_up
x_player_offset equ [bp+6]
y_player_offset equ [bp+4]
	push bp
	mov bp,sp
	push bx
	push ax
	push cx
	push x_player_offset
	push y_player_offset
	push 0
	call print_char
	mov bx,y_player_offset
	dec [word ptr bx]
	push x_player_offset
	push y_player_offset
	push 2
	call print_char
	pop cx
	pop ax
	pop bx
	pop bp
	ret 4
endp mov_up

proc mov_down	
x_player_offset equ [bp+6]
y_player_offset equ [bp+4]
	push bp
	mov bp,sp
	push bx
	push ax
	push cx
	push x_player_offset
	push y_player_offset
	push 0
	call print_char
	mov bx,y_player_offset
	inc [word ptr bx]
	push x_player_offset
	push y_player_offset
	push 2
	call print_char
	pop cx
	pop ax
	pop bx
	pop bp
	ret 4
endp mov_down

proc mov_right	
x_player_offset equ [bp+6]
y_player_offset equ [bp+4]
	push bp
	mov bp,sp
	push bx
	push ax
	push cx
	push x_player_offset
	push y_player_offset
	push 0
	call print_char
	mov bx,x_player_offset
	inc [word ptr bx]
	push x_player_offset
	push y_player_offset
	push 2
	call print_char
	pop cx
	pop ax
	pop bx
	pop bp
	ret 4
endp mov_right
	
proc mov_left	
x_player_offset equ [bp+6]
y_player_offset equ [bp+4]
	push bp
	mov bp,sp
	push bx
	push ax
	push cx
	push x_player_offset
	push y_player_offset
	push 0
	call print_char
	mov bx,x_player_offset
	dec [word ptr bx]
	push x_player_offset
	push y_player_offset
	push 2
	call print_char
	pop cx
	pop ax
	pop bx
	pop bp
	ret 4
endp mov_left

	
	
	
	
proc print_char
x_offest equ [bp+8]
y_offset equ [bp+6]
color equ [bp+4]	
	push bp
	mov bp,sp
	push dx
	push ax
	push cx
	push bx
	mov bx,x_offest
	mov dl, [bx]
	mov bx,y_offset
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
	push di
	mov di,mil_sec_to_wait
	dec di
time_loop:
	mov ah,2Ch
	int 21h
	mov bl,dl
	add bl,1
	cmp bl,100
	je subin
	jne check_agian
subin:
	mov bl,0
check_agian:
	int 21h
	cmp bl,dl
	jne check_agian
	cmp di,0
	jne cunt
	je ending_func1
cunt:
	dec di
	jmp time_loop
ending_func1:
	pop di
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
	push offset x_player
	push offset y_player
	call check_for_press
	jmp jmping
exit:
	mov ax, 4c00h
	int 21h
END start


