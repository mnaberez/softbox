; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels set.com

dirsize:    equ 0d8b2h  ;CCP directory width: 0=1 col, 1=2 cols, 3=4 cols
lpt_dev:    equ 0ea61h  ;CBM printer (LPT:) IEEE-488 primary address
ptr_dev:    equ 0ea62h  ;Paper Tape Reader (PTR:) IEEE-488 primary address
ptp_dev:    equ 0ea63h  ;Paper Tape Punch (PTP:) IEEE-488 primary address
leadin:     equ 0ea68h  ;Terminal command lead-in: 1bh=escape, 7eh=tilde
xy_order:   equ 0ea69h  ;X,Y order when sending move-to: 0=X first, 1=Y first
y_offset:   equ 0ea6ah  ;Offset added to Y when sending move-to sequence
x_offset:   equ 0ea6bh  ;Offset added to X when sending move-to sequence
ul1_dev:    equ 0ea66h  ;ASCII printer (UL1:) IEEE-488 primary address
scrtab:     equ 0ea80h  ;64 byte buffer for tab stops
jp_conout:  equ 0ea0ch  ;Jumps to conout (Console Output) routine in BIOS

    org 0100h           ;CP/M TPA

    ld hl,0080h         ;0100
    ld c,(hl)           ;0103
l0104h:
    inc hl              ;0104
    ld a,(hl)           ;0105
    cp 20h              ;0106
    jp nz,dispatch      ;0108
    dec c               ;010b
    jp nz,l0104h        ;010c
    jp bad_syntax       ;010f

p_bad_syntax:
;Pop DE then fall through to bad_syntax
    pop de

bad_syntax:
;Write "Syntax error" to console out and return to CP/M.
;
    ld de,syntax_err    ;DE = address of "Syntax error" string
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
    jp 0005h            ;Jump out to BDOS System Call.  It will
                        ;  return to CP/M.

dispatch:
    and 5fh
    cp 'U'              ;U = Set uppercase mode
    jp z,set_u
    cp 'L'              ;L = Set lowercase mode
    jp z,set_l
    cp 'T'              ;T = Set line spacing to tall
    jp z,set_t
    cp 'G'              ;G = Set line spacing to short
    jp z,set_g
    cp 'V'
    jp z,set_v
    cp 'D'              ;D = Set directory width
    jp z,set_d
    cp 'P'              ;P = Set IEEE-488 primary address of LPT:
    jp z,set_p
    cp 'A'              ;A = Set IEEE-488 primary address of UL1:
    jp z,set_a
    cp 'R'              ;R = Set IEEE-488 primary address of PTR:
    jp z,set_r
    cp 'N'              ;N = Set IEEE-488 primary address of PTP:
    jp z,set_n
    cp 'E'              ;E = Set terminal command lead-in
    jp z,set_e
    jp bad_syntax

set_u:
;Set uppercase mode
;  SET U
;
    ld c,15h            ;15h = Go to uppercase mode
    jp jp_conout        ;Jump out to conout (in BIOS) through jp_conout.
                        ;  It will return to CP/M.

set_l:
;Set lowercase mode
;  SET L
;
    ld c,16h            ;16h = Go to lowercase mode
    jp jp_conout        ;Jump out to conout (in BIOS) through jp_conout.
                        ;  It will return to CP/M.

set_g:
;Set line spacing to tall
;  SET T
;
    ld c,17h            ;17h = Set line spacing to tall
    jp jp_conout        ;Jump out to conout (in BIOS) through jp_conout.
                        ;  It will return to CP/M.

set_t:
;Set line spacing to short
;  SET G
;
    ld c,18h            ;18h = Set line spacing to short
    jp jp_conout        ;Jump out to conout (in BIOS) through jp_conout.
                        ;  It will return to CP/M.

sub_016bh:
    inc hl              ;016b
    ld a,(hl)           ;016c
    cp '='              ;016d
    jp nz,p_bad_syntax  ;016f
    inc hl              ;0172
    ld a,(hl)           ;0173
    dec c               ;0174
    dec c               ;0175
    dec c               ;0176
    jp m,p_bad_syntax   ;0177
    ret                 ;017a

set_e:
;Set terminal command lead-in
;  SET E=E  Escape
;  SET E=T  Tilde
;
    call sub_016bh
    and 5fh
    cp 'E'
    ld b,1bh            ;01bh = ESC
    jp z,l018eh
    cp 'T'
    jp nz,bad_syntax
    ld b,7eh            ;7eh = Tilde
l018eh:
    ld hl,leadin
    ld (hl),b
    ret

