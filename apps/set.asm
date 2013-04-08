; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels set.com

dirsize:  equ 0d8b2h    ;CCP directory width: 0=1 col, 1=2 cols, 3=4 cols
lpt_dev:  equ 0ea61h    ;CBM printer (LPT:) IEEE-488 primary address
ptr_dev:  equ 0ea62h    ;Paper Tape Reader (PTR:) IEEE-488 primary address
ptp_dev:  equ 0ea63h    ;Paper Tape Punch (PTP:) IEEE-488 primary address
leadin:   equ 0ea68h    ;Terminal command lead-in: 1bh=escape, 7eh=tilde
xy_order: equ 0ea69h    ;X,Y order when sending move-to: 0=X first, 1=Y first
y_offset: equ 0ea6ah    ;Offset added to Y when sending move-to sequence
x_offset: equ 0ea6bh    ;Offset added to X when sending move-to sequence
ul1_dev:  equ 0ea66h    ;ASCII printer (UL1:) IEEE-488 primary address
scrtab:   equ 0ea80h    ;64 byte buffer for tab stops

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
l0112h:
    pop de              ;0112

bad_syntax:
;Write "Syntax error" to console out and return to CP/M.
;
    ld de,syntax_err    ;DE = address of "Syntax error" string
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
    jp 0005h            ;Jump out to BDOS System Call.  It will
                        ;  return to CP/M.

dispatch:
    and 5fh
    cp 'U'
    jp z,set_u
    cp 'L'
    jp z,set_l
    cp 'T'
    jp z,set_t
    cp 'G'
    jp z,set_g
    cp 'V'
    jp z,set_v
    cp 'D'
    jp z,set_d
    cp 'P'
    jp z,set_p
    cp 'A'
    jp z,set_a
    cp 'R'
    jp z,set_n
    cp 'N'
    jp z,set_e
    cp 'E'
    jp z,l017bh
    jp bad_syntax

set_u:
    ld c,15h            ;15h = Go to uppercase mode
    jp 0ea0ch           ;0159

set_l:
    ld c,16h            ;16h = Go to lowercase mode
    jp 0ea0ch           ;015e

set_g:
    ld c,17h            ;17h = Set line spacing to tall
    jp 0ea0ch           ;0163

set_t:
    ld c,18h            ;18h = Set line spacing to short
    jp 0ea0ch           ;0168

sub_016bh:
    inc hl              ;016b
    ld a,(hl)           ;016c
    cp '='              ;016d
    jp nz,l0112h        ;016f
    inc hl              ;0172
    ld a,(hl)           ;0173
    dec c               ;0174
    dec c               ;0175
    dec c               ;0176
    jp m,l0112h         ;0177
    ret                 ;017a

l017bh:
    call sub_016bh      ;017b
    and 5fh             ;017e
    cp 'E'              ;0180
    ld b,1bh            ;0182
    jp z,l018eh         ;0184
    cp 'T'              ;0187
    jp nz,bad_syntax    ;0189
    ld b,7eh            ;018c
l018eh:
    ld hl,leadin        ;018e
    ld (hl),b           ;0191
    ret                 ;0192

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
    call sub_016bh      ;01ec
    ld b,00h            ;01ef
    cp '1'              ;01f1
    jp z,l0204h         ;01f3
    ld b,01h            ;01f6
    cp '2'              ;01f8
    jp z,l0204h         ;01fa
    ld b,03h            ;01fd
    cp '4'              ;01ff
    jp nz,bad_syntax    ;0201
l0204h:
    ld a,b              ;0204
    ld (dirsize),a      ;0205
    ret                 ;0208
set_a:
    ld de,ul1_dev       ;0209
set_p:
    ld de,lpt_dev       ;020c
    jp l021bh           ;020f
set_e:
    ld de,ptp_dev       ;0212
    jp l021bh           ;0215
set_n:
    ld de,ptr_dev       ;0218
l021bh:
    call sub_0223h      ;021b
    jp c,bad_syntax     ;021e
    ld (de),a           ;0221
    ret                 ;0222
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
    adc a,e             ;025f
    dec bc              ;0260
    adc a,h             ;0261
    inc c               ;0262
    adc a,a             ;0263
    inc de              ;0264
    sub c               ;0265
    dec de              ;0266
    sub d               ;0267
    ld e,93h            ;0268
    ld (de),a           ;026a
    sub a               ;026b
    inc d               ;026c
    sbc a,b             ;026d
    inc d               ;026e
    sbc a,d             ;026f
    ld de,1a9ch         ;0270
    sbc a,l             ;0273
    ld a,(de)           ;0274
    sbc a,c             ;0275
    nop                 ;0276
    sbc a,a             ;0277
    nop                 ;0278
    nop                 ;0279
l027ah:
    or c                ;027a
    inc b               ;027b
    or d                ;027c
    dec b               ;027d
    or e                ;027e
    ld b,0eah           ;027f
    ld c,0ebh           ;0281
    rrca                ;0283
    pop de              ;0284
    inc e               ;0285
    rst 10h             ;0286
    dec e               ;0287
    push bc             ;0288
    ld de,12d2h         ;0289
    call nc,0f413h      ;028c
    inc de              ;028f
    exx                 ;0290
    inc d               ;0291
    ld sp,hl            ;0292
    inc d               ;0293
    xor e               ;0294
    ld a,(de)           ;0295
    xor d               ;0296
    ld a,(de)           ;0297
    cp d                ;0298
    ld a,(de)           ;0299
    cp e                ;029a
    ld a,(de)           ;029b
    jp c,0bd1ah         ;029c
    dec de              ;029f
    xor b               ;02a0
    nop                 ;02a1
    xor c               ;02a2
    nop                 ;02a3
    nop                 ;02a4
    nop                 ;02a5
    nop                 ;02a6
    nop                 ;02a7
    nop                 ;02a8
    nop                 ;02a9
    nop                 ;02aa
    nop                 ;02ab
    nop                 ;02ac
    nop                 ;02ad
    nop                 ;02ae
    nop                 ;02af
