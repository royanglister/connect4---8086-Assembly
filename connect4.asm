.286
.model small
.stack 100h
.data

; Vars and consts:
xtop = 90 ; Board sizes
ytop = 145
xbot = 390
ybot = 495
n50 = 50 ; Tile size

board db 0, 0, 0, 0, 0, 0, 0, 0 ; first column is not in use (userCol >= 1)
	  db 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0
	  db 0, 0, 0, 0, 0, 0, 0, 0

userCol db ?
colsHeights db 0, 6, 6, 6, 6, 6, 6, 6 ; First element (represents first column) is not in use


p1 equ 1
p2 equ 2
currPlayer db 1

horizontalCounter db 0
verticalCounter db 0
diagonalCounter db 0
diagonalHelpCounter dw 0

winMode db 0 ; 1 - player won, 0 - didn't win yet

turnMsg db 'Player turn: $'
instructionMsg db 10, 10, 13, 'Enter a column number (1 - 7):', 10, 13, '$'
colNumbering db 10, '                     1     2     3      4     5     6     7', 10, 13, '$' 

winningMsg1 db 10, 'Player ', '$'
winningMsg2 db ' won! ', 13, '$'
gameOverMsg db 10, 'Game over. See you next time :)', 13, '$'
drawMsg db 10, 10, 'Draw! Board is full - no winner this time :)', 13, '$'

; 0 = Black, 1 = Blue, 2 = Green, 3 = Aqua, 4 = Red, 5 = Purple, 6 = Yellow, 7 = White, 8 = Gray, 9 = Light Blue
p1Pic	db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004
		db 004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004,004

	
p2Pic	db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
		db 006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006,006
	
x dw ? ; Picture's position on the screen
y dw ? ; (x,y) = (top,left)
xb dw ? ; (xb,yb) = (bottom,right)
yb dw ?

; Size of picture 
xsize dw 20 ; xsize = width
ysize dw 20 ; ysize = height of the picture
side db 50

.code
START:
mov ax, @data
mov ds, ax
; Here your code starts

	init:
		; Switching to graphic mode
		mov ax, 12h
		int 10h
		
		call DrawTable ; Drawing initial board	
		call PrintInitMsgs
		call PrintColNumbering
		
	turn:	
		call PrintWhosTurnIsIt
		call SelectColumn 	
		; User selects column
		; Graphic array gets updated
		call UpdateBoardArr
		
		call CheckWin
	
		call SwitchPlayers
		jmp turn

; here your code ends
mov ah, 4ch
int 21h

;-------------------------------------------------------------
; in: (dx,cx), al - color
; out: pixel
DrawPixel:   
	pusha
	mov ah, 0ch  ; 0ch is the interrupt number
	mov bx, 0
	int 10h
	popa
ret

;-------------------------------------------------------------
; in: (xtop,ytop) - the point where the board starts
;	  (xbot,ybot) - the point where the board ends
;	  n50 - the gap between each line (tile size)
; out: drawing a table according to the sizes that are in the variables
DrawTable:
	pusha
	mov al, 0fh ; White
	mov cx, ytop ; horizontal (-) lines
	mov dx, xtop
	
	contdraw1:
		mov al, 0fh
		call DrawPixel
		inc cx ; Column
		cmp cx, ybot
		jb  contdraw1
		
		mov cx, ytop		
		add dx, n50	; Side
		cmp dx, xbot
		jbe contdraw1

    mov cx, ytop ; Vertical (|) lines
    mov dx, xtop
	
	contdraw2:
		call DrawPixel
		inc dx
		cmp dx, xbot
		jb  contdraw2
		
		mov dx, xtop
		add cx, n50	; Side ***
		cmp cx, ybot
		jbe contdraw2
	popa
ret	

