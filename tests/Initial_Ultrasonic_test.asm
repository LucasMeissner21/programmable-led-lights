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

timer_interrupt:

	; Sets flag high on overflow
	sbi TIFR1, OCF1A
	ldi r21, $FF

	; TEMP TEST
	; Turns on light if light was off
	;SBIS PIND, 2
	;rjmp light_on

	; Turns off light if light was on
	;SBIC PIND, 2
	;rjmp light_off
	
	reti

Begin:

	ldi r20, $84  ; 7 out for trigger (8) , 6 in for echo, 2 out for LED (4)
	out DDRD, r20

	; Current arrangement enables interrupt on PORTD6 activation
	;ldi r20, ( 1<<PCIE2 ) ; Turning on pin change interrupt control register
	;sts PCICR, r20
	;ldi r20, ( 1<<PCINT22 ) ; Turning on mask for PORTD6 (echo port)
	;sts PCMSK2, r20

	; Flag for timer overflow interrupt, if on, led should NOT turn on

	ldi r20, $01 | (1<<WGM12)
	sts TCCR1B, r20
	ldi r20, $FF
	sts OCR1AH, r20
	ldi r20, $FF
	sts OCR1AL, r20
	ldi r20, ( 1<<OCF1A ) ; enable overflow interrupt
	sts TIFR1, r20
	ldi r20, ( 1<<OCIE1A ) ; enable timer overflow interrupt
	sts TIMSK1, r20

	sei

	call trigger
	rjmp outer_loop
	
trigger:

	; Turning on the trigger pulse
	cbi PIND, 7
	call delay
	call delay
	sbi PIND, 7
	call delayL
	cbi PIND, 7

	ret

delayL:

	; Calls delay_inner ( 1 microsecond delay ) 10 times
	call delay
	call delay
	call delay
	call delay
	call delay
	call delay
	call delay
	call delay
	call delay
	call delay
	ret

delay:

	; 1 microsecond delay
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ret

outer_loop:

	; Loops until echo starts
	SBIC PIND, 6
	rjmp inner_loop
	rjmp outer_loop

inner_loop:

	; Loops until echo ends
	SBIS PIND, 6
	rjmp US_Recieved
	rjmp inner_loop


US_Recieved:

	; Checks if timer overflow flag is set
	cpi r21, $FF
	breq reset_flag

	; Turns on light if light was off
	SBIS PIND, 2
	rjmp light_on

	; Turns off light if light was on
	SBIC PIND, 2
	rjmp light_off

	rjmp reset_flag

reset_flag:

	; Resets timer flag to 0 and calls trigger pulse
	ldi r21, $00
	call trigger
	rjmp outer_loop

light_on:

	ldi r20, $04
	out PORTD, r20
	rjmp reset_flag
	;reti

light_off:

	ldi r20, $00
	out PORTD, r20
	rjmp reset_flag
	;reti