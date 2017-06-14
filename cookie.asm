IDEAl
MODEL small
STACK 100h
DATASEG
	background db 'bac.bmp',0
	clicked db 'cli.bmp',0
	Header db 54 dup (0)
	Palette db 256*4 dup (0)
	ScrLine db 320 dup (0)
	
	cookies dw 0
		cookiesPerClick equ 1
	NumArr db 5 dup (0)
	string db 'Cookies:$'
	
	cursorText1 db '|Cursor:$'
	cursorText2 db '    |', 10, '|auto clicks once|',10, '|every 5 seconds |', 10, '|Price:$'
	cursor dw 0
	nextSecondToCursor db 0
		CursorSeconds equ 5
	cursorPrice dw 15
	
	priceText db '     |$'
	divider db 10, '------------------', 10, '$'
CODESEG

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


;this procedure prints to the screen a BMP file, doing all the things needed
;opening the file, reading header, reading palette, copying the palette, copying the BMP, and closing the file
;input: offset of file's name
;output: moving to graphics mode and chaning the screen to the given BMP file
proc PrintBMP
	push bp
	mov bp, sp
	push ax
	
	; Process BMP file
	mov ah, 3Dh
	xor al, al
	mov dx, [bp+4] ;file name
	int 21h
	push ax
	push offset Header
	push offset Palette
	call ReadHeaderPalette
	push offset Palette
	call CopyPal
	push ax
	call CopyBitmap
	mov bx, ax
	mov ah, 03Eh
	int 21h
	
	pop ax
	pop bp
	ret 2
endp PrintBMP

proc print_num
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	
	mov si, offset NumArr + 4
	mov ax, [bp+4] ;the number
convert_number:
	xor dx, dx
	mov bx, 10
	div bx
	mov [si], dl
	dec si
	cmp si, offset NumArr - 1
	jne convert_number

	mov si, offset NumArr
	mov bx, -1 ;signs that we havn't found the most significant non-zero digit yet
	xor cx, cx  ;signs how many digits are equal to zero
	mov ah, 2
printLoop:
	mov dl, [si]
	cmp dl, 0
	jne printDigit
	cmp bx, -1
	je emptyDigit
printDigit:
	xor bx, bx ;signs that most significant non-zero digit was found
	add dl, '0'
	int 21h
	inc si
	cmp si, offset NumArr + 5
	jne printLoop
	jmp done1
	
emptyDigit:
	cmp si, offset NumArr + 4
	je printDigit
	inc cx
	inc si
	cmp si, offset NumArr + 5
	jne printLoop
	jmp done1
	
done1:
	cmp cx, 0
	je done2
	mov ah, 2
	mov dl, ' '
emptyDigitLoop:
	int 21h
	loop emptyDigitLoop
done2:
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2
endp print_num

proc present_shop
	push ax
	push bx
	push dx
	
	mov ah, 2
	mov bh, 0
	xor dx, dx
	int 10h
	mov ah, 9
	mov dx, offset string
	int 21h
	push [cookies]
	call print_num
	mov ah, 2
	mov dl, ' '
	int 21h
	int 21h
	int 21h
	int 21h
	int 21h
	
	mov ah, 9
	mov dx, offset divider
	int 21h
	mov dx, offset cursorText1
	int 21h
	push [cursor]
	call print_num
	mov dx, offset cursorText2
	int 21h
	push [cursorPrice]
	call print_num
	mov dx, offset priceText
	int 21h
	mov dx, offset divider
	int 21h
	
	pop dx
	pop bx
	pop ax
	ret
endp present_shop
	
proc getCookies
	push ax
	push bx
	push cx
	push dx
	
	cmp [cursor], 0
	je noCursor
	mov ah, 2Ch
	int 21h
	cmp dh, [nextSecondToCursor]
	jne noCursor
	mov ax, [cursor]
	add [cookies], ax
	jnc notMax2
	mov [cookies], -1
notMax2:
	mov ah, 2Ch
	int 21h
	add dh, CursorSeconds
	cmp dh, 60
	jb setCursorNext
	sub dh, 60
setCursorNext:
	mov [nextSecondToCursor], dh
	
noCursor:
	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp getCookies

start:
	mov ax, @data
	mov ds, ax
	
	mov ax, 13h
	int 10h
	
	mov ax, 0
	int 33h
GoBackTo:
	xor si, si
	push offset background
	call PrintBMP
	call present_shop
	mov ax, 1
	int 33h
	
waitForClick:
	call getCookies
	call present_shop
	mov ax, 1
	int 33h
	mov ax, 3
	int 33h
	and bx, 1
	cmp bx, 1
	jne waitForClick
	
	cmp cx, 0174h
	jb waitForRelease
	cmp cx, 0244h
	ja waitForRelease
	cmp dx, 002Eh
	jb waitForRelease
	cmp dx, 009Ch
	ja waitForRelease
	
	mov si, -1 ;signges that the click was a cookie
	push offset clicked
	call PrintBMP
	add [cookies], cookiesPerClick
	jnc notMax1
	mov [cookies], -1
notMax1:
	call present_shop
waitForRelease:
	call getCookies
	call present_shop
	mov ax, 1
	int 33h
	mov ax, 3
	int 33h
	and bx, 1
	cmp bx, 1
	je waitForRelease
	cmp si, -1
	je GoBackTo
	;if here, click was for the shop
	cmp cx, 011Ch
	ja GoBackTo
	cmp dx, 000Bh
	jb GoBackTo
	cmp dx, 0037h
	jb CursorBuy
	jmp GoBackTo
	
CursorBuy:
	mov ax, [cursorPrice]
	cmp ax, [cookies]
	ja GoBackTo
	sub [cookies], ax
	inc [cursor]
	
	;calcs how much to add to the price according to the OG game
	mov ax, [cursorPrice]
	mov bl, 10
	div bl
	cmp ah, 0
	je noAddToResult
	inc al
	xor ah, ah
noAddToResult:
	add [cursorPrice], ax
	;finished calculating
	
	cmp [cursor], 1
	jne GoBackTo
	mov ah, 2Ch ;resets the time to start getting cookies for cursors
	int 21h
	add dh, CursorSeconds
	mov [nextSecondToCursor], dh
	cmp [nextSecondToCursor], 59
	jbe GoBackTo
	sub [nextSecondToCursor], 60
	jmp GoBackTo

exit:
	mov ax, 4c00h
	int 21h
END start