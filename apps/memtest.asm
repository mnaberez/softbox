; z80dasm 1.1.3
; command line: z80dasm --origin 256 --address --labels memtest.com

    org 0100h

l0100h:
    ld sp,l0100h        ;0100
    ld hl,0000h         ;0103
    ld (002ah),hl       ;0106
    ld (0020h),hl       ;0109
    ld (0022h),hl       ;010c
    ld (0028h),hl       ;010f
    xor a               ;0112
    ld (0024h),a        ;0113
    ld a,0feh           ;0116
    ld (0025h),a        ;0118
    ld hl,0ffffh        ;011b
    ld (0026h),hl       ;011e
    ld hl,l02c2h        ;0121
    call sub_02aeh      ;0124
    ld hl,0600h         ;0127
    ld (002ch),hl       ;012a
    ld de,0ea00h        ;012d
l0130h:
    ld c,01h            ;0130
l0132h:
    ld b,01h            ;0132
l0134h:
    ld hl,(002ch)       ;0134
    call sub_0300h      ;0137
    or a                ;013a
    jp nz,l01f6h        ;013b
    push bc             ;013e
l013fh:
    call sub_023ch      ;013f
    ld (hl),a           ;0142
    inc hl              ;0143
    ld a,l              ;0144
    cp e                ;0145
    jr nz,l013fh        ;0146
    ld a,h              ;0148
    cp d                ;0149
    jr nz,l013fh        ;014a
    pop bc              ;014c
    djnz l0134h         ;014d
    ld b,01h            ;014f
l0151h:
    ld hl,(002ch)       ;0151
    call sub_0300h      ;0154
    or a                ;0157
    jp nz,l01f6h        ;0158
    push bc             ;015b
l015ch:
    call sub_023ch      ;015c
    ld b,a              ;015f
    ld a,(hl)           ;0160
    cp b                ;0161
    jr z,l016ah         ;0162
    ld (hl),b           ;0164
    call sub_01ffh      ;0165
    jr l017eh           ;0168
l016ah:
    sub (hl)            ;016a
    add a,(hl)          ;016b
    sub (hl)            ;016c
    add a,(hl)          ;016d
    sub (hl)            ;016e
    add a,(hl)          ;016f
    sub (hl)            ;0170
    add a,(hl)          ;0171
    sub (hl)            ;0172
    add a,(hl)          ;0173
    sub (hl)            ;0174
    add a,(hl)          ;0175
    sub (hl)            ;0176
    add a,(hl)          ;0177
    sub (hl)            ;0178
    add a,(hl)          ;0179
    cp b                ;017a
    call nz,sub_01ffh   ;017b
l017eh:
    inc hl              ;017e
    ld a,l              ;017f
    cp e                ;0180
    jr nz,l015ch        ;0181
    ld a,h              ;0183
    cp d                ;0184
    jr nz,l015ch        ;0185
    pop bc              ;0187
    djnz l0151h         ;0188
    push bc             ;018a
    ld hl,l02e7h        ;018b
    call sub_02aeh      ;018e
    ld hl,(002ah)       ;0191
    inc hl              ;0194
    ld (002ah),hl       ;0195
    call sub_0293h      ;0198
    ld hl,l02edh        ;019b
    call sub_02aeh      ;019e
    ld hl,(0022h)       ;01a1
    call sub_0293h      ;01a4
    ld hl,(0020h)       ;01a7
    call sub_0293h      ;01aa
    ld ix,0020h         ;01ad
    ld a,(ix+00h)       ;01b1
    or (ix+01h)         ;01b4
    or (ix+02h)         ;01b7
    or (ix+03h)         ;01ba
    jr z,l01e1h         ;01bd
    ld a,20h            ;01bf
    call sub_030eh      ;01c1
    ld hl,(0026h)       ;01c4
    call sub_0293h      ;01c7
    ld a,2dh            ;01ca
    call sub_030eh      ;01cc
    ld hl,(0028h)       ;01cf
    call sub_0293h      ;01d2
    ld hl,l02f3h        ;01d5
    call sub_02aeh      ;01d8
    ld a,(0024h)        ;01db
    call sub_0298h      ;01de
