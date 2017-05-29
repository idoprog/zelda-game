IDEAL
MODEL small
STACK 100h
DATASEG
n1 dw 40
n2 dw 12
CODESEG
proc print_game_board
offset_x_player equ [bp+6] ;getting the pushed values
offset_y_player equ [bp+4] ;and renaming them so it will be easy to use them
	push bp
	mov bp,sp ;pushing used registers
	push bx
	
;printing gray square and on that green (top left)
	push 0 ;starting_pos_x
	push 0 ;starting_pos_y
	push 35 ;ending_pos_x
	push 8 ;ending_pos_y
	push 8 ;color
	call print_squre
	
	push 0 ;starting_pos_x
	push 0 ;starting_pos_y
	push 33 ;ending_pos_x
	push 7 ;ending_pos_y
	push 2 ;color
	call print_squre
	
;printing gray square and on that green (top right)
	push 45 ;starting_pos_x
	push 0 ;starting_pos_y
	push 80 ;ending_pos_x
	push 8 ;ending_pos_y
	push 8 ;color
	call print_squre
	
	push 47 ;starting_pos_x
	push 0 ;starting_pos_y
	push 80 ;ending_pos_x
	push 7 ;ending_pos_y
	push 2 ;color
	call print_squre

;printing gray square and on that green (bottom left)
	push 0 ;starting_pos_x
	push 17 ;starting_pos_y
	push 35 ;ending_pos_x
	push 25 ;ending_pos_y
	push 8 ;color
	call print_squre
	
	push 0 ;starting_pos_x
	push 18 ;starting_pos_y
	push 33 ;ending_pos_x
	push 25 ;ending_pos_y
	push 2 ;color
	call print_squre
	
;printing gray square and on that green (bottom right)
	push 45 ;starting_pos_x
	push 17 ;starting_pos_y
	push 80 ;ending_pos_x
	push 25 ;ending_pos_y
	push 8 ;color
	call print_squre
	
	push 47 ;starting_pos_x
	push 18 ;starting_pos_y
	push 80 ;ending_pos_x
	push 25 ;ending_pos_y
	push 2 ;color
	call print_squre
	
;roads
	push 0 ;starting_pos_x
	push 8 ;starting_pos_y
	push 80 ;ending_pos_x
	push 17 ;ending_pos_y
	push 6 ;color
	call print_squre
	
	push 35 ;starting_pos_x
	push 0 ;starting_pos_y
	push 45 ;ending_pos_x
	push 25 ;ending_pos_y
	push 6 ;color
	call print_squre
	
;printing the player
	mov bx,offset_x_player ;moving to bx the x player offset
	push [word ptr bx] ;pushing the value using bx
	mov bx,offset_y_player ;moving to bx the y player offset
	push [word ptr bx] ;pushing the value using bx
	push 1 ;pushing the color of the pixel the color
	call print_char

	pop bx ;poping used registers
	pop bp
	ret 4 ;to pushed values it needs to clean 4 bytes for the ss
endp print_game_board

proc print_squre
starting_pos_x equ [bp+12] ;renaming the pushed values so it will be easy to work with them
starting_pos_y equ [bp+10]
ending_pos_x equ [bp+8]
ending_pos_y equ [bp+6]
color equ [bp+4]
	push bp
	mov bp,sp ;pushing the used registers
	push di
	push si
	
	mov si,starting_pos_y ;si remembers the start y
;this loop prints the squre pixel by pixel
print_squre_y:
	mov di,starting_pos_x ;di remembers the start x
print_squre_x:
	push di ;pushing the values of the current position
	push si
	push color ;and color
	call print_char ;to print 1 pixel
	inc di ;adding 1 to x
	cmp di,ending_pos_x ;checking if it's arrived to ending position on the x
	jne print_squre_x

	inc si ;adding 1 to y
	cmp si,ending_pos_y ;checking if it's arrived to ending position on the y
	jne print_squre_y
	
	pop si ;poping used registers
	pop di
	pop bp
	ret 10 ;5 pushed values so ret 10 to clear 10 bytes from ss
endp print_squre

proc print_char
x equ [bp+8] ;pushed values
y equ [bp+6]
color equ [bp+4]	
	push bp
	mov bp,sp ;pushing used registers
	push dx
	push ax
	push cx
	push bx
	xor bx,bx ;zeroing values
	xor cx,cx
	xor ax,ax
	xor dx,dx
	mov dl,x ;changing the cursor
	mov dh,y  
	mov bx, 0      
	mov ah, 02h    
	int 10h
	
	mov ah,9  ;print ascii 219 in cursor position
	mov bx,color
	mov cx,1
	mov al,219
	int 10h
	
	pop bx ;poping pushed registers
	pop cx
	pop ax
	pop dx
	pop bp
	ret 6 ;3 pushed values then it's 6 bytes to clean from ss
endp print_char
start:
	mov ax, @data
	mov ds, ax
	push offset n1
	push offset n2
	call print_game_board
looping:
	jmp looping
exit:
	mov ax, 4c00h
	int 21h
END start