set_v:
    call sub_016bh      ;0193
    and 5fh             ;0196
    ld hl,l027ah        ;0198
    cp 'A'              ;019b
    jp z,l01cfh         ;019d
    cp 'T'              ;01a0
    jp z,l01cfh         ;01a2
    cp 'H'              ;01a5
    ld b,07eh           ;01a7
    jp z,l01b3h         ;01a9
    cp 'E'              ;01ac
    jp nz,bad_syntax    ;01ae
    ld b,1bh            ;01b1
l01b3h:
    ld a,b              ;01b3
    ld (leadin),a       ;01b4
    xor a               ;01b7
    ld (x_offset),a     ;01b8
    ld (y_offset),a     ;01bb
    ld a,001h           ;01be
    ld (xy_order),a     ;01c0
    ld hl,l025fh        ;01c3
    ld de,scrtab        ;01c6
    ld bc,0001bh        ;01c9
    ldir                ;01cc
    ret                 ;01ce
l01cfh:
    ld a,20h            ;01cf
    ld (y_offset),a     ;01d1
    ld (x_offset),a     ;01d4
    xor a               ;01d7
    ld (xy_order),a     ;01d8
    ld a,1bh            ;01db
    ld (leadin),a       ;01dd
    ld hl,l027ah        ;01e0
    ld de,scrtab        ;01e3
    ld bc,002bh         ;01e6
    ldir                ;01e9
    ret                 ;01eb

set_d:
;Set directory width
;  SET D=1
;  SET D=2  Listings from DIR command will be 1,2,4 columns
;  SET D=4
;
    call sub_016bh
    ld b,00h
    cp '1'
    jp z,l0204h
    ld b,01h
    cp '2'
    jp z,l0204h
    ld b,03h
    cp '4'
    jp nz,bad_syntax
l0204h:
    ld a,b
    ld (dirsize),a
    ret

set_a:
;Set IEEE-488 primary address of UL1:
;  SET A=?
;
    ld de,ul1_dev       ;DE = address of UL1: device number
    ;XXX no jump
                        ;TODO: This is a bug.  There should be a jump here.
                        ;      Instead it just falls through, where DE will
                        ;      be immediately overwritten.

set_p:
;Set IEEE-488 primary address of LPT:
;  SET P=?
;
    ld de,lpt_dev       ;DE = address of LPT: device number
    jp l021bh

set_n:
;Set IEEE-488 primary address of PTP:
;  SET N=?
;
    ld de,ptp_dev       ;DE = address of PTP: device number
    jp l021bh

set_r:
;Set IEEE-488 primary address of PTR:
;  SET R=?
;
    ld de,ptr_dev       ;DE = address of PTR: device number
                        ;Fall through

l021bh:
    call sub_0223h
    jp c,bad_syntax
    ld (de),a
    ret

sub_0223h:
    inc hl              ;0223
    ld a,(hl)           ;0224
    dec c               ;0225
    scf                 ;0226
    ret m               ;0227
    sub 30h             ;0228
    jp c,sub_0223h      ;022a
    cp 0ah              ;022d
    jp nc,sub_0223h     ;022f
    ld b,a              ;0232
    inc hl              ;0233
    dec c               ;0234
    jp m,l024dh         ;0235
    ld a,(hl)           ;0238
    sub 30h             ;0239
    jp c,l024dh         ;023b
    cp 0ah              ;023e
    jp nc,l024dh        ;0240
    push af             ;0243
    ld a,b              ;0244
    add a,a             ;0245
    add a,a             ;0246
    add a,b             ;0247
    add a,a             ;0248
    ld b,a              ;0249
    pop af              ;024a
    add a,b             ;024b
    ret                 ;024c
l024dh:
    ld a,b              ;024d
    dec hl              ;024e
    inc c               ;024f
    or a                ;0250
    ret                 ;0251

syntax_err:
    db "Syntax error$"

l025fh:
    db 8bh,0bh,8ch,0ch,8fh,13h,91h,1bh,92h,1eh,93h,12h,97h,14h
    db 98h,14h,9ah,11h,9ch,1ah,9dh,1ah,99h,00h,9fh,00h,00h

l027ah:
    db 0b1h,04h,0b2h,05h,0b3h,06h,0eah,0eh,0ebh,0fh,0d1h,1ch,0d7h
    db 1dh,0c5h,11h,0d2h,12h,0d4h,13h,0f4h,13h,0d9h,14h,0f9h,14h
    db 0abh,1ah,0aah,1ah,0bah,1ah,0bbh,1ah,0dah,1ah,0bdh,1bh,0a8h
    db 00h,0a9h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
