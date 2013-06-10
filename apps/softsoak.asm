;SOFTSOAK.COM
;  Perform a soak (burn-in) test on the SoftBox.
;
;Usage:
;  "SOFTSOAK"
;

    org 0100h

ppi1:     equ 10h       ;8255 PPI #1 (IC17)
ppi1_pa:  equ ppi1+0    ;  Port A: IEEE-488 Data In
ppi1_pb:  equ ppi1+1    ;  Port B: IEEE-488 Data Out
ppi1_pc:  equ ppi1+2    ;  Port C: DIP Switches
ppi1_cr:  equ ppi1+3    ;  Control Register

ppi2:     equ 14h       ;8255 PPI #2 (IC16)
ppi2_pa:  equ ppi2+0    ;  Port A:
                        ;    PA7 IEEE-488 IFC in
                        ;    PA6 IEEE-488 REN in
                        ;    PA5 IEEE-488 SRQ in
                        ;    PA4 IEEE-488 EOI in
                        ;    PA3 IEEE-488 NRFD in
                        ;    PA2 IEEE-488 NDAC in
                        ;    PA1 IEEE-488 DAV in
                        ;    PA0 IEEE-488 ATN in
ppi2_pb:  equ ppi2+1    ;  Port B:
                        ;    PB7 IEEE-488 IFC out
                        ;    PB6 IEEE-488 REN out
                        ;    PB5 IEEE-488 SRQ out
                        ;    PB4 IEEE-488 EOI out
                        ;    PB3 IEEE-488 NRFD out
                        ;    PB2 IEEE-488 NDAC out
                        ;    PB1 IEEE-488 DAV out
                        ;    PB0 IEEE-488 ATN out
ppi2_pc:  equ ppi2+2    ;  Port C:
                        ;    PC7 Unused
                        ;    PC6 Unused
                        ;    PC5 Corvus ACTIVE
                        ;    PC4 Corvus READY
                        ;    PC3 Unused
                        ;    PC2 LED "Ready"
                        ;    PC1 LED "B"
                        ;    PC0 LED "A"
ppi2_cr:  equ ppi2+3    ;  Control Register


l0100h:
    nop                 ;0100 00
    nop                 ;0101 00
    nop                 ;0102 00
    ld sp,l0100h        ;0103 31 00 01
    ld a,99h            ;0106 3e 99
    out (ppi1_cr),a     ;0108 d3 13
    ld a,98h            ;010a 3e 98
    out (ppi2_cr),a     ;010c d3 17
    ex (sp),hl          ;010e e3
    rst 38h             ;010f ff
    out (ppi2_pc),a     ;0110 d3 16
    xor a               ;0112 af
    out (ppi1_pb),a     ;0113 d3 11
    ld a,80h            ;0115 3e 80
    out (ppi2_pb),a     ;0117 d3 15
l0119h:
    call sub_02c7h      ;0119 cd c7 02
    ld hl,0f000h        ;011c 21 00 f0
    ld bc,00ffdh        ;011f 01 fd 0f
    call sub_02ceh      ;0122 cd ce 02
    ld c,03h            ;0125 0e 03
    ld hl,0fffdh        ;0127 21 fd ff
    cp (hl)             ;012a be
    jr z,l0142h         ;012b 28 15
    call sub_02c7h      ;012d cd c7 02
    ld hl,0f000h        ;0130 21 00 f0
    ld bc,00fffh        ;0133 01 ff 0f
    call sub_02ceh      ;0136 cd ce 02
    ld c,03h            ;0139 0e 03
    ld hl,0ffffh        ;013b 21 ff ff
    cp (hl)             ;013e be
    jp nz,l029ah        ;013f c2 9a 02
l0142h:
    ld c,05h            ;0142 0e 05
    ld d,00h            ;0144 16 00
l0146h:
    ld a,d              ;0146 7a
    and 0fh             ;0147 e6 0f
    call z,sub_02c7h    ;0149 cc c7 02
    ld b,00h            ;014c 06 00
