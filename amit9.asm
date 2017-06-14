IDEAL
MODEL small
STACK 100h
DATASEG
	player1_x dw 280
	player1_y dw 45
	player2_x dw 20
	player2_y dw 45
	disk_x dw 200
	disk_y dw 150
	disk_vy dw 3
	disk_vx dw 5
	diskit_time db ?
	
	filename db 'fi1.bmp',0
	filename2 db 'fi2.bmp', 0
	filename3 db 'fi3.bmp', 0
	filename4 db 'fi4.bmp', 0
	filename5 db 'fi5.bmp', 0
	Header db 54 dup (0)
	Palette db 256*4 dup (0)
	ScrLine db 320 dup (0)
	ErrorMsg db 'Error', 13, 10,'$'
	playerTurn db 0
CODESEG


proc handlePlayer
	push ax
	call handleDisk
	mov ah, 0
	int 16h
	Up equ 4800h	; up arrow
	Down equ 5000h	; down arrow
	Quit equ 011Bh	; escape
	
	; erase player
	push 0
	push [player1_x]
	push [player1_y]
	call printPlayer
	
	push 0
	push [player2_x]
	push [player2_y]
	call printPlayer
	
	; if escape, leave game
	cmp ax, Quit
	je exit
	
	call handleDisk
	cmp [playerTurn],0
	je player1
	jmp player2
	
player1:	
	; if up arrow, update the y
	cmp ax,Up
	je reduceY1
	; if down arrow, update the x
	cmp ax, Down
	je increaseY1
	
	
player2:
	cmp al, 's'
	je increaseY2
	cmp al, 'w'
	je reduceY2

	jmp endPress
	
reduceY1:
	dec [player1_y]
	cmp [player1_y],40		; check if reached upper margin of player's move
	jne endPress
	inc [player1_y]
	
	jmp endPress
increaseY1:
	inc [player1_y]
	cmp [player1_y],120		; check if reached lower margin of player's move
	jne endPress
	dec [player1_y]
	
	jmp endPress
	
reduceY2:
	dec [player2_y]
	cmp [player2_y],40		; check if reached upper margin of player's move
	jne endPress
	inc [player2_y]
	
	jmp endPress
increaseY2:
	inc [player2_y]
	cmp [player2_y],120		; check if reached lower margin of player's move
	jne endPress
	dec [player2_y]
	
	jmp endPress
	
endPress:
	call handleDisk
	xor [playerTurn], 1
	push 3
	push [player1_x]
	push [player1_y]
	call printPlayer
	
	push 2
	push [player2_x]
	push [player2_y]
	call printPlayer
	call handleDisk
	pop ax
	ret
endp handlePlayer

proc handleDisk
	push ax
	push dx
	push bx
	push cx
	
	mov ah, 2ch ;timer
	int 21h
	sub dl, [diskit_time] 
	cmp dl, 10					; if passsed 10 milisec, move disk
	jb cont
	
	; erase player
	push 0
	push [disk_x]
	push [disk_y]
	call printDisk
	
	push [disk_vy]		; push vy value
	push [disk_vx]		; push vx value
	push offset disk_x	; push x address
	push offset disk_y	; push y address
	call moveDisk
	
	mov ah, 2ch			; save current time milisec
	int 21h
	mov [diskit_time] , dl
	cmp [disk_x], 280
	je checkY1
	
	cmp [disk_x], 20
	je checkY2
	
	cmp [disk_x], 15
	jb updateVx
	cmp [disk_x], 295
 	ja updateVx
	
	cmp [disk_y], 4
	jb updateVy
	cmp [disk_y], 180
	ja updateVy
	
	
checkY1:
	mov bx, [player1_y]
	mov cx, 5
checkYloop:
	cmp [disk_y], bx
	je updateVx
	dec bx
	loop checkYloop
	jmp eraseplayer
	
checkY2:
	mov bx, [player2_y]
	mov cx, 5
checkY2loop:
	cmp [disk_y], bx
	je updateVx
	dec bx
	loop checkY2loop
	
eraseplayer:
	push 43
	push [disk_x]
	push [disk_y]
	call printDisk
	
	jmp cont
	
updateVx:
	neg [disk_vx]
	jmp cont
	
updateVy:
	neg [disk_vy]
	
	
cont:
	pop cx
	pop bx
	pop dx
	pop ax
	
	ret
endp handleDisk

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

;chnanges the colors from BGR (assemblu color format) to RGB (NMP file color format)
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

