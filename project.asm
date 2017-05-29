;Name: Roy Zehavi
;Subject: "Unblock Me"
 
IDEAL
MODEL small
STACK 100h
DATASEG
level db 1
levelsCompleted db 0
randomButton db 0
exitButton db 0
victory db 0
dataVal db 0
dataAddress dw 0
isMoveable db 0
arrow dw 0
x dw 75
y dw 15
level1 dw 2,2,2,3,0,1,1,3,0,0,0,9,0,0,0,2,2,2,3,0,0,0,9,0,4,4,3,0,0,0,9,2,2,3,0,0,0,0,0,2,2,2,3,0,9,0,1,1,3,0,0,0,9,0,0,1,1,1,3,0,8
level2 dw 0,0,2,2,2,3,0,1,1,1,3,9,0,0,0,0,0,0,9,4,4,3,0,0,0,0,9,2,2,3,0,0,1,1,3,0,2,2,2,3,0,9,0,0,0,0,2,2,3,0,0,9,1,1,1,3,0,0,0,8
level3 dw 2,2,3,0,2,2,3,0,2,2,2,3,0,1,1,1,3,9,0,0,0,1,1,1,3,9,4,4,3,0,0,0,2,2,3,0,9,0,1,1,3,0,0,0,9,0,2,2,3,0,0,0,0,2,2,3,0,9,0,0,1,1,1,3,0,8
level4 dw 0,0,2,2,3,0,1,1,1,3,9,1,1,3,0,0,1,1,3,9,4,4,3,0,2,2,2,3,0,0,0,9,2,2,2,3,0,1,1,3,0,0,2,2,2,3,0,9,0,0,0,0,2,2,3,0,0,9,0,1,1,1,3,0,0,8
level5 dw 1,1,1,3,2,2,3,0,0,0,9,0,0,2,2,2,3,0,0,1,1,3,9,4,4,3,0,0,0,2,2,2,3,0,9,2,2,3,0,0,0,1,1,3,0,9,0,1,1,1,3,2,2,3,0,0,9,1,1,3,1,1,3,0,0,8
level6 dw 0,0,0,0,1,1,3,9,2,2,3,0,0,0,2,2,3,0,2,2,2,3,0,0,9,0,4,4,3,0,0,0,9,2,2,3,0,2,2,3,0,1,1,3,0,0,9,0,0,0,2,2,3,0,1,1,3,9,1,1,1,3,0,0,0,8
level7 dw 2,2,2,3,0,0,0,2,2,3,0,0,2,2,3,0,9,0,1,1,3,0,0,0,9,0,0,4,4,3,2,2,2,3,0,0,9,1,1,1,3,0,0,2,2,3,0,9,0,0,2,2,3,0,0,0,0,9,1,1,3,0,1,1,3,0,8
level8 dw 1,1,3,2,2,3,0,1,1,3,2,2,2,3,0,9,0,0,0,0,2,2,3,0,0,9,2,2,3,0,0,4,4,3,0,0,9,0,0,1,1,3,1,1,3,9,2,2,3,0,2,2,3,0,0,2,2,3,0,1,1,3,9,0,0,0,0,1,1,3,8
level9 dw 1,1,3,0,2,2,2,3,0,1,1,3,9,0,0,0,0,0,0,9,2,2,3,0,4,4,3,0,0,0,9,0,0,1,1,3,1,1,3,9,1,1,3,1,1,3,2,2,3,0,2,2,3,0,9,0,0,0,0,0,0,8
level10 dw 1,1,3,1,1,3,2,2,2,3,0,2,2,3,0,9,1,1,3,1,1,3,0,0,9,4,4,3,0,0,0,0,9,2,2,2,3,0,0,0,0,0,0,9,0,2,2,3,0,2,2,3,0,2,2,3,0,1,1,3,0,9,0,0,0,0,1,1,3,8
level11 dw 2,2,2,3,0,2,2,3,0,2,2,3,0,2,2,3,0,1,1,3,9,0,0,0,0,2,2,3,0,2,2,3,0,9,0,0,4,4,3,0,0,9,0,2,2,3,0,0,2,2,3,0,1,1,3,9,0,0,0,0,0,0,9,0,0,0,1,1,1,3,8
level12 dw 1,1,3,1,1,3,2,2,3,0,2,2,3,0,9,1,1,3,2,2,3,0,2,2,3,0,0,0,9,4,4,3,0,0,0,0,9,1,1,3,1,1,3,0,0,9,0,0,2,2,3,0,2,2,3,0,1,1,3,9,1,1,3,0,0,1,1,3,8
level13 dw 0,0,0,2,2,3,0,1,1,3,9,1,1,1,3,0,0,2,2,3,0,9,0,2,2,3,0,4,4,3,2,2,2,3,0,0,9,0,0,0,0,0,2,2,3,0,9,2,2,3,0,1,1,1,3,0,0,9,0,1,1,3,1,1,3,0,8
level14 dw 0,0,2,2,3,0,1,1,3,0,9,0,0,0,2,2,3,0,1,1,3,9,4,4,3,2,2,3,0,0,2,2,3,0,2,2,2,3,0,9,2,2,2,3,0,0,0,0,0,0,9,0,1,1,1,3,0,0,9,0,0,0,0,0,0,8
level15 dw 1,1,3,2,2,3,0,1,1,3,0,9,1,1,3,0,0,2,2,2,3,0,0,9,2,2,2,3,0,4,4,3,0,0,0,9,0,1,1,1,3,0,0,9,0,0,0,2,2,3,0,1,1,3,9,1,1,3,0,0,0,0,8
level16 dw 2,2,2,3,0,0,0,1,1,1,3,9,0,0,0,0,0,2,2,2,3,0,9,0,4,4,3,0,0,0,9,1,1,3,0,1,1,3,0,9,1,1,3,2,2,3,0,2,2,3,0,1,1,3,9,1,1,3,0,0,0,0,8

