; z80dasm 1.1.3
; command line: z80dasm --origin 256 --labels --address xfer.com

    org 0100h

    nop                 ;0100 00
    nop                 ;0101 00
    nop                 ;0102 00
    ld sp,(0006h)       ;0103 ed 7b 06 00
    ld a,(005dh)        ;0107 3a 5d 00
    cp 20h              ;010a fe 20
    jp z,l03e1h         ;010c ca e1 03
    ld hl,005dh         ;010f 21 5d 00
    ld b,0bh            ;0112 06 0b
l0114h:
    ld a,(hl)           ;0114 7e
    cp 3fh              ;0115 fe 3f
    jp z,l03e1h         ;0117 ca e1 03
    inc hl              ;011a 23
    djnz l0114h         ;011b 10 f7
l011dh:
    call sub_0408h      ;011d cd 08 04
    ld de,l0416h        ;0120 11 16 04
    ld c,09h            ;0123 0e 09
    call 0005h          ;0125 cd 05 00
    call sub_03b8h      ;0128 cd b8 03
    ld a,(l075dh+2)     ;012b 3a 5f 07
    ld hl,07e2h         ;012e 21 e2 07
    ld (hl),00h         ;0131 36 00
    cp 31h              ;0133 fe 31
    jp z,l02dfh         ;0135 ca df 02
    cp 32h              ;0138 fe 32
    jp z,l0152h         ;013a ca 52 01
    cp 33h              ;013d fe 33
    jp z,l019fh         ;013f ca 9f 01
    inc (hl)            ;0142 34
    cp 34h              ;0143 fe 34
    jp z,l0152h         ;0145 ca 52 01
    ld de,l05a3h        ;0148 11 a3 05
    ld c,09h            ;014b 0e 09
    call 0005h          ;014d cd 05 00
    jr l011dh           ;0150 18 cb
l0152h:
    ld a,53h            ;0152 3e 53
    call sub_0247h      ;0154 cd 47 02
    ld hl,0080h         ;0157 21 80 00
l015ah:
    call sub_03a6h      ;015a cd a6 03
    ld d,a              ;015d 57
    ld a,(0ea6ch)       ;015e 3a 6c ea
    and 10h             ;0161 e6 10
    push af             ;0163 f5
    ld a,(07e2h)        ;0164 3a e2 07
    or a                ;0167 b7
    ld a,d              ;0168 7a
    jr z,l0174h         ;0169 28 09
    cp 0dh              ;016b fe 0d
    jr nz,l0174h        ;016d 20 05
    call sub_0234h      ;016f cd 34 02
    ld a,0ah            ;0172 3e 0a
l0174h:
    call sub_0234h      ;0174 cd 34 02
    pop af              ;0177 f1
    jr z,l015ah         ;0178 28 e0
l017ah:
    ld de,(l07e0h)      ;017a ed 5b e0 07
    call 0f060h         ;017e cd 60 f0
    ld b,7fh            ;0181 06 7f
l0183h:
    push bc             ;0183 c5
    ld a,1ah            ;0184 3e 1a
    call sub_0234h      ;0186 cd 34 02
    pop bc              ;0189 c1
    djnz l0183h         ;018a 10 f7
    ld de,005ch         ;018c 11 5c 00
    ld c,10h            ;018f 0e 10
    call 0005h          ;0191 cd 05 00
    ld de,l05ddh        ;0194 11 dd 05
    ld c,09h            ;0197 0e 09
    call 0005h          ;0199 cd 05 00
    jp 0000h            ;019c c3 00 00
l019fh:
    ld a,50h            ;019f 3e 50
    call sub_0247h      ;01a1 cd 47 02
    ld hl,0080h         ;01a4 21 80 00
    call sub_03a6h      ;01a7 cd a6 03
    call sub_03a6h      ;01aa cd a6 03
l01adh:
    call sub_03a6h      ;01ad cd a6 03
    push af             ;01b0 f5
    call sub_03a6h      ;01b1 cd a6 03
    pop bc              ;01b4 c1
    or b                ;01b5 b0
    jr z,l017ah         ;01b6 28 c2
    push hl             ;01b8 e5
    call sub_03a6h      ;01b9 cd a6 03
    push af             ;01bc f5
    call sub_03a6h      ;01bd cd a6 03
    ld d,a              ;01c0 57
    pop af              ;01c1 f1
    ld e,a              ;01c2 5f
    ld bc,2710h         ;01c3 01 10 27
    call sub_0223h      ;01c6 cd 23 02
    ld bc,03e8h         ;01c9 01 e8 03
    call sub_0223h      ;01cc cd 23 02
    ld bc,0064h         ;01cf 01 64 00
    call sub_0223h      ;01d2 cd 23 02
    ld bc,000ah         ;01d5 01 0a 00
    call sub_0223h      ;01d8 cd 23 02
    ld a,e              ;01db 7b
    add a,30h           ;01dc c6 30
    call sub_0234h      ;01de cd 34 02
    ld a,20h            ;01e1 3e 20
    call sub_0234h      ;01e3 cd 34 02
l01e6h:
    call sub_03a6h      ;01e6 cd a6 03
    or a                ;01e9 b7
    jr z,l01f4h         ;01ea 28 08
    jp m,l0200h         ;01ec fa 00 02
    call sub_0234h      ;01ef cd 34 02
    jr l01e6h           ;01f2 18 f2
l01f4h:
    ld a,0dh            ;01f4 3e 0d
    call sub_0234h      ;01f6 cd 34 02
    ld a,0ah            ;01f9 3e 0a
    call sub_0234h      ;01fb cd 34 02
    jr l01adh           ;01fe 18 ad
l0200h:
    ld de,l0602h        ;0200 11 02 06
    and 7fh             ;0203 e6 7f
    ld b,a              ;0205 47
    inc b               ;0206 04
l0207h:
    djnz l0218h         ;0207 10 0f
l0209h:
    ld a,(de)           ;0209 1a
    and 7fh             ;020a e6 7f
    push de             ;020c d5
    call sub_0234h      ;020d cd 34 02
    pop de              ;0210 d1
    ld a,(de)           ;0211 1a
    rla                 ;0212 17
    inc de              ;0213 13
    jr nc,l0209h        ;0214 30 f3
    jr l01e6h           ;0216 18 ce