l014eh:
    ld a,b              ;014e 78
    out (ppi1_pb),a     ;014f d3 11
    in a,(ppi1_pa)      ;0151 db 10
    cp b                ;0153 b8
    jp nz,l029ah        ;0154 c2 9a 02
    ld a,b              ;0157 78
    and 01eh            ;0158 e6 1e
    out (ppi2_pb),a     ;015a d3 15
    in a,(ppi2_pa)      ;015c db 14
    xor b               ;015e a8
    and 1eh             ;015f e6 1e
    jp nz,l029ah        ;0161 c2 9a 02
    djnz l014eh         ;0164 10 e8
    inc d               ;0166 14
    jr nz,l0146h        ;0167 20 dd
    call sub_02c7h      ;0169 cd c7 02
    ld hl,l0300h        ;016c 21 00 03
    ld de,0ed00h        ;016f 11 00 ed
l0172h:
    ld (hl),l           ;0172 75
    inc hl              ;0173 23
    dec de              ;0174 1b
    ld a,e              ;0175 7b
    or d                ;0176 b2
    jr nz,l0172h        ;0177 20 f9
    ld b,0ah            ;0179 06 0a
l017bh:
    call sub_02c7h      ;017b cd c7 02
    push bc             ;017e c5
    ld bc,0064h         ;017f 01 64 00
    call 02dah          ;0182 cd da 02
    pop bc              ;0185 c1
    djnz l017bh         ;0186 10 f3
    call sub_02c7h      ;0188 cd c7 02
    ld hl,l0300h        ;018b 21 00 03
    ld de,0ed00h        ;018e 11 00 ed
    ld c,02h            ;0191 0e 02
l0193h:
    ld a,(hl)           ;0193 7e
    cp l                ;0194 bd
    jp nz,l029ah        ;0195 c2 9a 02
    cpl                 ;0198 2f
    ld (hl),a           ;0199 77
    inc hl              ;019a 23
    dec de              ;019b 1b
    ld a,e              ;019c 7b
    or d                ;019d b2
    jr nz,l0193h        ;019e 20 f3
    ld b,0ah            ;01a0 06 0a
l01a2h:
    call sub_02c7h      ;01a2 cd c7 02
    push bc             ;01a5 c5
    ld bc,0064h         ;01a6 01 64 00
    call 02dah          ;01a9 cd da 02
    pop bc              ;01ac c1
    djnz l01a2h         ;01ad 10 f3
    call sub_02c7h      ;01af cd c7 02
    ld hl,l0300h        ;01b2 21 00 03
    ld de,0ed00h        ;01b5 11 00 ed
    ld c,02h            ;01b8 0e 02
l01bah:
    ld a,(hl)           ;01ba 7e
    cpl                 ;01bb 2f
    cp l                ;01bc bd
    jp nz,l029ah        ;01bd c2 9a 02
    inc hl              ;01c0 23
    dec de              ;01c1 1b
    ld a,e              ;01c2 7b
    or d                ;01c3 b2
    jr nz,l01bah        ;01c4 20 f4
    call sub_02c7h      ;01c6 cd c7 02
    ld a,0feh           ;01c9 3e fe
    ld (l0299h),a       ;01cb 32 99 02
    ld c,01h            ;01ce 0e 01
    ld de,0efffh        ;01d0 11 ff ef
l01d3h:
    ld b,01h            ;01d3 06 01
l01d5h:
    ld hl,l0300h        ;01d5 21 00 03
    push bc             ;01d8 c5