CODESEG

; printBorders
; Input: None
; Output: Borders and buttons are presented to the screen
; Description: This procedure prints the borders (black sides) and the buttons to the screen
proc printBorders
	push ax
	push bx
	push 10
	push 320
	push 0
	push 0
	push 0
	call printSquare
	push 10
	push 320
	push 0
	push 190
	push 0
	call printSquare
	push 200
	push 70
	push 0
	push 0
	push 0
	call printSquare
	push 200
	push 70
	push 0
	push 0
	push 250
	call printSquare
	push 15
	push 15
	push 4
	push 0
	push 0
	call printSquare;prints exit button
	push 30
	push 15
	push 1
	push 15
	push 0
	call printSquare;prints random button
	mov ax,2
drawCross1:;prints the cross on the exit button
	push 15
	push ax
	push ax
	call printDot
	add ax,1
	cmp ax,13
	jne drawCross1
	mov ax,12
	mov bx,2
drawCross2:	
	push 15
	push bx
	push ax
	call printDot
	sub ax,1
	add bx,1
	cmp bx,13
	jne drawCross2
	mov ax,4
drawQuestionMark1:;prints the question mark on the random button
	push 15
	push 22
	push ax
	call printDot
	add ax,1
	cmp ax,12
	jne drawQuestionMark1
	mov ax,22
drawQuestionMark2:
	push 15
	push ax
	push 11
	call printDot
	add ax,1
	cmp ax,28
	jne drawQuestionMark2
	mov ax,11
drawQuestionMark3:
	push 15
	push 28
	push ax
	call printDot
	sub ax,1
	cmp ax,6
	jne drawQuestionMark3
	mov ax,28
drawQuestionMark4:
	push 15
	push ax
	push 7
	call printDot
	add ax,1
	cmp ax,33
	jne drawQuestionMark4
	mov ax,11
	mov ax,35
drawQuestionMark5:
	push 15
	push ax
	push 7
	call printDot
	add ax,1
	cmp ax,37
	jne drawQuestionMark5
	mov ax,11	
	
	pop bx
	pop ax
	ret
	endp printBorders

; printBackground
; Input: None
; Output: Background and empty spots are presented to the screen
; Description: This procedure prints the background (blue and dark gray square), and prints the empty spots on the board.
proc printBackground
	push ax
	push bx
	push cx
	push dx
	push si
	push 190
	push 190
	push 1
	push 5
	push 65
	call printSquare;prints blue frame
	push 30
	push 6
	push 4
	push 70
	push 250
	call printSquare;prints the red finish line
	
	push 180
	push 180
	push 8
	push 10
	push 70
	call printSquare;prints the background(dark gray)
	mov ax,6
	mov cx,6
	mov dx,ax
	mov bx,15;y position
	mov si,75;x position
rowOfSquares:;prints empty spots on the board
	cmp dx,0
	je nextColSquares
	sub dx,1
	push 20
	push 20
	push 7
	push bx
	push si
	call printSquare
	add si,30
	jmp rowOfSquares
