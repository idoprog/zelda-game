IDEAL
MODEL small
STACK 100h
DATASEG
	birdx dw 100h
	birdy dw 100h
	gravity dw 0h
	death_checker dw 0h
	g_x_arr db 85 ,86 ,87 ,88 ,89 ,84 ,85 ,83 ,84 ,83 ,84 ,87 ,88 ,89 ,83 ,84 ,88 ,89 ,84 ,85 ,88 ,89 ,85 ,86 ,87 ,88 ,89
	g_y_arr db 92 ,92 ,92 ,92 ,92 ,93 ,93 ,94 ,94 ,95 ,95 ,95 ,95 ,95 ,96 ,96 ,96 ,96 ,97 ,97 ,97 ,97 ,98 ,98 ,98 ,98 ,98
	a_x_arr db 94 ,95 ,96 ,93 ,94 ,96 ,97 ,92 ,93 ,97 ,98 ,92 ,93 ,97 ,98 ,92 ,93 ,94 ,95 ,96 ,97 ,98 ,92 ,93 ,97 ,98 ,92 ,93 ,97 ,98
	a_y_arr db 92 ,92 ,92 ,93 ,93 ,93 ,93 ,94 ,94 ,94 ,94 ,95 ,95 ,95 ,95 ,96 ,96 ,96 ,96 ,96 ,96 ,96 ,97 ,97 ,97 ,97 ,98 ,98 ,98 ,98
	m_x_arr db 101 ,102 ,106 ,107 ,101 ,102 ,103 ,105 ,106 ,107 ,101 ,102 ,103 ,104 ,105 ,106 ,107 ,101 ,102 ,103 ,104 ,105 ,106 ,107 ,101 ,102 ,104 ,106, 107 ,101 ,102 ,106 ,107 ,101 ,102 ,106 ,107
	m_y_arr db 92 ,92 ,92 ,92 ,93 ,93 ,93 ,93 ,93 ,93, 94 ,94 ,94 ,94 ,94 ,94 ,94 ,95 ,95 ,95 ,95 ,95, 95 ,95 ,96 ,96 ,96 ,96 ,96 ,97 ,97 ,97 ,97 ,98 ,98, 98 ,98
	e_1_x_arr db 110 ,111 ,112 ,113 ,114 ,115 ,116 ,110 ,111 ,110 ,111 ,110 ,111 ,112 ,113 ,114 ,115 ,116 ,110 ,111 ,110 ,111 ,110 ,111 ,112 ,113 ,114 ,115 ,116
	e_1_y_arr db 92 ,92 ,92 ,92 ,92 ,92 ,92 ,93 ,93 ,94 ,94 ,95 ,95 ,95 ,95 ,95 ,95 ,95 ,96 ,96 ,97 ,97 ,98 ,98 ,98 ,98 ,98 ,98 ,98
	o_x_arr db 84 ,85 ,86 ,87 ,88 ,83 ,84 ,88 ,89 ,83 ,84 ,88 ,89, 83 ,84 ,88 ,89 ,83 ,84 ,88 ,89 ,83 ,84 ,88 ,89 ,84 ,85 ,86 ,87 ,88
	o_y_arr db 102 ,102 ,102 ,102 ,102 ,103 ,103 ,103 ,103 ,104 ,104 ,104 ,104 ,105 ,105 ,105 ,105 ,106 ,106 ,106 ,106 ,107 ,107 ,107 ,107 ,108 ,108 ,108 ,108 ,108
	v_x_arr db 92, 93 ,97 ,98 ,92, 93 ,97 ,98 ,92, 93 ,97 ,98 ,92 ,93 ,94 ,96 ,97 ,98 ,93 ,94 ,95 ,96 ,97 ,94 ,95 ,96 ,95
	v_y_arr db 102 ,102 ,102 ,102 ,103 ,103 ,103 ,103 ,104 ,104 ,104 ,104 ,105 ,105 ,105 ,105 ,105 ,105 ,106 ,106 ,106 ,106 ,106 ,107 ,107 ,107 ,108
	e_2_x_arr db 101 ,102 ,103 ,104 ,105 ,106 ,107 ,101 ,102 ,101 ,102 ,101 ,102 ,103 ,104 ,105 ,106 ,107 ,101 ,102 ,101 ,102 ,101 ,102 ,103 ,104 ,105 ,106 ,107
	e_2_y_arr db 102, 102 ,102 ,102 ,102 ,102 ,102 ,103 ,103 ,104 ,104 ,105 ,105 ,105 ,105 ,105 ,105 ,105 ,106 ,106 ,107 ,107 ,108 ,108 ,108 ,108 ,108 ,108 ,108
	r_x_arr db 110 ,111 ,112 ,113 ,114 ,115 ,110 ,111 ,114 ,115 ,116 ,110 ,111 ,115 ,116 ,110 ,111 ,114 ,115 ,116 ,110 ,111 ,112 ,113 ,114 ,110 ,111 ,113 ,114 ,115 ,110 ,111 ,114 ,115 ,116
	r_y_arr db 102 ,102 ,102 ,102 ,102 ,102 ,103 ,103 ,103 ,103 ,103 ,104 ,104 ,104 ,104 ,105 ,105 ,105 ,105 ,105 ,106 ,106 ,106 ,106 ,106 ,107 ,107 ,107 ,107 ,107 ,108 ,108 ,108 ,108 ,108
