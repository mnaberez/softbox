; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels --output=mwformat.asm mwformat.com

    org 0100h

    jp l03a0h           ;0100 c3 a0 03
sub_0103h:
    jp 0000h            ;0103 c3 00 00
    ret                 ;0106 c9
sub_0107h:
    ld hl,l0c4ah        ;0107 21 4a 0c
    ld (hl),c           ;010a 71
    ld a,(l0c4ah)       ;010b 3a 4a 0c
    out (18h),a         ;010e d3 18
    ret                 ;0110 c9
sub_0111h:
    in a,(18h)          ;0111 db 18
    ret                 ;0113 c9
    ld a,00h            ;0114 3e 00
    ret                 ;0116 c9
    ret                 ;0117 c9
sub_0118h:
    ld hl,l0c4bh        ;0118 21 4b 0c
    ld (hl),c           ;011b 71
    ld c,00h            ;011c 0e 00
    call sub_0107h      ;011e cd 07 01
l0121h:
    call sub_0111h      ;0121 cd 11 01
    cp 0a0h             ;0124 fe a0
    jp nz,l0121h        ;0126 c2 21 01
    ld hl,l0c4bh        ;0129 21 4b 0c
    ld c,(hl)           ;012c 4e
    call sub_0107h      ;012d cd 07 01
l0130h:
    call sub_0111h      ;0130 cd 11 01
    cp 0a1h             ;0133 fe a1
    jp nz,l0130h        ;0135 c2 30 01
    ld c,0ffh           ;0138 0e ff
    call sub_0107h      ;013a cd 07 01
    ld hl,l0c4ch        ;013d 21 4c 0c
l0140h:
    ld (hl),01h         ;0140 36 01
    jp l0149h           ;0142 c3 49 01
l0145h:
    ld hl,l0c4ch        ;0145 21 4c 0c
    inc (hl)            ;0148 34
l0149h:
    ld a,(l0c4ch)       ;0149 3a 4c 0c
    cp 15h              ;014c fe 15
    jp m,l0145h         ;014e fa 45 01
    ret                 ;0151 c9
sub_0152h:
    ld c,0ffh           ;0152 0e ff
    call sub_0107h      ;0154 cd 07 01
l0157h:
    call sub_0111h      ;0157 cd 11 01
    cp 0ffh             ;015a fe ff
    jp nz,l0157h        ;015c c2 57 01
    ld c,0feh           ;015f 0e fe
    call sub_0107h      ;0161 cd 07 01
l0164h:
    call sub_0111h      ;0164 cd 11 01
    and 80h             ;0167 e6 80
    jp nz,l0164h        ;0169 c2 64 01
    call sub_0111h      ;016c cd 11 01
    ld (l0c3ch),a       ;016f 32 3c 0c
    ret                 ;0172 c9
sub_0173h:
    ld a,(l0c3ch)       ;0173 3a 3c 0c
    and 40h             ;0176 e6 40
    jp nz,l017ch        ;0178 c2 7c 01
    ret                 ;017b c9
l017ch:
    ld bc,l0722h        ;017c 01 22 07
    call sub_029eh      ;017f cd 9e 02
    ld a,(l0c3ch)       ;0182 3a 3c 0c
    cp 40h              ;0185 fe 40
    jp nz,l0193h        ;0187 c2 93 01
    ld bc,l0730h        ;018a 01 30 07
    call sub_029eh      ;018d cd 9e 02
    jp l01eeh           ;0190 c3 ee 01
l0193h:
    ld a,(l0c3ch)       ;0193 3a 3c 0c
    cp 42h              ;0196 fe 42
    jp nz,l01a4h        ;0198 c2 a4 01
    ld bc,l0748h        ;019b 01 48 07
    call sub_029eh      ;019e cd 9e 02
    jp l01eeh           ;01a1 c3 ee 01
l01a4h:
    ld a,(l0c3ch)       ;01a4 3a 3c 0c
    cp 44h              ;01a7 fe 44
    jp nz,l01b5h        ;01a9 c2 b5 01
    ld bc,l075fh        ;01ac 01 5f 07
    call sub_029eh      ;01af cd 9e 02
    jp l01eeh           ;01b2 c3 ee 01
l01b5h:
    ld a,(l0c3ch)       ;01b5 3a 3c 0c
    cp 46h              ;01b8 fe 46
    jp nz,l01c6h        ;01ba c2 c6 01
    ld bc,l0774h        ;01bd 01 74 07
    call sub_029eh      ;01c0 cd 9e 02
    jp l01eeh           ;01c3 c3 ee 01
l01c6h:
    ld a,(l0c3ch)       ;01c6 3a 3c 0c
    cp 47h              ;01c9 fe 47
    jp nz,l01d7h        ;01cb c2 d7 01
    ld bc,l0785h        ;01ce 01 85 07
    call sub_029eh      ;01d1 cd 9e 02
    jp l01eeh           ;01d4 c3 ee 01
l01d7h:
    ld a,(l0c3ch)       ;01d7 3a 3c 0c
    cp 49h              ;01da fe 49
    jp nz,l01e8h        ;01dc c2 e8 01
    ld bc,l0799h        ;01df 01 99 07
    call sub_029eh      ;01e2 cd 9e 02
    jp l01eeh           ;01e5 c3 ee 01
l01e8h:
    ld bc,l07aeh        ;01e8 01 ae 07
    call sub_029eh      ;01eb cd 9e 02
l01eeh:
    call sub_0293h      ;01ee cd 93 02
    ret                 ;01f1 c9
sub_01f2h:
    ld hl,l0c4dh        ;01f2 21 4d 0c
    ld (hl),80h         ;01f5 36 80
    ld de,l0c4dh        ;01f7 11 4d 0c
    ld c,0ah            ;01fa 0e 0a
    call 0005h          ;01fc cd 05 00
    call sub_0293h      ;01ff cd 93 02
    ld hl,0000h         ;0202 21 00 00
    ld (l0c48h),hl      ;0205 22 48 0c
    ld a,(l0c4eh)       ;0208 3a 4e 0c
    or a                ;020b b7
    jp nz,l0217h        ;020c c2 17 02
    ld hl,l0c3fh        ;020f 21 3f 0c
    ld (hl),00h         ;0212 36 00
    jp l0284h           ;0214 c3 84 02
l0217h:
    ld a,(l0c4fh)       ;0217 3a 4f 0c
    ld (l0c3fh),a       ;021a 32 3f 0c
    cp 61h              ;021d fe 61
    jp m,l022eh         ;021f fa 2e 02
    cp 7bh              ;0222 fe 7b
    jp p,l022eh         ;0224 f2 2e 02
    ld hl,l0c3fh        ;0227 21 3f 0c
    ld a,(hl)           ;022a 7e
    add a,0e0h          ;022b c6 e0
    ld (hl),a           ;022d 77
l022eh:
    ld hl,l0cd0h        ;022e 21 d0 0c
    ld (hl),00h         ;0231 36 00
l0233h:
    ld a,(l0cd0h)       ;0233 3a d0 0c
    ld l,a              ;0236 6f
    rla                 ;0237 17
    sbc a,a             ;0238 9f
    ld bc,l0c4fh        ;0239 01 4f 0c
    ld h,a              ;023c 67
    add hl,bc           ;023d 09
    ld a,(hl)           ;023e 7e
    cp 30h              ;023f fe 30
    jp m,l0284h         ;0241 fa 84 02
    ld a,(l0cd0h)       ;0244 3a d0 0c
    ld l,a              ;0247 6f
    rla                 ;0248 17
    sbc a,a             ;0249 9f
    ld bc,l0c4fh        ;024a 01 4f 0c
    ld h,a              ;024d 67
    add hl,bc           ;024e 09
    ld a,(hl)           ;024f 7e
    cp 3ah              ;0250 fe 3a
    jp p,l0284h         ;0252 f2 84 02
    ld hl,(l0c48h)      ;0255 2a 48 0c
    ld b,h              ;0258 44
    ld c,l              ;0259 4d
    ld de,000ah         ;025a 11 0a 00
    call 0aech          ;025d cd ec 0a
    ld a,(l0cd0h)       ;0260 3a d0 0c
    ld l,a              ;0263 6f
    rla                 ;0264 17
    sbc a,a             ;0265 9f
    ld bc,l0c4fh        ;0266 01 4f 0c
    ld h,a              ;0269 67
    add hl,bc           ;026a 09
    ld a,(hl)           ;026b 7e
    ld l,a              ;026c 6f
    rla                 ;026d 17
    sbc a,a             ;026e 9f
    ld bc,0ffd0h        ;026f 01 d0 ff
    ld h,a              ;0272 67
    add hl,bc           ;0273 09
    add hl,de           ;0274 19
    ld (l0c48h),hl      ;0275 22 48 0c
    ld hl,l0cd0h        ;0278 21 d0 0c
    inc (hl)            ;027b 34
    ld a,(hl)           ;027c 7e
    ld hl,l0c4eh        ;027d 21 4e 0c
    cp (hl)             ;0280 be
    jp m,l0233h         ;0281 fa 33 02
l0284h:
    ret                 ;0284 c9
sub_0285h:
    ld hl,l0cd1h        ;0285 21 d1 0c
    ld (hl),c           ;0288 71
    ld c,02h            ;0289 0e 02
    ld a,(l0cd1h)       ;028b 3a d1 0c
    ld e,a              ;028e 5f
    call 0005h          ;028f cd 05 00
    ret                 ;0292 c9
sub_0293h:
    ld c,0dh            ;0293 0e 0d
    call sub_0285h      ;0295 cd 85 02
    ld c,0ah            ;0298 0e 0a
    call sub_0285h      ;029a cd 85 02
    ret                 ;029d c9
sub_029eh:
    ld hl,l0cd3h        ;029e 21 d3 0c
    ld (hl),b           ;02a1 70
    dec hl              ;02a2 2b
    ld (hl),c           ;02a3 71
    ld hl,(l0cd2h)      ;02a4 2a d2 0c
    ld a,(hl)           ;02a7 7e
    ld (l0cd4h),a       ;02a8 32 d4 0c
l02abh:
    ld hl,(l0cd2h)      ;02ab 2a d2 0c
    inc hl              ;02ae 23
    ld (l0cd2h),hl      ;02af 22 d2 0c
    ld hl,(l0cd2h)      ;02b2 2a d2 0c
    ld c,(hl)           ;02b5 4e
    call sub_0285h      ;02b6 cd 85 02
    ld hl,l0cd4h        ;02b9 21 d4 0c
    dec (hl)            ;02bc 35
    ld a,(hl)           ;02bd 7e
    or a                ;02be b7
    jp nz,l02abh        ;02bf c2 ab 02
    ret                 ;02c2 c9