l0218h:
    ld a,(de)           ;0218 1a
    inc de              ;0219 13
    cp 0ffh             ;021a fe ff
    jr z,l01e6h         ;021c 28 c8
    rla                 ;021e 17
    jr nc,l0218h        ;021f 30 f7
    jr l0207h           ;0221 18 e4
sub_0223h:
    push hl             ;0223 e5
    ex de,hl            ;0224 eb
    ld a,2fh            ;0225 3e 2f
l0227h:
    inc a               ;0227 3c
    or a                ;0228 b7
    sbc hl,bc           ;0229 ed 42
    jr nc,l0227h        ;022b 30 fa
    add hl,bc           ;022d 09
    ex (sp),hl          ;022e e3
    call sub_0234h      ;022f cd 34 02
    pop de              ;0232 d1
    ret                 ;0233 c9
sub_0234h:
    ld (hl),a           ;0234 77
    inc l               ;0235 2c
    ret nz              ;0236 c0
    ld de,005ch         ;0237 11 5c 00
    ld c,15h            ;023a 0e 15
    call 0005h          ;023c cd 05 00
    or a                ;023f b7
    jp nz,l02d4h        ;0240 c2 d4 02
    ld hl,0080h         ;0243 21 80 00
    ret                 ;0246 c9
sub_0247h:
    push af             ;0247 f5
l0248h:
    ld de,l0513h        ;0248 11 13 05
    ld c,09h            ;024b 0e 09
    call 0005h          ;024d cd 05 00
    call sub_03b8h      ;0250 cd b8 03
    ld a,(l075dh+2)     ;0253 3a 5f 07
    sub 41h             ;0256 d6 41
    ld (l07dfh),a       ;0258 32 df 07
    call 0f051h         ;025b cd 51 f0
    jr c,l026ah         ;025e 38 0a
    ld de,l0592h        ;0260 11 92 05
    ld c,09h            ;0263 0e 09
    call 0005h          ;0265 cd 05 00
    jr l0248h           ;0268 18 de
l026ah:
    ld de,l0531h        ;026a 11 31 05
    ld c,09h            ;026d 0e 09
    call 0005h          ;026f cd 05 00
    call sub_03b8h      ;0272 cd b8 03
    ld a,(l07dfh)       ;0275 3a df 07
    call 0f078h         ;0278 cd 78 f0
    ld a,(l07dfh)       ;027b 3a df 07
    and 01h             ;027e e6 01
    add a,30h           ;0280 c6 30
    ld (l075dh),a       ;0282 32 5d 07
    ld a,(l07dfh)       ;0285 3a df 07
    call 0f054h         ;0288 cd 54 f0
    ld hl,l075dh+1      ;028b 21 5e 07
    ld a,(hl)           ;028e 7e
    add a,06h           ;028f c6 06
    ld c,a              ;0291 4f
    ld (hl),3ah         ;0292 36 3a
    ld hl,l0759h        ;0294 21 59 07
    ld b,00h            ;0297 06 00
    add hl,bc           ;0299 09
    ld (hl),2ch         ;029a 36 2c
    inc hl              ;029c 23
    pop af              ;029d f1
    ld (hl),a           ;029e 77
    inc hl              ;029f 23
    ld (hl),2ch         ;02a0 36 2c
    inc hl              ;02a2 23
    ld (hl),52h         ;02a3 36 52
    ld hl,l075dh        ;02a5 21 5d 07
    ld e,03h            ;02a8 1e 03
    ld (l07e0h),de      ;02aa ed 53 e0 07
    call 0f05dh         ;02ae cd 5d f0
    ld a,(l07dfh)       ;02b1 3a df 07
    call 0f05ah         ;02b4 cd 5a f0
    or a                ;02b7 b7
    jp nz,l03ech        ;02b8 c2 ec 03
    ld de,005ch         ;02bb 11 5c 00
    ld c,13h            ;02be 0e 13
    call 0005h          ;02c0 cd 05 00
    ld de,005ch         ;02c3 11 5c 00
    ld c,16h            ;02c6 0e 16
    call 0005h          ;02c8 cd 05 00
    inc a               ;02cb 3c
    ret nz              ;02cc c0
    ld de,(l07e0h)      ;02cd ed 5b e0 07
    call 0f060h         ;02d1 cd 60 f0
l02d4h:
    ld de,l05c4h        ;02d4 11 c4 05
    ld c,09h            ;02d7 0e 09
    call 0005h          ;02d9 cd 05 00
    jp 0000h            ;02dc c3 00 00
l02dfh:
    ld de,l0548h        ;02df 11 48 05
    ld c,09h            ;02e2 0e 09
    call 0005h          ;02e4 cd 05 00
    call sub_03b8h      ;02e7 cd b8 03
    ld a,(l075dh+2)     ;02ea 3a 5f 07
    sub 41h             ;02ed d6 41
    ld (l07dfh),a       ;02ef 32 df 07
    call 0f051h         ;02f2 cd 51 f0
    jr c,l0301h         ;02f5 38 0a
    ld de,l0592h        ;02f7 11 92 05
    ld c,09h            ;02fa 0e 09
    call 0005h          ;02fc cd 05 00
    jr l02dfh           ;02ff 18 de