proc limit
	procvx equ [word ptr bp+4]
	procvy equ [word ptr bp+6]
	proc_x equ [word ptr bp+8]
	proc_y equ [word ptr bp+10]
	push bp
	mov bp,sp
	push bx
	push ax
	push cx
	
	mov ax, proc_x 
	cmp proc_x,5
    jbe neg_vx
	cmp proc_x,246
    jae neg_vx
	mov cx, proc_y 
	
	;cmp proc_y,200
	;jbe neg_vy
	;cmp proc_y,284
	;jae neg_vy
	jmp exit4
neg_vx:
	mov bx,procvx
    neg [word ptr bx]
	jmp exit4
neg_vy:
	mov bx,procvy
	neg [word ptr bx]
	jmp exit4
exit4:
	pop cx
	pop ax
	pop bx
	pop bp
	ret 8	
endp limit

proc moveDisk
; procedure moves the disk 
; it takes current X and adds the change in X (vx)
; it takes current Y and adds the change in Y (vy)
; procedure input values: 	diskVy: value of VY var
;							diskVx: value of VX var
;							newDiskX: address of diskX var 
;							newDisky: address of diskY var
	
	;push [disk_vy]		; push vy value
	;push [disk_vx]		; push vx value
	;push offset disk_x	; push x address
	;push offset disk_y	; push y address
	;call ssmoveDisk
	;push 10 
	;call wait1
	;inc  disk_x
	;inc disk_y
	;jmp try
		
	newDisky equ [bp+4]
	newDiskX equ [bp+6]
	diskVx equ [bp+8]
	diskVy equ [bp+10]
	push bp
	mov bp, sp
	
	push bx
	push di
	
	mov bx, newDiskX 	; current X var address
	mov di, [bx]		; current x value
	add di, diskVx		; adding vx value to x value, creating new x position
	mov [bx], di		; saving new x position to var
	
	mov bx, newDiskY 	; current Y var address
	mov di, [bx]		; current y value
	add di, diskVy	; adding vy value to y value, creating new y position
	mov [bx], di		; saving new y position to var
	
	
	pop di
	pop bx
	
	pop bp
	ret 8
endp moveDisk
	
proc printPlayer
	xpos equ [bp+6]
	ypos equ [bp+4]
	color equ [bp+8]
	push bp
	mov bp, sp
	
	;backup all register values
	push si
	push di
	push ax
	push bx
	push cx
	push dx
	
	mov ax, 0A000h
	mov es, ax
	
	mov si, 0 ;x
	mov di, 0 ; y
	
	mov cx, xpos
	mov dx, ypos
y_loop:
	mov si, 0
	mov cx, xpos
	inc di
	add dx, 1
	cmp di, 31
	je exit2
x_loop:
	push dx
	mov ax, 320
	mul dx
	add ax, cx
	mov bx, ax
	
	mov ax, color
	mov [byte ptr es:bx], al
	pop dx
	
	inc si
	add cx, 1
	cmp si, 5
	je y_loop
	jmp x_loop

exit2:
	pop dx
	pop cx
	pop bx
	pop ax
	pop di
	pop si
	pop bp
	ret 6
endp printPlayer

proc printDisk
; procedure prints a disk / ball
; it splits the ball into 5 parts, and prints different line size change in each
; procedure input values: 	color: for color
;							xDisk: start location X
;							yDisk: start location Y 
; the procedure uses a local variable lineLength to set the changing line length
	xDisk equ [bp+6]
	yDisk equ [bp+4]
	color equ [bp+8]
	lineLength equ [bp-2]
	push bp
	mov bp, sp
	sub sp, 2
	;backup all register values
	push si
	push di
	push ax
	push bx
	push cx
	push dx
	
	; point ES to screen pixels
	mov ax, 0A000h
	mov es, ax
	
	; the idea is to split the disk to 5 parts, and each one behaves differently
first_part:
; first part - 4 rows, the lineLength grows by 4 each line.
	mov ax, 4
	mov lineLength, ax	; changing lineLength
	mov si, 0 ;x
	mov di, 0 ; y
	
	mov cx, xDisk
	mov dx, yDisk
y_disk:
	mov si, lineLength
	mov ax, lineLength
	add ax, 4
	mov lineLength, ax	; changing lineLength
	mov cx, xDisk
	sub [word ptr bp+6],2
	inc di
	add dx, 1
	cmp di, 4		; counting 4 lines
	je second_part
x_disk:
	; location of the pixel is 320*y + x
	push dx
	mov ax, 320
	mul dx 			; y*320
	add ax, cx		; +x
	mov bx, ax
	
	mov ax, color
	mov [byte ptr es:bx], al
	pop dx
	
	add cx, 1
	dec si
	jz y_disk
	jmp x_disk

second_part:
; second part - 4 rows, the lineLength grows by 2 each line.
	xor di,di
	sub dx, 2
	mov ax, lineLength
	sub ax, 4
	mov lineLength, ax	; changing lineLength
	add [word ptr bp+6],2
