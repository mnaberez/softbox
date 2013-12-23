; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels --output=devnum.asm devnum.com

    org 0100h

    jp l0126h           ;0100 c3 26 01
    nop                 ;0103 00
    nop                 ;0104 00
    nop                 ;0105 00
    nop                 ;0106 00
    nop                 ;0107 00
    nop                 ;0108 00
    nop                 ;0109 00
l010ah:
    nop                 ;010a 00
    nop                 ;010b 00
l010ch:
    nop                 ;010c 00
    nop                 ;010d 00
l010eh:
    nop                 ;010e 00
    nop                 ;010f 00
l0110h:
    nop                 ;0110 00
    nop                 ;0111 00
l0112h:
    nop                 ;0112 00
    nop                 ;0113 00
l0114h:
    nop                 ;0114 00
    nop                 ;0115 00
l0116h:
    nop                 ;0116 00
    nop                 ;0117 00
l0118h:
    nop                 ;0118 00
    nop                 ;0119 00
l011ah:
    nop                 ;011a 00
    nop                 ;011b 00
    nop                 ;011c 00
    nop                 ;011d 00
    nop                 ;011e 00
    nop                 ;011f 00
    nop                 ;0120 00
    nop                 ;0121 00
l0122h:
    nop                 ;0122 00
    nop                 ;0123 00
    nop                 ;0124 00
    nop                 ;0125 00
l0126h:
    ld hl,l013ah        ;0126 21 3a 01
    jp l0736h           ;0129 c3 36 07
    dec sp              ;012c 3b
    dec b               ;012d 05
    nop                 ;012e 00
    nop                 ;012f 00
    dec a               ;0130 3d
    dec b               ;0131 05
    inc bc              ;0132 03
    ld bc,l011ah        ;0133 01 1a 01
    nop                 ;0136 00
    nop                 ;0137 00
    ld h,01h            ;0138 26 01
l013ah:
    call sub_0737h      ;013a cd 37 07
    call sub_074ch      ;013d cd 4c 07
    ld hl,001ah         ;0140 21 1a 00
    call sub_0671h      ;0143 cd 71 06
    call sub_067eh      ;0146 cd 7e 06
    call sub_074ch      ;0149 cd 4c 07
    ld hl,alter_pet_dos ;014c 21 07 05
    call sub_067eh      ;014f cd 7e 06
    call sub_074ch      ;0152 cd 4c 07
    ld hl,dashes        ;0155 21 d6 04
    call sub_067eh      ;0158 cd 7e 06
    call sub_074ch      ;015b cd 4c 07
    ld hl,empty_string  ;015e 21 38 05
    call sub_067eh      ;0161 cd 7e 06
    call sub_074ch      ;0164 cd 4c 07
    ld hl,empty_string  ;0167 21 38 05
    call sub_067eh      ;016a cd 7e 06
    call sub_074ch      ;016d cd 4c 07
    ld hl,empty_string  ;0170 21 38 05
    call sub_067eh      ;0173 cd 7e 06
    ld a,01h            ;0176 3e 01
    ld (4033h),a        ;0178 32 33 40
    ld hl,4000h         ;017b 21 00 40
    ld (l010ah),hl      ;017e 22 0a 01
    ld hl,0020h         ;0181 21 20 00
    ld (l010ch),hl      ;0184 22 0c 01
    ld bc,l010ah        ;0187 01 0a 01
    ld de,l010ch        ;018a 11 0c 01
    ld hl,l010eh        ;018d 21 0e 01
    call sub_0546h      ;0190 cd 46 05
    call sub_020eh      ;0193 cd 0e 02
    call sub_074ch      ;0196 cd 4c 07
    ld hl,04b7h         ;0199 21 b7 04
    call sub_0689h      ;019c cd 89 06
    ld a,(4036h)        ;019f 3a 36 40
    ld l,a              ;01a2 6f
    ld h,00h            ;01a3 26 00
    call sub_06d7h      ;01a5 cd d7 06
    call sub_074ch      ;01a8 cd 4c 07
    ld hl,empty_string  ;01ab 21 38 05
    call sub_067eh      ;01ae cd 7e 06
    call sub_074ch      ;01b1 cd 4c 07
    ld hl,new_dev_num   ;01b4 21 a0 04
    call sub_0689h      ;01b7 cd 89 06
    call sub_02c4h      ;01ba cd c4 02
    ld hl,(l0110h)      ;01bd 2a 10 01
    ld a,h              ;01c0 7c
    or l                ;01c1 b5
    jp nz,l01c8h        ;01c2 c2 c8 01
    call sub_0733h      ;01c5 cd 33 07
