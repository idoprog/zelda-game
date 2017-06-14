IDEAL
MODEL small
STACK 100h
DATASEG
	playerstart_y dw 73 
	playerend_y dw 122

	disk_x dw 160
	disk_y dw 100
	
	disk_vy dw 3
	disk_vx dw 5
	diskit_time db ?
	
	filename db 'fi1.bmp',0
	filename2 db 'fi2.bmp', 0
	Header db 54 dup (0)
	Palette db 256*4 dup (0)
	ScrLine db 320 dup (0)
	ErrorMsg db 'Error', 13, 10,'$'
	playerTurn db 0
CODESEG

proc printsqure
start_x equ [bp+12]
start_y equ [bp+10]
end_x equ [bp+8]
end_y equ [bp+6]
color equ [bp+4]
	push bp
	mov bp,sp 
	push cx ;y 
	push dx ;x
	
	mov cx, start_y
loop_y:
	mov dx, start_x
loop_x:
	push dx 
	push cx
	push color
	call printpixel
	inc dx
	cmp dx,end_x
	jne loop_x
	inc cx
	cmp cx,end_y
	jne loop_y
	
	
	pop dx
	pop cx
	pop bp
	ret 10
endp printsqure

proc printpixel
x equ [bp+8]
y equ [bp+6]
color equ [bp+4]
	push bp
	mov bp,sp
	push ax
	push cx
	push dx
	mov ah,0ch
	mov al, color
	mov cx, x
	mov dx, y
    int 10h
	
	pop dx
	pop cx
	pop ax
	pop bp
	ret 6
endp printpixel

proc printboard
    disk_x_offset equ [bp+14]
	disk_y_offset equ [bp+12]
	color_disk equ [bp+10]
	playerstart_y_offset equ [bp+8]
	playerend_y_offset equ [bp+6]
	playercolor equ [bp+4]
	

	push bp
	mov bp,sp
	push 0 
	push 0
	push 320
	push 200
    push 1
    call printsqure
	push 2 
	push 2
	push 318
	push 198
    push 0
    call printsqure
	push 0 
	push 2
	push 2
	push 198
    push 4
    call printsqure
	push playerstart_y_offset
	push playerend_y_offset
	push playercolor
	call printPlayer
	push disk_x_offset
	push disk_y_offset
	push color_disk
	call printdisk
	
	
	
	pop bp
	ret 12
endp printboard

proc printPlayer
	playerstart_y_offset equ [bp+8]
	playerend_y_offset equ [bp+6]
	color equ [bp+4]
	push bp
	mov bp, sp
	push bx
	push ax 
	push dx
	
	mov bx, playerstart_y_offset
	mov ax,[word ptr bx];ax=start_y
	mov bx, playerend_y_offset
	mov dx,[word ptr bx]; dx=end_y
	push 2
	push ax	
	push 7
	push dx	
	push color
	call printsqure
	
    pop dx	
    pop ax
    pop bx 
    pop bp 
	ret 6
endp printPlayer

proc printdisk

	x_disk_offset equ [bp+8]
	y_disk_offset equ [bp+6]
	color equ [bp+4]
	push bp
	mov bp, sp
	push bx
	push ax 
	push dx
	push si
	push cx
    mov bx,x_disk_offset
	mov ax, [word ptr bx];x
	mov bx,y_disk_offset
	mov dx, [word ptr bx];y
	sub dx,10
	sub ax,10
	mov bx,x_disk_offset
	mov si, [word ptr bx];x
	mov bx,y_disk_offset
	mov cx, [word ptr bx];y
	add cx,10
	add si,10
    	
	push ax
	push dx
	push si
	push cx	
	push color
	call printsqure
    pop cx
	pop si
    pop dx	
    pop ax
    pop bx 
    pop bp 
	ret 6
	endp printdisk
	
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

proc move_player
    direction equ [bp+8]
	playerstart_y_offset equ [bp+6]
	playerend_y_offset equ [bp+4]
	push bp
	mov bp,sp
	push bx
	mov bx,direction
	cmp bx,0
	je move_down
	push playerstart_y_offset
	push playerend_y_offset
	push 0
	call printPlayer
	mov bx,playerstart_y_offset
	dec [word ptr bx]
	mov bx,playerend_y_offset
	dec [word ptr bx] 
	push playerstart_y_offset
	push playerend_y_offset
	push 1
	call printPlayer
	jmp finish_move_player
	
move_down:
	push playerstart_y_offset
	push playerend_y_offset
	push 0
	call printPlayer
	mov bx,playerstart_y_offset
	inc [word ptr bx]
	mov bx,playerend_y_offset
	inc [word ptr bx] 
	push playerstart_y_offset
	push playerend_y_offset
	push 1
	call printPlayer	
			
finish_move_player:
	pop bx
	pop bp
	ret 6
endp move_player

proc check_for_press
	playerstart_y_offset equ [bp+6]
	playerend_y_offset equ [bp+4]
    push bp
	mov bp,sp
	push ax
	mov ah,1h
	int 16h
	;mov al,'w'
	jz finish_check_for_press
	cmp al,'w'
	je player_up
	cmp al,'s'
	je player_down
	jmp finish_check_for_press
	
player_up:
	push 1
	push playerstart_y_offset
	push playerend_y_offset
	call move_player
	
player_down:
	push 0
	push playerstart_y_offset
	push playerend_y_offset
	call move_player	
	
	
	
finish_check_for_press:
	mov ah,0ch
	mov al,0
	int 21h	
	pop ax	
    pop bp	
	ret 4
endp check_for_press
	
	













start:
	mov ax, @data
	mov ds, ax

	mov al,13h
	mov ah,0
	int 10h
	
	push offset playerstart_y
	push offset playerend_y
	push 1
	call printboard 
	

looping:
	push offset playerstart_y
	push offset playerend_y
	call check_for_press
	;mov ah, 2ch			; save current time milisec
	;int 21h
	;mov [diskit_time], dl
	;push offset disk_x
	
	

	jmp looping



	 
exit:
	; return to text mode
	mov ax, 03h
	int 10h
	
	mov ax, 4c00h
	int 21h

END start






