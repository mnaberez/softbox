;TIME.COM
;  Read or set the time on the CBM computer clock
;
;Usage:
;  "TIME"           Read the clock
;  "TIME 12:34:56"  Set the clock
;

warm:       equ  0000h  ;Warm start entry point
bdos:       equ  0005h  ;BDOS entry point
args:       equ  0080h  ;Command line arguments passed from CCP
gettime:    equ 0f072h  ;BIOS Read the CBM clocks (both RTC and jiffies)
settime:    equ 0f06fh  ;BIOS Set the time on the CBM real time clock

cread:      equ 01h     ;Console Input
cwrite:     equ 02h     ;Console Output
cwritestr:  equ 09h     ;Output String

ctrl_c:     equ 03h     ;Control-C

    org 0100h           ;CP/M TPA

    ld hl,args          ;HL = command line arguments from CCP: first byte is
                        ;       number of chars, followed by the chars
    ld c,(hl)           ;C = number of chars

                        ;Check if args contain a new time to set:
    call get_dec        ;  A = hours
    jp nc,time_input    ;  If no error, jump to set time.

time_output:
;Write the current time to the console and exit.
;
    ld de,time_is       ;DE = address of "Time is" string
    ld c,cwritestr      ;Output String
    call bdos           ;BDOS System Call

    call gettime        ;Read the CBM clocks (both RTC and jiffies):
                        ;  Real Time Clock:
                        ;    H = Hours, L = Minutes, D = Seconds
                        ;    E = Jiffies (counts up to 50 or 60)
                        ;  Jiffy Clock:
                        ;    A = Jiffy0 (MSB), B = Jiffy1, C = Jiffy2 (LSB)

                        ;Write the hour to console out:
    ld a,h              ;  A = Hours
    call put_dec        ;  Print A as a decimal number

                        ;Write a colon after the hour:
    push hl             ;  Push hours (H) and minutes (L) onto stack
    push de             ;  Push seconds (D) and jiffies (E) onto stack
    ld e,':'            ;  E = colon character
    ld c,cwrite         ;  Console Output
    call bdos           ;  BDOS System Call
    pop de              ;  Pop seconds and jiffies off stack
    pop hl              ;  Pop hours and minutes off stack

                        ;Write the minute to console out:
    ld a,l              ;  A = Minutes
    call put_dec        ;  Print A as a decimal number

                        ;Write a colon after the minute:
    push de             ;  Push seconds (D) and jiffies (E) onto stack
    ld e,':'            ;  E = colon character
    ld c,cwrite         ;  Console Output
    call bdos           ;  BDOS System Call
    pop hl              ;  XXX This is a bug.  It should be "pop de".  The
                        ;      intention was to preserve DE during the BDOS
                        ;      call so that D can be used by the next line.
                        ;      However, it turns out that the BDOS call does
                        ;      not destroy D, so this code works anyway.

                        ;Write the second to console out:
    ld a,d              ;  A = Seconds
    jp put_dec          ;  Jump out print A as a decimal number,
                        ;    it will return to CP/M.

time_input:
;Get a new time from the user and set the clock.
;
                        ;Get hours:
    ld d,a              ;  D = hours (already parsed)

                        ;Get minutes:
    call get_dec        ;  Parse minutes
    jp c,bad_syntax     ;  Abort if parse error
    ld e,a              ;  E = minutes

    push de             ;Push hours and minutes onto stack

                        ;Get seconds:
    call get_dec        ;  Parse seconds
    jp c,bad_syntax     ;  Abort if parse error
    ld d,a              ;  D = seconds

    push de             ;Push seconds onto stack

                        ;Print "Hit key to start clock":
    ld de,hit_key       ;  DE = address of "hit key" string
    ld c,cwritestr      ;  Output String
    call bdos           ;  BDOS System Call

                        ;Wait for the key:
    ld c,cread          ;  Console Input
    call bdos           ;  BDOS System Call
    cp ctrl_c           ;  Control-C pressed?
    jp z,warm           ;    Yes: jump to warm start

                        ;Pop time off stack:
    pop de              ;  D=seconds, E=jiffies
    pop hl              ;  H=hours, L=minutes

    jp settime          ;Jump out to set time on the CBM computer,
                        ;  it will return to CP/M.