l01c8h:
    call sub_074ch      ;01c8 cd 4c 07
    ld hl,empty_string  ;01cb 21 38 05
    call sub_067eh      ;01ce cd 7e 06
    call sub_074ch      ;01d1 cd 4c 07
    ld hl,empty_string  ;01d4 21 38 05
    call sub_067eh      ;01d7 cd 7e 06
    call sub_074ch      ;01da cd 4c 07
    ld hl,chg_dev_num   ;01dd 21 83 04
    call sub_0689h      ;01e0 cd 89 06
    ld hl,(l0112h)      ;01e3 2a 12 01
    call sub_06ceh      ;01e6 cd ce 06
    ld hl,ellipsis      ;01e9 21 7c 04
    call sub_067eh      ;01ec cd 7e 06
    ld hl,(l0112h)      ;01ef 2a 12 01
    ld a,l              ;01f2 7d
    ld (4036h),a        ;01f3 32 36 40
    ld hl,0020h         ;01f6 21 20 00
    ld (l010ch),hl      ;01f9 22 0c 01
    ld bc,l010ah        ;01fc 01 0a 01
    ld de,l010ch        ;01ff 11 0c 01
    ld hl,l010eh        ;0202 21 0e 01
    call sub_0583h      ;0205 cd 83 05
    call sub_020eh      ;0208 cd 0e 02
    call sub_0733h      ;020b cd 33 07
sub_020eh:
    ld hl,(l010eh)      ;020e 2a 0e 01
    ld a,l              ;0211 7d
    and 40h             ;0212 e6 40
    ld l,a              ;0214 6f
    ld a,h              ;0215 7c
    and 00h             ;0216 e6 00
    ld h,a              ;0218 67
    ld a,h              ;0219 7c
    or l                ;021a b5
    jp nz,l021fh        ;021b c2 1f 02
    ret                 ;021e c9
l021fh:
    call sub_074ch      ;021f cd 4c 07
    ld hl,drive_err_num ;0222 21 6c 04
    call sub_0689h      ;0225 cd 89 06
    ld hl,(l0114h)      ;0228 2a 14 01
    ld de,0ffc0h        ;022b 11 c0 ff
    add hl,de           ;022e 19
    ld a,h              ;022f 7c
    or l                ;0230 b5
    jp nz,l0240h        ;0231 c2 40 02
    call sub_074ch      ;0234 cd 4c 07
    ld hl,head_writ_err ;0237 21 52 04
    call sub_067eh      ;023a cd 7e 06
    call sub_0733h      ;023d cd 33 07
l0240h:
    ld hl,(l0114h)      ;0240 2a 14 01
    ld de,0ffbeh        ;0243 11 be ff
    add hl,de           ;0246 19
    ld a,h              ;0247 7c
    or l                ;0248 b5
    jp nz,l0258h        ;0249 c2 58 02
    call sub_074ch      ;024c cd 4c 07
    ld hl,head_read_err ;024f 21 39 04
    call sub_067eh      ;0252 cd 7e 06
    call sub_0733h      ;0255 cd 33 07
l0258h:
    ld hl,(l0114h)      ;0258 2a 14 01
    ld de,0ffbch        ;025b 11 bc ff
    add hl,de           ;025e 19
    ld a,h              ;025f 7c
    or l                ;0260 b5
    jp nz,l0270h        ;0261 c2 70 02
    call sub_074ch      ;0264 cd 4c 07
    ld hl,data_read_err ;0267 21 22 04
    call sub_067eh      ;026a cd 7e 06
    call sub_0733h      ;026d cd 33 07
l0270h:
    ld hl,(l0114h)      ;0270 2a 14 01
    ld de,0ffbah        ;0273 11 ba ff
    add hl,de           ;0276 19
    ld a,h              ;0277 7c
    or l                ;0278 b5
    jp nz,l0288h        ;0279 c2 88 02
    call sub_074ch      ;027c cd 4c 07
    ld hl,write_fault   ;027f 21 0f 04
    call sub_067eh      ;0282 cd 7e 06
    call sub_0733h      ;0285 cd 33 07
