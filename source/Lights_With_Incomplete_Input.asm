.Device ATmega328p
.cseg
.org 000000 ; Start at memory location 0
	; Interrupt Vectors
	rjmp Begin ; Reset vector
	nop
	reti ; INT0
	nop
	reti ; INT1
	nop
	reti ; PCI0
	reti
	nop
	reti ; PCI1
	nop
	reti ; PCI2
	nop
	reti ; WDT
	nop
	reti ; OC2A
	nop
	reti ; OC2B
	nop
	reti ; OVF2
	nop
	reti ; ICP1
	nop
	reti ; OC1A
	nop
	reti ; OC1B
	nop
	reti ; OVF1
	nop
	reti ; OC0A
	nop
	reti ; OC0B
	nop
	reti ; OVF0
	nop
	reti ; SPI
	nop
	rjmp light_input_interrupt; URXC
	nop
	reti ; UDRE
	nop
	reti ; UTXC
	nop
	reti ; ADCC
	nop
	reti ; ERDY
	nop
	reti ; ACI
	nop
	reti ; TWI
	nop
	reti ; SPMR
	nop 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


light_input_interrupt:

	; Stores r21 and r20 data
	push r21
	push r20
	lds r20, UDR0 ; Pulls input from USART

	; Jumps to check input
	rjmp check_input

	; Precautionary jump to end interrupt
	rjmp end_input_interrupt

check_input:

	; Updates r21 values for use in branch functions and checks if and what valid input was entered
	cpi r20, '/'
	breq start_early
	ldi r21, $25
	cpi r20, 'w' ; white input
	breq input_data
	ldi r21, $28
	cpi r20, 'n' ; blank input
	breq input_data
	ldi r21, $01
	cpi r20, 'r' ; red input
	breq input_data
	ldi r21, $04
	cpi r20, 'o' ; orange input
	breq input_data
	ldi r21, $07
	cpi r20, 'y' ; yellow input
	breq input_data
	ldi r21, $0A
	cpi r20, 's' ; spring green input
	breq input_data
	ldi r21, $0D
	cpi r20, 'g' ; green input
	breq input_data
	ldi r21, $10
	cpi r20, 't' ; turqoise input
	breq input_data
	ldi r21, $13
	cpi r20, 'c' ; cyan input
	breq input_data
	ldi r21, $16
	cpi r20, 'a' ; azure input
	breq input_data
	ldi r21, $19
	cpi r20, 'b' ; blue input
	breq input_data
	ldi r21, $1C
	cpi r20, 'v' ; violet input
	breq input_data
	ldi r21, $1F
	cpi r20, 'm' ; magenta input
	breq input_data
	ldi r21, $22
	cpi r20, 'p' ; pink input
	breq input_data
	ldi r21, $E8
	cpi r20, '1' ; 25% brightness
	breq update_brightness
	ldi r21, $F0
	cpi r20, '2' ; 50% brightness
	breq update_brightness
	ldi r21, $F8
	cpi r20, '3' ; 75% brightness
	breq update_brightness
	ldi r21, $FF
	cpi r20, '4' ; 100% brightness
	breq update_brightness

	; If no valid input entered, jumps to end_input_interrupt to return from interrupt
	rjmp end_input_interrupt

start_early:

	lds r20, $01FF ; Loads number of lights that have been inputted to USART into r20
	call start_frame ; Calls start_frame to update the light display

	; Resets current input count
	lds r20, $01FF
	ldi r20, $00
	sts $01FF, r20

	; Jumps to end_input_interrupt to return from the interrupt
	rjmp end_input_interrupt

input_data:

	; Stores X pointer
	push XH
	push XL

	add XL, r21 ; Pulling color data from SRAM based on input
	ld r22, X+ ; Storing blue data in r22
	ld r23, X+ ; Storing green data in r23
	ld r24, X ; Storing red data in r24

	; Restores X pointer
	pop XL
	pop XH
	
	; Stores X pointer
	push XH
	push XL

	add XL, r18 ; Updating X pointer with offset r18 to load into correct part of color input memory
	st X+, r22 ; Loads blue data
	st X+, r23 ; Loads green data
	st X, r24 ; Loads red data

	; Restores X pointer
	pop XL
	pop XH

	; Sends semi-proper display to USART
	call USART_send
	ldi r20, ','
	call USART_send
	ldi r20, ' '
	call USART_send

	; Increments current input count
	lds r20, $01FF
	inc r20
	sts $01FF, r20

	; Updating offsets and counters
	inc r18 
	inc r18
	inc r18 ; Offset for SRAM storage of color data
	dec r17 ; Counter for number of color inputs

	cpi r17, $00 ; Checking if all lights have an input
	brne end_input_interrupt ; If not, jumps to end_input_interrupt to return from interrupt

	; If all lights have been inputted, calls start_frame to update the display
	call start_frame

	; Resets current input count to 0
	lds r20, $01FF
	ldi r20, $00
	sts $01FF, r20

	; Jumps to end_input_interrupt to return from interrupt
	rjmp end_input_interrupt