sub_02c3h:
    call sub_0bd4h      ;02c3 cd d4 0b
    nop                 ;02c6 00
    ld (bc),a           ;02c7 02
    push de             ;02c8 d5
    inc c               ;02c9 0c
    ld hl,l0cd6h        ;02ca 21 d6 0c
    ld (hl),b           ;02cd 70
    dec hl              ;02ce 2b
    ld (hl),c           ;02cf 71
    ld hl,(l0cd5h)      ;02d0 2a d5 0c
    ld a,l              ;02d3 7d
    or h                ;02d4 b4
    jp z,l02f8h         ;02d5 ca f8 02
    ld hl,(l0cd5h)      ;02d8 2a d5 0c
    ld b,h              ;02db 44
    ld c,l              ;02dc 4d
    ld de,000ah         ;02dd 11 0a 00
    call sub_0b48h      ;02e0 cd 48 0b
    call sub_02c3h      ;02e3 cd c3 02
    ld hl,(l0cd5h)      ;02e6 2a d5 0c
    ld b,h              ;02e9 44
    ld c,l              ;02ea 4d
    ld de,000ah         ;02eb 11 0a 00
    call sub_0b48h      ;02ee cd 48 0b
    ld a,l              ;02f1 7d
    add a,30h           ;02f2 c6 30
    ld c,a              ;02f4 4f
    call sub_0285h      ;02f5 cd 85 02
l02f8h:
    call sub_0c17h      ;02f8 cd 17 0c
    ld (bc),a           ;02fb 02
    push de             ;02fc d5
    inc c               ;02fd 0c
sub_02feh:
    ld hl,l0cd8h        ;02fe 21 d8 0c
    ld (hl),b           ;0301 70
    dec hl              ;0302 2b
    ld (hl),c           ;0303 71
    ld hl,(l0cd7h)      ;0304 2a d7 0c
    ld a,l              ;0307 7d
    or h                ;0308 b4
    jp nz,l0315h        ;0309 c2 15 03
    ld bc,l07c6h        ;030c 01 c6 07
    call sub_029eh      ;030f cd 9e 02
    jp l031dh           ;0312 c3 1d 03
l0315h:
    ld hl,(l0cd7h)      ;0315 2a d7 0c
    ld b,h              ;0318 44
    ld c,l              ;0319 4d
    call sub_02c3h      ;031a cd c3 02
l031dh:
    ret                 ;031d c9
    ld hl,l0cdah        ;031e 21 da 0c
    ld (hl),b           ;0321 70
    dec hl              ;0322 2b
    ld (hl),c           ;0323 71
    ld hl,(l0cd9h)      ;0324 2a d9 0c
    add hl,hl           ;0327 29
    jp nc,l0341h        ;0328 d2 41 03
    ld bc,l07c6h+2      ;032b 01 c8 07
    call sub_029eh      ;032e cd 9e 02
    ld hl,(l0cd9h)      ;0331 2a d9 0c
    ld a,l              ;0334 7d
    cpl                 ;0335 2f
    add a,01h           ;0336 c6 01
    ld l,a              ;0338 6f
    ld a,h              ;0339 7c
    cpl                 ;033a 2f
    adc a,00h           ;033b ce 00
    ld h,a              ;033d 67
    ld (l0cd9h),hl      ;033e 22 d9 0c
l0341h:
    ld hl,(l0cd9h)      ;0341 2a d9 0c
    ld b,h              ;0344 44
    ld c,l              ;0345 4d
    call sub_02feh      ;0346 cd fe 02
    ret                 ;0349 c9
    ld hl,l0cdch        ;034a 21 dc 0c
    ld (hl),b           ;034d 70
    dec hl              ;034e 2b
    ld (hl),c           ;034f 71
    inc hl              ;0350 23
    inc hl              ;0351 23
    ld (hl),01h         ;0352 36 01
    jp l0397h           ;0354 c3 97 03
l0357h:
    ld c,0ch            ;0357 0e 0c
    ld hl,(l0cdbh)      ;0359 2a db 0c
    jp l0366h           ;035c c3 66 03
l035fh:
    or a                ;035f b7
    ld a,h              ;0360 7c
    rra                 ;0361 1f
    ld h,a              ;0362 67
    ld a,l              ;0363 7d
    rra                 ;0364 1f
    ld l,a              ;0365 6f
l0366h:
    dec c               ;0366 0d
    jp p,l035fh         ;0367 f2 5f 03
    ld a,l              ;036a 7d
    and 0fh             ;036b e6 0f
    ld (l0cdeh),a       ;036d 32 de 0c
    cp 0ah              ;0370 fe 0a
    jp m,l037ah         ;0372 fa 7a 03
    add a,37h           ;0375 c6 37
    jp l037fh           ;0377 c3 7f 03
l037ah:
    ld a,(l0cdeh)       ;037a 3a de 0c
    add a,30h           ;037d c6 30
l037fh:
    ld c,a              ;037f 4f
    call sub_0285h      ;0380 cd 85 02
    ld c,04h            ;0383 0e 04
    ld hl,(l0cdbh)      ;0385 2a db 0c
    jp l038ch           ;0388 c3 8c 03
l038bh:
    add hl,hl           ;038b 29
l038ch:
    dec c               ;038c 0d
    jp p,l038bh         ;038d f2 8b 03
    ld (l0cdbh),hl      ;0390 22 db 0c
    ld hl,l0cddh        ;0393 21 dd 0c
    inc (hl)            ;0396 34
l0397h:
    ld a,(l0cddh)       ;0397 3a dd 0c
    cp 05h              ;039a fe 05
    jp m,l0357h         ;039c fa 57 03
    ret                 ;039f c9
l03a0h:
    ld hl,(0006h)       ;03a0 2a 06 00
    ld sp,hl            ;03a3 f9
l03a4h:
    ld c,1ah            ;03a4 0e 1a
    call sub_0285h      ;03a6 cd 85 02
    ld bc,l07cah        ;03a9 01 ca 07
    call sub_029eh      ;03ac cd 9e 02
    call sub_0293h      ;03af cd 93 02
    ld bc,l07f1h        ;03b2 01 f1 07
    call sub_029eh      ;03b5 cd 9e 02
    call sub_0293h      ;03b8 cd 93 02
    call sub_0293h      ;03bb cd 93 02
    ld bc,l0818h        ;03be 01 18 08
    call sub_029eh      ;03c1 cd 9e 02
    call sub_0293h      ;03c4 cd 93 02
    call sub_0293h      ;03c7 cd 93 02
    ld bc,l0825h        ;03ca 01 25 08
    call sub_029eh      ;03cd cd 9e 02
    call sub_0293h      ;03d0 cd 93 02
    ld bc,l0848h        ;03d3 01 48 08
    call sub_029eh      ;03d6 cd 9e 02
    call sub_0293h      ;03d9 cd 93 02
    ld bc,l0869h        ;03dc 01 69 08
    call sub_029eh      ;03df cd 9e 02
    call sub_0293h      ;03e2 cd 93 02
    call sub_0293h      ;03e5 cd 93 02
    call sub_0293h      ;03e8 cd 93 02
    call sub_0293h      ;03eb cd 93 02
    ld bc,0874h         ;03ee 01 74 08
    call sub_029eh      ;03f1 cd 9e 02
    call sub_0293h      ;03f4 cd 93 02
    call sub_0293h      ;03f7 cd 93 02
    ld bc,088dh         ;03fa 01 8d 08
    call sub_029eh      ;03fd cd 9e 02
    call sub_0293h      ;0400 cd 93 02
    ld bc,l08aah        ;0403 01 aa 08
    call sub_029eh      ;0406 cd 9e 02
    call sub_0293h      ;0409 cd 93 02
    ld bc,l08c7h        ;040c 01 c7 08
    call sub_029eh      ;040f cd 9e 02
    call sub_0293h      ;0412 cd 93 02
    ld bc,l08e4h        ;0415 01 e4 08
    call sub_029eh      ;0418 cd 9e 02
    call sub_0293h      ;041b cd 93 02
    ld bc,l0901h        ;041e 01 01 09
    call sub_029eh      ;0421 cd 9e 02
    call sub_0293h      ;0424 cd 93 02
    ld bc,l091eh        ;0427 01 1e 09
    call sub_029eh      ;042a cd 9e 02
    call sub_0293h      ;042d cd 93 02
    ld bc,l093bh        ;0430 01 3b 09
    call sub_029eh      ;0433 cd 9e 02
    call sub_0293h      ;0436 cd 93 02
    call sub_0293h      ;0439 cd 93 02
    ld bc,l0952h        ;043c 01 52 09
    call sub_029eh      ;043f cd 9e 02
    call sub_01f2h      ;0442 cd f2 01
    ld a,(l0c3fh)       ;0445 3a 3f 0c
    cp 41h              ;0448 fe 41
    jp nz,l045bh        ;044a c2 5b 04
    ld hl,l0c3dh        ;044d 21 3d 0c
    ld (hl),02h         ;0450 36 02
    ld hl,00bfh         ;0452 21 bf 00
    ld (l0c40h),hl      ;0455 22 40 0c
    jp l04feh           ;0458 c3 fe 04
l045bh:
    ld a,(l0c3fh)       ;045b 3a 3f 0c
    cp 42h              ;045e fe 42
    jp nz,l0471h        ;0460 c2 71 04
    ld hl,l0c3dh        ;0463 21 3d 0c
    ld (hl),04h         ;0466 36 04
    ld hl,00bfh         ;0468 21 bf 00
    ld (l0c40h),hl      ;046b 22 40 0c
    jp l04feh           ;046e c3 fe 04
l0471h:
    ld a,(l0c3fh)       ;0471 3a 3f 0c
    cp 43h              ;0474 fe 43
    jp nz,l0487h        ;0476 c2 87 04
    ld hl,l0c3dh        ;0479 21 3d 0c
    ld (hl),08h         ;047c 36 08
    ld hl,00bfh         ;047e 21 bf 00
    ld (l0c40h),hl      ;0481 22 40 0c
    jp l04feh           ;0484 c3 fe 04
l0487h:
    ld a,(l0c3fh)       ;0487 3a 3f 0c
    cp 44h              ;048a fe 44
    jp nz,l049dh        ;048c c2 9d 04
    ld hl,l0c3dh        ;048f 21 3d 0c
    ld (hl),02h         ;0492 36 02
    ld hl,l0140h        ;0494 21 40 01
    ld (l0c40h),hl      ;0497 22 40 0c
    jp l04feh           ;049a c3 fe 04
l049dh:
    ld a,(l0c3fh)       ;049d 3a 3f 0c
    cp 45h              ;04a0 fe 45
    jp nz,l04b3h        ;04a2 c2 b3 04
    ld hl,l0c3dh        ;04a5 21 3d 0c
    ld (hl),04h         ;04a8 36 04
    ld hl,l0140h        ;04aa 21 40 01
    ld (l0c40h),hl      ;04ad 22 40 0c
    jp l04feh           ;04b0 c3 fe 04
l04b3h:
    ld a,(l0c3fh)       ;04b3 3a 3f 0c
    cp 46h              ;04b6 fe 46
    jp nz,l04c9h        ;04b8 c2 c9 04
    ld hl,l0c3dh        ;04bb 21 3d 0c
    ld (hl),06h         ;04be 36 06
    ld hl,l0140h        ;04c0 21 40 01
    ld (l0c40h),hl      ;04c3 22 40 0c
    jp l04feh           ;04c6 c3 fe 04