nextColSquares:
	add bx,30
	mov si,75
	mov dx,ax
	sub cx,1
	cmp cx,0
	jne rowOfSquares
endPrintBackground:
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	endp printBackground

; printDot
; Input:
; X offset
; Y offset
; Color value 
; Output: Prints a dot on the screen
; Description: Prints a dot in the given position and in the given color
proc printDot
	_x equ [bp+4]
	_y equ [bp+6]
	_color equ [bp+8]
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	;prints dot in the given color
	mov cx,_x
	mov dx,_y
	mov al,_color
	mov ah,0ch
	mov bh,0h
	int 10h
endPrintDot:
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
	endp printDot

; printSquare
; Input:
; X offset
; Y offset
; Color value
; Width of square value
; Length of square value
; Output: Prints a square to the screen.
; Description: Prints a square in the given width, length and color, which its top-left is in the given (X,Y)
proc printSquare
	_x equ [bp+4]
	_y equ [bp+6]
	_color equ [bp+8]
	_width equ [bp+10]
	_length equ [bp+12]
	push bp
	mov bp,sp
	push ax
	push cx
	push dx
	push si
	mov si,_width ;si- contains width
	mov cx,_length ;cx- contains length
	mov dx,si
	cmp cx,0
	je endPrintSquare
rowPrint:;prints row of dots
	cmp dx,0
	je nextCol
	mov ax,_color
	push ax
	mov ax,_y
	add ax,cx
	sub ax,1
	push ax
	mov ax,_x
	add ax,dx
	sub ax,1
	push ax
	call printDot
	sub dx,1
	jmp rowPrint
nextCol:;pass to the next line
	sub cx,1
	mov dx,si
	cmp cx,0
	jne rowPrint
endPrintSquare:
	pop si
	pop dx
	pop cx
	pop ax
	pop bp
	ret 10
	endp printSquare

; showBoard
; Input:
; Array (level) offset
; Output: The board is presented to the screen, including all the blocks
; Description: Reads the array from the beginning to the end, and analyzes the data inside of the array in order to print the board
proc showBoard
	_ptr equ [bp+4]
	push bp
	mov bp,sp
	push ax;data value
	push bx;data pointer
	push cx;width of block
	push dx;length of block
	push si;x position
	push di;y position
	mov bx,_ptr
	mov cx,0
	mov dx,0
	mov si,75
	mov di,15
	; call printBorders
	call printBackground
readLine:;reads the word in the memory and then goes to the suitable case
	mov ax,[bx]
	cmp ax,0
	je caseEmpty
	cmp ax,1
	je caseHorizontal
	cmp ax,2
	je caseVertical
	cmp ax,3
	je caseEndBlock
	jmp jumpTo1
caseEmpty:
	add si,30;increases X
	add bx,2;increases offset
	jmp readLine	
caseHorizontal:
	mov dx,20
	add cx,30;increases X
	add bx,2;increases offset
	jmp readLine
caseVertical:
	mov cx,20
	add dx,30;increases Y
	add bx,2;increases offset
	jmp readLine	
caseEndBlock:
	sub bx,2
	mov ax,[bx]
	add bx,4
	cmp ax,4
	je endOfRed
	cmp ax,1
	je endOfHorizontal
	cmp ax,2
	je endOfVertical
endOfHorizontal:
	push dx
	sub cx,10
	push cx
	add cx,10
	push 6
	push di
	push si
	call printSquare;prints the block horizontal
	add si,cx
	mov cx,0
	mov dx,0
	jmp readLine
endOfVertical:
	sub dx,10
	push dx
	add dx,10
	push cx
	push 6
	push di
	push si
	call printSquare;prints the block vertical
	mov cx,0
	mov dx,0
	jmp readLine
endOfRed:
	push dx
	sub cx,10
	push cx
	add cx,10
	push 4
	push di
	push si
	call printSquare;prints the red block horizontal
	add si,cx
	mov cx,0
	mov dx,0
	jmp readLine
caseRedBlock:
	mov dx,20
	add cx,30;increases X
	add bx,2;increases offset
	jmp readLine
jumpTo1:
	cmp ax,4
	je caseRedBlock
	cmp ax,8;end of level
	je endShowBoard
	cmp ax,9
	je caseNextLine	
caseNextLine:
	add di,30;increases Y
	add bx,2;increases offset
	mov si,75;sets X to the beginning of the line
	jmp readLine
endShowBoard:
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2
	endp showBoard
	