l01d9h:
    call sub_023dh      ;01d9 cd 3d 02
    ld (hl),a           ;01dc 77
    inc hl              ;01dd 23
    ld a,h              ;01de 7c
    and 03h             ;01df e6 03
    or l                ;01e1 b5
    call z,sub_02c7h    ;01e2 cc c7 02
    ld a,l              ;01e5 7d
    cp e                ;01e6 bb
    jr nz,l01d9h        ;01e7 20 f0
    ld a,h              ;01e9 7c
    cp d                ;01ea ba
    jr nz,l01d9h        ;01eb 20 ec
    pop bc              ;01ed c1
    djnz l01d5h         ;01ee 10 e5
    ld b,01h            ;01f0 06 01
    call sub_02c7h      ;01f2 cd c7 02
    ld hl,l0300h        ;01f5 21 00 03
    push bc             ;01f8 c5
    call sub_023dh      ;01f9 cd 3d 02
    ld b,a              ;01fc 47
    ld a,(hl)           ;01fd 7e
    cp b                ;01fe b8
    jp nz,l0294h        ;01ff c2 94 02
    sub (hl)            ;0202 96
    add a,(hl)          ;0203 86
    sub (hl)            ;0204 96
    add a,(hl)          ;0205 86
    sub (hl)            ;0206 96
    add a,(hl)          ;0207 86
    sub (hl)            ;0208 96
    add a,(hl)          ;0209 86
    sub (hl)            ;020a 96
    add a,(hl)          ;020b 86
    sub (hl)            ;020c 96
    add a,(hl)          ;020d 86
    sub (hl)            ;020e 96
    add a,(hl)          ;020f 86
    sub (hl)            ;0210 96
    add a,(hl)          ;0211 86
    cp b                ;0212 b8
    jp nz,l0294h        ;0213 c2 94 02
    inc hl              ;0216 23
    ld a,h              ;0217 7c
    and 03h             ;0218 e6 03
    or l                ;021a b5
    call z,sub_02c7h    ;021b cc c7 02
    ld a,l              ;021e 7d
    cp e                ;021f bb
    defb 0edh           ;next byte illegal after ed
    ld c,02h            ;0221 0e 02
l0223h:
    ld a,(hl)           ;0223 7e
    cp l                ;0224 bd
    jp nz,l029ah        ;0225 c2 9a 02
    cpl                 ;0228 2f
    ld (hl),a           ;0229 77
    inc hl              ;022a 23
    dec de              ;022b 1b
    ld a,e              ;022c 7b
    or d                ;022d b2
    jr nz,l0223h        ;022e 20 f3
    ld b,0ah            ;0230 06 0a
l0232h:
    call sub_02c7h      ;0232 cd c7 02
    push bc             ;0235 c5
    ld bc,0064h         ;0236 01 64 00
    call 02dah          ;0239 cd da 02
    pop bc              ;023c c1
sub_023dh:
    djnz l0232h         ;023d 10 f3
    call sub_02c7h      ;023f cd c7 02
    ld hl,l0300h        ;0242 21 00 03
l0245h:
    ld de,0ed00h        ;0245 11 00 ed
    ld c,02h            ;0248 0e 02
l024ah:
    ld a,(hl)           ;024a 7e
    cpl                 ;024b 2f
    cp l                ;024c bd
    jp nz,l029ah        ;024d c2 9a 02
    inc hl              ;0250 23
    dec de              ;0251 1b
    ld a,e              ;0252 7b
    or d                ;0253 b2
    jr nz,l024ah        ;0254 20 f4
    call sub_02c7h      ;0256 cd c7 02
    ld a,0feh           ;0259 3e fe
    ld (l0299h),a       ;025b 32 99 02
    ld c,01h            ;025e 0e 01
    ld de,0efffh        ;0260 11 ff ef
    ld b,01h            ;0263 06 01
l0265h:
    ld hl,l0300h        ;0265 21 00 03
    push bc             ;0268 c5
l0269h:
    call sub_023dh      ;0269 cd 3d 02
    ld (hl),a           ;026c 77
    inc hl              ;026d 23
    ld a,h              ;026e 7c
    and 03h             ;026f e6 03
    or l                ;0271 b5
    call z,sub_02c7h    ;0272 cc c7 02
    ld a,l              ;0275 7d
    cp e                ;0276 bb
    jr nz,l0269h        ;0277 20 f0
    ld a,h              ;0279 7c
    cp d                ;027a ba
    jr nz,l0269h        ;027b 20 ec
    pop bc              ;027d c1
    djnz l0265h         ;027e 10 e5
    ld b,01h            ;0280 06 01
    call sub_02c7h      ;0282 cd c7 02
