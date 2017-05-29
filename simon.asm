; Presented by: Gal Yahav
; School: Rabin Tel Mond, Grade 10, Class: 7
; Project name: Simon
; Game explanation: The Simon game is a game that comes in a sequence of colors and the user has to repeat the sequence until he is wrong or reaches 20 times
IDEAL
MODEL small
STACK 100h
DATASEG

	note dw 2394h  ; 1193180d
	voice1 db 98h  ; red
	voice2 db 0ah  ; red 
	voice3 db 00eh ;green
	voice4 db 00fh ;yellow
	voice5 db 008h ;blue
	errorvoice db 030h

	round   db     00h
	
	count   dw     0
	
	game_over dw   0
	
	array db 20 dup ()
	Clock equ es:6Ch
	
	x 		dw     120
	y 		dw     70
	
	red 	dw     4
	green   dw     2
	yellow  dw     43
	blue    dw     1
	
	red1	dw     41
	green1  dw     10
	yellow1 dw     14
	blue1   dw 	   33
	
	HowToPlay db 'How to play : Repeat after the color     sequence with the mouse',10,13,'$'
	StartMessage db 'press any key to continue',10,13,'$'
	message db 'game over ',10,13,'$'
	level   db 'You have reached stage:$' 
	win     db 'you win $'
	resetgame1 db 'press Enter to reset the game',10,13,'$'
	
	BackGround db 'sim.bmp',0
	Header db 54 dup (0)
	Palette db 256*4 dup (0)
	ScrLine db 320 dup (0)
	ErrorMsg db 'Error', 13, 10,'$'
	
CODESEG
;opens a file
;input: offset file name
;output: file's handle
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
;output: changes the given places the header and palette moves the reading pointer in the file to the start of the actual image
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
;input: file handle, offset to read Palette from
;output: the colors in the ports are changed

proc CopyPal
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	mov bx, [bp+6]
	
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
	ret 4
endp CopyPal

;prints to the graphic screen the BMP file (after opening file, reading palette and copying it)
;input: file handle
;output: copying the BMP file from the file to the data segment to the A000 segment, the graphics screen
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

;closes an open file
;input: file handle
;output: none
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

;this procedure prints to the screen a BMP file, doing all the things needed
;opening the file, reading header, reading palette, copying the palette, copying the BMP, and closing the file
;input: offset of file's name
;output: moving to graphics mode and chaning the screen to the given BMP file
proc PrintBMP
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
	push ax
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

; This function causes the program to stop for a 0.05sec
;input: none
;output: none
proc wait_1_sec 
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	mov bx, 5
setsec:
	mov ah, 2ch
	int 21h
	mov al, dl ;miliseconds
checkforsec:
	mov ah, 2ch
	int 21h
	cmp al, dl ;checks if the miliseconds changed
	je checkforsec
	dec bx
	cmp bx, 0
	jne setsec
	pop dx
	pop cx
	pop bx
	pop ax
end1:
	pop bp
	ret
endp wait_1_sec

; This function accepts coordinates and color and prints a square of 40 by 40 according to the data
;input: x , y ,color
;output: none
proc Print_square 
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	
	
	xor si, si
	mov cx,[bp+6] ;x
	mov dx,[bp+4] ;y
	mov al,[bp+8] ;color
loop1: ; the loop print row in 1 color
	xor di,  di				
loop2: ; the loop print line in 1 color 
	mov bh,0h
	mov ah,0ch
	int 10h
	mov cx,[bp+6] ;x
	inc di
	add cx, di
	cmp di, 40
	jne loop2
	
	mov cx,[bp+6] ; x
	inc si
	mov dx,[bp+4] ;y
	add dx, si
	cmp si, 40
	jne loop1
	
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6

endp Print_square

;This function takes a guess from the user and sends for testing
;input: x , y ,round , count , errorvoice , note , game_over
;output: user guess(userx,usery)
proc user_turn
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	xor bx,bx
	mov si,[count]
NextGuessOrResetUserTurn:
	
	mov [game_over],0

; Loop until mouse click

MouseP: ; loop until mouse pressed

	mov ax,3h
	int 33h ;check left mouse click
	cmp bx, 01h  ; See if button is pressed
	jne MouseP ;If Not pressed, go back and check again
	
	xor bx, bx  ;Okay, button is pressed, clear the result