l04c9h:
    ld a,(l0c3fh)       ;04c9 3a 3f 0c
    cp 5ah              ;04cc fe 5a
    jp nz,l04fbh        ;04ce c2 fb 04
    call sub_0293h      ;04d1 cd 93 02
    call sub_0293h      ;04d4 cd 93 02
    ld bc,096ch         ;04d7 01 6c 09
    call sub_029eh      ;04da cd 9e 02
    call sub_01f2h      ;04dd cd f2 01
    ld a,(l0c48h)       ;04e0 3a 48 0c
    ld (l0c3dh),a       ;04e3 32 3d 0c
    call sub_0293h      ;04e6 cd 93 02
    ld bc,097eh         ;04e9 01 7e 09
    call sub_029eh      ;04ec cd 9e 02
    call sub_01f2h      ;04ef cd f2 01
    ld hl,(l0c48h)      ;04f2 2a 48 0c
    ld (l0c40h),hl      ;04f5 22 40 0c
    jp l04feh           ;04f8 c3 fe 04
l04fbh:
    jp l03a4h           ;04fb c3 a4 03
l04feh:
    ld c,1ah            ;04fe 0e 1a
    call sub_0285h      ;0500 cd 85 02
    call sub_0293h      ;0503 cd 93 02
    call sub_0293h      ;0506 cd 93 02
    ld bc,0994h         ;0509 01 94 09
    call sub_029eh      ;050c cd 9e 02
    ld a,(l0c3dh)       ;050f 3a 3d 0c
    ld l,a              ;0512 6f
    rla                 ;0513 17
    sbc a,a             ;0514 9f
    ld b,a              ;0515 47
    ld c,l              ;0516 4d
    call sub_02feh      ;0517 cd fe 02
    ld bc,099fh         ;051a 01 9f 09
    call sub_029eh      ;051d cd 9e 02
    ld hl,(l0c40h)      ;0520 2a 40 0c
    ld b,h              ;0523 44
    ld c,l              ;0524 4d
    call sub_02feh      ;0525 cd fe 02
    ld bc,l09aah+1      ;0528 01 ab 09
    call sub_029eh      ;052b cd 9e 02
    call sub_0293h      ;052e cd 93 02
    call sub_0293h      ;0531 cd 93 02
    ld bc,l09b6h+1      ;0534 01 b7 09
    call sub_029eh      ;0537 cd 9e 02
    ld a,(l0c3dh)       ;053a 3a 3d 0c
    ld l,a              ;053d 6f
    rla                 ;053e 17
    sbc a,a             ;053f 9f
    ld b,a              ;0540 47
    ld c,l              ;0541 4d
    ld hl,(l0c40h)      ;0542 2a 40 0c
    ex de,hl            ;0545 eb
    call 0aech          ;0546 cd ec 0a
    ex de,hl            ;0549 eb
    add hl,hl           ;054a 29
    add hl,hl           ;054b 29
    add hl,hl           ;054c 29
    ld b,h              ;054d 44
    ld c,l              ;054e 4d
    call sub_02feh      ;054f cd fe 02
    ld bc,09d2h         ;0552 01 d2 09
    call sub_029eh      ;0555 cd 9e 02
l0558h:
    ld a,(l0c3dh)       ;0558 3a 3d 0c
    dec a               ;055b 3d
    or 80h              ;055c f6 80
    ld (l0c3eh),a       ;055e 32 3e 0c
    ld hl,(l0c40h)      ;0561 2a 40 0c
    dec hl              ;0564 2b
    ld a,h              ;0565 7c
    or 80h              ;0566 f6 80
    ld h,a              ;0568 67
    ld (l0c42h),hl      ;0569 22 42 0c
    call sub_0293h      ;056c cd 93 02
    call sub_0293h      ;056f cd 93 02
    ld bc,09dbh         ;0572 01 db 09
    call sub_029eh      ;0575 cd 9e 02
    call sub_01f2h      ;0578 cd f2 01
    ld a,(l0c3fh)       ;057b 3a 3f 0c
    cp 4eh              ;057e fe 4e
    jp nz,l064bh        ;0580 c2 4b 06
l0583h:
    call sub_0293h      ;0583 cd 93 02
    ld bc,09f8h         ;0586 01 f8 09
    call sub_029eh      ;0589 cd 9e 02
    ld a,(l0c3dh)       ;058c 3a 3d 0c
    ld l,a              ;058f 6f
    rla                 ;0590 17
    sbc a,a             ;0591 9f
    ld h,a              ;0592 67
    dec hl              ;0593 2b
    ld b,h              ;0594 44
    ld c,l              ;0595 4d
    call sub_02feh      ;0596 cd fe 02
    ld bc,0a14h         ;0599 01 14 0a
    call sub_029eh      ;059c cd 9e 02
    call sub_01f2h      ;059f cd f2 01
    ld hl,(l0c48h)      ;05a2 2a 48 0c
    add hl,hl           ;05a5 29
    jp c,l05bbh         ;05a6 da bb 05
    ld a,(l0c3dh)       ;05a9 3a 3d 0c
    ld l,a              ;05ac 6f
    rla                 ;05ad 17
    sbc a,a             ;05ae 9f
    ex de,hl            ;05af eb
    ld hl,(l0c48h)      ;05b0 2a 48 0c
    ld d,a              ;05b3 57
    ld a,l              ;05b4 7d
    sub e               ;05b5 93
    ld a,h              ;05b6 7c
    sbc a,d             ;05b7 9a
    jp m,l05c7h         ;05b8 fa c7 05
l05bbh:
    ld bc,0a19h         ;05bb 01 19 0a
    call sub_029eh      ;05be cd 9e 02
    call sub_0293h      ;05c1 cd 93 02
    jp l0583h           ;05c4 c3 83 05
l05c7h:
    ld a,(l0c48h)       ;05c7 3a 48 0c
    ld (l0c3eh),a       ;05ca 32 3e 0c
l05cdh:
    call sub_0293h      ;05cd cd 93 02
    ld bc,l0a1ch        ;05d0 01 1c 0a
    call sub_029eh      ;05d3 cd 9e 02
    ld a,(l0c3eh)       ;05d6 3a 3e 0c
    ld l,a              ;05d9 6f
    rla                 ;05da 17
    sbc a,a             ;05db 9f
    ld b,a              ;05dc 47
    ld c,l              ;05dd 4d
    call sub_02feh      ;05de cd fe 02
    ld bc,l0a3bh        ;05e1 01 3b 0a
    call sub_029eh      ;05e4 cd 9e 02
    call sub_01f2h      ;05e7 cd f2 01
    ld a,(l0c3fh)       ;05ea 3a 3f 0c
    cp 4eh              ;05ed fe 4e
    jp nz,l0637h        ;05ef c2 37 06
l05f2h:
    call sub_0293h      ;05f2 cd 93 02
    ld bc,0a3fh         ;05f5 01 3f 0a
    call sub_029eh      ;05f8 cd 9e 02
    ld hl,(l0c40h)      ;05fb 2a 40 0c
    dec hl              ;05fe 2b
    ld b,h              ;05ff 44
    ld c,l              ;0600 4d
    call sub_02feh      ;0601 cd fe 02
    ld bc,0a59h         ;0604 01 59 0a
    call sub_029eh      ;0607 cd 9e 02
    call sub_01f2h      ;060a cd f2 01
    ld hl,(l0c48h)      ;060d 2a 48 0c
    add hl,hl           ;0610 29
    jp c,l0622h         ;0611 da 22 06
    ld hl,(l0c48h)      ;0614 2a 48 0c
    ld a,l              ;0617 7d
    ex de,hl            ;0618 eb
    ld hl,(l0c40h)      ;0619 2a 40 0c
    sub l               ;061c 95
    ld a,d              ;061d 7a
    sbc a,h             ;061e 9c
    jp m,l062eh         ;061f fa 2e 06
l0622h:
    ld bc,0a5eh         ;0622 01 5e 0a
    call sub_029eh      ;0625 cd 9e 02
    call sub_0293h      ;0628 cd 93 02
    jp l05f2h           ;062b c3 f2 05
l062eh:
    ld hl,(l0c48h)      ;062e 2a 48 0c
    ld (l0c42h),hl      ;0631 22 42 0c
    jp l0648h           ;0634 c3 48 06
l0637h:
    ld a,(l0c3fh)       ;0637 3a 3f 0c
    cp 59h              ;063a fe 59
    jp z,l0648h         ;063c ca 48 06
    ld bc,l0a61h        ;063f 01 61 0a
    call sub_029eh      ;0642 cd 9e 02
    jp l05cdh           ;0645 c3 cd 05
l0648h:
    jp l065ch           ;0648 c3 5c 06
l064bh:
    ld a,(l0c3fh)       ;064b 3a 3f 0c
    cp 59h              ;064e fe 59
    jp z,l065ch         ;0650 ca 5c 06
    ld bc,l0a78h+1      ;0653 01 79 0a
    call sub_029eh      ;0656 cd 9e 02
    jp l0558h           ;0659 c3 58 05
l065ch:
    ld bc,0a91h         ;065c 01 91 0a
    call sub_029eh      ;065f cd 9e 02
    call sub_0293h      ;0662 cd 93 02
    ld bc,l0aaeh        ;0665 01 ae 0a
    call sub_029eh      ;0668 cd 9e 02
    call sub_01f2h      ;066b cd f2 01
    ld c,42h            ;066e 0e 42
    call sub_0118h      ;0670 cd 18 01
    ld hl,0000h         ;0673 21 00 00
    ld (l0c44h),hl      ;0676 22 44 0c
    jp l068ah           ;0679 c3 8a 06
l067ch:
    ld hl,l0c44h        ;067c 21 44 0c
    ld c,(hl)           ;067f 4e
    call sub_0107h      ;0680 cd 07 01
    ld hl,(l0c44h)      ;0683 2a 44 0c
    inc hl              ;0686 23
    ld (l0c44h),hl      ;0687 22 44 0c
l068ah:
    ld bc,0ffe0h        ;068a 01 e0 ff
    ld hl,(l0c44h)      ;068d 2a 44 0c
    add hl,bc           ;0690 09
    add hl,hl           ;0691 29
    jp c,l067ch         ;0692 da 7c 06
    ld hl,0020h         ;0695 21 20 00
    ld (l0c44h),hl      ;0698 22 44 0c
    jp l06aah           ;069b c3 aa 06
l069eh:
    ld c,00h            ;069e 0e 00
    call sub_0107h      ;06a0 cd 07 01
    ld hl,(l0c44h)      ;06a3 2a 44 0c
    inc hl              ;06a6 23
    ld (l0c44h),hl      ;06a7 22 44 0c