update_brightness:

	; Stores brightness value in its location in SRAM
	sts SSEG_SRAM+47, r21

	; Sends semi-proper display
	call USART_send
	ldi r20, ','
	call USART_send
	ldi r20, ' '
	call USART_send

	; Jumps to end_input_interrupt to return from subroutine
	rjmp end_input_interrupt

end_input_interrupt:

	; pops r20 and r21 back from stack
	pop r20
	pop r21
	; Return from interrupt
	reti

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Begin:

	.EQU SSEG_SRAM = $0200 ; Starting memory location for color data

	; LOADING MEMORY FOR LED COLOR OUTPUT
	; RED
	ldi r20, $00 ; Blue
	sts SSEG_SRAM+1, r20
	ldi r20, $00 ; Green
	sts SSEG_SRAM+2, r20
	ldi r20, $FF ; Red
	sts SSEG_SRAM+3, r20

	; ORANGE
	ldi r20, $00 ; Blue
	sts SSEG_SRAM+4, r20
	ldi r20, $7D ; Green
	sts SSEG_SRAM+5, r20
	ldi r20, $FF ; Red
	sts SSEG_SRAM+6, r20

	; YELLOW
	ldi r20, $00 ; Blue
	sts SSEG_SRAM+7, r20
	ldi r20, $FF ; Green
	sts SSEG_SRAM+8, r20
	ldi r20, $FF ; Red
	sts SSEG_SRAM+9, r20

	; SPRING GREEN
	ldi r20, $00 ; Blue
	sts SSEG_SRAM+10, r20
	ldi r20, $FF ; Green
	sts SSEG_SRAM+11, r20
	ldi r20, $7D ; Red
	sts SSEG_SRAM+12, r20

	; GREEN
	ldi r20, $00 ; Blue
	sts SSEG_SRAM+13, r20
	ldi r20, $FF ; Green
	sts SSEG_SRAM+14, r20
	ldi r20, $00 ; Red
	sts SSEG_SRAM+15, r20

	; TURQOISE
	ldi r20, $7D ; Blue
	sts SSEG_SRAM+16, r20
	ldi r20, $FF ; Green
	sts SSEG_SRAM+17, r20
	ldi r20, $00 ; Red
	sts SSEG_SRAM+18, r20

	; CYAN
	ldi r20, $FF ; Blue
	sts SSEG_SRAM+19, r20
	ldi r20, $FF ; Green
	sts SSEG_SRAM+20, r20
	ldi r20, $00 ; Red
	sts SSEG_SRAM+21, r20

	; AZURE
	ldi r20, $FF ; Blue
	sts SSEG_SRAM+22, r20
	ldi r20, $7D ; Green
	sts SSEG_SRAM+23, r20
	ldi r20, $00 ; Red
	sts SSEG_SRAM+24, r20

	; BLUE
	ldi r20, $FF ; Blue
	sts SSEG_SRAM+25, r20
	ldi r20, $00 ; Green
	sts SSEG_SRAM+26, r20
	ldi r20, $00 ; Red
	sts SSEG_SRAM+27, r20

	; VIOLET
	ldi r20, $FF ; Blue
	sts SSEG_SRAM+28, r20
	ldi r20, $00 ; Green
	sts SSEG_SRAM+29, r20
	ldi r20, $7D ; Red
	sts SSEG_SRAM+30, r20

	; MAGENTA
	ldi r20, $FF ; Blue
	sts SSEG_SRAM+31, r20
	ldi r20, $00 ; Green
	sts SSEG_SRAM+32, r20
	ldi r20, $FF ; Red
	sts SSEG_SRAM+33, r20

	; PINK
	ldi r20, $7D ; Blue
	sts SSEG_SRAM+34, r20
	ldi r20, $00 ; Green
	sts SSEG_SRAM+35, r20
	ldi r20, $FF ; Red
	sts SSEG_SRAM+36, r20

	; WHITE
	ldi r20, $FF ; Blue
	sts SSEG_SRAM+37, r20
	ldi r20, $FF ; Green
	sts SSEG_SRAM+38, r20
	ldi r20, $FF ; Red
	sts SSEG_SRAM+39, r20

	; NONE
	ldi r20, $00 ; Blue
	sts SSEG_SRAM+40, r20
	ldi r20, $00 ; Green
	sts SSEG_SRAM+41, r20
	ldi r20, $00 ; Red
	sts SSEG_SRAM+42, r20

	; LOADING MEMORY FOR BRIGHTNESS DATA
	; 25%
	ldi r20, $E8
	sts SSEG_SRAM+43, r20

	; 50%
	ldi r20, $F0
	sts SSEG_SRAM+44, r20

	; 75%
	ldi r20, $F8
	sts SSEG_SRAM+45, r20

	; 100%
	ldi r20, $FF
	sts SSEG_SRAM+46, r20

	; STARTING BRIGHTNESS
	ldi r20, $E8
	sts SSEG_SRAM+47, r20

	; COLOR INPUT STORAGE STARTS SSEG_SRAM+48
	.EQU BRIGHTNESS = $022F ; memory location for brightness
	.EQU MAX_INPUTS = $0C ; number of lights, max number of inputs for individual lights
	.EQU NUM_INPUTS = $01FF ; number of lights that have been inputted to USART thus far

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Sets X pointer to first value of color memory
	ldi XH, $02
	ldi XL, $00

	; Setting data direction for PORTD to all out
	ldi r21, $FF
	out DDRD, r21

	; Set up the stack pointer (for calling subroutines)
    ldi r21, $08 ; Set high part of stack pointer
    out SPH, r21
    ldi r21, $ff ; set low part of stack pointer
    out SPL, r21

	; Setting up USART interrupt
	call USART_Setup

	; Setting current input count to 0
	ldi r20, $00
	sts $01FF, r20

	sei ; Turn on global interrupts
	ldi r18, $30 ; Stores position of color input data
	ldi r17, $0C ; Stores number of inputs
	rjmp end_loop ; Jumps to end_loop to loop until an interrupt happens

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end_loop:

	; Loops until interrupt is enabled
	nop
	nop
	nop
	nop
	nop
	rjmp end_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start_frame:

	; Sends start frame for light configuration
	ldi r21, $20 ; Counter for start_frame input
	call send_low ; Sends low $20 times to initialize light input
	
	; Storing X pointer
	push XH
	push XL

	adiw X, $30 ; X pointer offset of 48 to get to color data storage
	ldi r21, $0C ; Counter for number of lights to input
	ldi r22, $00 ; Counter for number of lights that have been inputted
	call read_color ; Calling read color to parse through color input data and send to lights

	; Restoring X pointer
	pop XL
	pop XH

	ldi r17, $0C ; Resetting counter for inputs
	ldi r18, $30 ; Resetting offset for X pointer to color inputs

	; Calls send_message to send 'successful output' message to USART
	call send_message

	; Return from subroutine call
	ret