MouseR: ; loop until mouse released

	mov ax, 3
	int 33h     ;Check the mouse
	cmp bx, 0   ;See if button is released
	jne MouseR  ;If NOT equal, then not released, go check again.

	
	shr cx,1 ; adjust cx to range 0-319, to fit screen
	;read dot
	mov bh,0h
	mov ah,0dh
	int 10h ; read the x and the y in the mouse release location (and the color)
	
	; check if the place in the array = 1
	
	cmp [byte ptr array + si],1 
	jne CheckNumber
	
	push [bp + 14]
	push [bp + 16]
	push offset game_over
	push [bp + 4]
	push [bp + 6]
	push dx
	push cx
	call check_guess
	jmp NextTurn
	
CheckNumber: ; check if the place in the array = 2
	
	cmp [byte ptr array + si],2 
	jne CheckNumber1
	
	push [bp + 14]
	push [bp + 16]
	push offset game_over
	push [bp + 4]
	mov di,[bp + 6]
	add di,40
	push di
	push dx
	push cx
	call check_guess
	jmp NextTurn
	
CheckNumber1: ; check if the place in the array = 3

	cmp [byte ptr array + si],3 
	jne CheckNumber2
	
	push [bp + 14]
	push [bp + 16]
	push offset game_over
	mov bx,[bp + 4]
	add bx,40
	push bx
	push [bp + 6]
	push dx
	push cx
	call check_guess
	jmp NextTurn
	
CheckNumber2: ;else the place in the array = 4
	
	push [bp + 14]
	push [bp + 16]
	push offset game_over
	mov bx,[bp + 4]
	add bx, 40
	push bx
	mov di, [bp + 6]
	add di, 40
	push di
	push dx
	push cx
	call check_guess
	
NextTurn:

	cmp [game_over],2 ; check if the player press the black area
	je NextGuessOrResetUserTurn  ; jmp if yes
	
	cmp [game_over],1 ; check if the player guess was wrong
	je EndGame ; jump if yes
	
	inc si
	cmp si,[word ptr round]
	jbe NextGuessOrResetUserTurn
	
EndGame: ; if the player's guess was wrong the game is over
	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 16
endp user_turn

;This function randomizes a random number between 1 and 4
;input: array
;output: number between 1 - 4
proc random_Array 

	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	
	xor_array:; The loop resets the array
	
    ; The loop draws a random number between 1 and 4 and inserts it into the array
	; generate random number, bx number of times
	mov ax, [Clock] ; read timer counter
	mov ah, [byte cs:bx] ; read one byte from memory
	xor al, ah ; xor memory and counter
	and al, 00000011b ; leave result between 0-3
	inc al; inc the result by 1 (make the result between 1-4)
	
	mov di,[word ptr round]
	mov [byte ptr array + di],al ; Enter the number to be placed in the array

	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
endp random_Array 

;This function accepts an array and sends the colors accordingly
;input: x , y ,round , array , all the colors , voice1 - 5 , note
;output: x,y,color,voice
proc PcTurn 
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	
	xor si,si
	
LoopPrintArray: ; A loop that prints all the colors in the array
	call wait_1_sec
	;color change (print_array)
	cmp [byte ptr array + si],1
	jne nextcolor
	push [bp+10]
	push [bp+4]
	push [bp+6]
	call Print_square
	
	push [bp + 28]
	push [bp + 26]
	call MakeVoice
	
	;return color
	push [bp+8]
	push [bp+4]
	push [bp+6]
	call Print_square
	
	jmp next_color
nextcolor:
	call wait_1_sec
	;color change (print_array)
	cmp [byte ptr array + si],2 
	jne nextcolor1
	push [bp+14]
	push [bp+4]
	mov di, [bp+6]
	add di, 40
	push di
	call Print_square
	
	push [bp + 30]
	push [bp + 24]
	call MakeVoice
	
	;return color
	push [bp+12]
	push [bp+4]
	mov di, [bp+6]
	add di, 40
	push di
	call Print_square
	
		
	jmp next_color