y_disk2:
	mov si, lineLength
	mov ax, lineLength
	add ax, 2
	mov lineLength, ax	; changing lineLength
	mov cx, xDisk
	sub [word ptr bp+6],1
	inc di
	add dx, 2
	cmp di, 4		; counting 4 lines
	je third_part
x_disk2:
	; location of the pixel is 320*y + x
	push dx
	mov ax, 320 
	mul dx 			; y*320
	add ax, cx		; +x
	mov bx, ax
	
	mov ax, color
	mov [byte ptr es:bx], al
	add bx, 320
	mov [byte ptr es:bx], al
	pop dx
	
	add cx, 1
	dec si
	jz y_disk2
	jmp x_disk2
	
middle_part:
; middle part - 3 rows, of the lineLength max.
	xor di,di
	dec dx
	
y_disk_m:
	mov si, lineLength
	mov cx, xDisk
	inc di
	add dx, 1
	cmp di, 3	; counting 3 lines
	je third_part
x_disk_m:
	; location of the pixel is 320*y + x
	push dx
	mov ax, 320
	mul dx 			; y*320
	add ax, cx		; +x
	mov bx, ax
	
	mov ax, color
	mov [byte ptr es:bx], al
	
	pop dx

	dec si
	jz y_disk_m
	jmp x_disk_m
	
third_part:
; third part - 4 rows, the lineLength reduced by 2 each line.
	mov si, 0 ;x
	mov di, 0 ; y
	
	mov cx, xDisk
	mov dx, yDisk
	add dx, 8
	add [word ptr bp+6], 2
	mov ax, lineLength
	sub ax, 4
	mov lineLength, ax	; changing lineLength
y_disk3:
	mov si, lineLength
	mov ax, lineLength
	sub ax, 2
	mov lineLength, ax	; changing lineLength
	mov cx, xDisk
	add [word ptr bp+6], 1
	inc di
	add dx, 2
	cmp di, 4	; counting 4 lines
	je fourth_part
x_disk3:
	; location of the pixel is 320*y + x
	push dx
	mov ax, 320
	mul dx 			; y*320
	add ax, cx		; +x
	mov bx, ax
	
	mov ax, color
	mov [byte ptr es:bx], al
	add bx, 320
	mov [byte ptr es:bx], al
	pop dx
	
	add cx, 1
	dec si
	jz y_disk3
	jmp x_disk3
	
fourth_part:
; fourth part - 4 rows, the lineLength reduced by 4 each line.
	mov si, 0 ;x
	mov di, 0 ; y
	mov dx, yDisk
	add dx, 15
y_disk4:
	mov si, lineLength
	mov ax, lineLength
	sub ax, 4
	mov lineLength, ax	; changing lineLength
	mov cx, xDisk
	add [word ptr bp+6], 2
	inc di
	add dx, 1
	cmp di, 4		; counting 4 lines
	je exit_disk
x_disk4:
	; location of the pixel is 320*y + x
	push dx
	mov ax, 320
	mul dx 			; y*320
	add ax, cx		; +x
	mov bx, ax
	
	mov ax, color
	mov [byte ptr es:bx], al
	pop dx
	
	add cx, 1
	dec si
	jz y_disk4
	jmp x_disk4
	
exit_disk:
	pop dx
	pop cx
	pop bx
	pop ax
	pop di
	pop si
	add sp, 2
	pop bp
	ret 6
endp printDisk


start:
	mov ax, @data
	mov ds, ax
	
	push offset filename
	call printBMP
waitforkeyprees:	
	mov ah, 0;wait for key press
	int 16h
	cmp ax,  011Bh
	je exit
	cmp ax,  1C0Dh
	je game
	cmp ax, 3920h
	je print_rules
	jmp waitforkeyprees
	
	
print_rules:
		push offset filename2
		call printBMP
waitforkeyprees2:
		mov ah, 0;wait for key press
		int 16h
		cmp ax,  1C0Dh
		je game
		jmp waitforkeyprees2

game:	
	push offset filename3
	call PrintBMP

	mov ah, 2ch			; save current time milisec
	int 21h
	mov [diskit_time], dl
loopGame:

	call handleDisk
	mov ah, 1
	int 16h
	jz loopGame
	call handlePlayer
	call handleDisk
	mov ah, 1
	int 16h
	;push offset player1_y
	;call comp_player 
	jz loopGame
	call handlePlayer
	call handleDisk
	
	jmp loopGame
	
	
exit:
	; return to text mode
	mov ax, 03h
	int 10h
	
	mov ax, 4c00h
	int 21h

END start