l0285h:
    ld hl,l0300h        ;0285 21 00 03
    push bc             ;0288 c5
l0289h:
    call sub_023dh      ;0289 cd 3d 02
    ld b,a              ;028c 47
    ld a,(hl)           ;028d 7e
    cp b                ;028e b8
    jp nz,l0294h        ;028f c2 94 02
    sub (hl)            ;0292 96
    add a,(hl)          ;0293 86
l0294h:
    sub (hl)            ;0294 96
    add a,(hl)          ;0295 86
    sub (hl)            ;0296 96
    add a,(hl)          ;0297 86
    sub (hl)            ;0298 96
l0299h:
    add a,(hl)          ;0299 86
l029ah:
    sub (hl)            ;029a 96
    add a,(hl)          ;029b 86
    sub (hl)            ;029c 96
    add a,(hl)          ;029d 86
    sub (hl)            ;029e 96
    add a,(hl)          ;029f 86
    sub (hl)            ;02a0 96
    add a,(hl)          ;02a1 86
    cp b                ;02a2 b8
    jp nz,l0294h        ;02a3 c2 94 02
    inc hl              ;02a6 23
    ld a,h              ;02a7 7c
    and 03h             ;02a8 e6 03
    or l                ;02aa b5
    call z,sub_02c7h    ;02ab cc c7 02
    ld a,l              ;02ae 7d
    cp e                ;02af bb
    jr nz,l0289h        ;02b0 20 d7
    ld a,h              ;02b2 7c
    cp d                ;02b3 ba
    jr nz,l0289h        ;02b4 20 d3
    pop bc              ;02b6 c1
    djnz l0285h         ;02b7 10 cc
    call sub_02c7h      ;02b9 cd c7 02
    inc c               ;02bc 0c
    ld a,c              ;02bd 79
    cp 0bh              ;02be fe 0b
    jp nz,l01d3h        ;02c0 c2 d3 01
    ld a,(l0299h)       ;02c3 3a 99 02
    rrca                ;02c6 0f
sub_02c7h:
    ld (l0299h),a       ;02c7 32 99 02
    jp l0119h           ;02ca c3 19 01
    push hl             ;02cd e5
sub_02ceh:
    ld b,00h            ;02ce 06 00
    ld hl,l0245h        ;02d0 21 45 02
    add hl,bc           ;02d3 09
    add hl,bc           ;02d4 09
    ex (sp),hl          ;02d5 e3
    ret                 ;02d6 c9

    jr l02ebh           ;02d7 18 12
    jr l02f9h           ;02d9 18 1e
    jr l02fbh           ;02db 18 1e
    jr l02feh           ;02dd 18 1f
    jr l0301h           ;02df 18 20
    jr l02f6h           ;02e1 18 13
    jr l0304h           ;02e3 18 1f
    jr l02f4h           ;02e5 18 0d
    jr l030fh           ;02e7 18 26
    jr l031ch           ;02e9 18 31
l02ebh:
    ld a,l              ;02eb 7d
    rrca                ;02ec 0f
    rrca                ;02ed 0f
    rrca                ;02ee 0f
    xor h               ;02ef ac
    and 01h             ;02f0 e6 01
    jr z,l02f6h         ;02f2 28 02
l02f4h:
    xor a               ;02f4 af
    ret                 ;02f5 c9
l02f6h:
    ld a,0ffh           ;02f6 3e ff
    ret                 ;02f8 c9
l02f9h:
    ld a,l              ;02f9 7d
    ret                 ;02fa c9
l02fbh:
    ld a,0aah           ;02fb 3e aa
    ret                 ;02fd c9
l02feh:
    ld a,l              ;02fe 7d
    cpl                 ;02ff 2f
l0300h:
    ret                 ;0300 c9
l0301h:
    ld a,55h            ;0301 3e 55
    ret                 ;0303 c9