l0288h:
    ld hl,(l0114h)      ;0288 2a 14 01
    ld de,0ffb9h        ;028b 11 b9 ff
    add hl,de           ;028e 19
    ld a,h              ;028f 7c
    or l                ;0290 b5
    jp nz,l02a0h        ;0291 c2 a0 02
    call sub_074ch      ;0294 cd 4c 07
    ld hl,not_ready     ;0297 21 f9 03
    call sub_067eh      ;029a cd 7e 06
    call sub_0733h      ;029d cd 33 07
l02a0h:
    ld hl,(l0114h)      ;02a0 2a 14 01
    ld de,0ffb7h        ;02a3 11 b7 ff
    add hl,de           ;02a6 19
    ld a,h              ;02a7 7c
    or l                ;02a8 b5
    jp nz,l02b8h        ;02a9 c2 b8 02
    call sub_074ch      ;02ac cd 4c 07
    ld hl,illegal_cmd   ;02af 21 e2 03
    call sub_067eh      ;02b2 cd 7e 06
    call sub_0733h      ;02b5 cd 33 07
l02b8h:
    call sub_074ch      ;02b8 cd 4c 07
    ld hl,unknown_err   ;02bb 21 c8 03
    call sub_067eh      ;02be cd 7e 06
    call sub_0733h      ;02c1 cd 33 07
sub_02c4h:
    ld hl,0080h         ;02c4 21 80 00
    ld (l0116h),hl      ;02c7 22 16 01
    ld hl,(l0116h)      ;02ca 2a 16 01
    ld (hl),50h         ;02cd 36 50
    call sub_053eh      ;02cf cd 3e 05
    call sub_074ch      ;02d2 cd 4c 07
    ld hl,empty_string  ;02d5 21 38 05
    call sub_067eh      ;02d8 cd 7e 06
    ld hl,(l0116h)      ;02db 2a 16 01
    inc hl              ;02de 23
    ld l,(hl)           ;02df 6e
    ld h,00h            ;02e0 26 00
    ld a,h              ;02e2 7c
    or l                ;02e3 b5
    jp nz,l02eeh        ;02e4 c2 ee 02
    ld hl,0000h         ;02e7 21 00 00
    ld (l0110h),hl      ;02ea 22 10 01
    ret                 ;02ed c9
l02eeh:
    ld hl,(l0116h)      ;02ee 2a 16 01
    inc hl              ;02f1 23
    inc hl              ;02f2 23
    ld l,(hl)           ;02f3 6e
    ld h,00h            ;02f4 26 00
    ld (l0110h),hl      ;02f6 22 10 01
    ld hl,(l0110h)      ;02f9 2a 10 01
    ld de,0ff9fh        ;02fc 11 9f ff
    ld a,h              ;02ff 7c
    rla                 ;0300 17
    jp c,l0306h         ;0301 da 06 03
    add hl,de           ;0304 19
    add hl,hl           ;0305 29
l0306h:
    ccf                 ;0306 3f
    sbc a,a             ;0307 9f
    ld h,a              ;0308 67
    ld l,a              ;0309 6f
    push hl             ;030a e5
    ld hl,(l0110h)      ;030b 2a 10 01
    ld de,0ff85h        ;030e 11 85 ff
    ld a,h              ;0311 7c
    rla                 ;0312 17
    jp c,l0318h         ;0313 da 18 03
    add hl,de           ;0316 19
    add hl,hl           ;0317 29
l0318h:
    sbc a,a             ;0318 9f
    ld h,a              ;0319 67
    ld l,a              ;031a 6f
    pop de              ;031b d1
    ld a,h              ;031c 7c
    and d               ;031d a2
    ld h,a              ;031e 67
    ld a,l              ;031f 7d
    and e               ;0320 a3
    ld l,a              ;0321 6f
    ld a,h              ;0322 7c
    or l                ;0323 b5
    jp z,l0331h         ;0324 ca 31 03
    ld de,0ffe0h        ;0327 11 e0 ff
    ld hl,(l0110h)      ;032a 2a 10 01
    add hl,de           ;032d 19
    ld (l0110h),hl      ;032e 22 10 01
