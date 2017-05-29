IDEAL
MODEL small
STACK 100h
DATASEG

	Avar dw 0
	Bvar dw 0
	Cvar dw 0
	derAvar dw 0
	EachNumberA db 6 dup (0)
	EachNumberB db 6 dup (0)
	EachNumberC db 6 dup (0)
	EachNumberDerA db 6 dup (0)
	message db 'y = a^x + bx + c$'
	messageA db 'y = $'
	messageB db '^X + $'
	messageC db 'X + $'
	x dw 0
	y dw 0
	color db 0fh
CODESEG

proc GetParameter
	push bp
	mov bp, sp
	xor cx, cx
	xor bx, bx
	
loop1:

	mov ah, 0
	int 16h
	cmp ax, 1c0dh
	je EndOfProc
	mov dl, al
	mov ah, 2
	int 21h
	sub al, '0'
	mov bl, al
	mov ax, 10
	mul cx
	mov cx, ax
	add cx, bx
	jmp loop1
	
EndOfProc:

	mov bx, [bp+4]
	mov [bx], cx
	pop bp
	ret 2
	
endp GetParameter

proc FromHexToDec

	push bp
	mov bp, sp	
	mov ax, [bp+6]
	mov si, 5
	
again:

	mov bl, 0ah
	div bl
	mov bx, [bp+4]
	mov [bx+si], ah
	xor ah, ah
	dec si
	cmp al,0
	jne again
	pop bp
	ret 4
	
endp FromHexToDec

proc NumberPrinter

	push bp
	mov bp, sp	
	xor bx, bx
	xor di, di
	mov bx, [bp+4]
	mov si, 0
	
CheckAgain:

	cmp [byte ptr bx+si], 0
	jne Print
	inc si
	jmp CheckAgain
	
Print:

	mov dl, [byte ptr bx+si]
	add dl, '0'
	mov ah, 2
	int 21h
	inc si
	cmp si, 5
	jbe Print
	pop bp
	ret 2
	
endp NumberPrinter

proc Derivative

	push bp
	mov bp, sp
	mov ax, [bp+6]
	mov bl, 2
	mul bl
	mov bx, [bp+4]
	mov [bx], ax
	pop bp
	ret 4
	
endp Derivative

proc GraphPrinter
	push bp
	mov bp, sp
	mov ax, 13h
	int 10h
yscale:
	mov [word ptr bp+8], 0
xscale:
	mov bh,0h
	mov cx,[bp+8]
	mov dx,[bp+6]
	mov al,[byte ptr bp+4]
	mov ah,0ch
	int 10h
	inc [word ptr bp+8]
	cmp [word ptr bp+8], 320
	jne xscale
	add [word ptr bp+6], 5
	cmp [word ptr bp+6], 200
	jne yscale
	mov [word ptr bp+8], 0
ySscale:
	mov [word ptr bp+6], 0
xSscale:
	mov bh,0h
	mov cx,[bp+8]
	mov dx,[bp+6]
	mov al,[byte ptr bp+4]
	mov ah,0ch
	int 10h
	inc [word ptr bp+6]
	cmp [word ptr bp+6], 200
	jne xSscale
	add [word ptr bp+8], 5
	cmp [word ptr bp+8], 320
	jne ySscale
Graph:
	mov [word ptr bp+8], 0
	mov [word ptr bp+6], 100
	mov [byte ptr bp+4], 4
Gxscale:
	mov bh,0h
	mov cx,[bp+8]
	mov dx,[bp+6]
	mov al,[byte ptr bp+4]
	mov ah,0ch
	int 10h
	inc [word ptr bp+8]
	cmp [word ptr bp+8], 320
	jne Gxscale
	mov [word ptr bp+8], 160
	mov [word ptr bp+6], 0
	mov [byte ptr bp+4], 4
Gyscale:
	mov bh,0h
	mov cx,[bp+8]
	mov dx,[bp+6]
	mov al,[byte ptr bp+4]
	mov ah,0ch
	int 10h
	inc [word ptr bp+6]
	cmp [word ptr bp+6], 200
	jne Gyscale
	pop bp
	ret 6
endp GraphPrinter
	push bp
	mov bp,sp
	
start:
	
	mov ax, @data
	mov ds, ax
	
;printing the function methode
	mov dx, offset message
	mov ah, 9h
	int 21h
	
;new line
	mov dl, 10
	mov ah, 2
	int 21h
ParameterA:

;carriage return
	mov dl, 13
	mov ah, 2
	int 21h
	
;ask from the user to give parametrs
	mov dl, 'a'
	mov ah, 2
	int 21h
	mov dl, '='
	mov ah, 2
	int 21h
	push offset Avar
	call GetParameter
	push [word ptr Avar]
	push offset EachNumberA
	call FromHexToDec
	
	mov ah, 0
	int 16h
	cmp ax, 011Bh
	je ParameterA
	
;new line
	mov dl, 10
	mov ah, 2
	int 21h
ParameterB:
;carriage return
	mov dl, 13
	mov ah, 2
	int 21h
	mov dl, 'b'
	mov ah, 2
	int 21h
	mov dl, '='
	mov ah, 2
	int 21h
	push offset Bvar
	call GetParameter
	push [word ptr Bvar]
	push offset EachNumberB
	call FromHexToDec
	
	mov ah, 0
	int 16h
	cmp ax, 011Bh
	je ParameterB
	
;new line
	mov dl, 10
	mov ah, 2
	int 21h
	
ParameterC:
;carriage return
	mov dl, 13
	mov ah, 2
	int 21h

	mov dl, 'c'
	mov ah, 2
	int 21h
	mov dl, '='
	mov ah, 2
	int 21h
	push offset Cvar
	call GetParameter
	push [word ptr Cvar]
	push offset EachNumberC
	call FromHexToDec
	
	mov ah, 0
	int 16h
	cmp ax, 011Bh
	je ParameterC
	
	;new line
	mov dl, 10
	mov ah, 2
	int 21h
	
;carriage return
	mov dl, 13
	mov ah, 2
	int 21h
	
;print the user function
	mov dx, offset messageA
	mov ah, 9h
	int 21h
	push offset EachNumberA
	call NumberPrinter
	mov dx, offset messageB
	mov ah, 9h
	int 21h
	push offset EachNumberB
	call NumberPrinter
	mov dx, offset messageC
	mov ah, 9h
	int 21h
	push offset EachNumberC
	call NumberPrinter
	
;new line
	mov dl, 10
	mov ah, 2
	int 21h
	
;carriage return
	mov dl, 13
	mov ah, 2
	int 21h
	jmp pass
	
startv2:
	jmp start
pass:
	
;print the derivative
	push [word ptr Avar]
	push offset derAvar
	call derivative
	mov dx, offset messageA
	mov ah, 9h
	int 21h
	push [word ptr derAvar]
	push offset EachNumberDerA
	call FromHexToDec
	push offset EachNumberDerA
	call NumberPrinter
	mov dx, offset messageC
	mov ah, 9h
	int 21h
	push offset EachNumberB
	call NumberPrinter
	
; Wait for key press
	mov ah,00h
	int 16h

;Drwing the graph
	push [x]
	push [y]
	push [word ptr color]
	call GraphPrinter

	; Wait for key press
	mov ah,00h
	int 16h
	
	; Return to text mode
	mov ah, 0
	mov al, 2
	int 10h
	
	mov ah, 0
	int 16h
	cmp ax, 1c0dh
	je startv2
		
	exit:
	mov ax, 4C00h
	int 21h
END start