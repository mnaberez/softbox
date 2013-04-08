; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels set.com

    org 0100h

    ld hl,0080h         ;0100
    ld c,(hl)           ;0103
l0104h:
    inc hl              ;0104
    ld a,(hl)           ;0105
    cp 20h              ;0106
    jp nz,l011bh        ;0108
    dec c               ;010b
    jp nz,l0104h        ;010c
    jp l0113h           ;010f
l0112h:
    pop de              ;0112
l0113h:
    ld de,l0252h        ;0113
    ld c,09h            ;0116
    jp 0005h            ;0118
l011bh:
    and 5fh             ;
    cp 55h              ;"U"
    jp z,l0157h         ;
    cp 4ch              ;"L"
    jp z,l015ch         ;
    cp 54h              ;"T"
    jp z,l0166h         ;
    cp 47h              ;"G"
    jp z,l0161h         ;
    cp 56h              ;"V"
    jp z,l0193h         ;
    cp 44h              ;"D"
    jp z,l01ech         ;
    cp 50h              ;"P"
    jp z,l020ch         ;
    cp 41h              ;"A"
    jp z,l0209h         ;
    cp 52h              ;"R"
    jp z,l0218h         ;
    cp 4eh              ;"N"
    jp z,l0212h         ;
    cp 45h              ;"E"
    jp z,l017bh         ;0151
    jp l0113h           ;0154
l0157h:
    ld c,15h            ;15h = Go to uppercase mode
    jp 0ea0ch           ;0159
l015ch:
    ld c,16h            ;16h = Go to lowercase mode
    jp 0ea0ch           ;015e
l0161h:
    ld c,17h            ;17h = Set line spacing to tall
    jp 0ea0ch           ;0163
l0166h:
    ld c,18h            ;18h = Set line spacing to short
    jp 0ea0ch           ;0168
sub_016bh:
    inc hl              ;016b
    ld a,(hl)           ;016c
    cp 3dh              ;016d
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
    cp 45h              ;0180
    ld b,1bh            ;0182
    jp z,l018eh         ;0184
    cp 54h              ;0187
    jp nz,l0113h        ;0189
    ld b,7eh            ;018c
l018eh:
    ld hl,0ea68h        ;018e
    ld (hl),b           ;0191
    ret                 ;0192
l0193h:
    call sub_016bh      ;0193
    and 5fh             ;0196
    ld hl,l027ah        ;0198
    cp 41h              ;019b  "A"
    jp z,l01cfh         ;019d
    cp 54h              ;01a0  "T"
    jp z,l01cfh         ;01a2
    cp 48h              ;01a5  "H"
    ld b,07eh           ;01a7
    jp z,l01b3h         ;01a9
    cp 45h              ;01ac  "E"
    jp nz,l0113h        ;01ae
    ld b,1bh            ;01b1
l01b3h:
    ld a,b              ;01b3
    ld (0ea68h),a       ;01b4
    xor a               ;01b7
    ld (0ea6bh),a       ;01b8
    ld (0ea6ah),a       ;01bb
    ld a,001h           ;01be
    ld (0ea69h),a       ;01c0
    ld hl,l025fh        ;01c3
    ld de,0ea80h        ;01c6
    ld bc,0001bh        ;01c9
    ldir                ;01cc
    ret                 ;01ce
l01cfh:
    ld a,20h            ;01cf
    ld (0ea6ah),a       ;01d1
    ld (0ea6bh),a       ;01d4
    xor a               ;01d7
    ld (0ea69h),a       ;01d8
    ld a,1bh            ;01db
    ld (0ea68h),a       ;01dd
    ld hl,l027ah        ;01e0
    ld de,0ea80h        ;01e3
    ld bc,002bh         ;01e6
    ldir                ;01e9
    ret                 ;01eb
l01ech:
    call sub_016bh      ;01ec
    ld b,00h            ;01ef
    cp 31h              ;01f1
    jp z,l0204h         ;01f3
    ld b,01h            ;01f6
    cp 32h              ;01f8
    jp z,l0204h         ;01fa
    ld b,03h            ;01fd
    cp 34h              ;01ff
    jp nz,l0113h        ;0201
l0204h:
    ld a,b              ;0204
    ld (0d8b2h),a       ;0205
    ret                 ;0208
l0209h:
    ld de,0ea66h        ;0209
l020ch:
    ld de,0ea61h        ;020c
    jp l021bh           ;020f
l0212h:
    ld de,0ea63h        ;0212
    jp l021bh           ;0215
l0218h:
    ld de,0ea62h        ;0218
l021bh:
    call sub_0223h      ;021b
    jp c,l0113h         ;021e
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

l0252h:
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