bad_syntax:
    ld de,syntax_err    ;DE = address of "Syntax error" string
    ld c,cwritestr      ;Output String
    call bdos           ;BDOS System Call
    jp warm             ;Warm start

get_dec:
;Get a one or two character decimal number from the args buffer,
;convert it to a binary number, and return it in A.
;
;If the current args char at HL is not a digit, HL will be advanced
;until a digit is reached.
;
;On exit, HL will be pointing at the last char of the decimal number
;in the args buffer.
;
;Returns carry flag set on error.
;
                        ;Get first char from args:
    inc hl              ;  Increment HL to point to next char in args
    ld a,(hl)           ;  A = char from args at HL
    dec c               ;  Decrement C (number of chars remaining in args)
    scf                 ;  Set carry flag to indicate error status
    ret m               ;  Return if sign flag is set (decremented past 0)

                        ;Convert first char from ASCII to binary number:
    sub 30h             ;  Subtract 30h to convert it (ASCII "0" = 30h)
    jp c,get_dec        ;  Jump if carry is set, indicating A < 0
    cp 0ah              ;  Compare to check upper bounds
    jp nc,get_dec       ;  Jump if A >= 0Ah (ASCII "9" = 39h)
    ld b,a              ;  Save the valid binary number in B

                        ;Get second char from args:
    inc hl              ;  Increment HL to point to next char in args
    dec c               ;  Decrement C (number of chars remaining in args)
    jp m,get_dec_one    ;  Jump if sign flag is set (decremented past 0)
    ld a,(hl)           ;  A = char from args at HL

                        ;Convert second char from ASCII to binary number:
    sub 30h             ;  Subtract 30h to convert it (ASCII "0" = 30h)
    jp c,get_dec_one    ;  Jump if carry is set, indicating A < 0
    cp 0ah              ;  Compare to check upper bounds
    jp nc,get_dec_one   ;  Jump if A >= 0Ah (ASCII "9" = 39h)

                        ;B = first number, A = second number

                        ;Multiply first number (B) by 10:
    push af             ;  Save A
    ld a,b              ;  Both A and B contain the first number
    add a,a             ;  A = A + A
    add a,a             ;  A = A + A
    add a,b             ;  A = A + B
    add a,a             ;  A = A + A
    ld b,a              ;  Save result in B
    pop af              ;  Recall A

                        ;B = (first number * 10), A = second number

    add a,b             ;Add them to make the final number
    ret                 ;Return the number

get_dec_one:
;Called from get_dec when the decimal number in args was found to have
;only one digit.  The digit is in B.  HL and C are rolled back because
;get_dec will advanced past the digit.
;
    ld a,b              ;A = B
    dec hl              ;Roll back HL
    inc c               ;Roll back C
    or a                ;Clear carry flag
    ret

put_dec:
;Print A as a decimal number
;Only two digits are supported, so the range is 0-99 decimal.
;
    push de             ;Save DE
    push hl             ;Save HL

                        ;Find ASCII digit for tens place, store in E:
    ld e,2fh            ;  E = 2Fh, which is ASCII "0" - 1
put_dec_loop:           ;
    inc e               ;  Increment E to next ASCII digit
    sub 0ah             ;  Subtract 10 from A
    jp p,put_dec_loop   ;  Loop until A goes negative

                        ;Find ASCII digit for ones place, store in A:
    add a,0ah+30h       ;  Add 10 to undo the last subtraction
                        ;  Add 30h to convert it to ASCII

                        ;Print the digit in E (tens place):
    push af             ;  Save A
    ld c,cwrite         ;  Console Output
    call bdos           ;  BDOS System Call
    pop af              ;  Recall A

                        ;Print the digit in A (ones place):
    ld e,a              ;  E = A
    ld c,cwrite         ;  Console Output
    call bdos           ;  BDOS System Call

    pop hl              ;Recall HL
    pop de              ;Recall DE
    ret

time_is:
    db "Time is  $"
hit_key:
    db "Hit any key to start clock : $"
syntax_err:
    db "Syntax error$"