l06aah:
    ld bc,0fe00h        ;06aa 01 00 fe
    ld hl,(l0c44h)      ;06ad 2a 44 0c
    add hl,bc           ;06b0 09
    add hl,hl           ;06b1 29
    jp c,l069eh         ;06b2 da 9e 06
    call sub_0152h      ;06b5 cd 52 01
    call sub_0173h      ;06b8 cd 73 01
    call sub_0293h      ;06bb cd 93 02
    call sub_0293h      ;06be cd 93 02
    ld bc,l0acbh+1      ;06c1 01 cc 0a
    call sub_029eh      ;06c4 cd 9e 02
    ld c,27h            ;06c7 0e 27
    call sub_0118h      ;06c9 cd 18 01
    ld c,00h            ;06cc 0e 00
    call sub_0107h      ;06ce cd 07 01
    ld hl,l0c3eh        ;06d1 21 3e 0c
    ld c,(hl)           ;06d4 4e
    call sub_0107h      ;06d5 cd 07 01
    ld hl,l0c42h        ;06d8 21 42 0c
    ld c,(hl)           ;06db 4e
    call sub_0107h      ;06dc cd 07 01
    ld b,08h            ;06df 06 08
    ld hl,(l0c42h)      ;06e1 2a 42 0c
    jp l06eeh           ;06e4 c3 ee 06
l06e7h:
    or a                ;06e7 b7
    ld a,h              ;06e8 7c
    rra                 ;06e9 1f
    ld h,a              ;06ea 67
    ld a,l              ;06eb 7d
    rra                 ;06ec 1f
    ld l,a              ;06ed 6f
l06eeh:
    dec b               ;06ee 05
    jp p,l06e7h         ;06ef f2 e7 06
    ld c,l              ;06f2 4d
    call sub_0107h      ;06f3 cd 07 01
    ld c,1fh            ;06f6 0e 1f
    call sub_0107h      ;06f8 cd 07 01
    ld c,00h            ;06fb 0e 00
    call sub_0107h      ;06fd cd 07 01
    ld c,00h            ;0700 0e 00
    call sub_0107h      ;0702 cd 07 01
    ld c,00h            ;0705 0e 00
    call sub_0107h      ;0707 cd 07 01
    call sub_0152h      ;070a cd 52 01
    call sub_0173h      ;070d cd 73 01
    call sub_0293h      ;0710 cd 93 02
    call sub_0293h      ;0713 cd 93 02
    ld bc,l0adbh        ;0716 01 db 0a
    call sub_029eh      ;0719 cd 9e 02
    call sub_0293h      ;071c cd 93 02
    call sub_0103h      ;071f cd 03 01
l0722h:
    dec c               ;0722 0d
    ld b,h              ;0723 44
    ld d,d              ;0724 52
    ld c,c              ;0725 49
    ld d,(hl)           ;0726 56
    ld b,l              ;0727 45
    jr nz,$+71          ;0728 20 45
    ld d,d              ;072a 52
    ld d,d              ;072b 52
    ld c,a              ;072c 4f
    ld d,d              ;072d 52
    jr nz,l0753h        ;072e 20 23
l0730h:
    rla                 ;0730 17
    inc (hl)            ;0731 34
    jr nc,l0754h        ;0732 30 20
    dec l               ;0734 2d
    jr nz,$+106         ;0735 20 68
    ld h,l              ;0737 65
    ld h,c              ;0738 61
    ld h,h              ;0739 64
    ld h,l              ;073a 65
    ld (hl),d           ;073b 72
    jr nz,l07b5h        ;073c 20 77
    ld (hl),d           ;073e 72
    ld l,c              ;073f 69
    ld (hl),h           ;0740 74
    ld h,l              ;0741 65
    jr nz,l07a9h        ;0742 20 65
    ld (hl),d           ;0744 72
    ld (hl),d           ;0745 72
    ld l,a              ;0746 6f
    ld (hl),d           ;0747 72
l0748h:
    ld d,34h            ;0748 16 34
    ld (2d20h),a        ;074a 32 20 2d
    jr nz,l07b7h        ;074d 20 68
    ld h,l              ;074f 65
    ld h,c              ;0750 61
    ld h,h              ;0751 64
    ld h,l              ;0752 65
l0753h:
    ld (hl),d           ;0753 72
l0754h:
    jr nz,$+116         ;0754 20 72
    ld h,l              ;0756 65
    ld h,c              ;0757 61
    ld h,h              ;0758 64
    jr nz,l07c0h        ;0759 20 65
    ld (hl),d           ;075b 72
    ld (hl),d           ;075c 72
    ld l,a              ;075d 6f
    ld (hl),d           ;075e 72
l075fh:
    inc d               ;075f 14
    inc (hl)            ;0760 34
    inc (hl)            ;0761 34
    jr nz,l0791h        ;0762 20 2d
    jr nz,l07cah        ;0764 20 64
    ld h,c              ;0766 61
    ld (hl),h           ;0767 74
    ld h,c              ;0768 61
    jr nz,l07ddh        ;0769 20 72
    ld h,l              ;076b 65
    ld h,c              ;076c 61
    ld h,h              ;076d 64
    jr nz,l07d5h        ;076e 20 65
    ld (hl),d           ;0770 72
    ld (hl),d           ;0771 72
    ld l,a              ;0772 6f
    ld (hl),d           ;0773 72
l0774h:
    djnz l07aah         ;0774 10 34
    ld (hl),20h         ;0776 36 20
    dec l               ;0778 2d
    jr nz,$+121         ;0779 20 77
    ld (hl),d           ;077b 72
    ld l,c              ;077c 69
    ld (hl),h           ;077d 74
    ld h,l              ;077e 65
    jr nz,l07e7h        ;077f 20 66
    ld h,c              ;0781 61
    ld (hl),l           ;0782 75
    ld l,h              ;0783 6c
    ld (hl),h           ;0784 74
l0785h:
    inc de              ;0785 13
    inc (hl)            ;0786 34
    scf                 ;0787 37
    jr nz,l07b7h        ;0788 20 2d
    jr nz,l07f0h        ;078a 20 64
    ld l,c              ;078c 69
    ld (hl),e           ;078d 73
    ld l,e              ;078e 6b
    jr nz,$+112         ;078f 20 6e
l0791h:
    ld l,a              ;0791 6f
    ld (hl),h           ;0792 74
    jr nz,l0807h        ;0793 20 72
    ld h,l              ;0795 65
    ld h,c              ;0796 61
    ld h,h              ;0797 64
    ld a,c              ;0798 79
l0799h:
    inc d               ;0799 14
    inc (hl)            ;079a 34
    add hl,sp           ;079b 39
    jr nz,$+47          ;079c 20 2d
    jr nz,l0809h        ;079e 20 69
    ld l,h              ;07a0 6c
    ld l,h              ;07a1 6c
    ld h,l              ;07a2 65
    ld h,a              ;07a3 67
    ld h,c              ;07a4 61
    ld l,h              ;07a5 6c
    jr nz,l080bh        ;07a6 20 63
    ld l,a              ;07a8 6f
l07a9h:
    ld l,l              ;07a9 6d
l07aah:
    ld l,l              ;07aa 6d
    ld h,c              ;07ab 61
    ld l,(hl)           ;07ac 6e
    ld h,h              ;07ad 64
l07aeh:
    rla                 ;07ae 17
    ld a,b              ;07af 78
    ld a,b              ;07b0 78
    jr nz,l07e0h        ;07b1 20 2d
    jr nz,l082ah        ;07b3 20 75
l07b5h:
    ld l,(hl)           ;07b5 6e
    ld l,e              ;07b6 6b
l07b7h:
    ld l,(hl)           ;07b7 6e
    ld l,a              ;07b8 6f
    ld (hl),a           ;07b9 77
    ld l,(hl)           ;07ba 6e
    jr nz,$+103         ;07bb 20 65
    ld (hl),d           ;07bd 72
    ld (hl),d           ;07be 72
    ld l,a              ;07bf 6f
l07c0h:
    ld (hl),d           ;07c0 72
    jr nz,$+101         ;07c1 20 63
    ld l,a              ;07c3 6f
    ld h,h              ;07c4 64
    ld h,l              ;07c5 65
l07c6h:
    ld bc,l0130h        ;07c6 01 30 01
    dec l               ;07c9 2d
l07cah:
    ld h,53h            ;07ca 26 53
    ld l,a              ;07cc 6f
    ld h,(hl)           ;07cd 66
    ld (hl),h           ;07ce 74
    ld b,d              ;07cf 42
    ld l,a              ;07d0 6f
    ld a,b              ;07d1 78
    jr nz,l0821h        ;07d2 20 4d
    ld l,c              ;07d4 69
l07d5h:
    ld l,(hl)           ;07d5 6e
    ld l,c              ;07d6 69
    dec l               ;07d7 2d
    ld d,a              ;07d8 57
    ld l,c              ;07d9 69
    ld l,(hl)           ;07da 6e
    ld h,e              ;07db 63
    ld l,b              ;07dc 68
l07ddh:
    ld h,l              ;07dd 65
    ld (hl),e           ;07de 73
    ld (hl),h           ;07df 74
l07e0h:
    ld h,l              ;07e0 65
    ld (hl),d           ;07e1 72
    jr nz,l082ah        ;07e2 20 46
    ld l,a              ;07e4 6f
    ld (hl),d           ;07e5 72
    ld l,l              ;07e6 6d
l07e7h:
    ld h,c              ;07e7 61
    ld (hl),h           ;07e8 74
    jr nz,l083bh        ;07e9 20 50
    ld (hl),d           ;07eb 72
    ld l,a              ;07ec 6f
    ld h,a              ;07ed 67
    ld (hl),d           ;07ee 72
    ld h,c              ;07ef 61
l07f0h:
    ld l,l              ;07f0 6d
l07f1h:
    ld h,2dh            ;07f1 26 2d
    dec l               ;07f3 2d
    dec l               ;07f4 2d
    dec l               ;07f5 2d
    dec l               ;07f6 2d
    dec l               ;07f7 2d
    dec l               ;07f8 2d
    jr nz,l0828h        ;07f9 20 2d
    dec l               ;07fb 2d
    dec l               ;07fc 2d
    dec l               ;07fd 2d
    jr nz,l082dh        ;07fe 20 2d
    dec l               ;0800 2d
    dec l               ;0801 2d
    dec l               ;0802 2d
    dec l               ;0803 2d
    dec l               ;0804 2d
    dec l               ;0805 2d
    dec l               ;0806 2d
l0807h:
    dec l               ;0807 2d
    dec l               ;0808 2d
l0809h:
    jr nz,l0838h        ;0809 20 2d
l080bh:
    dec l               ;080b 2d
    dec l               ;080c 2d
    dec l               ;080d 2d
    dec l               ;080e 2d
    dec l               ;080f 2d
    jr nz,l083fh        ;0810 20 2d
    dec l               ;0812 2d
    dec l               ;0813 2d
    dec l               ;0814 2d
    dec l               ;0815 2d
    dec l               ;0816 2d
    dec l               ;0817 2d