CODESEG
;this proc get the x and y of the point in the top-left of the bird the clear it (paint black pixels on it)
;input: the offset of birdx and birdy
;output: paint black pixels
proc clear_bird
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	bird_x_off_clearbird equ [bp + 6]
	bird_y_off_clearbird equ [bp + 4]
	mov bx, bird_x_off_clearbird
	mov cx, [bx];get the x of the bird
	mov bx, bird_y_off_clearbird
	mov dx, [bx];get the y of the bird
	mov bx, 0
	mov si, 7;the loop will run 7 times
clear_bird_loop:
	push 0
	push cx
	push dx
	call line_printer;clear one line
	inc dx;go to the next line
	dec si
	cmp si, 0
	ja clear_bird_loop;do the loop
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
endp clear_bird
;this proc get the x and y of the point in the top-left of the bird the and the place the proc need to paint it and paint the bird
;input: the offset of birdx and birdy and the x and y of the next place
;output: paint the bird
proc paint_bird
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	middle_bird_x_paintbird equ [bp + 10]
	middle_bird_y_paintbird equ [bp + 8]
	bird_x_off_paintbird equ [bp + 6]
	bird_y_off_paintbird equ [bp + 4]
	;paint the bird in the new place
	mov cx, middle_bird_x_paintbird; get the x
	mov dx, middle_bird_y_paintbird; get the y
	mov si, 7;the loop will run 7 times
print_bird_loop:
	push 4
	push cx
	push dx
	call line_printer;paint one line
	inc dx;go to the nexr line
	dec si
	cmp si, 0
	ja print_bird_loop
	;set the new place of the bird to the variables
	mov bx, bird_x_off_paintbird
	mov ax, middle_bird_x_paintbird
	mov [bx], ax
	mov bx, bird_y_off_paintbird
	mov ax, middle_bird_y_paintbird
	mov [bx], ax
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8
endp paint_bird
;this proc help proc like paint bird and clear bird, the proc paint one line
;input: color and x and y of the line
;output: paint the line the in the place
proc line_printer
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	color_line_printer equ [bp + 8]
	x_line_printer equ [bp + 6]
	y_line_printer equ [bp + 4]
	;get all the inputs
	mov al, color_line_printer
	mov bl, 0
	mov cx, x_line_printer
	mov dx, y_line_printer
	mov si, 7;the loop will run  times one time for each pixel
line_printer_loop:
	mov ah,0ch
	int 10h;paint pixel
	inc cx;go to the next pixel
	dec si
	cmp si, 0
	ja line_printer_loop
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
endp line_printer
;this proc print Pipeline in the right with a entrance
;input: -
;output: paint pipeline and entrance
proc print_Pipe_line
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	mov al, 2;color of the pipeline
	mov bl, 0
	mov dx, 199;the loop will run 199 times
	mov cx, 319;set the x
	;the loop paint 199 pixels for each y of dx
printPipelineloop:
	mov ah,0ch
	int 10h; paint the pixel
	dec dx
	cmp dx, 0
	jne printPipelineloop
	;get random number for the place of the entrance