; mouseClick
; Input:
; X offset
; Y offset
; Output: X gets the X position where the user clicked at,
; Y gets the Y position where the user clicked at.
; Description: This procedure waits for a mouse click and then stores the coordinates in X and Y
proc mouseClick
	xPos equ [bp+4]
	yPos equ [bp+6]
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	;loop until mouse click
mouseLeft:
	mov ax,3h
	int 33h
	cmp bx,01h
	jne mouseLeft
	;loop until mouse released
mouseLeftReleased:
	mov ax,3h
	int 33h
	cmp bx,00h
	jne mouseLeftReleased
endMouseClick:
	; initializes the mouse
	mov ax,2h
	int 33h
	shr cx,1
	mov bx,xPos
	mov [bx],cx;moves the X of the mouse click to xPos
	mov bx,yPos
	mov [bx],dx;moves the Y of the mouse click to yPos
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
	endp mouseClick

; getXY
; Input:
; X offset
; Y offset
; exitButton offset
; randomButton offset
; Output: X gets the fixed X value, Y gets the fixed Y value, and the buttons gets 1 or 0 (1 if the user clicked on them)
; Description: This procedure gets a mouse click and its coordinates, and then fixes the X value in this formula (X = (((X+75)/30)*30)-75).
; Fixes the Y value in this formula (Y = (((Y+15)/30)*30)-15).
; (the dividing doesn’t consider the remainder).
proc getXY
	xPos equ [bp+4]
	yPos equ [bp+6]
	_exitButton equ [bp+8]
	_randomButton equ [bp+10]
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push yPos
	push xPos
	call mouseClick;gets a mouse click
	mov dx,0
	mov bx,xPos
	mov ax,[bx];ax contains x position
	add ax,75
	mov bx,30
	div bx
	mov dx,0
	mul bx
	sub ax,75
	mov bx,xPos
	mov [bx],ax
	mov bx,yPos
	mov ax,[bx];cx contains y position
	add ax,15
	mov bx,30
	mov dx,0
	div bx
	mov dx,0
	mul bx
	sub ax,15
	mov bx,yPos
	mov [bx],ax
	;checks for exit button
	cmp ax,0FFF1h
	jne notExitButton
	mov bx,xPos
	mov bx,[bx]
	cmp bx,0FFF1h
	jne notExitButton
	mov bx,_exitButton
	mov [byte ptr bx],1
	jmp endXY
notExitButton:
	;checks for random button
	mov bx,yPos
	mov ax,[bx]
	cmp ax,0Fh
	jne endXY
	mov bx,xPos
	mov bx,[bx]
	cmp bx,0FFF1h
	jne endXY
	mov bx,_randomButton
	mov [byte ptr bx],1
endXY:
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 8
	endp getXY

; findXY
; Input:
; Array (level) offset
; X offset
; Y offset
; dataValue offset
; dataAddress offset
; xStartingValue value
; yStartingValue value
; Output: dataValue gets the kind of block which is in the given position.
; dataAddress gets the offset of the block which is in the given position.
; Description: This procedure analyzes the given array in order to find what kind of block is there in a given position on the board.
; (the search is being started when x is set to xStartingValue and y is set to yStartingValue)
proc findXY
	_ptr equ [bp+4]
	xPos equ [bp+6]
	yPos equ [bp+8]
	dataValue equ [bp+10]
	address equ [bp+12]
	xVal equ [bp+14]
	yVal equ [bp+16]
	push bp
	mov bp,sp
	push ax;data value
	push bx;data pointer
	push cx;width of block
	push dx;length of block
	push si;x position
	push di;y position
	mov dx,0
	mov cx,0
	mov si,xVal
	mov di,yVal
	mov bx,dataValue
	mov [byte ptr bx],5
	mov bx,_ptr
readLine2:;searches until si==xPos and di==yPos
	mov ax,[bx]
	push bx
	mov bx,xPos
	cmp ax,3
	je continue
	cmp [bx],si
	jne continue
	mov bx,yPos
	cmp [bx],di
	jne continue
	pop bx
	mov si,address
	mov [si],bx;moves the offset of the block to dataAddress
	mov bx,dataValue	
	mov [byte ptr bx],al;moves the value of the block to dataValue
	je endFindXY2
continue:	
	pop bx
	cmp ax,0
	je caseEmpty2
	cmp ax,1
	je caseHorizontal2
	cmp ax,2
	je caseVertical2
	cmp ax,3
	je caseEndBlock2
	jmp jumpTo2
caseEmpty2:
	add si,30
	add bx,2
	jmp readLine2	