l0301h:
    ld de,l056bh        ;0301 11 6b 05
    ld c,09h            ;0304 0e 09
    call 0005h          ;0306 cd 05 00
    call sub_03b8h      ;0309 cd b8 03
    ld a,(l07dfh)       ;030c 3a df 07
    call 0f078h         ;030f cd 78 f0
    ld a,(l07dfh)       ;0312 3a df 07
    and 01h             ;0315 e6 01
    add a,30h           ;0317 c6 30
    ld (l075dh),a       ;0319 32 5d 07
    ld a,(l07dfh)       ;031c 3a df 07
    call 0f054h         ;031f cd 54 f0
    ld hl,l075dh+1      ;0322 21 5e 07
    ld c,(hl)           ;0325 4e
    ld b,00h            ;0326 06 00
    ld ix,l075dh+2      ;0328 dd 21 5f 07
    add ix,bc           ;032c dd 09
    ld (ix+00h),02ch    ;032e dd 36 00 2c
    ld (ix+01h),053h    ;0332 dd 36 01 53
    ld (ix+02h),02ch    ;0336 dd 36 02 2c
    ld (ix+03h),057h    ;033a dd 36 03 57
    inc bc              ;033e 03
    inc bc              ;033f 03
    inc bc              ;0340 03
    inc bc              ;0341 03
    inc bc              ;0342 03
    inc bc              ;0343 03
    ld (hl),3ah         ;0344 36 3a
    dec hl              ;0346 2b
    ld e,03h            ;0347 1e 03
    ld (l07e0h),de      ;0349 ed 53 e0 07
    call 0f05dh         ;034d cd 5d f0
    ld a,(l07dfh)       ;0350 3a df 07
    call 0f05ah         ;0353 cd 5a f0
    or a                ;0356 b7
    jp nz,l03ech        ;0357 c2 ec 03
    ld de,005ch         ;035a 11 5c 00
    ld c,0fh            ;035d 0e 0f
    call 0005h          ;035f cd 05 00
    inc a               ;0362 3c
    jp z,l039bh         ;0363 ca 9b 03
l0366h:
    ld de,005ch         ;0366 11 5c 00
    ld c,14h            ;0369 0e 14
    call 0005h          ;036b cd 05 00
    or a                ;036e b7
    jr nz,l0389h        ;036f 20 18
    ld de,(l07e0h)      ;0371 ed 5b e0 07
    call 0f033h         ;0375 cd 33 f0
    ld hl,0080h         ;0378 21 80 00
l037bh:
    ld a,(hl)           ;037b 7e
    push hl             ;037c e5
    call 0f042h         ;037d cd 42 f0
    pop hl              ;0380 e1
    inc l               ;0381 2c
    jr nz,l037bh        ;0382 20 f7
    call 0f036h         ;0384 cd 36 f0
    jr l0366h           ;0387 18 dd
l0389h:
    ld de,(l07e0h)      ;0389 ed 5b e0 07
    call 0f060h         ;038d cd 60 f0
    ld de,l05ddh        ;0390 11 dd 05
    ld c,09h            ;0393 0e 09
    call 0005h          ;0395 cd 05 00
    jp 0000h            ;0398 c3 00 00
l039bh:
    ld de,l05f1h        ;039b 11 f1 05
    ld c,09h            ;039e 0e 09
    call 0005h          ;03a0 cd 05 00
    jp 0000h            ;03a3 c3 00 00
sub_03a6h:
    push hl             ;03a6 e5
    ld de,(l07e0h)      ;03a7 ed 5b e0 07
    call 0f039h         ;03ab cd 39 f0
    call 0f03fh         ;03ae cd 3f f0
    push af             ;03b1 f5
    call 0f03ch         ;03b2 cd 3c f0
    pop af              ;03b5 f1
    pop hl              ;03b6 e1
    ret                 ;03b7 c9
sub_03b8h:
    ld de,l075dh        ;03b8 11 5d 07
    ld a,50h            ;03bb 3e 50
    ld (de),a           ;03bd 12
    ld c,0ah            ;03be 0e 0a
    call 0005h          ;03c0 cd 05 00
    call sub_0408h      ;03c3 cd 08 04
    ld a,(l075dh+1)     ;03c6 3a 5e 07
    ld hl,l075dh+2      ;03c9 21 5f 07
    ld b,a              ;03cc 47
    inc b               ;03cd 04
l03ceh:
    ld a,(hl)           ;03ce 7e
    cp 61h              ;03cf fe 61
    jr c,l03dah         ;03d1 38 07
    cp 7bh              ;03d3 fe 7b
    jr nc,l03dah        ;03d5 30 03
    sub 20h             ;03d7 d6 20
    ld (hl),a           ;03d9 77
l03dah:
    inc hl              ;03da 23
    djnz l03ceh         ;03db 10 f1
    dec hl              ;03dd 2b
    ld (hl),0dh         ;03de 36 0d
    ret                 ;03e0 c9
l03e1h:
    ld de,l0582h        ;03e1 11 82 05
    ld c,09h            ;03e4 0e 09
    call 0005h          ;03e6 cd 05 00
    jp 0000h            ;03e9 c3 00 00
l03ech:
    ld de,l05b3h        ;03ec 11 b3 05
    ld c,09h            ;03ef 0e 09
    call 0005h          ;03f1 cd 05 00
    ld hl,0eac0h        ;03f4 21 c0 ea
l03f7h:
    push hl             ;03f7 e5
    ld e,(hl)           ;03f8 5e
    ld c,02h            ;03f9 0e 02
    call 0005h          ;03fb cd 05 00
    pop hl              ;03fe e1
    ld a,(hl)           ;03ff 7e
    inc hl              ;0400 23
    cp 0dh              ;0401 fe 0d
    jr nz,l03f7h        ;0403 20 f2
    jp 0000h            ;0405 c3 00 00
sub_0408h:
    ld e,0dh            ;0408 1e 0d
    ld c,02h            ;040a 0e 02
    call 0005h          ;040c cd 05 00
    ld e,0ah            ;040f 1e 0a
    ld c,02h            ;0411 0e 02
    jp 0005h            ;0413 c3 05 00
l0416h:
    ld b,e              ;0416 43
    ld d,b              ;0417 50
    cpl                 ;0418 2f
    ld c,l              ;0419 4d
    jr nz,l0458h        ;041a 20 3c
    dec l               ;041c 2d
    dec l               ;041d 2d
    ld a,20h            ;041e 3e 20
    ld d,b              ;0420 50
    ld h,l              ;0421 65
    ld (hl),h           ;0422 74
    jr nz,l0469h        ;0423 20 44
    ld c,a              ;0425 4f
    ld d,e              ;0426 53
    jr nz,l048fh        ;0427 20 66
    ld l,c              ;0429 69
    ld l,h              ;042a 6c
    ld h,l              ;042b 65
    jr nz,l04a2h        ;042c 20 74
    ld (hl),d           ;042e 72
    ld h,c              ;042f 61
    ld l,(hl)           ;0430 6e
    ld (hl),e           ;0431 73
    ld h,(hl)           ;0432 66
    ld h,l              ;0433 65
    ld (hl),d           ;0434 72
    dec c               ;0435 0d
    ld a,(bc)           ;0436 0a
    dec l               ;0437 2d
    dec l               ;0438 2d
    dec l               ;0439 2d
    dec l               ;043a 2d
    jr nz,$+34          ;043b 20 20
    jr nz,l045fh        ;043d 20 20
    jr nz,l0461h        ;043f 20 20
    dec l               ;0441 2d
    dec l               ;0442 2d
    dec l               ;0443 2d
    jr nz,l0473h        ;0444 20 2d
    dec l               ;0446 2d
    dec l               ;0447 2d
    jr nz,l0477h        ;0448 20 2d
    dec l               ;044a 2d
    dec l               ;044b 2d
    dec l               ;044c 2d
    jr nz,l047ch        ;044d 20 2d
    dec l               ;044f 2d
    dec l               ;0450 2d
    dec l               ;0451 2d
    dec l               ;0452 2d
    dec l               ;0453 2d
    dec l               ;0454 2d
    dec l               ;0455 2d
    dec c               ;0456 0d
    ld a,(bc)           ;0457 0a