l0331h:
    ld hl,0000h         ;0331 21 00 00
    ld (l0112h),hl      ;0334 22 12 01
    ld hl,0002h         ;0337 21 02 00
    ld (l0118h),hl      ;033a 22 18 01
l033dh:
    ld hl,(l0116h)      ;033d 2a 16 01
    ex de,hl            ;0340 eb
    ld hl,(l0118h)      ;0341 2a 18 01
    add hl,de           ;0344 19
    ld l,(hl)           ;0345 6e
    ld h,00h            ;0346 26 00
    push hl             ;0348 e5
    ld de,0ffd0h        ;0349 11 d0 ff
    ld a,h              ;034c 7c
    rla                 ;034d 17
    jp c,l0353h         ;034e da 53 03
    add hl,de           ;0351 19
    add hl,hl           ;0352 29
l0353h:
    ccf                 ;0353 3f
    sbc a,a             ;0354 9f
    ld h,a              ;0355 67
    ld l,a              ;0356 6f
    ld (l0122h),hl      ;0357 22 22 01
    pop hl              ;035a e1
    ld de,0ffc6h        ;035b 11 c6 ff
    ld a,h              ;035e 7c
    rla                 ;035f 17
    jp c,l0365h         ;0360 da 65 03
    add hl,de           ;0363 19
    add hl,hl           ;0364 29
l0365h:
    sbc a,a             ;0365 9f
    ld h,a              ;0366 67
    ld l,a              ;0367 6f
    push hl             ;0368 e5
    ld hl,(l0122h)      ;0369 2a 22 01
    ex de,hl            ;036c eb
    pop hl              ;036d e1
    ld a,h              ;036e 7c
    and d               ;036f a2
    ld h,a              ;0370 67
    ld a,l              ;0371 7d
    and e               ;0372 a3
    ld l,a              ;0373 6f
    push hl             ;0374 e5
    ld hl,(l0116h)      ;0375 2a 16 01
    inc hl              ;0378 23
    ld l,(hl)           ;0379 6e
    ld h,00h            ;037a 26 00
    push hl             ;037c e5
    ld hl,(l0118h)      ;037d 2a 18 01
    dec hl              ;0380 2b
    dec hl              ;0381 2b
    pop de              ;0382 d1
    ld a,d              ;0383 7a
    xor h               ;0384 ac
    ld a,h              ;0385 7c
    jp m,l038dh         ;0386 fa 8d 03
    ld a,l              ;0389 7d
    sub e               ;038a 93
    ld a,h              ;038b 7c
    sbc a,d             ;038c 9a
l038dh:
    rla                 ;038d 17
    sbc a,a             ;038e 9f
    ld h,a              ;038f 67
    ld l,a              ;0390 6f
    pop de              ;0391 d1
    ld a,h              ;0392 7c
    and d               ;0393 a2
    ld h,a              ;0394 67
    ld a,l              ;0395 7d
    and e               ;0396 a3
    ld l,a              ;0397 6f
    ld a,h              ;0398 7c
    or l                ;0399 b5
    jp z,l03c4h         ;039a ca c4 03
    ld hl,(l0112h)      ;039d 2a 12 01
    call sub_06a9h      ;03a0 cd a9 06
    ld a,(bc)           ;03a3 0a
    nop                 ;03a4 00
    push hl             ;03a5 e5
    ld hl,(l0116h)      ;03a6 2a 16 01
    ex de,hl            ;03a9 eb
    ld hl,(l0118h)      ;03aa 2a 18 01
    add hl,de           ;03ad 19
    ld l,(hl)           ;03ae 6e
    ld h,00h            ;03af 26 00
    pop de              ;03b1 d1
    add hl,de           ;03b2 19
    ld de,0ffd0h        ;03b3 11 d0 ff
    add hl,de           ;03b6 19
    ld (l0112h),hl      ;03b7 22 12 01
    ld hl,(l0118h)      ;03ba 2a 18 01
    inc hl              ;03bd 23
    ld (l0118h),hl      ;03be 22 18 01
    jp l033dh           ;03c1 c3 3d 03