the_entrance_too_close_too_the_end:
	mov ah, 2Ch
	int 21h
	xor dh, dh
	add dx, dx ;because we get random number 0-99 this double so it get number 0-198 (only even numbers) 
	cmp dx ,155 ;check if the entrance is not so close to end
	jg the_entrance_too_close_too_the_end
	mov si, 40;the loo will run 40 times
	mov al, 0;the color of the entrance is black
	mov cx, 319;the entrance is in x 319
	entrance:
	mov ah,0ch
	int 10h; paint pixel
	inc dx;go to the next pixel
	dec si
	cmp si, 0
	jne entrance
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp print_Pipe_line
;this procedor mov all the pixels left exept of the bird (the left size will be black)
;input: the x and y of the bird
proc mov_pixel_left
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	bird_x_off_mov_pixel_left equ [bp + 6]
	bird_y_off_mov_pixel_left equ [bp + 4]
	mov bh, 0h
	mov cx, 0
	mov dx, 0
	mov di, 0
	;this loop check the number of each pixel and paint it in the left of the pixel
mov_pixel_left_loop:
	mov cx, di
	add cx, 1;go to the pixel int the left
	mov ah,0Dh
	int 10h;cheack the number of the pixel in the left
	sub cx, 1;go to the pixel
	mov ah,0ch
	int 10h;paint him like the the pixel in the left
	add di, 1;go to the next pixel
	cmp cx, 318
	jne end_of_mov_pixel_left_loop
	xor di, di
	add dx, 1;go to the next line
end_of_mov_pixel_left_loop:
	cmp dx, 200
	jne mov_pixel_left_loop
	;clear the bird from where the bird now
	;--------------------------------
	mov bx, bird_x_off_mov_pixel_left
	mov cx, [bx]
	sub cx, 1;because the bird go one pixel left it need to clear it from one pixel left
	mov [bx], cx
	push bird_x_off_mov_pixel_left
	push bird_y_off_mov_pixel_left
	call clear_bird
	;-----------------------------
	;paint the bird in the new place
	;------------------------------
	mov cx, [bx]
	add cx, 1
	mov [bx], cx;got to the right place
	mov bx, bird_x_off_mov_pixel_left
	mov ax, [bx]
	push ax
	mov bx, bird_y_off_mov_pixel_left
	mov ax, [bx]
	push ax
	push bird_x_off_mov_pixel_left
	push bird_y_off_mov_pixel_left
	call paint_bird;paint the bird in where the bird was
	;---------------------------------
	mov al, 0;the color will be black
	mov bl, 0
	mov cx, 199; the loop will run 199 times
	;this loop paint all the pixel in the left in black
blackleft:
	mov dx, cx
	mov cx, 319
	mov ah,0ch
	int 10h
	mov cx, dx
	loop blackleft
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
endp mov_pixel_left
; this proc make the bird jump and Increase her x set the gravity to 0
;input: the x and the y of the bird and the gravity
proc jump
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	bird_x_off_jump equ [bp + 8]
	bird_y_off_jump equ [bp + 6]
	gravity_off_jump equ [bp + 4]
	mov bx, gravity_off_jump
	mov [word ptr bx], 0;set the gravity to 0
	push bird_x_off_jump
	push bird_y_off_jump
	call clear_bird;clear the bird from where it was
	mov bx, bird_y_off_jump
	mov dx, [bx]
	sub dx, 10;because the bird will go 10 pixels up
	mov bx, bird_x_off_jump
	mov cx, [bx]
	push cx
	push dx
	push bird_x_off_jump
	push bird_y_off_jump
	call paint_bird;paint the bird 10 pixels up
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
endp jump
;this proc Increase the gravity and lower the bird according to the gravity
;input: the x and the y of the bird and the gravity
proc gravity_proc
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	bird_x_off_gravity_proc equ [bp + 8]
	bird_y_off_gravity_proc equ [bp + 6]
	gravity_off_gravity_proc equ [bp + 4]
	mov bx, bird_y_off_gravity_proc
	mov cx, [bx]
	mov bx, gravity_off_gravity_proc
	mov dx, 199
	sub dx, [bx]
	cmp cx, dx; check if the bird too close to the end
	ja too_close_to_the_end
	push bird_x_off_gravity_proc
	push bird_y_off_gravity_proc
	call clear_bird;clear the bird from where the bird was
	mov bx, bird_x_off_gravity_proc
	push [bx]
	mov bx, bird_y_off_gravity_proc
	mov cx, [bx];get the y of the bird
	mov bx, gravity_off_gravity_proc
	add cx, [bx];add to the y the gravity
	push cx
	push bird_x_off_gravity_proc
	push bird_y_off_gravity_proc
	call paint_bird
	jmp end_of_gravity_proc