l0458h:
    ld a,(bc)           ;0458 0a
    ld sp,202eh         ;0459 31 2e 20
    jr nz,$+69          ;045c 20 43
    ld l,a              ;045e 6f
l045fh:
    ld (hl),b           ;045f 70
    ld a,c              ;0460 79
l0461h:
    jr nz,$+117         ;0461 20 73
    ld h,l              ;0463 65
    ld (hl),c           ;0464 71
    ld (hl),l           ;0465 75
    ld h,l              ;0466 65
    ld l,(hl)           ;0467 6e
    ld (hl),h           ;0468 74
l0469h:
    ld l,c              ;0469 69
    ld h,c              ;046a 61
    ld l,h              ;046b 6c
    jr nz,$+104         ;046c 20 66
    ld l,c              ;046e 69
    ld l,h              ;046f 6c
    ld h,l              ;0470 65
    jr nz,l04e7h        ;0471 20 74
l0473h:
    ld l,a              ;0473 6f
    jr nz,l04c6h        ;0474 20 50
    ld b,l              ;0476 45
l0477h:
    ld d,h              ;0477 54
    jr nz,$+70          ;0478 20 44
    ld c,a              ;047a 4f
    ld d,e              ;047b 53
l047ch:
    dec c               ;047c 0d
    ld a,(bc)           ;047d 0a
    ld a,(bc)           ;047e 0a
    ld (202eh),a        ;047f 32 2e 20
    jr nz,$+69          ;0482 20 43
    ld l,a              ;0484 6f
    ld (hl),b           ;0485 70
    ld a,c              ;0486 79
    jr nz,l04fch        ;0487 20 73
    ld h,l              ;0489 65
    ld (hl),c           ;048a 71
    ld (hl),l           ;048b 75
    ld h,l              ;048c 65
    ld l,(hl)           ;048d 6e
    ld (hl),h           ;048e 74
l048fh:
    ld l,c              ;048f 69
    ld h,c              ;0490 61
    ld l,h              ;0491 6c
    jr nz,l04fah        ;0492 20 66
    ld l,c              ;0494 69
    ld l,h              ;0495 6c
    ld h,l              ;0496 65
    jr nz,l04ffh        ;0497 20 66
    ld (hl),d           ;0499 72
    ld l,a              ;049a 6f
    ld l,l              ;049b 6d
    jr nz,l04eeh        ;049c 20 50
    ld b,l              ;049e 45
    ld d,h              ;049f 54
    jr nz,l04e6h        ;04a0 20 44
l04a2h:
    ld c,a              ;04a2 4f
    ld d,e              ;04a3 53
    dec c               ;04a4 0d
    ld a,(bc)           ;04a5 0a
    ld a,(bc)           ;04a6 0a
    inc sp              ;04a7 33
    ld l,20h            ;04a8 2e 20
    jr nz,l04efh        ;04aa 20 43
    ld l,a              ;04ac 6f
    ld (hl),b           ;04ad 70
    ld a,c              ;04ae 79
    jr nz,l04f3h        ;04af 20 42
    ld b,c              ;04b1 41
    ld d,e              ;04b2 53
    ld c,c              ;04b3 49
    ld b,e              ;04b4 43
    jr nz,l0527h        ;04b5 20 70
    ld (hl),d           ;04b7 72
    ld l,a              ;04b8 6f
    ld h,a              ;04b9 67
    ld (hl),d           ;04ba 72
    ld h,c              ;04bb 61
    ld l,l              ;04bc 6d
    jr nz,l0525h        ;04bd 20 66
    ld (hl),d           ;04bf 72
    ld l,a              ;04c0 6f
    ld l,l              ;04c1 6d
    jr nz,l0514h        ;04c2 20 50
    ld b,l              ;04c4 45
    ld d,h              ;04c5 54
l04c6h:
    jr nz,l050ch        ;04c6 20 44
    ld c,a              ;04c8 4f
    ld d,e              ;04c9 53
    dec c               ;04ca 0d
    ld a,(bc)           ;04cb 0a
    ld a,(bc)           ;04cc 0a
    inc (hl)            ;04cd 34
    ld l,20h            ;04ce 2e 20
    jr nz,l0513h        ;04d0 20 41
    ld (hl),e           ;04d2 73
    jr nz,$+52          ;04d3 20 32
    ld l,20h            ;04d5 2e 20
    jr nz,l053bh        ;04d7 20 62
    ld (hl),l           ;04d9 75
    ld (hl),h           ;04da 74
    jr nz,l0546h        ;04db 20 69
    ld l,(hl)           ;04dd 6e
    ld (hl),e           ;04de 73
    ld h,l              ;04df 65
    ld (hl),d           ;04e0 72
    ld (hl),h           ;04e1 74
    jr nz,$+110         ;04e2 20 6c
    ld l,c              ;04e4 69
    ld l,(hl)           ;04e5 6e
l04e6h:
    ld h,l              ;04e6 65
l04e7h:
    jr nz,l054fh        ;04e7 20 66
    ld h,l              ;04e9 65
    ld h,l              ;04ea 65
    ld h,h              ;04eb 64
    ld (hl),e           ;04ec 73
    dec c               ;04ed 0d
l04eeh:
    ld a,(bc)           ;04ee 0a