l03c4h:
    ret                 ;03c4 c9
    call sub_0733h      ;03c5 cd 33 07

unknown_err:
    db 17h
    dw unknown_err+3
    db "xx - unknown error code"

illegal_cmd:
    db 14h
    dw illegal_cmd+3
    db "49 - illegal command"

not_ready:
    db 13h
    dw not_ready+3
    db "47 - disk not ready"

write_fault:
    db 10h
    dw write_fault+3
    db "46 - write fault"

data_read_err:
    db 14h
    dw data_read_err+3
    db "44 - data read error"

head_read_err:
    db 16h
    dw head_read_err+3
    db "42 - header read error"

head_writ_err:
    db 17h
    dw head_writ_err+3
    db "40 - header write error"

drive_err_num:
    db 0dh
    dw drive_err_num+3
    db "DRIVE ERROR #"

ellipsis:
    db 04h
    dw ellipsis+3
    db " ..."

chg_dev_num:
    db 1ah
    dw chg_dev_num+3
    db "changing device number to "

new_dev_num:
    db 14h
    dw new_dev_num+3
    db "new device number ? "

cur_dev_num_is:
    db 1ch
    dw cur_dev_num_is+3
    db "current device number is :  "

dashes:
    db 2eh
    dw dashes+3
    db "----- --- --- ------ ------ -- ---------------"

alter_pet_dos:
    db 2eh
    dw alter_pet_dos+3
    db "Alter PET DOS device number of Mini-Winchester"

empty_string:
    db 0
    dw empty_string+3
    db 0, 0, 0

sub_053eh:
    ld c,0ah            ;053e 0e 0a
    ld de,0080h         ;0540 11 80 00
    jp 0005h            ;0543 c3 05 00
sub_0546h:
    ld (l0631h+1),hl    ;0546 22 32 06
    xor a               ;0549 af
    ld (hl),a           ;054a 77
    inc hl              ;054b 23
    ld (hl),a           ;054c 77
    ld (l0631h),a       ;054d 32 31 06
    ld a,(de)           ;0550 1a
    ld (l062fh),a       ;0551 32 2f 06
    inc de              ;0554 13
    ld a,(de)           ;0555 1a
    ld (l062fh+1),a     ;0556 32 30 06
l0559h:
    ld a,(bc)           ;0559 0a
    ld l,a              ;055a 6f
    inc bc              ;055b 03
    ld a,(bc)           ;055c 0a
    ld h,a              ;055d 67
    push hl             ;055e e5
    ld a,21h            ;055f 3e 21
l0561h:
    call sub_05c0h      ;0561 cd c0 05
    call sub_05f9h      ;0564 cd f9 05
    call sub_05ddh      ;0567 cd dd 05
    pop hl              ;056a e1
    jr nz,l05bbh        ;056b 20 4e
    ld a,41h            ;056d 3e 41
    call sub_05c0h      ;056f cd c0 05
    ld b,00h            ;0572 06 00
l0574h:
    in a,(18h)          ;0574 db 18
    ld (hl),a           ;0576 77
l0577h:
    inc hl              ;0577 23
    ex (sp),hl          ;0578 e3
    ex (sp),hl          ;0579 e3
    djnz l0574h         ;057a 10 f8
    call sub_05ddh      ;057c cd dd 05
    ret z               ;057f c8
    jp l05bbh           ;0580 c3 bb 05
sub_0583h:
    ld (l0631h+1),hl    ;0583 22 32 06
    xor a               ;0586 af
    ld (hl),a           ;0587 77
    inc hl              ;0588 23
    ld (hl),a           ;0589 77
    ld (l0631h),a       ;058a 32 31 06
    ld a,(de)           ;058d 1a
l058eh:
    ld (l062fh),a       ;058e 32 2f 06
    inc de              ;0591 13
    ld a,(de)           ;0592 1a
    ld (l062fh+1),a     ;0593 32 30 06
l0596h:
    ld a,(bc)           ;0596 0a
    ld l,a              ;0597 6f
    inc bc              ;0598 03
    ld a,(bc)           ;0599 0a
    ld h,a              ;059a 67
    ld a,42h            ;059b 3e 42
    call sub_05c0h      ;059d cd c0 05
    ld b,00h            ;05a0 06 00