l0818h:
    inc c               ;0818 0c
    ld d,d              ;0819 52
    ld h,l              ;081a 65
    halt                ;081b 76
    ld l,c              ;081c 69
    ld (hl),e           ;081d 73
    ld l,c              ;081e 69
    ld l,a              ;081f 6f
    ld l,(hl)           ;0820 6e
l0821h:
    jr nz,$+52          ;0821 20 32
    ld l,31h            ;0823 2e 31
l0825h:
    ld (4157h),hl       ;0825 22 57 41
l0828h:
    ld d,d              ;0828 52
    ld c,(hl)           ;0829 4e
l082ah:
    ld c,c              ;082a 49
    ld c,(hl)           ;082b 4e
    ld b,a              ;082c 47
l082dh:
    jr nz,l085ch        ;082d 20 2d
    jr nz,$+119         ;082f 20 75
    ld (hl),e           ;0831 73
    ld h,l              ;0832 65
    jr nz,l08a4h        ;0833 20 6f
    ld h,(hl)           ;0835 66
    jr nz,l08ach        ;0836 20 74
l0838h:
    ld l,b              ;0838 68
    ld l,c              ;0839 69
    ld (hl),e           ;083a 73
l083bh:
    jr nz,$+114         ;083b 20 70
    ld (hl),d           ;083d 72
    ld l,a              ;083e 6f
l083fh:
    ld h,a              ;083f 67
    ld (hl),d           ;0840 72
    ld h,c              ;0841 61
    ld l,l              ;0842 6d
    jr nz,l08bch        ;0843 20 77
    ld l,c              ;0845 69
    ld l,h              ;0846 6c
    ld l,h              ;0847 6c
l0848h:
    jr nz,l08aeh        ;0848 20 64
    ld h,l              ;084a 65
    ld (hl),e           ;084b 73
    ld (hl),h           ;084c 74
    ld (hl),d           ;084d 72
    ld l,a              ;084e 6f
    ld a,c              ;084f 79
    jr nz,$+99          ;0850 20 61
    ld l,(hl)           ;0852 6e
    ld a,c              ;0853 79
    jr nz,$+103         ;0854 20 65
    ld a,b              ;0856 78
    ld l,c              ;0857 69
    ld (hl),e           ;0858 73
    ld (hl),h           ;0859 74
    ld l,c              ;085a 69
    ld l,(hl)           ;085b 6e
l085ch:
    ld h,a              ;085c 67
    jr nz,$+102         ;085d 20 64
    ld h,c              ;085f 61
    ld (hl),h           ;0860 74
    ld h,c              ;0861 61
    jr nz,l08d3h        ;0862 20 6f
    ld l,(hl)           ;0864 6e
    jr nz,l08dbh        ;0865 20 74
    ld l,b              ;0867 68
    ld h,l              ;0868 65
l0869h:
    ld a,(bc)           ;0869 0a
    ld l,b              ;086a 68
    ld h,c              ;086b 61
    ld (hl),d           ;086c 72
    ld h,h              ;086d 64
    jr nz,l08d4h        ;086e 20 64
    ld l,c              ;0870 69
    ld (hl),e           ;0871 73
    ld l,e              ;0872 6b
    ld l,18h            ;0873 2e 18
    ld b,h              ;0875 44
    ld (hl),d           ;0876 72
    ld l,c              ;0877 69
    halt                ;0878 76
    ld h,l              ;0879 65
    jr nz,l08efh        ;087a 20 73
    ld l,c              ;087c 69
    ld a,d              ;087d 7a
    ld h,l              ;087e 65
    ld (hl),e           ;087f 73
    jr nz,$+117         ;0880 20 73
    ld (hl),l           ;0882 75
    ld (hl),b           ;0883 70
    ld (hl),b           ;0884 70
    ld l,a              ;0885 6f
    ld (hl),d           ;0886 72
    ld (hl),h           ;0887 74
    ld h,l              ;0888 65
    ld h,h              ;0889 64
    jr nz,l08c6h        ;088a 20 3a
    jr nz,l08aah        ;088c 20 1c
    ld b,c              ;088e 41
    ld l,20h            ;088f 2e 20
    jr nz,$+34          ;0891 20 20
    inc sp              ;0893 33
    jr nz,l08b6h        ;0894 20 20
    ld c,l              ;0896 4d
    ld h,d              ;0897 62
    ld a,c              ;0898 79
    ld (hl),h           ;0899 74
    ld h,l              ;089a 65
    jr nz,$+34          ;089b 20 20
    jr nz,$+34          ;089d 20 20
    jr nz,l08c1h        ;089f 20 20
    jr z,l08d4h         ;08a1 28 31
    add hl,sp           ;08a3 39
l08a4h:
    ld sp,6320h         ;08a4 31 20 63
    ld a,c              ;08a7 79
    ld l,h              ;08a8 6c
    add hl,hl           ;08a9 29
l08aah:
    inc e               ;08aa 1c
    ld b,d              ;08ab 42
l08ach:
    ld l,20h            ;08ac 2e 20
l08aeh:
    jr nz,l08d0h        ;08ae 20 20
    ld (hl),20h         ;08b0 36 20
    jr nz,l0901h        ;08b2 20 4d
    ld h,d              ;08b4 62
    ld a,c              ;08b5 79
l08b6h:
    ld (hl),h           ;08b6 74
    ld h,l              ;08b7 65
    jr nz,$+34          ;08b8 20 20
    jr nz,$+34          ;08ba 20 20
l08bch:
    jr nz,l08deh        ;08bc 20 20
    jr z,l08f1h         ;08be 28 31
    add hl,sp           ;08c0 39
l08c1h:
    ld sp,6320h         ;08c1 31 20 63
    ld a,c              ;08c4 79
    ld l,h              ;08c5 6c
l08c6h:
    add hl,hl           ;08c6 29
l08c7h:
    inc e               ;08c7 1c
    ld b,e              ;08c8 43
    ld l,20h            ;08c9 2e 20
    jr nz,l08edh        ;08cb 20 20
    ld sp,2032h         ;08cd 31 32 20
l08d0h:
    ld c,l              ;08d0 4d
    ld h,d              ;08d1 62
    ld a,c              ;08d2 79
l08d3h:
    ld (hl),h           ;08d3 74
l08d4h:
    ld h,l              ;08d4 65
    jr nz,$+34          ;08d5 20 20
    jr nz,$+34          ;08d7 20 20
    jr nz,$+34          ;08d9 20 20
l08dbh:
    jr z,l090eh         ;08db 28 31
    add hl,sp           ;08dd 39
l08deh:
    ld sp,6320h         ;08de 31 20 63
    ld a,c              ;08e1 79
    ld l,h              ;08e2 6c
    add hl,hl           ;08e3 29
l08e4h:
    inc e               ;08e4 1c
    ld b,h              ;08e5 44
    ld l,20h            ;08e6 2e 20
    jr nz,l090ah        ;08e8 20 20
    dec (hl)            ;08ea 35
    jr nz,l090dh        ;08eb 20 20
l08edh:
    ld c,l              ;08ed 4d
    ld h,d              ;08ee 62
l08efh:
    ld a,c              ;08ef 79
    ld (hl),h           ;08f0 74
l08f1h:
    ld h,l              ;08f1 65
    jr nz,$+34          ;08f2 20 20
    jr nz,$+34          ;08f4 20 20
    jr nz,$+34          ;08f6 20 20
    jr z,$+53           ;08f8 28 33
    ld (2030h),a        ;08fa 32 30 20
    ld h,e              ;08fd 63
    ld a,c              ;08fe 79
    ld l,h              ;08ff 6c
    add hl,hl           ;0900 29
l0901h:
    inc e               ;0901 1c
    ld b,l              ;0902 45
    ld l,20h            ;0903 2e 20
    jr nz,l0927h        ;0905 20 20
    ld sp,2030h         ;0907 31 30 20
l090ah:
    ld c,l              ;090a 4d
    ld h,d              ;090b 62
    ld a,c              ;090c 79
l090dh:
    ld (hl),h           ;090d 74
l090eh:
    ld h,l              ;090e 65
    jr nz,$+34          ;090f 20 20
    jr nz,$+34          ;0911 20 20
    jr nz,$+34          ;0913 20 20
    jr z,l094ah         ;0915 28 33
    ld (2030h),a        ;0917 32 30 20
    ld h,e              ;091a 63
    ld a,c              ;091b 79
    ld l,h              ;091c 6c
    add hl,hl           ;091d 29
l091eh:
    inc e               ;091e 1c
    ld b,(hl)           ;091f 46
    ld l,20h            ;0920 2e 20
    jr nz,l0944h        ;0922 20 20
    ld sp,2035h         ;0924 31 35 20
l0927h:
    ld c,l              ;0927 4d
    ld h,d              ;0928 62
    ld a,c              ;0929 79
    ld (hl),h           ;092a 74
    ld h,l              ;092b 65
    jr nz,l094eh        ;092c 20 20
    jr nz,l0950h        ;092e 20 20
    jr nz,l0952h        ;0930 20 20
    jr z,l0967h         ;0932 28 33
    ld (2030h),a        ;0934 32 30 20
    ld h,e              ;0937 63
    ld a,c              ;0938 79
    ld l,h              ;0939 6c
    add hl,hl           ;093a 29
l093bh:
    ld d,5ah            ;093b 16 5a
    ld l,20h            ;093d 2e 20
    jr nz,l0961h        ;093f 20 20
    ld c,(hl)           ;0941 4e
    ld l,a              ;0942 6f
    ld l,(hl)           ;0943 6e
l0944h:
    ld h,l              ;0944 65
    jr nz,l09b6h        ;0945 20 6f
    ld h,(hl)           ;0947 66
    jr nz,l09beh        ;0948 20 74
l094ah:
    ld l,b              ;094a 68
    ld h,l              ;094b 65
    jr nz,l09afh        ;094c 20 61
l094eh:
    ld h,d              ;094e 62
    ld l,a              ;094f 6f
l0950h:
    halt                ;0950 76
    ld h,l              ;0951 65
l0952h:
    add hl,de           ;0952 19
    ld d,a              ;0953 57
    ld l,b              ;0954 68
    ld l,c              ;0955 69
    ld h,e              ;0956 63
    ld l,b              ;0957 68
    jr nz,l09beh        ;0958 20 64
    ld (hl),d           ;095a 72
    ld l,c              ;095b 69
    halt                ;095c 76
    ld h,l              ;095d 65
    jr nz,$+118         ;095e 20 74
    ld a,c              ;0960 79
l0961h:
    ld (hl),b           ;0961 70
    ld h,l              ;0962 65
    jr nz,l098dh        ;0963 20 28
    ld b,c              ;0965 41
    dec l               ;0966 2d