too_close_to_the_end:;if the bird too close too the end the proc paint the bird at the end of the screen
	push bird_x_off_gravity_proc
	push bird_y_off_gravity_proc
	call clear_bird;clear the bird from where the bird was
	mov bx, bird_x_off_gravity_proc
	push [bx]
	push 193;the end of the screen less the length of the bird = 193
	push bird_x_off_gravity_proc
	push bird_y_off_gravity_proc
	call paint_bird
end_of_gravity_proc:
	mov bx, gravity_off_gravity_proc
	mov cx, 2
	add [bx], cx;add to the gravity 2, the next time the will fall more pixels
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
endp gravity_proc
;waits 3 milisecends
;input: -
;output: -
proc wait_3_milisec
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	mov bx, 0003h;the nember of the milisecends the proc wait
setmilisec:
	mov ah, 2ch
	int 21h
	mov al, dl ;miliseconds
checkformilisec:
	mov ah, 2ch
	int 21h
	cmp al, dl ;checks if the miliseconds changed
	je checkformilisec
	dec bx;if the sec change
	cmp bx, 0
	jne setmilisec
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp wait_3_milisec
;this proc get arrey of x of a letter, arrey of y of a letter, and the number pixels in the letter and paint the letter
;input:this proc get arrey of x of a letter, arrey of y of a letter, and the number pixels in the letter
;output: paint the letter
proc print_letter
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	letter_x_arr_off_print_letter equ [bp + 8]
	letter_y_arr_off_print_letter equ [bp + 6]
	lenght_letter_print_letter equ [bp + 4]
	mov al ,15;the color of the letter will be white
	mov bx, 0
	xor cx, cx
	xor dx, dx
	mov si, letter_x_arr_off_print_letter
	mov di, letter_y_arr_off_print_letter
	print_letter_loop:
	mov bl, bh;because when it print pixel bl need to be 0
	xor bh, bh
	mov cl, [bx + si];get the x of the pixel
	mov dl, [bx + di];get the y of the pixel
	mov bh, bl;because when it print pixel bl need to be 0
	xor bl, bl
	mov ah,0ch
	int 10h;paint the pixel
	add bh, 1;go to the next pixel
	cmp bh, lenght_letter_print_letter
	jne print_letter_loop
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 32
endp print_letter
;this proc check if the bird is dead
;input the x and the y of the bird and access to death_checker
;output: death_checker = 0 if the bird is not dead, death_checker = 1 if the bird is dead
proc death_proc
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	bird_x_off_death_proc equ [bp + 8]
	bird_y_off_death_proc equ [bp + 6]
	death_checker_death_proc equ [bp + 4]
	;if the bird is in the Edges of the screen the bird is dead
	;---------------------------------
	mov bx, bird_y_off_death_proc
	mov ax, 193
	cmp [bx], ax;if the bird is in bottom of the screen
	je he_is_dead
	mov ax, 0
	cmp [bx], ax;if the bird is in the top of the screen
	je he_is_dead
	;---------------------------------
	;for each of the pixel next to the bird if he is color 2 -the color of the pipe line the bird is dead
	mov bx, bird_y_off_death_proc
	mov dx, [bx]
	xor bx, bx
	add dx, 7;set the number of times the loop will run
Loop_of_y:
	mov bx, bird_x_off_death_proc
	mov cx, [bx]
	xor bx, bx
	add cx, 7;set the number of times the loop will run
