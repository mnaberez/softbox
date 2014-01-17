; inthndlr2.asm

; PURPOSE:      Interrupt handler. To be executed at each machine interrupt.
;                    count interrupts
;                    update clock
;                    blink cursor
;                    process repeated keys
;                    scan the keyboard
;                    update keyboard buffer

;include <k.incl>

; EXTERNAL REFERENCES
        xref curadr             ; obtains cursor line address
        xref scankybrd          ; scans the keyboard

        xref key                ; holds the key value found last interrupt
        xref delay              ; first delay (no. interrupts) for repeated key
        xref repeat             ; no. of interrupts between key repeats
        xref keyold             ; previous key pressed

; EXTERNAL DEFINITION
        xdef inthndlr

inthndlr equ *

; INCREMENT THE INTERRUPT COUNTER
        guess
            inc nints+2         ; increment the least significant byte
          quif ne
            inc nints+1         ; if it overflowed increment next byte
          quif ne
            inc nints           ; if it overflowed too increment next byte
        endguess

; UPDATE THE CLOCK
        guess
            inc jif             ; increment the jiffy counter
            lda jif             ; and compare with the
            cmp freq            ; number of jiffies per second
          quif ne
            lda #0              ; when the right number of jiffies
            sta jif             ; have been counted, reset the jiffy
            inc secs            ; counter, increment the seconds counter
            lda secs            ; and compare with the
            cmp #60             ; number of seconds in a minute
          quif ne
            lda #0              ; when 60 seconds are up
            sta secs            ; reset the seconds counter
            inc min             ; increment the minutes counter
            lda min             ; and compare with the
            cmp #60             ; number of minutes in an hour
          quif ne
            lda #0              ; when 60 minutes have elapsed
            sta min             ; reset the minutes counter
            inc hrs             ; increment the hours counter
            lda hrs             ; and compare with the
            cmp #24             ; number of hours in a day
          quif ne
            lda #0              ; when 24 hours have elapsed
            sta hrs             ; reset the hours counter to zero
        endguess

; BLINK THE CURSOR (if enabled)
        guess
            lda curflg          ; is the cursor enabled?
          quif ne
            dec crblink         ; if it is, decrement blink rate counter
          quif ne
            lda #20             ; when counter overflows, re-initialize it to
            sta crblink         ; 20 (no. of interrupts between cursor reverses)
            jsr curadr          ; find address of current line
            lda (scraddr),y     ; get the character at the cursor
            eor #$80            ; reverse it
            sta (scraddr),y     ; and put it back
        endguess

; REPEATING KEY PROCESSING
        guess
            lda key             ; most recent key value
            cmp keyold          ; compare with previous value
          beq L1
            sta keyold          ; if it is a new key value, preserve value
            lda #ndelay         ; in keyold and set initial delay before
            sta delay           ; repetition will start
          quif ne
L1          cmp #$FF            ; not a key pressing
          quif eq
            lda delay
          beq L2                ; if delay is still not zero
            dec delay           ; decrement it but don't repeat the key
          quif ne
L2          dec repeat          ; now decrement repeat until zero
          quif ne
            lda #nrepeat        ; reset repeat
            sta repeat
            lda #0              ; and set key to zero so that a new key
            sta key             ; will be set during the key board scanning
            lda #ncurs          ; and speed up the cursor blinking in
            sta crblink         ; harmony with the key repeats.
        endguess

; SCAN THE KEYBOARD
        guess
            jsr scankybrd       ; scan the keyboard but if no new key
          quif eq               ; then quit and do nothing
            ldx nchar           ;  if a new key (or repeated key) results
            cpx #keybufsize     ;  make sure there is room left in the
          quif eq               ;  keyboard buffer.  If there is,
            sta keybuf,x        ;  store the character in the buffer
            inc nchar           ;  and increment buffer character counter
        endguess

; RESTORE REGISTERS AND RETURN
        pla
        tay
        pla
        tax
        pla
        rti
