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
	rjmp timer_interrupt ; OC1A
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
	reti ; URXC
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

timer_interrupt:

	; Turns off timer compare bit
	sbi TIFR1, OCF1A
	; Checks if r18 flag is set high
	cpi r18, $FF
	; Branches to set high
	brne set_high

	; Sets flag low
	ldi r18, $00
	; Jumps to end_timer_interrupt
	rjmp end_timer_interrupt

set_high:

	; Sets flag high
	ldi r18, $FF
	; Jumps to end_timer_interrupt
	rjmp end_timer_interrupt

end_timer_interrupt:

	; Returns from interrupt
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
    .EQU ANIMATION_NUM_ON = $01FE ; number of lights on in animation
    .EQU ANIMATION_NUM_BGND = $01FD ; number of lights off in animation
    .EQU ANIMATION_COLOR_ON = $01FC ; color of light being animated
    .EQU ANIMATION_COLOR_BGND = $01FB ; color of background for animation
    .EQU COLOR_MEMORY = $0230 ; memory location for start of color data

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Sets X pointer to first value of color memory
	ldi XH, $02
	ldi XL, $00

	; Setting data direction of PORTD to all out
	ldi r21, $FF
	out DDRD, r21

	; Set up the stack pointer (for calling subroutines)
    ldi r21, $08 ; Set high part of stack pointer
    out SPH, r21
    ldi r21, $ff ; set low part of stack pointer
    out SPL, r21

	; Calls function to load first display or animation sequence
    call load_animation_data

	; Turning on timer compare mode to reset timer on compare and setting prescalar
    ldi r20, $05 | (1<<WGM12)
	sts TCCR1B, r20
	; Setting timer compare value (high)
	ldi r20, $04
	sts OCR1AH, r20
	; Setting timer compare value (low)
	ldi r20, $00
	sts OCR1AL, r20
	ldi r20, ( 1<<OCF1A ) ; enable timer compare interrupt
	sts TIFR1, r20
	ldi r20, ( 1<<OCIE1A ) ; setting timer compare interrupt mask
	sts TIMSK1, r20

	ldi r18, $30 ; Stores position of color input data
	ldi r17, $0C ; Stores number of inputs

	rjmp animation_loop_start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_animation_data:

    ; Pushing relevant registers
    push r16
    push r17
    push r21

	; Setting X pointer to bottom of color data memory
	ldi XH, $02
	ldi XL, $00

    ldi r16, $03 ; loading number of lights to have on throughout animation
    sts $01FE, r16 ; storing number of lights on in animation
    ldi r17, $0C ; loading total number of lights
    sub r17, r16 ; sets r17 to be the total number of background lights
    sts $01FD, r17 ; storing number of background lights in animation

    ldi r21, $01;$25  ; loading r21 with color to be animated
    sts $01FB, r21 ; storing color in memory
	ldi r18, $30 ; Loading offset for X pointer and color input data to the start of color input data
    call load_color_data ; Calling load_color_data for lights being animated

    mov r16, r17 ; copying background light number to r16
    ldi r21, $28 ; loading r21 with background color
    sts $01FC, r21 ; storing color in memory
	; Resetting X pointer to bottom of color data memory
	ldi XH, $02 
	ldi XL, $00
    call load_color_data ; Calling load_color_data for background of animation

	; Restoring values
    pop r21
    pop r17
    pop r16

	; Returning from subroutine call
	ret

load_color_data:

    ; Storing current X pointer in stack
	push XH
	push XL

	add XL, r21 ; Pulling color data from SRAM based on input
	ld r22, X+ ; Storing blue data in r22
	ld r23, X+ ; Storing green data in r23
	ld r24, X ; Storing red data in r24

	; Restoring X pointer
	pop XL
	pop XH

	; Storing current X pointer in stack
    push XH
	push XL

	add XL, r18 ; Moving X pointer to correct part of memory based on offset 'r18'
	st X+, r22 ; Storing blue data
	st X+, r23 ; Storing green data
	st X, r24 ; Storing red data

	; Restoring X pointer
	pop XL
	pop XH

    ; Updating offsets and counters
	inc r18 
	inc r18
	inc r18 ; Counter for SRAM storage of color data
    
	; Executing for loop
    dec r16
    cpi r16, $00
    brne load_color_data
	; Return from subroutine call
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end_loop:

	; Loops until interrupt is enabled (NOT USED IN THIS ASM FILE)
	nop
	nop
	nop
	nop
	nop
	rjmp end_loop

