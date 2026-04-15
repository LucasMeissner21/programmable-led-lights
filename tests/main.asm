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

	; START FRAME
	; STRUCTURE: 0000 0000 0000 0000 0000 0000 0000 0000
	ldi r20, $00 ; 0
	sts SSEG_SRAM, r20
	ldi r20, $00 ; 0
	sts SSEG_SRAM+1, r20
	ldi r20, $00 ; 0
	sts SSEG_SRAM+2, r20
	ldi r20, $00 ; 0
	sts SSEG_SRAM+3, r20

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; COLORS IN RAINBOW ORDER ( not including brightness control )
	; STRUCTURE: 111- ---- (brightness control) ---- ---- (blue) ---- ---- (green) ---- ---- (red)
	; RED
	ldi r20, $00 ; blue
	sts SSEG_SRAM+4, r20
	ldi r20, $00 ; green
	sts SSEG_SRAM+5, r20
	ldi r20, $FF ; red
	sts SSEG_SRAM+6, r20

	; ORANGE
	ldi r20, $00 ; blue
	sts SSEG_SRAM+7, r20
	ldi r20, $7D ; green
	sts SSEG_SRAM+8, r20
	ldi r20, $FF ; red
	sts SSEG_SRAM+9, r20


	; YELLOW
	ldi r20, $00 ; blue
	sts SSEG_SRAM+10, r20
	ldi r20, $FF ; green
	sts SSEG_SRAM+11, r20
	ldi r20, $FF ; red
	sts SSEG_SRAM+12, r20

	; SPRING GREEN
	ldi r20, $00 ; blue
	sts SSEG_SRAM+13, r20
	ldi r20, $FF ; green
	sts SSEG_SRAM+14, r20
	ldi r20, $7D ; red
	sts SSEG_SRAM+15, r20

	; GREEN
	ldi r20, $00 ; blue
	sts SSEG_SRAM+16, r20
	ldi r20, $FF ; green
	sts SSEG_SRAM+17, r20
	ldi r20, $00 ; red
	sts SSEG_SRAM+18, r20

	; TURQOISE
	ldi r20, $7D ; blue
	sts SSEG_SRAM+19, r20
	ldi r20, $FF ; green
	sts SSEG_SRAM+20, r20
	ldi r20, $00 ; red
	sts SSEG_SRAM+21, r20

	; CYAN
	ldi r20, $FF ; blue
	sts SSEG_SRAM+22, r20
	ldi r20, $FF ; green
	sts SSEG_SRAM+23, r20
	ldi r20, $00 ; red
	sts SSEG_SRAM+24, r20

	; OCEAN
	ldi r20, $FF ; blue
	sts SSEG_SRAM+25, r20
	ldi r20, $7D ; green
	sts SSEG_SRAM+26, r20
	ldi r20, $00 ; red
	sts SSEG_SRAM+27, r20

	; BLUE
	ldi r20, $FF ; blue
	sts SSEG_SRAM+28, r20
	ldi r20, $00 ; green
	sts SSEG_SRAM+29, r20
	ldi r20, $00 ; red
	sts SSEG_SRAM+30, r20

	; VIOLET
	ldi r20, $FF ; blue
	sts SSEG_SRAM+31, r20
	ldi r20, $00 ; green
	sts SSEG_SRAM+32, r20
	ldi r20, $7D ; red
	sts SSEG_SRAM+33, r20

	; MAGENTA
	ldi r20, $FF ; blue
	sts SSEG_SRAM+34, r20
	ldi r20, $00 ; green
	sts SSEG_SRAM+35, r20
	ldi r20, $FF ; red
	sts SSEG_SRAM+36, r20

	; RASPBERRY
	ldi r20, $7D ; blue
	sts SSEG_SRAM+37, r20
	ldi r20, $00 ; green
	sts SSEG_SRAM+38, r20
	ldi r20, $FF ; red
	sts SSEG_SRAM+39, r20

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; END FRAME
	; STRUCTURE: 1111 1111 1111 1111 1111 1111 1111 1111
	ldi r20, $FF ; 0
	sts SSEG_SRAM+40, r20
	ldi r20, $FF ; 0
	sts SSEG_SRAM+41, r20
	ldi r20, $FF ; 0
	sts SSEG_SRAM+42, r20
	ldi r20, $FF ; 0
	sts SSEG_SRAM+43, r20

	; BRIGHTNESS ( changeable )
	; STRUCTURE: 111- ---- (5-bit, 32-level brightness)
	ldi r20, $E8 ; Set brightness level to 8/31

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; TEST LIGHT SEQUENCE STORAGE

	ldi r20, 4
	sts SSEG_SRAM+44, r20
	ldi r20, 7
	sts SSEG_SRAM+45, r20
	ldi r20, 10
	sts SSEG_SRAM+46, r20
	ldi r20, 13
	sts SSEG_SRAM+47, r20
	ldi r20, 16
	sts SSEG_SRAM+48, r20
	ldi r20, 19
	sts SSEG_SRAM+49, r20
	ldi r20, 22
	sts SSEG_SRAM+50, r20
	ldi r20, 25
	sts SSEG_SRAM+51, r20
	ldi r20, 28
	sts SSEG_SRAM+52, r20
	ldi r20, 31
	sts SSEG_SRAM+53, r20
	ldi r20, 34
	sts SSEG_SRAM+54, r20
	ldi r20, 37
	sts SSEG_SRAM+55, r20

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


	ldi r18, $44 ; offset for X pointer
	sei ; Turn on global interrupts

	rjmp check

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check: ; Continuous loop to check for button inputs

	;sei ; Enables global interrupts on return from interrupt
	nop
	nop
	nop
	nop	
	nop
	rjmp check ; Loops


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