l04efh:
    ld a,(bc)           ;04ef 0a
    ld d,a              ;04f0 57
    ld l,b              ;04f1 68
    ld l,c              ;04f2 69
l04f3h:
    ld h,e              ;04f3 63
    ld l,b              ;04f4 68
    jr nz,l056bh        ;04f5 20 74
    ld a,c              ;04f7 79
    ld (hl),b           ;04f8 70
    ld h,l              ;04f9 65
l04fah:
    jr nz,l056bh        ;04fa 20 6f
l04fch:
    ld h,(hl)           ;04fc 66
    jr nz,$+118         ;04fd 20 74
l04ffh:
    ld (hl),d           ;04ff 72
    ld h,c              ;0500 61
    ld l,(hl)           ;0501 6e
    ld (hl),e           ;0502 73
    ld h,(hl)           ;0503 66
    ld h,l              ;0504 65
    ld (hl),d           ;0505 72
    jr nz,$+42          ;0506 20 28
    ld sp,7420h         ;0508 31 20 74
    ld l,a              ;050b 6f
l050ch:
    jr nz,l0542h        ;050c 20 34
    add hl,hl           ;050e 29
    jr nz,$+65          ;050f 20 3f
    jr nz,l0537h        ;0511 20 24
l0513h:
    ld d,b              ;0513 50
l0514h:
    ld b,l              ;0514 45
    ld d,h              ;0515 54
    jr nz,$+70          ;0516 20 44
    ld c,a              ;0518 4f
    ld d,e              ;0519 53
    jr nz,l058fh        ;051a 20 73
    ld l,a              ;051c 6f
    ld (hl),l           ;051d 75
    ld (hl),d           ;051e 72
    ld h,e              ;051f 63
    ld h,l              ;0520 65
    jr nz,l0587h        ;0521 20 64
    ld (hl),d           ;0523 72
    ld l,c              ;0524 69
l0525h:
    halt                ;0525 76
    ld h,l              ;0526 65
l0527h:
    jr nz,l0551h        ;0527 20 28
    ld b,c              ;0529 41
    dec l               ;052a 2d
    ld d,b              ;052b 50
    add hl,hl           ;052c 29
    jr nz,l056eh        ;052d 20 3f
    jr nz,l0555h        ;052f 20 24
l0531h:
    ld d,b              ;0531 50
    ld b,l              ;0532 45
    ld d,h              ;0533 54
    jr nz,l057ah        ;0534 20 44
    ld c,a              ;0536 4f
l0537h:
    ld d,e              ;0537 53
    jr nz,l05adh        ;0538 20 73
    ld l,a              ;053a 6f
l053bh:
    ld (hl),l           ;053b 75
    ld (hl),d           ;053c 72
    ld h,e              ;053d 63
    ld h,l              ;053e 65
    jr nz,l05a7h        ;053f 20 66
    ld l,c              ;0541 69
l0542h:
    ld l,h              ;0542 6c
    ld h,l              ;0543 65
    jr nz,l0585h        ;0544 20 3f
l0546h:
    jr nz,l056ch        ;0546 20 24
l0548h:
    ld d,b              ;0548 50
    ld b,l              ;0549 45
    ld d,h              ;054a 54
    jr nz,l0591h        ;054b 20 44
    ld c,a              ;054d 4f
    ld d,e              ;054e 53
l054fh:
    jr nz,l05b5h        ;054f 20 64
l0551h:
    ld h,l              ;0551 65
    ld (hl),e           ;0552 73
    ld (hl),h           ;0553 74
    ld l,c              ;0554 69
l0555h:
    ld l,(hl)           ;0555 6e
    ld h,c              ;0556 61
    ld (hl),h           ;0557 74
    ld l,c              ;0558 69
    ld l,a              ;0559 6f
    ld l,(hl)           ;055a 6e
    jr nz,l05c1h        ;055b 20 64
    ld (hl),d           ;055d 72
    ld l,c              ;055e 69
    halt                ;055f 76
    ld h,l              ;0560 65
    jr nz,l058bh        ;0561 20 28
    ld b,c              ;0563 41
    dec l               ;0564 2d
    ld d,b              ;0565 50
    add hl,hl           ;0566 29
    jr nz,l05a8h        ;0567 20 3f
    jr nz,l058fh        ;0569 20 24
l056bh:
    ld d,b              ;056b 50
l056ch:
    ld b,l              ;056c 45
    ld d,h              ;056d 54
l056eh:
    jr nz,l05b4h        ;056e 20 44
    ld c,a              ;0570 4f
    ld d,e              ;0571 53
    jr nz,$+102         ;0572 20 64
    ld h,l              ;0574 65
    ld (hl),e           ;0575 73
    ld (hl),h           ;0576 74
    ld l,(hl)           ;0577 6e
    ld l,20h            ;0578 2e 20
l057ah:
    ld h,(hl)           ;057a 66
    ld l,c              ;057b 69
    ld l,h              ;057c 6c
    ld h,l              ;057d 65
    jr nz,l05bfh        ;057e 20 3f
    jr nz,l05a6h        ;0580 20 24
l0582h:
    dec c               ;0582 0d
    ld a,(bc)           ;0583 0a
    ld b,d              ;0584 42
l0585h:
    ld h,c              ;0585 61
    ld h,h              ;0586 64
l0587h:
    jr nz,l05efh        ;0587 20 66
    ld l,c              ;0589 69
    ld l,h              ;058a 6c
l058bh:
    ld h,l              ;058b 65
    jr nz,$+112         ;058c 20 6e
    ld h,c              ;058e 61
l058fh:
    ld l,l              ;058f 6d
    ld h,l              ;0590 65
l0591h:
    inc h               ;0591 24
l0592h:
    dec c               ;0592 0d
    ld a,(bc)           ;0593 0a
    ld b,d              ;0594 42
    ld h,c              ;0595 61
    ld h,h              ;0596 64
    jr nz,l05fdh        ;0597 20 64
    ld (hl),d           ;0599 72
    ld l,c              ;059a 69
    halt                ;059b 76
    ld h,l              ;059c 65
    jr nz,$+112         ;059d 20 6e
    ld h,c              ;059f 61
    ld l,l              ;05a0 6d
    ld h,l              ;05a1 65
    inc h               ;05a2 24
