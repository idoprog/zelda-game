IDEAL
MODEL small
STACK 100h
DATASEG
x_player dw 40
y_player dw 12
rand_num db ?
is_legal db ?
CODESEG
proc print_black_board
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
endp print_black_board

proc print_game_board
offset_x_player equ [bp+6]
offset_y_player equ [bp+4]
	push bp
	mov bp,sp
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
	mov bx,offset_x_player
	push [word ptr bx]
	mov bx,offset_y_player
	push [word ptr bx]
	push 1
	call print_char

	pop bx
	pop bp
	ret 4
endp print_game_board

proc print_squre
starting_pos_x equ [bp+12]
starting_pos_y equ [bp+10]
ending_pos_x equ [bp+8]
ending_pos_y equ [bp+6]
color equ [bp+4]
	push bp
	mov bp,sp
	push di
	push si
	
	mov si,starting_pos_y
print_squre_y:
	mov di,starting_pos_x
print_squre_x:
	push di
	push si
	push color
	call print_char
	inc di
	cmp di,ending_pos_x
	jne print_squre_x

	inc si 
	cmp si,ending_pos_y
	jne print_squre_y
	
	pop si
	pop di
	pop bp
	ret 10
endp print_squre

proc check_for_press
x_player_offset equ [bp+8]
y_player_offset equ [bp+6]
is_legal_offset equ [bp+4]
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov bx,x_player_offset
	mov di,[word ptr bx] ;di = x
	mov bx,y_player_offset
	mov dx,[word ptr bx] ;dx = y
	mov ah,1h
	int 16h ;helper here
	jnz pres
	jz finish_check_for_press
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
	jne finish_check_for_press

	
	
up_pressed:
	push di
	push dx
	push is_legal_offset
	push 3
	call legal_place
	
	mov bx,is_legal_offset
	cmp [byte ptr bx],0 ;0 = not legal 1= legal
	je not_legal1
	
	
	push x_player_offset
	push y_player_offset
	call mov_up
	jmp finish_check_for_press
	
down_pressed:
	push di
	push dx
	push is_legal_offset
	push 2
	call legal_place
	
	mov bx,is_legal_offset
	cmp [byte ptr bx],0 ;0 = not legal 1= legal
	je not_legal1
	
	push x_player_offset
	push y_player_offset
	call mov_down
	jmp finish_check_for_press

	
right_pressed:
	push di
	push dx
	push is_legal_offset
	push 4
	call legal_place
	
	mov bx,is_legal_offset
	cmp [byte ptr bx],0 ;0 = not legal 1= legal
	je not_legal1
	
	push x_player_offset
	push y_player_offset
	call mov_right
	jmp finish_check_for_press

	
left_pressed:	
	push di
	push dx
	push is_legal_offset
	push 1
	call legal_place
	
	mov bx,is_legal_offset
	cmp [byte ptr bx],0 ;0 = not legal 1= legal
	je not_legal1
	
	push x_player_offset
	push y_player_offset
	call mov_left

not_legal1:
	push 2394h
	push 3
	call play_sound
finish_check_for_press:
	mov ah,0Ch
	mov al,0
	int 21h
	
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
endp check_for_press
	
	
proc mov_up
x_player_offset equ [bp+6]
y_player_offset equ [bp+4]
	push bp
	mov bp,sp
	push bx
	push ax
	push cx
	mov bx,x_player_offset
	mov ax,[bx] ;ax = x
	mov bx,y_player_offset
	mov cx,[bx] ;cx = y
	push ax
	push cx
	push 6
	call print_char
	mov bx,y_player_offset
	dec [word ptr bx]
	mov bx,x_player_offset
	mov ax,[bx] ;ax = x
	mov bx,y_player_offset
	mov cx,[bx] ;cx = y
	push ax
	push cx
	push 1
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
	mov bx,x_player_offset
	mov ax,[bx] ;ax = x
	mov bx,y_player_offset
	mov cx,[bx] ;cx = y
	push ax
	push cx
	push 6
	call print_char
	mov bx,y_player_offset
	inc [word ptr bx]
	mov bx,x_player_offset
	mov ax,[bx] ;ax = x
	mov bx,y_player_offset
	mov cx,[bx] ;cx = y
	push ax
	push cx
	push 1
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
	mov bx,x_player_offset
	mov ax,[bx] ;ax = x
	mov bx,y_player_offset
	mov cx,[bx] ;cx = y
	push ax
	push cx
	push 6
	call print_char
	mov bx,x_player_offset
	inc [word ptr bx]
	mov bx,x_player_offset
	mov ax,[bx] ;ax = x
	mov bx,y_player_offset
	mov cx,[bx] ;cx = y
	push ax
	push cx
	push 1
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
	mov bx,x_player_offset
	mov ax,[bx] ;ax = x
	mov bx,y_player_offset
	mov cx,[bx] ;cx = y
	push ax
	push cx
	push 6
	call print_char
	
	mov bx,x_player_offset
	dec [word ptr bx]
	
	mov bx,x_player_offset
	mov ax,[bx] ;ax = x
	mov bx,y_player_offset
	mov cx,[bx] ;cx = y
	push ax
	push cx
	push 1
	call print_char
	
	pop cx
	pop ax
	pop bx
	pop bp
	ret 4