l01e1h:
    call sub_02b7h      ;01e1
    pop bc              ;01e4
    inc c               ;01e5
    ld a,c              ;01e6
    cp 0bh              ;01e7
    jp nz,l0132h        ;01e9
    ld a,(0025h)        ;01ec
    rrca                ;01ef
    ld (0025h),a        ;01f0
    jp l0130h           ;01f3
l01f6h:
    ld hl,l02deh        ;01f6
    call sub_02aeh      ;01f9
    jp 0000h            ;01fc
sub_01ffh:
    push bc             ;01ff
    push de             ;0200
    push hl             ;0201
    xor b               ;0202
    ld hl,0024h         ;0203
    or (hl)             ;0206
    ld (hl),a           ;0207
    ld hl,(0020h)       ;0208
    inc hl              ;020b
    ld (0020h),hl       ;020c
    ld a,h              ;020f
    or l                ;0210
    jr nz,l021ah        ;0211
    ld hl,(0022h)       ;0213
    inc hl              ;0216
    ld (0022h),hl       ;0217
l021ah:
    pop de              ;021a
    push de             ;021b
    ld a,(0026h)        ;021c
    sub e               ;021f
    ld a,(0027h)        ;0220
    sbc a,d             ;0223
    jr c,l022ah         ;0224
    ld (0026h),de       ;0226
l022ah:
    ld a,(0028h)        ;022a
    sub e               ;022d
    ld a,(0029h)        ;022e
    sbc a,d             ;0231
    jr nc,l0238h        ;0232
    ld (0028h),de       ;0234
l0238h:
    pop hl              ;0238
    pop de              ;0239
    pop bc              ;023a
    ret                 ;023b
sub_023ch:
    push hl             ;023c
    ld b,00h            ;023d
    ld hl,l0244h        ;023f
    add hl,bc           ;0242
    add hl,bc           ;0243
l0244h:
    ex (sp),hl          ;0244
    ret                 ;0245
    jr l025ah           ;0246
    jr l0268h           ;0248
    jr l026ah           ;024a
    jr l026dh           ;024c
    jr l0270h           ;024e
    jr l0265h           ;0250
    jr l0273h           ;0252
    jr l0263h           ;0254
    jr l027eh           ;0256
    jr l028bh           ;0258
l025ah:
    ld a,l              ;025a
    rrca                ;025b
    rrca                ;025c
    rrca                ;025d
    xor h               ;025e
    and 01h             ;025f
    jr z,l0265h         ;0261
l0263h:
    xor a               ;0263
    ret                 ;0264
l0265h:
    ld a,0ffh           ;0265
    ret                 ;0267
l0268h:
    ld a,l              ;0268
    ret                 ;0269
l026ah:
    ld a,0aah           ;026a
    ret                 ;026c
l026dh:
    ld a,l              ;026d
    cpl                 ;026e
    ret                 ;026f
l0270h:
    ld a,55h            ;0270
    ret                 ;0272
l0273h:
    ld a,l              ;0273
    rrca                ;0274
    rrca                ;0275
    rrca                ;0276
    xor h               ;0277
    and 01h             ;0278
    jr z,l0263h         ;027a
    jr l0265h           ;027c
l027eh:
    ld a,l              ;027e
    rra                 ;027f
    jr c,l0286h         ;0280
    ld a,(0025h)        ;0282
    ret                 ;0285
l0286h:
    ld a,(0025h)        ;0286
    cpl                 ;0289
    ret                 ;028a
l028bh:
    ld a,l              ;028b
    rra                 ;028c
    jr nc,l0286h        ;028d
    ld a,(0025h)        ;028f
    ret                 ;0292
sub_0293h:
    ld a,h              ;0293
    call sub_0298h      ;0294
    ld a,l              ;0297
sub_0298h:
    push af             ;0298
    rrca                ;0299
    rrca                ;029a
    rrca                ;029b
    rrca                ;029c
    call sub_02a1h      ;029d
    pop af              ;02a0
sub_02a1h:
    and 0fh             ;02a1
    cp 0ah              ;02a3
    jr c,l02a9h         ;02a5
    add a,07h           ;02a7
l02a9h:
    add a,30h           ;02a9
    jp sub_030eh        ;02ab