caseHorizontal2:
	add si,30
	add cx,30
	add bx,2
	jmp readLine2
caseVertical2:
	add di,30
	add dx,30
	add bx,2
	jmp readLine2	
caseEndBlock2:
	sub bx,2
	mov ax,[bx]
	add bx,4
	cmp ax,4
	je endOfRed2
	cmp ax,1
	je endOfHorizontal2
	cmp ax,2
	je endOfVertical2
endOfHorizontal2:
	mov cx,0
	jmp readLine2
endOfVertical2:
	sub di,dx
	mov dx,0
	jmp readLine2
endOfRed2:
	mov cx,0
	jmp readLine2
caseRedBlock2:
	add si,30
	add cx,30
	add bx,2
	jmp readLine2
jumpTo2:
	cmp ax,4
	je caseRedBlock2
	cmp ax,8
	je endFindXY2
	cmp ax,9
	je caseNextLine2
endFindXY2:
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 14
	endp findXY 
caseNextLine2:
	add di,30
	add bx,2
	mov si,75
	jmp readLine2

; waitForArrows
; Input:
; direction offset
; Output: direction gets the value of the arrow pressed
; Description: This procedure waits until the user pressed one of the arrows on the keyboard. Then it stores the scan code value in “direction”
proc waitForArrows
	value equ [bp+4]
	push bp
	mov bp,sp
	push ax
WaitForKey:
	; check if there is a new key in buffer
	in al, 64h
	cmp al, 10b
	je WaitForKey
	;checks for arrows
	in al, 60h
	cmp al, 48h
	je endWaitForArrows
	cmp al, 04Bh
	je endWaitForArrows
	cmp al, 04Dh
	je endWaitForArrows
	cmp al, 50h
	je endWaitForArrows
	; check if the key is same as already pressed
	cmp al,ah
	je WaitForKey
	; new key- store it
	mov ah,al
	jmp WaitForKey
endWaitForArrows:
	mov bx,value
	mov [bx],al;stores the scan code of the arrow pressed in "value"
	pop ax
	pop bp
	ret 2
	endp waitForArrows
	
; checkMove
; Input:
; Array (level) offset
; Arrow value
; X offset
; Y offset
; dataAddress offset
; dataValue offset
; isMoveable offset
; Output: Puts 1 into isMoveable if the given block (based on x,y and dataAddress) can move to the given direction.
; Else puts 0
; Description: Analyzes the given array to find the block which fits the (X,Y) position given, then checks if he can move to the given direction(if it is not blocked).
; puts 1 or 0 in isMoveable if he can move or not
proc checkMove
	arr equ [bp+4]
	direction equ [bp+6]
	xPos equ [bp+8]
	yPos equ [bp+10]
	address equ [bp+12]
	dataValue equ [bp+14]
	_isMoveable equ [bp+16]
	push bp
	mov bp,sp
	push ax;data value
	push bx;data pointer
	push cx;x position
	push dx;y position
	push si
	push di
	mov bx,_isMoveable
	mov [byte ptr bx],0
	mov bx,xPos
	mov cx,[bx]
	mov bx,yPos
	mov dx,[bx]
	mov bx,address
	mov bx,[bx]
	mov si,bx
	mov ax,[bx]
	mov di,direction
	cmp di,04Dh
	je rightArrow
	cmp di,04Bh
	je leftArrow
	cmp di,48h
	je upArrow
	cmp di,50h
	je downArrow
rightArrow:
	cmp ax,1;checks if the block can move horizontal
	je findRightmost
	cmp ax,4
	je findRightmost
	jmp endCheckMove
findRightmost:;finds the rightmost part of the given block
	add cx,30
	add bx,2
	cmp [word ptr bx],1
	je findRightmost
	cmp [word ptr bx],4
	je findRightmost
	
	sub bx,2
	sub cx,30
	cmp cx,225;checks if the block is in the right edge of the board
	je endCheckMove
	push 15
	push 75
	push address
	push dataValue
	push yPos
	push bx
	mov bx,xPos
	add cx,30
	mov [bx],cx
	sub cx,30
	pop bx
	push xPos
	push arr
	call findXY;finds what exists in right of the block (empty spot or another block)
	mov bx,xPos
	mov [bx],cx
	jmp isMoveableCheck
leftArrow:
	cmp ax,1
	je findLeftmost
	cmp ax,4
	je findLeftmost
	jmp endCheckMove
