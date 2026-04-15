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

button_interrupt:


Clear:


Route_Instruction:


send_USART_interrupt:


send_USART_return:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Begin:

	.EQU SSEG_SRAM = $0200 ; Starting memory location for progress bar

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

	; BRIGHTNESS
	; 25%
	ldi r20, $E8
	sts SSEG_SRAM+37, r20

	; 50%
	ldi r20, $F0
	sts SSEG_SRAM+38, r20

	; 75%
	ldi r20, $F8
	sts SSEG_SRAM+39, r20

	; 100%
	ldi r20, $FF
	sts SSEG_SRAM+40, r20

	; COLOR INPUT STORAGE STARTS SSEG_SRAM+41

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Sets X pointer to first value for PORTD
	ldi XH, $02
	ldi XL, $00

	; TO-DO
	ldi r21, $FF
	out DDRD, r21
	; Set up port outputs and data direction
	; Set up interrupts

	; Set up the stack pointer (for calling subroutines)
    ldi r21, $08 ; Set high part of stack pointer
    out SPH, r21
    ldi r21, $ff ; set low part of stack pointer
    out SPL, r21

	; USART Setup
	call USART_Setup
	;ldi r20, 'L'
	;call USART_send

	sei ; Turn on global interrupts
	rjmp start_frame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end_loop:

	nop
	nop
	nop
	nop
	nop
	rjmp end_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

input_data:

	push XH
	push XL

	ldi r21, $29
	add XL, r21
	; TO-DO: Have this input come from USART
	; Inputting Red
	ldi r19, $00
	sts X, r19
	inc XL
	ldi r19, $00
	sts X, r19
	inc XL
	ldi r19, $FF
	sts X, r19
	inc XL
	; Inputting Orange
	ldi r19, $00
	sts X, r19
	inc XL
	ldi r19, $7D
	sts X, r19
	inc XL
	ldi r19, $FF
	sts X, r19
	inc XL
	; Inputting Yellow
	ldi r19, $00
	sts X, r19
	inc XL
	ldi r19, $FF
	sts X, r19
	inc XL
	ldi r19, $FF
	sts X, r19
	inc XL
	; Inputting Spring Green
	ldi r19, $00
	sts X, r19
	inc XL
	ldi r19, $FF
	sts X, r19
	inc XL
	ldi r19, $7D
	sts X, r19
	inc XL
	; Inputting Green
	ldi r19, $00
	sts X, r19
	inc XL
	ldi r19, $FF
	sts X, r19
	inc XL
	ldi r19, $00
	sts X, r19
	inc XL
	; Inputting Turqoise
	ldi r19, $7D
	sts X, r19
	inc XL
	ldi r19, $FF
	sts X, r19
	inc XL
	ldi r19, $00
	sts X, r19
	inc XL
	; Inputting Cyan
	ldi r19, $FF
	sts X, r19
	inc XL
	ldi r19, $FF
	sts X, r19
	inc XL
	ldi r19, $00
	sts X, r19
	inc XL
	; Inputting Azure
	ldi r19, $FF
	sts X, r19
	inc XL
	ldi r19, $7D
	sts X, r19
	inc XL
	ldi r19, $00
	sts X, r19
	inc XL
	; Inputting Blue
	ldi r19, $FF
	sts X, r19
	inc XL
	ldi r19, $00
	sts X, r19
	inc XL
	ldi r19, $00
	sts X, r19
	inc XL
	; Inputting Violet
	ldi r19, $FF
	sts X, r19
	inc XL
	ldi r19, $00
	sts X, r19
	inc XL
	ldi r19, $7D
	sts X, r19
	inc XL
	; Inputting Magenta
	ldi r19, $FF
	sts X, r19
	inc XL
	ldi r19, $00
	sts X, r19
	inc XL
	ldi r19, $FF
	sts X, r19
	inc XL
	; Inputting Pink
	ldi r19, $7D
	sts X, r19
	inc XL
	ldi r19, $00
	sts X, r19
	inc XL
	ldi r19, $FF
	sts X, r19
	inc XL


	pop XH
	pop XL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start_frame:

	; Sends start frame for light configuration
	ldi r21, $20 ; Counter for start_frame input
	call send_low
	
	ldi r21, $0C ; Counter for number of lights to input
	call read_color
	rjmp end_loop

read_color:

	; Reads color input and sends to light
	; TO-DO: Implement pulling color from stored SRAM
	; TO-DO: Implement pulling brightness from stored SRAM
	push r21
	ldi r21, $08 ; Counter for brightness
	ldi r19, $F0 ; Brightness value at 50% ( to be pulled from SRAM later )
	call scan_bin
	ldi r21, $08 ; Counter for blue input
	ldi r19, $7D ; Color data for RED ( to be pulled from SRAM later )
	call scan_bin
	ldi r21, $08 ; Counter for green input
	ldi r19, $00 ; Color data for RED ( to be pulled from SRAM later )
	call scan_bin
	ldi r21, $08 ; Counter for red input
	ldi r19, $FF ; Color data for RED ( to be pulled from SRAM later )
	call scan_bin
	pop r21

	dec r21
	cpi r21, $00
	breq end_frame

	rjmp read_color

scan_bin:

	; Reads brightness input and sends to light
	push r21
	ldi r21, $01
	sbrs r19, 7
	call send_low
	sbrc r19, 7
	call send_high
	pop r21
	lsl r19

	dec r21
	cpi r21, $00
	brne scan_bin

	ret

send_high:

	; Turns on and off clock and data ports to send 1 to data line
	ldi r20, $30
    out PORTD, r20
    ldi r20, $00
    out PORTD, r20
    dec r21
    cpi r21, $00
    brne send_high
    ret

send_low:

	; Turns on and off clock and keeps data port off to send 0 to data line
	ldi r20, $20
    out PORTD, r20
    ldi r20, $00
    out PORTD, r20
    dec r21
    cpi r21, $00
    brne send_low
    ret

end_frame:

	; Sends end frame for light configuration
	ldi r21, $20 ; counter
	call send_high
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