read_color:

	; Storing r21 counter data
	push r21

	; Calls check_end to see if all inputted lights have been sent, if so resets to start of input memory
	call check_end
	inc r22 ; Increases number of lights that have been inputted thus far

	ldi r21, $08 ; Counter for brightness
	lds r19, $022F ; Brightness data
	call scan_bin ; Calls scan_bin to convert brightness data into output to lights

	ldi r21, $08 ; Counter for blue input
	ld r19, X+ ; Blue data
	call scan_bin ; Calls scan_bin to convert blue color data into output to lights

	ldi r21, $08 ; Counter for green input
	ld r19, X+ ; Green data
	call scan_bin ; Calls scan_bin to convert green color data into output to lights

	ldi r21, $08 ; Counter for red input
	ld r19, X+ ; Red data
	call scan_bin ; Calls scan_bin to convert red color data into output to lights

	; Restoring r21 counter data
	pop r21

	; Executing for loop
	dec r21 
	cpi r21, $00
	; Branches to end_frame to tell the lights all inputs have been made
	breq end_frame

	; Loops
	rjmp read_color

check_end:

	; Stores r20 data
	push r20
	lds r20, $01FF ; Loads number of total inputs to r20
	cp r22, r20 ; Compares number of current inputs to total number
	breq reset_X ; If equal, branches to reset_X to reset X pointer and counter
	rjmp end_check_end ; Otherwise jumps to end_check_end to return from subroutine

