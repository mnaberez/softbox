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
    db "CP/M <--> Pet DOS file transfer",0dh,0ah
    db "----      --- --- ---- --------",0dh,0ah

    db 0ah,"1.  Copy sequential file to PET DOS",0dh,0ah
    db 0ah,"2.  Copy sequential file from PET DOS",0dh,0ah
    db 0ah,"3.  Copy BASIC program from PET DOS",0dh,0ah
    db 0ah,"4.  As 2.  but insert line feeds",0dh,0ah
    db 0ah,"Which type of transfer (1 to 4) ? $"
l0513h:
    db "PET DOS source drive (A-P) ? $"
l0531h:
    db "PET DOS source file ? $"
l0548h:
    db "PET DOS destination drive (A-P) ? $"
l056bh:
    db "PET DOS destn. file ? $"
l0582h:
    db 0dh,0ah,"Bad file name$"
l0592h:
    db 0dh,0ah,"Bad drive name$"
l05a3h:
    db 0dh,0ah,"Bad command",0dh,0ah,"$"
l05b3h:
    db 0dh,0ah,"Disk error :",0dh,0ah,"$"
l05c4h:
    db 0dh,0ah,"Disk or directory full$"
l05ddh:
    db 0dh,0ah,"Transfer complete$"
l05f1h:
    db 0dh,0ah,"File not found$"

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