Loop_of_x:
	mov ah,0Dh
	int 10h
	mov ah, 2
	cmp al, ah;if the pixel is color 2 the bird is dead
	je he_is_dead
	dec cx
	mov bx, bird_x_off_death_proc
	mov ax, [bx]
	xor bx, bx
	cmp cx, ax
	jne Loop_of_x
	dec dx
	mov bx, bird_y_off_death_proc
	mov ax, [bx]
	xor bx, bx
	sub ax, 1
	cmp dx, ax
	jne Loop_of_y

	jmp he_is_not_dead;if non of the Situations is happen the bird is not dead
he_is_dead:
	mov bx, death_checker_death_proc
	mov ax, 1
	mov [bx], ax;mov to death_checker 1
	jmp end_death_proc
he_is_not_dead:
	mov bx, death_checker_death_proc
	mov ax, 0
	mov [bx], ax;mov to death_checker 0
end_death_proc:
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
endp death_proc
;this proc synchronize the other proc
;input: the x and the y of the bird, the gravity of the bird and the death checker
;output: the game
proc manage_game
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	birdx_off_manage_game equ [bp + 10]
	birdy_off_manage_game equ [bp + 8]
	gravity_off_manage_game equ [bp + 6]
	death_checker_off_manage_game equ [bp +4]
	;-----------------
	;start game things
	push 160
	push 100
	push birdx_off_manage_game
	push birdy_off_manage_game
	call paint_bird;paint the bird
	call print_Pipe_line;print pipe line
	mov bx, gravity_off_manage_game
	mov ax, 0
	mov [bx], ax ;set the gravity to 0
	;-----------------
	mov bx, 0;set bx to 0
	mov ah, 2Ch
	int 21h
	and dl, 111b
	mov cx, 40 
	add cl, dl;put in cl random number 40-48 the numbe will be the distance between pipe lines
game_loop:
	call wait_3_milisec
	;game loop thing
	;---------------
	xor ax, ax
	mov ah, 01h
	int 16h
	jz not_space;check if something is pressed
	mov ah, 0
	int 16h
	cmp ax, 3920h
	jne not_space;check if space is pressed
	push birdx_off_manage_game
	push birdy_off_manage_game
	push gravity_off_manage_game
	call jump
not_space:
	cmp bx, cx; if bx isnt aqual to the distance it inc bx if is aqual to the distance print pipe line and set random distance
	jne no_pipe
	mov bx, 0
	call print_Pipe_line;if bx aqual to the distance print pipe line and set random distance
	mov ah, 2Ch
	int 21h
	and dl, 111b
	mov cx, 40 
	add cl, dl
no_pipe:
	inc bx; if bx isnt aqual to the distance it inc bx
	;call to gravity_proc, mov_pixel_left and death_proc
	push birdx_off_manage_game
	push birdy_off_manage_game
	push gravity_off_manage_game
	call gravity_proc
	push birdx_off_manage_game
	push birdy_off_manage_game
	call mov_pixel_left
	push birdx_off_manage_game
	push birdy_off_manage_game
	push death_checker_off_manage_game
	call death_proc
	mov si, death_checker_off_manage_game;check if the bird dead
	mov ax, 1
	cmp [si], ax
	je death;if the bird dead it end the game
	;---------------
	jmp game_loop;if the bird isnt dead it continue the game
death:
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8
	endp manage_game
start:
mov ax, @data
mov ds, ax
mov ax, 13h
int 10h
	push offset birdx
	push offset birdy
	push offset gravity
	push offset death_checker
	call manage_game
	;after the game the code print "game over"
	push offset g_x_arr
	push offset g_y_arr
	push 27
	call print_letter
	push offset a_x_arr
	push offset a_y_arr
	push 30
	call print_letter
	push offset m_x_arr
	push offset m_y_arr
	push 37
	call print_letter
	push offset e_1_x_arr
	push offset e_1_y_arr
	push 29
	call print_letter
	push offset o_x_arr
	push offset o_y_arr
	push 30
	call print_letter
	push offset v_x_arr
	push offset v_y_arr
	push 27
	call print_letter
	push offset e_2_x_arr
	push offset e_2_y_arr
	push 29
	call print_letter
	push offset r_x_arr
	push offset r_y_arr
	push 35
	call print_letter
exit:
mov ax, 4c00h
int 21h
END start