l05a2h:
    ld a,(hl)           ;05a2 7e
    out (18h),a         ;05a3 d3 18
    inc hl              ;05a5 23
    ex (sp),hl          ;05a6 e3
    ex (sp),hl          ;05a7 e3
    djnz l05a2h         ;05a8 10 f8
    call sub_05ddh      ;05aa cd dd 05
    jr nz,l05bbh        ;05ad 20 0c
    ld a,22h            ;05af 3e 22
    call sub_05c0h      ;05b1 cd c0 05
    call sub_05f9h      ;05b4 cd f9 05
    call sub_05ddh      ;05b7 cd dd 05
    ret z               ;05ba c8
l05bbh:
    ld hl,(l0631h+1)    ;05bb 2a 32 06
    ld (hl),a           ;05be 77
    ret                 ;05bf c9
sub_05c0h:
    ld b,a              ;05c0 47
    xor a               ;05c1 af
    out (18h),a         ;05c2 d3 18
l05c4h:
    in a,(18h)          ;05c4 db 18
    cp 0a0h             ;05c6 fe a0
    jr nz,l05c4h        ;05c8 20 fa
    ld a,b              ;05ca 78
    out (18h),a         ;05cb d3 18
l05cdh:
    in a,(18h)          ;05cd db 18
    cp 0a1h             ;05cf fe a1
    jr nz,l05cdh        ;05d1 20 fa
    ld a,0ffh           ;05d3 3e ff
    out (18h),a         ;05d5 d3 18
    ld b,14h            ;05d7 06 14
l05d9h:
    nop                 ;05d9 00
    djnz l05d9h         ;05da 10 fd
    ret                 ;05dc c9
sub_05ddh:
    ld a,0ffh           ;05dd 3e ff
    out (18h),a         ;05df d3 18
l05e1h:
    in a,(18h)          ;05e1 db 18
    inc a               ;05e3 3c
    jr nz,l05e1h        ;05e4 20 fb
    ld a,0feh           ;05e6 3e fe
    out (18h),a         ;05e8 d3 18
l05eah:
    in a,(18h)          ;05ea db 18
    rla                 ;05ec 17
    jr c,l05eah         ;05ed 38 fb
    in a,(18h)          ;05ef db 18
    bit 6,a             ;05f1 cb 77
    push af             ;05f3 f5
    xor a               ;05f4 af
    out (18h),a         ;05f5 d3 18
    pop af              ;05f7 f1
    ret                 ;05f8 c9
sub_05f9h:
    xor a               ;05f9 af
    out (18h),a         ;05fa d3 18
    ld hl,(l062fh)      ;05fc 2a 2f 06
    ld a,(l0631h)       ;05ff 3a 31 06
    ld b,05h            ;0602 06 05
l0604h:
    rra                 ;0604 1f
    rr h                ;0605 cb 1c
    rr l                ;0607 cb 1d
l0609h:
    djnz l0604h         ;0609 10 f9
    ld a,(4033h)        ;060b 3a 33 40
    ld b,a              ;060e 47
    and l               ;060f a5
    out (18h),a         ;0610 d3 18
l0612h:
    srl h               ;0612 cb 3c
    rr l                ;0614 cb 1d
    srl b               ;0616 cb 38
    jr nz,l0612h        ;0618 20 f8
    ld a,l              ;061a 7d
    out (18h),a         ;061b d3 18
    ld a,h              ;061d 7c
    out (18h),a         ;061e d3 18
    ld a,(l062fh)       ;0620 3a 2f 06
    and 1fh             ;0623 e6 1f
    out (18h),a         ;0625 d3 18
    xor a               ;0627 af
    out (18h),a         ;0628 d3 18
    out (18h),a         ;062a d3 18
    out (18h),a         ;062c d3 18
    ret                 ;062e c9
l062fh:
    jr nz,$+4           ;062f 20 02
l0631h:
    ld hl,0000h         ;0631 21 00 00
l0634h:
    ret                 ;0634 c9
    call 2050h          ;0635 cd 50 20
l0638h:
    ld b,3eh            ;0638 06 3e
    jr nz,l0609h        ;063a 20 cd
    ld a,07h            ;063c 3e 07
    ret                 ;063e c9