endp mov_left

	
	
	
	
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
	
	mov dl,x
	mov dh,y  
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
	push bp
	mov bp,sp
	push ax
	push cx
	push dx
	mov ah,2Ch
setting_time:
	int 21h
	mov al,dl
time_loop:
	int 21h
	cmp al,dl
	je time_loop
	dec [word ptr bp+4]
	cmp [word ptr bp+4],0
	jne setting_time
	pop dx
	pop cx
	pop ax
	pop bp 
	ret 2
endp timer

proc random_1to4
rand_num_offset equ [bp+4]
	push bp
	mov bp,sp
	push cx
	push dx
	push bx
	push ax
	mov ah,2Ch
	int 21h
	mov al,dl
	xor ah,ah
	mov bl,25
	div bl
	mov bx,rand_num_offset
	mov [byte ptr bx],al
	pop ax
	pop bx
	pop dx
	pop cx
	pop bp
	ret 2
endp random_1to4

proc play_sound
time_to_play equ [bp+6]
note equ [bp+4]
	push bp
	mov bp,sp
	push ax
	xor ax,ax
	mov al, 182         
    out 43h, al       
    mov ax,note                            
    out 42h, al         
    mov al, ah         
    out 42h, al 
    in  al, 61h                                 
    or  al, 00000011b   
    out 61h, al         
	
	
	in al, 61h                          
    and al, 11111100b 
    out 61h, al
	pop ax
	pop bp
	ret 4
endp play_sound
	
proc endless_loop
	push bp
	mov bp,sp
looping:
	jmp looping
	pop bp
	ret 
endp endless_loop

proc legal_place
x equ [bp+10]
y equ [bp+8]
is_legal_ofsset equ [bp+6]
direc equ [bp+4] ;1 = left 2 = down 3 = up 4 = right
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	mov cx,direc
	mov ax,x ;ax = x
	mov bx,y ;bx = y
	cmp cx,1
	je lefting
	jne still_not1
still_not1:
	cmp cx,2
	je downing
	jne still_not2
still_not2:
	cmp cx,3
	je uping
	jne righting

	
lefting:
	dec ax
	cmp ax,34
	ja it_legal
	jbe keep_check_lefting
keep_check_lefting:
	cmp bx,7
	jbe not_legal
	ja keep_check_lefting1
keep_check_lefting1:
	cmp bx,17
	jb keep_check_lefting2
	jae not_legal
keep_check_lefting2:
	cmp ax,0
	je not_legal
	jne it_legal
	
	
downing:
	inc bx
	cmp bx,17
	jb it_legal
	jae keep_check_downing
keep_check_downing:
	cmp ax,34
	jbe not_legal
	ja keep_check_downing1
keep_check_downing1:
	cmp ax,45
	jae not_legal
	jb keep_check_downing2
keep_check_downing2:
	cmp bx,24
	je not_legal
	jne it_legal
	
	
	
uping:
	dec bx
	cmp bx,7
	ja it_legal
	jbe keep_check_uping
keep_check_uping:
	cmp ax,34
	jbe not_legal
	ja keep_check_uping1
keep_check_uping1:
	cmp ax,46
	jae not_legal
	jb keep_check_uping2
keep_check_uping2:
	cmp bx,0
	je not_legal
	jne it_legal
	



righting:
	inc ax
	cmp ax,45
	jb it_legal
	jae keep_check_righting
keep_check_righting:
	cmp bx,7
	jbe not_legal
	ja keep_check_righting1
keep_check_righting1:
	cmp bx,17
	jae not_legal
	jb keep_check_righting2
keep_check_righting2:
	cmp ax,79
	je not_legal
	jne it_legal
	
	
	
it_legal:
	mov bx,is_legal_ofsset
	mov [byte ptr bx],1
	jmp finish_legal_place
not_legal:
	mov bx,is_legal_ofsset
	mov [byte ptr bx],0
finish_legal_place:
	pop cx
	pop bx
	pop ax
	pop bp 
	ret 8
endp legal_place


start:
	mov ax,@data
	mov ds,ax
	push offset x_player
	push offset y_player
	call print_game_board
looping1:
	push offset x_player
	push offset y_player
	push offset is_legal
	call check_for_press
	jmp looping1
exit:
	mov ax, 4c00h
	int 21h
END start