nextcolor1:
	call wait_1_sec
	;color change (print_array)
	cmp [byte ptr array + si],3
	jne nextcolor2
	push [bp+18]
	mov di, [bp+4]
	add di, 40
	push di
	push [bp+6]
	call Print_square
	
	push [bp + 32]
	push [bp + 24]
	call MakeVoice
	
	;return color
	push [bp+16]
	mov di, [bp+4]
	add di, 40
	push di
	push [bp+6]
	call Print_square
	
	jmp next_color
nextcolor2:
	call wait_1_sec
	;color change (print_array)
	push [bp+22]
	mov di, [bp+4]
	add di, 40
	push di
	mov di, [bp+6]
	add di, 40
	push di
	call Print_square
	
	push [bp + 34]
	push [bp + 24]
	call MakeVoice
	
	
	;return color
	push [bp+20]
	mov ax, [bp+4]
	add ax, 40
	push ax
	mov di, [bp+6]
	add di, 40
	push di
	
	call Print_square 
	
next_color:
	
	inc si
	cmp si,[word ptr round]
	jbe LoopPrintArray 
	

	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 36
endp PcTurn

; This function prints the game screen
;input: x,y,colors
;output:none
proc print_screem 
	
	push bp
	mov bp,sp
	
	push [bp+8]
	push [bp+4]
	push [bp+6]
	call Print_square ;print red score
	
	push [bp+10]
	push [bp+4]
	mov di, [bp+6]
	add di, 40
	push di
	call Print_square ;print green score
	
	push [bp+12]
	mov di, [bp+4]
	add di, 40
	push di
	push [bp+6]
	call Print_square ;print yellow score
	
	push [bp+14]
	mov di, [bp+4]
	add di, 40
	push di
	mov di, [bp+6]
	add di, 40
	push di
	call Print_square ;print blue score
	
	pop bp
	ret 12
endp print_screem

;This function that checks whether the user guessed correctly or not
;input:x,y,userx,usery,voice1-5 , note , errorvoice , game_over
;output: game_over = 0,1,2 (0 = continue,1 = endgame,2 = resetuserturn)
proc check_guess 
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	
;Check if the user click on the black area
	
	mov dx,70 ;y
	cmp dx,[bp+6] ;usery
	jbe NextCheck ; Check if the click was above the game board
	
	push [bp + 14]
	push [bp + 12]
	call MakeVoice
	mov [game_over],2 ; reset the user turn
	jmp TrueOrFalse
NextCheck:
	add dx, 80    ;y
	cmp dx,[bp + 6] ;usery
	jae NextCheck1 ; Check if the click was below the game board
	
	push [bp + 14]
	push [bp + 12]
	call MakeVoice
	mov [game_over],2 ; reset the user turn
	jmp TrueOrFalse
NextCheck1:
	mov cx,120 ;x
	cmp cx,[bp+4]  ;userx
	jbe NextCheck2 ; check if the click was left the game board
	
	push [bp + 14]
	push [bp + 12]
	call Makevoice
	mov [game_over],2 ; reset the user turn
	jmp TrueOrFalse
NextCheck2:
	add cx,80  ;x
	cmp cx,[bp + 4] ;userx
	jae CheckGuess ; check if the click was right the game board
	
	push [bp + 14]
	push [bp + 12]
	call MakeVoice
	;if false end the program
	mov [game_over],2 ; reset the user turn
	jmp TrueOrFalse

CheckGuess:
	
	mov dx,[bp+8] ;y
	cmp dx,[bp+6] ;usery
	jbe NextCheck3 
	
	;if false end the program
	mov [game_over],1
	jmp TrueOrFalse
NextCheck3:

	add dx,40     ;y
	cmp dx,[bp + 6] ;usery
	jae NextCheck4
	
	;if false end the program
	mov [game_over],1
	jmp TrueOrFalse
NextCheck4:
	
	mov cx,[bp+10] ;x
	cmp cx,[bp+4]  ;userx
	jbe NextCheck5
	
	;if false end the program
	mov [game_over],1
	jmp TrueOrFalse
NextCheck5:

	add cx,40     ;x
	cmp cx,[bp + 4] ;userx
	jae TrueOrFalse
	
	;if false end the program
	mov [game_over],1
	
TrueOrFalse:
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 14
endp check_guess