l063fh:
    ld a,0ah            ;063f 3e 0a
    call sub_073eh      ;0641 cd 3e 07
    ld a,0dh            ;0644 3e 0d
    call sub_073eh      ;0646 cd 3e 07
    ret                 ;0649 c9
    ld a,02h            ;064a 3e 02
    ld (l0634h),a       ;064c 32 34 06
    ld a,l              ;064f 7d
    call sub_0661h      ;0650 cd 61 06
    ld (0637h),a        ;0653 32 37 06
    ld a,l              ;0656 7d
    call sub_0665h      ;0657 cd 65 06
    ld (l0638h),a       ;065a 32 38 06
    ld hl,l0634h        ;065d 21 34 06
    ret                 ;0660 c9
sub_0661h:
    rrca                ;0661 0f
    rrca                ;0662 0f
    rrca                ;0663 0f
    rrca                ;0664 0f
sub_0665h:
    and 0fh             ;0665 e6 0f
    cp 0ah              ;0667 fe 0a
    jp m,l066eh         ;0669 fa 6e 06
    add a,07h           ;066c c6 07
l066eh:
    add a,30h           ;066e c6 30
    ret                 ;0670 c9
sub_0671h:
    ld a,01h            ;0671 3e 01
    ld (l0634h),a       ;0673 32 34 06
    ld a,l              ;0676 7d
    ld (0637h),a        ;0677 32 37 06
    ld hl,l0634h        ;067a 21 34 06
    ret                 ;067d c9
sub_067eh:
    ld a,(hl)           ;067e 7e
    or a                ;067f b7
    jp z,l063fh         ;0680 ca 3f 06
    call sub_069bh      ;0683 cd 9b 06
    jp l063fh           ;0686 c3 3f 06
sub_0689h:
    ld a,(hl)           ;0689 7e
    or a                ;068a b7
    ret z               ;068b c8
    call sub_069bh      ;068c cd 9b 06
    ret                 ;068f c9
    ld a,(hl)           ;0690 7e
    or a                ;0691 b7
    jp z,l0638h+1       ;0692 ca 39 06
    call sub_069bh      ;0695 cd 9b 06
    jp l0638h+1         ;0698 c3 39 06
sub_069bh:
    ld b,a              ;069b 47
    inc hl              ;069c 23
    inc hl              ;069d 23
    inc hl              ;069e 23
l069fh:
    ld a,(hl)           ;069f 7e
    call sub_073eh      ;06a0 cd 3e 07
    dec b               ;06a3 05
    inc hl              ;06a4 23
    jp nz,l069fh        ;06a5 c2 9f 06
    ret                 ;06a8 c9
sub_06a9h:
    ld b,h              ;06a9 44
    ld c,l              ;06aa 4d
    pop hl              ;06ab e1
    ld e,(hl)           ;06ac 5e
    inc hl              ;06ad 23
    ld d,(hl)           ;06ae 56
    inc hl              ;06af 23
    push hl             ;06b0 e5
    ld l,c              ;06b1 69
    ld h,b              ;06b2 60
    ld a,h              ;06b3 7c
    or l                ;06b4 b5
    ret z               ;06b5 c8
    ex de,hl            ;06b6 eb
    ld a,h              ;06b7 7c
    or l                ;06b8 b5
    ret z               ;06b9 c8
    ld b,h              ;06ba 44
    ld c,l              ;06bb 4d
    ld hl,0000h         ;06bc 21 00 00
    ld a,10h            ;06bf 3e 10
l06c1h:
    add hl,hl           ;06c1 29
    ex de,hl            ;06c2 eb
    add hl,hl           ;06c3 29
    ex de,hl            ;06c4 eb
    jp nc,l06c9h        ;06c5 d2 c9 06
    add hl,bc           ;06c8 09
l06c9h:
    dec a               ;06c9 3d
    jp nz,l06c1h        ;06ca c2 c1 06
    ret                 ;06cd c9
sub_06ceh:
    call sub_06e5h      ;06ce cd e5 06
    ld a,20h            ;06d1 3e 20
    call sub_073eh      ;06d3 cd 3e 07
    ret                 ;06d6 c9
