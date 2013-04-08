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

    ld hl,0080h
    ld c,(hl)
l0104h:
    inc hl
    ld a,(hl)
    cp 20h
    jp nz,dispatch
    dec c
    jp nz,l0104h
    jp bad_syntax

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
    inc hl
    ld a,(hl)
    cp '='
    jp nz,p_bad_syntax
    inc hl
    ld a,(hl)
    dec c
    dec c
    dec c
    jp m,p_bad_syntax
    ret

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
    call sub_016bh
    and 5fh
    ld hl,l027ah
    cp 'A'
    jp z,l01cfh
    cp 'T'
    jp z,l01cfh
    cp 'H'
    ld b,07eh
    jp z,l01b3h
    cp 'E'
    jp nz,bad_syntax
    ld b,1bh
l01b3h:
    ld a,b
    ld (leadin),a
    xor a
    ld (x_offset),a
    ld (y_offset),a
    ld a,001h
    ld (xy_order),a
    ld hl,l025fh
    ld de,scrtab
    ld bc,0001bh
    ldir
    ret
l01cfh:
    ld a,20h
    ld (y_offset),a
    ld (x_offset),a
    xor a
    ld (xy_order),a
    ld a,1bh
    ld (leadin),a
    ld hl,l027ah
    ld de,scrtab
    ld bc,002bh
    ldir
    ret

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
    inc hl
    ld a,(hl)
    dec c
    scf
    ret m
    sub 30h
    jp c,sub_0223h
    cp 0ah
    jp nc,sub_0223h
    ld b,a
    inc hl
    dec c
    jp m,l024dh
    ld a,(hl)
    sub 30h
    jp c,l024dh
    cp 0ah
    jp nc,l024dh
    push af
    ld a,b
    add a,a
    add a,a
    add a,b
    add a,a
    ld b,a
    pop af
    add a,b
    ret
l024dh:
    ld a,b
    dec hl
    inc c
    or a
    ret

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