l05a3h:
    dec c               ;05a3 0d
    ld a,(bc)           ;05a4 0a
    ld b,d              ;05a5 42
l05a6h:
    ld h,c              ;05a6 61
l05a7h:
    ld h,h              ;05a7 64
l05a8h:
    jr nz,$+101         ;05a8 20 63
    ld l,a              ;05aa 6f
    ld l,l              ;05ab 6d
    ld l,l              ;05ac 6d
l05adh:
    ld h,c              ;05ad 61
    ld l,(hl)           ;05ae 6e
    ld h,h              ;05af 64
    dec c               ;05b0 0d
    ld a,(bc)           ;05b1 0a
    inc h               ;05b2 24
l05b3h:
    dec c               ;05b3 0d
l05b4h:
    ld a,(bc)           ;05b4 0a
l05b5h:
    ld b,h              ;05b5 44
    ld l,c              ;05b6 69
    ld (hl),e           ;05b7 73
    ld l,e              ;05b8 6b
    jr nz,l0620h        ;05b9 20 65
    ld (hl),d           ;05bb 72
    ld (hl),d           ;05bc 72
    ld l,a              ;05bd 6f
    ld (hl),d           ;05be 72
l05bfh:
    jr nz,l05fbh        ;05bf 20 3a
l05c1h:
    dec c               ;05c1 0d
    ld a,(bc)           ;05c2 0a
    inc h               ;05c3 24
l05c4h:
    dec c               ;05c4 0d
    ld a,(bc)           ;05c5 0a
    ld b,h              ;05c6 44
    ld l,c              ;05c7 69
    ld (hl),e           ;05c8 73
    ld l,e              ;05c9 6b
    jr nz,$+113         ;05ca 20 6f
    ld (hl),d           ;05cc 72
    jr nz,l0633h        ;05cd 20 64
    ld l,c              ;05cf 69
    ld (hl),d           ;05d0 72
    ld h,l              ;05d1 65
    ld h,e              ;05d2 63
    ld (hl),h           ;05d3 74
    ld l,a              ;05d4 6f
    ld (hl),d           ;05d5 72
    ld a,c              ;05d6 79
    jr nz,l063fh        ;05d7 20 66
    ld (hl),l           ;05d9 75
    ld l,h              ;05da 6c
    ld l,h              ;05db 6c
    inc h               ;05dc 24
l05ddh:
    dec c               ;05dd 0d
    ld a,(bc)           ;05de 0a
    ld d,h              ;05df 54
    ld (hl),d           ;05e0 72
    ld h,c              ;05e1 61
    ld l,(hl)           ;05e2 6e
    ld (hl),e           ;05e3 73
    ld h,(hl)           ;05e4 66
    ld h,l              ;05e5 65
    ld (hl),d           ;05e6 72
    jr nz,l064ch        ;05e7 20 63
    ld l,a              ;05e9 6f
    ld l,l              ;05ea 6d
    ld (hl),b           ;05eb 70
    ld l,h              ;05ec 6c
    ld h,l              ;05ed 65
    ld (hl),h           ;05ee 74
l05efh:
    ld h,l              ;05ef 65
    inc h               ;05f0 24
l05f1h:
    dec c               ;05f1 0d
    ld a,(bc)           ;05f2 0a
    ld b,(hl)           ;05f3 46
    ld l,c              ;05f4 69
    ld l,h              ;05f5 6c
    ld h,l              ;05f6 65
    jr nz,l0667h        ;05f7 20 6e
    ld l,a              ;05f9 6f
    ld (hl),h           ;05fa 74
l05fbh:
    jr nz,l0663h        ;05fb 20 66
l05fdh:
    ld l,a              ;05fd 6f
    ld (hl),l           ;05fe 75
    ld l,(hl)           ;05ff 6e
    ld h,h              ;0600 64
    inc h               ;0601 24
l0602h:
    ld b,l              ;0602 45
    ld c,(hl)           ;0603 4e
    call nz,4f46h       ;0604 c4 46 4f
    jp nc,454eh         ;0607 d2 4e 45
    ld e,b              ;060a 58
    call nc,4144h       ;060b d4 44 41
    ld d,h              ;060e 54
    pop bc              ;060f c1
    ld c,c              ;0610 49
    ld c,(hl)           ;0611 4e
    ld d,b              ;0612 50
    ld d,l              ;0613 55
    ld d,h              ;0614 54
    and e               ;0615 a3
    ld c,c              ;0616 49
    ld c,(hl)           ;0617 4e
    ld d,b              ;0618 50
    ld d,l              ;0619 55
    call nc,4944h       ;061a d4 44 49
    call 4552h          ;061d cd 52 45
l0620h:
    ld b,c              ;0620 41
    call nz,454ch       ;0621 c4 4c 45
    call nc,4f47h       ;0624 d4 47 4f
    ld d,h              ;0627 54
    rst 8               ;0628 cf
    ld d,d              ;0629 52
    ld d,l              ;062a 55
    adc a,49h           ;062b ce 49
    add a,52h           ;062d c6 52
    ld b,l              ;062f 45
    ld d,e              ;0630 53
    ld d,h              ;0631 54
    ld c,a              ;0632 4f
l0633h:
    ld d,d              ;0633 52
    push bc             ;0634 c5
    ld b,a              ;0635 47
    ld c,a              ;0636 4f
    ld d,e              ;0637 53
    ld d,l              ;0638 55
    jp nz,4552h         ;0639 c2 52 45
    ld d,h              ;063c 54
    ld d,l              ;063d 55
    ld d,d              ;063e 52
l063fh:
    adc a,52h           ;063f ce 52
    ld b,l              ;0641 45
    call 5453h          ;0642 cd 53 54
    ld c,a              ;0645 4f
    ret nc              ;0646 d0
    ld c,a              ;0647 4f
    adc a,57h           ;0648 ce 57
    ld b,c              ;064a 41
    ld c,c              ;064b 49
l064ch:
    call nc,4f4ch       ;064c d4 4c 4f
    ld b,c              ;064f 41
    call nz,4153h       ;0650 c4 53 41
    ld d,(hl)           ;0653 56
    push bc             ;0654 c5
    ld d,(hl)           ;0655 56
    ld b,l              ;0656 45
    ld d,d              ;0657 52
    ld c,c              ;0658 49
    ld b,(hl)           ;0659 46
    exx                 ;065a d9
    ld b,h              ;065b 44
    ld b,l              ;065c 45
    add a,50h           ;065d c6 50
    ld c,a              ;065f 4f
    ld c,e              ;0660 4b
    push bc             ;0661 c5
    ld d,b              ;0662 50