;-------------------------------------------------------------
;in: (x,y) - pic position
;    ysize - pic's height
;    xsize - pic's width
;    si - pic's offset
DrawPic:       
	pusha
	mov dx, x         ; xb = x + ysize
	mov cx, y         ; yb = y + xsize
	mov xb, dx
	mov yb, cx
	mov bx, ysize
	add xb, bx
	mov bx, xsize
	add yb, bx
	
    cycle:
		mov al,[si]

    after:
        pusha
        call DrawPixel  ;in: (dx,cx), al - color; out: pixel
        popa
		
        inc si
        inc cx      ; Runs by column
        cmp cx, yb
        js cycle
        sub cx, xsize
        inc dx 			; Proceeds to next line
        cmp dx, xb
        js cycle	
	popa
ret

;-------------------------------------------------------------
; in: board, winMode
; out: winMode => 1 - Won, 0 - Didn't win
CheckWin:
	pusha
	
	call Checkhorizontal
	cmp [winMode], 1
	je game_over
	
	call CheckVertical
	cmp [winMode], 1
	je game_over
	
	call CheckDiagonalFirst
	cmp [winMode], 1
	je game_over
	
	call CheckDiagonalSecond
	cmp [winMode], 1
	je game_over
	
	popa
	ret
	
	game_over:
		call Endgame	
	popa
ret

;-------------------------------------------------------------
; in: the messages pointers
; out: printing initial messages
PrintInitMsgs:
	pusha
	lea dx, turnMsg
	mov ah, 09h
	int 21h
	
	lea dx, instructionMsg
	mov ah, 09h
	int 21h
	popa
ret

;-------------------------------------------------------------
; in: colNumbering
; out: prints the number of every column of the board
PrintColNumbering:
	pusha
	; Placing cursor in the right position
	mov dh, 24
	mov dl, 0
	mov ah, 2
	int 10h
	
	lea dx, colNumbering
	mov ah, 09h
	int 21h
	popa
ret

;-------------------------------------------------------------
; in: players' pics pointers, x, y, currPlayer
; out: printing who's turn is it by drawing the player's color
PrintWhosTurnIsIt:	
	pusha
	mov x, 4
	mov y, 100
	cmp [currPlayer], p1	
	jne p2_turn_msg
	
	p1_turn_msg: ; If it's p1's turn
		lea si, p1Pic
		call DrawPic
	popa
	ret
	
	p2_turn_msg: ; If it's p2's turn
		lea si, p2Pic
		call DrawPic
	popa
ret

;-------------------------------------------------------------
; The user selects a column number between 1 and 7
; in: none
; out: (x,y) to draw the player's picture
SelectColumn:
	pusha
	get_col_num:
		mov ah, 0     
		int 16h ; Reading char into al
		mov bl, al ; Storing input in bl
		
	; Checking whether the input is a number in range
	check_input:              
		cmp bl, '1' ; Comparing bl to the ASCII value of '1'
		jb get_col_num     
		
		cmp bl, '7' ; Comparing bl to the ASCII value of '7'
		ja get_col_num   
		
		; Now bl contains an ASCII value between '1' and '7'
		; Integer value can be acquired by subtracting from bl 30h	
		sub bl,30h
		mov [userCol], bl
		
		mov bh, 0
		cmp colsHeights[bx], 0 ; If column is already full
		je get_col_num
		
		push bx ; Assuring bx remained unchanged after the drawing of the player's pic 
		
		; Calculations to draw the player's pic in the right place
		mov ah, 0			; x = xtop + 50 * (colsHeights[bx] - 1)
		mov al, colsHeights[bx]
		dec al
		mul side
		add ax, xtop
		mov [x], ax
		add x, 15
		
		dec bx				; y = ytop + (userCol - 1) * 50
		mov ax, bx
		mul side
		add ax, ytop
		mov [y], ax
		add [y], 15
		
		pop bx
		dec colsHeights[bx]
		
		; Drawing the right pic according to the current player
		cmp [currPlayer], p1
		je draw_p1
		
		lea si, p2Pic	
		call DrawPic
		call CheckFullBoard
		
		popa
		ret
		
		draw_p1:
			lea si, p1Pic	
			call DrawPic
		call CheckFullBoard
	popa
ret