l0967h:
    ld e,d              ;0967 5a
    add hl,hl           ;0968 29
    jr nz,l09aah        ;0969 20 3f
    jr nz,$+19          ;096b 20 11
    ld c,b              ;096d 48
    ld l,a              ;096e 6f
    ld (hl),a           ;096f 77
    jr nz,l09dfh        ;0970 20 6d
    ld h,c              ;0972 61
    ld l,(hl)           ;0973 6e
    ld a,c              ;0974 79
    jr nz,l09dfh        ;0975 20 68
    ld h,l              ;0977 65
    ld h,c              ;0978 61
    ld h,h              ;0979 64
    ld (hl),e           ;097a 73
    jr nz,$+65          ;097b 20 3f
    jr nz,$+23          ;097d 20 15
    ld c,b              ;097f 48
    ld l,a              ;0980 6f
    ld (hl),a           ;0981 77
    jr nz,l09f1h        ;0982 20 6d
    ld h,c              ;0984 61
    ld l,(hl)           ;0985 6e
    ld a,c              ;0986 79
    jr nz,l09ech        ;0987 20 63
    ld a,c              ;0989 79
    ld l,h              ;098a 6c
    ld l,c              ;098b 69
    ld l,(hl)           ;098c 6e
l098dh:
    ld h,h              ;098d 64
    ld h,l              ;098e 65
    ld (hl),d           ;098f 72
    ld (hl),e           ;0990 73
    jr nz,$+65          ;0991 20 3f
    jr nz,$+12          ;0993 20 0a
    ld b,h              ;0995 44
    ld (hl),d           ;0996 72
    ld l,c              ;0997 69
    halt                ;0998 76
    ld h,l              ;0999 65
    jr nz,l0a04h        ;099a 20 68
    ld h,c              ;099c 61
    ld (hl),e           ;099d 73
    jr nz,$+13          ;099e 20 0b
    jr nz,l0a0ah        ;09a0 20 68
    ld h,l              ;09a2 65
    ld h,c              ;09a3 61
    ld h,h              ;09a4 64
    ld (hl),e           ;09a5 73
    jr nz,l0a09h        ;09a6 20 61
    ld l,(hl)           ;09a8 6e
    ld h,h              ;09a9 64
l09aah:
    jr nz,$+13          ;09aa 20 0b
    jr nz,l0a11h        ;09ac 20 63
    ld a,c              ;09ae 79
l09afh:
    ld l,h              ;09af 6c
    ld l,c              ;09b0 69
    ld l,(hl)           ;09b1 6e
    ld h,h              ;09b2 64
    ld h,l              ;09b3 65
    ld (hl),d           ;09b4 72
    ld (hl),e           ;09b5 73
l09b6h:
    ld l,1ah            ;09b6 2e 1a
    ld d,h              ;09b8 54
    ld l,b              ;09b9 68
    ld h,l              ;09ba 65
    jr nz,l0a23h        ;09bb 20 66
    ld l,a              ;09bd 6f
l09beh:
    ld (hl),d           ;09be 72
    ld l,l              ;09bf 6d
    ld h,c              ;09c0 61
    ld (hl),h           ;09c1 74
    ld (hl),h           ;09c2 74
    ld h,l              ;09c3 65
    ld h,h              ;09c4 64
    jr nz,l0a2ah        ;09c5 20 63
    ld h,c              ;09c7 61
    ld (hl),b           ;09c8 70
    ld h,c              ;09c9 61
    ld h,e              ;09ca 63
    ld l,c              ;09cb 69
    ld (hl),h           ;09cc 74
    ld a,c              ;09cd 79
    jr nz,l0a39h        ;09ce 20 69
    ld (hl),e           ;09d0 73
    jr nz,$+10          ;09d1 20 08
    jr nz,l0a20h        ;09d3 20 4b
    ld h,d              ;09d5 62
    ld a,c              ;09d6 79
    ld (hl),h           ;09d7 74
    ld h,l              ;09d8 65
    ld (hl),e           ;09d9 73
    ld l,1ch            ;09da 2e 1c
    ld b,(hl)           ;09dc 46
    ld l,a              ;09dd 6f
    ld (hl),d           ;09de 72
l09dfh:
    ld l,l              ;09df 6d
    ld h,c              ;09e0 61
    ld (hl),h           ;09e1 74
    jr nz,l0a45h        ;09e2 20 61
    ld l,h              ;09e4 6c
    ld l,h              ;09e5 6c
    jr nz,l0a5bh        ;09e6 20 73
    ld (hl),l           ;09e8 75
    ld (hl),d           ;09e9 72
    ld h,(hl)           ;09ea 66
    ld h,c              ;09eb 61
l09ech:
    ld h,e              ;09ec 63
    ld h,l              ;09ed 65
    ld (hl),e           ;09ee 73
    jr nz,$+42          ;09ef 20 28
l09f1h:
    ld e,c              ;09f1 59
    cpl                 ;09f2 2f
    ld c,(hl)           ;09f3 4e
    add hl,hl           ;09f4 29
    jr nz,l0a36h        ;09f5 20 3f
    jr nz,$+29          ;09f7 20 1b
    ld b,(hl)           ;09f9 46
    ld l,a              ;09fa 6f
    ld (hl),d           ;09fb 72
    ld l,l              ;09fc 6d
    ld h,c              ;09fd 61
    ld (hl),h           ;09fe 74
    jr nz,l0a78h        ;09ff 20 77
    ld l,b              ;0a01 68
    ld l,c              ;0a02 69
    ld h,e              ;0a03 63
l0a04h:
    ld l,b              ;0a04 68
    jr nz,l0a7ah        ;0a05 20 73
    ld (hl),l           ;0a07 75
    ld (hl),d           ;0a08 72
l0a09h:
    ld h,(hl)           ;0a09 66
l0a0ah:
    ld h,c              ;0a0a 61
    ld h,e              ;0a0b 63
    ld h,l              ;0a0c 65
    jr nz,l0a37h        ;0a0d 20 28
    jr nc,l0a31h        ;0a0f 30 20
l0a11h:
    ld (hl),h           ;0a11 74
    ld l,a              ;0a12 6f
    jr nz,$+6           ;0a13 20 04
    add hl,hl           ;0a15 29
    jr nz,l0a57h        ;0a16 20 3f
    jr nz,l0a1ch        ;0a18 20 02
    ccf                 ;0a1a 3f
    ccf                 ;0a1b 3f
l0a1ch:
    ld e,46h            ;0a1c 1e 46
    ld l,a              ;0a1e 6f
    ld (hl),d           ;0a1f 72
l0a20h:
    ld l,l              ;0a20 6d
    ld h,c              ;0a21 61
    ld (hl),h           ;0a22 74
l0a23h:
    jr nz,l0a86h        ;0a23 20 61
    ld l,h              ;0a25 6c
    ld l,h              ;0a26 6c
    jr nz,l0a9dh        ;0a27 20 74
    ld (hl),d           ;0a29 72
l0a2ah:
    ld h,c              ;0a2a 61
    ld h,e              ;0a2b 63
    ld l,e              ;0a2c 6b
    ld (hl),e           ;0a2d 73
    jr nz,$+113         ;0a2e 20 6f
    ld l,(hl)           ;0a30 6e
l0a31h:
    jr nz,l0aa6h        ;0a31 20 73
    ld (hl),l           ;0a33 75
    ld (hl),d           ;0a34 72
    ld h,(hl)           ;0a35 66
l0a36h:
    ld h,c              ;0a36 61
l0a37h:
    ld h,e              ;0a37 63
    ld h,l              ;0a38 65
l0a39h:
    jr nz,$+37          ;0a39 20 23
l0a3bh:
    inc bc              ;0a3b 03
    jr nz,l0a7dh        ;0a3c 20 3f
    jr nz,$+27          ;0a3e 20 19
    ld b,(hl)           ;0a40 46
    ld l,a              ;0a41 6f
    ld (hl),d           ;0a42 72
    ld l,l              ;0a43 6d
    ld h,c              ;0a44 61
l0a45h:
    ld (hl),h           ;0a45 74
    jr nz,$+121         ;0a46 20 77
    ld l,b              ;0a48 68
    ld l,c              ;0a49 69
    ld h,e              ;0a4a 63
    ld l,b              ;0a4b 68
    jr nz,$+118         ;0a4c 20 74
    ld (hl),d           ;0a4e 72
    ld h,c              ;0a4f 61
    ld h,e              ;0a50 63
    ld l,e              ;0a51 6b
    jr nz,l0a7ch        ;0a52 20 28
    jr nc,l0a76h        ;0a54 30 20
    ld (hl),h           ;0a56 74
l0a57h:
    ld l,a              ;0a57 6f
    jr nz,$+6           ;0a58 20 04
    add hl,hl           ;0a5a 29
l0a5bh:
    jr nz,l0a9ch        ;0a5b 20 3f
    jr nz,l0a61h        ;0a5d 20 02
    ccf                 ;0a5f 3f
    ccf                 ;0a60 3f
l0a61h:
    rla                 ;0a61 17
    ld d,b              ;0a62 50
    ld l,h              ;0a63 6c
    ld h,l              ;0a64 65
    ld h,c              ;0a65 61
    ld (hl),e           ;0a66 73
    ld h,l              ;0a67 65
    jr nz,l0acbh        ;0a68 20 61
    ld l,(hl)           ;0a6a 6e
    ld (hl),e           ;0a6b 73
    ld (hl),a           ;0a6c 77
    ld h,l              ;0a6d 65
    ld (hl),d           ;0a6e 72
    jr nz,$+91          ;0a6f 20 59
    jr nz,l0ae2h        ;0a71 20 6f
    ld (hl),d           ;0a73 72
    jr nz,l0ac4h        ;0a74 20 4e
l0a76h:
    jr nz,l0ab2h        ;0a76 20 3a
l0a78h:
    jr nz,$+25          ;0a78 20 17
l0a7ah:
    ld d,b              ;0a7a 50
    ld l,h              ;0a7b 6c
l0a7ch:
    ld h,l              ;0a7c 65
l0a7dh:
    ld h,c              ;0a7d 61
    ld (hl),e           ;0a7e 73
    ld h,l              ;0a7f 65
    jr nz,$+99          ;0a80 20 61
    ld l,(hl)           ;0a82 6e
    ld (hl),e           ;0a83 73
    ld (hl),a           ;0a84 77
    ld h,l              ;0a85 65
l0a86h:
    ld (hl),d           ;0a86 72
    jr nz,l0ae2h        ;0a87 20 59
    jr nz,l0afah        ;0a89 20 6f
    ld (hl),d           ;0a8b 72
    jr nz,$+80          ;0a8c 20 4e
    jr nz,$+60          ;0a8e 20 3a
    jr nz,l0aaeh        ;0a90 20 1c
    ld d,b              ;0a92 50
    ld (hl),d           ;0a93 72
    ld h,l              ;0a94 65
    ld (hl),e           ;0a95 73
    ld (hl),e           ;0a96 73
    jr nz,$+116         ;0a97 20 72
    ld h,l              ;0a99 65
    ld (hl),h           ;0a9a 74
    ld (hl),l           ;0a9b 75
l0a9ch:
    ld (hl),d           ;0a9c 72