l0663h:
    ld d,d              ;0663 52
    ld c,c              ;0664 49
    ld c,(hl)           ;0665 4e
    ld d,h              ;0666 54
l0667h:
    and e               ;0667 a3
    ld d,b              ;0668 50
    ld d,d              ;0669 52
    ld c,c              ;066a 49
    ld c,(hl)           ;066b 4e
    call nc,4f43h       ;066c d4 43 4f
    ld c,(hl)           ;066f 4e
    call nc,494ch       ;0670 d4 4c 49
    ld d,e              ;0673 53
    call nc,4c43h       ;0674 d4 43 4c
    jp nc,4d43h         ;0677 d2 43 4d
    call nz,5953h       ;067a c4 53 59
    out (4fh),a         ;067d d3 4f
    ld d,b              ;067f 50
    ld b,l              ;0680 45
    adc a,43h           ;0681 ce 43
    ld c,h              ;0683 4c
    ld c,a              ;0684 4f
    ld d,e              ;0685 53
    push bc             ;0686 c5
    ld b,a              ;0687 47
    ld b,l              ;0688 45
    call nc,454eh       ;0689 d4 4e 45
    rst 10h             ;068c d7
    ld d,h              ;068d 54
    ld b,c              ;068e 41
    ld b,d              ;068f 42
    xor b               ;0690 a8
    ld d,h              ;0691 54
    rst 8               ;0692 cf
    ld b,(hl)           ;0693 46
    adc a,53h           ;0694 ce 53
    ld d,b              ;0696 50
    ld b,e              ;0697 43
    xor b               ;0698 a8
    ld d,h              ;0699 54
    ld c,b              ;069a 48
    ld b,l              ;069b 45
    adc a,4eh           ;069c ce 4e
    ld c,a              ;069e 4f
    call nc,5453h       ;069f d4 53 54
    ld b,l              ;06a2 45
    ret nc              ;06a3 d0
    xor e               ;06a4 ab
    xor l               ;06a5 ad
    xor d               ;06a6 aa
    xor a               ;06a7 af
    sbc a,41h           ;06a8 de 41
    ld c,(hl)           ;06aa 4e
    call nz,0d24fh      ;06ab c4 4f d2
    cp (hl)             ;06ae be
    cp l                ;06af bd
    cp h                ;06b0 bc
    ld d,e              ;06b1 53
    ld b,a              ;06b2 47
    adc a,49h           ;06b3 ce 49
    ld c,(hl)           ;06b5 4e
    call nc,4241h       ;06b6 d4 41 42
    out (55h),a         ;06b9 d3 55
    ld d,e              ;06bb 53
    jp nc,5246h         ;06bc d2 46 52
    push bc             ;06bf c5
    ld d,b              ;06c0 50
    ld c,a              ;06c1 4f
    out (53h),a         ;06c2 d3 53
    ld d,c              ;06c4 51
    jp nc,4e52h         ;06c5 d2 52 4e
    call nz,4f4ch       ;06c8 c4 4c 4f
    rst 0               ;06cb c7
    ld b,l              ;06cc 45
    ld e,b              ;06cd 58
    ret nc              ;06ce d0
    ld b,e              ;06cf 43
    ld c,a              ;06d0 4f
    out (53h),a         ;06d1 d3 53
    ld c,c              ;06d3 49
    adc a,54h           ;06d4 ce 54
    ld b,c              ;06d6 41
    adc a,41h           ;06d7 ce 41
    ld d,h              ;06d9 54
    adc a,50h           ;06da ce 50
    ld b,l              ;06dc 45
    ld b,l              ;06dd 45
    bit 1,h             ;06de cb 4c
    ld b,l              ;06e0 45
    adc a,53h           ;06e1 ce 53
    ld d,h              ;06e3 54
    ld d,d              ;06e4 52
    and h               ;06e5 a4
    ld d,(hl)           ;06e6 56
    ld b,c              ;06e7 41
    call z,5341h        ;06e8 cc 41 53
    jp 4843h            ;06eb c3 43 48
    ld d,d              ;06ee 52
    and h               ;06ef a4
    ld c,h              ;06f0 4c
    ld b,l              ;06f1 45
    ld b,(hl)           ;06f2 46
    ld d,h              ;06f3 54
    and h               ;06f4 a4
    ld d,d              ;06f5 52
    ld c,c              ;06f6 49
    ld b,a              ;06f7 47
    ld c,b              ;06f8 48
    ld d,h              ;06f9 54
    and h               ;06fa a4
    ld c,l              ;06fb 4d
    ld c,c              ;06fc 49
    ld b,h              ;06fd 44
    and h               ;06fe a4
    ld b,a              ;06ff 47
    rst 8               ;0700 cf
    ld b,e              ;0701 43
    ld c,a              ;0702 4f
    ld c,(hl)           ;0703 4e
    ld b,e              ;0704 43
    ld b,c              ;0705 41
    call nc,4f44h       ;0706 d4 44 4f
    ld d,b              ;0709 50
    ld b,l              ;070a 45
    adc a,44h           ;070b ce 44
    ld b,e              ;070d 43
    ld c,h              ;070e 4c
    ld c,a              ;070f 4f
    ld d,e              ;0710 53
    push bc             ;0711 c5
    ld d,d              ;0712 52
    ld b,l              ;0713 45
    ld b,e              ;0714 43
    ld c,a              ;0715 4f
    ld d,d              ;0716 52
    call nz,4548h       ;0717 c4 48 45
    ld b,c              ;071a 41
    ld b,h              ;071b 44
    ld b,l              ;071c 45
    jp nc,4f43h         ;071d d2 43 4f
    ld c,h              ;0720 4c
    ld c,h              ;0721 4c
    ld b,l              ;0722 45
    ld b,e              ;0723 43
    call nc,4142h       ;0724 d4 42 41
    ld b,e              ;0727 43
    ld c,e              ;0728 4b
    ld d,l              ;0729 55
    ret nc              ;072a d0
    ld b,e              ;072b 43
    ld c,a              ;072c 4f
    ld d,b              ;072d 50
    exx                 ;072e d9
    ld b,c              ;072f 41
    ld d,b              ;0730 50
    ld d,b              ;0731 50
    ld b,l              ;0732 45
    ld c,(hl)           ;0733 4e
    call nz,5344h       ;0734 c4 44 53
    ld b,c              ;0737 41
    ld d,(hl)           ;0738 56
    push bc             ;0739 c5
    ld b,h              ;073a 44
    ld c,h              ;073b 4c
    ld c,a              ;073c 4f
    ld b,c              ;073d 41
    call nz,4143h       ;073e c4 43 41
    ld d,h              ;0741 54
    ld b,c              ;0742 41
    ld c,h              ;0743 4c
    ld c,a              ;0744 4f
    rst 0               ;0745 c7
    ld d,d              ;0746 52
    ld b,l              ;0747 45
    ld c,(hl)           ;0748 4e
    ld b,c              ;0749 41
    ld c,l              ;074a 4d
    push bc             ;074b c5
    ld d,e              ;074c 53
    ld b,e              ;074d 43
    ld d,d              ;074e 52
    ld b,c              ;074f 41
    ld d,h              ;0750 54
    ld b,e              ;0751 43
    ret z               ;0752 c8
    ld b,h              ;0753 44
    ld c,c              ;0754 49
    ld d,d              ;0755 52
    ld b,l              ;0756 45
    ld b,e              ;0757 43
    ld d,h              ;0758 54
