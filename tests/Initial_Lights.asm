.Device ATmega328p

    ldi r21, $FF
	out DDRD, r21
    ldi r21, $00
    out PORTD, r21
    ldi r18, $03
    rjmp set_strip_start

set_strip_start:

    ; Sending start frame
    ldi r21, $20 ; counter
    ldi r19, $20 ; data/clock
    call run_frame ; sends start frame
    rjmp set_strip

set_strip:

    call red_light
    call red_light
    call green_light
    call green_light
    dec r18
    cpi r18, $00
    brne set_strip
    rjmp end_strip

end_strip:

    ; Sending end frame
    ldi r21, $20 ; counter
    ldi r19, $30 ; data/clock
    call run_frame ; sends end frame
    rjmp loop

red_light:

    ; Sending brightness control
    ldi r21, $03
    ldi r19, $30
    call run_frame
    ldi r21, $01
    ldi r19, $20
    call run_frame
    ldi r21, $01
    ldi r19, $30
    call run_frame
    ldi r21, $03
    ldi r19, $20
    call run_frame

    ; Sending data for light
    ldi r21, $08 ; counter
    ldi r19, $20 ; data/clock
    call run_frame ; sends blue off
    ldi r21, $08 ; counter
    ldi r19, $20 ; data/clock
    call run_frame ; sends green off
    ldi r21, $08 ; counter
    ldi r19, $30 ; data/clock
    call run_frame ; sends red on

    ret

green_light:

    ; Sending brightness control
    ldi r21, $03
    ldi r19, $30
    call run_frame
    ldi r21, $01
    ldi r19, $20
    call run_frame
    ldi r21, $01
    ldi r19, $30
    call run_frame
    ldi r21, $03
    ldi r19, $20
    call run_frame

    ; Sending data for light
    ldi r21, $08 ; counter
    ldi r19, $20 ; data/clock
    call run_frame ; sends blue off
    ldi r21, $08 ; counter
    ldi r19, $30 ; data/clock
    call run_frame ; sends green on
    ldi r21, $08 ; counter
    ldi r19, $20 ; data/clock
    call run_frame ; sends red off

    ret

loop:

    nop
    nop
    nop
    nop
    nop
    rjmp loop

run_frame:

    mov r20, r19
    out PORTD, r20
    ldi r20, $00
    out PORTD, r20
    dec r21
    cpi r21, $00
    brne run_frame
    ret