sub_06d7h:
    call sub_06e5h      ;06d7 cd e5 06
    ld a,0ah            ;06da 3e 0a
    call sub_073eh      ;06dc cd 3e 07
    ld a,0dh            ;06df 3e 0d
    call sub_073eh      ;06e1 cd 3e 07
    ret                 ;06e4 c9
sub_06e5h:
    push hl             ;06e5 e5
    ld a,h              ;06e6 7c
    and 80h             ;06e7 e6 80
    jp z,l06f8h         ;06e9 ca f8 06
    ld a,l              ;06ec 7d
    cpl                 ;06ed 2f
    ld l,a              ;06ee 6f
    ld a,h              ;06ef 7c
    cpl                 ;06f0 2f
    ld h,a              ;06f1 67
    inc hl              ;06f2 23
    ld a,2dh            ;06f3 3e 2d
    call sub_073eh      ;06f5 cd 3e 07
l06f8h:
    ld c,30h            ;06f8 0e 30
    ld de,2710h         ;06fa 11 10 27
    call sub_071ah      ;06fd cd 1a 07
    ld de,03e8h         ;0700 11 e8 03
    call sub_071ah      ;0703 cd 1a 07
    ld de,0064h         ;0706 11 64 00
    call sub_071ah      ;0709 cd 1a 07
    ld de,000ah         ;070c 11 0a 00
    call sub_071ah      ;070f cd 1a 07
    ld de,0001h         ;0712 11 01 00
    call sub_071ah      ;0715 cd 1a 07
    pop hl              ;0718 e1
    ret                 ;0719 c9
sub_071ah:
    call sub_072ch      ;071a cd 2c 07
    jp c,l0724h         ;071d da 24 07
    inc c               ;0720 0c
    jp sub_071ah        ;0721 c3 1a 07
l0724h:
    ld a,c              ;0724 79
    call sub_073eh      ;0725 cd 3e 07
    add hl,de           ;0728 19
    ld c,30h            ;0729 0e 30
    ret                 ;072b c9
sub_072ch:
    ld a,l              ;072c 7d
    sub e               ;072d 93
    ld l,a              ;072e 6f
    ld a,h              ;072f 7c
    sbc a,d             ;0730 9a
    ld h,a              ;0731 67
    ret                 ;0732 c9
sub_0733h:
    jp 0000h            ;0733 c3 00 00
l0736h:
    jp (hl)             ;0736 e9
sub_0737h:
    ret                 ;0737 c9
    ld hl,0fffeh        ;0738 21 fe ff
    jp l074dh           ;073b c3 4d 07
sub_073eh:
    push hl             ;073e e5
    push de             ;073f d5
    push bc             ;0740 c5
    push af             ;0741 f5
    ld c,02h            ;0742 0e 02
    ld e,a              ;0744 5f
    call 0005h          ;0745 cd 05 00
    pop af              ;0748 f1
    pop bc              ;0749 c1
    pop de              ;074a d1
    pop hl              ;074b e1
sub_074ch:
    ret                 ;074c c9
l074dh:
    push de             ;074d d5
    push bc             ;074e c5
    push hl             ;074f e5
    ld c,01h            ;0750 0e 01
    call 0005h          ;0752 cd 05 00
    pop hl              ;0755 e1
    ld (hl),a           ;0756 77
    inc hl              ;0757 23
    ld (hl),00h         ;0758 36 00
    pop bc              ;075a c1
    pop de              ;075b d1
    ret                 ;075c c9
    ld a,(hl)           ;075d 7e
    jp sub_073eh        ;075e c3 3e 07
    call sub_073eh      ;0761 cd 3e 07
    ret                 ;0764 c9
    push hl             ;0765 e5
    ld a,h              ;0766 7c
    and 80h             ;0767 e6 80
    jp z,l06f8h         ;0769 ca f8 06
    ld a,l              ;076c 7d
    cpl                 ;076d 2f
    ld l,a              ;076e 6f
    ld a,h              ;076f 7c
    cpl                 ;0770 2f
    ld h,a              ;0771 67
    inc hl              ;0772 23
    ld a,2dh            ;0773 3e 2d
    call sub_073eh      ;0775 cd 3e 07
    ld c,30h            ;0778 0e 30
    ld de,2710h         ;077a 11 10 27
    call sub_071ah      ;077d cd 1a 07