;-------------------------------------------------------------
; in: userCol, colsHeights, currPlayer, board
; out: updates the board's array
UpdateBoardArr:
	pusha
	mov cx, 8
	mov bh, 0
	mov bl, [userCol]
	mov si, 0
	mov dh, 0
	mov dl, 0
	
	locate_row:
		add dl, colsHeights[bx] ; bx contains userCol => colsHeights[userCol]
		loop locate_row
	; Now dl is pointing to the first index of the row (num_of_tiles_in_a_row * user_column_height)
	add dl, [userCol] ; The exact index on the board array ((num_of_tiles_in_a_row * user_column_height) + userCol)
	
	mov al, [currPlayer]
	mov si, dx
	mov board[si], al
	popa
ret

;-------------------------------------------------------------
; in: colsHeights, drawMsg
; out: checks if the board is full and prints that the game has ended with a draw.
CheckFullBoard:
	pusha
	mov cx, 8 ; colsHeight's array size
	mov si, offset colsHeights ; Moving si to the first element of the array
	
	; Checking if every column's height in the array is zero (full)
	check_board_full:
		mov al, [si] 
		cmp al, 0
		jne not_full
		inc si ; Moving to the next element in the array
		
		loop check_board_full
		jmp full
		
		not_full:
			popa
			ret
			
		full: ; Draw - no winner
			; Printing draw message
			lea dx, drawMsg
			mov ah, 09h
			int 21h
			
			; Terminating program
			mov ah, 4ch
			int 21h
	popa
ret

;-------------------------------------------------------------
; in: winMode, horizontalCounter, userCol, colsHeights, board, currPlayer
; out: checking if the current player has 4 horizontal adjacent tiles on the board 
Checkhorizontal:
	pusha
	mov [winMode], 0
	mov [horizontalCounter], 0
	mov si, 0
	mov cx, 8
	mov bh, 0
	mov bl, [userCol]
	mov si, 0
	mov dh, 0
	mov dl, 0
	
	calc_horizontal_starting_point:
		add dl, colsHeights[bx] ; bx contains userCol => colsHeights[userCol]
		loop calc_horizontal_starting_point
	;add dl, 7
	
	mov si, dx
	; Now si is pointing to the first index of the row
	
	mov cx, 8 ; Tiles in a row (including the first ghost column)
	check_horizontal:
		mov dl, board[si]
		cmp dl, [currPlayer]
		je	yes_horizontal ; If current player owns the tile
		jmp no_horizontal ; If neutral / owned by the other player
		
		yes_horizontal:
			inc [horizontalCounter]
			jmp continue_horizontal_check
			
		no_horizontal:
			mov [horizontalCounter], 0

		continue_horizontal_check:
			; If there are 4 or more horizontal adjacent tiles owned by the current player
			cmp [horizontalCounter], 4
			jae won_horizontal
			
			inc si ; Checking horizontal adjacent places in board array
			loop check_horizontal
		
		popa
		ret
		
	won_horizontal:
		mov [winMode], 1
	popa
ret

;-------------------------------------------------------------
; in: winMode, verticalCounter, userCol, colsHeights, board, currPlayer
; out: checking if the current player has 4 vertical adjacent tiles on the board 
CheckVertical:
	pusha
	mov [winMode], 0
	mov [verticalCounter], 0
	mov si, 0
	mov bh, 0
	mov bl, [userCol]
	mov dh, 0
	
	; Vertical starting point
	mov si, bx ; si = userCol
	;dec si ; Because index start from 0
	
	mov cx, 6 ; Tiles in a column
	check_vertical:
		mov dl, board[si]
		cmp dl, [currPlayer]
		je	yes_vertical ; If current player owns the tile
		jmp no_vertical ; If neutral / owned by the other player
		
		yes_vertical:
			inc [verticalCounter]
			jmp continue_vertical_check
			
		no_vertical:
			mov [verticalCounter], 0
		
		continue_vertical_check:
			; If there are 4 or more vertical adjacent tiles owned by the current player
			cmp [verticalCounter], 4
			jae won_vertical
			
			add si, 8 ; Checking vertical adjacent places in board array
			loop check_vertical
		
		popa
		ret
	
	won_vertical:
		mov [winMode], 1
	popa
ret	