l0a9dh:
    ld l,(hl)           ;0a9d 6e
    jr nz,l0b14h        ;0a9e 20 74
    ld l,a              ;0aa0 6f
    jr nz,l0b09h        ;0aa1 20 66
    ld l,a              ;0aa3 6f
    ld (hl),d           ;0aa4 72
    ld l,l              ;0aa5 6d
l0aa6h:
    ld h,c              ;0aa6 61
    ld (hl),h           ;0aa7 74
    jr nz,l0b0eh        ;0aa8 20 64
    ld l,c              ;0aaa 69
    ld (hl),e           ;0aab 73
    ld l,e              ;0aac 6b
    inc l               ;0aad 2c
l0aaeh:
    dec e               ;0aae 1d
    ld (hl),b           ;0aaf 70
    ld (hl),d           ;0ab0 72
    ld h,l              ;0ab1 65
l0ab2h:
    ld (hl),e           ;0ab2 73
    ld (hl),e           ;0ab3 73
    jr nz,$+101         ;0ab4 20 63
    ld l,a              ;0ab6 6f
    ld l,(hl)           ;0ab7 6e
    ld (hl),h           ;0ab8 74
    ld (hl),d           ;0ab9 72
    ld l,a              ;0aba 6f
    ld l,h              ;0abb 6c
    dec l               ;0abc 2d
    ld b,e              ;0abd 43
    jr nz,l0b34h        ;0abe 20 74
    ld l,a              ;0ac0 6f
    jr nz,l0b24h        ;0ac1 20 61
    ld h,d              ;0ac3 62
l0ac4h:
    ld l,a              ;0ac4 6f
    ld (hl),d           ;0ac5 72
    ld (hl),h           ;0ac6 74
    jr nz,$+48          ;0ac7 20 2e
    ld l,2eh            ;0ac9 2e 2e
l0acbh:
    jr nz,l0adbh        ;0acb 20 0e
    ld b,(hl)           ;0acd 46
    ld l,a              ;0ace 6f
    ld (hl),d           ;0acf 72
    ld l,l              ;0ad0 6d
    ld h,c              ;0ad1 61
    ld (hl),h           ;0ad2 74
    ld (hl),h           ;0ad3 74
    ld l,c              ;0ad4 69
    ld l,(hl)           ;0ad5 6e
    ld h,a              ;0ad6 67
    jr nz,$+48          ;0ad7 20 2e
    ld l,2eh            ;0ad9 2e 2e
l0adbh:
    djnz l0b23h         ;0adb 10 46
    ld l,a              ;0add 6f
    ld (hl),d           ;0ade 72
    ld l,l              ;0adf 6d
    ld h,c              ;0ae0 61
    ld (hl),h           ;0ae1 74
l0ae2h:
    jr nz,l0b47h        ;0ae2 20 63
    ld l,a              ;0ae4 6f
    ld l,l              ;0ae5 6d
    ld (hl),b           ;0ae6 70
    ld l,h              ;0ae7 6c
    ld h,l              ;0ae8 65
    ld (hl),h           ;0ae9 74
    ld h,l              ;0aea 65
    ld l,0afh           ;0aeb 2e af
    ld h,a              ;0aed 67
    add a,b             ;0aee 80
    jp m,l0af9h         ;0aef fa f9 0a
    or c                ;0af2 b1
    jp z,l0b44h         ;0af3 ca 44 0b
    jp l0b00h           ;0af6 c3 00 0b
l0af9h:
    inc h               ;0af9 24
l0afah:
    cpl                 ;0afa 2f
    ld b,a              ;0afb 47
    ld a,c              ;0afc 79
    cpl                 ;0afd 2f
    ld c,a              ;0afe 4f
    inc bc              ;0aff 03
l0b00h:
    xor a               ;0b00 af
    add a,d             ;0b01 82
    jp m,l0b0ch         ;0b02 fa 0c 0b
    or e                ;0b05 b3
    jp z,l0b44h         ;0b06 ca 44 0b
l0b09h:
    jp l0b13h           ;0b09 c3 13 0b
l0b0ch:
    inc h               ;0b0c 24
    cpl                 ;0b0d 2f
l0b0eh:
    ld d,a              ;0b0e 57
    ld a,e              ;0b0f 7b
    cpl                 ;0b10 2f
    ld e,a              ;0b11 5f
    inc de              ;0b12 13
l0b13h:
    push hl             ;0b13 e5
l0b14h:
    ld a,c              ;0b14 79
    sub e               ;0b15 93
    ld a,b              ;0b16 78
    sbc a,d             ;0b17 9a
    jp p,l0b20h         ;0b18 f2 20 0b
    ld h,b              ;0b1b 60
    ld l,c              ;0b1c 69
    ex de,hl            ;0b1d eb
    ld b,h              ;0b1e 44
    ld c,l              ;0b1f 4d
l0b20h:
    ld hl,0000h         ;0b20 21 00 00
l0b23h:
    ex de,hl            ;0b23 eb
l0b24h:
    ld a,b              ;0b24 78
    or c                ;0b25 b1
    jp z,l0b39h         ;0b26 ca 39 0b
    ld a,b              ;0b29 78
    rra                 ;0b2a 1f
    ld b,a              ;0b2b 47
    ld a,c              ;0b2c 79
    rra                 ;0b2d 1f
    ld c,a              ;0b2e 4f
    jp nc,l0b35h        ;0b2f d2 35 0b
    ex de,hl            ;0b32 eb
    add hl,de           ;0b33 19
l0b34h:
    ex de,hl            ;0b34 eb
l0b35h:
    add hl,hl           ;0b35 29
    jp l0b24h           ;0b36 c3 24 0b
l0b39h:
    pop af              ;0b39 f1
    rra                 ;0b3a 1f
    ret nc              ;0b3b d0
    ld a,d              ;0b3c 7a
    cpl                 ;0b3d 2f
    ld d,a              ;0b3e 57
    ld a,e              ;0b3f 7b
    cpl                 ;0b40 2f
    ld e,a              ;0b41 5f
    inc de              ;0b42 13
    ret                 ;0b43 c9
l0b44h:
    ld de,0000h         ;0b44 11 00 00
l0b47h:
    ret                 ;0b47 c9
sub_0b48h:
    xor a               ;0b48 af
    ld h,b              ;0b49 60
    ld l,c              ;0b4a 69
    ld b,a              ;0b4b 47
    add a,d             ;0b4c 82
    jp m,l0b55h         ;0b4d fa 55 0b
    or e                ;0b50 b3
    jp nz,l0b5dh        ;0b51 c2 5d 0b
    ret                 ;0b54 c9
l0b55h:
    inc b               ;0b55 04
    ld a,d              ;0b56 7a
    cpl                 ;0b57 2f
    ld d,a              ;0b58 57
    ld a,e              ;0b59 7b
    cpl                 ;0b5a 2f
    ld e,a              ;0b5b 5f
    inc de              ;0b5c 13
l0b5dh:
    xor a               ;0b5d af
    add a,h             ;0b5e 84
    jp m,l0b6ah         ;0b5f fa 6a 0b
    or l                ;0b62 b5
    jp nz,l0b75h        ;0b63 c2 75 0b
    ld bc,0000h         ;0b66 01 00 00
    ret                 ;0b69 c9
l0b6ah:
    ld a,b              ;0b6a 78
    or 02h              ;0b6b f6 02
    ld b,a              ;0b6d 47
    ld a,h              ;0b6e 7c
    cpl                 ;0b6f 2f
    ld h,a              ;0b70 67
    ld a,l              ;0b71 7d
    cpl                 ;0b72 2f
    ld l,a              ;0b73 6f
    inc hl              ;0b74 23
l0b75h:
    push bc             ;0b75 c5
    ld a,01h            ;0b76 3e 01
    push af             ;0b78 f5
    ld bc,0000h         ;0b79 01 00 00
    xor a               ;0b7c af
    add a,d             ;0b7d 82
    jp m,l0b8eh         ;0b7e fa 8e 0b
    ex de,hl            ;0b81 eb
l0b82h:
    pop af              ;0b82 f1
    inc a               ;0b83 3c
    push af             ;0b84 f5
    add hl,hl           ;0b85 29
    ld a,h              ;0b86 7c
    cp 00h              ;0b87 fe 00
    jp p,l0b82h         ;0b89 f2 82 0b
    ex de,hl            ;0b8c eb
    xor a               ;0b8d af
l0b8eh:
    ld a,c              ;0b8e 79
    rla                 ;0b8f 17
    ld c,a              ;0b90 4f
    ld a,b              ;0b91 78
    rla                 ;0b92 17
    ld b,a              ;0b93 47
    ld a,l              ;0b94 7d
    sub e               ;0b95 93
    ld l,a              ;0b96 6f
    ld a,h              ;0b97 7c
    sbc a,d             ;0b98 9a
    ld h,a              ;0b99 67
    jp c,l0ba1h         ;0b9a da a1 0b
    inc bc              ;0b9d 03
    jp l0ba2h           ;0b9e c3 a2 0b
l0ba1h:
    add hl,de           ;0ba1 19
l0ba2h:
    pop af              ;0ba2 f1
    dec a               ;0ba3 3d
    jp z,l0bb2h         ;0ba4 ca b2 0b
    push af             ;0ba7 f5
    xor a               ;0ba8 af
    ld a,d              ;0ba9 7a
    rra                 ;0baa 1f
    ld d,a              ;0bab 57
    ld a,e              ;0bac 7b
    rra                 ;0bad 1f
    ld e,a              ;0bae 5f
    jp l0b8eh           ;0baf c3 8e 0b
l0bb2h:
    xor a               ;0bb2 af
    ld a,d              ;0bb3 7a
    rra                 ;0bb4 1f
    ld d,a              ;0bb5 57
    ld a,e              ;0bb6 7b
    rra                 ;0bb7 1f
    ld e,a              ;0bb8 5f
    pop af              ;0bb9 f1
    push af             ;0bba f5
    rra                 ;0bbb 1f
    rra                 ;0bbc 1f
    jp nc,l0bc7h        ;0bbd d2 c7 0b
    ld a,h              ;0bc0 7c
    cpl                 ;0bc1 2f
    ld h,a              ;0bc2 67
    ld a,l              ;0bc3 7d
    cpl                 ;0bc4 2f
    ld l,a              ;0bc5 6f
    inc hl              ;0bc6 23
l0bc7h:
    pop af              ;0bc7 f1
    inc a               ;0bc8 3c
    rra                 ;0bc9 1f
    rra                 ;0bca 1f
    ret nc              ;0bcb d0
    ld a,b              ;0bcc 78
    cpl                 ;0bcd 2f
    ld b,a              ;0bce 47
    ld a,c              ;0bcf 79
    cpl                 ;0bd0 2f
    ld c,a              ;0bd1 4f
    inc bc              ;0bd2 03
    ret                 ;0bd3 c9
sub_0bd4h:
    pop hl              ;0bd4 e1
    push bc             ;0bd5 c5
    push de             ;0bd6 d5
    ld a,08h            ;0bd7 3e 08
    add a,(hl)          ;0bd9 86
    ld e,a              ;0bda 5f
    inc hl              ;0bdb 23
    xor a               ;0bdc af
    ld b,a              ;0bdd 47
    sub (hl)            ;0bde 96
    jp z,l0be3h         ;0bdf ca e3 0b
    dec b               ;0be2 05