findLeftmost:;finds the leftmost part of the given block
	sub cx,30
	sub bx,2
	cmp [word ptr bx],1
	je findLeftmost	
	cmp [word ptr bx],4
	je findLeftmost
	
	add bx,2
	add cx,30
	cmp cx,75;checks if the block is in the left edge of the board
	je endCheckMove
	push 15
	push 75
	push address
	push dataValue
	push yPos
	push bx
	mov bx,xPos
	sub cx,30
	mov [bx],cx
	add cx,30
	pop bx
	push xPos
	push arr
	call findXY;finds what exists in left of the block (empty spot or another block)
	mov bx,xPos
	mov [bx],cx
	jmp isMoveableCheck
upArrow:
	mov di,dx
	cmp ax,2
	je findUpper
	jmp endCheckMove	
findUpper:;finds the upper part of the given block
	sub dx,30
	sub bx,2
	cmp [word ptr bx],2
	je findUpper
	
	add bx,2
	add dx,30
	cmp dx,15;checks if the block is in the top edge of the board
	je endCheckMove
	push 15
	push 75
	push address
	push dataValue
	push bx
	mov bx,yPos
	sub dx,30
	mov [bx],dx
	add dx,30
	pop bx
	push yPos
	push xPos
	push arr
	call findXY;finds what exists above the block (empty spot or another block)
	mov bx,yPos
	mov [bx],di
	jmp isMoveableCheck
downArrow:
	mov di,dx
	cmp ax,2
	je findLowest
	jmp endCheckMove	
findLowest:;finds the lowest part of the given block
	add dx,30
	add bx,2
	cmp [word ptr bx],2
	je findLowest
	
	sub bx,2
	sub dx,30
	cmp dx,165;checks if the block is in the bottom edge of the board
	je endCheckMove
	push 15
	push 75
	push address
	push dataValue
	push bx
	mov bx,yPos
	add dx,30
	mov [bx],dx
	sub dx,30
	pop bx
	push yPos
	push xPos
	push arr
	call findXY;finds what exists under the block (empty spot or another block)
	mov bx,yPos
	mov [bx],di
	jmp isMoveableCheck
isMoveableCheck:	
	mov bx,address
	mov bx,[bx]
	cmp [word ptr bx],0;checks if the block is able to move to the given direction
	jne endCheckMove
	mov bx,_isMoveable
	mov [byte ptr bx],1;moves 1 to isMoveable
	mov bx,address
	mov [bx],si
	jmp endCheckMove
endCheckMove:
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 14
	endp checkMove

; moveBlock
; Input: 
; Array (level) offset
; Arrow value
; X offset
; Y offset
; dataAddress offset
; dataValue offset
; Output: “Array” is being changed to represent the new board (after moving)
; Description: This procedure changes the data in “Array” to represent the board after moving. It uses X,Y and dataAddress in order to find the block in the array, then it deletes it from its current position and moves it to a new position in the array.	
proc moveBlock
	arr equ [bp+4]
	direction equ [bp+6]
	xPos equ [bp+8]
	yPos equ [bp+10]
	address equ [bp+12]
	dataValue equ [bp+14]
	push bp
	mov bp,sp
	push ax;data value
	push bx;data pointer
	push cx;x position
	push dx;y position
	push di
	mov bx,xPos
	mov cx,[bx]
	mov bx,yPos
	mov dx,[bx]
	mov bx,address
	mov bx,[bx]
	mov ax,[bx]
	mov di,direction
	mov si,bx
	cmp di,04Dh
	je rightArrowMove
	cmp di,04Bh
	je leftArrowMove
	cmp di,48h
	je upArrowMove
	cmp di,50h
	je downArrowMove
rightArrowMove:
findLeftmost1:
	sub bx,2
	cmp [word ptr bx],1
	je findLeftmost1
	cmp [word ptr bx],4
	je findLeftmost1
	add bx,2
	mov [word ptr bx],0;moves 0 to the leftmost part of the block
	mov bx,si
findRightmost1:
	add bx,2
	cmp [word ptr bx],3
	jne findRightmost1
	mov [word ptr bx],ax;moves 1 or 4 to the spot which is next to the rightmost part of the block;
	mov [word ptr bx+2],3;moves the end of the block (3)
	jmp endMoveBlock

leftArrowMove:
findRightmost2:
	add bx,2
	cmp [word ptr bx],1
	je findRightmost2
	cmp [word ptr bx],4
	je findRightmost2
	sub bx,2
	mov [word ptr bx],3
	mov [word ptr bx+2],0;moves 0 to the rightmost part of the block
	mov bx,si