;-------------------------------------------------------------
; in: winMode, diagonalCounter, userCol, colsHeights, board, currPlayer
; out: checking if the current player has 4 diagonal (top left to bottom right) adjacent tiles on the board 
CheckDiagonalFirst:
	pusha																		;     -1-2-3-4-5-6-7-
	first_first_check: ; middle -> up											;(1) | \ \ \ \ # # # |
		mov [winMode], 0 														;(2) | \ \ \ \ \ # # |
		mov [diagonalCounter], 0 												;(3) | \ \ \ \ \ \ # |
		mov si, 0 																;(4) | # \ \ \ \ \ \ |
		mov dh, 0 																;(5) | # # \ \ \ \ \ |
		mov [diagonalHelpCounter], 6 ; Number of tiles in a diagon				;(6) | # # # \ \ \ \ |					
		mov ax, 2 ; Starting tile 												;	  -1-2-3-4-5-6-7-
		
		start_first_first_check:
			mov si, ax ; pointing si to the current starting tile of the current diagon
			mov cx, [diagonalHelpCounter] ; Tiles in the current diagonal line 
			
			diagonal_first_first_check:
				mov dl, board[si]
				cmp dl, [currPlayer]
				je	yes_diagonal_first_first ; If current player owns the tile
				jmp no_diagonal_first_first ; If neutral / owned by the other player
				
				yes_diagonal_first_first:
					inc [diagonalCounter]
					jmp continue_diagonal_first_first_check
					
				no_diagonal_first_first:
					mov [diagonalCounter], 0
				
				continue_diagonal_first_first_check: 
					; If there are 4 or more diagonal adjacent tiles owned by the current player
					cmp [diagonalCounter], 4
					jae won_diagonal_first
					
					add si, 9 ; Checking diagonal adjacent places in board array
					loop diagonal_first_first_check
				
		inc ax ; Starting tile of next diagon
		dec [diagonalHelpCounter] ; Num of tiles in the next diagon
		cmp ax, 5 ; Tile on board where there are no 4-tile-diagonal left to check
		jne start_first_first_check ; Repeating 3 times for three upper diagons
			
	first_second_check: ; middle -> down															
		mov [diagonalCounter], 0
		mov si, 0
		mov dh, 0
		mov [diagonalHelpCounter], 6
		mov ax, 1 ; Starting tile
		
		start_first_second_check:
			mov si, ax ; pointing si to the current starting tile of the current diagon
			mov cx, [diagonalHelpCounter] ; Tiles in the current diagonal line	
			
			diagonal_first_second_check:	
				mov dl, board[si]
				cmp dl, [currPlayer]
				je	yes_diagonal_first_second ; If current player owns the tile
				jmp no_diagonal_first_second ; If neutral / owned by the other player
				
				yes_diagonal_first_second:
					inc [diagonalCounter]
					jmp continue_diagonal_first_second_check
					
				no_diagonal_first_second:
					mov [diagonalCounter], 0
				
				continue_diagonal_first_second_check: 
					; If there are 4 or more diagonal adjacent tiles owned by the current player
					cmp [diagonalCounter], 4
					jae won_diagonal_first
					
					add si, 9 ; Checking diagonal adjacent places in board array
					loop diagonal_first_second_check
					
		add ax, 8 ; Starting tile of next diagon
		dec [diagonalHelpCounter] ; Num of tiles in the next diagon
		cmp ax, 25 ; Tile on board where there are no 4-tile-diagonal left to check
		jne start_first_second_check ; Repeating 3 times for three lower diagons
	
	popa
	ret
	
	won_diagonal_first:
		mov [winMode], 1
	popa
ret

