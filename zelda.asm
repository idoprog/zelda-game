IDEAL
MODEL small
STACK 100h
DATASEG
	x_player dw 40 ;it remembers the x of the player
	y_player dw 12 ;it remembers the y of the player
	hp_player db 3 ;it remembers the health of the player
	rand_num db ? ;after the randomize num procedure this num is put in this var
	is_legal db ? ;after checking the place in legal_place procedure it puts 1 or 0 in this if the move is legal or illegal
	x_mons_arr dw ?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ;array of all the x of the monsters
	y_mons_arr dw ?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ;array of all the y of the monsters
	hp_mons_arr db ?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ;array of the health of every monster
	mons_num dw 0 ;it's the monster counter now
	mons_x_mov_helper dw ? ;it helps with x values in the mons_mov procedure
	mons_y_mov_helper dw ? ;it helps with y values in the mons_mov procedure
	is_near db ?,?,?,? ;it helps in the check_near procedure if the first place is 1 = there's a painted pixel on the left if the second one is 1 = there is a pixel down and etc...
	num_position dw ? ;it helps in check_array procedure using this the procedure returns the value with this var 
	live_mons db 1 ;how many monsters to print this round
	attacked db ? ;it helps in the mons_attack if the mons_attacked the value is changed to 1
	;printing bmps vars
	los db 'los.bmp',0
	won db 'won.bmp',0
	file db '6.bmp',0
	Header db 54 dup (0)
	Palette db 256*4 dup (0)
	ScrLine db 320 dup (0)
	ErrorMsg db 'Error', 13, 10,'$'
CODESEG
; this procedure is not in the game but I used it beta tests to print empty screen 
; this is in text mode so to print pixel i used the ascii code 219 (also called DB) the character is a full text slot size so you can print pixel in colors using this char
; input:none
; output:none
; goal:print black screen
proc print_black_board
	push bp ;pushing registers that are used in the code
	mov bp,sp 
	push ax
	push di
	push si
	push dx
	push cx
	
	mov si, 25 ;moving to si the y 
;this loop is printing black pixel on every slot on the board using x and y 
downRow:
	mov ah,2 ;moving to ah 2 to get it ready for the interrupt that prints char to the screen
	mov di, 79 ;moving to di the x
	mov dl, 0ah ;moving the value to print this value is to get to next row
	int 21h ;prints next row