findLeftmost2:
	sub bx,2
	cmp [word ptr bx],1
	je findLeftmost2
	cmp [word ptr bx],4
	je findLeftmost2
	mov [word ptr bx],ax;moves 1 or 4 to the spot which is before the leftmost part of the block;
	jmp endMoveBlock
upArrowMove:
findLowest1:;finds the lowest part of the block
	add bx,2
	add dx,30
	cmp [word ptr bx],2
	je findLowest1
	sub bx,2
	sub dx,30
	mov si,bx;si contains the offset of the lowest part of the block
findUpper1:;finds the upper part of the block
	sub bx,2
	sub dx,30
	cmp [word ptr bx],2
	je findUpper1
	add bx,2
	add dx,30
	
	push 15
	push 75
	push address
	push dataValue
	push bx
	mov bx,yPos
	sub dx,30
	mov [bx],dx
	add dx,30
	pop bx
	push yPos
	push xPos
	push arr
	call findXY;finds the address of the spot which is above the block
	mov bx,si
	mov si,address
	mov si,[si]
	add bx,2
moveUp:
	push si
	push bx
	call moveMemoryUnit;moves the block (2 and 3) to the position found
	cmp [word ptr bx],2
	je moveUp
	jmp endMoveBlock

downArrowMove:
findUpper2:;finds the upper part of the block
	sub bx,2
	sub dx,30
	cmp [word ptr bx],2
	je findUpper2
	add bx,2
	add dx,30
	mov si,bx;si contains the offset of the upper part of the block
	mov di,dx;
findLowest2:;finds the lowest part of the block
	add bx,2
	add dx,30
	cmp [word ptr bx],2
	je findLowest2
	sub bx,2
	sub dx,30
	
	push di
	push cx
	push address
	push dataValue
	push bx
	mov bx,yPos
	add di,30
	mov [bx],di
	sub di,30
	pop bx
	push yPos
	push xPos
	add bx,4
	push bx;array pointer
	sub bx,4
	call findXY;finds the address of the spot which is under the block
	mov bx,si
	mov si,address
	mov si,[si]
	sub si,2
moveDown:
	push si
	push bx
	call moveMemoryUnit;moves the block (2 and 3) to the position found
	cmp [word ptr bx],2
	je moveDown
	cmp [word ptr bx],3
	je moveDown
	jmp endMoveBlock	
endMoveBlock:
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 12
	endp moveBlock

; moveMemoryUnit
; Input:
; sourceAddress value
; destinationAddress value
; Output: Change in the memory. The source will move to the destination.
; Description: This procedure switches the source with the data which is next to him until it gets to the destination. (or before him).
proc moveMemoryUnit
	srcAddress equ [bp+4]
	desAddress equ [bp+6]
	push bp
	mov bp,sp
	push ax;value
	push bx;pointer
	push cx
	push dx;destinition
	push di
	push si
	mov bx,srcAddress
	mov ax,[bx]
	mov dx,desAddress
	cmp bx,si
	jb leftToRight
	cmp bx,si
	ja rightToLeft
leftToRight:
	add bx,2
	mov si,[bx]
	mov [bx-2],si
	mov [bx],ax
	cmp bx,dx
	jne leftToRight
	jmp endMoveMemoryUnit
rightToLeft:
	sub bx,2
	mov si,[bx]
	mov [bx+2],si
	mov [bx],ax
	cmp bx,dx
	jne rightToLeft
	jmp endMoveMemoryUnit	
endMoveMemoryUnit:
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
	endp moveMemoryUnit

; checkIfWin
; Input: 
; Array (level) offset
; isVictory offset
; X offset
; Y offset
; dataAddress offset
; dataValue offset
; Output: isVictory will get 1 if level completed and 0 if not
; Description: This procedure locates the red block in the array and if it is in near the exit (red line) it puts 1 in isVictory. Otherwise it puts 0
proc checkIfWin
	arr equ [bp+4]
	_victory equ [bp+6]
	xPos equ [bp+8]
	yPos equ [bp+10]
	address equ [bp+12]
	dataValue equ [bp+14]
	push bp
	mov bp,sp
	push bx
	mov bx,_victory
	mov [byte ptr bx],0
	mov bx,xPos
	mov [word ptr bx],225
	mov bx,yPos
	mov [word ptr bx],75
	push 15
	push 75
	push address
	push dataValue
	push yPos
	push xPos
	push arr
	call findXY;checks for the block which is in the end position (near the finish line)
	mov bx,dataValue
	cmp [byte ptr bx],4;checks if it is the red block
	jne endCheckIfWin
	mov bx,_victory
	mov [byte ptr bx],1;moves victory 1