; This function receives a frequency and plays it
;input:frequency(2 sounds)
;output: none
proc MakeVoice 
	push bp
	mov bp,sp
	push ax
	push dx
	
	; open speaker
	
	in al, 61h
	or al, 00000011b
	out 61h, al
	
	; send control word to change frequency
	
	mov al, 0B6h
	out 43h, al
	
	mov al, [bp + 4]
	out 42h, al ; Sending lower byte
	mov al, [bp + 6]
	out 42h, al ; Sending upper byte

	call wait_1_sec
	
	; close the speaker
	
	in al, 61h
	and al, 11111100b
	out 61h, al
	
	pop dx
	pop ax
	pop bp
	ret 4
endp MakeVoice
	
start:
	mov ax, @data
	mov ds, ax
	
ResetGame:
	
	mov bx,0
resetarray:
	mov [array + bx],0
	inc bx
	cmp bx,20
	jne resetarray
	
	mov [word ptr round] ,0
	mov [word ptr count] ,0
	mov [word ptr game_over],0
	 
	push offset BackGround ; home screen
	call PrintBMP
	
	mov ah,00h
	int 16h  ; Press any key to continue
	
	mov dx,offset HowToPlay
	mov ah,9h
	int 21h
	
	mov dx,offset StartMessage ; print message press any key to continue
	mov ah,9h
	int 21h
	
	mov ah,00h
	int 16h  ; Press any key to continue
	
	mov ax, 13h
	int 10h ; graphic mode
	
	in al, 61h
	or al, 00000011b
	out 61h, al
	
	push [blue]
	push [yellow]
	push [green]
	push [red]
	push [y]
	push [x]
	call print_screem
	
	; Initializes the mouse

	mov ax,0h
	int 33h
	
	; Show mouse

	mov ax,1h
	int 33h
	
RandLoop: ; A loop of game stages
	
	mov ax, 40h
	mov es, ax
	xor cx,cx
	xor bx,bx
	
	push offset array
	push offset round
	call random_Array
	
	push offset round ;38
	push offset array ;36
	push [word ptr voice5] ;34
	push [word ptr voice4] ;32
	push [word ptr voice3] ;30
	push [word ptr voice2] ;28
	push [word ptr voice1] ;26
	push [Note]   ;24
	push [blue1]  ;22
	push [blue]   ;20 
	push [yellow1];18
	push [yellow] ;16
	push [green1] ;14
	push [green] ;12
	push [red1]  ;10
	push [red] ; 8
	push [y] ;6
	push [x] ;4
	call PcTurn
	
	push [word ptr errorvoice]
	push [Note]
	push offset game_over
	push offset round 
	push offset array
	push offset count
	push [y]
	push [x]
	call user_turn
	
	
	cmp [game_over],1 ; end the game
	je exit
	
	
	inc [round]
	cmp [round],20 ; next level
	jb RandLoop
	
	;END messages
	
	mov dx, offset win
	mov ah, 9h
	int 21h
	cmp [round],20 ; if you win the 20 stages
	je winner
	
	cmp [round],20 ; if you lose befor level 20
	jb lose
	
exit:
	push offset BackGround
	call PrintBMP
	mov dx, offset message;game over 
	mov ah, 9h
	int 21h
	
lose: ;0-19
	
	mov dx,offset level ; You have reached stage
	mov ah,9h
	int 21h
	
	; print number
	
	xor cx, cx
	mov ax, [word ptr round]
	mov bl, 0ah
	div bl
	mov cl, ah
	add al, '0'
	mov dl, al 
	mov ah,2
	int 21h
	add cl, '0'
	mov dl, cl 
	mov ah,2
	int 21h

	;new line
	mov dl, 10
	mov ah, 2
	int 21h
	;carriage return
	mov dl, 13
	mov ah, 2
	int 21h
	
	jmp endgame1
winner: ;20
	mov dx,offset level ; You have reached stage
	mov ah,9h
	int 21h

	mov dl, '2'
	mov ah,2
	int 21h
	
	mov dl, '0'
	int 21h
	
	;new line
	mov dl, 10
	mov ah, 2
	int 21h
	;carriage return
	mov dl, 13
	mov ah, 2
	int 21h
	
endgame1:
	
	mov dx,offset resetgame1 ; reset the game
	mov ah,9h
	int 21h
	
	mov ah, 0
	int 16h
	
	mov ah,0
	int 16h
	cmp ax,1c0dh
	je  ResetGame
	
	mov ax, 4c00h
	int 21h
END start