l0759h:
    ld c,a              ;0759 4f
    ld d,d              ;075a 52
    exx                 ;075b d9
    rst 38h             ;075c ff
l075dh:
    ld hl,(3ca0h)       ;075d 2a a0 3c
    add hl,de           ;0760 19
    inc (hl)            ;0761 34
    pop de              ;0762 d1
    pop af              ;0763 f1
    and 7fh             ;0764 e6 7f
    push af             ;0766 f5
    add a,a             ;0767 87
    jp m,2f92h          ;0768 fa 92 2f
    ld hl,(3c8eh)       ;076b 2a 8e 3c
    ld a,(hl)           ;076e 7e
    or a                ;076f b7
    jp z,2f81h          ;0770 ca 81 2f
    pop af              ;0773 f1
    push bc             ;0774 c5
    ld b,a              ;0775 47
    inc b               ;0776 04
    dec hl              ;0777 2b
    dec b               ;0778 05
    jp z,2f6ch          ;0779 ca 6c 2f
    ld a,(hl)           ;077c 7e
    push de             ;077d d5
    cpl                 ;077e 2f
    ld e,a              ;077f 5f
    ld d,0ffh           ;0780 16 ff
    add hl,de           ;0782 19
    pop de              ;0783 d1
    jp 2f5dh            ;0784 c3 5d 2f
    ld a,(hl)           ;0787 7e
    or a                ;0788 b7
    jp z,2f8fh          ;0789 ca 8f 2f
    dec a               ;078c 3d
    ld b,a              ;078d 47
    dec hl              ;078e 2b
    ld a,(hl)           ;078f 7e
    inc b               ;0790 04
    dec b               ;0791 05
    jp z,2f8fh          ;0792 ca 8f 2f
    call 3121h          ;0795 cd 21 31
    dec b               ;0798 05
    jp 2f73h            ;0799 c3 73 2f
    pop af              ;079c f1
    dec hl              ;079d 2b
    inc a               ;079e 3c
    dec a               ;079f 3d
    jp z,2f8ch          ;07a0 ca 8c 2f
    dec hl              ;07a3 2b
    jp 2f84h            ;07a4 c3 84 2f
    ld a,(hl)           ;07a7 7e
    pop hl              ;07a8 e1
    ret                 ;07a9 c9
    pop bc              ;07aa c1
    pop hl              ;07ab e1
    ret                 ;07ac c9
    ld a,2eh            ;07ad 3e 2e
    call 3121h          ;07af cd 21 31
    call 3121h          ;07b2 cd 21 31
    pop af              ;07b5 f1
    and 3fh             ;07b6 e6 3f
    push bc             ;07b8 c5
    ld hl,(3c9bh)       ;07b9 2a 9b 3c
    ld c,a              ;07bc 4f
    ld b,00h            ;07bd 06 00
    add hl,bc           ;07bf 09
    ld b,h              ;07c0 44
    call 17b6h          ;07c1 cd b6 17
    ld b,l              ;07c4 45
    call 17b6h          ;07c5 cd b6 17
    pop bc              ;07c8 c1
    pop hl              ;07c9 e1
    dec de              ;07ca 1b
    ld a,(de)           ;07cb 1a
    ret                 ;07cc c9
    push hl             ;07cd e5
    call 0b54h          ;07ce cd 54 0b
    pop hl              ;07d1 e1
    call nz,2fcbh       ;07d2 c4 cb 2f
    push af             ;07d5 f5
    ld de,3b16h         ;07d6 11 16 3b
    ld a,(de)           ;07d9 1a
    inc a               ;07da 3c
    ld c,a              ;07db 4f
    ld a,(de)           ;07dc 1a
    ld (hl),a           ;07dd 77
    inc de              ;07de 13
l07dfh:
    dec hl              ;07df 2b
l07e0h:
    dec c               ;07e0 0d
    jp nz,0f1c1h        ;07e1 c2 c1 f1
    and 7fh             ;07e4 e6 7f
    push af             ;07e6 f5
    add a,a             ;07e7 87
    jp m,2f92h          ;07e8 fa 92 2f
    ld hl,(3c8eh)       ;07eb 2a 8e 3c
    ld a,(hl)           ;07ee 7e
    or a                ;07ef b7
    jp z,2f81h          ;07f0 ca 81 2f
    pop af              ;07f3 f1
    push bc             ;07f4 c5
    ld b,a              ;07f5 47
    inc b               ;07f6 04
    dec hl              ;07f7 2b
    dec b               ;07f8 05
    jp z,2f6ch          ;07f9 ca 6c 2f
    ld a,(hl)           ;07fc 7e
    push de             ;07fd d5
    cpl                 ;07fe 2f
    ld e,a              ;07ff 5f