l0304h:
    ld a,l              ;0304 7d
    rrca                ;0305 0f
    rrca                ;0306 0f
    rrca                ;0307 0f
    xor h               ;0308 ac
    and 01h             ;0309 e6 01
    jr z,l02f4h         ;030b 28 e7
    jr l02f6h           ;030d 18 e7
l030fh:
    ld a,l              ;030f 7d
    rra                 ;0310 1f
    jr c,l0317h         ;0311 38 04
    ld a,(l0299h)       ;0313 3a 99 02
    ret                 ;0316 c9
l0317h:
    ld a,(l0299h)       ;0317 3a 99 02
    cpl                 ;031a 2f
    ret                 ;031b c9
l031ch:
    ld a,l              ;031c 7d
    rra                 ;031d 1f
    jr nc,l0317h        ;031e 30 f7
    ld a,(l0299h)       ;0320 3a 99 02
    ret                 ;0323 c9
    ld c,04h            ;0324 0e 04
    jp l029ah           ;0326 c3 9a 02
    call 043eh          ;0329 cd 3e 04
    sbc a,16h           ;032c de 16
    halt                ;032e 76
    ld b,c              ;032f 41
l0330h:
    xor a               ;0330 af
    sbc a,16h           ;0331 de 16
    ld de,0ffffh        ;0333 11 ff ff
l0336h:
    dec de              ;0336 1b
    ld a,e              ;0337 7b
    or d                ;0338 b2
    jr nz,l0336h        ;0339 20 fb
    ld a,04h            ;033b 3e 04
    sbc a,16h           ;033d de 16
    ld de,0ffffh        ;033f 11 ff ff
l0342h:
    dec de              ;0342 1b
    ld a,e              ;0343 7b
    or d                ;0344 b2
    jr nz,l0342h        ;0345 20 fb
    djnz l0330h         ;0347 10 e7
    ld b,05h            ;0349 06 05
    ld de,0ffffh        ;034b 11 ff ff
l034eh:
    dec de              ;034e 1b
    ld a,e              ;034f 7b
    or d                ;0350 b2
    jr nz,l034eh        ;0351 20 fb
    djnz l034eh         ;0353 10 f9
    jr $-43             ;0355 18 d3
    in a,(ppi2_pc)      ;0357 db 16
    xor 0ffh            ;0359 ee ff
    out (ppi2_pc),a     ;035b d3 16
    ret                 ;035d c9
    xor a               ;035e af
l035fh:
    add a,(hl)          ;035f 86
    rrca                ;0360 0f
    ld d,a              ;0361 57
    inc hl              ;0362 23
    dec bc              ;0363 0b
    ld a,b              ;0364 78
    or c                ;0365 b1
    ld a,d              ;0366 7a
    jr nz,l035fh        ;0367 20 f6
    ret                 ;0369 c9
l036ah:
    push bc             ;036a c5
    ld b,0c8h           ;036b 06 c8
l036dh:
    add a,00h           ;036d c6 00
    djnz l036dh         ;036f 10 fc
    pop bc              ;0371 c1
    dec bc              ;0372 0b
    ld a,c              ;0373 79
l0374h:
    or b                ;0374 b0
    jr nz,l036ah        ;0375 20 f3
    ret                 ;0377 c9
    ret                 ;0378 c9
    ld a,l              ;0379 7d
    ret                 ;037a c9
    ld a,0aah           ;037b 3e aa
    ret                 ;037d c9
    ld a,l              ;037e 7d
    cpl                 ;037f 2f
    ret                 ;0380 c9
    ld a,55h            ;0381 3e 55
    ret                 ;0383 c9
    ld a,l              ;0384 7d
    rrca                ;0385 0f
    rrca                ;0386 0f
    rrca                ;0387 0f
    xor h               ;0388 ac
    and 01h             ;0389 e6 01
    jr z,l0374h         ;038b 28 e7
    jr $-23             ;038d 18 e7
    ld a,l              ;038f 7d