sub_02aeh:
    ld a,(hl)           ;02ae
    or a                ;02af
    ret z               ;02b0
    call sub_030eh      ;02b1
    inc hl              ;02b4
    jr sub_02aeh        ;02b5
sub_02b7h:
    ld a,0dh            ;02b7
    call sub_030eh      ;02b9
    ld a,0ah            ;02bc
    call sub_030eh      ;02be
    ret                 ;02c1
l02c2h:
    dec c               ;02c2
    ld a,(bc)           ;02c3
    ld d,h              ;02c4
    ld h,l              ;02c5
    ld (hl),e           ;02c6
    ld (hl),h           ;02c7
    ld l,c              ;02c8
    ld l,(hl)           ;02c9
    ld h,a              ;02ca
    jr nz,l0310h        ;02cb
    ld d,b              ;02cd
    cpl                 ;02ce
    ld c,l              ;02cf
    jr nz,$+68          ;02d0
    ld l,a              ;02d2
    ld a,b              ;02d3
    jr nz,l0343h        ;02d4
    ld h,l              ;02d6
    ld l,l              ;02d7
    ld l,a              ;02d8
    ld (hl),d           ;02d9
    ld a,c              ;02da
    dec c               ;02db
    ld a,(bc)           ;02dc
    nop                 ;02dd
l02deh:
    ld b,d              ;02de
    ld (hl),d           ;02df
    ld h,l              ;02e0
    ld h,c              ;02e1
    ld l,e              ;02e2
    ld l,02eh           ;02e3
    ld l,00h            ;02e5
l02e7h:
    ld d,b              ;02e7
    ld h,c              ;02e8
    ld (hl),e           ;02e9
    ld (hl),e           ;02ea
    dec a               ;02eb
    nop                 ;02ec
l02edh:
    jr nz,l0334h        ;02ed
    ld (hl),d           ;02ef
    ld (hl),d           ;02f0
    dec a               ;02f1
    nop                 ;02f2
l02f3h:
    jr nz,l0337h        ;02f3
    ld l,c              ;02f5
    ld (hl),h           ;02f6
    jr nz,l02f9h        ;02f7
l02f9h:
    call sub_0300h      ;02f9
    or a                ;02fc
    jr z,l02f9h         ;02fd
    ret                 ;02ff
sub_0300h:
    push hl             ;0300
    push bc             ;0301
    push de             ;0302
    call 0f006h         ;0303
    or a                ;0306
    call nz,0f009h      ;0307
    pop de              ;030a
    pop bc              ;030b
    pop hl              ;030c
    ret                 ;030d
sub_030eh:
    push bc             ;030e
    push hl             ;030f
l0310h:
    push de             ;0310
    push af             ;0311
    ld c,a              ;0312
    call 0f00ch         ;0313
    pop af              ;0316
    pop de              ;0317
    pop hl              ;0318
    pop bc              ;0319
    ret                 ;031a
    jp nc,0cd0fh        ;031b
    and c               ;031e
    ld (bc),a           ;031f
    pop af              ;0320
    and 0fh             ;0321
    cp 0ah              ;0323
    jr c,l0329h         ;0325
    add a,07h           ;0327
l0329h:
    add a,30h           ;0329
    jp sub_030eh        ;032b
l032eh:
    ld a,(hl)           ;032e
    or a                ;032f
    ret z               ;0330
    call sub_030eh      ;0331
l0334h:
    inc hl              ;0334
    jr l032eh           ;0335
l0337h:
    ld a,0dh            ;0337
    call sub_030eh      ;0339
    ld a,0ah            ;033c
    call sub_030eh      ;033e
    ret                 ;0341
    dec c               ;0342