l0be3h:
    ld c,a              ;0be3 4f
    ld a,e              ;0be4 7b
    push hl             ;0be5 e5
    ld hl,0000h         ;0be6 21 00 00
    add hl,sp           ;0be9 39
    ld d,h              ;0bea 54
    ld e,l              ;0beb 5d
    add hl,bc           ;0bec 09
    ld sp,hl            ;0bed f9
l0beeh:
    or a                ;0bee b7
    jp z,l0bfch         ;0bef ca fc 0b
    ex de,hl            ;0bf2 eb
    ld c,(hl)           ;0bf3 4e
    ex de,hl            ;0bf4 eb
    ld (hl),c           ;0bf5 71
    inc hl              ;0bf6 23
    inc de              ;0bf7 13
    dec a               ;0bf8 3d
    jp l0beeh           ;0bf9 c3 ee 0b
l0bfch:
    pop hl              ;0bfc e1
    ld a,(hl)           ;0bfd 7e
    inc hl              ;0bfe 23
    ld c,(hl)           ;0bff 4e
    inc hl              ;0c00 23
    ld b,(hl)           ;0c01 46
    inc hl              ;0c02 23
    push bc             ;0c03 c5
    ex (sp),hl          ;0c04 e3
l0c05h:
    or a                ;0c05 b7
    jp z,l0c13h         ;0c06 ca 13 0c
    dec de              ;0c09 1b
    ld c,(hl)           ;0c0a 4e
    ex de,hl            ;0c0b eb
    ld (hl),c           ;0c0c 71
    ex de,hl            ;0c0d eb
    inc hl              ;0c0e 23
    dec a               ;0c0f 3d
    jp l0c05h           ;0c10 c3 05 0c
l0c13h:
    pop hl              ;0c13 e1
    pop de              ;0c14 d1
    pop bc              ;0c15 c1
    jp (hl)             ;0c16 e9
sub_0c17h:
    ex (sp),hl          ;0c17 e3
    push af             ;0c18 f5
    ld a,(hl)           ;0c19 7e
    inc hl              ;0c1a 23
    ld e,(hl)           ;0c1b 5e
    inc hl              ;0c1c 23
    ld d,(hl)           ;0c1d 56
    ld hl,0006h         ;0c1e 21 06 00
    ld b,h              ;0c21 44
    ld c,a              ;0c22 4f
    add hl,sp           ;0c23 39
    ex de,hl            ;0c24 eb
    add hl,bc           ;0c25 09
l0c26h:
    or a                ;0c26 b7
    jp z,l0c34h         ;0c27 ca 34 0c
    dec hl              ;0c2a 2b
    ex de,hl            ;0c2b eb
    ld c,(hl)           ;0c2c 4e
    ex de,hl            ;0c2d eb
    ld (hl),c           ;0c2e 71
    inc de              ;0c2f 13
    dec a               ;0c30 3d
    jp l0c26h           ;0c31 c3 26 0c
l0c34h:
    ex de,hl            ;0c34 eb
    pop af              ;0c35 f1
    pop de              ;0c36 d1
    pop bc              ;0c37 c1
    ld sp,hl            ;0c38 f9
    push bc             ;0c39 c5
    ex de,hl            ;0c3a eb
    ret                 ;0c3b c9
l0c3ch:
    nop                 ;0c3c 00
l0c3dh:
    nop                 ;0c3d 00
l0c3eh:
    nop                 ;0c3e 00
l0c3fh:
    nop                 ;0c3f 00
l0c40h:
    nop                 ;0c40 00
    nop                 ;0c41 00
l0c42h:
    nop                 ;0c42 00
    nop                 ;0c43 00
l0c44h:
    nop                 ;0c44 00
    nop                 ;0c45 00
    nop                 ;0c46 00
    nop                 ;0c47 00
l0c48h:
    nop                 ;0c48 00
    nop                 ;0c49 00
l0c4ah:
    nop                 ;0c4a 00
l0c4bh:
    nop                 ;0c4b 00
l0c4ch:
    nop                 ;0c4c 00
l0c4dh:
    nop                 ;0c4d 00
l0c4eh:
    nop                 ;0c4e 00
l0c4fh:
    nop                 ;0c4f 00
    nop                 ;0c50 00
    nop                 ;0c51 00
    nop                 ;0c52 00
    nop                 ;0c53 00
    nop                 ;0c54 00
    nop                 ;0c55 00
    nop                 ;0c56 00
    nop                 ;0c57 00
    nop                 ;0c58 00
    nop                 ;0c59 00
    nop                 ;0c5a 00
    nop                 ;0c5b 00
    nop                 ;0c5c 00
    nop                 ;0c5d 00
    nop                 ;0c5e 00
    nop                 ;0c5f 00
    nop                 ;0c60 00
    nop                 ;0c61 00
    nop                 ;0c62 00
    nop                 ;0c63 00
    nop                 ;0c64 00
    nop                 ;0c65 00
    nop                 ;0c66 00
    nop                 ;0c67 00
    nop                 ;0c68 00
    nop                 ;0c69 00
    nop                 ;0c6a 00
    nop                 ;0c6b 00
    nop                 ;0c6c 00
    nop                 ;0c6d 00
    nop                 ;0c6e 00
    nop                 ;0c6f 00
    nop                 ;0c70 00
    nop                 ;0c71 00
    nop                 ;0c72 00
    nop                 ;0c73 00
    nop                 ;0c74 00
    nop                 ;0c75 00
    nop                 ;0c76 00
    nop                 ;0c77 00
    nop                 ;0c78 00
    nop                 ;0c79 00
    nop                 ;0c7a 00
    nop                 ;0c7b 00
    nop                 ;0c7c 00
    nop                 ;0c7d 00
    nop                 ;0c7e 00
    nop                 ;0c7f 00
    nop                 ;0c80 00
    nop                 ;0c81 00
    nop                 ;0c82 00
    nop                 ;0c83 00
    nop                 ;0c84 00
    nop                 ;0c85 00
    nop                 ;0c86 00
    nop                 ;0c87 00
    nop                 ;0c88 00
    nop                 ;0c89 00
    nop                 ;0c8a 00
    nop                 ;0c8b 00
    nop                 ;0c8c 00
    nop                 ;0c8d 00
    nop                 ;0c8e 00
    nop                 ;0c8f 00
    nop                 ;0c90 00
    nop                 ;0c91 00
    nop                 ;0c92 00
    nop                 ;0c93 00
    nop                 ;0c94 00
    nop                 ;0c95 00
    nop                 ;0c96 00
    nop                 ;0c97 00
    nop                 ;0c98 00
    nop                 ;0c99 00
    nop                 ;0c9a 00
    nop                 ;0c9b 00
    nop                 ;0c9c 00
    nop                 ;0c9d 00
    nop                 ;0c9e 00
    nop                 ;0c9f 00
    nop                 ;0ca0 00
    nop                 ;0ca1 00
    nop                 ;0ca2 00
    nop                 ;0ca3 00
    nop                 ;0ca4 00
    nop                 ;0ca5 00
    nop                 ;0ca6 00
    nop                 ;0ca7 00
    nop                 ;0ca8 00
    nop                 ;0ca9 00
    nop                 ;0caa 00
    nop                 ;0cab 00
    nop                 ;0cac 00
    nop                 ;0cad 00
    nop                 ;0cae 00
    nop                 ;0caf 00
    nop                 ;0cb0 00
    nop                 ;0cb1 00
    nop                 ;0cb2 00
    nop                 ;0cb3 00
    nop                 ;0cb4 00
    nop                 ;0cb5 00
    nop                 ;0cb6 00
    nop                 ;0cb7 00
    nop                 ;0cb8 00
    nop                 ;0cb9 00
    nop                 ;0cba 00
    nop                 ;0cbb 00
    nop                 ;0cbc 00
    nop                 ;0cbd 00
    nop                 ;0cbe 00
    nop                 ;0cbf 00
    nop                 ;0cc0 00
    nop                 ;0cc1 00
    nop                 ;0cc2 00
    nop                 ;0cc3 00
    nop                 ;0cc4 00
    nop                 ;0cc5 00
    nop                 ;0cc6 00
    nop                 ;0cc7 00
    nop                 ;0cc8 00
    nop                 ;0cc9 00
    nop                 ;0cca 00
    nop                 ;0ccb 00
    nop                 ;0ccc 00
    nop                 ;0ccd 00
    nop                 ;0cce 00
    nop                 ;0ccf 00
l0cd0h:
    nop                 ;0cd0 00
l0cd1h:
    nop                 ;0cd1 00
l0cd2h:
    nop                 ;0cd2 00
l0cd3h:
    nop                 ;0cd3 00
l0cd4h:
    nop                 ;0cd4 00
l0cd5h:
    nop                 ;0cd5 00
l0cd6h:
    nop                 ;0cd6 00
l0cd7h:
    nop                 ;0cd7 00
l0cd8h:
    nop                 ;0cd8 00
l0cd9h:
    nop                 ;0cd9 00
l0cdah:
    nop                 ;0cda 00
l0cdbh:
    nop                 ;0cdb 00
l0cdch:
    nop                 ;0cdc 00
l0cddh:
    nop                 ;0cdd 00
l0cdeh:
    nop                 ;0cde 00
    ld a,(de)           ;0cdf 1a
    ld a,(de)           ;0ce0 1a
    ld a,(de)           ;0ce1 1a
    ld a,(de)           ;0ce2 1a
    ld a,(de)           ;0ce3 1a
    ld a,(de)           ;0ce4 1a
    ld a,(de)           ;0ce5 1a
    ld a,(de)           ;0ce6 1a
    ld a,(de)           ;0ce7 1a
    ld a,(de)           ;0ce8 1a
    ld a,(de)           ;0ce9 1a
    ld a,(de)           ;0cea 1a
    ld a,(de)           ;0ceb 1a
    ld a,(de)           ;0cec 1a
    ld a,(de)           ;0ced 1a
    ld a,(de)           ;0cee 1a
    ld a,(de)           ;0cef 1a
    ld a,(de)           ;0cf0 1a
    ld a,(de)           ;0cf1 1a
    ld a,(de)           ;0cf2 1a
    ld a,(de)           ;0cf3 1a
    ld a,(de)           ;0cf4 1a
    ld a,(de)           ;0cf5 1a
    ld a,(de)           ;0cf6 1a
    ld a,(de)           ;0cf7 1a
    ld a,(de)           ;0cf8 1a
    ld a,(de)           ;0cf9 1a
    ld a,(de)           ;0cfa 1a
    ld a,(de)           ;0cfb 1a
    ld a,(de)           ;0cfc 1a
    ld a,(de)           ;0cfd 1a
    ld a,(de)           ;0cfe 1a
    ld a,(de)           ;0cff 1a