animation_loop_start:

	; Storing relevant register data to stack
	push r21
	push r20
	push r19
	push r18

    ldi r20, $0C ; Loading counter for animation_loop
	ldi r18, $00 ; Setting flag for timer interrupt low
    call animation_loop ; Calling subroutine to output each frame of animation
	call load_animation_data ; Calling subroutine to reset color input memory to the beginning of the animation

	; Restoring relevant register data
	pop r18
	pop r19
	pop r20
	pop r21

	; Loops
	rjmp animation_loop_start

animation_loop:

	; Loops until timer interrupt flag is set high
	ldi r18, $00
	sei ; Enabling global interrupts
	cpi r18, $FF
	brne animation_loop
	cli ; Disabling global interrupts

	; Setting X pointer to bottom of color memory
	ldi XH, $02
	ldi XL, $00

	; Storing r21 and r20 before calling start_frame to send the current frame of the animation to the lights
    push r21
    push r20
    call start_frame
	; Restoring r21 and r20
    pop r20
    pop r21

	; Setting X pointer to start of color input memory
    ldi XH, $02
    ldi XL, $30

	; Storing several relevant values
    push XH
    push XL
	push r21
	push r20
	push r19
	push r18
	push r17

    ldi r21, $0C ; Setting counter for loop for cycle_frames to effectively right shift each color's data
	ld r22, X+ ; Storing blue data for first light in r22
	ld r23, X+ ; Storing green data for first light in r23
	ld r24, X+ ; Storing red data for first light in r24 (X pointer now points to blue data for second light)
	call cycle_frames ; Calling subroutine to right shift each color's data in memory
	; Setting X pointer to bottom of color memory
	ldi XH, $02
	ldi XL, $00
	; If $01FC is loaded into r20, animation will act like a loading bar, if $01FB is loaded, one or multiple lights will cycle around lights
	lds r20, $01FC
	call load_background_cell ; Calling subroutine to set the rgb data for the first light after rest have been right shifted

	; Restoring several relevant values
	pop r17
	pop r18
	pop r19
	pop r20
	pop r21
    pop XL
    pop XH

	; Executing for loop
	dec r20
	cpi r20, $00
	brne animation_loop

	; Return from subroutine call
	ret

load_background_cell:

	; Storing X pointer
	push XH
	push XL

	add XL, r20 ; Setting X pointer to correct color to be loaded
	ld r22, X+ ; Loading blue data into r22
	ld r23, X+ ; Loading green data into r23
	ld r24, X ; Loading red data into r24

	; Restoring X pointer
	pop XL
	pop XH

	; Setting X pointer to start of color input memory
	adiw X, $30

	st X+, r22 ; Storing blue data for first light
	st X+, r23 ; Storing green data for first light
	st X+, r24 ; Storing red data for first light

	; Return from subroutine call
	ret

cycle_frames:

	ld r17, X+ ; Storing blue data for light in r17
	ld r18, X+ ; Storing green data for light in r18
	ld r19, X ; Storing red data for light in r19
	sbiw X, 2 ; Setting X pointer back to start of current light

	st X+, r22 ; Overwritting blue data with previous light blue data
	st X+, r23 ; Overwritting green data with previous light green data
	st X+, r24 ; Overwritting red data with previous light red data
	; X pointer is now pointing to next light in sequence

	mov r22, r17 ; Copying current light blue data into r22
	mov r23, r18 ; Copying current light green data into r23
	mov r24, r19 ; Copying current light red data into r24

	; Executing for loop
	dec r21
	cpi r21, $00
	brne cycle_frames

	; Return from subroutine call
	ret

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

	; Return from subroutine call
	ret

read_color:

	; Storing r21 counter data
	push r21

	inc r22 ; Increases number of lights that have been inputted thus far

	ldi r21, $08 ; Counter for brightness
	lds r19, $022F ; Brightness data
	call scan_bin ; Calls scan_bin to convert brightness data into output to lights

	ldi r21, $08 ; Counter for blue input
	ld r19, X+ ; Blue data loaded
	call scan_bin ; Calls scan_bin to convert blue color data into output to lights

	ldi r21, $08 ; Counter for green input
	ld r19, X+ ; Green data loaded
	call scan_bin ; Calls scan_bin to convert green color data into output to lights

	ldi r21, $08 ; Counter for red input
	ld r19, X+ ; Red data loaded
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

scan_bin:

	; Storing r21
	push r21
	ldi r21, $01 ; Setting counter to 1 when sending a low or high signal
	sbrs r19, 7 ; Checking if most significant bit is set
	call send_low ; Calling send_low if not set
	sbrc r19, 7 ; Checking if most significant bit is clear
	call send_high ; Calling send_high if set
	; Restoring r21
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