endCheckIfWin:
	pop bx
	pop bp
	ret 12
	endp checkIfWin
	
	
start:
	mov ax,@data
	mov ds,ax
	; graphic mode
	mov ax,13h
	int 10h
	xor ax,ax;resets all the registers
	xor bx,bx
	xor cx,cx
	xor dx,dx
	xor si,si
	xor di,di
	xor bp,bp
	call printBorders;prints the borders and the buttons
gameLoop:
	cmp [levelsCompleted],16;checks if all levels completed
	je exit
	mov [randomButton],0;resets buttons values
	mov [victory],0
	;randomize number between 1-16
	mov ax, 40h
	mov es, ax
	mov ax, [es:6Ch]
	and al, 00001111b
	mov ch,0
	mov cl,al
	add cl,1
	xor ax,ax
	;moves the random number to "level"
	mov [level],cl
	;loads the selected level
	cmp [level],1
	je lvl1
	cmp [level],2
	je lvl2
	cmp [level],3
	je lvl3
	cmp [level],4
	je lvl4
	cmp [level],5
	je lvl5
	cmp [level],6
	je lvl6
	cmp [level],7
	je lvl7
	cmp [level],8
	je lvl8
	cmp [level],9
	je lvl9
	cmp [level],10
	je lvl10
	cmp [level],11
	je lvl11
	cmp [level],12
	je lvl12
	cmp [level],13
	je lvl13
	cmp [level],14
	je lvl14
	cmp [level],15
	je lvl15
	cmp [level],16
	je lvl16
lvl1:
	mov cx,offset level1
	jmp startLevel
lvl2:
	mov cx,offset level2
	jmp startLevel
lvl3:
	mov cx,offset level3
	jmp startLevel
lvl4:
	mov cx,offset level4
	jmp startLevel
lvl5:
	mov cx,offset level5
	jmp startLevel
lvl6:
	mov cx,offset level6
	jmp startLevel
lvl7:
	mov cx,offset level7
	jmp startLevel
lvl8:
	mov cx,offset level8
	jmp startLevel
lvl9:
	mov cx,offset level9
	jmp startLevel
lvl10:
	mov cx,offset level10
	jmp startLevel
lvl11:
	mov cx,offset level11
	jmp startLevel
lvl12:
	mov cx,offset level12
	jmp startLevel
lvl13:
	mov cx,offset level13
	jmp startLevel
lvl14:
	mov cx,offset level14
	jmp startLevel
lvl15:
	mov cx,offset level15
	jmp startLevel
lvl16:
	mov cx,offset level16
	jmp startLevel		
startLevel:
	push offset dataVal
	push offset dataAddress
	push offset y
	push offset x
	push offset victory
	push cx
	call checkIfWin
	cmp [victory],1;checks if the level is already completed
	je gameLoop
	push cx
	call showBoard;presents the board
	; initializes the mouse
	mov ax,1h
	int 33h
	push offset randomButton
	push offset exitButton
	push offset y
	push offset x
	call getXY;gets a mouse click and checks if a button pressed
	cmp [exitButton],1
	je exit
	cmp [randomButton],1
	je gameloop
	push 15
	push 75
	push offset dataAddress
	push offset dataVal
	push offset y
	push offset x
	push cx
	call findXY
	mov ah,0
	mov al,[byte ptr dataval]
	cmp ax,0;checks if a block is selected
	je startLevel
	cmp ax,5
	je startLevel
	cmp ax,9
	je startLevel
	cmp ax,8
	je startLevel
	push offset arrow
	call waitForArrows;waits until the user press an arrow
	push offset isMoveable
	push offset dataVal
	push offset dataAddress
	push offset y
	push offset x
	push [arrow]
	push cx
	call checkMove;checks if the block can move to the given direction
	cmp [byte ptr isMoveable],1
	jne startLevel
	push offset dataVal
	push offset dataAddress
	push offset y
	push offset x
	push [arrow]
	push cx
	call moveBlock;moves the block
	push offset dataVal
	push offset dataAddress
	push offset y
	push offset x
	push offset victory
	push cx
	call checkIfWin;checks if level completed
	cmp [victory],1
	jne startLevel
	mov [victory],0
	add [levelsCompleted],1
	jmp gameLoop
exit:
	mov ah,0
	mov al,2
	int 10h
	mov ax,3h
	int 10h
	mov ax,4c00h
	int 21h
END start