row:
	mov ah,9 ;moving ah 9 to get it ready for the interrupt that apply settings to the printing
	mov bx,0 ;page (always 0 i my case
	mov cx,1 ;how many chars i want to print, because i print it cahr by char i need it print one at a time
	int 10h ;applying settings
	mov ah,2 
	mov dl,219 ;moving the ascii code to print DB (see above)
	int 21h ;prints
	mov cx,0
	dec di
	cmp di, 0 ;checks if we finished row
	jne row
	
	dec si
	cmp si, 0 ;check if we need to go to next row
	jne downRow
	
	pop cx ;poping values 
	pop dx 
	pop si
	pop di
	pop ax
	pop bp 
	ret
endp print_black_board


; this procedure prints the game board with the main character in the middle in the start position using another procedure that prints squares in colors
; inputs: the offset of the player x,the offset of the player y
; outputs: none
; goal: prints game start board with the player 
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

; this procedure prints squre in selected color starting in the starting pixel that is given by the programmer and ending the square in a selected position pushed by the programmer
; it print using another function that prints 1 pixel
; inputs: starting x,starting y,ending x,ending y,and color to print the square
; outputs:none
; goal:print square in color
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
; this procedure is one of the main procedures of the program using int 16h ah=1 interrupt this procedure read the last value that entered the keyboard buffer
; so using that the player move and attack
; inputs:the offset of x player,the offset of y player,is legal offset (a helper var,see above),is near offset (a helper var,see above),array contaning x values of monsters,array contaning y values of monsters
		; array contaning hp values of monsters,num position offset (a helper var,see above),counter var of live monster
; outputs:updated x and y values,live monster counter updated
; goal:respond to player clicking on the keyboard by action that suits the press
proc check_for_press
x_player_offset equ [bp+20] ;renaming pushed values for easier mangement
y_player_offset equ [bp+18]
is_legal_offset equ [bp+16]
is_near_offset equ [bp+14]
x_mons_arr_offset equ [bp+12]
y_mons_arr_offset equ [bp+10]
hp_mons_arr_offset equ [bp+8]
num_position_offset equ [bp+6]
live_mons_offset equ [bp+4]
	push bp
	mov bp,sp ;pushing used registers
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	mov bx,x_player_offset 
	mov di,[word ptr bx] ;moving the x of the player to di 
	mov bx,y_player_offset
	mov dx,[word ptr bx] ;moving the y of the player to dx
	mov ah,1h
	int 16h ;int 16h ah=1 takess the last value in the keyboard buffer and puts it in al if there was no value the zero flag will be zero otherwise it will become 1
	jnz pres ;the flag is not zero so the user pressed somthing
	jz finish_check_for_press ;the flag is zero so there isn't any value
pres:
	cmp al,'w' ;checking if the value is 'w'
	je up_pressed
	jne keep_check1
keep_check1:
	cmp al,'a'  ;checking if the value is 'a'
	je left_pressed
	jne keep_check2
keep_check2:
	cmp al,'s' ;checking if the value is 's'
	je down_pressed
	jne keep_check3
keep_check3:
	cmp al,'d' ;checking if the value is 'd'
	je right_pressed
	jne keep_check4
keep_check4:
	cmp al,'e' ;checking if the value is 'e'
	je attack_pressed
	jne finish_check_for_press ;the user pressed unknown value

;using legal place procedure this part is moving the player up if the move is illegal it does a beep and end the procedure (also updating previuos values)
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
	push 1
	call mov_up ;moving the player up
	jmp finish_check_for_press
;using legal place procedure this part is moving the player down if the move is illegal it does a beep and end the procedure (also updating previuos values)
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
	push 1
	call mov_down ;moving the player down
	jmp finish_check_for_press

;using legal place procedure this part is moving the player right if the move is illegal it does a beep and end the procedure (also updating previuos values)
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
	push 1
	call mov_right ;moving the player right
	jmp finish_check_for_press

;using legal place procedure this part is moving the player left if the move is illegal it does a beep and end the procedure (also updating previuos values)	
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
	push 1
	call mov_left ;moving the player left
	jmp finish_check_for_press
;if 'e' key is pressed the player attacks all the monsters close to him
attack_pressed:
	push di 
	push dx
	push is_near_offset
	push 4
	call check_near ;check pixels near player's pixel
;if the value is one in the first slot of the array there's monster on the left, it attacks it
left_mons: 
	mov bx,is_near_offset
	cmp [byte ptr bx],1
	jne down_mons
	dec di
	push di
	push x_mons_arr_offset
	push 15
	push num_position_offset
	call check_array
	mov bx, num_position_offset
	cmp [byte ptr bx],70
	je down_mons
	mov si,[word ptr bx]
	mov bx,y_mons_arr_offset
	cmp [word ptr bx+si],dx
	jne down_mons
	mov bx,hp_mons_arr_offset
	dec [byte ptr bx+si]
	inc di
	cmp [byte ptr bx+si],0
	jne down_mons
	mov bx,live_mons_offset
	dec [byte ptr bx]
;if the value is one in the second slot of the array there's monster down, it attacks it and update the monster life
down_mons:
	mov bx,is_near_offset
	cmp [byte ptr bx+1],1
	jne up_mons
	inc dx
	push di
	push x_mons_arr_offset
	push 15
	push num_position_offset
	call check_array
	mov bx, num_position_offset
	cmp [byte ptr bx],70
	je up_mons
	mov si,[word ptr bx]
	mov bx,y_mons_arr_offset
	cmp [word ptr bx+si],dx
	jne up_mons
	mov bx,hp_mons_arr_offset
	dec [byte ptr bx+si]
	dec dx
	cmp [byte ptr bx+si],0
	jne up_mons
	mov bx,live_mons_offset
	dec [byte ptr bx]
	
;if the value is one in the third slot of the array there's monster up, it attacks it and update the monster life
up_mons:
	mov bx,is_near_offset
	cmp [byte ptr bx+2],1
	jne right_mons
	dec dx
	push di
	push x_mons_arr_offset
	push 15
	push num_position_offset
	call check_array
	mov bx, num_position_offset
	cmp [byte ptr bx],70
	je right_mons
	mov si,[word ptr bx]
	mov bx,y_mons_arr_offset
	cmp [word ptr bx+si],dx
	jne right_mons
	mov bx,hp_mons_arr_offset
	dec [byte ptr bx+si]
	inc dx
	cmp [byte ptr bx+si],0
	jne right_mons
	mov bx,live_mons_offset
	dec [byte ptr bx]

;if the value is one in the forth slot of the array there's monster on the right, it attacks it	and update the monster life
right_mons:
	push 10
	push 9545
	call play_sound
	mov bx,is_near_offset
	cmp [byte ptr bx+3],1
	jne finish_check_for_press
	inc di
	push di
	push x_mons_arr_offset
	push 15
	push num_position_offset
	call check_array
	mov bx, num_position_offset
	cmp [byte ptr bx],70
	je finish_check_for_press
	mov si,[word ptr bx]
	mov bx,y_mons_arr_offset
	cmp [word ptr bx+si],dx
	jne finish_check_for_press
	mov bx,hp_mons_arr_offset
	dec [byte ptr bx+si]
	dec di
	cmp [byte ptr bx+si],0
	jne finish_check_for_press
	mov bx,live_mons_offset
	dec [byte ptr bx]
	jmp finish_check_for_press
	
;the action wasn't legal it plays sound
not_legal1:
	push 10
	push 9545
	call play_sound
finish_check_for_press:
	mov ah,0Ch ;at the end of the fuction since ah 1 int 16h isn't cleaning the buffer these commands cleans the buffer from previuos key strokes
	mov al,0
	int 21h
	
	pop si ;poping used registers
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 18 ;9 pushed values so it's 18 byte to clean from ss
endp check_for_press
	
; this procedure prints brown pixel in previuos postion and colors pixel in updated location the color is chosen by the user the updated position is up to the previuos
; inputs:x offset,y offset,color of the pixel
; outputs:none 
; goal:"moving" pixel palce by raplacing the last position with the new 
proc mov_up
x_player_offset equ [bp+8]
y_player_offset equ [bp+6]
color equ [bp+4]
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
	call print_char ;printing brown in previuos location
	mov bx,y_player_offset
	dec [word ptr bx] ;updating position
	mov bx,x_player_offset
	mov ax,[bx] ;ax = x
	mov bx,y_player_offset
	mov cx,[bx] ;cx = y
	push ax
	push cx
	push color
	call print_char ;printing colored pixel in updated position
	pop cx
	pop ax
	pop bx
	pop bp
	ret 6
endp mov_up
;this procedure prints brown pixel in previuos postion and colors pixel in updated location the color is chosen by the user the updated position is down to the previuos
;inputs:x offset,y offset,color of the pixel
;outputs:none 
;goal:"moving" pixel palce by raplacing the last position with the new 
proc mov_down	
x_player_offset equ [bp+8]
y_player_offset equ [bp+6]
color equ [bp+4]
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
	call print_char ;printing brown in previuos location
	mov bx,y_player_offset
	inc [word ptr bx] ;updating position
	mov bx,x_player_offset
	mov ax,[bx] ;ax = x
	mov bx,y_player_offset
	mov cx,[bx] ;cx = y
	push ax
	push cx
	push color
	call print_char ;printing colored pixel in updated position
	pop cx
	pop ax
	pop bx
	pop bp
	ret 6
endp mov_down
;this procedure prints brown pixel in previuos postion and colors pixel in updated location the color is chosen by the user the updated position is right to the previuos
;inputs:x offset,y offset,color of the pixel
;outputs:none 
;goal:"moving" pixel palce by raplacing the last position with the new 
proc mov_right	
x_player_offset equ [bp+8]
y_player_offset equ [bp+6]
color equ [bp+4]
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
	call print_char ;printing brown in previuos location
	mov bx,x_player_offset
	inc [word ptr bx] ;updating position
	mov bx,x_player_offset
	mov ax,[bx] ;ax = x
	mov bx,y_player_offset
	mov cx,[bx] ;cx = y
	push ax
	push cx
	push color
	call print_char ;printing colored pixel in updated position
	pop cx
	pop ax
	pop bx
	pop bp
	ret 6
endp mov_right
;this procedure prints brown pixel in previuos postion and colors pixel in updated location the color is chosen by the user the updated position is left to the previuos
;inputs:x offset,y offset,color of the pixel
;outputs:none 
;goal:"moving" pixel palce by raplacing the last position with the new 
proc mov_left	
x_player_offset equ [bp+8]
y_player_offset equ [bp+6]
color equ [bp+4]
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
	call print_char ;printing brown in previuos location
	
	mov bx,x_player_offset
	dec [word ptr bx] ;updating position
	
	mov bx,x_player_offset
	mov ax,[bx] ;ax = x
	mov bx,y_player_offset
	mov cx,[bx] ;cx = y
	push ax
	push cx
	push color
	call print_char ;printing colored pixel in updated position
	
	pop cx
	pop ax
	pop bx
	pop bp
	ret 6
endp mov_left

	
; this procedure is checking if a number is in a array if it's in the array in returns it's position in a var if it's not in the array it returns 70 (high imposibble value) in the var
; inputs:number to search,the array offset,array length,and a num position offset (a helper var,see above)
; outputs:number position in array if it's not in the array returns 70 (returns using var)
proc check_array
number equ [bp+10] ;renaming pushed values for easier working with them
array_offset equ [bp+8]
array_length equ [bp+6]
num_position_offset equ [bp+4]
	push bp
	mov bp,sp ;pushing used registers
	push bx
	push ax
	push si
	push di
	
	
	mov si,0
	mov bx,array_offset
	mov ax,number
;this loop search the pushed number in the array if he found it it will end the procedure
array_loop:
	cmp [word ptr bx+si],ax
	jne keep_go
	mov di,num_position_offset
	mov [word ptr di],si
	jmp finish_check_array ;found it so it ends the procedure
keep_go:
	inc si 
	cmp si,array_length
	jne array_loop ;haven't found keep searching
	
	mov bx,num_position_offset
	mov [byte ptr bx],70 ;it doesn't exists in the array

finish_check_array:
	
	pop di ;poping pushed registers
	pop si
	pop ax
	pop bx
	pop bp
	ret 8 ;4 pushed values so it's 8 bytes to clean from the ss
endp check_array

; this procedure prints the ascii 219 char which is a full text slot (also called DB) in a given value and color
; inputs:x,y,color
; outputs:none
; goal:print a pixel in a give location and color
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

; this procedure is waiting a given time of miliseconds using the ah 2ch interrupt to get system time and moving it to a register and calling it agian untill the equallity is broken and then a milisecond passed
; and then doing that a given time
; inputs:miliseconds to wait
; output:none 
; goal:waiting a miliseconds
proc timer
	push bp
	mov bp,sp ;pushing used registers
	push ax
	push cx
	push dx
	mov ah,2Ch ;moving for all the curse of the loop ah 2ch
setting_time:
	int 21h ;calling the interrupt
	mov al,dl ;moving the value in the time of the call
time_loop:
	int 21h ;calling agian
	cmp al,dl ;checking when the equallity is broken
	je time_loop
	dec [word ptr bp+4]
	cmp [word ptr bp+4],0 ;doing that pushed number of times
	jne setting_time
	pop dx ;poping registers
	pop cx
	pop ax
	pop bp 
	ret 2 ;one push value so it needs to clean 2 bytes of memory
endp timer
; same as timer procedure but here there is the check_for_press procedure so that even when it waits time the player could move
; inputs: position x of player offset,position y of player offset,is legal (helper var,see above),is near (healper var,see above),monster x array offset,monster y array offset,monster health offset
		; num position offset (helper var,see above),live monster counter
; outputs:none
; goal:wait time and let the player move in that time 
proc timer1
x_player_offset equ [bp+22] 
y_player_offset equ [bp+20]
is_legal_offset equ [bp+18]
is_near_offset equ [bp+16]
x_mons_arr_offset equ [bp+14]
y_mons_arr_offset equ [bp+12]
hp_mons_arr_offset equ [bp+10]
num_position_offset equ [bp+8]
live_mons_offset equ [bp+6]
	push bp
	mov bp,sp
	push ax
	push cx
	push dx
	mov ah,2Ch
setting_time1:
	int 21h
	mov al,dl
time_loop1:
	int 21h
	;letting the player move here:
	push x_player_offset 
	push y_player_offset
	push is_legal_offset
	push is_near_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push num_position_offset
	push live_mons_offset
	call check_for_press
	;keep checking time
	cmp al,dl
	je time_loop1
	dec [word ptr bp+4]
	cmp [word ptr bp+4],0
	jne setting_time1
	pop dx
	pop cx
	pop ax
	pop bp 
	ret 20
endp timer1
; this procedure randomize a number zero to give number (not included) it calls system time and divide the miliseconds in a number that can create on of your random options
; for exmple: the dividor sent-25 and we divide it by system miliseconds for exmple:46 46/25=1 (and ingnoring the reminder) we get our number 1 (which is from 0-3 4 options)
; input: random num offset (helper var,see above),dividor which is the number to divide
; output:using the rand_num_offset pushed value we output the result through
; goal:randomize num using dividor
proc random_num
rand_num_offset equ [bp+4] ;renaming pushed values for easier use
dvidor equ [bp+6]
	push bp
	mov bp,sp
	push cx ;pushing used registers
	push dx
	push bx
	push ax
	mov ah,2Ch
	int 21h ;getting system time
	mov al,dl
	xor ah,ah
	mov bl,dvidor
	div bl ;the dividing
	mov bx,rand_num_offset 
	mov [byte ptr bx],al ;outputs the result
	pop ax
	pop bx
	pop dx
	pop cx
	pop bp
	ret 4 ;2 pushed values so it's 4 bytes to clean from ss
endp random_num
; this procedure play sound from given number that number can be achived by dividing a contant number with the frequncy of the note and outputing that number to ports using in and out 
; inputs:note after dividing,time to play that note
proc play_sound
time_to_play equ [bp+6] ;renaming pushed values for easier use
note equ [bp+4]
	push bp
	mov bp,sp
	push ax
	
    ;start speaker
	in  al, 61h                                 
    or  al, 00000011b   
    out 61h, al         
	
	;chage ferq premission
	mov al,0b6h
	out 43h,al
	
	;changing freq
	mov ax,note
	out 42h,al
	mov al,ah
	out 42h,al
	
	
	;start timer to wanted time
	push time_to_play
	call timer 
	
	;stop sound
	in al, 61h                          
    and al, 11111100b 
    out 61h, al
	pop ax
	pop bp
	ret 4 ;two oushed values so it's 4 byte to clean from ss
endp play_sound

proc play_sound1
x_player_offset equ [bp+24]
y_player_offset equ [bp+22]
is_legal_offset equ [bp+20]
is_near_offset equ [bp+18]
x_mons_arr_offset equ [bp+16]
y_mons_arr_offset equ [bp+14]
hp_mons_arr_offset equ [bp+12]
num_position_offset equ [bp+10]
live_mons_offset equ [bp+8]
time_to_play equ [bp+6] ;renaming pushed values for easier use
note equ [bp+4]
	push bp
	mov bp,sp
	push ax
	
    ;start speaker
	in  al, 61h                                 
    or  al, 00000011b   
    out 61h, al         
	
	;chage ferq premission
	mov al,0b6h
	out 43h,al
	
	;changing freq
	mov ax,note
	out 42h,al
	mov al,ah
	out 42h,al
	
	
	;start timer to wanted time
	push x_player_offset
	push y_player_offset
	push is_legal_offset
	push is_near_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push num_position_offset
	push live_mons_offset
	push time_to_play
	call timer1
	
	;stop sound
	in al, 61h                          
    and al, 11111100b 
    out 61h, al
	pop ax
	pop bp
	ret 22 ;11 pushed values so it's 22 byte to clean from ss
endp play_sound1
	
; this procedure check if the place is legal using a position given by the programmer it also gets a direction from the programmer to know the movement 
; inputs:x,y, is legal offset (helper var,see above),direction the direction of the move 
; outputs:it outputs in is_legal 1 if the move is legal and 0 if it's illegal 
; goal:check if a move is legal or illegal and do "beep" if illegal
proc legal_place
x equ [bp+10] ;renaming pushed values for easier use
y equ [bp+8]
is_legal_ofsset equ [bp+6]
direc equ [bp+4] ;1 = left 2 = down 3 = up 4 = right
	push bp
	mov bp,sp 
	push ax ;pushing used registers
	push bx
	push cx
	mov cx,direc
	mov ax,x ;ax = x
	mov bx,y ;bx = y
	cmp cx,1
	je lefting ;checking the direction
	jne still_not1
still_not1:
	cmp cx,2
	je downing
	jne still_not2
still_not2:
	cmp cx,3
	je uping
	jne righting

;check legallity for left move
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
	jne keep_check_lefting3
keep_check_lefting3:
	cmp ax,79
	je not_legal
	jne it_legal
	
;check legallity for right move
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
	
	
;check legallity for up move
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
	cmp ax,45
	jae not_legal
	jb keep_check_uping2
keep_check_uping2:
	cmp bx,0
	je not_legal
	jne it_legal
	


;check legallity for right move
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
	jne keep_check_righting3
keep_check_righting3:
	cmp ax,0
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

; this procedure randomize a spawn from 4 roads and in every road it randomize specific slot in the road
; inputs: player x offset, player y offset, is legal offset (helper var,see above),is near offset (helper var,see above), monster x array offset, monster y array offset, monster health array
		; num position offset (helper var,see above),live monster counter, random number offset (helper var,see above),moster counter offset
; outputs:updating the x and y monster array,updating monster health when spawning (3)
; goal:spawn a monster in a randomized position
proc spawn_mons
	x_player_offset equ [bp+24] ;renaming pushed values so it's easier to use
	y_player_offset equ [bp+22]
	is_legal_offset equ [bp+20]
	is_near_offset equ [bp+18]
	x_mons_arr_offset equ [bp+16]
	y_mons_arr_offset equ [bp+14]
	hp_mons_arr_offset equ [bp+12]
	num_position_offset equ [bp+10]
	live_mons_offset equ [bp+8]
	rand_num_offset equ [bp+6]
	mons_num_offset equ [bp+4]

	push bp
	mov bp,sp
	push cx ;pushing using registers
	push bx
	push di
	push si
	;check for press of the player to give the feel of fast response
	push x_player_offset
	push y_player_offset
	push is_legal_offset
	push is_near_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push num_position_offset
	push live_mons_offset
	call check_for_press
	
	
	mov di,mons_num_offset
	mov si,[word ptr di]
	mov bx,hp_mons_arr_offset
	mov [byte ptr bx+si],3
	;randomize one of the 4 roads
	push 25
	push rand_num_offset
	call random_num
	mov bx,rand_num_offset
	cmp [byte ptr bx],1
	je up_road
	cmp [byte ptr bx],2
	je right_road
	cmp [byte ptr bx],3
	je down_road
	jne left_road
;if the randomized road is up randomize a specific position	
up_road:
	push 10
	push rand_num_offset
	call random_num
	mov bx,rand_num_offset
	mov si,35
	add si,[word ptr bx]
	mov di,mons_num_offset
	mov cx,[word ptr di]
	mov di,cx
	mov bx,x_mons_arr_offset
	mov [word ptr bx+di],si
	mov bx,y_mons_arr_offset
	mov [word ptr bx+di],0
	
	mov bx,x_mons_arr_offset
	push [word ptr bx+di]
	mov bx,y_mons_arr_offset
	push [word ptr bx+di]
	push 4 
	call print_char
	jmp finish_spawn_mons
	
;if the randomized road is right randomize a specific position		
right_road:
	push 20
	push rand_num_offset
	call random_num
	mov bx,rand_num_offset
	mov si,9
	add si,[word ptr bx]
	mov di,mons_num_offset
	mov cx,[word ptr di]
	mov di,cx
	mov bx,x_mons_arr_offset
	mov [word ptr bx+di],79
	mov bx,y_mons_arr_offset
	mov [word ptr bx+di],si
	
	mov bx,x_mons_arr_offset
	push [word ptr bx+di]
	mov bx,y_mons_arr_offset
	push [word ptr bx+di]
	push 4
	call print_char
	jmp finish_spawn_mons

;if the randomized road is down randomize a specific position			
down_road:
	push 10
	push rand_num_offset
	call random_num
	mov bx,rand_num_offset
	mov si,35
	add si,[word ptr bx]
	mov di,mons_num_offset
	mov cx,[word ptr di]
	mov di,cx
	mov bx,x_mons_arr_offset
	mov [word ptr bx+di],si
	mov bx,y_mons_arr_offset
	mov [word ptr bx+di],24
	
	mov bx,x_mons_arr_offset
	push [word ptr bx+di]
	mov bx,y_mons_arr_offset
	push [word ptr bx+di]
	push 4 
	call print_char
	jmp finish_spawn_mons

	
	
;if the randomized road is left randomize a specific position		
left_road:
	push 20
	push rand_num_offset
	call random_num
	mov bx,rand_num_offset
	mov si,9
	add si,[word ptr bx]
	mov di,mons_num_offset
	mov cx,[word ptr di]
	mov di,cx
	mov bx,x_mons_arr_offset
	mov [word ptr bx+di],0
	mov bx,y_mons_arr_offset
	mov [word ptr bx+di],si
	
	mov bx,x_mons_arr_offset
	push [word ptr bx+di]
	mov bx,y_mons_arr_offset
	push [word ptr bx+di]
	push 4 
	call print_char
finish_spawn_mons:
	;check for press of the player to give the feel of fast response
	push x_player_offset
	push y_player_offset
	push is_legal_offset
	push is_near_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push num_position_offset
	push live_mons_offset
	call check_for_press
	
	
	pop si ;poping used registers
	pop di
	pop bx
	pop cx
	pop bp
	ret 22
endp spawn_mons


;this procedure make the monster move after the player using his position and the legal_place procedure check for press is also here to give the player a fast response
;inputs: player x offset, player y offset, is legal offset (helper var,see above),is near offset (helper var,see above), monster x array offset, monster y array offset, monster health array
;		moster counter offset, x helper offset (helper var,see above), y helper offset (helper var,see above), num position offset (helper var,see above),live monster counter
;outputs:updated monster position
;goal:monster that follows the player 
proc mov_mons
x_player_offset equ [bp+26] ;renaming pushed values for easier use
y_player_offset equ [bp+24]
is_legal_offset equ [bp+22]
is_near_offset equ [bp+20]
x_mons_arr_offset equ [bp+18]
y_mons_arr_offset equ [bp+16]
hp_mons_arr_offset equ [bp+14]
mons_num_offset equ [bp+12]
x_helper_offset equ [bp+10]
y_helper_offset equ [bp+8]
num_position_offset equ [bp+6]
live_mons_offset equ [bp+4]
	push bp
	mov bp,sp
	push ax ;push used registers
	push bx
	push cx
	push dx
	push si
	push di
	;check for press of the player to give the feel of fast response
	push x_player_offset
	push y_player_offset
	push is_legal_offset
	push is_near_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push num_position_offset
	push live_mons_offset
	call check_for_press
	;copying values from offsets
	mov bx,x_player_offset
	mov ax, [word ptr bx] ;ax = x
	
	mov bx, y_player_offset
	mov cx, [word ptr bx] ;cx = y
	
	mov bx,mons_num_offset
	mov di,[word ptr bx] ;di = mons_num
	
	mov bx,x_mons_arr_offset
	mov dx,[word ptr bx+di] ;dx = mons_x
	
	mov bx,y_mons_arr_offset
	mov si,[word ptr bx+di] ;si = mons_y
	
	
	cmp ax,dx
	ja sub_ax_dx
	jb sub_dx_ax
	je up_or_down
;subbing monster x from x player
sub_ax_dx:
	mov bx,x_helper_offset
	mov [word ptr bx],1 ;1 = x player is bigger
	sub ax,dx
	cmp ax,8
	jbe up_or_down
	ja y_check
;subbing x player from monster x
sub_dx_ax:
	mov bx,x_helper_offset
	mov [word ptr bx],0 ;0 = x monster is bigger
	sub dx,ax
	cmp dx,8
	jbe up_or_down
	ja y_check
;using the y of the player or the monster it checks if it's need to go up or down (which is bigger)
up_or_down:
	cmp cx,si
	ja mons_mov_down
	jb mons_mov_up
	je right_or_left
;using the x of the player or the monster it checks if it's need to go right or left (which is bigger)
right_or_left:
	mov bx,x_helper_offset
	cmp [word ptr bx],0
	je mons_mov_left
	jne mons_mov_right
;check which y is bigger agian to determine whos bigger
y_check:
	cmp cx,si
	ja sub_cx_si
	jb sub_si_cx
	je right_or_left
;subbing monster y from y player	
sub_cx_si:
	mov bx,y_helper_offset
	mov [word ptr bx],1 ;1 = y player is bigger
	sub cx,si
	cmp cx,7
	jbe right_or_left
	ja check_sector
;subbing y player from monster y
sub_si_cx:
	mov bx,y_helper_offset
	mov [word ptr bx],0 ;0 = y monster is bigger
	sub si,cx
	cmp si,7
	jbe right_or_left
	ja check_sector
;it compares the values to know how to move even when they are in two different sector
check_sector:
	mov bx,x_helper_offset
	cmp [word ptr bx],1
	je up_or_down
	jne right_or_left

;the monster move up, if it's illegal it moves left or right	
mons_mov_up:
	mov bx,x_mons_arr_offset
	mov dx,[word ptr bx+di]
	
	mov bx,x_helper_offset
	mov [word ptr bx],dx
	
	mov bx,y_mons_arr_offset
	mov si,[word ptr bx+di]
	
	mov bx,y_helper_offset
	mov [word ptr bx],si
	
	push dx
	push si
	push is_legal_offset
	push 3
	call legal_place
	
	mov bx,is_legal_offset
	cmp [byte ptr bx],0
	jne right_mov_up
	
	mov bx,x_player_offset
	mov ax,[word ptr bx]
	cmp ax,dx
	ja mons_mov_right
	jb mons_mov_left
	
	
right_mov_up:
	push x_helper_offset
	push y_helper_offset
	push 4 
	call mov_up
	
	mov bx,x_helper_offset
	mov dx,[word ptr bx]
	mov bx,x_mons_arr_offset
	mov [word ptr bx+di],dx
	
	mov bx,y_helper_offset
	mov si,[word ptr bx]
	mov bx,y_mons_arr_offset
	mov [word ptr bx+di],si
	
	jmp finish_mons_mov


;the monster move down, if it's illegal it moves left or right		
mons_mov_down:
	mov bx,x_mons_arr_offset
	mov dx,[word ptr bx+di]
	
	mov bx,x_helper_offset
	mov [word ptr bx],dx
	
	mov bx,y_mons_arr_offset
	mov si,[word ptr bx+di]
	
	mov bx,y_helper_offset
	mov [word ptr bx],si
	
	push dx
	push si
	push is_legal_offset
	push 2
	call legal_place
	
	mov bx,is_legal_offset
	cmp [byte ptr bx],0
	jne right_mov_down
	
	mov bx,x_player_offset
	mov ax,[word ptr bx]
	cmp ax,dx
	ja mons_mov_right
	jb mons_mov_left
	
right_mov_down:
	push x_helper_offset
	push y_helper_offset
	push 4 
	call mov_down
	
	mov bx,x_helper_offset
	mov dx,[word ptr bx]
	mov bx,x_mons_arr_offset
	mov [word ptr bx+di],dx
	
	mov bx,y_helper_offset
	mov si,[word ptr bx]
	mov bx,y_mons_arr_offset
	mov [word ptr bx+di],si
	
	jmp finish_mons_mov
;the monster move left, if it's illegal it moves up or down		
mons_mov_left:
	mov bx,x_mons_arr_offset
	mov dx,[word ptr bx+di]
	
	mov bx,x_helper_offset
	mov [word ptr bx],dx
	
	mov bx,y_mons_arr_offset
	mov si,[word ptr bx+di]
	
	mov bx,y_helper_offset
	mov [word ptr bx],si
	
	push dx
	push si
	push is_legal_offset
	push 1
	call legal_place
	
	mov bx,is_legal_offset
	cmp [byte ptr bx],0
	jne right_mov_left
	
	mov bx,y_player_offset
	mov cx,[word ptr bx]
	cmp cx,si
	ja mons_mov_down
	jb mons_mov_up
	
right_mov_left:
	push x_helper_offset
	push y_helper_offset
	push 4 
	call mov_left
	
	mov bx,x_helper_offset
	mov dx,[word ptr bx]
	mov bx,x_mons_arr_offset
	mov [word ptr bx+di],dx
	
	mov bx,y_helper_offset
	mov si,[word ptr bx]
	mov bx,y_mons_arr_offset
	mov [word ptr bx+di],si
	
	jmp finish_mons_mov
;the monster move right, if it's illegal it moves up or down			
mons_mov_right:
	mov bx,x_mons_arr_offset
	mov dx,[word ptr bx+di]
	
	mov bx,x_helper_offset
	mov [word ptr bx],dx
	
	mov bx,y_mons_arr_offset
	mov si,[word ptr bx+di]
	
	mov bx,y_helper_offset
	mov [word ptr bx],si
	
	push dx
	push si
	push is_legal_offset
	push 4
	call legal_place
	
	mov bx,is_legal_offset
	cmp [byte ptr bx],0
	jne right_mov_right
	
	mov bx,y_player_offset
	mov cx,[word ptr bx]
	cmp cx,si
	ja mons_mov_down
	jb mons_mov_up
	
right_mov_right:
	push x_helper_offset
	push y_helper_offset
	push 4 
	call mov_right
	
	mov bx,x_helper_offset
	mov dx,[word ptr bx]
	mov bx,x_mons_arr_offset
	mov [word ptr bx+di],dx
	
	mov bx,y_helper_offset
	mov si,[word ptr bx]
	mov bx,y_mons_arr_offset
	mov [word ptr bx+di],si
	
	
finish_mons_mov:
	;check for press of the player to give the feel of fast response
	push x_player_offset
	push y_player_offset
	push is_legal_offset
	push is_near_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push num_position_offset
	push live_mons_offset
	push 20
	call timer1
	
	pop di ;poping used registers
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 24
endp mov_mons
; this procedure gets a position and it checks the pixels near that position if the color match the color is given by the programmer
; inputs:x,y,is near offset (helper var,see above),color
; outputs:using is near offset array it moves 1 to every direction where the color that is given by the programmer is equal to the color near that pixel
; goal:check if there is a monster or a player near a given position
proc check_near
x equ [bp+10] ;renaming the values for easier use
y equ [bp+8]
is_near_offset equ [bp+6] ;if first byte is 1 = left second 1 = down third 1 = up forth 1 = right
color equ [bp+4]
	push bp ;pushing used registers
	mov bp,sp
	push dx
	push bx
	push cx
	push ax
	push di
	
	mov dl,x ;moving values to registers
	mov dh,y
	mov bh,0
;checking above the given position	
up_checker:
	dec dh
	mov ah,2 
	int 10h
	mov ah,8
	int 10h
	cmp ah,color
	jne down_checker
	mov di,is_near_offset
	mov [byte ptr di+2],1
;checking down to the given position		
down_checker:
	add dh,2
	mov ah,2
	int 10h
	mov ah,8
	int 10h
	cmp ah,color
	jne left_checker
	mov di,is_near_offset
	mov [byte ptr di+1],1
;checking left to the given position	
left_checker:
	dec dh
	dec dl
	mov ah,2
	int 10h
	mov ah,8
	int 10h
	cmp ah,color 
	jne right_checker
	mov di,is_near_offset
	mov [byte ptr di],1
;checking right to the given position		
right_checker:
	add dl,2
	mov ah,2
	int 10h
	mov ah,8
	int 10h
	cmp ah,color 
	jne finish_check_near
	mov di,is_near_offset
	mov [byte ptr di+3],1
	
finish_check_near:

	pop di ;poping used registers
	pop ax
	pop cx
	pop bx
	pop dx
	pop bp
	ret 8
endp check_near
; this procedure checks if a user is near her and the she attacks him 
; inputs: player x offset, player y offset, is legal offset (helper var,see above),is near offset (helper var,see above), monster x array offset, monster y array offset, monster health array
		; moster counter offset, num position offset (helper var,see above),hp player offset,attacked offset (helper var,see above),live monster offset
; outputs:it's updating the hp of the player if attack
; goal:to attack the player and beep
proc mons_attack
	x_player_offset equ [bp+26] ;renaming pushed values so it's easier to use
	y_player_offset equ [bp+24]
	is_legal_offset equ [bp+22]
	live_mons_offset equ [bp+20]
	attacked_offset equ [bp+18]
	x_mons_arr_offset equ [bp+16]
	y_mons_arr_offset equ [bp+14]
	hp_mons_arr_offset equ [bp+12]
	mons_num_offset equ [bp+10]
	hp_player_offset equ [bp+8]
	is_near_offset equ [bp+6]
	num_position_offset equ [bp+4]
	push bp
	mov bp,sp
	push bx
	push si
	push dx
	push di
	
	mov bx,mons_num_offset
	mov si,[word ptr bx]
	;putting values in registers
	mov bx,x_mons_arr_offset
	mov dx,[word ptr bx+si] ;dx = x
	
	mov bx,y_mons_arr_offset
	mov di,[word ptr bx+si] ;di = y
	
	push x_player_offset
	push y_player_offset
	push is_legal_offset
	push is_near_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push num_position_offset
	push live_mons_offset
	push 10
	call timer1
	
	;checking if near
	push dx
	push di 
	push is_near_offset
	push 1
	call check_near
	;checking the array is_near to see if the player is near
	push 1
	push is_near_offset
	push 4
	push num_position_offset
	call check_array
	mov bx,num_position_offset
	cmp [byte ptr bx],70
	je not_attacked
	mov bx,hp_player_offset
	dec [byte ptr bx]
	mov bx,attacked_offset
	;if attack it plays sound
	push x_player_offset
	push y_player_offset
	push is_legal_offset
	push is_near_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push num_position_offset
	push live_mons_offset
	push 10
	push 9545
	call play_sound1
	mov [byte ptr bx],1
	;waiting 10 miliseconds while giving the player the ability to move
	push x_player_offset
	push y_player_offset
	push is_legal_offset
	push is_near_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push num_position_offset
	push live_mons_offset
	push 10
	call timer1
	jmp finish_mons_attack
not_attacked:
	mov bx,attacked_offset
	mov [byte ptr bx],0
finish_mons_attack:
	pop di ;poping used registers
	pop dx
	pop si
	pop bx
	pop bp
	ret 24
endp mons_attack

; this procedure changes all the values of an array to zero
; inputs:array offset,array length
; outputs:none
; goal:reset an array 
proc clear_array
array_offset equ [bp+6]
array_length equ [bp+4]
	push bp
	mov bp,sp
	push bx
	push si
	mov si,0
	mov bx,array_offset
array_clear:
	mov [byte ptr bx],0 ;moving zero to array values
	inc si
	cmp si,array_length
	jne array_clear
	
	
	pop si
	pop bx
	pop bp
	ret 4
endp clear_array


; this procedure is runnig one game using all procedures and vars
; inputs:every var except for var of printing a bmp (see above)
; outputs:none
; goal:run one game
proc manage_game
	offset_won equ [bp+36]
	offset_los equ [bp+34]
	attacked_offset equ [bp+32]
	x_player_offset equ [bp+30]
	y_player_offset equ [bp+28]
	hp_player_offset equ [bp+26]
	rand_num_offset equ [bp+24]
	is_legal_offset equ [bp+22]
	x_mons_arr_offset equ [bp+20]
	y_mons_arr_offset equ [bp+18]
	hp_mons_arr_offset equ [bp+16]
	mons_num_offset equ [bp+14]
	x_helper_offset equ [bp+12]
	y_helper_offset equ [bp+10]
	is_near_offset equ [bp+8]
	num_position_offset equ [bp+6]
	live_mons_offset equ [bp+4]
	push bp
	mov bp,sp
	push bx
	push si
	push cx
	;spawns monster
	push x_player_offset
	push y_player_offset
	call print_game_board
	
	push x_player_offset
	push y_player_offset
	push is_legal_offset
	push is_near_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push num_position_offset
	push live_mons_offset
	push rand_num_offset
	push mons_num_offset
	call spawn_mons

	

mons_game:
	;attacks the player
	push x_player_offset
	push y_player_offset
	push is_legal_offset
	push live_mons_offset
	push attacked_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push mons_num_offset
	push hp_player_offset
	push is_near_offset
	push num_position_offset
	call mons_attack
	;clearing is near array
	push is_near_offset
	push 4
	call clear_array
	;checking if attacked
	mov bx,attacked_offset
	cmp [byte ptr bx],1 ;if not attacks the monster move
	jne mons_game_mov
	mov bx,hp_player_offset ;if attacks it checks the player health
	cmp [byte ptr bx],0
	je lost ;if he died the game is over
	jne ending
mons_game_mov:
	push x_player_offset
	push y_player_offset
	push is_legal_offset
	push is_near_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push mons_num_offset
	push x_helper_offset
	push y_helper_offset
	push num_position_offset
	push live_mons_offset
	call mov_mons


ending:	
	push x_player_offset
	push y_player_offset
	push is_legal_offset
	push is_near_offset
	push x_mons_arr_offset
	push y_mons_arr_offset
	push hp_mons_arr_offset
	push num_position_offset
	push live_mons_offset
	call check_for_press
	;checking if the monster is dead
	mov bx,mons_num_offset
	mov si,[word ptr bx]
	mov bx,hp_mons_arr_offset
	cmp [byte ptr bx+si],0
	je win
	jmp mons_game

lost:
	push offset_los
	call PrintBMP1
	jmp finish_manage_game	
win:
	push offset_won
	call PrintBMP1
finish_manage_game:
	pop cx
	pop si
	pop bx
	pop bp
	ret 34
endp manage_game
; opens a file
; input: offset file name
; output: file's handle
proc OpenFile
	push bp
	mov bp, sp
	push ax
	push bx
	push dx
	; Open file
	mov ah, 3Dh
	xor al, al
	mov dx, [bp+4] ;file name
	int 21h
	jc openerror
	mov [bp+4], ax ;file's handle
	
	pop dx
	pop bx
	pop ax
	pop bp
	ret
openerror:
	mov dx, offset ErrorMsg
	mov ah, 9h
	int 21h
	pop dx
	pop bx
	pop ax
	pop bp
	ret
endp OpenFile

;Reads Header and Palette
;input: file handle, offset to put header, offset to put Palette
;output: changes the given places the the header and palette
;		 moves the reading pointer in the file to the start of the actual image
proc ReadHeaderPalette
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	mov bx, [bp+8]
	mov ah,3fh
	mov cx,54
	mov dx, [bp+6]
	int 21h
	; Read BMP file color palette, 256 colors * 4 bytes (400h)
	mov ah,3fh
	mov cx,400h
	mov dx, [bp+4]
	int 21h
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
endp ReadHeaderPalette

;chnanges the colors from BGR (assembly color format) to RGB (BMP file color format)
;input: offset to read Palette from
;output: the colors in the ports are changed
proc CopyPal
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	; Copy the colors palette to the video memory
	; The number of the first color should be sent to port 3C8h
	; The palette is sent to port 3C9h
	mov si, [bp+4]
	mov cx,256
	mov dx,3C8h
	mov al,0
	; Copy starting color to port 3C8h
	out dx,al
	; Copy palette itself to port 3C9h
	inc dx
PalLoop:
	; Note: Colors in a BMP file are saved as BGR values rather than RGB.
	mov al,[si+2] ; Get red value.
	shr al,2 ; Max. is 255, but video palette maximal
	; value is 63. Therefore dividing by 4.
	out dx,al ; Send it.
	mov al,[si+1] ; Get green value.
	shr al,2
	out dx,al ; Send it.
	mov al,[si] ; Get blue value.
	shr al,2
	out dx,al ; Send it.
	add si,4 ; Point to next color.
	; (There is a null chr. after every color.)
	loop PalLoop
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2
endp CopyPal

; prints to the graphic screen the BMP file (after opening file, reading palette and copying it)
; input: file handle
; output: copying the BMP file from the file to the data segment to the A000 segment, the graphics screen
proc CopyBitmap
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	mov bx, [bp+4] ;handle
	; BMP graphics are saved upside-down.
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	mov ax, 0A000h
	mov es, ax
	mov cx,200
PrintBMPLoop:
	push cx
	; di = cx*320, point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	; Read one line
	mov ah,3fh
	mov cx,320
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,320
	mov si,offset ScrLine
	rep movsb ; Copy line to the screen
	;rep movsb is same as the following code:
	;mov es:di, ds:si
	;inc si
	;inc di
	;dec cx
	pop cx
	loop PrintBMPLoop
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2
endp CopyBitmap

; closes an open file
; input: file handle
; output: none
proc CloseFile
	push bp
	mov bp, sp
	push ax
	push bx
	mov ah, 03Eh
	mov bx, [bp+4]
	int 21h
	pop bx
	pop ax
	pop bp
	ret 2
endp CloseFile

; this procedure prints to the screen a BMP file, doing all the things needed
; opening the file, reading header, reading palette, copying the palette, copying the BMP, and closing the file
; input: offset of file's name
; output: moving to graphics mode and chaning the screen to the given BMP file
proc PrintBMP
	push bp
	mov bp, sp
	push ax
	
	; Process BMP file
	push [bp+4]
	call OpenFile
	pop ax ;file's handle
	push ax
	push offset Header
	push offset Palette
	call ReadHeaderPalette
	push offset Palette
	call CopyPal
	push ax
	call CopyBitmap
	push ax
	call CloseFile
	
	pop ax
	pop bp
	ret 2
endp PrintBMP

;this procedure prints to the screen a BMP file, doing all the things needed
;opening the file, reading header, reading palette, copying the palette, copying the BMP, and closing the file
;input: offset of file's name
;output: moving to graphics mode and chaning the screen to the given BMP file
proc PrintBMP1
	push bp
	mov bp, sp
	push ax
	
	; Graphic mode
	mov ax, 13h
	int 10h
	; Process BMP file
	push [bp+4]
	call OpenFile
	pop ax ;file's handle
	push ax
	push offset Header
	push offset Palette
	call ReadHeaderPalette
	push offset Palette
	call CopyPal
	push ax
	call CopyBitmap
	push ax
	call CloseFile
	
	pop ax
	pop bp
	ret 2
endp PrintBMP1
start:
	mov ax,@data
	mov ds,ax
	
	; Graphic mode
	mov ax, 13h
	int 10h
	; Process BMP file
	push offset file
	call OpenFile
	pop ax ;file's handle
	push ax
	push offset Header
	push offset Palette
	call ReadHeaderPalette
	push offset Palette
	call CopyPal
	push ax
	call CopyBitmap
	push ax
	call CloseFile

PrintLoop:
	push offset file
	call PrintBMP
	
	push 3
	call timer
	
	mov ah,1
	int 16h
	jnz start_game
	
	dec [byte ptr file]
	cmp [byte ptr file], '0'
	jne PrintLoop
reset: 
	add [byte ptr file],6
	jmp PrintLoop
	
start_game:
	mov ah,0
	mov al,03
	int 10h
	mov ah,0Ch
	mov al,0
	int 21h
	push offset won 
	push offset los
	push offset attacked
	push offset x_player
	push offset y_player
	push offset hp_player
	push offset rand_num
	push offset is_legal
	push offset x_mons_arr
	push offset y_mons_arr
	push offset hp_mons_arr
	push offset mons_num
	push offset mons_x_mov_helper
	push offset mons_y_mov_helper
	push offset is_near
	push offset num_position
	push offset live_mons
	call manage_game
	mov ah,0
	int 16h
	
	mov ax, 3
	int 10h
	
	
exit:
	mov ax, 4c00h
	int 21h
END start