;-------------------------------------------------------------
; in: winMode, diagonalCounter, userCol, colsHeights, board, currPlayer
; out: checking if the current player has 4 diagonal (top right to bottom left) adjacent tiles on the board 
CheckDiagonalSecond:
	pusha																		;     -1-2-3-4-5-6-7-
	second_first_check: ; middle -> up											;(1) | # # # / / / / |
		mov [winMode], 0 														;(2) | # # / / / / / |
		mov [diagonalCounter], 0 												;(3) | # / / / / / / |
		mov si, 0 																;(4) | / / / / / / # |
		mov dh, 0 																;(5) | / / / / / # # |
		mov [diagonalHelpCounter], 6 ; Number of tiles in a diagon				;(6) | / / / / # # # |					
		mov ax, 6 ; Starting tile 												;	  -1-2-3-4-5-6-7-
		
		start_second_first_check:
			mov si, ax ; pointing si to the current starting tile of the current diagon
			mov cx, [diagonalHelpCounter] ; Tiles in the current diagonal line
			
			diagonal_second_first_check:
				mov dl, board[si]
				cmp dl, [currPlayer]
				je	yes_diagonal_second_first ; If current player owns the tile
				jmp no_diagonal_second_first ; If neutral / owned by the other player
				
				yes_diagonal_second_first:
					inc [diagonalCounter]
					jmp continue_diagonal_second_first_check
					
				no_diagonal_second_first:
					mov [diagonalCounter], 0
				
				continue_diagonal_second_first_check: 
					; If there are 4 or more diagonal adjacent tiles owned by the current player
					cmp [diagonalCounter], 4
					jae won_diagonal_second
					
					add si, 7 ; Checking diagonal adjacent places in board array
					loop diagonal_second_first_check
				
		dec ax ; Starting tile of next diagon
		dec [diagonalHelpCounter] ; Num of tiles in the next diagon
		cmp ax, 3 ; Tile on board where there are no 4-tile-diagonal left to check
		jne start_second_first_check ; Repeating 3 times for three upper diagons
	
	second_second_check: ; middle -> down															
		mov [diagonalCounter], 0
		mov si, 0
		mov dh, 0
		mov [diagonalHelpCounter], 6
		mov ax, 7 ; Starting tile
		
		start_second_second_check:
			mov si, ax ; pointing si to the current starting tile of the current diagon
			mov cx, [diagonalHelpCounter] ; Tiles in the current diagonal line	
			
			diagonal_second_second_check:	
				mov dl, board[si]
				cmp dl, [currPlayer]
				je	yes_diagonal_second_second ; If current player owns the tile
				jmp no_diagonal_second_second ; If neutral / owned by the other player
				
				yes_diagonal_second_second:
					inc [diagonalCounter]
					jmp continue_diagonal_second_second_check
					
				no_diagonal_second_second:
					mov [diagonalCounter], 0
				
				continue_diagonal_second_second_check: 
					; If there are 4 or more diagonal adjacent tiles owned by the current player
					cmp [diagonalCounter], 4
					jae won_diagonal_second
					
					add si, 7 ; Checking diagonal adjacent places in board array
					loop diagonal_second_second_check
					
		add ax, 8 ; Starting tile of next diagon
		dec [diagonalHelpCounter] ; Num of tiles in the next diagon
		cmp ax, 31 ; Tile on board where there are no 4-tile-diagonal left to check
		jne start_second_second_check ; Repeating 3 times for three lower diagons
	
	popa
	ret
	
	won_diagonal_second:
		mov [winMode], 1
	popa
ret
	
;-------------------------------------------------------------
; in: currPlayer - current player number
; out: Prints a winning message and ends the program
Endgame:
	pusha
	; Placing cursor in the right position
	mov dh, 26
	mov dl, 0
	mov ah, 2
	int 10h
	
	; 'Player '
	lea dx, winningMsg1
	mov ah, 09h
	int 21h
	
	; '1' / '2'
	add [currPlayer], 48 ; Getting the integer value of the character
	mov dl, currPlayer
	mov ah, 02h
	int 21h
	sub [currPlayer], 48
	
	; ' won! '
	lea dx, winningMsg2
	mov ah, 09h
	int 21h
	
	lea dx, gameOverMsg
	mov ah, 09h
	int 21h
	popa
	
	; Terminating program
	mov ah, 4ch
	int 21h
ret

;-------------------------------------------------------------
; in: currPlayer - current player number
; out: Switches the number of the active player
SwitchPlayers:
	pusha
	cmp [currPlayer], p1
	je switch_to_p2
	
	; If current player is p2
	mov [currPlayer], p1
	popa
	ret
	
	; else
	switch_to_p2:
		mov [currPlayer], p2
	popa
ret
	

end START