l0343h:
    ld a,(bc)           ;0343
    ld d,h              ;0344
    ld h,l              ;0345
    ld (hl),e           ;0346
    ld (hl),h           ;0347
    ld l,c              ;0348
    ld l,(hl)           ;0349
    ld h,a              ;034a
    jr nz,$+69          ;034b
    ld d,b              ;034d
    cpl                 ;034e
    ld c,l              ;034f
    jr nz,l0394h        ;0350
    ld l,a              ;0352
    ld a,b              ;0353
    jr nz,l03c3h        ;0354
    ld h,l              ;0356
    ld l,l              ;0357
    ld l,a              ;0358
    ld (hl),d           ;0359
    ld a,c              ;035a
    dec c               ;035b
    ld a,(bc)           ;035c
    nop                 ;035d
    ld b,d              ;035e
    ld (hl),d           ;035f
    ld h,l              ;0360
    ld h,c              ;0361
    ld l,e              ;0362
    ld l,2eh            ;0363
    ld l,00h            ;0365
    ld d,b              ;0367
    ld h,c              ;0368
    ld (hl),e           ;0369
    ld (hl),e           ;036a
    dec a               ;036b
    nop                 ;036c
    jr nz,l03b4h        ;036d
    ld (hl),d           ;036f
    ld (hl),d           ;0370
    dec a               ;0371
    nop                 ;0372
    jr nz,l03b7h        ;0373
    ld l,c              ;0375
    ld (hl),h           ;0376
    jr nz,l0379h        ;0377
l0379h:
    call sub_0300h      ;0379
    or a                ;037c
    jr z,l0379h         ;037d
    ret                 ;037f
    jr c,l0386h         ;0380
    ld a,(0025h)        ;0382
    ret                 ;0385
l0386h:
    ld a,(0025h)        ;0386
    cpl                 ;0389
    ret                 ;038a
    ld a,l              ;038b
    rra                 ;038c
    jr nc,l0386h        ;038d
    ld a,(0025h)        ;038f
    ret                 ;0392
    ld a,h              ;0393
l0394h:
    call sub_0298h      ;0394
    ld a,l              ;0397
    push af             ;0398
    rrca                ;0399
    rrca                ;039a
    rrca                ;039b
    rrca                ;039c
    call sub_02a1h      ;039d
    pop af              ;03a0
    and 0fh             ;03a1
    cp 0ah              ;03a3
    jr c,l03a9h         ;03a5
    add a,07h           ;03a7
l03a9h:
    add a,30h           ;03a9
    jp sub_030eh        ;03ab
l03aeh:
    ld a,(hl)           ;03ae
    or a                ;03af
    ret z               ;03b0
    call sub_030eh      ;03b1
l03b4h:
    inc hl              ;03b4
    jr l03aeh           ;03b5
l03b7h:
    ld a,0dh            ;03b7
    call sub_030eh      ;03b9
    ld a,0ah            ;03bc
    call sub_030eh      ;03be
    ret                 ;03c1
    dec c               ;03c2
l03c3h:
    ld a,(bc)           ;03c3
    ld d,h              ;03c4
    ld h,l              ;03c5
    ld (hl),e           ;03c6
    ld (hl),h           ;03c7
    ld l,c              ;03c8
    ld l,(hl)           ;03c9
    ld h,a              ;03ca
    jr nz,$+69          ;03cb
    ld d,b              ;03cd
    cpl                 ;03ce
    ld c,l              ;03cf
    jr nz,$+68          ;03d0
    ld l,a              ;03d2
    ld a,b              ;03d3
    jr nz,$+111         ;03d4
    ld h,l              ;03d6
    ld l,l              ;03d7
    ld l,a              ;03d8
    ld (hl),d           ;03d9
    ld a,c              ;03da
    dec c               ;03db
    ld a,(bc)           ;03dc
    nop                 ;03dd
    ld b,d              ;03de
    ld (hl),d           ;03df
    ld h,l              ;03e0
    ld h,c              ;03e1
    ld l,e              ;03e2
    ld l,2eh            ;03e3
    ld l,00h            ;03e5
    ld d,b              ;03e7
    ld h,c              ;03e8
    ld (hl),e           ;03e9
    ld (hl),e           ;03ea
    dec a               ;03eb
    nop                 ;03ec
    jr nz,$+71          ;03ed
    ld (hl),d           ;03ef
    ld (hl),d           ;03f0
    dec a               ;03f1
    nop                 ;03f2
    jr nz,$+68          ;03f3
    ld l,c              ;03f5
    ld (hl),h           ;03f6
    jr nz,l03f9h        ;03f7
l03f9h:
    call sub_0300h      ;03f9
    or a                ;03fc
    jr z,l03f9h         ;03fd
    ret                 ;03ff
