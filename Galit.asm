IDEAl
MODEL small
STACK 100h
DATASEG
	file db '1.bmp',0
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

;waits a time asked for
;input: how many miliseconds to wait
;output: none
proc wait1
	push bp
	mov bp, sp
	cmp [word ptr bp+4], 0
	je end1
	push ax
	push bx
	push cx
	push dx
	mov bx, [bp+4]
setsec:
	mov ah, 2ch
	int 21h
	mov al, dl ;seconds
checkforsec:
	mov ah, 2ch
	int 21h
	cmp al, dl ;checks if the seconds changed
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
	ret 2
endp wait1

start:
	mov ax, @data
	mov ds, ax
	
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
	
	mov bl, 1

PrintLoop:
	push offset file
	call PrintBMP
	
	push 10
	call wait1
	
	cmp [byte ptr file], '6'
	je reset 
	jne go
	add [byte ptr file], bl
reset: 
	sub [byte ptr file],6
go:
	jmp PrintLoop
	
exit:
	mov ax, 4c00h
	int 21h
END start