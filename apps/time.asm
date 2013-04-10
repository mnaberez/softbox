;TIME.COM
;  Read or set time on the CBM computer clock

bdos:       equ  0005h  ;BDOS entry point
args:       equ  0080h  ;Command line arguments passed from CCP
get_time:   equ 0f072h  ;BIOS Read the CBM clocks (both RTC and jiffies)
set_time:   equ 0f06fh  ;BIOS Set the time on the CBM real time clock

    org 0100h           ;CP/M TPA

    ld hl,args          ;HL = command line arguments from CCP: first byte is
                        ;       number of chars, followed by the chars
    ld c,(hl)           ;C = number of chars
    call sub_0168h      ;0104
    jp nc,time_input    ;0107

time_output:
;Write the current time to the console and exit.
;
    ld de,time_is       ;DE = address of "Time is" string
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
    call bdos           ;BDOS System Call

    call get_time       ;Read the CBM clocks (both RTC and jiffies):
                        ;  Real Time Clock:
                        ;    H = Hours, L = Minutes, D = Seconds
                        ;    E = Jiffies (counts up to 50 or 60)
                        ;  Jiffy Clock:
                        ;    A = Jiffy0 (MSB), B = Jiffy1, C = Jiffy2 (LSB)

                        ;Write the hour to console out:
    ld a,h              ;  A = Hours
    call put_dec        ;  Print A as a decimal number

                        ;Write a colon after the hour:
    push hl             ;
    push de             ;
    ld e,3ah            ;  E = ":" character
    ld c,02h            ;  C = 02h, C_WRITE (Console Output)
    call bdos           ;  BDOS System Call
    pop de              ;
    pop hl              ;

                        ;Write the minute to console out:
    ld a,l              ;  A = Minutes
    call put_dec        ;  Print A as a decimal number

                        ;Write a colon after the minute:
    push de             ;
    ld e,3ah            ;  E = ":" character
    ld c,02h            ;  C = 02h, C_WRITE (Console Output)
    call bdos           ;  BDOS System Call
    pop hl              ;  XXX
                        ;  TODO: pushes DE but pops HL.  Is this a bug?

                        ;Write the second to console out:
    ld a,d              ;  A = Seconds
    jp put_dec          ;  Jump out print A as a decimal number,
                        ;    it will return to CP/M.

time_input:
;Get a new time from the user and set the clock.
;
    ld d,a              ;0135
    call sub_0168h      ;0136
    jp c,bad_syntax     ;0139
    ld e,a              ;013c
    push de             ;013d
    call sub_0168h      ;013e
    jp c,bad_syntax     ;0141
    ld d,a              ;0144

    push de             ;0145
    ld de,hit_key       ;0146
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
    call bdos           ;BDOS System Call
    ld c,01h            ;C = 01h, C_READ (Console Input)
    call bdos           ;BDOS System Call
    cp 03h              ;Control-C pressed?
    jp z,0000h          ;0155
    pop de              ;0158
    pop hl              ;0159

    jp set_time         ;Jump out to set time on the CBM computer,
                        ;  it will return to CP/M.

bad_syntax:
    ld de,syntax_err    ;015d
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
    call bdos           ;BDOS System Call
    jp 0000h

sub_0168h:
    inc hl              ;0168
    ld a,(hl)           ;0169
    dec c               ;016a
    scf                 ;016b
    ret m               ;016c
    sub 30h             ;016d
    jp c,sub_0168h      ;016f
    cp 0ah              ;0172
    jp nc,sub_0168h     ;0174
    ld b,a              ;0177
    inc hl              ;0178
    dec c               ;0179
    jp m,l0192h         ;017a
    ld a,(hl)           ;017d
    sub 30h             ;017e
    jp c,l0192h         ;0180
    cp 0ah              ;0183
    jp nc,l0192h        ;0185
    push af             ;0188
    ld a,b              ;0189
    add a,a             ;018a
    add a,a             ;018b
    add a,b             ;018c
    add a,a             ;018d
    ld b,a              ;018e
    pop af              ;018f
    add a,b             ;0190
    ret                 ;0191
l0192h:
    ld a,b              ;0192
    dec hl              ;0193
    inc c               ;0194
    or a                ;0195
    ret                 ;0196

put_dec:
    push de             ;0197
    push hl             ;0198
    ld e,2fh            ;0199
l019bh:
    inc e               ;019b
    sub 0ah             ;019c
    jp p,l019bh         ;019e
    add a,3ah           ;01a1
    push af             ;01a3
    ld c,02h            ;C = 02h, C_WRITE (Console Output)
    call bdos           ;BDOS System Call
    pop af              ;01a9
    ld e,a              ;01aa
    ld c,02h            ;C = 02h, C_WRITE (Console Output)
    call bdos           ;BDOS System Call
    pop hl              ;01b0
    pop de              ;01b1
    ret                 ;01b2

time_is:
    db "Time is  $"
hit_key:
    db "Hit any key to start clock : $"
syntax_err:
    db "Syntax error$"

    add hl,bc           ;01e8
    ld c,(hl)           ;01e9
    call 0786h          ;01ea
    ld hl,1d84h         ;01ed
    inc (hl)            ;01f0
    jp nz,08cch         ;01f1
    ld hl,1cdeh         ;01f4
    ld (hl),00h         ;01f7
    ld bc,014ah         ;01f9
    nop                 ;01fc
    call nz,1ce5h       ;01fd