reset_X:

	; Resets current input counter to $00
	ldi r22, $00
	; Sets X pointer back to start of inputted color memory
	ldi XH, $02
	ldi XL, $30
	; Jumps to end_check_end to return from subroutine
	rjmp end_check_end

end_check_end:

	; Restores r20 data
	pop r20
	; Returns from subroutine
	ret

scan_bin:

	; Restoring r21 and r20
	push r21
	push r20
	ldi r21, $01 ; Setting counter to 1 when sending a low or high signal
	sbrs r19, 7 ; Checking if most significant bit is set
	call send_low ; Calling send_low if not set
	sbrc r19, 7 ; Checking if most significant bit is clear
	call send_high ; Calling send_high if set
	; Restoring r21 and r20
	pop r20
	pop r21
	; Shifts bits in r19 to check through each bit and translate it to uno board
	lsl r19

	; Executing for loop
	dec r21
	cpi r21, $00
	brne scan_bin

	; Return from subroutine call
	ret

send_high:

	; Turns on and off clock and data ports to send 1 to data line
	ldi r20, $30
    out PORTD, r20
    ldi r20, $00
    out PORTD, r20
	; Executing for loop
    dec r21
    cpi r21, $00
    brne send_high
	; Return from subroutine call
    ret

send_low:

	; Turns on and off clock and keeps data port off to send 0 to data line
	ldi r20, $20
    out PORTD, r20
    ldi r20, $00
    out PORTD, r20
    dec r21
	; Executing for loop
    cpi r21, $00
    brne send_low
	; Return from subroutine call
    ret

end_frame:

	ldi r21, $20 ; Setting counter for end frame
	call send_high ; Sends high signal $20 times to tell lights all inputs have been made
	; Return from subroutine call
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
USART_Setup:

	; Initializing USART setup
	ldi r21, $00
	ldi r20, $67
	sts UBRR0H, r21
	sts UBRR0L, r20

	ldi r20, (1<<RXEN0)|(1<<TXEN0)|(1<<RXCIE0)
	sts UCSR0B, r20

	ldi r20, (1<<USBS0)|(3<<UCSZ00)
	sts UCSR0C, r20

	ret

USART_send:

	; Sending character to USART
	lds r21, UCSR0A
	sbrs r21, UDRE0

	rjmp USART_send

	sts UDR0, r20
	ret

send_message:

	; Sends message once display is updated ( DISPLAY UPDATED SUCCESSFULLY! )
	ldi r20, ' '
	call USART_send
	ldi r20, 'D'
	call USART_send
	ldi r20, 'I'
	call USART_send
	ldi r20, 'S'
	call USART_send
	ldi r20, 'P'
	call USART_send
	ldi r20, 'L'
	call USART_send
	ldi r20, 'A'
	call USART_send
	ldi r20, 'Y'
	call USART_send
	ldi r20, ' '
	call USART_send
	ldi r20, 'U'
	call USART_send
	ldi r20, 'P'
	call USART_send
	ldi r20, 'D'
	call USART_send
	ldi r20, 'A'
	call USART_send
	ldi r20, 'T'
	call USART_send
	ldi r20, 'E'
	call USART_send
	ldi r20, 'D'
	call USART_send
	ldi r20, ' '
	call USART_send
	ldi r20, 'S'
	call USART_send
	ldi r20, 'U'
	call USART_send
	ldi r20, 'C'
	call USART_send
	ldi r20, 'C'
	call USART_send
	ldi r20, 'E'
	call USART_send
	ldi r20, 'S'
	call USART_send
	ldi r20, 'S'
	call USART_send
	ldi r20, 'F'
	call USART_send
	ldi r20, 'U'
	call USART_send
	ldi r20, 'L'
	call USART_send
	ldi r20, 'L'
	call USART_send
	ldi r20, 'Y'
	call USART_send
	ldi r20, '!'
	call USART_send
	ldi r20, ' '
	call USART_send
	; Return from subroutine call
	ret