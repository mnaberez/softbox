; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels --output=mwdos291.asm mwdos291.com

    org 0100h

l0100h:
    jp start

unused_1:
    nop                 ;0103 00
    nop                 ;0104 00
    nop                 ;0105 00
    nop                 ;0106 00
    nop                 ;0107 00
    nop                 ;0108 00
    nop                 ;0109 00

; Start of BASIC variables ==================================================

l010ah:
    dw 0
l010ch:
    dw 0
l010eh:
    dw 0
l0110h:
    dw 0
l0112h:
    dw 0
l0114h:
    dw 0
l0116h:
    dw 0
l0118h:
    dw 0
l011ah:
    dw 0
l011ch:
    dw 0
    dw 0
    dw 0
    db 0
l0123h:
    db 0
l0124h:
    dw 0
    dw 0

; End of BASIC variables ====================================================

start:
    ld hl,main
    jp ini

unused_2:
    rst 18h             ;012e df
    inc b               ;012f 04
    nop                 ;0130 00
    nop                 ;0131 00
    pop hl              ;0132 e1
    inc b               ;0133 04
    inc bc              ;0134 03
    ld bc,011ch         ;0135 01 1c 01
    nop                 ;0138 00
    nop                 ;0139 00
    jr z,$+3            ;013a 28 01

main:
    call n5_0

    ;PRINT CHR$(26) ' Clear screen
    call pr0a
    ld hl,001ah
    call chr
    call pv2d

    ;PRINT "DOS firmware updating program"
    call pr0a
    ld hl,dos_firm_upd
    call pv2d

    ;PRINT "for Mini-Winchester"
    call pr0a
    ld hl,for_mw
    call pv2d

    ;PRINT "--- ---------------"
    call pr0a
    ld hl,dashes
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "Continue (Y/N) ? ";
    call pr0a
    ld hl,continue_yn
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R = &H59 THEN GOTO l0193h
    ld hl,(l010ah)
    ld de,0-'Y'
    add hl,de
    ld a,h
    or l
    jp z,l0193h

    ;END
    call end

l0193h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "writing controller code ..."
    call pr0a
    ld hl,writing_code
    call pv2d

    ld hl,0001h         ;01a5 21 01 00
    jp l01dah           ;01a8 c3 da 01

l01abh:
    ld hl,(l010ch)      ;01ab 2a 0c 01
    add hl,hl           ;01ae 29
    add hl,hl           ;01af 29
    add hl,hl           ;01b0 29
    add hl,hl           ;01b1 29
    add hl,hl           ;01b2 29
    add hl,hl           ;01b3 29
    add hl,hl           ;01b4 29
    add hl,hl           ;01b5 29
    ld de,l4000h        ;01b6 11 00 40
    add hl,de           ;01b9 19
    ld (l010eh),hl      ;01ba 22 0e 01
    ld de,0020h         ;01bd 11 20 00
    ld hl,(l010ch)      ;01c0 2a 0c 01
    add hl,de           ;01c3 19
    ld (l0110h),hl      ;01c4 22 10 01

    ;CALL mw_write (l010eh, l0110h, l0112h)
    ld bc,l010eh
    ld de,l0110h
    ld hl,l0112h
    call mw_write

    ;GOSUB check_error
    call check_error

    ld hl,(l010ch)      ;01d6 2a 0c 01
    inc hl              ;01d9 23
l01dah:
    ld (l010ch),hl      ;01da 22 0c 01
    ld hl,(l010ch)      ;01dd 2a 0c 01
    ld de,0ffe0h        ;01e0 11 e0 ff
    ld a,h              ;01e3 7c
    rla                 ;01e4 17
    jp c,l01eah         ;01e5 da ea 01
    add hl,de           ;01e8 19
    add hl,hl           ;01e9 29
l01eah:
    jp c,l01abh         ;01ea da ab 01

    ;END
    call end

check_error:
    ;IF (l010eh AND &H40) <> 0 THEN GOTO got_error
    ld hl,(l0112h)
    ld a,l
    and 40h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp nz,got_error
    ret

got_error:
    ;PRINT "DRIVE ERROR #"
    call pr0a
    ld hl,drive_err_num
    call pv1d

    ;IF l0114h <> &H40 THEN GOTO is_err_42h
    ld hl,(l0114h)
    ld de,0-40h
    add hl,de
    ld a,h
    or l
    jp nz,is_err_42h

    ;PRINT "40 - header write error"
    call pr0a
    ld hl,head_writ_err
    call pv2d

    ;END
    call end

is_err_42h:
    ;IF l0114h <> &H42 THEN GOTO is_err_44h
    ld hl,(l0114h)
    ld de,0-42h
    add hl,de
    ld a,h
    or l
    jp nz,is_err_44h

    ;PRINT "42 - header read error"
    call pr0a
    ld hl,head_read_err
    call pv2d

    ;END
    call end

is_err_44h:
    ;IF l0114h <> &H46 THEN GOTO is_err_46h
    ld hl,(l0114h)
    ld de,0-44h
    add hl,de
    ld a,h
    or l
    jp nz,is_err_46h

    ;PRINT "44 - data read error"
    call pr0a
    ld hl,data_read_err
    call pv2d

    ;END
    call end

is_err_46h:
    ;IF l0114h <> &H46 THEN GOTO is_err_46h
    ld hl,(l0114h)
    ld de,0-46h
    add hl,de
    ld a,h
    or l
    jp nz,is_err_47h

    ;PRINT "46 - write fault"
    call pr0a
    ld hl,write_fault
    call pv2d

    ;END
    call end

is_err_47h:
    ;IF l0114h <> &H47 THEN GOTO is_err_49h
    ld hl,(l0114h)
    ld de,0-47h
    add hl,de
    ld a,h
    or l
    jp nz,is_err_49h

    ;PRINT "47 - disk not ready"
    call pr0a
    ld hl,not_ready
    call pv2d

    ;END
    call end

is_err_49h:
    ;IF l0114h <> &H49 THEN GOTO unknown_error
    ld hl,(l0114h)
    ld de,0-49h
    add hl,de
    ld a,h
    or l
    jp nz,unknown_error

    ;PRINT "49 - illegal command"
    call pr0a
    ld hl,illegal_cmd
    call pv2d

    ;END
    call end

unknown_error:
    ;PRINT "xx - unknown error code"
    call pr0a
    ld hl,unknown_err
    call pv2d

    ;END
    call end

readline:
    ld hl,0080h         ;02a6 21 80 00
    ld (l0116h),hl      ;02a9 22 16 01
    ld hl,(l0116h)      ;02ac 2a 16 01
    ld (hl),50h         ;02af 36 50
    call buffin         ;02b1 cd e2 04

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ld hl,(l0116h)      ;02bd 2a 16 01
    inc hl              ;02c0 23
    ld l,(hl)           ;02c1 6e
    ld h,00h            ;02c2 26 00
    ld a,h              ;02c4 7c
    or l                ;02c5 b5
    jp nz,l02d0h        ;02c6 c2 d0 02
    ld hl,0000h         ;02c9 21 00 00
    ld (l010ah),hl      ;02cc 22 0a 01
    ret                 ;02cf c9
l02d0h:
    ld hl,(l0116h)      ;02d0 2a 16 01
    inc hl              ;02d3 23
    inc hl              ;02d4 23
    ld l,(hl)           ;02d5 6e
    ld h,00h            ;02d6 26 00
    ld (l010ah),hl      ;02d8 22 0a 01
    ld hl,(l010ah)      ;02db 2a 0a 01
    ld de,0ff9fh        ;02de 11 9f ff
    ld a,h              ;02e1 7c
    rla                 ;02e2 17
    jp c,l02e8h         ;02e3 da e8 02
    add hl,de           ;02e6 19
    add hl,hl           ;02e7 29
l02e8h:
    ccf                 ;02e8 3f
    sbc a,a             ;02e9 9f
    ld h,a              ;02ea 67
    ld l,a              ;02eb 6f
    push hl             ;02ec e5
    ld hl,(l010ah)      ;02ed 2a 0a 01
    ld de,0ff85h        ;02f0 11 85 ff
sub_02f3h:
    ld a,h              ;02f3 7c
    rla                 ;02f4 17
    jp c,l02fah         ;02f5 da fa 02
    add hl,de           ;02f8 19
    add hl,hl           ;02f9 29
l02fah:
    sbc a,a             ;02fa 9f
    ld h,a              ;02fb 67
    ld l,a              ;02fc 6f
    pop de              ;02fd d1
    ld a,h              ;02fe 7c
    and d               ;02ff a2
    ld h,a              ;0300 67
    ld a,l              ;0301 7d
    and e               ;0302 a3
    ld l,a              ;0303 6f
l0304h:
    ld a,h              ;0304 7c
    or l                ;0305 b5
    jp z,l0313h         ;0306 ca 13 03
    ld de,0ffe0h        ;0309 11 e0 ff
    ld hl,(l010ah)      ;030c 2a 0a 01
    add hl,de           ;030f 19
    ld (l010ah),hl      ;0310 22 0a 01
l0313h:
    ld hl,0000h         ;0313 21 00 00
    ld (l0118h),hl      ;0316 22 18 01
    ld hl,0002h         ;0319 21 02 00
    ld (l011ah),hl      ;031c 22 1a 01
l031fh:
    ld hl,(l0116h)      ;031f 2a 16 01
    ex de,hl            ;0322 eb
    ld hl,(l011ah)      ;0323 2a 1a 01
    add hl,de           ;0326 19
    ld l,(hl)           ;0327 6e
    ld h,00h            ;0328 26 00
    push hl             ;032a e5
    ld de,0ffd0h        ;032b 11 d0 ff
    ld a,h              ;032e 7c
    rla                 ;032f 17
    jp c,l0335h         ;0330 da 35 03
    add hl,de           ;0333 19
    add hl,hl           ;0334 29
l0335h:
    ccf                 ;0335 3f
    sbc a,a             ;0336 9f
    ld h,a              ;0337 67
sub_0338h:
    ld l,a              ;0338 6f
    ld (l0124h),hl      ;0339 22 24 01
    pop hl              ;033c e1
    ld de,0ffc6h        ;033d 11 c6 ff
    ld a,h              ;0340 7c
    rla                 ;0341 17
    jp c,l0347h         ;0342 da 47 03
    add hl,de           ;0345 19
    add hl,hl           ;0346 29
l0347h:
    sbc a,a             ;0347 9f
    ld h,a              ;0348 67
    ld l,a              ;0349 6f
    push hl             ;034a e5
    ld hl,(l0124h)      ;034b 2a 24 01
    ex de,hl            ;034e eb
    pop hl              ;034f e1
    ld a,h              ;0350 7c
    and d               ;0351 a2
    ld h,a              ;0352 67
    ld a,l              ;0353 7d
    and e               ;0354 a3
    ld l,a              ;0355 6f
    push hl             ;0356 e5
    ld hl,(l0116h)      ;0357 2a 16 01
    inc hl              ;035a 23
    ld l,(hl)           ;035b 6e
    ld h,00h            ;035c 26 00
    push hl             ;035e e5
    ld hl,(l011ah)      ;035f 2a 1a 01
    dec hl              ;0362 2b
    dec hl              ;0363 2b
    pop de              ;0364 d1
    ld a,d              ;0365 7a
    xor h               ;0366 ac
    ld a,h              ;0367 7c
    jp m,l036fh         ;0368 fa 6f 03
    ld a,l              ;036b 7d
    sub e               ;036c 93
    ld a,h              ;036d 7c
    sbc a,d             ;036e 9a
l036fh:
    rla                 ;036f 17
    sbc a,a             ;0370 9f
l0371h:
    ld h,a              ;0371 67
    ld l,a              ;0372 6f
    pop de              ;0373 d1
    ld a,h              ;0374 7c
    and d               ;0375 a2
l0376h:
    ld h,a              ;0376 67
    ld a,l              ;0377 7d
    and e               ;0378 a3
    ld l,a              ;0379 6f
    ld a,h              ;037a 7c
    or l                ;037b b5
    jp z,l03a6h         ;037c ca a6 03
    ld hl,(l0118h)      ;037f 2a 18 01
    call imug           ;0382 cd 4d 06
    ld a,(bc)           ;0385 0a
    nop                 ;0386 00
    push hl             ;0387 e5
    ld hl,(l0116h)      ;0388 2a 16 01
    ex de,hl            ;038b eb
    ld hl,(l011ah)      ;038c 2a 1a 01
    add hl,de           ;038f 19
    ld l,(hl)           ;0390 6e
    ld h,00h            ;0391 26 00
    pop de              ;0393 d1
    add hl,de           ;0394 19
    ld de,0ffd0h        ;0395 11 d0 ff
    add hl,de           ;0398 19
    ld (l0118h),hl      ;0399 22 18 01
    ld hl,(l011ah)      ;039c 2a 1a 01
    inc hl              ;039f 23
    ld (l011ah),hl      ;03a0 22 1a 01
    jp l031fh           ;03a3 c3 1f 03
l03a6h:
    ret                 ;03a6 c9
    call end            ;03a7 cd 72 06

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

writing_code:
    db 1bh
    dw writing_code+3
    db "writing controller code ..."

continue_yn:
    db 11h
    dw continue_yn+3
    db "Continue (Y/N) ? "

dashes:
    db 13h
    dw dashes+3
    db "--- ---------------"

for_mw:
    db 13h
    dw for_mw+3
    db "for Mini-Winchester"

dos_firm_upd:
    db 1dh
    dw dos_firm_upd+3
    db "DOS firmware updating program"

empty_string:
    db 0
    dw empty_string+3
    db 0, 0, 0

; Start of Unknown Library ==================================================

buffin:
;Buffered Console Input.  Caller must store buffer size at 80h.  On
;return, 81h will contain the number of data bytes and the data
;will start at 82h.
    ld c,0ah            ;04e2 0e 0a
    ld de,0080h         ;04e4 11 80 00
    jp 0005h            ;04e7 c3 05 00

mw_read:
    ld (var_4),hl       ;04ea 22 d6 05
    xor a               ;04ed af
    ld (hl),a           ;04ee 77
    inc hl              ;04ef 23
    ld (hl),a           ;04f0 77
    ld (var_3),a        ;04f1 32 d5 05
    ld a,(de)           ;04f4 1a
    ld (var_1),a        ;04f5 32 d3 05
    inc de              ;04f8 13
    ld a,(de)           ;04f9 1a
    ld (var_2),a        ;04fa 32 d4 05
    ld a,(bc)           ;04fd 0a
    ld l,a              ;04fe 6f
    inc bc              ;04ff 03
    ld a,(bc)           ;0500 0a
    ld h,a              ;0501 67
    push hl             ;0502 e5
    ld a,21h            ;0503 3e 21
    call mw_sub_0564h   ;0505 cd 64 05
sub_0508h:
    call mw_sub_059dh   ;0508 cd 9d 05
    call mw_sub_0581h   ;050b cd 81 05
    pop hl              ;050e e1
    jr nz,l055fh        ;050f 20 4e
    ld a,41h            ;0511 3e 41
    call mw_sub_0564h   ;0513 cd 64 05
    ld b,00h            ;0516 06 00
l0518h:
    in a,(18h)          ;0518 db 18
    ld (hl),a           ;051a 77
    inc hl              ;051b 23
    ex (sp),hl          ;051c e3
    ex (sp),hl          ;051d e3
    djnz l0518h         ;051e 10 f8
    call mw_sub_0581h   ;0520 cd 81 05
    ret z               ;0523 c8
    jp l055fh           ;0524 c3 5f 05

mw_write:
    ld (var_4),hl       ;0527 22 d6 05
l052ah:
    xor a               ;052a af
l052bh:
    ld (hl),a           ;052b 77
    inc hl              ;052c 23
    ld (hl),a           ;052d 77
    ld (var_3),a        ;052e 32 d5 05
    ld a,(de)           ;0531 1a
    ld (var_1),a        ;0532 32 d3 05
    inc de              ;0535 13
    ld a,(de)           ;0536 1a
    ld (var_2),a        ;0537 32 d4 05
    ld a,(bc)           ;053a 0a
    ld l,a              ;053b 6f
    inc bc              ;053c 03
    ld a,(bc)           ;053d 0a
    ld h,a              ;053e 67
    ld a,42h            ;053f 3e 42
    call mw_sub_0564h   ;0541 cd 64 05
    ld b,00h            ;0544 06 00
l0546h:
    ld a,(hl)           ;0546 7e
    out (18h),a         ;0547 d3 18
    inc hl              ;0549 23
    ex (sp),hl          ;054a e3
    ex (sp),hl          ;054b e3
    djnz l0546h         ;054c 10 f8
    call mw_sub_0581h   ;054e cd 81 05
    jr nz,l055fh        ;0551 20 0c
    ld a,22h            ;0553 3e 22
    call mw_sub_0564h   ;0555 cd 64 05
    call mw_sub_059dh   ;0558 cd 9d 05
    call mw_sub_0581h   ;055b cd 81 05
    ret z               ;055e c8
l055fh:
    ld hl,(var_4)       ;055f 2a d6 05
l0562h:
    ld (hl),a           ;0562 77
    ret                 ;0563 c9

mw_sub_0564h:
    ld b,a              ;0564 47
    xor a               ;0565 af
    out (18h),a         ;0566 d3 18
l0568h:
    in a,(18h)          ;0568 db 18
l056ah:
    cp 0a0h             ;056a fe a0
    jr nz,l0568h        ;056c 20 fa
    ld a,b              ;056e 78
    out (18h),a         ;056f d3 18
l0571h:
    in a,(18h)          ;0571 db 18
    cp 0a1h             ;0573 fe a1
    jr nz,l0571h        ;0575 20 fa
    ld a,0ffh           ;0577 3e ff
    out (18h),a         ;0579 d3 18
    ld b,14h            ;057b 06 14
l057dh:
    nop                 ;057d 00
    djnz l057dh         ;057e 10 fd
    ret                 ;0580 c9

mw_sub_0581h:
    ld a,0ffh           ;0581 3e ff
    out (18h),a         ;0583 d3 18
l0585h:
    in a,(18h)          ;0585 db 18
    inc a               ;0587 3c
    jr nz,l0585h        ;0588 20 fb
    ld a,0feh           ;058a 3e fe
    out (18h),a         ;058c d3 18
l058eh:
    in a,(18h)          ;058e db 18
    rla                 ;0590 17
    jr c,l058eh         ;0591 38 fb
    in a,(18h)          ;0593 db 18
    bit 6,a             ;0595 cb 77
    push af             ;0597 f5
sub_0598h:
    xor a               ;0598 af
l0599h:
    out (18h),a         ;0599 d3 18
    pop af              ;059b f1
    ret                 ;059c c9

mw_sub_059dh:
    xor a               ;059d af
    out (18h),a         ;059e d3 18
    ld hl,(var_1)       ;05a0 2a d3 05
    ld a,(var_3)        ;05a3 3a d5 05
    ld b,05h            ;05a6 06 05
l05a8h:
    rra                 ;05a8 1f
    rr h                ;05a9 cb 1c
l05abh:
    rr l                ;05ab cb 1d
l05adh:
    djnz l05a8h         ;05ad 10 f9
    ld a,(4033h)        ;05af 3a 33 40
    ld b,a              ;05b2 47
    and l               ;05b3 a5
    out (18h),a         ;05b4 d3 18
l05b6h:
    srl h               ;05b6 cb 3c
    rr l                ;05b8 cb 1d
    srl b               ;05ba cb 38
    jr nz,l05b6h        ;05bc 20 f8
    ld a,l              ;05be 7d
    out (18h),a         ;05bf d3 18
    ld a,h              ;05c1 7c
    out (18h),a         ;05c2 d3 18
    ld a,(var_1)        ;05c4 3a d3 05
    and 1fh             ;05c7 e6 1f
    out (18h),a         ;05c9 d3 18
    xor a               ;05cb af
    out (18h),a         ;05cc d3 18
    out (18h),a         ;05ce d3 18
    out (18h),a         ;05d0 d3 18
    ret                 ;05d2 c9

var_1:
    db 14h
var_2:
    db 00h
var_3:
    db 10h
var_4:
    db 0fdh

    db 0c9h

; Start of KLIB.REL =========================================================

; XSTRIN --------------------------------------------------------------------

tmp:
    db 3eh              ;header: string length
    dw 0d3ffh           ;header: start address of string
    db 18h, 0dbh        ;string data (not at start address ??)

print_spc:
    ld a,' '
    call conout
    ret

print_eol:
    ld a,0ah
    call conout
    ld a,0dh
    call conout
    ret

hex:
;XSTRIN: HEX
;Make a temporary string (length 2 bytes) with the hexadecimal
;representation of the byte in HL and return a pointer to it in HL.
;Implements BASIC function: HEX$(x)
;

    ld a,02h            ;A = 2 bytes in string
    ld (tmp),a          ;Store length in temp string header
    ld a,l              ;A = L
    call xstrin_3       ;Convert high nibble in A to ASCII
    ld (tmp+3),a        ;Save it as first char of string
    ld a,l              ;A = L
    call xstrin_4       ;Convert low nibble in A to ASCII
    ld (tmp+4),a        ;Save it as second char of string
    ld hl,tmp           ;HL = address of the string
    ret

xstrin_3:
    rrca
    rrca
    rrca
    rrca
xstrin_4:
    and 0fh
    cp 0ah
    jp m,xstrin_5
    add a,07h
xstrin_5:
    add a,30h
    ret

chr:
;XSTRIN: CHR
;Make a temporary string from the char in L and
;return a pointer to it in HL.
;Implements BASIC function: CHR$(x)
;
    ld a,01h            ;A = 1 byte in string
    ld (tmp),a          ;Store length in temp string header
    ld a,l              ;A = L
    ld (tmp+3),a        ;Store A as the temp string data
    ld hl,tmp           ;HL = address of the string
    ret

pv2d:
;XSTRIN: PV2D
;Print string in HL followed by CR+LF
;Implements BASIC command: PRINT"foo"
;
    ld a,(hl)
    or a
    jp z,print_eol
    call print_str
    jp print_eol

pv1d:
;XSTRIN: PV1D
;Print string in HL but do not send CR+LF
;Implements BASIC command: PRINT"foo";
;
    ld a,(hl)
    or a
    ret z
    call print_str
    ret

pv0d:
;XSTRIN: PV0D
;Print string in HL followed by a space
;
    ld a,(hl)
    or a
    jp z,print_spc
    call print_str
    jp print_spc



print_str:
;Print string of length A at pointer HL.
;
    ld b,a
    inc hl
    inc hl
    inc hl
l0643h:
    ld a,(hl)
    call conout
    dec b
    inc hl
    jp nz,l0643h
    ret

; MUL1 ----------------------------------------------------------------------

imug:
;MUL1: IMUG
    ld b,h              ;064d 44
    ld c,l              ;064e 4d
    pop hl              ;064f e1
    ld e,(hl)           ;0650 5e
    inc hl              ;0651 23
    ld d,(hl)           ;0652 56
    inc hl              ;0653 23
    push hl             ;0654 e5
    ld l,c              ;0655 69
    ld h,b              ;0656 60

imuh:
;MUL1: IMUH
    ld a,h              ;0657 7c
    or l                ;0658 b5
    ret z               ;0659 c8
    ex de,hl            ;065a eb
    ld a,h              ;065b 7c
    or l                ;065c b5
    ret z               ;065d c8
    ld b,h              ;065e 44
    ld c,l              ;065f 4d
sub_0660h:
    ld hl,0000h         ;0660 21 00 00
    ld a,10h            ;0663 3e 10
l0665h:
    add hl,hl           ;0665 29
    ex de,hl            ;0666 eb
    add hl,hl           ;0667 29
    ex de,hl            ;0668 eb
    jp nc,l066dh        ;0669 d2 6d 06
    add hl,bc           ;066c 09
l066dh:
    dec a               ;066d 3d
    jp nz,l0665h        ;066e c2 65 06
    ret                 ;0671 c9

; XXXLIB --------------------------------------------------------------------

end:
;XXXLIB: $END
;Jump to CP/M warm start
;Implements BASIC command: END
    jp 0000h

ini:
;XXXLIB: INI
;Jump to the address in HL
    jp (hl)

n5_0:
;XXXLIB: $5.0
;Do nothing and return
    ret

; CPMIO ---------------------------------------------------------------------

charin:
;CPMIO: CHARIN
    ld hl,0fffeh        ;0677 21 fe ff
    jp conin           ;067a c3 8c 06

conout:
;CPMIO: CONOUT
;Write the char in A to the console
    push hl
    push de
    push bc
    push af
    ld c,02h
    ld e,a
    call 0005h
    pop af
    pop bc
    pop de
    pop hl

pr0a:
;CPMIO: $PR0A
;Do nothing and return
    ret                 ;068b c9

conin:
;CPMIO: CONIN
    push de
    push bc
    push hl
    ld c,01h
    call 0005h
    pop hl
    ld (hl),a
    inc hl
    ld (hl),00h
    pop bc
    pop de
    ret

char:
;CPMIO: CHAR
    ld a,(hl)
    jp conout

;TODO: Unknown code below ---------------------------------------------------

    dec b               ;06a0 05
    ret                 ;06a1 c9
    ld a,(hl)           ;06a2 7e
    or a                ;06a3 b7
l06a4h:
    jp z,print_eol      ;06a4 ca e3 05
    call print_str      ;06a7 cd 3f 06
l06aah:
    jp print_eol        ;06aa c3 e3 05
    ld a,(hl)           ;06ad 7e
    or a                ;06ae b7
l06afh:
    ret z               ;06af c8
    call print_str      ;06b0 cd 3f 06
    ret                 ;06b3 c9
    ld a,(hl)           ;06b4 7e
    or a                ;06b5 b7
    jp z,print_spc      ;06b6 ca dd 05
    call print_str      ;06b9 cd 3f 06
    jp print_spc        ;06bc c3 dd 05
    ld b,a              ;06bf 47
    inc hl              ;06c0 23
    inc hl              ;06c1 23
    inc hl              ;06c2 23
    ld a,(hl)           ;06c3 7e
    call conout         ;06c4 cd 7d 06
    dec b               ;06c7 05
    inc hl              ;06c8 23
    jp nz,l0643h        ;06c9 c2 43 06
    ret                 ;06cc c9
    ld b,h              ;06cd 44
    ld c,l              ;06ce 4d
    pop hl              ;06cf e1
    ld e,(hl)           ;06d0 5e
    inc hl              ;06d1 23
    ld d,(hl)           ;06d2 56
    inc hl              ;06d3 23
    push hl             ;06d4 e5
    ld l,c              ;06d5 69
    ld h,b              ;06d6 60
    ld a,h              ;06d7 7c
    or l                ;06d8 b5
    ret z               ;06d9 c8
    ex de,hl            ;06da eb
    ld a,h              ;06db 7c
    or l                ;06dc b5
    ret z               ;06dd c8
    ld b,h              ;06de 44
    ld c,l              ;06df 4d
    ld hl,0000h         ;06e0 21 00 00
    ld a,10h            ;06e3 3e 10
    add hl,hl           ;06e5 29
    ex de,hl            ;06e6 eb
    add hl,hl           ;06e7 29
    ex de,hl            ;06e8 eb
    jp nc,l066dh        ;06e9 d2 6d 06
    add hl,bc           ;06ec 09
    dec a               ;06ed 3d
    jp nz,l0665h        ;06ee c2 65 06
    ret                 ;06f1 c9
    jp 0000h            ;06f2 c3 00 00
    jp (hl)             ;06f5 e9
    ret                 ;06f6 c9
    ld hl,0fffeh        ;06f7 21 fe ff
    jp conin            ;06fa c3 8c 06
    push hl             ;06fd e5
    push de             ;06fe d5
    push bc             ;06ff c5
    ld c,a              ;0700 4f
    ld hl,l0562h        ;0701 21 62 05
    add hl,bc           ;0704 09
    call sub_02f3h      ;0705 cd f3 02
    jp l0371h           ;0708 c3 71 03
l070bh:
    ld hl,n5_0          ;070b 21 76 06
    call sub_02f3h      ;070e cd f3 02
    ld a,d              ;0711 7a
    call 0692h          ;0712 cd 92 06
    jp l0371h           ;0715 c3 71 03
    call 002eh          ;0718 cd 2e 00
    ld c,3fh            ;071b 0e 3f
    call 0015h          ;071d cd 15 00
    ld hl,(0013h)       ;0720 2a 13 00
    ld sp,hl            ;0723 f9
    ld hl,0000h         ;0724 21 00 00
    add hl,sp           ;0727 39
    ld (0013h),hl       ;0728 22 13 00
    call sub_0338h      ;072b cd 38 03
    ld (0011h),hl       ;072e 22 11 00
    call 0689h          ;0731 cd 89 06
    call 015ah          ;0734 cd 5a 01
l0737h:
    ld hl,(0011h)       ;0737 2a 11 00
    ld (000ch),hl       ;073a 22 0c 00
    jp l052bh           ;073d c3 2b 05
    ld hl,(0013h)       ;0740 2a 13 00
    ld sp,hl            ;0743 f9
    ret                 ;0744 c9
    nop                 ;0745 00
    rlca                ;0746 07
    rrca                ;0747 0f
    rla                 ;0748 17
    rra                 ;0749 1f
    daa                 ;074a 27
    cpl                 ;074b 2f
    scf                 ;074c 37
    ccf                 ;074d 3f
l074eh:
    halt                ;074e 76
    ret                 ;074f c9
    ex (sp),hl          ;0750 e3
    jp (hl)             ;0751 e9
    ex de,hl            ;0752 eb
    di                  ;0753 f3
    ld sp,hl            ;0754 f9
    ei                  ;0755 fb
    add a,0ceh          ;0756 c6 ce
    out (0d6h),a        ;0758 d3 d6
    in a,(0deh)         ;075a db de
    and 0eeh            ;075c e6 ee
    or 0feh             ;075e f6 fe
    ld (322ah),hl       ;0760 22 2a 32
    ld a,(0cdc3h)       ;0763 3a c3 cd
    ld b,l              ;0766 45
    ld c,c              ;0767 49
    jr nz,$+34          ;0768 20 20
    ld d,e              ;076a 53
    ld d,b              ;076b 50
    ld c,b              ;076c 48
    ld c,h              ;076d 4c
    ld b,h              ;076e 44
    ld c,c              ;076f 49
    jr nz,$+34          ;0770 20 20
    ld e,b              ;0772 58
    ld b,e              ;0773 43
    ld c,b              ;0774 48
    ld b,a              ;0775 47
    ld d,b              ;0776 50
    ld b,e              ;0777 43
    ld c,b              ;0778 48
    ld c,h              ;0779 4c
    ld e,b              ;077a 58
    ld d,h              ;077b 54
l077ch:
    ld c,b              ;077c 48
    ld c,h              ;077d 4c
    ld d,d              ;077e 52
    ld b,l              ;077f 45
    ld d,h              ;0780 54
    jr nz,l07cbh        ;0781 20 48
    ld c,h              ;0783 4c
    ld d,h              ;0784 54
    jr nz,$+69          ;0785 20 43
    ld c,l              ;0787 4d
    ld b,e              ;0788 43
    jr nz,$+85          ;0789 20 53
    ld d,h              ;078b 54
    ld b,e              ;078c 43
    jr nz,$+69          ;078d 20 43
    ld c,l              ;078f 4d
    ld b,c              ;0790 41
    jr nz,l07d7h        ;0791 20 44
    ld b,c              ;0793 41
    ld b,c              ;0794 41
sub_0795h:
    jr nz,l07e9h        ;0795 20 52
    ld b,c              ;0797 41
    ld d,d              ;0798 52
    jr nz,l07edh        ;0799 20 52
    ld b,c              ;079b 41
    ld c,h              ;079c 4c
    jr nz,l07f1h        ;079d 20 52
    ld d,d              ;079f 52
    ld b,e              ;07a0 43
    jr nz,l07f5h        ;07a1 20 52
    ld c,h              ;07a3 4c
    ld b,e              ;07a4 43
    jr nz,l07f5h        ;07a5 20 4e
    ld c,a              ;07a7 4f
    ld d,b              ;07a8 50
    jr nz,$+69          ;07a9 20 43
    ld d,b              ;07ab 50
    ld c,c              ;07ac 49
    jr nz,$+81          ;07ad 20 4f
    ld d,d              ;07af 52
    ld c,c              ;07b0 49
    jr nz,l080bh        ;07b1 20 58
    ld d,d              ;07b3 52
    ld c,c              ;07b4 49
    jr nz,l07f8h        ;07b5 20 41
    ld c,(hl)           ;07b7 4e
    ld c,c              ;07b8 49
    jr nz,$+85          ;07b9 20 53
    ld b,d              ;07bb 42
    ld c,c              ;07bc 49
    jr nz,l0808h        ;07bd 20 49
    ld c,(hl)           ;07bf 4e
    jr nz,$+34          ;07c0 20 20
    ld d,e              ;07c2 53
    ld d,l              ;07c3 55
    ld c,c              ;07c4 49
    jr nz,$+81          ;07c5 20 4f
    ld d,l              ;07c7 55
l07c8h:
    ld d,h              ;07c8 54
    jr nz,l080ch        ;07c9 20 41
l07cbh:
    ld b,e              ;07cb 43
    ld c,c              ;07cc 49
    jr nz,l0810h        ;07cd 20 41
    ld b,h              ;07cf 44
    ld c,c              ;07d0 49
    jr nz,$+69          ;07d1 20 43
    ld b,c              ;07d3 41
    ld c,h              ;07d4 4c
    ld c,h              ;07d5 4c
    ld c,d              ;07d6 4a
l07d7h:
    ld c,l              ;07d7 4d
    ld d,b              ;07d8 50
    jr nz,l0827h        ;07d9 20 4c
    ld b,h              ;07db 44
    ld b,c              ;07dc 41
    jr nz,$+85          ;07dd 20 53
    ld d,h              ;07df 54
    ld b,c              ;07e0 41
    jr nz,l082fh        ;07e1 20 4c
    ld c,b              ;07e3 48
    ld c,h              ;07e4 4c
    ld b,h              ;07e5 44
    ld d,e              ;07e6 53
    ld c,b              ;07e7 48
    ld c,h              ;07e8 4c
l07e9h:
    ld b,h              ;07e9 44
    ld c,l              ;07ea 4d
    ld c,a              ;07eb 4f
    ld d,(hl)           ;07ec 56
l07edh:
    jr nz,l0830h        ;07ed 20 41
    ld b,h              ;07ef 44
    ld b,h              ;07f0 44
l07f1h:
    jr nz,l0834h        ;07f1 20 41
    ld b,h              ;07f3 44
l07f4h:
    ld b,e              ;07f4 43
l07f5h:
    jr nz,$+85          ;07f5 20 53
    ld d,l              ;07f7 55
l07f8h:
    ld b,d              ;07f8 42
    jr nz,l084eh        ;07f9 20 53
    ld b,d              ;07fb 42
    ld b,d              ;07fc 42
    jr nz,l0840h        ;07fd 20 41
    ld c,(hl)           ;07ff 4e
    ld b,c              ;0800 41
    jr nz,l085bh        ;0801 20 58
    ld d,d              ;0803 52
    ld b,c              ;0804 41
    jr nz,$+81          ;0805 20 4f
l0807h:
    ld d,d              ;0807 52
l0808h:
    ld b,c              ;0808 41
    jr nz,l084eh        ;0809 20 43
l080bh:
    ld c,l              ;080b 4d
l080ch:
    ld d,b              ;080c 50
    jr nz,$+75          ;080d 20 49
    ld c,(hl)           ;080f 4e
l0810h:
    ld d,d              ;0810 52
l0811h:
    jr nz,l0857h        ;0811 20 44
    ld b,e              ;0813 43
    ld d,d              ;0814 52
    jr nz,$+79          ;0815 20 4d
    ld d,(hl)           ;0817 56
    ld c,c              ;0818 49
    jr nz,l0867h        ;0819 20 4c
    ld e,b              ;081b 58
    ld c,c              ;081c 49
    jr nz,l0872h        ;081d 20 53
    ld d,h              ;081f 54
l0820h:
    ld b,c              ;0820 41
    ld e,b              ;0821 58
l0822h:
    ld c,c              ;0822 49
    ld c,(hl)           ;0823 4e
    ld e,b              ;0824 58
    jr nz,l086bh        ;0825 20 44
l0827h:
    ld b,c              ;0827 41
    ld b,h              ;0828 44
    jr nz,l0877h        ;0829 20 4c
    ld b,h              ;082b 44
    ld b,c              ;082c 41
    ld e,b              ;082d 58
    ld b,h              ;082e 44
l082fh:
    ld b,e              ;082f 43
l0830h:
    ld e,b              ;0830 58
    jr nz,$+84          ;0831 20 52
    ld d,e              ;0833 53
l0834h:
    ld d,h              ;0834 54
    jr nz,$+82          ;0835 20 50
    ld d,e              ;0837 53
    ld d,a              ;0838 57
    jr nz,$+82          ;0839 20 50
    ld c,a              ;083b 4f
l083ch:
    ld d,b              ;083c 50
    jr nz,l088fh        ;083d 20 50
    ld d,l              ;083f 55
l0840h:
    ld d,e              ;0840 53
    ld c,b              ;0841 48
l0842h:
    ld c,(hl)           ;0842 4e
    ld e,d              ;0843 5a
    ld e,d              ;0844 5a
    jr nz,l0895h        ;0845 20 4e
    ld b,e              ;0847 43
    ld b,e              ;0848 43
    jr nz,l089bh        ;0849 20 50
    ld c,a              ;084b 4f
l084ch:
    ld d,b              ;084c 50
    ld b,l              ;084d 45
l084eh:
    ld d,b              ;084e 50
    jr nz,l089eh        ;084f 20 4d
    jr nz,l0895h        ;0851 20 42
    jr nz,l0898h        ;0853 20 43
    jr nz,l089bh        ;0855 20 44
l0857h:
    jr nz,l089eh        ;0857 20 45
    jr nz,$+74          ;0859 20 48
l085bh:
    jr nz,l08a9h        ;085b 20 4c
    jr nz,l08ach        ;085d 20 4d
    jr nz,$+67          ;085f 20 41
    jr nz,l08a5h        ;0861 20 42
    jr nz,$+34          ;0863 20 20
    jr nz,$+70          ;0865 20 44
l0867h:
    jr nz,l0889h        ;0867 20 20
    jr nz,$+74          ;0869 20 48
l086bh:
    jr nz,$+34          ;086b 20 20
    jr nz,l08c2h        ;086d 20 53
    ld d,b              ;086f 50
    jr nz,l0892h        ;0870 20 20
l0872h:
    ld d,b              ;0872 50
    ld d,e              ;0873 53
    ld d,a              ;0874 57
    jr nz,$+65          ;0875 20 3f
l0877h:
    ccf                 ;0877 3f
    dec a               ;0878 3d
    jr nz,$-59          ;0879 20 c3
    sub (hl)            ;087b 96
    rrca                ;087c 0f
    jp l0fd1h           ;087d c3 d1 0f
    jp l06a4h           ;0880 c3 a4 06
    jp l06aah+2         ;0883 c3 ac 06
    jp l1416h           ;0886 c3 16 14
l0889h:
    jp l0fech           ;0889 c3 ec 0f
    jp l1014h           ;088c c3 14 10
l088fh:
    jp sub_0ffbh+2      ;088f c3 fd 0f
l0892h:
    jp l1045h           ;0892 c3 45 10
l0895h:
    jp l106ch+2         ;0895 c3 6e 10
l0898h:
    jp 1251h            ;0898 c3 51 12
l089bh:
    jp 10e8h            ;089b c3 e8 10
l089eh:
    jp l105fh           ;089e c3 5f 10
    jp 1090h            ;08a1 c3 90 10
    ex (sp),hl          ;08a4 e3
l08a5h:
    ld (l1750h+2),hl    ;08a5 22 52 17
    ex (sp),hl          ;08a8 e3
l08a9h:
    jp 0000h            ;08a9 c3 00 00
l08ach:
    ld hl,(0006h)       ;08ac 2a 06 00
    ld (l06aah),hl      ;08af 22 aa 06
    ld hl,l06a4h        ;08b2 21 a4 06
    ld (0001h),hl       ;08b5 22 01 00
l08b8h:
    ld hl,0000h         ;08b8 21 00 00
    ld (0006h),hl       ;08bb 22 06 00
    ld (17b1h),hl       ;08be 22 b1 17
    xor a               ;08c1 af
l08c2h:
    ld (1757h),a        ;08c2 32 57 17
    ld (l174dh+1),a     ;08c5 32 4e 17
    ld (l1725h),a       ;08c8 32 25 17
    ld (1754h),a        ;08cb 32 54 17
    ld hl,l0100h        ;08ce 21 00 01
    ld (000ch),hl       ;08d1 22 0c 00
    ld (l1765h),hl      ;08d4 22 65 17
    ld (l17e5h),hl      ;08d7 22 e5 17
    ld (l17b3h),hl      ;08da 22 b3 17
    ld hl,l0100h        ;08dd 21 00 01
    ld sp,17e3h         ;08e0 31 e3 17
    push hl             ;08e3 e5
    ld hl,0002h         ;08e4 21 02 00
sub_08e7h:
    push hl             ;08e7 e5
    dec hl              ;08e8 2b
    dec hl              ;08e9 2b
    ld (17e3h),hl       ;08ea 22 e3 17
    push hl             ;08ed e5
    push hl             ;08ee e5
    ld (l1750h),hl      ;08ef 22 50 17
    ld a,0c3h           ;08f2 3e c3
    ld (0038h),a        ;08f4 32 38 00
    ld hl,0686h         ;08f7 21 86 06
    ld (0039h),hl       ;08fa 22 39 00
    ld a,(005dh)        ;08fd 3a 5d 00
    cp 20h              ;0900 fe 20
    jp z,l070bh         ;0902 ca 0b 07
    ld hl,0000h         ;0905 21 00 00
    jp l0c77h           ;0908 c3 77 0c
    ld sp,17dbh         ;090b 31 db 17
    call l105fh         ;090e cd 5f 10
    ld c,01h            ;0911 0e 01
    call nz,l06a4h      ;0913 c4 a4 06
    call sub_1055h      ;0916 cd 55 10
    ld a,23h            ;0919 3e 23
    call sub_0ffbh+2    ;091b cd fd 0f
    call l0fech         ;091e cd ec 0f
    call l1014h         ;0921 cd 14 10
    cp 0dh              ;0924 fe 0d
    jp z,l070bh         ;0926 ca 0b 07
    ld hl,174ch         ;0929 21 4c 17
    ld (hl),00h         ;092c 36 00
    cp 2dh              ;092e fe 2d
    jp nz,l0737h        ;0930 c2 37 07
    dec (hl)            ;0933 35
    call l1014h         ;0934 cd 14 10
    sub 41h             ;0937 d6 41
    jp c,l0fe1h         ;0939 da e1 0f
    cp 1ah              ;093c fe 1a
    jp nc,l0fe1h        ;093e d2 e1 0f
l0941h:
    ld e,a              ;0941 5f
    ld d,00h            ;0942 16 00
    ld hl,l074eh        ;0944 21 4e 07
    add hl,de           ;0947 19
    add hl,de           ;0948 19
l0949h:
    ld e,(hl)           ;0949 5e
    inc hl              ;094a 23
    ld d,(hl)           ;094b 56
    ex de,hl            ;094c eb
l094dh:
    jp (hl)             ;094d e9
    and h               ;094e a4
    rlca                ;094f 07
    pop hl              ;0950 e1
    rrca                ;0951 0f
l0952h:
    defb 0fdh,07h,02dh  ;illegal sequence
    ex af,af'           ;0955 08
    pop hl              ;0956 e1
    rrca                ;0957 0f
    pop af              ;0958 f1
    ex af,af'           ;0959 08
    dec b               ;095a 05
    add hl,bc           ;095b 09
    ret                 ;095c c9
    add hl,bc           ;095d 09
    ld sp,hl            ;095e f9
    ld a,(bc)           ;095f 0a
    pop hl              ;0960 e1
    rrca                ;0961 0f
    pop hl              ;0962 e1
    rrca                ;0963 0f
    adc a,07h           ;0964 ce 07
    ld h,a              ;0966 67
    dec bc              ;0967 0b
    pop hl              ;0968 e1
    rrca                ;0969 0f
    pop hl              ;096a e1
    rrca                ;096b 0f
    and l               ;096c a5
    dec bc              ;096d 0b
    pop hl              ;096e e1
    rrca                ;096f 0f
    ld h,a              ;0970 67
    inc c               ;0971 0c
    ld d,d              ;0972 52
    ld c,0e1h           ;0973 0e e1
    ld c,0dch           ;0975 0e dc
    ld c,0e1h           ;0977 0e e1
    rrca                ;0979 0f
    pop hl              ;097a e1
    rrca                ;097b 0f
    dec e               ;097c 1d
    rrca                ;097d 0f
    pop hl              ;097e e1
    rrca                ;097f 0f
l0980h:
    pop hl              ;0980 e1
    rrca                ;0981 0f
    push hl             ;0982 e5
    push de             ;0983 d5
    push bc             ;0984 c5
    xor a               ;0985 af
    ld (005bh),a        ;0986 32 5b 00
    ld c,0fh            ;0989 0e 0f
    ld de,005ch         ;098b 11 5c 00
    call l06a4h         ;098e cd a4 06
    pop bc              ;0991 c1
    pop de              ;0992 d1
    pop hl              ;0993 e1
    ret                 ;0994 c9
    ld a,01h            ;0995 3e 01
    ld (l174dh+1),a     ;0997 32 4e 17
    ld hl,0680h         ;099a 21 80 06
    ld (0006h),hl       ;099d 22 06 00
    ld (17b1h),hl       ;09a0 22 b1 17
    ret                 ;09a3 c9
    call sub_0b96h      ;09a4 cd 96 0b
    jp nc,l0fe1h        ;09a7 d2 e1 0f
    call 1251h          ;09aa cd 51 12
    or a                ;09ad b7
    jp nz,07beh         ;09ae c2 be 07
    ld a,(174ch)        ;09b1 3a 4c 17
    or a                ;09b4 b7
    jp z,l07c8h         ;09b5 ca c8 07
    call sub_0795h      ;09b8 cd 95 07
    jp l070bh           ;09bb c3 0b 07
    dec a               ;09be 3d
    jp nz,l0fe1h        ;09bf c2 e1 0f
    call 10e8h          ;09c2 cd e8 10
    ld (000ch),hl       ;09c5 22 0c 00
    call 0009h          ;09c8 cd 09 00
    jp l070bh           ;09cb c3 0b 07
    call sub_0b96h      ;09ce cd 96 0b
    jp nc,l0fe1h        ;09d1 d2 e1 0f
    call 1251h          ;09d4 cd 51 12
    jp z,l07f1h+1       ;09d7 ca f2 07
    call 10e8h          ;09da cd e8 10
    ld (000ch),hl       ;09dd 22 0c 00
    dec a               ;09e0 3d
    jp z,l07f1h+1       ;09e1 ca f2 07
    call 10e8h          ;09e4 cd e8 10
    ld (000eh),hl       ;09e7 22 0e 00
    dec a               ;09ea 3d
    jp nz,l0fe1h        ;09eb c2 e1 0f
    xor a               ;09ee af
    jp l07f4h           ;09ef c3 f4 07
    ld a,0ch            ;09f2 3e 0c
    ld (0010h),a        ;09f4 32 10 00
    call 0006h          ;09f7 cd 06 00
    jp l070bh           ;09fa c3 0b 07
    call 1251h          ;09fd cd 51 12
    jp c,l0fe1h         ;0a00 da e1 0f
l0a03h:
    jp z,l0fe1h         ;0a03 ca e1 0f
    call 10e8h          ;0a06 cd e8 10
    push hl             ;0a09 e5
    ld bc,0000h         ;0a0a 01 00 00
    dec a               ;0a0d 3d
    jp nz,0816h         ;0a0e c2 16 08
l0a11h:
    push bc             ;0a11 c5
    push bc             ;0a12 c5
    jp 0826h            ;0a13 c3 26 08
    call 10e8h          ;0a16 cd e8 10
l0a19h:
    push hl             ;0a19 e5
    dec a               ;0a1a 3d
    jp nz,l0822h        ;0a1b c2 22 08
    push bc             ;0a1e c5
    jp 0826h            ;0a1f c3 26 08
    call 10e8h          ;0a22 cd e8 10
    push hl             ;0a25 e5
    pop de              ;0a26 d1
    pop bc              ;0a27 c1
    ld hl,l070bh        ;0a28 21 0b 07
    ex (sp),hl          ;0a2b e3
    jp (hl)             ;0a2c e9
l0a2dh:
    call sub_1242h      ;0a2d cd 42 12
    jp z,l084ch         ;0a30 ca 4c 08
    call 10e8h          ;0a33 cd e8 10
    jp c,l083ch         ;0a36 da 3c 08
    ld (l1765h),hl      ;0a39 22 65 17
    and 7fh             ;0a3c e6 7f
    dec a               ;0a3e 3d
    jp z,l084ch         ;0a3f ca 4c 08
    call 10e8h          ;0a42 cd e8 10
    dec a               ;0a45 3d
    jp nz,l0fe1h        ;0a46 c2 e1 0f
    jp l0857h           ;0a49 c3 57 08
    ld hl,(l1765h)      ;0a4c 2a 65 17
    ld a,l              ;0a4f 7d
    and 0f0h            ;0a50 e6 f0
    ld l,a              ;0a52 6f
    ld de,00bfh         ;0a53 11 bf 00
    add hl,de           ;0a56 19
l0a57h:
    ld (l1765h+2),hl    ;0a57 22 67 17
    call sub_1055h      ;0a5a cd 55 10
    call l105fh         ;0a5d cd 5f 10
    jp nz,l070bh        ;0a60 c2 0b 07
    ld hl,(l1765h)      ;0a63 2a 65 17
    ld (1769h),hl       ;0a66 22 69 17
    call 10a7h          ;0a69 cd a7 10
    ld a,3ah            ;0a6c 3e 3a
    call sub_0ffbh+2    ;0a6e cd fd 0f
    ld a,(l174dh)       ;0a71 3a 4d 17
    or a                ;0a74 b7
    jp z,l0892h+1       ;0a75 ca 93 08
    ld c,08h            ;0a78 0e 08
    call sub_0ffbh      ;0a7a cd fb 0f
    ld e,(hl)           ;0a7d 5e
    inc hl              ;0a7e 23
    ld d,(hl)           ;0a7f 56
    inc hl              ;0a80 23
    ex de,hl            ;0a81 eb
    call 10a7h          ;0a82 cd a7 10
l0a85h:
    ex de,hl            ;0a85 eb
    call 10beh          ;0a86 cd be 10
    jp c,l08a5h+2       ;0a89 da a7 08
    dec c               ;0a8c 0d
    jp nz,087ah         ;0a8d c2 7a 08
    jp l08a5h+2         ;0a90 c3 a7 08
    call sub_0ffbh      ;0a93 cd fb 0f
    ld a,(hl)           ;0a96 7e
    call l1045h         ;0a97 cd 45 10
    inc hl              ;0a9a 23
    call 10beh          ;0a9b cd be 10
    jp c,l08a5h+2       ;0a9e da a7 08
    ld a,l              ;0aa1 7d
l0aa2h:
    and 0fh             ;0aa2 e6 0f
    jp nz,l0892h+1      ;0aa4 c2 93 08
    ld (l1765h),hl      ;0aa7 22 65 17
    ld a,(174ch)        ;0aaa 3a 4c 17
    or a                ;0aad b7
l0aaeh:
    jp nz,08cah         ;0aae c2 ca 08
    ld hl,(1769h)       ;0ab1 2a 69 17
    ex de,hl            ;0ab4 eb
    call sub_0ffbh      ;0ab5 cd fb 0f
    ld a,(de)           ;0ab8 1a
sub_0ab9h:
    call sub_10afh      ;0ab9 cd af 10
    inc de              ;0abc 13
    ld hl,(l1765h)      ;0abd 2a 65 17
    ld a,l              ;0ac0 7d
sub_0ac1h:
    sub e               ;0ac1 93
    jp nz,l08b8h        ;0ac2 c2 b8 08
    ld a,h              ;0ac5 7c
    sub d               ;0ac6 92
    jp nz,l08b8h        ;0ac7 c2 b8 08
    ld hl,(l1765h)      ;0aca 2a 65 17
l0acdh:
    call 10beh          ;0acd cd be 10
    jp c,l070bh         ;0ad0 da 0b 07
    jp 085ah            ;0ad3 c3 5a 08
    call 1251h          ;0ad6 cd 51 12
    cp 03h              ;0ad9 fe 03
    jp nz,l0fe1h        ;0adb c2 e1 0f
    call 10e8h          ;0ade cd e8 10
    push hl             ;0ae1 e5
    call 10e8h          ;0ae2 cd e8 10
    push hl             ;0ae5 e5
l0ae6h:
    call 10e8h          ;0ae6 cd e8 10
    pop de              ;0ae9 d1
    pop bc              ;0aea c1
    ret                 ;0aeb c9
    ld a,e              ;0aec 7b
    sub c               ;0aed 91
    ld a,d              ;0aee 7a
    sbc a,b             ;0aef 98
    ret                 ;0af0 c9
    call 08d6h          ;0af1 cd d6 08
    ld a,h              ;0af4 7c
    or a                ;0af5 b7
    jp nz,l0fe1h        ;0af6 c2 e1 0f
    call 08ech          ;0af9 cd ec 08
    jp c,l070bh         ;0afc da 0b 07
    ld a,l              ;0aff 7d
    ld (bc),a           ;0b00 02
    inc bc              ;0b01 03
    jp 08f9h            ;0b02 c3 f9 08
    xor a               ;0b05 af
    ld (1746h),a        ;0b06 32 46 17
l0b09h:
    call sub_1055h      ;0b09 cd 55 10
    call 1251h          ;0b0c cd 51 12
    ld (1747h),a        ;0b0f 32 47 17
    call 10e8h          ;0b12 cd e8 10
    push hl             ;0b15 e5
    call 10e8h          ;0b16 cd e8 10
l0b19h:
    ld (l1748h),hl      ;0b19 22 48 17
    push hl             ;0b1c e5
    call 10e8h          ;0b1d cd e8 10
    ld (l1748h+2),hl    ;0b20 22 4a 17
    ld b,h              ;0b23 44
    ld c,l              ;0b24 4d
    pop de              ;0b25 d1
    pop hl              ;0b26 e1
    jp 0931h            ;0b27 c3 31 09
    push hl             ;0b2a e5
    ld hl,1746h         ;0b2b 21 46 17
    ld (hl),0ffh        ;0b2e 36 ff
    pop hl              ;0b30 e1
    di                  ;0b31 f3
    jp z,l094dh         ;0b32 ca 4d 09
l0b35h:
    jp c,093bh          ;0b35 da 3b 09
    ld (l17e5h),hl      ;0b38 22 e5 17
    and 7fh             ;0b3b e6 7f
    dec a               ;0b3d 3d
    jp z,l094dh         ;0b3e ca 4d 09
    call 09a1h          ;0b41 cd a1 09
    dec a               ;0b44 3d
    jp z,l094dh         ;0b45 ca 4d 09
    ld e,c              ;0b48 59
l0b49h:
    ld d,b              ;0b49 50
    call 09a1h          ;0b4a cd a1 09
    ld hl,l1725h+1      ;0b4d 21 26 17
    ld c,08h            ;0b50 0e 08
    push hl             ;0b52 e5
    ld a,(hl)           ;0b53 7e
    or a                ;0b54 b7
l0b55h:
    jp z,0987h          ;0b55 ca 87 09
    inc hl              ;0b58 23
    ld e,(hl)           ;0b59 5e
    inc hl              ;0b5a 23
    ld d,(hl)           ;0b5b 56
    push hl             ;0b5c e5
    ld a,(1746h)        ;0b5d 3a 46 17
    or a                ;0b60 b7
    jp z,l0980h         ;0b61 ca 80 09
    ld hl,(l17e5h)      ;0b64 2a e5 17
    ld a,e              ;0b67 7b
    cp l                ;0b68 bd
    jp nz,l0980h        ;0b69 c2 80 09
    ld a,d              ;0b6c 7a
    cp h                ;0b6d bc
    jp nz,l0980h        ;0b6e c2 80 09
    pop hl              ;0b71 e1
    pop hl              ;0b72 e1
    ld (1723h),hl       ;0b73 22 23 17
    push hl             ;0b76 e5
sub_0b77h:
    ld a,(hl)           ;0b77 7e
    ld (hl),00h         ;0b78 36 00
    ld (1722h),a        ;0b7a 32 22 17
    jp 0987h            ;0b7d c3 87 09
    pop hl              ;0b80 e1
    inc hl              ;0b81 23
    ld a,(de)           ;0b82 1a
    ld (hl),a           ;0b83 77
sub_0b84h:
    ex de,hl            ;0b84 eb
    ld (hl),0ffh        ;0b85 36 ff
    pop hl              ;0b87 e1
    ld de,0004h         ;0b88 11 04 00
    add hl,de           ;0b8b 19
    dec c               ;0b8c 0d
    jp nz,l0952h        ;0b8d c2 52 09
    ld sp,17dbh         ;0b90 31 db 17
    pop de              ;0b93 d1
sub_0b94h:
    pop bc              ;0b94 c1
    pop af              ;0b95 f1
sub_0b96h:
    pop hl              ;0b96 e1
    ld sp,hl            ;0b97 f9
    ld hl,(l17e5h)      ;0b98 2a e5 17
    push hl             ;0b9b e5
    ld hl,(17e3h)       ;0b9c 2a e3 17
    ei                  ;0b9f fb
    ret                 ;0ba0 c9
    push af             ;0ba1 f5
    push bc             ;0ba2 c5
    ld hl,1757h         ;0ba3 21 57 17
    ld a,(hl)           ;0ba6 7e
    inc (hl)            ;0ba7 34
    or a                ;0ba8 b7
    jp z,09bch          ;0ba9 ca bc 09
    inc hl              ;0bac 23
    ld a,(hl)           ;0bad 7e
    inc hl              ;0bae 23
    ld b,(hl)           ;0baf 46
    inc hl              ;0bb0 23
    cp e                ;0bb1 bb
    jp nz,09bch         ;0bb2 c2 bc 09
l0bb5h:
    ld a,b              ;0bb5 78
    cp d                ;0bb6 ba
    jp nz,09bch         ;0bb7 c2 bc 09
    ld a,(hl)           ;0bba 7e
    ld (de),a           ;0bbb 12
    inc hl              ;0bbc 23
    ld (hl),e           ;0bbd 73
    inc hl              ;0bbe 23
    ld (hl),d           ;0bbf 72
    inc hl              ;0bc0 23
    ld a,(de)           ;0bc1 1a
    ld (hl),a           ;0bc2 77
    ld a,0ffh           ;0bc3 3e ff
    ld (de),a           ;0bc5 12
l0bc6h:
    pop bc              ;0bc6 c1
    pop af              ;0bc7 f1
    ret                 ;0bc8 c9
    call 1251h          ;0bc9 cd 51 12
    jp z,l0a85h         ;0bcc ca 85 0a
    call 10e8h          ;0bcf cd e8 10
    dec a               ;0bd2 3d
    jp z,l0a03h         ;0bd3 ca 03 0a
    dec a               ;0bd6 3d
    jp nz,l0fe1h        ;0bd7 c2 e1 0f
    push hl             ;0bda e5
    call 10e8h          ;0bdb cd e8 10
    pop de              ;0bde d1
    push hl             ;0bdf e5
    call sub_1055h      ;0be0 cd 55 10
    add hl,de           ;0be3 19
    call 10a7h          ;0be4 cd a7 10
    call sub_0ffbh      ;0be7 cd fb 0f
    pop hl              ;0bea e1
    xor a               ;0beb af
    sub l               ;0bec 95
    ld l,a              ;0bed 6f
    ld a,00h            ;0bee 3e 00
    sbc a,h             ;0bf0 9c
    ld h,a              ;0bf1 67
    add hl,de           ;0bf2 19
    call 10a7h          ;0bf3 cd a7 10
    jp l070bh           ;0bf6 c3 0b 07
    djnz l0c22h         ;0bf9 10 27
l0bfbh:
    ret pe              ;0bfb e8
    inc bc              ;0bfc 03
l0bfdh:
    ld h,h              ;0bfd 64
    nop                 ;0bfe 00
    ld a,(bc)           ;0bff 0a
    nop                 ;0c00 00
    ld bc,0eb00h        ;0c01 01 00 eb
    call sub_1055h      ;0c04 cd 55 10
    push de             ;0c07 d5
    push de             ;0c08 d5
    call l106ch+2       ;0c09 cd 6e 10
    call sub_0ffbh      ;0c0c cd fb 0f
    ld a,23h            ;0c0f 3e 23
    call sub_0ffbh+2    ;0c11 cd fd 0f
    ld b,85h            ;0c14 06 85
    ld hl,09f9h         ;0c16 21 f9 09
    ld e,(hl)           ;0c19 5e
    inc hl              ;0c1a 23
    ld d,(hl)           ;0c1b 56
    inc hl              ;0c1c 23
    ex (sp),hl          ;0c1d e3
    ld c,30h            ;0c1e 0e 30
    ld a,l              ;0c20 7d
    sub e               ;0c21 93
l0c22h:
    ld l,a              ;0c22 6f
    ld a,h              ;0c23 7c
    sbc a,d             ;0c24 9a
l0c25h:
    ld h,a              ;0c25 67
    jp c,l0a2dh         ;0c26 da 2d 0a
    inc c               ;0c29 0c
    jp 0a20h            ;0c2a c3 20 0a
    add hl,de           ;0c2d 19
    ld a,b              ;0c2e 78
    or a                ;0c2f b7
    jp p,0a44h          ;0c30 f2 44 0a
    push af             ;0c33 f5
    ld a,c              ;0c34 79
    cp 30h              ;0c35 fe 30
    jp z,0a4bh          ;0c37 ca 4b 0a
    call sub_0ffbh+2    ;0c3a cd fd 0f
    pop af              ;0c3d f1
    and 7fh             ;0c3e e6 7f
    ld b,a              ;0c40 47
    jp l0a57h           ;0c41 c3 57 0a
    ld a,c              ;0c44 79
    call sub_0ffbh+2    ;0c45 cd fd 0f
l0c48h:
    jp l0a57h           ;0c48 c3 57 0a
    pop af              ;0c4b f1
    and 7fh             ;0c4c e6 7f
    cp 01h              ;0c4e fe 01
    jp nz,l0a57h        ;0c50 c2 57 0a
    ld b,a              ;0c53 47
    jp 0a44h            ;0c54 c3 44 0a
    ex (sp),hl          ;0c57 e3
    dec b               ;0c58 05
sub_0c59h:
    jp nz,l0a19h        ;0c59 c2 19 0a
    pop de              ;0c5c d1
    pop de              ;0c5d d1
    ld a,d              ;0c5e 7a
    or a                ;0c5f b7
    jp nz,l070bh        ;0c60 c2 0b 07
    ld a,e              ;0c63 7b
    and 7fh             ;0c64 e6 7f
    cp 20h              ;0c66 fe 20
    jp c,l070bh         ;0c68 da 0b 07
    inc a               ;0c6b 3c
    jp z,l070bh         ;0c6c ca 0b 07
    call sub_0ffbh      ;0c6f cd fb 0f
    ld a,27h            ;0c72 3e 27
    call sub_0ffbh+2    ;0c74 cd fd 0f
l0c77h:
    ld a,e              ;0c77 7b
    and 7fh             ;0c78 e6 7f
    call sub_0ffbh+2    ;0c7a cd fd 0f
    ld a,27h            ;0c7d 3e 27
    call sub_0ffbh+2    ;0c7f cd fd 0f
l0c82h:
    jp l070bh           ;0c82 c3 0b 07
    ld hl,(17b1h)       ;0c85 2a b1 17
    inc hl              ;0c88 23
    inc hl              ;0c89 23
    ld d,(hl)           ;0c8a 56
    dec hl              ;0c8b 2b
    ld e,(hl)           ;0c8c 5e
    dec hl              ;0c8d 2b
    ld c,(hl)           ;0c8e 4e
    dec hl              ;0c8f 2b
    ld a,c              ;0c90 79
    cp 10h              ;0c91 fe 10
    jp nc,l070bh        ;0c93 d2 0b 07
    call sub_1055h      ;0c96 cd 55 10
    ex de,hl            ;0c99 eb
    call 10a7h          ;0c9a cd a7 10
    ex de,hl            ;0c9d eb
    call sub_0ffbh      ;0c9e cd fb 0f
    inc c               ;0ca1 0c
    dec c               ;0ca2 0d
    jp z,l0aaeh         ;0ca3 ca ae 0a
    ld a,(hl)           ;0ca6 7e
    dec hl              ;0ca7 2b
    call sub_0ffbh+2    ;0ca8 cd fd 0f
    jp l0aa2h           ;0cab c3 a2 0a
l0caeh:
    call l105fh         ;0cae cd 5f 10
    jp nz,l070bh        ;0cb1 c2 0b 07
    jp 0a8ah            ;0cb4 c3 8a 0a
    ld b,00h            ;0cb7 06 00
    ld a,b              ;0cb9 78
    ld b,00h            ;0cba 06 00
    or a                ;0cbc b7
    ret nz              ;0cbd c0
    jp l1014h           ;0cbe c3 14 10
l0cc1h:
    cp 2eh              ;0cc1 fe 2e
    ret z               ;0cc3 c8
    cp 0dh              ;0cc4 fe 0d
    ret z               ;0cc6 c8
    cp 2ah              ;0cc7 fe 2a
    ret z               ;0cc9 c8
    cp 20h              ;0cca fe 20
    ret                 ;0ccc c9
    call sub_0ac1h      ;0ccd cd c1 0a
    jp z,l0ae6h         ;0cd0 ca e6 0a
    ld (hl),a           ;0cd3 77
    inc hl              ;0cd4 23
    call sub_0ab9h      ;0cd5 cd b9 0a
    dec c               ;0cd8 0d
    jp nz,l0acdh        ;0cd9 c2 cd 0a
    call sub_0ac1h      ;0cdc cd c1 0a
    ret z               ;0cdf c8
    call sub_0ab9h      ;0ce0 cd b9 0a
    jp 0adch            ;0ce3 c3 dc 0a
    ld d,20h            ;0ce6 16 20
    cp 2ah              ;0ce8 fe 2a
    jp nz,0af2h         ;0cea c2 f2 0a
    call sub_0ab9h      ;0ced cd b9 0a
    ld d,3fh            ;0cf0 16 3f
    ld (hl),d           ;0cf2 72
    inc hl              ;0cf3 23
    dec c               ;0cf4 0d
    jp nz,0af2h         ;0cf5 c2 f2 0a
    ret                 ;0cf8 c9
    ld a,(174ch)        ;0cf9 3a 4c 17
l0cfch:
    or a                ;0cfc b7
    jp nz,l0fe1h        ;0cfd c2 e1 0f
    ld de,l176dh+1      ;0d00 11 6e 17
    ld hl,0080h         ;0d03 21 80 00
    ld a,(de)           ;0d06 1a
    ld c,a              ;0d07 4f
    ld (hl),a           ;0d08 77
    inc c               ;0d09 0c
    inc de              ;0d0a 13
    inc de              ;0d0b 13
    inc hl              ;0d0c 23
    ld a,(de)           ;0d0d 1a
    ld (hl),a           ;0d0e 77
    dec c               ;0d0f 0d
    jp nz,l0b09h+2      ;0d10 c2 0b 0b
    ld (hl),c           ;0d13 71
    ld e,02h            ;0d14 1e 02
    ld hl,005ch         ;0d16 21 5c 00
    call 0ab7h          ;0d19 cd b7 0a
sub_0d1ch:
    cp 20h              ;0d1c fe 20
    jp z,l0b19h         ;0d1e ca 19 0b
    push af             ;0d21 f5
    call sub_0ab9h      ;0d22 cd b9 0a
    cp 3ah              ;0d25 fe 3a
    jp nz,l0b35h        ;0d27 c2 35 0b
    pop af              ;0d2a f1
    sub 40h             ;0d2b d6 40
    ld (hl),a           ;0d2d 77
    inc hl              ;0d2e 23
    call 0ab7h          ;0d2f cd b7 0a
sub_0d32h:
    jp 0b3ah            ;0d32 c3 3a 0b
    ld b,a              ;0d35 47
    ld (hl),00h         ;0d36 36 00
    inc hl              ;0d38 23
    pop af              ;0d39 f1
    ld c,08h            ;0d3a 0e 08
    call l0acdh         ;0d3c cd cd 0a
    cp 2eh              ;0d3f fe 2e
    call z,sub_0ab9h    ;0d41 cc b9 0a
    ld c,03h            ;0d44 0e 03
    call l0acdh         ;0d46 cd cd 0a
    call 0ac4h          ;0d49 cd c4 0a
    jp z,l0b55h         ;0d4c ca 55 0b
    call sub_0ab9h      ;0d4f cd b9 0a
    jp l0b49h           ;0d52 c3 49 0b
    ld c,04h            ;0d55 0e 04
    ld (hl),00h         ;0d57 36 00
    inc hl              ;0d59 23
    dec c               ;0d5a 0d
    jp nz,l0b55h+2      ;0d5b c2 57 0b
    dec e               ;0d5e 1d
    jp nz,l0b19h        ;0d5f c2 19 0b
    ld (hl),00h         ;0d62 36 00
    jp l070bh           ;0d64 c3 0b 07
    call 08d6h          ;0d67 cd d6 08
    call 08ech          ;0d6a cd ec 08
    jp c,l070bh         ;0d6d da 0b 07
    ld a,(bc)           ;0d70 0a
    inc bc              ;0d71 03
    ld (hl),a           ;0d72 77
    inc hl              ;0d73 23
    jp 0b6ah            ;0d74 c3 6a 0b
    ld hl,0065h         ;0d77 21 65 00
    cp (hl)             ;0d7a be
    ret nz              ;0d7b c0
    ld a,b              ;0d7c 78
    inc hl              ;0d7d 23
    cp (hl)             ;0d7e be
    ret nz              ;0d7f c0
    ld a,c              ;0d80 79
    inc hl              ;0d81 23
l0d82h:
    cp (hl)             ;0d82 be
    ret                 ;0d83 c9
    ex de,hl            ;0d84 eb
l0d85h:
    ld hl,(l17b3h)      ;0d85 2a b3 17
    ld a,l              ;0d88 7d
    sub e               ;0d89 93
    ld a,h              ;0d8a 7c
    sbc a,d             ;0d8b 9a
    ex de,hl            ;0d8c eb
    ret                 ;0d8d c9
    call sub_0b84h      ;0d8e cd 84 0b
    ret nc              ;0d91 d0
    ld (l17b3h),hl      ;0d92 22 b3 17
    ret                 ;0d95 c9
    ld a,(l174dh+1)     ;0d96 3a 4e 17
    cp 01h              ;0d99 fe 01
    ret nc              ;0d9b d0
    push hl             ;0d9c e5
    ld hl,0000h         ;0d9d 21 00 00
    call sub_0b84h      ;0da0 cd 84 0b
    pop hl              ;0da3 e1
    ret                 ;0da4 c9
    call 1251h          ;0da5 cd 51 12
    jp c,l0fe1h         ;0da8 da e1 0f
    jp z,0c31h          ;0dab ca 31 0c
    call 10e8h          ;0dae cd e8 10
l0db1h:
    push hl             ;0db1 e5
    ld hl,0001h         ;0db2 21 01 00
    dec a               ;0db5 3d
l0db6h:
    ld a,(174ch)        ;0db6 3a 4c 17
    jp z,l0bc6h         ;0db9 ca c6 0b
    or a                ;0dbc b7
    jp nz,l0fe1h        ;0dbd c2 e1 0f
    call 10e8h          ;0dc0 cd e8 10
    jp 0bd0h            ;0dc3 c3 d0 0b
    ld hl,0000h         ;0dc6 21 00 00
    or a                ;0dc9 b7
    jp nz,0bd0h         ;0dca c2 d0 0b
    ld hl,0001h         ;0dcd 21 01 00
    ld a,h              ;0dd0 7c
    or a                ;0dd1 b7
    jp nz,l0fe1h        ;0dd2 c2 e1 0f
    ld (l17afh),hl      ;0dd5 22 af 17
    ld hl,l1725h+1      ;0dd8 21 26 17
l0ddbh:
    ld c,08h            ;0ddb 0e 08
    push hl             ;0ddd e5
    ld a,(hl)           ;0dde 7e
    or a                ;0ddf b7
    jp z,l0bfdh         ;0de0 ca fd 0b
    inc hl              ;0de3 23
    ld a,(hl)           ;0de4 7e
    inc hl              ;0de5 23
    ld d,(hl)           ;0de6 56
    pop hl              ;0de7 e1
    ex (sp),hl          ;0de8 e3
    cp l                ;0de9 bd
    jp nz,l0bfbh        ;0dea c2 fb 0b
    ld a,d              ;0ded 7a
    cp h                ;0dee bc
    jp nz,l0bfbh        ;0def c2 fb 0b
    ld a,(l17afh)       ;0df2 3a af 17
    pop hl              ;0df5 e1
    ld (hl),a           ;0df6 77
    or a                ;0df7 b7
    jp l070bh           ;0df8 c3 0b 07
    ex (sp),hl          ;0dfb e3
    push hl             ;0dfc e5
    pop hl              ;0dfd e1
l0dfeh:
    ld de,0004h         ;0dfe 11 04 00
    add hl,de           ;0e01 19
    dec c               ;0e02 0d
    jp nz,0bddh         ;0e03 c2 dd 0b
    ld a,(l17afh)       ;0e06 3a af 17
    or a                ;0e09 b7
l0e0ah:
    jp z,l0fe1h         ;0e0a ca e1 0f
    ld hl,l1725h+1      ;0e0d 21 26 17
    ld c,08h            ;0e10 0e 08
    push hl             ;0e12 e5
    ld a,(hl)           ;0e13 7e
l0e14h:
    or a                ;0e14 b7
    jp nz,l0c25h        ;0e15 c2 25 0c
    ld a,(l17afh)       ;0e18 3a af 17
    pop hl              ;0e1b e1
    ld (hl),a           ;0e1c 77
    pop de              ;0e1d d1
    inc hl              ;0e1e 23
    ld (hl),e           ;0e1f 73
    inc hl              ;0e20 23
    ld (hl),d           ;0e21 72
    jp l070bh           ;0e22 c3 0b 07
    pop hl              ;0e25 e1
    ld de,0004h         ;0e26 11 04 00
    add hl,de           ;0e29 19
    dec c               ;0e2a 0d
    jp nz,0c12h         ;0e2b c2 12 0c
    jp l0fe1h           ;0e2e c3 e1 0f
    ld hl,l1725h+1      ;0e31 21 26 17
    ld c,08h            ;0e34 0e 08
l0e36h:
    push hl             ;0e36 e5
    ld a,(hl)           ;0e37 7e
    or a                ;0e38 b7
    jp z,sub_0c59h+2    ;0e39 ca 5b 0c
    ld a,(174ch)        ;0e3c 3a 4c 17
    or a                ;0e3f b7
l0e40h:
    jp z,l0c48h         ;0e40 ca 48 0c
    ld (hl),00h         ;0e43 36 00
    jp sub_0c59h+2      ;0e45 c3 5b 0c
    push bc             ;0e48 c5
    call sub_1055h      ;0e49 cd 55 10
    ld a,(hl)           ;0e4c 7e
    call l1045h         ;0e4d cd 45 10
    call sub_0ffbh      ;0e50 cd fb 0f
    inc hl              ;0e53 23
sub_0e54h:
    ld e,(hl)           ;0e54 5e
    inc hl              ;0e55 23
    ld d,(hl)           ;0e56 56
    call l106ch+2       ;0e57 cd 6e 10
    pop bc              ;0e5a c1
    pop hl              ;0e5b e1
l0e5ch:
    ld de,0004h         ;0e5c 11 04 00
    add hl,de           ;0e5f 19
    dec c               ;0e60 0d
    jp nz,0c36h         ;0e61 c2 36 0c
    jp l070bh           ;0e64 c3 0b 07
    call 1251h          ;0e67 cd 51 12
    ld hl,0000h         ;0e6a 21 00 00
    jp z,l0c77h         ;0e6d ca 77 0c
    dec a               ;0e70 3d
    jp nz,l0fe1h        ;0e71 c2 e1 0f
    call 10e8h          ;0e74 cd e8 10
    ld (l17afh),hl      ;0e77 22 af 17
    ld hl,006ch         ;0e7a 21 6c 00
l0e7dh:
    ld de,l179fh        ;0e7d 11 9f 17
    ld c,10h            ;0e80 0e 10
    ld a,(hl)           ;0e82 7e
    ld (de),a           ;0e83 12
    inc hl              ;0e84 23
    inc de              ;0e85 13
    dec c               ;0e86 0d
    jp nz,l0c82h        ;0e87 c2 82 0c
    ld a,(005dh)        ;0e8a 3a 5d 00
    cp 3fh              ;0e8d fe 3f
    jp z,0d40h          ;0e8f ca 40 0d
    call 0782h          ;0e92 cd 82 07
    cp 0ffh             ;0e95 fe ff
    jp z,l0fe1h         ;0e97 ca e1 0f
l0e9ah:
    ld a,48h            ;0e9a 3e 48
    ld bc,4558h         ;0e9c 01 58 45
    call sub_0b77h      ;0e9f cd 77 0b
    ld hl,(l17afh)      ;0ea2 2a af 17
l0ea5h:
    push hl             ;0ea5 e5
    jp z,0ccfh          ;0ea6 ca cf 0c
    pop hl              ;0ea9 e1
    ld de,l0100h        ;0eaa 11 00 01
    add hl,de           ;0ead 19
    push hl             ;0eae e5
l0eafh:
    ld de,005ch         ;0eaf 11 5c 00
    ld c,14h            ;0eb2 0e 14
    call l06a4h         ;0eb4 cd a4 06
    pop hl              ;0eb7 e1
    or a                ;0eb8 b7
    jp nz,0d40h         ;0eb9 c2 40 0d
    ld de,0080h         ;0ebc 11 80 00
    ld c,80h            ;0ebf 0e 80
    ld a,(de)           ;0ec1 1a
    inc de              ;0ec2 13
    ld (hl),a           ;0ec3 77
    inc hl              ;0ec4 23
    dec c               ;0ec5 0d
    jp nz,l0cc1h        ;0ec6 c2 c1 0c
l0ec9h:
    call 0b8eh          ;0ec9 cd 8e 0b
    jp l0caeh           ;0ecc c3 ae 0c
    call 0faah          ;0ecf cd aa 0f
    cp 1ah              ;0ed2 fe 1a
    jp z,l0fe1h         ;0ed4 ca e1 0f
    sbc a,3ah           ;0ed7 de 3a
    jp nz,0ccfh         ;0ed9 c2 cf 0c
    ld d,a              ;0edc 57
    pop hl              ;0edd e1
    push hl             ;0ede e5
    call sub_0d32h      ;0edf cd 32 0d
    ld e,a              ;0ee2 5f
l0ee3h:
    call sub_0d32h      ;0ee3 cd 32 0d
    push af             ;0ee6 f5
    call sub_0d32h      ;0ee7 cd 32 0d
    pop bc              ;0eea c1
    ld c,a              ;0eeb 4f
    add hl,bc           ;0eec 09
    ld a,e              ;0eed 7b
    or a                ;0eee b7
    jp nz,0d02h         ;0eef c2 02 0d
    ld a,b              ;0ef2 78
    or c                ;0ef3 b1
    ld hl,l0100h        ;0ef4 21 00 01
    jp z,l0cfch         ;0ef7 ca fc 0c
    ld l,c              ;0efa 69
    ld h,b              ;0efb 60
    ld (l17e5h),hl      ;0efc 22 e5 17
    jp 0d40h            ;0eff c3 40 0d
    call sub_0d32h      ;0f02 cd 32 0d
    call sub_0d32h      ;0f05 cd 32 0d
    ld (hl),a           ;0f08 77
    inc hl              ;0f09 23
    dec e               ;0f0a 1d
    jp nz,0d05h         ;0f0b c2 05 0d
    call sub_0d32h      ;0f0e cd 32 0d
    push af             ;0f11 f5
    call 0b8eh          ;0f12 cd 8e 0b
    pop af              ;0f15 f1
    jp nz,l0fe1h        ;0f16 c2 e1 0f
l0f19h:
    jp 0ccfh            ;0f19 c3 cf 0c
    call 0faah          ;0f1c cd aa 0f
    call 10dbh          ;0f1f cd db 10
    rlca                ;0f22 07
    rlca                ;0f23 07
    rlca                ;0f24 07
    rlca                ;0f25 07
    and 0f0h            ;0f26 e6 f0
    push af             ;0f28 f5
    call 0faah          ;0f29 cd aa 0f
    call 10dbh          ;0f2c cd db 10
    pop bc              ;0f2f c1
    or b                ;0f30 b0
l0f31h:
    ret                 ;0f31 c9
    push bc             ;0f32 c5
    push hl             ;0f33 e5
    push de             ;0f34 d5
    call sub_0d1ch      ;0f35 cd 1c 0d
    ld b,a              ;0f38 47
    pop de              ;0f39 d1
    add a,d             ;0f3a 82
    ld d,a              ;0f3b 57
    ld a,b              ;0f3c 78
    pop hl              ;0f3d e1
l0f3eh:
    pop bc              ;0f3e c1
    ret                 ;0f3f c9
    ld hl,0000h         ;0f40 21 00 00
    call sub_0b84h      ;0f43 cd 84 0b
    jp c,0d50h          ;0f46 da 50 0d
    ld a,(l174dh+1)     ;0f49 3a 4e 17
    or a                ;0f4c b7
    call z,sub_0795h    ;0f4d cc 95 07
    ld a,55h            ;0f50 3e 55
    ld bc,l544ch        ;0f52 01 4c 54
    call sub_0b77h      ;0f55 cd 77 0b
    push af             ;0f58 f5
    ld hl,l179fh        ;0f59 21 9f 17
    ld de,005ch         ;0f5c 11 5c 00
    ld c,10h            ;0f5f 0e 10
    ld a,(hl)           ;0f61 7e
    ld (de),a           ;0f62 12
    inc hl              ;0f63 23
    inc de              ;0f64 13
    dec c               ;0f65 0d
    jp nz,0d61h         ;0f66 c2 61 0d
    xor a               ;0f69 af
    ld (007ch),a        ;0f6a 32 7c 00
    ld a,(005dh)        ;0f6d 3a 5d 00
    cp 20h              ;0f70 fe 20
    jp z,l0dfeh         ;0f72 ca fe 0d
    ld hl,l0e36h        ;0f75 21 36 0e
    call sub_100ah      ;0f78 cd 0a 10
    call 0782h          ;0f7b cd 82 07
    inc a               ;0f7e 3c
    jp z,l0fe1h         ;0f7f ca e1 0f
    call 0faah          ;0f82 cd aa 0f
    cp 1ah              ;0f85 fe 1a
    jp z,l0dfeh         ;0f87 ca fe 0d
    cp 21h              ;0f8a fe 21
    jp c,l0d82h         ;0f8c da 82 0d
l0f8fh:
    call 0d1fh          ;0f8f cd 1f 0d
    push af             ;0f92 f5
    call sub_0d1ch      ;0f93 cd 1c 0d
    pop de              ;0f96 d1
    ld e,a              ;0f97 5f
    ld hl,(l17afh)      ;0f98 2a af 17
    add hl,de           ;0f9b 19
    push hl             ;0f9c e5
    call 0faah          ;0f9d cd aa 0f
    cp 20h              ;0fa0 fe 20
    jp z,l0db1h         ;0fa2 ca b1 0d
    pop hl              ;0fa5 e1
    call 0faah          ;0fa6 cd aa 0f
    cp 20h              ;0fa9 fe 20
    jp c,l0d85h         ;0fab da 85 0d
    jp 0da6h            ;0fae c3 a6 0d
    ld hl,(0006h)       ;0fb1 2a 06 00
    ld e,00h            ;0fb4 1e 00
    dec hl              ;0fb6 2b
    call 0faah          ;0fb7 cd aa 0f
    cp 09h              ;0fba fe 09
    jp z,0dd4h          ;0fbc ca d4 0d
    cp 0dh              ;0fbf fe 0d
    jp z,0dd4h          ;0fc1 ca d4 0d
    cp 21h              ;0fc4 fe 21
    jp c,l0fe1h         ;0fc6 da e1 0f
    ld (hl),a           ;0fc9 77
l0fcah:
    inc e               ;0fca 1c
    ld a,e              ;0fcb 7b
    cp 11h              ;0fcc fe 11
    jp nc,l0fe1h        ;0fce d2 e1 0f
l0fd1h:
    jp l0db6h           ;0fd1 c3 b6 0d
    push de             ;0fd4 d5
    push hl             ;0fd5 e5
    ex de,hl            ;0fd6 eb
    ld hl,(0006h)       ;0fd7 2a 06 00
    inc hl              ;0fda 23
    ld e,(hl)           ;0fdb 5e
l0fdch:
    inc hl              ;0fdc 23
l0fddh:
    ld d,(hl)           ;0fdd 56
    pop hl              ;0fde e1
    ld (hl),d           ;0fdf 72
    dec hl              ;0fe0 2b
l0fe1h:
    ld (hl),e           ;0fe1 73
    dec hl              ;0fe2 2b
    ld (hl),0c3h        ;0fe3 36 c3
    call sub_0b84h      ;0fe5 cd 84 0b
    jp nc,l0fe1h        ;0fe8 d2 e1 0f
    ex de,hl            ;0feb eb
l0fech:
    ld hl,(0006h)       ;0fec 2a 06 00
    ex de,hl            ;0fef eb
    ld (0006h),hl       ;0ff0 22 06 00
    ex de,hl            ;0ff3 eb
    pop de              ;0ff4 d1
    ld (hl),e           ;0ff5 73
    inc hl              ;0ff6 23
    pop de              ;0ff7 d1
    ld (hl),e           ;0ff8 73
    inc hl              ;0ff9 23
    ld (hl),d           ;0ffa 72
sub_0ffbh:
    jp l0d82h           ;0ffb c3 82 0d
    pop af              ;0ffe f1
    jp nz,l0e14h        ;0fff c2 14 0e
l1002h:
    ld hl,l0e0ah        ;1002 21 0a 0e
    push hl             ;1005 e5
    ld hl,(l17e5h)      ;1006 2a e5 17
    jp (hl)             ;1009 e9
sub_100ah:
    ld hl,(0006h)       ;100a 2a 06 00
    add hl,de           ;100d 19
    ld (17b1h),hl       ;100e 22 b1 17
    jp l070bh           ;1011 c3 0b 07
l1014h:
    ld hl,l0e40h        ;1014 21 40 0e
    call sub_100ah      ;1017 cd 0a 10
    ld hl,(l17b3h)      ;101a 2a b3 17
    call 10a7h          ;101d cd a7 10
sub_1020h:
    call sub_0ffbh      ;1020 cd fb 0f
    ld hl,(l17e5h)      ;1023 2a e5 17
    call 10a7h          ;1026 cd a7 10
    call sub_0ffbh      ;1029 cd fb 0f
    ld hl,(0006h)       ;102c 2a 06 00
    dec hl              ;102f 2b
    call 10a7h          ;1030 cd a7 10
    jp l070bh           ;1033 c3 0b 07
sub_1036h:
    dec c               ;1036 0d
    ld a,(bc)           ;1037 0a
    ld d,e              ;1038 53
    ld e,c              ;1039 59
    ld c,l              ;103a 4d
    ld b,d              ;103b 42
    ld c,a              ;103c 4f
    ld c,h              ;103d 4c
    ld d,e              ;103e 53
    nop                 ;103f 00
l1040h:
    dec c               ;1040 0d
    ld a,(bc)           ;1041 0a
    ld c,(hl)           ;1042 4e
    ld b,l              ;1043 45
    ld e,b              ;1044 58
l1045h:
    ld d,h              ;1045 54
    jr nz,l1068h        ;1046 20 20
    ld d,b              ;1048 50
    ld b,e              ;1049 43
    jr nz,l106ch        ;104a 20 20
    ld b,l              ;104c 45
    ld c,(hl)           ;104d 4e
    ld b,h              ;104e 44
    dec c               ;104f 0d
    ld a,(bc)           ;1050 0a
    nop                 ;1051 00
    call sub_1242h      ;1052 cd 42 12
sub_1055h:
    dec a               ;1055 3d
    jp nz,l0fe1h        ;1056 c2 e1 0f
    call 10e8h          ;1059 cd e8 10
    call sub_1055h      ;105c cd 55 10
l105fh:
    push hl             ;105f e5
    call 10a7h          ;1060 cd a7 10
    call sub_0ffbh      ;1063 cd fb 0f
    pop hl              ;1066 e1
    push hl             ;1067 e5
l1068h:
    ld a,(l174dh)       ;1068 3a 4d 17
    or a                ;106b b7
l106ch:
    jp z,0e79h          ;106c ca 79 0e
    ld e,(hl)           ;106f 5e
    inc hl              ;1070 23
    ld d,(hl)           ;1071 56
    ex de,hl            ;1072 eb
    call 10a7h          ;1073 cd a7 10
    jp l0e7dh           ;1076 c3 7d 0e
    ld a,(hl)           ;1079 7e
    call l1045h         ;107a cd 45 10
sub_107dh:
    call sub_0ffbh      ;107d cd fb 0f
    call l0fech         ;1080 cd ec 0f
    call l1014h         ;1083 cd 14 10
l1086h:
    pop hl              ;1086 e1
    cp 0dh              ;1087 fe 0d
    jp z,0ed0h          ;1089 ca d0 0e
    cp 2eh              ;108c fe 2e
    jp nz,l0e9ah        ;108e c2 9a 0e
    ld a,(l176dh+1)     ;1091 3a 6e 17
    or a                ;1094 b7
    jp z,l070bh         ;1095 ca 0b 07
    ld a,2eh            ;1098 3e 2e
    cp 22h              ;109a fe 22
    push hl             ;109c e5
    jp nz,l0eafh        ;109d c2 af 0e
    call sub_1020h      ;10a0 cd 20 10
    pop hl              ;10a3 e1
    cp 0dh              ;10a4 fe 0d
    jp z,l0e5ch         ;10a6 ca 5c 0e
    ld (hl),a           ;10a9 77
    inc hl              ;10aa 23
    push hl             ;10ab e5
    jp 0ea0h            ;10ac c3 a0 0e
sub_10afh:
    call 1254h          ;10af cd 54 12
    dec a               ;10b2 3d
    jp nz,l0fe1h        ;10b3 c2 e1 0f
    call 10e8h          ;10b6 cd e8 10
l10b9h:
    ld a,(l174dh)       ;10b9 3a 4d 17
    or a                ;10bc b7
    jp z,l0ec9h         ;10bd ca c9 0e
    ex de,hl            ;10c0 eb
    pop hl              ;10c1 e1
    ld (hl),e           ;10c2 73
    inc hl              ;10c3 23
    ld (hl),d           ;10c4 72
    inc hl              ;10c5 23
    jp l0e5ch           ;10c6 c3 5c 0e
sub_10c9h:
    or a                ;10c9 b7
    jp nz,l0fe1h        ;10ca c2 e1 0f
    ld a,l              ;10cd 7d
    pop hl              ;10ce e1
    ld (hl),a           ;10cf 77
    inc hl              ;10d0 23
    ld a,(l174dh)       ;10d1 3a 4d 17
    or a                ;10d4 b7
    jp z,l0e5ch         ;10d5 ca 5c 0e
    inc hl              ;10d8 23
    jp l0e5ch           ;10d9 c3 5c 0e
    ld a,01h            ;10dc 3e 01
    jp l0ee3h           ;10de c3 e3 0e
    ld a,02h            ;10e1 3e 02
    ld (1754h),a        ;10e3 32 54 17
    call sub_1242h      ;10e6 cd 42 12
    ld hl,0000h         ;10e9 21 00 00
    ld (l1750h),hl      ;10ec 22 50 17
l10efh:
    inc hl              ;10ef 23
    jp z,0f10h          ;10f0 ca 10 0f
    jp c,0f00h          ;10f3 da 00 0f
l10f6h:
    call 10e8h          ;10f6 cd e8 10
    push af             ;10f9 f5
    ld a,l              ;10fa 7d
    or h                ;10fb b4
    jp z,l0fe1h         ;10fc ca e1 0f
    pop af              ;10ff f1
    push hl             ;1100 e5
    dec a               ;1101 3d
    jp z,0f0fh          ;1102 ca 0f 0f
    dec a               ;1105 3d
l1106h:
    jp nz,l0fe1h        ;1106 c2 e1 0f
    call 10e8h          ;1109 cd e8 10
l110ch:
    ld (l1750h),hl      ;110c 22 50 17
    pop hl              ;110f e1
    ld (1755h),hl       ;1110 22 55 17
    xor a               ;1113 af
    ld (1747h),a        ;1114 32 47 17
    call sub_130bh      ;1117 cd 0b 13
    jp 092ah            ;111a c3 2a 09
l111dh:
    call l1014h         ;111d cd 14 10
    cp 0dh              ;1120 fe 0d
    jp nz,0f2bh         ;1122 c2 2b 0f
    call sub_130bh      ;1125 cd 0b 13
    jp l070bh           ;1128 c3 0b 07
    ld bc,000bh         ;112b 01 0b 00
    ld hl,l13f6h        ;112e 21 f6 13
    cp (hl)             ;1131 be
    jp z,l0f3eh         ;1132 ca 3e 0f
    inc hl              ;1135 23
    inc b               ;1136 04
    dec c               ;1137 0d
    jp nz,l0f31h        ;1138 c2 31 0f
l113bh:
    jp l0fe1h           ;113b c3 e1 0f
    call l1014h         ;113e cd 14 10
    cp 0dh              ;1141 fe 0d
    jp nz,l0fe1h        ;1143 c2 e1 0f
    push bc             ;1146 c5
    call sub_1055h      ;1147 cd 55 10
    call sub_12dbh      ;114a cd db 12
    call sub_0ffbh      ;114d cd fb 0f
    call l0fech         ;1150 cd ec 0f
    call 1251h          ;1153 cd 51 12
    or a                ;1156 b7
    jp z,l070bh         ;1157 ca 0b 07
    dec a               ;115a 3d
    jp nz,l0fe1h        ;115b c2 e1 0f
    call 10e8h          ;115e cd e8 10
    pop bc              ;1161 c1
    ld a,b              ;1162 78
    cp 05h              ;1163 fe 05
    jp nc,l0f8fh        ;1165 d2 8f 0f
    ld a,h              ;1168 7c
    or a                ;1169 b7
    jp nz,l0fe1h        ;116a c2 e1 0f
    ld a,l              ;116d 7d
    cp 02h              ;116e fe 02
    jp nc,l0fe1h        ;1170 d2 e1 0f
    call 12a4h          ;1173 cd a4 12
    ld h,a              ;1176 67
    ld b,c              ;1177 41
    ld a,0feh           ;1178 3e fe
    call 0f89h          ;117a cd 89 0f
    and h               ;117d a4
    ld b,c              ;117e 41
    ld h,a              ;117f 67
    ld a,l              ;1180 7d
l1181h:
    call 0f89h          ;1181 cd 89 0f
    or h                ;1184 b4
    ld (de),a           ;1185 12
    jp l070bh           ;1186 c3 0b 07
    dec b               ;1189 05
    ret z               ;118a c8
    rlca                ;118b 07
    jp 0f89h            ;118c c3 89 0f
    jp nz,0f9fh         ;118f c2 9f 0f
    ld a,h              ;1192 7c
    or a                ;1193 b7
    jp nz,l0fe1h        ;1194 c2 e1 0f
    ld a,l              ;1197 7d
    ld hl,l17e0h        ;1198 21 e0 17
    ld (hl),a           ;119b 77
    jp l070bh           ;119c c3 0b 07
l119fh:
    push hl             ;119f e5
    call sub_12c2h      ;11a0 cd c2 12
    pop de              ;11a3 d1
l11a4h:
    ld (hl),e           ;11a4 73
    inc hl              ;11a5 23
    ld (hl),d           ;11a6 72
    jp l070bh           ;11a7 c3 0b 07
    push hl             ;11aa e5
    push de             ;11ab d5
    push bc             ;11ac c5
    ld a,(005bh)        ;11ad 3a 5b 00
    and 7fh             ;11b0 e6 7f
    jp z,l0fcah         ;11b2 ca ca 0f
    ld d,00h            ;11b5 16 00
    ld e,a              ;11b7 5f
    ld hl,0080h         ;11b8 21 80 00
    add hl,de           ;11bb 19
    ld a,(hl)           ;11bc 7e
    cp 1ah              ;11bd fe 1a
    jp z,l0fdch         ;11bf ca dc 0f
    ld hl,005bh         ;11c2 21 5b 00
    inc (hl)            ;11c5 34
    or a                ;11c6 b7
    jp l0fddh           ;11c7 c3 dd 0f
    ld c,14h            ;11ca 0e 14
l11cch:
    ld de,005ch         ;11cc 11 5c 00
sub_11cfh:
    call l06a4h         ;11cf cd a4 06
    or a                ;11d2 b7
    jp nz,l17b5h        ;11d3 c2 b5 17
    ld (005bh),a        ;11d6 32 5b 00
    jp 0fb5h            ;11d9 c3 b5 0f
    scf                 ;11dc 37
    pop bc              ;11dd c1
    pop de              ;11de d1
    pop hl              ;11df e1
    ret                 ;11e0 c9
    call sub_1055h      ;11e1 cd 55 10
    ld a,3fh            ;11e4 3e 3f
    call sub_0ffbh+2    ;11e6 cd fd 0f
    jp l070bh           ;11e9 c3 0b 07
    ld c,0ah            ;11ec 0e 0a
sub_11eeh:
    ld de,l176dh        ;11ee 11 6d 17
    call l06a4h         ;11f1 cd a4 06
    ld hl,l176fh        ;11f4 21 6f 17
    ld (l176bh),hl      ;11f7 22 6b 17
    ret                 ;11fa c9
    ld a,20h            ;11fb 3e 20
    push hl             ;11fd e5
sub_11feh:
    push de             ;11fe d5
    push bc             ;11ff c5
    ld e,a              ;1200 5f
l1201h:
    ld c,02h            ;1201 0e 02
    call l06a4h         ;1203 cd a4 06
    pop bc              ;1206 c1
    pop de              ;1207 d1
    pop hl              ;1208 e1
l1209h:
    ret                 ;1209 c9
    ld a,(hl)           ;120a 7e
    or a                ;120b b7
    ret z               ;120c c8
    call sub_0ffbh+2    ;120d cd fd 0f
    inc hl              ;1210 23
    jp sub_100ah        ;1211 c3 0a 10
    call sub_1020h      ;1214 cd 20 10
    cp 7fh              ;1217 fe 7f
l1219h:
    ret z               ;1219 c8
    cp 61h              ;121a fe 61
    ret c               ;121c d8
    and 5fh             ;121d e6 5f
    ret                 ;121f c9
    push hl             ;1220 e5
l1221h:
    ld hl,l176dh+1      ;1221 21 6e 17
    ld a,(hl)           ;1224 7e
    or a                ;1225 b7
sub_1226h:
    ld a,0dh            ;1226 3e 0d
    jp z,1034h          ;1228 ca 34 10
    dec (hl)            ;122b 35
l122ch:
    ld hl,(l176bh)      ;122c 2a 6b 17
l122fh:
    ld a,(hl)           ;122f 7e
    inc hl              ;1230 23
    ld (l176bh),hl      ;1231 22 6b 17
    pop hl              ;1234 e1
    ret                 ;1235 c9
    cp 0ah              ;1236 fe 0a
    jp nc,l1040h        ;1238 d2 40 10
    add a,30h           ;123b c6 30
    jp sub_0ffbh+2      ;123d c3 fd 0f
    add a,37h           ;1240 c6 37
sub_1242h:
    jp sub_0ffbh+2      ;1242 c3 fd 0f
sub_1245h:
    push af             ;1245 f5
    rra                 ;1246 1f
    rra                 ;1247 1f
    rra                 ;1248 1f
    rra                 ;1249 1f
    and 0fh             ;124a e6 0f
    call sub_1036h      ;124c cd 36 10
    pop af              ;124f f1
    and 0fh             ;1250 e6 0f
    jp sub_1036h        ;1252 c3 36 10
    ld a,0dh            ;1255 3e 0d
    call sub_0ffbh+2    ;1257 cd fd 0f
    ld a,0ah            ;125a 3e 0a
    jp sub_0ffbh+2      ;125c c3 fd 0f
    push bc             ;125f c5
    push de             ;1260 d5
    push hl             ;1261 e5
    ld c,0bh            ;1262 0e 0b
    call l06a4h         ;1264 cd a4 06
    and 01h             ;1267 e6 01
    pop hl              ;1269 e1
    pop de              ;126a d1
    pop bc              ;126b c1
    ret                 ;126c c9
    ex de,hl            ;126d eb
    push de             ;126e d5
l126fh:
    ex de,hl            ;126f eb
    call 10a7h          ;1270 cd a7 10
    pop de              ;1273 d1
    ld a,(174ch)        ;1274 3a 4c 17
    or a                ;1277 b7
    ret nz              ;1278 c0
    call 16f5h          ;1279 cd f5 16
    ret z               ;127c c8
    call sub_0ffbh      ;127d cd fb 0f
    ld a,2eh            ;1280 3e 2e
    call sub_0ffbh+2    ;1282 cd fd 0f
    ld e,(hl)           ;1285 5e
    dec hl              ;1286 2b
    ld a,(hl)           ;1287 7e
    call sub_0ffbh+2    ;1288 cd fd 0f
    dec e               ;128b 1d
    jp nz,l1086h        ;128c c2 86 10
    ret                 ;128f c9
    push hl             ;1290 e5
    ld a,(174ch)        ;1291 3a 4c 17
    or a                ;1294 b7
    pop de              ;1295 d1
l1296h:
    ret nz              ;1296 c0
    call 16f5h          ;1297 cd f5 16
    ret z               ;129a c8
    call sub_1055h      ;129b cd 55 10
    call 1085h          ;129e cd 85 10
    ld a,3ah            ;12a1 3e 3a
    call sub_0ffbh+2    ;12a3 cd fd 0f
    ret                 ;12a6 c9
    ld a,h              ;12a7 7c
    call l1045h         ;12a8 cd 45 10
    ld a,l              ;12ab 7d
    jp l1045h           ;12ac c3 45 10
    cp 7fh              ;12af fe 7f
    jp nc,l10b9h        ;12b1 d2 b9 10
sub_12b4h:
    cp 20h              ;12b4 fe 20
    jp nc,sub_0ffbh+2   ;12b6 d2 fd 0f
    ld a,2eh            ;12b9 3e 2e
    jp sub_0ffbh+2      ;12bb c3 fd 0f
    ex de,hl            ;12be eb
l12bfh:
    ld hl,(l1765h+2)    ;12bf 2a 67 17
sub_12c2h:
    ld a,l              ;12c2 7d
    sub e               ;12c3 93
    ld l,a              ;12c4 6f
    ld a,h              ;12c5 7c
    sbc a,d             ;12c6 9a
    ex de,hl            ;12c7 eb
    ret                 ;12c8 c9
    cp 2fh              ;12c9 fe 2f
    ret z               ;12cb c8
    cp 2bh              ;12cc fe 2b
    ret z               ;12ce c8
    cp 2dh              ;12cf fe 2d
    ret z               ;12d1 c8
    cp 0dh              ;12d2 fe 0d
    ret z               ;12d4 c8
sub_12d5h:
    cp 2ch              ;12d5 fe 2c
    ret z               ;12d7 c8
    cp 20h              ;12d8 fe 20
    ret                 ;12da c9
sub_12dbh:
    sub 30h             ;12db d6 30
    cp 0ah              ;12dd fe 0a
    ret c               ;12df d8
    add a,0f9h          ;12e0 c6 f9
    cp 10h              ;12e2 fe 10
    ret c               ;12e4 d8
    jp l0fe1h           ;12e5 c3 e1 0f
    ex de,hl            ;12e8 eb
    ld e,(hl)           ;12e9 5e
    inc hl              ;12ea 23
    ld d,(hl)           ;12eb 56
    inc hl              ;12ec 23
    ex de,hl            ;12ed eb
l12eeh:
    ret                 ;12ee c9
    push de             ;12ef d5
    call l1014h         ;12f0 cd 14 10
    ld hl,(17b1h)       ;12f3 2a b1 17
    push af             ;12f6 f5
    ld c,(hl)           ;12f7 4e
    ld a,c              ;12f8 79
    cp 10h              ;12f9 fe 10
    jp nc,l0fe1h        ;12fb d2 e1 0f
l12feh:
    pop af              ;12fe f1
    ex de,hl            ;12ff eb
    push de             ;1300 d5
    push af             ;1301 f5
    ld hl,(l176bh)      ;1302 2a 6b 17
    push hl             ;1305 e5
    ld hl,(l176dh)      ;1306 2a 6d 17
    push hl             ;1309 e5
    ex de,hl            ;130a eb
sub_130bh:
    inc c               ;130b 0c
    call sub_10c9h      ;130c cd c9 10
    jp z,1121h          ;130f ca 21 11
    dec c               ;1312 0d
    jp z,l113bh         ;1313 ca 3b 11
l1316h:
    dec hl              ;1316 2b
    cp (hl)             ;1317 be
    jp nz,l113bh        ;1318 c2 3b 11
    call l1014h         ;131b cd 14 10
    jp l110ch           ;131e c3 0c 11
    dec c               ;1321 0d
    jp nz,l113bh        ;1322 c2 3b 11
    pop hl              ;1325 e1
    pop hl              ;1326 e1
    pop hl              ;1327 e1
    call 10cch          ;1328 cd cc 10
    jp z,1134h          ;132b ca 34 11
    call l1014h         ;132e cd 14 10
    jp 1144h            ;1331 c3 44 11
    pop hl              ;1334 e1
    inc hl              ;1335 23
    ld e,(hl)           ;1336 5e
    inc hl              ;1337 23
    ld d,(hl)           ;1338 56
    pop hl              ;1339 e1
    ret                 ;133a c9
    pop hl              ;133b e1
    ld (l176dh),hl      ;133c 22 6d 17
    pop hl              ;133f e1
    ld (l176bh),hl      ;1340 22 6b 17
    pop af              ;1343 f1
    pop hl              ;1344 e1
    push af             ;1345 f5
    ld a,(hl)           ;1346 7e
    cpl                 ;1347 2f
    add a,l             ;1348 85
    ld l,a              ;1349 6f
    ld a,0ffh           ;134a 3e ff
    adc a,h             ;134c 8c
sub_134dh:
    ld h,a              ;134d 67
    dec hl              ;134e 2b
    dec hl              ;134f 2b
l1350h:
    pop af              ;1350 f1
    jp l10f6h           ;1351 c3 f6 10
    ex de,hl            ;1354 eb
    ld hl,0000h         ;1355 21 00 00
    cp 2eh              ;1358 fe 2e
    jp z,l10efh         ;135a ca ef 10
    cp 40h              ;135d fe 40
    jp nz,116ch         ;135f c2 6c 11
    call l10efh         ;1362 cd ef 10
l1365h:
    push hl             ;1365 e5
    ex de,hl            ;1366 eb
    ld e,(hl)           ;1367 5e
    inc hl              ;1368 23
    ld d,(hl)           ;1369 56
    pop hl              ;136a e1
    ret                 ;136b c9
    cp 3dh              ;136c fe 3d
    jp nz,117bh         ;136e c2 7b 11
    call l10efh         ;1371 cd ef 10
l1374h:
    push hl             ;1374 e5
    ex de,hl            ;1375 eb
    ld e,(hl)           ;1376 5e
    ld d,00h            ;1377 16 00
    pop hl              ;1379 e1
    ret                 ;137a c9
    cp 27h              ;137b fe 27
    jp nz,l119fh        ;137d c2 9f 11
    ex de,hl            ;1380 eb
    call sub_1020h      ;1381 cd 20 10
    cp 20h              ;1384 fe 20
    jp c,l0fe1h         ;1386 da e1 0f
    cp 27h              ;1389 fe 27
    jp nz,119ah         ;138b c2 9a 11
    call sub_1020h      ;138e cd 20 10
    call 10cch          ;1391 cd cc 10
    ret z               ;1394 c8
    cp 27h              ;1395 fe 27
    jp nz,l0fe1h        ;1397 c2 e1 0f
    ld d,e              ;139a 53
    ld e,a              ;139b 5f
    jp l1181h           ;139c c3 81 11
    cp 23h              ;139f fe 23
    jp nz,11c3h         ;13a1 c2 c3 11
    call l1014h         ;13a4 cd 14 10
    call 10cch          ;13a7 cd cc 10
    jp z,11c1h          ;13aa ca c1 11
    sub 30h             ;13ad d6 30
    cp 0ah              ;13af fe 0a
    jp nc,l0fe1h        ;13b1 d2 e1 0f
    add hl,hl           ;13b4 29
    ld b,h              ;13b5 44
    ld c,l              ;13b6 4d
    add hl,hl           ;13b7 29
    add hl,hl           ;13b8 29
    add hl,bc           ;13b9 09
    ld c,a              ;13ba 4f
    ld b,00h            ;13bb 06 00
    add hl,bc           ;13bd 09
    jp l11a4h           ;13be c3 a4 11
    ex de,hl            ;13c1 eb
    ret                 ;13c2 c9
    cp 5eh              ;13c3 fe 5e
    jp nz,11dah         ;13c5 c2 da 11
l13c8h:
    push de             ;13c8 d5
    ld hl,(l17e0h+1)    ;13c9 2a e1 17
    ld e,(hl)           ;13cc 5e
    inc hl              ;13cd 23
l13ceh:
    ld d,(hl)           ;13ce 56
    inc hl              ;13cf 23
    call l1014h         ;13d0 cd 14 10
    cp 5eh              ;13d3 fe 5e
    jp z,l11cch         ;13d5 ca cc 11
    pop hl              ;13d8 e1
    ret                 ;13d9 c9
    call 10dbh          ;13da cd db 10
    add hl,hl           ;13dd 29
    add hl,hl           ;13de 29
    add hl,hl           ;13df 29
    add hl,hl           ;13e0 29
l13e1h:
    or l                ;13e1 b5
    ld l,a              ;13e2 6f
    call l1014h         ;13e3 cd 14 10
    call 10cch          ;13e6 cd cc 10
    jp nz,11c3h         ;13e9 c2 c3 11
    ex de,hl            ;13ec eb
    ret                 ;13ed c9
    ex de,hl            ;13ee eb
    ld (l171eh+2),hl    ;13ef 22 20 17
l13f2h:
    ex de,hl            ;13f2 eb
    ld (hl),e           ;13f3 73
    inc hl              ;13f4 23
    ld (hl),d           ;13f5 72
l13f6h:
    inc hl              ;13f6 23
    push hl             ;13f7 e5
    ld hl,sub_175ch+2   ;13f8 21 5e 17
    inc (hl)            ;13fb 34
    pop hl              ;13fc e1
    ret                 ;13fd c9
    cp 2dh              ;13fe fe 2d
    jp nz,l1209h        ;1400 c2 09 12
    ld de,0000h         ;1403 11 00 00
l1406h:
    jp l122fh           ;1406 c3 2f 12
    cp 2bh              ;1409 fe 2b
sub_140bh:
    jp nz,1216h         ;140b c2 16 12
    ex de,hl            ;140e eb
sub_140fh:
    ld hl,(l171eh+2)    ;140f 2a 20 17
    ex de,hl            ;1412 eb
    jp 121eh            ;1413 c3 1e 12
l1416h:
    call 1154h          ;1416 cd 54 11
    cp 2bh              ;1419 fe 2b
    jp nz,l122ch        ;141b c2 2c 12
    push de             ;141e d5
    call l1014h         ;141f cd 14 10
    call 1154h          ;1422 cd 54 11
    pop bc              ;1425 c1
    ex de,hl            ;1426 eb
    add hl,bc           ;1427 09
    ex de,hl            ;1428 eb
    jp l1219h           ;1429 c3 19 12
    cp 2dh              ;142c fe 2d
    ret nz              ;142e c0
    call l1014h         ;142f cd 14 10
    push de             ;1432 d5
    call 1154h          ;1433 cd 54 11
    pop bc              ;1436 c1
    push af             ;1437 f5
    ld a,c              ;1438 79
    sub e               ;1439 93
    ld e,a              ;143a 5f
    ld a,b              ;143b 78
    sbc a,d             ;143c 9a
    ld d,a              ;143d 57
    pop af              ;143e f1
    jp l1219h           ;143f c3 19 12
    call l1014h         ;1442 cd 14 10
    ld hl,l174dh        ;1445 21 4d 17
    ld (hl),00h         ;1448 36 00
    cp 57h              ;144a fe 57
    jp nz,1254h         ;144c c2 54 12
    ld (hl),0ffh        ;144f 36 ff
    call l1014h         ;1451 cd 14 10
    ld hl,sub_175ch+2   ;1454 21 5e 17
    ld (hl),00h         ;1457 36 00
    inc hl              ;1459 23
    cp 0dh              ;145a fe 0d
    jp z,l1296h         ;145c ca 96 12
l145fh:
    cp 2ch              ;145f fe 2c
    jp nz,l126fh        ;1461 c2 6f 12
    ld a,80h            ;1464 3e 80
    ld (sub_175ch+2),a  ;1466 32 5e 17
    ld de,0000h         ;1469 11 00 00
    jp 1272h            ;146c c3 72 12
    call sub_11feh      ;146f cd fe 11
    call sub_11eeh      ;1472 cd ee 11
    cp 0dh              ;1475 fe 0d
    jp z,l1296h         ;1477 ca 96 12
    call l1014h         ;147a cd 14 10
    call sub_11feh      ;147d cd fe 11
    call sub_11eeh      ;1480 cd ee 11
    cp 0dh              ;1483 fe 0d
    jp z,l1296h         ;1485 ca 96 12
    call l1014h         ;1488 cd 14 10
    call sub_11feh      ;148b cd fe 11
    call sub_11eeh      ;148e cd ee 11
    cp 0dh              ;1491 fe 0d
    jp nz,l0fe1h        ;1493 c2 e1 0f
    ld de,sub_175ch+2   ;1496 11 5e 17
    ld a,(de)           ;1499 1a
    cp 81h              ;149a fe 81
    jp z,l0fe1h         ;149c ca e1 0f
    inc de              ;149f 13
l14a0h:
    or a                ;14a0 b7
    rlca                ;14a1 07
    rrca                ;14a2 0f
    ret                 ;14a3 c9
    push hl             ;14a4 e5
    ld hl,l1406h        ;14a5 21 06 14
    ld e,b              ;14a8 58
    ld d,00h            ;14a9 16 00
    add hl,de           ;14ab 19
    ld c,(hl)           ;14ac 4e
    ld hl,17dfh         ;14ad 21 df 17
    ld a,(hl)           ;14b0 7e
    ex de,hl            ;14b1 eb
    pop hl              ;14b2 e1
    ret                 ;14b3 c9
    call 12a4h          ;14b4 cd a4 12
    dec c               ;14b7 0d
    jp z,l12bfh         ;14b8 ca bf 12
    rra                 ;14bb 1f
    jp 12b7h            ;14bc c3 b7 12
    and 01h             ;14bf e6 01
    ret                 ;14c1 c9
    sub 06h             ;14c2 d6 06
l14c4h:
    ld hl,1401h         ;14c4 21 01 14
    ld e,a              ;14c7 5f
    ld d,00h            ;14c8 16 00
    add hl,de           ;14ca 19
    ld e,(hl)           ;14cb 5e
    ld d,0ffh           ;14cc 16 ff
    ld hl,17e7h         ;14ce 21 e7 17
    add hl,de           ;14d1 19
    ret                 ;14d2 c9
    call sub_12c2h      ;14d3 cd c2 12
    ld e,(hl)           ;14d6 5e
    inc hl              ;14d7 23
    ld d,(hl)           ;14d8 56
    ex de,hl            ;14d9 eb
    ret                 ;14da c9
l14dbh:
    ld a,b              ;14db 78
l14dch:
    cp 05h              ;14dc fe 05
    jp nc,l12eeh        ;14de d2 ee 12
    call sub_12b4h      ;14e1 cd b4 12
    or a                ;14e4 b7
    ld a,2dh            ;14e5 3e 2d
    jp z,sub_0ffbh+2    ;14e7 ca fd 0f
    ld a,(hl)           ;14ea 7e
    jp sub_0ffbh+2      ;14eb c3 fd 0f
    push af             ;14ee f5
    ld a,(hl)           ;14ef 7e
    call sub_0ffbh+2    ;14f0 cd fd 0f
    ld a,3dh            ;14f3 3e 3d
    call sub_0ffbh+2    ;14f5 cd fd 0f
    pop af              ;14f8 f1
    jp nz,1304h         ;14f9 c2 04 13
    ld hl,l17e0h        ;14fc 21 e0 17
    ld a,(hl)           ;14ff 7e
    call l1045h         ;1500 cd 45 10
    ret                 ;1503 c9
    call 12d3h          ;1504 cd d3 12
    call 10a7h          ;1507 cd a7 10
    ret                 ;150a c9
    call sub_1055h      ;150b cd 55 10
    call sub_0ffbh      ;150e cd fb 0f
    ld hl,l13f6h        ;1511 21 f6 13
    ld b,00h            ;1514 06 00
    push bc             ;1516 c5
    push hl             ;1517 e5
    call sub_12dbh      ;1518 cd db 12
    pop hl              ;151b e1
    pop bc              ;151c c1
    inc b               ;151d 04
    inc hl              ;151e 23
    ld a,b              ;151f 78
    cp 0bh              ;1520 fe 0b
l1522h:
    jp nc,1330h         ;1522 d2 30 13
    cp 05h              ;1525 fe 05
    jp c,l1316h         ;1527 da 16 13
    call sub_0ffbh      ;152a cd fb 0f
    jp l1316h           ;152d c3 16 13
    call sub_0ffbh      ;1530 cd fb 0f
    call 15b0h          ;1533 cd b0 15
    push af             ;1536 f5
    push de             ;1537 d5
    push bc             ;1538 c5
l1539h:
    call sub_0b96h      ;1539 cd 96 0b
l153ch:
    jp nc,l1350h        ;153c d2 50 13
    ld hl,(l17e5h)      ;153f 2a e5 17
    ld (000ch),hl       ;1542 22 0c 00
    ld hl,0010h         ;1545 21 10 00
    ld (hl),0ffh        ;1548 36 ff
    call 0006h          ;154a cd 06 00
    jp 1378h            ;154d c3 78 13
    dec hl              ;1550 2b
    ld (l1765h+2),hl    ;1551 22 67 17
    ld hl,(l17e5h)      ;1554 2a e5 17
    ld a,(hl)           ;1557 7e
    call l1045h         ;1558 cd 45 10
    inc hl              ;155b 23
l155ch:
    call 10beh          ;155c cd be 10
    jp c,1378h          ;155f da 78 13
    push af             ;1562 f5
    call sub_0ffbh      ;1563 cd fb 0f
    pop af              ;1566 f1
    or e                ;1567 b3
l1568h:
    jp z,l1374h         ;1568 ca 74 13
    ld e,(hl)           ;156b 5e
    inc hl              ;156c 23
    ld d,(hl)           ;156d 56
    call l106ch+2       ;156e cd 6e 10
    jp 1378h            ;1571 c3 78 13
    ld a,(hl)           ;1574 7e
    call l1045h         ;1575 cd 45 10
    ld hl,(l17e5h)      ;1578 2a e5 17
    ld a,(hl)           ;157b 7e
    ld b,a              ;157c 47
    and 0c0h            ;157d e6 c0
    cp 80h              ;157f fe 80
    jp nz,138fh         ;1581 c2 8f 13
    ld a,b              ;1584 78
    and 07h             ;1585 e6 07
    cp 06h              ;1587 fe 06
    jp nz,l13f2h        ;1589 c2 f2 13
    jp 13bch            ;158c c3 bc 13
    cp 40h              ;158f fe 40
l1591h:
    jp nz,13ach         ;1591 c2 ac 13
    ld a,b              ;1594 78
    cp 76h              ;1595 fe 76
    jp z,l13f2h         ;1597 ca f2 13
    and 07h             ;159a e6 07
    cp 06h              ;159c fe 06
l159eh:
    jp z,l13c8h         ;159e ca c8 13
    ld a,b              ;15a1 78
sub_15a2h:
    and 38h             ;15a2 e6 38
    cp 30h              ;15a4 fe 30
sub_15a6h:
    jp nz,l13f2h        ;15a6 c2 f2 13
    jp l13c8h           ;15a9 c3 c8 13
    ld a,b              ;15ac 78
    cp 36h              ;15ad fe 36
    jp z,l13c8h         ;15af ca c8 13
    cp 34h              ;15b2 fe 34
    jp z,13bch          ;15b4 ca bc 13
    cp 35h              ;15b7 fe 35
    jp nz,l13ceh        ;15b9 c2 ce 13
    ld a,3dh            ;15bc 3e 3d
    call sub_0ffbh+2    ;15be cd fd 0f
    ld hl,(17e3h)       ;15c1 2a e3 17
    ld a,(hl)           ;15c4 7e
    call l1045h         ;15c5 cd 45 10
    ld hl,(17e3h)       ;15c8 2a e3 17
    jp l13e1h           ;15cb c3 e1 13
    and 0e7h            ;15ce e6 e7
    cp 02h              ;15d0 fe 02
    jp nz,l13f2h        ;15d2 c2 f2 13
    ld a,b              ;15d5 78
    and 10h             ;15d6 e6 10
    ld hl,(17dbh)       ;15d8 2a db 17
    jp nz,l13e1h        ;15db c2 e1 13
    ld hl,(17ddh)       ;15de 2a dd 17
    ld a,(174ch)        ;15e1 3a 4c 17
    or a                ;15e4 b7
    jp nz,l13f2h        ;15e5 c2 f2 13
    ex de,hl            ;15e8 eb
l15e9h:
    call 16f5h          ;15e9 cd f5 16
    jp z,l13f2h         ;15ec ca f2 13
l15efh:
    call sub_107dh      ;15ef cd 7d 10
    pop bc              ;15f2 c1
    pop de              ;15f3 d1
    pop af              ;15f4 f1
    ret                 ;15f5 c9
    ld b,e              ;15f6 43
    ld e,d              ;15f7 5a
    ld c,l              ;15f8 4d
sub_15f9h:
    ld b,l              ;15f9 45
    ld c,c              ;15fa 49
    ld b,c              ;15fb 41
    ld b,d              ;15fc 42
    ld b,h              ;15fd 44
    ld c,b              ;15fe 48
    ld d,e              ;15ff 53
    ld d,b              ;1600 50
    or 0f4h             ;1601 f6 f4
    call m,0fefah       ;1603 fc fa fe
    ld bc,l0807h        ;1606 01 07 08
    inc bc              ;1609 03
    dec b               ;160a 05
    ld hl,0000h         ;160b 21 00 00
    ld (1755h),hl       ;160e 22 55 17
    xor a               ;1611 af
    ld (1754h),a        ;1612 32 54 17
    ret                 ;1615 c9
    di                  ;1616 f3
    ld (17e3h),hl       ;1617 22 e3 17
    pop hl              ;161a e1
    dec hl              ;161b 2b
    ld (l17e5h),hl      ;161c 22 e5 17
    push af             ;161f f5
    ld hl,0002h         ;1620 21 02 00
    add hl,sp           ;1623 39
    pop af              ;1624 f1
sub_1625h:
    ld sp,17e3h         ;1625 31 e3 17
    push hl             ;1628 e5
    push af             ;1629 f5
    push bc             ;162a c5
    push de             ;162b d5
    ei                  ;162c fb
    ld hl,(l17e5h)      ;162d 2a e5 17
    ld a,(hl)           ;1630 7e
    cp 0ffh             ;1631 fe ff
    push af             ;1633 f5
    push hl             ;1634 e5
    ld a,(1722h)        ;1635 3a 22 17
    ld (1746h),a        ;1638 32 46 17
sub_163bh:
    ld hl,l1742h        ;163b 21 42 17
    ld c,08h            ;163e 0e 08
    push hl             ;1640 e5
    ld a,(hl)           ;1641 7e
    or a                ;1642 b7
    jp z,144dh          ;1643 ca 4d 14
    inc hl              ;1646 23
    ld e,(hl)           ;1647 5e
    inc hl              ;1648 23
    ld d,(hl)           ;1649 56
    inc hl              ;164a 23
    ld a,(hl)           ;164b 7e
    ld (de),a           ;164c 12
sub_164dh:
    pop hl              ;164d e1
    ld de,0fffch        ;164e 11 fc ff
    add hl,de           ;1651 19
    dec c               ;1652 0d
    jp nz,1440h         ;1653 c2 40 14
    call sub_15a2h      ;1656 cd a2 15
    ld hl,1757h         ;1659 21 57 17
    ld a,(hl)           ;165c 7e
    ld (hl),00h         ;165d 36 00
    or a                ;165f b7
    jp z,1470h          ;1660 ca 70 14
l1663h:
    dec a               ;1663 3d
    ld b,a              ;1664 47
l1665h:
    inc hl              ;1665 23
    ld e,(hl)           ;1666 5e
l1667h:
    inc hl              ;1667 23
    ld d,(hl)           ;1668 56
    inc hl              ;1669 23
    ld a,(hl)           ;166a 7e
    ld (de),a           ;166b 12
    ld a,b              ;166c 78
    jp l145fh           ;166d c3 5f 14
    pop hl              ;1670 e1
    pop af              ;1671 f1
    jp z,1494h          ;1672 ca 94 14
    inc hl              ;1675 23
    ld (l17e5h),hl      ;1676 22 e5 17
    ex de,hl            ;1679 eb
    ld hl,l06aah        ;167a 21 aa 06
    ld c,(hl)           ;167d 4e
    inc hl              ;167e 23
    ld b,(hl)           ;167f 46
l1680h:
    call 08ech          ;1680 cd ec 08
    jp c,1494h          ;1683 da 94 14
    call sub_140bh      ;1686 cd 0b 14
sub_1689h:
    ld hl,(l1750h+2)    ;1689 2a 52 17
    ex de,hl            ;168c eb
    ld a,82h            ;168d 3e 82
    or a                ;168f b7
    scf                 ;1690 37
    jp 092ah            ;1691 c3 2a 09
    ld a,(l1725h)       ;1694 3a 25 17
    or a                ;1697 b7
l1698h:
    jp nz,l1539h        ;1698 c2 39 15
    ld hl,l1725h+1      ;169b 21 26 17
    ld c,08h            ;169e 0e 08
    push hl             ;16a0 e5
    ld a,(hl)           ;16a1 7e
    or a                ;16a2 b7
    jp z,14f6h          ;16a3 ca f6 14
    inc hl              ;16a6 23
    ld a,(hl)           ;16a7 7e
    inc hl              ;16a8 23
    ld d,(hl)           ;16a9 56
    ld hl,(l17e5h)      ;16aa 2a e5 17
    cp l                ;16ad bd
l16aeh:
    jp nz,14f6h         ;16ae c2 f6 14
    ld a,d              ;16b1 7a
    cp h                ;16b2 bc
    jp nz,14f6h         ;16b3 c2 f6 14
    pop hl              ;16b6 e1
    ld a,(hl)           ;16b7 7e
    dec a               ;16b8 3d
    jp nz,l14c4h        ;16b9 c2 c4 14
    push af             ;16bc f5
    dec a               ;16bd 3d
    ld (l1725h),a       ;16be 32 25 17
    jp l14dbh           ;16c1 c3 db 14
    ld (hl),a           ;16c4 77
    push af             ;16c5 f5
    call 156fh          ;16c6 cd 6f 15
    cp 02h              ;16c9 fe 02
    jp z,l14dbh         ;16cb ca db 14
    ld a,(174ch)        ;16ce 3a 4c 17
    or a                ;16d1 b7
    jp z,l14dbh         ;16d2 ca db 14
    call 15b0h          ;16d5 cd b0 15
l16d8h:
    jp 092ah            ;16d8 c3 2a 09
l16dbh:
    call sub_1055h      ;16db cd 55 10
l16deh:
    pop af              ;16de f1
    inc a               ;16df 3c
    call l1045h         ;16e0 cd 45 10
sub_16e3h:
    ld hl,l1568h        ;16e3 21 68 15
    call sub_100ah      ;16e6 cd 0a 10
    ld hl,(l17e5h)      ;16e9 2a e5 17
    ex de,hl            ;16ec eb
    call l106ch+2       ;16ed cd 6e 10
    call sub_130bh      ;16f0 cd 0b 13
    jp 092ah            ;16f3 c3 2a 09
    pop hl              ;16f6 e1
    ld de,0004h         ;16f7 11 04 00
l16fah:
    add hl,de           ;16fa 19
    dec c               ;16fb 0d
    jp nz,l14a0h        ;16fc c2 a0 14
    call l105fh         ;16ff cd 5f 10
    jp nz,l1539h        ;1702 c2 39 15
    call 156fh          ;1705 cd 6f 15
    jp z,1521h          ;1708 ca 21 15
    dec a               ;170b 3d
    jp nz,1515h         ;170c c2 15 15
    call 15b0h          ;170f cd b0 15
    jp 092ah            ;1712 c3 2a 09
    ld hl,(l17e5h)      ;1715 2a e5 17
    call 1090h          ;1718 cd 90 10
    call sub_130bh      ;171b cd 0b 13
l171eh:
    jp 092ah            ;171e c3 2a 09
    ld a,(1746h)        ;1721 3a 46 17
    or a                ;1724 b7
l1725h:
    jp z,l1539h         ;1725 ca 39 15
    ld hl,(l1748h+2)    ;1728 2a 4a 17
    ld c,l              ;172b 4d
    ld b,h              ;172c 44
    ld hl,(l1748h)      ;172d 2a 48 17
    ex de,hl            ;1730 eb
    ld a,(1747h)        ;1731 3a 47 17
    or a                ;1734 b7
    scf                 ;1735 37
    jp 092ah            ;1736 c3 2a 09
    call sub_1055h      ;1739 cd 55 10
sub_173ch:
    call sub_15a2h      ;173c cd a2 15
    ld hl,0000h         ;173f 21 00 00
l1742h:
    ld (l1750h),hl      ;1742 22 50 17
    call sub_140bh      ;1745 cd 0b 14
l1748h:
    ld (l1725h),a       ;1748 32 25 17
    ld a,2ah            ;174b 3e 2a
l174dh:
    call sub_0ffbh+2    ;174d cd fd 0f
l1750h:
    ld hl,(l17e5h)      ;1750 2a e5 17
    call sub_0b96h      ;1753 cd 96 0b
    jp nc,l155ch        ;1756 d2 5c 15
    ld (000ch),hl       ;1759 22 0c 00
sub_175ch:
    call l106ch+1       ;175c cd 6d 10
    ld hl,(17e3h)       ;175f 2a e3 17
    ld (l1765h),hl      ;1762 22 65 17
l1765h:
    jp l070bh           ;1765 c3 0b 07
    jr nz,$+82          ;1768 20 50
    ld b,c              ;176a 41
l176bh:
    ld d,e              ;176b 53
    ld d,e              ;176c 53
l176dh:
    jr nz,l176fh        ;176d 20 00
l176fh:
    ld hl,1754h         ;176f 21 54 17
    ld a,(hl)           ;1772 7e
    or a                ;1773 b7
    ret z               ;1774 c8
    push hl             ;1775 e5
    ld hl,(1755h)       ;1776 2a 55 17
    dec hl              ;1779 2b
    ld (1755h),hl       ;177a 22 55 17
    ld a,h              ;177d 7c
sub_177eh:
    or l                ;177e b5
    pop hl              ;177f e1
    jp nz,1588h         ;1780 c2 88 15
    ld (hl),a           ;1783 77
    dec a               ;1784 3d
    ld (l1725h),a       ;1785 32 25 17
    ld a,(hl)           ;1788 7e
sub_1789h:
    or a                ;1789 b7
    ret                 ;178a c9
    ld de,000dh         ;178b 11 0d 00
    ld hl,l16dbh        ;178e 21 db 16
    ld a,(hl)           ;1791 7e
    and b               ;1792 a0
    inc hl              ;1793 23
    cp (hl)             ;1794 be
    inc hl              ;1795 23
    jp z,l159eh         ;1796 ca 9e 15
    inc d               ;1799 14
    dec e               ;179a 1d
    jp nz,l1591h        ;179b c2 91 15
    ld e,d              ;179e 5a
l179fh:
    ld d,00h            ;179f 16 00
    ret                 ;17a1 c9
    ld a,(1722h)        ;17a2 3a 22 17
    or a                ;17a5 b7
    ret z               ;17a6 c8
    ld hl,(1723h)       ;17a7 2a 23 17
    ld (hl),a           ;17aa 77
    xor a               ;17ab af
    ld (1722h),a        ;17ac 32 22 17
l17afh:
    ret                 ;17af c9
    ld hl,(l17e5h)      ;17b0 2a e5 17
l17b3h:
    ld b,(hl)           ;17b3 46
    inc hl              ;17b4 23
l17b5h:
    push hl             ;17b5 e5
    call 158bh          ;17b6 cd 8b 15
    ld hl,l174dh+2      ;17b9 21 4f 17
    ld (hl),e           ;17bc 73
    ld hl,15c7h         ;17bd 21 c7 15
sub_17c0h:
    add hl,de           ;17c0 19
    add hl,de           ;17c1 19
    ld e,(hl)           ;17c2 5e
    inc hl              ;17c3 23
    ld d,(hl)           ;17c4 56
    ex de,hl            ;17c5 eb
    jp (hl)             ;17c6 e9
    ex (sp),hl          ;17c7 e3
    dec d               ;17c8 15
    dec bc              ;17c9 0b
    ld d,0e3h           ;17ca 16 e3
    dec d               ;17cc 15
    dec bc              ;17cd 0b
sub_17ceh:
    ld d,0e9h           ;17ce 16 e9
    dec d               ;17d0 15
    dec e               ;17d1 1d
    ld d,2fh            ;17d2 16 2f
    ld d,60h            ;17d4 16 60
    ld d,60h            ;17d6 16 60
    ld d,5dh            ;17d8 16 5d
    ld d,5dh            ;17da 16 5d
    ld d,53h            ;17dc 16 53
    ld d,60h            ;17de 16 60
l17e0h:
    ld d,4eh            ;17e0 16 4e
    ld d,0cdh           ;17e2 16 cd
    ld sp,hl            ;17e4 f9
l17e5h:
    dec d               ;17e5 15
    jp nz,l1663h        ;17e6 c2 63 16
    call 1604h          ;17e9 cd 04 16
    jp l1663h           ;17ec c3 63 16
    ld a,(l06aah)       ;17ef 3a aa 06
    cp e                ;17f2 bb
    ret nz              ;17f3 c0
    ld a,(l06aah+1)     ;17f4 3a ab 06
    cp d                ;17f7 ba
    ret                 ;17f8 c9
    pop bc              ;17f9 c1
    pop hl              ;17fa e1
    ld e,(hl)           ;17fb 5e
    inc hl              ;17fc 23
    ld d,(hl)           ;17fd 56
    inc hl              ;17fe 23
    push hl             ;17ff e5
    push bc             ;1800 c5
    jp l15efh           ;1801 c3 ef 15
    ld hl,(l17e0h+1)    ;1804 2a e1 17
    ld e,(hl)           ;1807 5e
    inc hl              ;1808 23
    ld d,(hl)           ;1809 56
    ret                 ;180a c9
    call sub_15f9h      ;180b cd f9 15
    jp z,1618h          ;180e ca 18 16
    pop bc              ;1811 c1
    push bc             ;1812 c5
    ld a,02h            ;1813 3e 02
    jp l1665h           ;1815 c3 65 16
    pop de              ;1818 d1
    push de             ;1819 d5
    jp l1663h           ;181a c3 63 16
    ld a,b              ;181d 78
    cp 0ffh             ;181e fe ff
    jp nz,sub_1625h+2   ;1820 c2 27 16
    xor a               ;1823 af
    jp l1667h           ;1824 c3 67 16
    and 38h             ;1827 e6 38
    ld e,a              ;1829 5f
    ld d,00h            ;182a 16 00
    jp l1663h           ;182c c3 63 16
    ld hl,(17e3h)       ;182f 2a e3 17
    ex de,hl            ;1832 eb
    call l15efh         ;1833 cd ef 15
    jp nz,l1663h        ;1836 c2 63 16
    jp l15e9h           ;1839 c3 e9 15
    ld a,(l174dh+2)     ;183c 3a 4f 17
    cp 02h              ;183f fe 02
    ret c               ;1841 d8
    cp 04h              ;1842 fe 04
    ccf                 ;1844 3f
    ret c               ;1845 d8
    ld hl,(l17e5h)      ;1846 2a e5 17
    inc hl              ;1849 23
    inc hl              ;184a 23
    inc hl              ;184b 23
    ex de,hl            ;184c eb
    ret                 ;184d c9
    pop de              ;184e d1
    push de             ;184f d5
    jp l1663h           ;1850 c3 63 16
    call 1604h          ;1853 cd 04 16
    pop bc              ;1856 c1
    push bc             ;1857 c5
    ld a,02h            ;1858 3e 02
    jp l1665h           ;185a c3 65 16
    pop de              ;185d d1
    inc de              ;185e 13
    push de             ;185f d5
    pop de              ;1860 d1
    inc de              ;1861 13
    push de             ;1862 d5
    ld a,01h            ;1863 3e 01
    inc a               ;1865 3c
    scf                 ;1866 37
    push af             ;1867 f5
    ld hl,(l1750h)      ;1868 2a 50 17
    ld a,h              ;186b 7c
    or l                ;186c b5
    jp z,l1698h         ;186d ca 98 16
    push de             ;1870 d5
    push bc             ;1871 c5
    push hl             ;1872 e5
    ld hl,l174dh+2      ;1873 21 4f 17
    ld c,(hl)           ;1876 4e
    ld hl,(l17e5h)      ;1877 2a e5 17
    ex de,hl            ;187a eb
    ld hl,l1680h        ;187b 21 80 16
    ex (sp),hl          ;187e e3
    jp (hl)             ;187f e9
    or a                ;1880 b7
    pop bc              ;1881 c1
    pop de              ;1882 d1
    jp z,l1698h         ;1883 ca 98 16
    push af             ;1886 f5
    ld a,23h            ;1887 3e 23
    call sub_0ffbh+2    ;1889 cd fd 0f
    pop af              ;188c f1
    call l1045h         ;188d cd 45 10
    ld a,20h            ;1890 3e 20
    call sub_0ffbh+2    ;1892 cd fd 0f
    jp l153ch           ;1895 c3 3c 15
    ld a,(1754h)        ;1898 3a 54 17
    ld hl,l174dh        ;189b 21 4d 17
    and (hl)            ;189e a6
    jp z,l16aeh         ;189f ca ae 16
    call sub_163bh+1    ;18a2 cd 3c 16
    jp c,l16aeh         ;18a5 da ae 16
    pop af              ;18a8 f1
    ld a,02h            ;18a9 3e 02
    jp l16d8h+1         ;18ab c3 d9 16
    pop af              ;18ae f1
    push af             ;18af f5
    or a                ;18b0 b7
    jp z,l16d8h         ;18b1 ca d8 16
    dec a               ;18b4 3d
    ex de,hl            ;18b5 eb
    ld e,a              ;18b6 5f
    ld a,(hl)           ;18b7 7e
    cpl                 ;18b8 2f
    ld (hl),a           ;18b9 77
    cp (hl)             ;18ba be
    cpl                 ;18bb 2f
    ld (hl),a           ;18bc 77
    ld a,e              ;18bd 7b
sub_18beh:
    ex de,hl            ;18be eb
    push af             ;18bf f5
    jp z,16cch          ;18c0 ca cc 16
    call sub_163bh+1    ;18c3 cd 3c 16
    jp nc,16cch         ;18c6 d2 cc 16
    call 1604h          ;18c9 cd 04 16
    pop af              ;18cc f1
    dec a               ;18cd 3d
    jp z,l16d8h         ;18ce ca d8 16
    push de             ;18d1 d5
    ld e,c              ;18d2 59
    ld d,b              ;18d3 50
    pop bc              ;18d4 c1
    jp 16b5h            ;18d5 c3 b5 16
    pop af              ;18d8 f1
    pop hl              ;18d9 e1
    ret                 ;18da c9
    rst 38h             ;18db ff
    jp 0c2c7h           ;18dc c3 c7 c2
    rst 38h             ;18df ff
    call 0c4c7h         ;18e0 cd c7 c4
    rst 38h             ;18e3 ff
    ret                 ;18e4 c9
    rst 0               ;18e5 c7
    rst 0               ;18e6 c7
    rst 38h             ;18e7 ff
    jp (hl)             ;18e8 e9
    rst 0               ;18e9 c7
    ld b,0c7h           ;18ea 06 c7
    add a,0cfh          ;18ec c6 cf
sub_18eeh:
    ld bc,22e7h         ;18ee 01 e7 22
    rst 0               ;18f1 c7
    ret nz              ;18f2 c0
    rst 30h             ;18f3 f7
    out (2ah),a         ;18f4 d3 2a
    or c                ;18f6 b1
    rla                 ;18f7 17
    inc hl              ;18f8 23
    inc hl              ;18f9 23
    ld b,(hl)           ;18fa 46
    dec hl              ;18fb 2b
    ld c,(hl)           ;18fc 4e
    dec hl              ;18fd 2b
    ld a,(hl)           ;18fe 7e
    cp 10h              ;18ff fe 10
    jp nc,l171eh        ;1901 d2 1e 17
    push hl             ;1904 e5
    cpl                 ;1905 2f
    add a,l             ;1906 85
    ld l,a              ;1907 6f
    ld a,0ffh           ;1908 3e ff
    adc a,h             ;190a 8c
    ld h,a              ;190b 67
    ld a,e              ;190c 7b
    cp c                ;190d b9
    jp nz,1719h         ;190e c2 19 17
    ld a,d              ;1911 7a
    sub b               ;1912 90
    jp nz,1719h         ;1913 c2 19 17
    pop hl              ;1916 e1
    inc a               ;1917 3c
    ret                 ;1918 c9
    inc sp              ;1919 33
    inc sp              ;191a 33
    jp l16fah           ;191b c3 fa 16
    xor a               ;191e af
    ret                 ;191f c9
    nop                 ;1920 00
    nop                 ;1921 00
    nop                 ;1922 00
    add hl,sp           ;1923 39
    ld b,l              ;1924 45
    dec (hl)            ;1925 35
    nop                 ;1926 00
    ld b,h              ;1927 44
    ld b,c              ;1928 41
    ld b,c              ;1929 41
    nop                 ;192a 00
    jr nc,$+59          ;192b 30 39
sub_192dh:
    inc sp              ;192d 33
    nop                 ;192e 00
    ld a,(bc)           ;192f 0a
    ld a,(0031h)        ;1930 3a 31 00
    jr nc,$+71          ;1933 30 45
    ld b,c              ;1935 41
    nop                 ;1936 00
    jr nc,$+50          ;1937 30 30
    ld b,(hl)           ;1939 46
    nop                 ;193a 00
    ld (l4330h),a       ;193b 32 30 43
l193eh:
    nop                 ;193e 00
    ld b,d              ;193f 42
    ld sp,0030h         ;1940 31 30 00
    ld b,l              ;1943 45
    ld sp,l4443h        ;1944 31 43 44
    ld b,c              ;1947 41
    ld b,c              ;1948 41
    ld sp,l4630h        ;1949 31 30 46
    ld b,l              ;194c 45
    ld (l4430h),a       ;194d 32 30 44
    ld b,c              ;1950 41
    jr c,l1988h         ;1951 38 35
    jr nc,$+71          ;1953 30 45
sub_1955h:
    ld b,e              ;1955 43
    inc sp              ;1956 33
    ld b,c              ;1957 41
    ld (hl),33h         ;1958 36 33
    ld b,(hl)           ;195a 46
sub_195bh:
    dec c               ;195b 0d
    ld a,(bc)           ;195c 0a
    ld a,(3031h)        ;195d 3a 31 30
    jr nc,l19a7h        ;1960 30 45
    ld b,d              ;1962 42
    jr nc,l1995h        ;1963 30 30
    jr nc,l1997h        ;1965 30 30
    ld b,l              ;1967 45
    ld (3041h),a        ;1968 32 41 30
    ld (hl),30h         ;196b 36 30
    ld b,b              ;196d 40
    ld sp,3045h         ;196e 31 45 30
    jr nc,l19a5h        ;1971 30 32
sub_1973h:
    ld b,d              ;1973 42
    ld b,e              ;1974 43
    ld b,h              ;1975 44
    ld b,c              ;1976 41
    ld b,c              ;1977 41
    ld sp,l4630h        ;1978 31 30 46
    ld b,l              ;197b 45
    jr nc,l19b7h        ;197c 30 39
    ld b,e              ;197e 43
    ld b,c              ;197f 41
    ld b,h              ;1980 44
    inc (hl)            ;1981 34
sub_1982h:
    jr nc,l19c9h        ;1982 30 45
    ld b,(hl)           ;1984 46
    ld b,l              ;1985 45
    scf                 ;1986 37
    inc sp              ;1987 33
l1988h:
    dec c               ;1988 0d
    ld a,(bc)           ;1989 0a
    ld a,(3031h)        ;198a 3a 31 30
    jr nc,$+71          ;198d 30 45
    ld b,e              ;198f 43
    jr nc,$+50          ;1990 30 30
    jr nc,l19c4h        ;1992 30 30
    ld b,h              ;1994 44
l1995h:
    ld b,e              ;1995 43
    ld b,c              ;1996 41
l1997h:
    ld b,h              ;1997 44
    inc (hl)            ;1998 34
    jr nc,l19e0h        ;1999 30 45
    ld b,(hl)           ;199b 46
    ld b,l              ;199c 45
    ld (l4430h+1),a     ;199d 32 31 44
    ld b,c              ;19a0 41
    ld b,l              ;19a1 45
    ld sp,3031h         ;19a2 31 31 30
l19a5h:
    scf                 ;19a5 37
    scf                 ;19a6 37
l19a7h:
    ld sp,3743h         ;19a7 31 43 37
    ld b,d              ;19aa 42
    ld b,(hl)           ;19ab 46
    ld b,l              ;19ac 45
    ld sp,l4430h        ;19ad 31 30 44
    ld (3145h),a        ;19b0 32 45 31
l19b3h:
    ld b,d              ;19b3 42
    jr nc,l19f4h        ;19b4 30 3e
    ld a,(de)           ;19b6 1a
l19b7h:
    scf                 ;19b7 37
    pop bc              ;19b8 c1
    pop de              ;19b9 d1
l19bah:
    pop hl              ;19ba e1
    ret                 ;19bb c9
    ld b,h              ;19bc 44
    jr nc,$+50          ;19bd 30 30
    jr nc,$+51          ;19bf 30 31
    jr nc,l1a06h        ;19c1 30 43
    inc sp              ;19c3 33
l19c4h:
    ld b,d              ;19c4 42
    ld (hl),30h         ;19c5 36 30
    ld b,l              ;19c7 45
    ld b,h              ;19c8 44
l19c9h:
    dec (hl)            ;19c9 35
    ld b,l              ;19ca 45
    dec (hl)            ;19cb 35
l19cch:
    ld b,l              ;19cc 45
    ld b,d              ;19cd 42
    ld (3041h),a        ;19ce 32 41 30
    ld (hl),30h         ;19d1 36 30
    jr nc,l1a07h        ;19d3 30 32
    inc sp              ;19d5 33
    dec (hl)            ;19d6 35
    ld b,l              ;19d7 45
    ld (3533h),a        ;19d8 32 33 35
    ld (hl),45h         ;19db 36 45
    ld sp,3237h         ;19dd 31 37 32
l19e0h:
    dec (hl)            ;19e0 35
    add hl,sp           ;19e1 39
    dec c               ;19e2 0d
    ld a,(bc)           ;19e3 0a
    ld a,(3031h)        ;19e4 3a 31 30
    nop                 ;19e7 00
    jr nz,$-110         ;19e8 20 90
    nop                 ;19ea 00
    ld b,b              ;19eb 40
    nop                 ;19ec 00
    ex af,af'           ;19ed 08
    ld hl,9210h         ;19ee 21 10 92
    djnz l1a14h         ;19f1 10 21
    ld (de),a           ;19f3 12
l19f4h:
    ld b,d              ;19f4 42
    ld c,b              ;19f5 48
    nop                 ;19f6 00
    add hl,bc           ;19f7 09
    djnz l19fch         ;19f8 10 02
    ld b,b              ;19fa 40
    nop                 ;19fb 00
l19fch:
    djnz $+66           ;19fc 10 40
    ex af,af'           ;19fe 08
    ex af,af'           ;19ff 08
    ld b,c              ;1a00 41
    ld (bc),a           ;1a01 02
    nop                 ;1a02 00
    add a,d             ;1a03 82
    ld b,d              ;1a04 42
    ld c,b              ;1a05 48
l1a06h:
    add hl,bc           ;1a06 09
l1a07h:
    add hl,bc           ;1a07 09
    jr nz,$+68          ;1a08 20 42
    ld hl,2001h         ;1a0a 21 01 20
sub_1a0dh:
    ex af,af'           ;1a0d 08
    ld (1112h),hl       ;1a0e 22 12 11
    djnz l1a23h         ;1a11 10 10
    adc a,b             ;1a13 88
l1a14h:
    ld b,d              ;1a14 42
    ld c,b              ;1a15 48
    ld c,c              ;1a16 49
    inc h               ;1a17 24
    inc h               ;1a18 24
    sub d               ;1a19 92
    ld b,d              ;1a1a 42
    ld c,c              ;1a1b 49
    inc h               ;1a1c 24
    ld b,d              ;1a1d 42
    ld c,c              ;1a1e 49
    jr nz,l19a5h        ;1a1f 20 84
    inc h               ;1a21 24
    add a,h             ;1a22 84
l1a23h:
    djnz l19b7h         ;1a23 10 92
    add hl,bc           ;1a25 09
    djnz l19bah         ;1a26 10 92
    ld c,b              ;1a28 48
sub_1a29h:
    ld c,c              ;1a29 49
    add hl,bc           ;1a2a 09
    jr nz,$-124         ;1a2b 20 82
    ld b,h              ;1a2d 44
    inc b               ;1a2e 04
    inc h               ;1a2f 24
    sub b               ;1a30 90
    sub b               ;1a31 90
    add a,h             ;1a32 84
    sub c               ;1a33 91
    ex af,af'           ;1a34 08
    ld c,b              ;1a35 48
    sub b               ;1a36 90
    sub b               ;1a37 90
    add a,h             ;1a38 84
    add a,h             ;1a39 84
    ld b,h              ;1a3a 44
    inc h               ;1a3b 24
    inc h               ;1a3c 24
    jr nz,l1a87h        ;1a3d 20 48
    ex af,af'           ;1a3f 08
    inc b               ;1a40 04
    ex af,af'           ;1a41 08
    ex af,af'           ;1a42 08
    nop                 ;1a43 00
    inc b               ;1a44 04
    nop                 ;1a45 00
    jr nz,l19cch        ;1a46 20 84
    jr nz,l1a52h        ;1a48 20 08
l1a4ah:
    ld b,d              ;1a4a 42
    djnz $-108          ;1a4b 10 92
    inc b               ;1a4d 04
    ld hl,l4424h        ;1a4e 21 24 44
    inc h               ;1a51 24
l1a52h:
    inc b               ;1a52 04
    adc a,b             ;1a53 88
    ld (9224h),hl       ;1a54 22 24 92
    ld b,d              ;1a57 42
    inc h               ;1a58 24
    sub b               ;1a59 90
    sub d               ;1a5a 92
    ld b,h              ;1a5b 44
    ex af,af'           ;1a5c 08
    ld b,c              ;1a5d 41
    ex af,af'           ;1a5e 08
    ld hl,l1002h        ;1a5f 21 02 10
    ld de,l4110h        ;1a62 11 10 41
    ex af,af'           ;1a65 08
    ld b,d              ;1a66 42
    ex af,af'           ;1a67 08
    ex af,af'           ;1a68 08
    sub b               ;1a69 90
    sub d               ;1a6a 92
    ld c,c              ;1a6b 49
    inc h               ;1a6c 24
    add a,h             ;1a6d 84
    sub b               ;1a6e 90
    sub d               ;1a6f 92
    ld (de),a           ;1a70 12
    ld c,b              ;1a71 48
    jr nz,l1ab6h        ;1a72 20 42
    ld bc,9024h         ;1a74 01 24 90
    sub d               ;1a77 92
    ld c,c              ;1a78 49
    add hl,bc           ;1a79 09
sub_1a7ah:
    inc h               ;1a7a 24
    sub d               ;1a7b 92
    ld c,b              ;1a7c 48
    ex af,af'           ;1a7d 08
    sub d               ;1a7e 92
    ld c,c              ;1a7f 49
    ex af,af'           ;1a80 08
l1a81h:
    inc h               ;1a81 24
    ex af,af'           ;1a82 08
    sub c               ;1a83 91
    inc b               ;1a84 04
    add a,c             ;1a85 81
    ld (de),a           ;1a86 12
l1a87h:
    ld c,b              ;1a87 48
    ld de,8924h         ;1a88 11 24 89
    ld hl,2420h         ;1a8b 21 20 24
    sub d               ;1a8e 92
    ld c,c              ;1a8f 49
    jr nz,l1a92h        ;1a90 20 00
l1a92h:
    nop                 ;1a92 00
    nop                 ;1a93 00
    nop                 ;1a94 00
    nop                 ;1a95 00
    nop                 ;1a96 00
    nop                 ;1a97 00
    nop                 ;1a98 00
    nop                 ;1a99 00
l1a9ah:
    nop                 ;1a9a 00
l1a9bh:
    nop                 ;1a9b 00
    nop                 ;1a9c 00
    nop                 ;1a9d 00
    nop                 ;1a9e 00
    nop                 ;1a9f 00
    nop                 ;1aa0 00
    nop                 ;1aa1 00
l1aa2h:
    nop                 ;1aa2 00
    nop                 ;1aa3 00
    nop                 ;1aa4 00
    nop                 ;1aa5 00
    nop                 ;1aa6 00
    nop                 ;1aa7 00
    nop                 ;1aa8 00
    nop                 ;1aa9 00
    nop                 ;1aaa 00
    nop                 ;1aab 00
l1aach:
    nop                 ;1aac 00
    nop                 ;1aad 00
    nop                 ;1aae 00
    nop                 ;1aaf 00
    nop                 ;1ab0 00
    nop                 ;1ab1 00
    nop                 ;1ab2 00
    nop                 ;1ab3 00
    nop                 ;1ab4 00
    nop                 ;1ab5 00
l1ab6h:
    nop                 ;1ab6 00
    nop                 ;1ab7 00
    inc h               ;1ab8 24
    sub d               ;1ab9 92
    ld c,c              ;1aba 49
    inc h               ;1abb 24
    sub c               ;1abc 91
    nop                 ;1abd 00
    ld c,c              ;1abe 49
    jr nz,l1a4ah        ;1abf 20 89
    inc h               ;1ac1 24
    ld (de),a           ;1ac2 12
    ld c,b              ;1ac3 48
    jr nz,l1aceh        ;1ac4 20 08
    ld b,b              ;1ac6 40
    ld b,b              ;1ac7 40
    ex af,af'           ;1ac8 08
    inc h               ;1ac9 24
    add a,h             ;1aca 84
    add a,h             ;1acb 84
    sub b               ;1acc 90
    sub b               ;1acd 90
l1aceh:
    ld (8210h),hl       ;1ace 22 10 82
    ld bc,5555h         ;1ad1 01 55 55
    ld d,l              ;1ad4 55
    ld d,l              ;1ad5 55
    ld d,l              ;1ad6 55
    ld d,l              ;1ad7 55
    ld b,b              ;1ad8 40
    nop                 ;1ad9 00
    add a,b             ;1ada 80
    ld c,b              ;1adb 48
    ld (9148h),hl       ;1adc 22 48 91
    inc h               ;1adf 24
    ld c,c              ;1ae0 49
    inc h               ;1ae1 24
    sub d               ;1ae2 92
    ld c,c              ;1ae3 49
l1ae4h:
    ld (de),a           ;1ae4 12
    ld b,h              ;1ae5 44
    ld b,d              ;1ae6 42
    ld c,c              ;1ae7 49
    inc h               ;1ae8 24
    add a,b             ;1ae9 80
    add a,h             ;1aea 84
    add a,h             ;1aeb 84
    ld c,b              ;1aec 48
    ld hl,9024h         ;1aed 21 24 90
    ld c,b              ;1af0 48
    sub d               ;1af1 92
    nop                 ;1af2 00
    ld c,c              ;1af3 49
    inc h               ;1af4 24
    sub b               ;1af5 90
    sub c               ;1af6 91
    ex af,af'           ;1af7 08
    ex af,af'           ;1af8 08
    sub c               ;1af9 91
    inc h               ;1afa 24
    ld b,h              ;1afb 44
    add a,d             ;1afc 82
    ld c,b              ;1afd 48
    sub c               ;1afe 91
    ld de,l4908h        ;1aff 11 08 49
    inc h               ;1b02 24
    add a,h             ;1b03 84
    adc a,b             ;1b04 88
    add a,b             ;1b05 80
    djnz l1a9ah         ;1b06 10 92
    ex af,af'           ;1b08 08
    sub d               ;1b09 92
    ld c,b              ;1b0a 48
    sub c               ;1b0b 91
    jr nz,l1b52h        ;1b0c 20 44
    add hl,bc           ;1b0e 09
    jr nz,l1aa2h        ;1b0f 20 91
    add hl,bc           ;1b11 09
    ld bc,l1201h        ;1b12 01 01 12
    djnz l1a9bh         ;1b15 10 84
    add hl,bc           ;1b17 09
    nop                 ;1b18 00
    ld bc,2220h         ;1b19 01 20 22
    inc b               ;1b1c 04
    djnz l1b27h         ;1b1d 10 08
    ld b,b              ;1b1f 40
    nop                 ;1b20 00
    ld (de),a           ;1b21 12
l1b22h:
    ld b,h              ;1b22 44
    ld b,h              ;1b23 44
    ld (0440h),hl       ;1b24 22 40 04
l1b27h:
    add a,b             ;1b27 80
    ld (bc),a           ;1b28 02
    ld (de),a           ;1b29 12
    djnz l1aach         ;1b2a 10 80
    nop                 ;1b2c 00
    adc a,b             ;1b2d 88
    jr nz,l1b78h        ;1b2e 20 48
    ld de,2220h         ;1b30 11 20 22
    djnz l1b55h         ;1b33 10 20
    ld (l0842h),hl      ;1b35 22 42 08
    ld c,c              ;1b38 49
    nop                 ;1b39 00
    inc b               ;1b3a 04
    adc a,b             ;1b3b 88
    add a,h             ;1b3c 84
    inc h               ;1b3d 24
    sub d               ;1b3e 92
    nop                 ;1b3f 00
    add a,b             ;1b40 80
    ld bc,l1221h        ;1b41 01 21 12
    inc h               ;1b44 24
    add hl,bc           ;1b45 09
    ld bc,2011h         ;1b46 01 11 20
    nop                 ;1b49 00
    jr nz,l1b5ch        ;1b4a 20 10
l1b4ch:
    adc a,b             ;1b4c 88
    ld b,b              ;1b4d 40
    ld c,b              ;1b4e 48
    ld (bc),a           ;1b4f 02
    djnz l1ae4h         ;1b50 10 92
l1b52h:
    ld c,b              ;1b52 48
    inc b               ;1b53 04
    ld b,d              ;1b54 42
l1b55h:
    ld c,c              ;1b55 49
    ld (bc),a           ;1b56 02
l1b57h:
    nop                 ;1b57 00
    ld bc,8800h         ;1b58 01 00 88
    add a,c             ;1b5b 81
l1b5ch:
    ld hl,8024h         ;1b5c 21 24 80
    sub c               ;1b5f 91
    inc h               ;1b60 24
    ex af,af'           ;1b61 08
    add hl,bc           ;1b62 09
    jr nz,l1b85h        ;1b63 20 20
    ex af,af'           ;1b65 08
    ld c,b              ;1b66 48
    jr nz,l1b6dh        ;1b67 20 04
    adc a,c             ;1b69 89
    ld bc,l0820h        ;1b6a 01 20 08
l1b6dh:
    inc b               ;1b6d 04
    sub b               ;1b6e 90
    ld (de),a           ;1b6f 12
    ld hl,2011h         ;1b70 21 11 20
    ld b,b              ;1b73 40
    ld (de),a           ;1b74 12
    ld b,c              ;1b75 41
    ld (de),a           ;1b76 12
    ld b,c              ;1b77 41
l1b78h:
    nop                 ;1b78 00
    ld b,b              ;1b79 40
    ld c,b              ;1b7a 48
    ld b,b              ;1b7b 40
    ld c,b              ;1b7c 48
    add a,b             ;1b7d 80
    ld (bc),a           ;1b7e 02
    djnz l1b81h         ;1b7f 10 00
l1b81h:
    sub d               ;1b81 92
    ld b,d              ;1b82 42
    djnz l1bc9h         ;1b83 10 44
l1b85h:
    ld b,b              ;1b85 40
    ld b,b              ;1b86 40
    ld b,d              ;1b87 42
    ld c,c              ;1b88 49
    inc b               ;1b89 04
    adc a,b             ;1b8a 88
    sub d               ;1b8b 92
    ld b,b              ;1b8c 40
    ld (de),a           ;1b8d 12
    ld bc,2400h         ;1b8e 01 00 24
    sub c               ;1b91 91
    ld bc,0010h         ;1b92 01 10 00
    add a,b             ;1b95 80
    add hl,bc           ;1b96 09
    inc h               ;1b97 24
    ld c,b              ;1b98 48
    ld b,d              ;1b99 42
    ld b,h              ;1b9a 44
    ld hl,8408h         ;1b9b 21 08 84
    add a,b             ;1b9e 80
    ld b,d              ;1b9f 42
    djnz l1b22h         ;1ba0 10 80
    sub b               ;1ba2 90
    nop                 ;1ba3 00
    ld bc,0020h         ;1ba4 01 20 00
    inc b               ;1ba7 04
    ld c,b              ;1ba8 48
    add a,b             ;1ba9 80
l1baah:
    sub d               ;1baa 92
    ld c,c              ;1bab 49
    inc h               ;1bac 24
    sub b               ;1bad 90
    inc h               ;1bae 24
    nop                 ;1baf 00
    nop                 ;1bb0 00
    nop                 ;1bb1 00
    ex af,af'           ;1bb2 08
    sub d               ;1bb3 92
    inc h               ;1bb4 24
    ld (8904h),hl       ;1bb5 22 04 89
l1bb8h:
    inc h               ;1bb8 24
    djnz l1b4ch         ;1bb9 10 91
    ld bc,8220h         ;1bbb 01 20 82
    ld b,h              ;1bbe 44
    sub c               ;1bbf 91
    nop                 ;1bc0 00
    adc a,b             ;1bc1 88
    ld de,8410h         ;1bc2 11 10 84
    add a,d             ;1bc5 82
    inc h               ;1bc6 24
    add a,d             ;1bc7 82
    ex af,af'           ;1bc8 08
l1bc9h:
    sub d               ;1bc9 92
    ld (l0949h),hl      ;1bca 22 49 09
    jr nz,l1b57h        ;1bcd 20 88
    inc h               ;1bcf 24
    add a,h             ;1bd0 84
    ld c,c              ;1bd1 49
    inc h               ;1bd2 24
    ld b,h              ;1bd3 44
    add a,c             ;1bd4 81
    ex af,af'           ;1bd5 08
    inc h               ;1bd6 24
    ex af,af'           ;1bd7 08
    djnz l1b5ch         ;1bd8 10 82
    ld b,d              ;1bda 42
    ld (4020h),hl       ;1bdb 22 20 40
    ex af,af'           ;1bde 08
    nop                 ;1bdf 00
    ld b,b              ;1be0 40
    ld b,b              ;1be1 40
    ld b,h              ;1be2 44
    djnz l1bf5h         ;1be3 10 10
    sub b               ;1be5 90
    sub d               ;1be6 92
    ld b,b              ;1be7 40
    inc b               ;1be8 04
    ld bc,0012h         ;1be9 01 12 00
    djnz l1c10h         ;1bec 10 22
    djnz $+35           ;1bee 10 21
    ex af,af'           ;1bf0 08
    ld (bc),a           ;1bf1 02
l1bf2h:
    ex af,af'           ;1bf2 08
    ld b,d              ;1bf3 42
    ld (bc),a           ;1bf4 02
l1bf5h:
    nop                 ;1bf5 00
    ld (l0811h),hl      ;1bf6 22 11 08
    ld (l4410h),hl      ;1bf9 22 10 44
    add a,h             ;1bfc 84
    ld (8410h),hl       ;1bfd 22 10 84
    ld b,b              ;1c00 40
    nop                 ;1c01 00
    nop                 ;1c02 00
    nop                 ;1c03 00
    ld bc,2400h         ;1c04 01 00 24
    inc b               ;1c07 04
    ex af,af'           ;1c08 08
    add a,d             ;1c09 82
    ld b,h              ;1c0a 44
    inc h               ;1c0b 24
    adc a,b             ;1c0c 88
    inc h               ;1c0d 24
    sub b               ;1c0e 90
    ld (bc),a           ;1c0f 02
l1c10h:
    jr nz,l1c12h        ;1c10 20 00
l1c12h:
    djnz l1c1ch         ;1c12 10 08
    ld c,b              ;1c14 48
    nop                 ;1c15 00
    sub b               ;1c16 90
    ld bc,8410h         ;1c17 01 10 84
    sub b               ;1c1a 90
    ld b,d              ;1c1b 42
l1c1ch:
    ld (de),a           ;1c1c 12
    ld c,b              ;1c1d 48
    djnz l1c20h         ;1c1e 10 00
l1c20h:
    add a,c             ;1c20 81
    djnz l1c44h         ;1c21 10 21
    ex af,af'           ;1c23 08
    inc b               ;1c24 04
    sub b               ;1c25 90
    ld b,b              ;1c26 40
    jr nz,l1c49h        ;1c27 20 20
    add a,h             ;1c29 84
    ld b,h              ;1c2a 44
    add a,h             ;1c2b 84
    ld c,b              ;1c2c 48
    djnz l1c73h         ;1c2d 10 44
    nop                 ;1c2f 00
    ld c,c              ;1c30 49
l1c31h:
    ld (bc),a           ;1c31 02
    ld (de),a           ;1c32 12
    ld (bc),a           ;1c33 02
    djnz l1bb8h         ;1c34 10 82
    ld c,b              ;1c36 48
    ld c,c              ;1c37 49
    ld hl,8424h         ;1c38 21 24 84
    add a,d             ;1c3b 82
    ld bc,got_error     ;1c3c 01 01 02
    ld (0002h),hl       ;1c3f 22 02 00
    add a,h             ;1c42 84
    nop                 ;1c43 00
l1c44h:
    sub b               ;1c44 90
    ld b,h              ;1c45 44
    ld hl,2212h         ;1c46 21 12 22
l1c49h:
    ld b,h              ;1c49 44
    sub b               ;1c4a 90
    jr nz,$+10          ;1c4b 20 08
    ld c,c              ;1c4d 49
    inc h               ;1c4e 24
    ld (de),a           ;1c4f 12
    ld c,c              ;1c50 49
    add hl,bc           ;1c51 09
    ld (de),a           ;1c52 12
    ld (2044h),hl       ;1c53 22 44 20
    sub c               ;1c56 91
    jr nz,l1c69h        ;1c57 20 10
    ld (de),a           ;1c59 12
    djnz l1c9ch         ;1c5a 10 40
    add a,b             ;1c5c 80
    sub b               ;1c5d 90
    ld b,d              ;1c5e 42
    djnz l1bf2h         ;1c5f 10 91
    inc h               ;1c61 24
    ex af,af'           ;1c62 08
    inc h               ;1c63 24
    sub c               ;1c64 91
    ld (de),a           ;1c65 12
    ld b,b              ;1c66 40
    nop                 ;1c67 00
    nop                 ;1c68 00
l1c69h:
    nop                 ;1c69 00
    adc a,b             ;1c6a 88
    ld b,d              ;1c6b 42
    ld bc,l0100h+1      ;1c6c 01 01 01
    inc h               ;1c6f 24
    inc b               ;1c70 04
    nop                 ;1c71 00
    inc b               ;1c72 04
l1c73h:
    sub b               ;1c73 90
    jr nz,l1c77h        ;1c74 20 01
    ex af,af'           ;1c76 08
l1c77h:
    adc a,b             ;1c77 88
    inc h               ;1c78 24
    sub b               ;1c79 90
    ld (de),a           ;1c7a 12
    inc h               ;1c7b 24
    inc b               ;1c7c 04
    ex af,af'           ;1c7d 08
    add a,h             ;1c7e 84
    djnz $-110          ;1c7f 10 90
    add a,h             ;1c81 84
    adc a,c             ;1c82 89
    inc h               ;1c83 24
    inc h               ;1c84 24
    sub c               ;1c85 91
    inc h               ;1c86 24
    ld (bc),a           ;1c87 02
    ld c,c              ;1c88 49
    ld (2449h),hl       ;1c89 22 49 24
    sub c               ;1c8c 91
    ld hl,9210h         ;1c8d 21 10 92
    add hl,bc           ;1c90 09
    ld hl,9224h         ;1c91 21 24 92
    ld c,c              ;1c94 49
    nop                 ;1c95 00
    ld b,b              ;1c96 40
    adc a,b             ;1c97 88
    ld hl,8000h         ;1c98 21 00 80
    add a,h             ;1c9b 84
l1c9ch:
    ex af,af'           ;1c9c 08
    ld b,d              ;1c9d 42
    jr nz,l1c31h        ;1c9e 20 91
    nop                 ;1ca0 00
    xor d               ;1ca1 aa
    xor d               ;1ca2 aa
    xor d               ;1ca3 aa
    and h               ;1ca4 a4
    sub d               ;1ca5 92
    ld b,d              ;1ca6 42
    nop                 ;1ca7 00
    ld (de),a           ;1ca8 12
    inc b               ;1ca9 04
    add a,c             ;1caa 81
    ex af,af'           ;1cab 08
    ld (4402h),hl       ;1cac 22 02 44
    sub d               ;1caf 92
    nop                 ;1cb0 00
    add a,b             ;1cb1 80
    inc h               ;1cb2 24
    ex af,af'           ;1cb3 08
    nop                 ;1cb4 00
    ld hl,l4404h        ;1cb5 21 04 44
    inc b               ;1cb8 04
    ld de,2409h         ;1cb9 11 09 24
    ld c,c              ;1cbc 49
    inc b               ;1cbd 04
    djnz l1cc0h         ;1cbe 10 00
l1cc0h:
    inc h               ;1cc0 24
    sub b               ;1cc1 90
    add a,c             ;1cc2 81
    nop                 ;1cc3 00
    nop                 ;1cc4 00
    nop                 ;1cc5 00
    ld bc,1000h         ;1cc6 01 00 10
    nop                 ;1cc9 00
    add a,h             ;1cca 84
    inc b               ;1ccb 04

    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

; Start of code similar to HardBox ROM ======================================

;Note: this code is not executed by MWDOS291.COM.  It is a data payload
;      that gets written to the hard disk.  The addresses here (4000h+)
;      are offset.  It is believed that the actual start address of this
;      code in MW-100 memory is 0100h.

l4000h:
    jp 0200h            ;4000 c3 00 02
    ld bc,0000h         ;4003 01 00 00
    nop                 ;4006 00
    ret nz              ;4007 c0
    rla                 ;4008 17
    nop                 ;4009 00
    ret po              ;400a e0
    inc bc              ;400b 03
    ld sp,hl            ;400c f9
    inc bc              ;400d 03
    ld c,l              ;400e 4d
    nop                 ;400f 00
    dec e               ;4010 1d

    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db "HARD DISK       ",07h,60h,00h,08h
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0

    xor a               ;4100 af
    out (11h),a         ;4101 d3 11
    ld a,80h            ;4103 3e 80
    out (15h),a         ;4105 d3 15
    ld a,(0136h)        ;4107 3a 36 01
    ld (2000h),a        ;410a 32 00 20
    ld sp,4a93h         ;410d 31 93 4a
l4110h:
    ld hl,2004h         ;4110 21 04 20
    ld de,2005h         ;4113 11 05 20
    ld bc,2a0eh         ;4116 01 0e 2a
    ld (hl),00h         ;4119 36 00
    ldir                ;411b ed b0
    xor a               ;411d af
    ld (2002h),a        ;411e 32 02 20
    ld a,01h            ;4121 3e 01
    ld (l460ch),a       ;4123 32 0c 46
    ld hl,2bf5h         ;4126 21 f5 2b
    ld (2af3h),hl       ;4129 22 f3 2a
    ld hl,0103h         ;412c 21 03 01
    ld de,2004h         ;412f 11 04 20
    ld bc,0020h         ;4132 01 20 00
    ldir                ;4135 ed b0
    ld hl,l0123h        ;4137 21 23 01
    ld de,203eh         ;413a 11 3e 20
    ld bc,0010h         ;413d 01 10 00
    ldir                ;4140 ed b0
    call 05d8h          ;4142 cd d8 05
    call sub_192dh      ;4145 cd 2d 19
    ld hl,(200bh)       ;4148 2a 0b 20
    ld (202ah),hl       ;414b 22 2a 20
sub_414eh:
    ld a,(2009h)        ;414e 3a 09 20
    ld e,a              ;4151 5f
    ld d,00h            ;4152 16 00
    add hl,de           ;4154 19
    ld (202fh),hl       ;4155 22 2f 20
    ld hl,(200dh)       ;4158 2a 0d 20
    ld a,h              ;415b 7c
    ld b,09h            ;415c 06 09
    call sub_1a7ah      ;415e cd 7a 1a
    inc hl              ;4161 23
    ld (2039h),hl       ;4162 22 39 20
    ld hl,(200bh)       ;4165 2a 0b 20
    ld b,05h            ;4168 06 05
    call sub_1a7ah      ;416a cd 7a 1a
    inc hl              ;416d 23
    ex de,hl            ;416e eb
    ld hl,(202ah)       ;416f 2a 2a 20
    ld b,03h            ;4172 06 03
    call sub_1a7ah      ;4174 cd 7a 1a
    inc hl              ;4177 23
    add hl,de           ;4178 19
    ex de,hl            ;4179 eb
    ld hl,(202fh)       ;417a 2a 2f 20
    ld b,02h            ;417d 06 02
    call sub_1a7ah      ;417f cd 7a 1a
    inc hl              ;4182 23
    add hl,de           ;4183 19
    ld de,(200dh)       ;4184 ed 5b 0d 20
    add hl,de           ;4188 19
    ld de,(2039h)       ;4189 ed 5b 39 20
    add hl,de           ;418d 19
    ex de,hl            ;418e eb
    ld hl,(2008h)       ;418f 2a 08 20
    scf                 ;4192 37
    sbc hl,de           ;4193 ed 52
    srl h               ;4195 cb 3c
    rr l                ;4197 cb 1d
    ld (2034h),hl       ;4199 22 34 20
    ld hl,(2005h)       ;419c 2a 05 20
    ld a,(2007h)        ;419f 3a 07 20
    ld de,0004h         ;41a2 11 04 00
    add hl,de           ;41a5 19
    adc a,00h           ;41a6 ce 00
    ld (2024h),hl       ;41a8 22 24 20
    ld (2026h),a        ;41ab 32 26 20
    ex de,hl            ;41ae eb
    ld hl,(200bh)       ;41af 2a 0b 20
    ld b,03h            ;41b2 06 03
    call sub_1a7ah      ;41b4 cd 7a 1a
    inc hl              ;41b7 23
    add hl,de           ;41b8 19
    adc a,00h           ;41b9 ce 00
    ld (2027h),hl       ;41bb 22 27 20
    ld (2029h),a        ;41be 32 29 20
    ld de,(202ah)       ;41c1 ed 5b 2a 20
    srl d               ;41c5 cb 3a
    rr e                ;41c7 cb 1b
    inc de              ;41c9 13
    add hl,de           ;41ca 19
    adc a,00h           ;41cb ce 00
    ld (202ch),hl       ;41cd 22 2c 20
    ld (202eh),a        ;41d0 32 2e 20
    ld de,(202fh)       ;41d3 ed 5b 2f 20
    add hl,de           ;41d7 19
    adc a,00h           ;41d8 ce 00
    ld (2031h),hl       ;41da 22 31 20
    ld (2033h),a        ;41dd 32 33 20
    ld de,(2034h)       ;41e0 ed 5b 34 20
    ld b,08h            ;41e4 06 08
l41e6h:
    add hl,de           ;41e6 19
    adc a,00h           ;41e7 ce 00
    djnz l41e6h         ;41e9 10 fb
    ld (203bh),hl       ;41eb 22 3b 20
    ld (203dh),a        ;41ee 32 3d 20
    ex de,hl            ;41f1 eb
    ld hl,(2039h)       ;41f2 2a 39 20
    add hl,hl           ;41f5 29
    add hl,hl           ;41f6 29
    add hl,de           ;41f7 19
    adc a,00h           ;41f8 ce 00
    ld (2036h),hl       ;41fa 22 36 20
    ld (2038h),a        ;41fd 32 38 20
    ld a,0fh            ;4200 3e 0f
    ld (2ae7h),a        ;4202 32 e7 2a
    call sub_1689h      ;4205 cd 89 16
    ld hl,0000h         ;4208 21 00 00
    ld (2d68h),hl       ;420b 22 68 2d
l420eh:
    call sub_15a6h      ;420e cd a6 15
    jr c,l4236h         ;4211 38 23
    bit 7,(ix+01h)      ;4213 dd cb 01 7e
    jr nz,l420eh        ;4217 20 f5
    call sub_18beh      ;4219 cd be 18
    ld b,40h            ;421c 06 40
    ld ix,(2aeeh)       ;421e dd 2a ee 2a
l4222h:
    ld l,(ix+00h)       ;4222 dd 6e 00
    ld h,(ix+01h)       ;4225 dd 66 01
    ld de,2057h         ;4228 11 57 20
    call 1733h          ;422b cd 33 17
    inc ix              ;422e dd 23
    inc ix              ;4230 dd 23
    djnz l4222h         ;4232 10 ee
    jr l420eh           ;4234 18 d8
l4236h:
    ld de,0000h         ;4236 11 00 00
    ld hl,2057h         ;4239 21 57 20
l423ch:
    ld b,08h            ;423c 06 08
    ld c,(hl)           ;423e 4e
    inc hl              ;423f 23
l4240h:
    rr c                ;4240 cb 19
    jr nc,l4265h        ;4242 30 21
    push bc             ;4244 c5
    push hl             ;4245 e5
    push de             ;4246 d5
    call l17b5h         ;4247 cd b5 17
    ld b,80h            ;424a 06 80
    ld ix,(2aeah)       ;424c dd 2a ea 2a
l4250h:
    ld l,(ix+00h)       ;4250 dd 6e 00
    ld h,(ix+01h)       ;4253 dd 66 01
    inc ix              ;4256 dd 23
    inc ix              ;4258 dd 23
    ld de,2457h         ;425a 11 57 24
    call 1733h          ;425d cd 33 17
    djnz l4250h         ;4260 10 ee
    pop de              ;4262 d1
    pop hl              ;4263 e1
    pop bc              ;4264 c1
l4265h:
    inc de              ;4265 13
    ld a,(202fh)        ;4266 3a 2f 20
    cp e                ;4269 bb
    jr nz,l4272h        ;426a 20 06
    ld a,(2030h)        ;426c 3a 30 20
    cp d                ;426f ba
    jr z,l4276h         ;4270 28 04
l4272h:
    djnz l4240h         ;4272 10 cc
    jr l423ch           ;4274 18 c6
l4276h:
    xor a               ;4276 af
    out (16h),a         ;4277 d3 16
    out (11h),a         ;4279 d3 11
    in a,(15h)          ;427b db 15
    and 00h             ;427d e6 00
    out (15h),a         ;427f d3 15
l4281h:
    in a,(14h)          ;4281 db 14
    and 01h             ;4283 e6 01
    jr z,l4281h         ;4285 28 fa
l4287h:
    in a,(15h)          ;4287 db 15
    or 84h              ;4289 f6 84
    out (15h),a         ;428b d3 15
    in a,(15h)          ;428d db 15
    and 0f7h            ;428f e6 f7
    out (15h),a         ;4291 d3 15
l4293h:
    in a,(14h)          ;4293 db 14
    and 02h             ;4295 e6 02
    jr nz,l42a2h        ;4297 20 09
    in a,(14h)          ;4299 db 14
    and 01h             ;429b e6 01
    jr nz,l4293h        ;429d 20 f4
    jp 0415h            ;429f c3 15 04
l42a2h:
    ld hl,2af0h         ;42a2 21 f0 2a
    in a,(15h)          ;42a5 db 15
    or 08h              ;42a7 f6 08
    out (15h),a         ;42a9 d3 15
    in a,(10h)          ;42ab db 10
    ld c,a              ;42ad 4f
    in a,(15h)          ;42ae db 15
    and 0fbh            ;42b0 e6 fb
    out (15h),a         ;42b2 d3 15
    ld a,(2000h)        ;42b4 3a 00 20
    or 20h              ;42b7 f6 20
    cp c                ;42b9 b9
    jr z,do_listn       ;42ba 28 26
    xor 60h             ;42bc ee 60
    cp c                ;42be b9
    jr z,do_talk        ;42bf 28 29
    ld a,c              ;42c1 79
    cp 3fh              ;42c2 fe 3f
    jr z,do_unlst       ;42c4 28 2c
    cp 5fh              ;42c6 fe 5f
    jr z,do_untlk       ;42c8 28 2c
    and 60h             ;42ca e6 60
    cp 60h              ;42cc fe 60
    jr nz,l42dah        ;42ce 20 0a
    ld a,c              ;42d0 79
    ld (2ae7h),a        ;42d1 32 e7 2a
    and 0f0h            ;42d4 e6 f0
    cp 0e0h             ;42d6 fe e0
    jr z,l42fah         ;42d8 28 20
l42dah:
    in a,(14h)          ;42da db 14
    and 02h             ;42dc e6 02
    jr nz,l42dah        ;42de 20 fa
    jr l4287h           ;42e0 18 a5

do_listn:
    set 2,(hl)          ;42e2 cb d6
    xor a               ;42e4 af
    ld (2ae7h),a        ;42e5 32 e7 2a
    jr l42dah           ;42e8 18 f0

do_talk:
    set 1,(hl)          ;42ea cb ce
    xor a               ;42ec af
    ld (2ae7h),a        ;42ed 32 e7 2a
    jr l42dah           ;42f0 18 e8

do_unlst:
    res 2,(hl)          ;42f2 cb 96
    jr l42dah           ;42f4 18 e4

do_untlk:
    res 1,(hl)          ;42f6 cb 8e
    jr l42dah           ;42f8 18 e0

l42fah:
    ld (hl),00h         ;42fa 36 00
    ld a,c              ;42fc 79
    and 0fh             ;42fd e6 0f
    ld (2ae7h),a        ;42ff 32 e7 2a
    push af             ;4302 f5
    cp 02h              ;4303 fe 02
    call nc,05d8h       ;4305 d4 d8 05
    pop af              ;4308 f1
    cp 0fh              ;4309 fe 0f
    push af             ;430b f5
    call z,0932h        ;430c cc 32 09
    pop af              ;430f f1
    call nz,sub_08e7h   ;4310 c4 e7 08
    jr l42dah           ;4313 18 c5
    in a,(15h)          ;4315 db 15
    and 7fh             ;4317 e6 7f
    out (15h),a         ;4319 d3 15
    ld a,(2af0h)        ;431b 3a f0 2a
    or a                ;431e b7
    jp z,l0376h         ;431f ca 76 03
    bit 2,a             ;4322 cb 57
    jr nz,l4355h        ;4324 20 2f
    in a,(15h)          ;4326 db 15
    and 0fbh            ;4328 e6 fb
    out (15h),a         ;432a d3 15
    ld a,(2ae7h)        ;432c 3a e7 2a
    or a                ;432f b7
l4330h:
    jp z,l0376h         ;4330 ca 76 03
    and 0fh             ;4333 e6 0f
    ld (2ae7h),a        ;4335 32 e7 2a
    cp 0fh              ;4338 fe 0f
    jp nz,l0941h        ;433a c2 41 09
l433dh:
    ld hl,(2af1h)       ;433d 2a f1 2a
    ld a,(hl)           ;4340 7e
    call 0510h          ;4341 cd 10 05
    jp c,l0376h         ;4344 da 76 03
    ld a,(hl)           ;4347 7e
    inc hl              ;4348 23
    cp 0dh              ;4349 fe 0d
    jr nz,l4350h        ;434b 20 03
    ld hl,2cf5h         ;434d 21 f5 2c
l4350h:
    ld (2af1h),hl       ;4350 22 f1 2a
    jr l433dh           ;4353 18 e8
l4355h:
    ld a,(2ae7h)        ;4355 3a e7 2a
    or a                ;4358 b7
    jp z,l0376h         ;4359 ca 76 03
    push af             ;435c f5
    and 0fh             ;435d e6 0f
    ld (2ae7h),a        ;435f 32 e7 2a
    cp 02h              ;4362 fe 02
    call nc,05d8h       ;4364 d4 d8 05
    pop af              ;4367 f1
    jp p,049bh          ;4368 f2 9b 04
    ld hl,2c75h         ;436b 21 75 2c
    ld b,7fh            ;436e 06 7f
l4370h:
    call 04c1h          ;4370 cd c1 04
    jp c,l0376h         ;4373 da 76 03
    bit 7,b             ;4376 cb 78
    jr nz,l437dh        ;4378 20 03
    ld (hl),a           ;437a 77
    inc hl              ;437b 23
    dec b               ;437c 05

l437dh:
    ld a,(l456fh)       ;437d 3a 6f 45
    or a                ;4380 b7
    jr z,l4370h         ;4381 28 ed
    ld (hl),0dh         ;4383 36 0d
    ld a,(2ae7h)        ;4385 3a e7 2a
    cp 0fh              ;4388 fe 0f
    jp nz,06bbh         ;438a c2 bb 06
    ld hl,2c75h         ;438d 21 75 2c
    ld de,2bf5h         ;4390 11 f5 2b
    ld bc,0080h         ;4393 01 80 00
    ldir                ;4396 ed b0
    jp l056ah           ;4398 c3 6a 05
    ld a,(2ae7h)        ;439b 3a e7 2a
    cp 0fh              ;439e fe 0f
    jp nz,0a48h         ;43a0 c2 48 0a
    ld hl,(2af3h)       ;43a3 2a f3 2a
l43a6h:
    call 04c1h          ;43a6 cd c1 04
    jp c,l0376h         ;43a9 da 76 03
    ld (hl),a           ;43ac 77
    ld a,l              ;43ad 7d
    cp 74h              ;43ae fe 74
    jr z,l43b6h         ;43b0 28 04
    inc hl              ;43b2 23
    ld (2af3h),hl       ;43b3 22 f3 2a
l43b6h:
    ld a,(l456fh)       ;43b6 3a 6f 45
    or a                ;43b9 b7
    jr z,l43a6h         ;43ba 28 ea
    ld (hl),0dh         ;43bc 36 0d
    jp l056ah           ;43be c3 6a 05
    in a,(14h)          ;43c1 db 14
    and 01h             ;43c3 e6 01
    jr nz,l4406h        ;43c5 20 3f
    in a,(15h)          ;43c7 db 15
    and 0f7h            ;43c9 e6 f7
    out (15h),a         ;43cb d3 15
l43cdh:
    in a,(14h)          ;43cd db 14
    and 01h             ;43cf e6 01
    jr nz,l4406h        ;43d1 20 33
    in a,(14h)          ;43d3 db 14
    and 02h             ;43d5 e6 02
    jr z,l43cdh         ;43d7 28 f4
    in a,(10h)          ;43d9 db 10
    push af             ;43db f5
    xor a               ;43dc af
    ld (l456fh),a       ;43dd 32 6f 45
    in a,(14h)          ;43e0 db 14
    and 10h             ;43e2 e6 10
    jr z,l43ebh         ;43e4 28 05
    ld a,01h            ;43e6 3e 01
    ld (l456fh),a       ;43e8 32 6f 45
l43ebh:
    in a,(15h)          ;43eb db 15
    or 08h              ;43ed f6 08
    out (15h),a         ;43ef d3 15
    in a,(15h)          ;43f1 db 15
    and 0fbh            ;43f3 e6 fb
    out (15h),a         ;43f5 d3 15
l43f7h:
    in a,(14h)          ;43f7 db 14
    and 02h             ;43f9 e6 02
    jr nz,l43f7h        ;43fb 20 fa
    in a,(15h)          ;43fd db 15
    or 04h              ;43ff f6 04
    out (15h),a         ;4401 d3 15
    pop af              ;4403 f1
l4404h:
    or a                ;4404 b7
    ret                 ;4405 c9
l4406h:
    scf                 ;4406 37
    ret                 ;4407 c9

wreoi:
    push af             ;4408 f5
    in a,(15h)          ;4409 db 15
    or 10h              ;440b f6 10
    out (15h),a         ;440d d3 15
    pop af              ;440f f1
l4410h:
    call l0518h+1       ;4410 cd 19 05
    ret c               ;4413 d8
    call 055ah          ;4414 cd 5a 05
    or a                ;4417 b7
    ret                 ;4418 c9

wrieee:
    push af             ;4419 f5
l441ah:
    in a,(14h)          ;441a db 14
    and 01h             ;441c e6 01
    jr nz,l4457h        ;441e 20 37
    in a,(14h)          ;4420 db 14
    and 08h             ;4422 e6 08
l4424h:
    jr nz,l441ah        ;4424 20 f4
    in a,(14h)          ;4426 db 14
    and 01h             ;4428 e6 01
    jr nz,l4457h        ;442a 20 2b
    in a,(14h)          ;442c db 14
    and 04h             ;442e e6 04
l4430h:
    jr z,l4457h         ;4430 28 25
    pop af              ;4432 f1
    out (11h),a         ;4433 d3 11
    in a,(15h)          ;4435 db 15
    or 02h              ;4437 f6 02
    out (15h),a         ;4439 d3 15
l443bh:
    in a,(14h)          ;443b db 14
    and 08h             ;443d e6 08
    jr nz,l4455h        ;443f 20 14
    in a,(14h)          ;4441 db 14
l4443h:
    and 04h             ;4443 e6 04
    jr nz,l443bh        ;4445 20 f4
    in a,(14h)          ;4447 db 14
    and 08h             ;4449 e6 08
    jr nz,l4455h        ;444b 20 08
    in a,(15h)          ;444d db 15
    and 0fdh            ;444f e6 fd
    out (15h),a         ;4451 d3 15
    scf                 ;4453 37
    ret                 ;4454 c9
l4455h:
    or a                ;4455 b7
    ret                 ;4456 c9
l4457h:
    pop af              ;4457 f1
    scf                 ;4458 37
    ret                 ;4459 c9
l445ah:
    in a,(14h)          ;445a db 14
    and 04h             ;445c e6 04
    jr nz,l445ah        ;445e 20 fa
    in a,(15h)          ;4460 db 15
    and 0edh            ;4462 e6 ed
    out (15h),a         ;4464 d3 15
    xor a               ;4466 af
    out (11h),a         ;4467 d3 11
    ret                 ;4469 c9
    call 05d8h          ;446a cd d8 05
    ld de,l0599h        ;446d 11 99 05
    ld hl,2bf5h         ;4470 21 f5 2b
    ld (2af3h),hl       ;4473 22 f3 2a
    ld b,12h            ;4476 06 12
    ld ix,l05abh        ;4478 dd 21 ab 05
l447ch:
    ld a,(de)           ;447c 1a
    cp (hl)             ;447d be
    jr z,cmd_found      ;447e 28 0c
    inc de              ;4480 13
    inc ix              ;4481 dd 23
    inc ix              ;4483 dd 23
    djnz l447ch         ;4485 10 f5
    ld a,1fh            ;4487 3e 1f
    jp 05cfh            ;4489 c3 cf 05

cmd_found:
    ld l,(ix+00h)       ;448c dd 6e 00
    ld h,(ix+01h)       ;448f dd 66 01
    call sub_0598h      ;4492 cd 98 05
    jp l0376h           ;4495 c3 76 03

do_cmd:
    jp (hl)             ;4498 e9

cmd_char:
    db "NSDIRGHW-VLT!PBUAC"

cmd_addr:
    dw 1002h            ;"N": New Drive Name
    dw 0bf5h            ;"S": Scratch Files
    dw 0f6bh            ;"D": Set Default Drive Number
    dw 0f7fh            ;"I": Initialize
    dw 0fa0h            ;"R": Rename File
    dw 0c48h            ;"H": Set Hide a File
    dw 0c48h            ;"W": Set Write Protect
    dw 0c48h            ;"-": Reset (Global | Hide a File | Write Protect)
    dw 0c48h            ;"V": Validate
    dw 0f80h            ;"L": Login
    dw 0eech            ;"T": Transfer Files
    dw 0ca9h            ;"!"
    dw 0ef1h            ;"P": Record Position
    dw 103fh            ;"B": Block commands
    dw 10d0h            ;"U": User commands
    dw 11fbh            ;"A": Absolute commands
    dw 12f1h            ;"C": Copy and Concat

    jp po,0cd0ch        ;44cd e2 0c cd
    in a,(05h)          ;44d0 db 05
    ld sp,4a93h         ;44d2 31 93 4a
    jp l0376h           ;44d5 c3 76 03
    call 064ch          ;44d8 cd 4c 06
    ld (2050h),a        ;44db 32 50 20
    ld hl,l1a81h        ;44de 21 81 1a

l44e1h:
    bit 7,(hl)          ;44e1 cb 7e
    jr nz,l44f0h        ;44e3 20 0b
    cp (hl)             ;44e5 be
    jr z,l44f0h         ;44e6 28 08
    inc hl              ;44e8 23
l44e9h:
    bit 7,(hl)          ;44e9 cb 7e
    inc hl              ;44eb 23
    jr z,l44e9h         ;44ec 28 fb
    jr l44e1h           ;44ee 18 f1
l44f0h:
    ex de,hl            ;44f0 eb
    inc de              ;44f1 13
    push de             ;44f2 d5
    ld hl,2cf5h         ;44f3 21 f5 2c
    ld de,0000h         ;44f6 11 00 00
    call sub_0660h      ;44f9 cd 60 06
    ld (hl),2ch         ;44fc 36 2c
    inc hl              ;44fe 23
    pop de              ;44ff d1
l4500h:
    ld a,(de)           ;4500 1a
    and 7fh             ;4501 e6 7f
    ld (hl),a           ;4503 77
    cp 20h              ;4504 fe 20
    jr nc,l4523h        ;4506 30 1b
    push de             ;4508 d5
    ld de,l1baah        ;4509 11 aa 1b
    ld b,a              ;450c 47
l450dh:
    dec b               ;450d 05
    jr z,l4517h         ;450e 28 07
l4510h:
    ld a,(de)           ;4510 1a
    inc de              ;4511 13
    rla                 ;4512 17
    jr nc,l4510h        ;4513 30 fb
    jr l450dh           ;4515 18 f6
l4517h:
    ld a,(de)           ;4517 1a
    and 7fh             ;4518 e6 7f
    ld (hl),a           ;451a 77
    ld a,(de)           ;451b 1a
    inc hl              ;451c 23
    inc de              ;451d 13
    rla                 ;451e 17
    jr nc,l4517h        ;451f 30 f6
    pop de              ;4521 d1
    dec hl              ;4522 2b
l4523h:
    ld a,(de)           ;4523 1a
    rla                 ;4524 17
    inc hl              ;4525 23
    inc de              ;4526 13
    jr nc,l4500h        ;4527 30 d7
    ld (hl),2ch         ;4529 36 2c
    inc hl              ;452b 23
    ld a,(2051h)        ;452c 3a 51 20
    ld de,(2052h)       ;452f ed 5b 52 20
    call sub_0660h      ;4533 cd 60 06
    ld (hl),2ch         ;4536 36 2c
    inc hl              ;4538 23
    ld a,(2054h)        ;4539 3a 54 20
    ld de,(2055h)       ;453c ed 5b 55 20
    call sub_0660h      ;4540 cd 60 06
    ld (hl),0dh         ;4543 36 0d
    ld hl,2cf5h         ;4545 21 f5 2c
    ld (2af1h),hl       ;4548 22 f1 2a
    ret                 ;454b c9

clrerrts:
    xor a               ;454c af
    ld (2051h),a        ;454d 32 51 20
    ld (2052h),a        ;4550 32 52 20
    ld (2053h),a        ;4553 32 53 20
    ld (2054h),a        ;4556 32 54 20
    ld (2055h),a        ;4559 32 55 20
    ld (2056h),a        ;455c 32 56 20
    ret                 ;455f c9

put_number:
    ld ix,06a9h         ;4560 dd 21 a9 06
    ld b,06h            ;4564 06 06
    ld iy,l460fh        ;4566 fd 21 0f 46
    res 0,(iy+00h)      ;456a fd cb 00 86
    push hl             ;456e e5
l456fh:
    ex de,hl            ;456f eb
l4570h:
    ld e,(ix+01h)       ;4570 dd 5e 01
    ld d,(ix+02h)       ;4573 dd 56 02
    ld c,2fh            ;4576 0e 2f
l4578h:
    inc c               ;4578 0c
    sub (ix+00h)        ;4579 dd 96 00
    sbc hl,de           ;457c ed 52
    jr nc,l4578h        ;457e 30 f8
    add a,(ix+00h)      ;4580 dd 86 00
    adc hl,de           ;4583 ed 5a
    ld e,a              ;4585 5f
    ld a,c              ;4586 79
    cp 30h              ;4587 fe 30
    jr nz,l4596h        ;4589 20 0b
    bit 0,(iy+00h)      ;458b fd cb 00 46
    jr nz,l4596h        ;458f 20 05
    ld a,b              ;4591 78
    cp 02h              ;4592 fe 02
    jr nz,l459eh        ;4594 20 08
l4596h:
    set 0,(iy+00h)      ;4596 fd cb 00 c6
    ex (sp),hl          ;459a e3
    ld (hl),c           ;459b 71
    inc hl              ;459c 23
    ex (sp),hl          ;459d e3
l459eh:
    ld a,e              ;459e 7b
    inc ix              ;459f dd 23
    inc ix              ;45a1 dd 23
    inc ix              ;45a3 dd 23
    djnz l4570h         ;45a5 10 c9
    pop hl              ;45a7 e1
    ret                 ;45a8 c9

    db 0a0h,86h,01h     ;100000
    db 10h,27h,00h      ;10000
    db 0e8h,03h,00h     ;1000
    db 64h,00h,00h      ;100
    db 0ah,00h,00h      ;10
    db 01h,00h,00h      ;1

do_open:
    call 05d8h          ;45bb cd d8 05
    call sub_1689h      ;45be cd 89 16
    bit 7,(iy+28h)      ;45c1 fd cb 28 7e
    call nz,sub_08e7h   ;45c5 c4 e7 08
    ld iy,(2ae8h)       ;45c8 fd 2a e8 2a
    ld (iy+28h),000h    ;45cc fd 36 28 00
    ld (iy+27h),000h    ;45d0 fd 36 27 00
    ld (iy+26h),0ffh    ;45d4 fd 36 26 ff
    ld hl,2c75h         ;45d8 21 75 2c

l45dbh:
    ld a,(hl)           ;45db 7e
    cp "$"              ;45dc fe 24
    jp z,l1365h         ;45de ca 65 13
    cp "#"              ;45e1 fe 23
    jp z,08d8h          ;45e3 ca d8 08
    cp "@"              ;45e6 fe 40
    jr nz,l45f1h        ;45e8 20 07
    set 5,(iy+28h)      ;45ea fd cb 28 ee
    inc hl              ;45ee 23
    jr l45dbh           ;45ef 18 ea
l45f1h:
    call 15e3h          ;45f1 cd e3 15
l45f4h:
    ld (iy+00h),000h    ;45f4 fd 36 00 00
    ld a,(2ae7h)        ;45f8 3a e7 2a
    cp 02h              ;45fb fe 02
    jr nc,l4607h        ;45fd 30 08
    ld (iy+00h),002h    ;45ff fd 36 00 02
    set 0,(iy+28h)      ;4603 fd cb 28 c6
l4607h:
    ld a,(hl)           ;4607 7e
l4608h:
    cp 0dh              ;4608 fe 0d
    jr z,l4663h         ;460a 28 57
l460ch:
    cp 2ch              ;460c fe 2c
    inc hl              ;460e 23
l460fh:
    jr nz,l4607h        ;460f 20 f6
    ld a,(hl)           ;4611 7e
    ld b,00h            ;4612 06 00
    cp "S"              ;4614 fe 53
    jr z,l4648h         ;4616 28 30
    ld b,01h            ;4618 06 01
    cp "U"              ;461a fe 55
    jr z,l4648h         ;461c 28 2a
    ld b,02h            ;461e 06 02
    cp "P"              ;4620 fe 50
    jr z,l4648h         ;4622 28 24
    cp "W"              ;4624 fe 57
    jr z,l465dh         ;4626 28 35
    cp "A"              ;4628 fe 41
    jr z,l4657h         ;462a 28 2b
    cp "R"              ;462c fe 52
    jr nz,l4637h        ;462e 20 07
l4630h:
    inc hl              ;4630 23
    ld a,(hl)           ;4631 7e
    cp "E"              ;4632 fe 45
    jr nz,l4607h        ;4634 20 d1
    inc hl              ;4636 23
l4637h:
    cp "L"              ;4637 fe 4c
    jr nz,l4607h        ;4639 20 cc
    ld b,03h            ;463b 06 03
    inc hl              ;463d 23
    ld a,(hl)           ;463e 7e
    cp ","              ;463f fe 2c
    jr nz,l4648h        ;4641 20 05
    inc hl              ;4643 23
    ld a,(hl)           ;4644 7e
    ld (iy+15h),a       ;4645 fd 77 15
l4648h:
    ld a,(iy+00h)       ;4648 fd 7e 00
    and 0fch            ;464b e6 fc
    or b                ;464d b0
    ld (iy+00h),a       ;464e fd 77 00

    set 0,(iy+28h)      ;4651 fd cb 28 c6
    jr l4607h           ;4655 18 b0

l4657h:
    set 4,(iy+28h)      ;4657 fd cb 28 e6
    jr l4607h           ;465b 18 aa

l465dh:
    set 3,(iy+28h)      ;465d fd cb 28 de
    jr l4607h           ;4661 18 a4

l4663h:
    ld a,(2ae7h)        ;4663 3a e7 2a
    cp 02h              ;4666 fe 02
    jr nc,l4675h        ;4668 30 0b
    res 3,(iy+28h)      ;466a fd cb 28 9e
    or a                ;466e b7
    jr z,l4675h         ;466f 28 04
    set 3,(iy+28h)      ;4671 fd cb 28 de
l4675h:
    bit 3,(iy+28h)      ;4675 fd cb 28 5e
    jp z,l0810h         ;4679 ca 10 08
    call sub_163bh      ;467c cd 3b 16
    ld a,21h            ;467f 3e 21
    jp c,05cfh          ;4681 da cf 05
    ld hl,2d45h         ;4684 21 45 2d
    ld a,(2d67h)        ;4687 3a 67 2d
    call l153ch+1       ;468a cd 3d 15
    ld iy,(2ae8h)       ;468d fd 2a e8 2a
    jr c,l46aah         ;4691 38 17
    bit 5,(iy+28h)      ;4693 fd cb 28 6e
    ld a,3fh            ;4697 3e 3f
    jp z,05cfh          ;4699 ca cf 05
    bit 6,(ix+00h)      ;469c dd cb 00 76
    ld a,1ah            ;46a0 3e 1a
    jp nz,05cfh         ;46a2 c2 cf 05
    call sub_16e3h      ;46a5 cd e3 16
    jr l46adh           ;46a8 18 03
l46aah:
    call 1586h          ;46aa cd 86 15
l46adh:
    push de             ;46ad d5
    push ix             ;46ae dd e5
l46b0h:
    ld a,(2d67h)        ;46b0 3a 67 2d
    ld (iy+01h),a       ;46b3 fd 77 01
    ld (iy+23h),e       ;46b6 fd 73 23
    ld (iy+24h),d       ;46b9 fd 72 24

    set 7,(iy+00h)      ;46bc fd cb 00 fe
    set 7,(iy+28h)      ;46c0 fd cb 28 fe
    ld b,03h            ;46c4 06 03
    ld a,(iy+15h)       ;46c6 fd 7e 15
    ld (iy+25h),a       ;46c9 fd 77 25
    or a                ;46cc b7
    jr nz,l46d7h        ;46cd 20 08
    ld (iy+15h),0feh    ;46cf fd 36 15 fe
    ld (iy+25h),0feh    ;46d3 fd 36 25 fe
l46d7h:
    ld (iy+12h),0ffh    ;46d7 fd 36 12 ff
    ld (iy+20h),000h    ;46db fd 36 20 00
    inc iy              ;46df fd 23
    djnz l46d7h         ;46e1 10 f4
    ld hl,(2aeeh)       ;46e3 2a ee 2a
    ld b,80h            ;46e6 06 80
l46e8h:
    ld (hl),0ffh        ;46e8 36 ff
    inc hl              ;46ea 23
    djnz l46e8h         ;46eb 10 fb
    call sub_18eeh      ;46ed cd ee 18
    ld hl,(2ae8h)       ;46f0 2a e8 2a
    ld de,0002h         ;46f3 11 02 00
    add hl,de           ;46f6 19
    ex de,hl            ;46f7 eb
    ld hl,2d45h         ;46f8 21 45 2d
    ld bc,0010h         ;46fb 01 10 00
    ldir                ;46fe ed b0
    ld hl,(2ae8h)       ;4700 2a e8 2a
    pop de              ;4703 d1
    ld bc,0020h         ;4704 01 20 00
    ldir                ;4707 ed b0
    pop de              ;4709 d1
    call sub_1789h      ;470a cd 89 17
    jp l0376h           ;470d c3 76 03
l4710h:
    ld hl,2d45h         ;4710 21 45 2d
    ld a,(2d67h)        ;4713 3a 67 2d
    call l153ch+1       ;4716 cd 3d 15
    ld iy,(2ae8h)       ;4719 fd 2a e8 2a
    jr nc,l472eh        ;471d 30 0f
    ld a,(iy+00h)       ;471f fd 7e 00
    and 03h             ;4722 e6 03
    cp 03h              ;4724 fe 03
    jp z,l077ch         ;4726 ca 7c 07
    ld a,3eh            ;4729 3e 3e
    jp 05cfh            ;472b c3 cf 05
l472eh:
    bit 0,(iy+28h)      ;472e fd cb 28 46
    jr z,l4752h         ;4732 28 1e
    ld a,(iy+00h)       ;4734 fd 7e 00
    xor (ix+00h)        ;4737 dd ae 00
    and 03h             ;473a e6 03
    jr z,l4752h         ;473c 28 14
    ld hl,2d45h         ;473e 21 45 2d
    ld a,(2d67h)        ;4741 3a 67 2d
    call 1544h          ;4744 cd 44 15
    ld iy,(2ae8h)       ;4747 fd 2a e8 2a
    jr nc,l472eh        ;474b 30 e1
    ld a,40h            ;474d 3e 40
    jp 05cfh            ;474f c3 cf 05
l4752h:
    call sub_18beh      ;4752 cd be 18
    ld (iy+23h),e       ;4755 fd 73 23
    ld (iy+24h),d       ;4758 fd 72 24
    ld (iy+20h),000h    ;475b fd 36 20 00
    ld (iy+21h),000h    ;475f fd 36 21 00
    ld (iy+22h),000h    ;4763 fd 36 22 00
    set 7,(iy+28h)      ;4767 fd cb 28 fe
    ld b,20h            ;476b 06 20
l476dh:
    ld a,(ix+00h)       ;476d dd 7e 00
    ld (iy+00h),a       ;4770 fd 77 00
    inc ix              ;4773 dd 23
    inc iy              ;4775 fd 23
    djnz l476dh         ;4777 10 f4
    ld iy,(2ae8h)       ;4779 fd 2a e8 2a
    ld a,(iy+15h)       ;477d fd 7e 15
    ld (iy+25h),a       ;4780 fd 77 25
    bit 4,(iy+28h)      ;4783 fd cb 28 66
    jr nz,l47b3h        ;4787 20 2a
    ld a,(iy+12h)       ;4789 fd 7e 12
    and (iy+13h)        ;478c fd a6 13
    and (iy+14h)        ;478f fd a6 14
    inc a               ;4792 3c
    jr nz,l47aah        ;4793 20 15
    ld a,(iy+00h)       ;4795 fd 7e 00
    and 03h             ;4798 e6 03
    cp 03h              ;479a fe 03
    jr z,l47b0h         ;479c 28 12
    xor a               ;479e af
    ld (iy+12h),a       ;479f fd 77 12
    ld (iy+13h),a       ;47a2 fd 77 13
    ld (iy+14h),a       ;47a5 fd 77 14
    jr l47b0h           ;47a8 18 06
l47aah:
    call 0bcah          ;47aa cd ca 0b
    call l17e0h         ;47ad cd e0 17
l47b0h:
    jp l0376h           ;47b0 c3 76 03
l47b3h:
    ld a,(iy+12h)       ;47b3 fd 7e 12
    add a,01h           ;47b6 c6 01
    ld (iy+20h),a       ;47b8 fd 77 20
    ld a,(iy+13h)       ;47bb fd 7e 13
    adc a,00h           ;47be ce 00
    ld (iy+21h),a       ;47c0 fd 77 21
    ld a,(iy+14h)       ;47c3 fd 7e 14
    adc a,00h           ;47c6 ce 00
    ld (iy+22h),a       ;47c8 fd 77 22
    call 0bcah          ;47cb cd ca 0b
    ld a,(2d6bh)        ;47ce 3a 6b 2d
    or a                ;47d1 b7
    call nz,l17e0h      ;47d2 c4 e0 17
    jp l0376h           ;47d5 c3 76 03
    set 7,(iy+28h)      ;47d8 fd cb 28 fe
    set 6,(iy+28h)      ;47dc fd cb 28 f6
    ld (iy+20h),000h    ;47e0 fd 36 20 00
    jp l0376h           ;47e4 c3 76 03
    call sub_1689h      ;47e7 cd 89 16
    bit 7,(iy+28h)      ;47ea fd cb 28 7e
    ret z               ;47ee c8
    res 7,(iy+28h)      ;47ef fd cb 28 be
    call 0bcah          ;47f3 cd ca 0b
    bit 7,(iy+27h)      ;47f6 fd cb 27 7e
    call nz,17ebh       ;47fa c4 eb 17
    bit 4,(iy+27h)      ;47fd fd cb 27 66
    jr nz,l4808h        ;4801 20 05
    bit 7,(iy+00h)      ;4803 fd cb 00 7e
    ret z               ;4807 c8
l4808h:
    ld e,(iy+23h)       ;4808 fd 5e 23
    ld d,(iy+24h)       ;480b fd 56 24
    push de             ;480e d5
    call sub_177eh      ;480f cd 7e 17
    res 7,(iy+00h)      ;4812 fd cb 00 be
    ld bc,0020h         ;4816 01 20 00
    ld a,e              ;4819 7b
    and 07h             ;481a e6 07
    add a,a             ;481c 87
    add a,a             ;481d 87
    add a,a             ;481e 87
    add a,a             ;481f 87
    add a,a             ;4820 87
    ld e,a              ;4821 5f
    ld d,00h            ;4822 16 00
    ld hl,2af5h         ;4824 21 f5 2a
    add hl,de           ;4827 19
    ex de,hl            ;4828 eb
    ld hl,(2ae8h)       ;4829 2a e8 2a
    ldir                ;482c ed b0
    pop de              ;482e d1
    jp sub_1789h        ;482f c3 89 17
    xor a               ;4832 af
l4833h:
    ld (2ae7h),a        ;4833 32 e7 2a
    push af             ;4836 f5
    call sub_08e7h      ;4837 cd e7 08
    pop af              ;483a f1
    inc a               ;483b 3c
    cp 0fh              ;483c fe 0f
    jr nz,l4833h        ;483e 20 f3
    ret                 ;4840 c9
    call sub_1689h      ;4841 cd 89 16
    bit 7,(iy+28h)      ;4844 fd cb 28 7e
    jp z,l0376h         ;4848 ca 76 03
    bit 6,(iy+28h)      ;484b fd cb 28 76
    jp nz,09e9h         ;484f c2 e9 09
    bit 4,(iy+28h)      ;4852 fd cb 28 66
    jp nz,l0376h        ;4856 c2 76 03
    bit 3,(iy+28h)      ;4859 fd cb 28 5e
    jp nz,l0376h        ;485d c2 76 03
    bit 2,(iy+28h)      ;4860 fd cb 28 56
    jp nz,l0a11h        ;4864 c2 11 0a
    call 0bcah          ;4867 cd ca 0b
    ld a,(iy+00h)       ;486a fd 7e 00
    and 03h             ;486d e6 03
    cp 03h              ;486f fe 03
    jr nz,l487bh        ;4871 20 08
    call sub_10afh+1    ;4873 cd b0 10
    ld a,32h            ;4876 3e 32
    jp nc,05cfh         ;4878 d2 cf 05
l487bh:
    ld a,(2d6bh)        ;487b 3a 6b 2d
    ld e,a              ;487e 5f
    ld d,00h            ;487f 16 00
    ld hl,(2aech)       ;4881 2a ec 2a
    add hl,de           ;4884 19
l4885h:
    ld a,(iy+00h)       ;4885 fd 7e 00
    and 03h             ;4888 e6 03
    cp 03h              ;488a fe 03
    jr nz,l489fh        ;488c 20 11
    dec (iy+25h)        ;488e fd 35 25
    jr nz,l489fh        ;4891 20 0c
    ld a,(iy+15h)       ;4893 fd 7e 15
    ld (iy+25h),a       ;4896 fd 77 25
    in a,(15h)          ;4899 db 15
    or 10h              ;489b f6 10
    out (15h),a         ;489d d3 15
l489fh:
    ld a,(iy+20h)       ;489f fd 7e 20
    cp (iy+12h)         ;48a2 fd be 12
    jr nz,l48b7h        ;48a5 20 10
    ld a,(iy+21h)       ;48a7 fd 7e 21
    cp (iy+13h)         ;48aa fd be 13
    jr nz,l48b7h        ;48ad 20 08
    ld a,(iy+22h)       ;48af fd 7e 22
    cp (iy+14h)         ;48b2 fd be 14
    jr z,l48dah         ;48b5 28 23
l48b7h:
    ld a,(hl)           ;48b7 7e
    call l0518h+1       ;48b8 cd 19 05
    jp c,09e3h          ;48bb da e3 09
    inc hl              ;48be 23
    inc (iy+20h)        ;48bf fd 34 20
    jr nz,l48d5h        ;48c2 20 11
    inc (iy+21h)        ;48c4 fd 34 21
    jr nz,l48cch        ;48c7 20 03
    inc (iy+22h)        ;48c9 fd 34 22
l48cch:
    call 0bcah          ;48cc cd ca 0b
    call l17e0h         ;48cf cd e0 17
    ld hl,(2aech)       ;48d2 2a ec 2a
l48d5h:
    call 055ah          ;48d5 cd 5a 05
    jr l4885h           ;48d8 18 ab
l48dah:
    ld a,(hl)           ;48da 7e
    call sub_0508h      ;48db cd 08 05
    jp c,l0376h         ;48de da 76 03
    jr l48dah           ;48e1 18 f7
    inc (iy+25h)        ;48e3 fd 34 25
    jp l0376h           ;48e6 c3 76 03
l48e9h:
    ld hl,(2aech)       ;48e9 2a ec 2a
    ld c,(iy+20h)       ;48ec fd 4e 20
    ld b,00h            ;48ef 06 00
    add hl,bc           ;48f1 09
    ld a,(iy+25h)       ;48f2 fd 7e 25
    cp c                ;48f5 b9
    jr z,l4904h         ;48f6 28 0c
    ld a,(hl)           ;48f8 7e
    call 0510h          ;48f9 cd 10 05
    jp c,l0376h         ;48fc da 76 03
    inc (iy+20h)        ;48ff fd 34 20
    jr l48e9h           ;4902 18 e5
l4904h:
    ld a,(hl)           ;4904 7e
    call sub_0508h      ;4905 cd 08 05
l4908h:
    jp c,l0376h         ;4908 da 76 03
    ld (iy+20h),000h    ;490b fd 36 20 00
    jr l48e9h           ;490f 18 d8
l4911h:
    ld hl,(45f0h)       ;4911 2a f0 45
    ld a,(l45f1h+1)     ;4914 3a f2 45
    cp l                ;4917 bd
    jr z,l493fh         ;4918 28 25
    ld a,(hl)           ;491a 7e
    call l0518h+1       ;491b cd 19 05
    jp c,l0376h         ;491e da 76 03
    inc hl              ;4921 23
    ld (45f0h),hl       ;4922 22 f0 45
    ld a,(l45f1h+1)     ;4925 3a f2 45
    cp l                ;4928 bd
    jr z,l4930h         ;4929 28 05
    call 055ah          ;492b cd 5a 05
    jr l4911h           ;492e 18 e1
l4930h:
    ld hl,(l45f4h)      ;4930 2a f4 45
    ld a,l              ;4933 7d
    or h                ;4934 b4
    push af             ;4935 f5
    call nz,sub_140fh   ;4936 c4 0f 14
    call 055ah          ;4939 cd 5a 05
    pop af              ;493c f1
    jr nz,l4911h        ;493d 20 d2
l493fh:
    xor a               ;493f af
    call sub_0508h      ;4940 cd 08 05
    jr nc,l493fh        ;4943 30 fa
    jp l0376h           ;4945 c3 76 03
    call sub_1689h      ;4948 cd 89 16
    bit 7,(iy+28h)      ;494b fd cb 28 7e
    jp z,l0376h         ;494f ca 76 03
    bit 6,(iy+28h)      ;4952 fd cb 28 76
    jp nz,l0bb5h        ;4956 c2 b5 0b
    ld a,(iy+00h)       ;4959 fd 7e 00
    and 03h             ;495c e6 03
    cp 03h              ;495e fe 03
    jr z,l49afh         ;4960 28 4d
    bit 3,(iy+28h)      ;4962 fd cb 28 5e
    jr nz,l496fh        ;4966 20 07
    bit 4,(iy+28h)      ;4968 fd cb 28 66
    jp z,l0376h         ;496c ca 76 03
l496fh:
    call 0bcah          ;496f cd ca 0b
    ld a,(2d6bh)        ;4972 3a 6b 2d
    ld e,a              ;4975 5f
    ld d,00h            ;4976 16 00
    ld hl,(2aech)       ;4978 2a ec 2a
    add hl,de           ;497b 19
l497ch:
    call 04c1h          ;497c cd c1 04
    jp c,l0376h         ;497f da 76 03
    ld (hl),a           ;4982 77
    set 7,(iy+27h)      ;4983 fd cb 27 fe
    set 4,(iy+27h)      ;4987 fd cb 27 e6
    inc hl              ;498b 23
    inc (iy+12h)        ;498c fd 34 12
    jr nz,l4999h        ;498f 20 08
    inc (iy+13h)        ;4991 fd 34 13
    jr nz,l4999h        ;4994 20 03
    inc (iy+14h)        ;4996 fd 34 14
l4999h:
    inc (iy+20h)        ;4999 fd 34 20
    jr nz,l497ch        ;499c 20 de
    inc (iy+21h)        ;499e fd 34 21
    jr nz,l49a6h        ;49a1 20 03
    inc (iy+22h)        ;49a3 fd 34 22
l49a6h:
    call 17ebh          ;49a6 cd eb 17
    res 7,(iy+27h)      ;49a9 fd cb 27 be
    jr l496fh           ;49ad 18 c0
l49afh:
    call 04c1h          ;49af cd c1 04
    jp c,l0376h         ;49b2 da 76 03
    push af             ;49b5 f5
    call 05d8h          ;49b6 cd d8 05
    call 0bcah          ;49b9 cd ca 0b
    call sub_10afh+1    ;49bc cd b0 10
    jp c,0b4bh          ;49bf da 4b 0b
    ld l,(iy+20h)       ;49c2 fd 6e 20
    ld h,(iy+21h)       ;49c5 fd 66 21
    ld a,(iy+22h)       ;49c8 fd 7e 22
    push af             ;49cb f5
    push hl             ;49cc e5
    ld a,(iy+12h)       ;49cd fd 7e 12
    add a,01h           ;49d0 c6 01
    ld (iy+20h),a       ;49d2 fd 77 20
    ld a,(iy+13h)       ;49d5 fd 7e 13
    adc a,00h           ;49d8 ce 00
    ld (iy+21h),a       ;49da fd 77 21
    ld a,(iy+14h)       ;49dd fd 7e 14
    adc a,00h           ;49e0 ce 00
    ld (iy+22h),a       ;49e2 fd 77 22
    call 0bcah          ;49e5 cd ca 0b
    call l17e0h         ;49e8 cd e0 17
    ld c,(iy+20h)       ;49eb fd 4e 20
    ld b,00h            ;49ee 06 00
    ld hl,(2aech)       ;49f0 2a ec 2a
    add hl,bc           ;49f3 09
l49f4h:
    pop de              ;49f4 d1
    pop bc              ;49f5 c1
    push bc             ;49f6 c5
    push de             ;49f7 d5
    ld a,(iy+20h)       ;49f8 fd 7e 20
    cp e                ;49fb bb
    ld a,(iy+21h)       ;49fc fd 7e 21
    sbc a,d             ;49ff 9a
    ld a,(iy+22h)       ;4a00 fd 7e 22
    sbc a,b             ;4a03 98
    jr nc,l4a2bh        ;4a04 30 25
    ld a,0ffh           ;4a06 3e ff
    ld b,(iy+15h)       ;4a08 fd 46 15
l4a0bh:
    ld (hl),a           ;4a0b 77
    inc hl              ;4a0c 23
    inc (iy+20h)        ;4a0d fd 34 20
l4a10h:
    jr nz,l4a25h        ;4a10 20 13
l4a12h:
    inc (iy+21h)        ;4a12 fd 34 21
    jr nz,l4a1ah        ;4a15 20 03
    inc (iy+22h)        ;4a17 fd 34 22
l4a1ah:
    push bc             ;4a1a c5
    call 17ebh          ;4a1b cd eb 17
    call 0bcah          ;4a1e cd ca 0b
    pop bc              ;4a21 c1
    ld hl,(2aech)      ;4a22 2a ec 2a
l4a25h:
    ld a,0dh            ;4a25 3e 0d
    djnz l4a0bh         ;4a27 10 e2
    jr l49f4h           ;4a29 18 c9
l4a2bh:
    pop hl              ;4a2b e1
    pop hl              ;4a2c e1
    ld a,(iy+15h)       ;4a2d fd 7e 15
    dec a               ;4a30 3d
    add a,(iy+20h)      ;4a31 fd 86 20
    ld (iy+12h),a       ;4a34 fd 77 12
    ld a,(iy+21h)       ;4a37 fd 7e 21
    adc a,00h           ;4a3a ce 00
    ld (iy+13h),a       ;4a3c fd 77 13
    ld a,(iy+22h)       ;4a3f fd 7e 22
    adc a,00h           ;4a42 ce 00
    ld (iy+14h),a       ;4a44 fd 77 14
    set 4,(iy+27h)      ;4a47 fd cb 27 e6
    call 0bcah          ;4a4b cd ca 0b
    ld bc,(2d6bh)       ;4a4e ed 4b 6b 2d
    ld b,00h            ;4a52 06 00
    ld hl,(2aech)       ;4a54 2a ec 2a
    add hl,bc           ;4a57 09
    pop af              ;4a58 f1
    jr l4a66h           ;4a59 18 0b
l4a5bh:
    call 04c1h          ;4a5b cd c1 04
    jr nc,l4a66h        ;4a5e 30 06
    call 17ebh          ;4a60 cd eb 17
    jp l0376h           ;4a63 c3 76 03
l4a66h:
    ld c,a              ;4a66 4f
    ld a,(iy+25h)       ;4a67 fd 7e 25
    or a                ;4a6a b7
    ld a,c              ;4a6b 79
    push af             ;4a6c f5
    push iy             ;4a6d fd e5
    ld a,33h            ;4a6f 3e 33
    call z,05dbh        ;4a71 cc db 05
    pop iy              ;4a74 fd e1
    pop af              ;4a76 f1
    call nz,sub_0b94h   ;4a77 c4 94 0b
    ld a,(l456fh)       ;4a7a 3a 6f 45
    or a                ;4a7d b7
    jr z,l4a5bh         ;4a7e 28 db
l4a80h:
    ld a,(iy+25h)       ;4a80 fd 7e 25
    or a                ;4a83 b7
    jr z,l4a8ch         ;4a84 28 06
    xor a               ;4a86 af
    call sub_0b94h      ;4a87 cd 94 0b
    jr l4a80h           ;4a8a 18 f4
l4a8ch:
    ld a,(iy+15h)       ;4a8c fd 7e 15
    ld (iy+25h),a       ;4a8f fd 77 25
    jr l4a5bh           ;4a92 18 c7
    ld (hl),a           ;4a94 77
    dec (iy+25h)        ;4a95 fd 35 25
    inc hl              ;4a98 23
    inc (iy+20h)        ;4a99 fd 34 20
    ret nz              ;4a9c c0
    inc (iy+21h)        ;4a9d fd 34 21
    jr nz,l4aa5h        ;4aa0 20 03
    inc (iy+22h)        ;4aa2 fd 34 22
l4aa5h:
    call 17ebh          ;4aa5 cd eb 17
    call 0bcah          ;4aa8 cd ca 0b
    call sub_10afh+1    ;4aab cd b0 10
    call c,l17e0h       ;4aae dc e0 17
    ld hl,(2aech)       ;4ab1 2a ec 2a
    ret                 ;4ab4 c9
l4ab5h:
    call 04c1h          ;4ab5 cd c1 04
    jp c,l0376h         ;4ab8 da 76 03
    ld hl,(2aech)       ;4abb 2a ec 2a
    ld c,(iy+20h)       ;4abe fd 4e 20
    inc (iy+20h)        ;4ac1 fd 34 20
    ld b,00h            ;4ac4 06 00
    add hl,bc           ;4ac6 09
    ld (hl),a           ;4ac7 77
    jr l4ab5h           ;4ac8 18 eb
    ld iy,(2ae8h)       ;4aca fd 2a e8 2a
    ld a,(iy+20h)       ;4ace fd 7e 20
    ld (2d6bh),a        ;4ad1 32 6b 2d
    ld l,(iy+21h)       ;4ad4 fd 6e 21
    ld h,(iy+22h)       ;4ad7 fd 66 22
    ld a,l              ;4ada 7d
    and 07h             ;4adb e6 07
    ld (2d6ch),a        ;4add 32 6c 2d
    ld b,03h            ;4ae0 06 03
    call sub_1a7ah      ;4ae2 cd 7a 1a
    ld a,l              ;4ae5 7d
    and 7fh             ;4ae6 e6 7f
    ld (2d6ah),a        ;4ae8 32 6a 2d
    ld b,07h            ;4aeb 06 07
    call sub_1a7ah      ;4aed cd 7a 1a
    ld a,l              ;4af0 7d
    ld (2d6dh),a        ;4af1 32 6d 2d
    ret                 ;4af4 c9
    call sub_1625h      ;4af5 cd 25 16
l4af8h:
    call 15e3h          ;4af8 cd e3 15
    push hl             ;4afb e5
    ld a,0fh            ;4afc 3e 0f
    ld (2ae7h),a        ;4afe 32 e7 2a
    call sub_1689h      ;4b01 cd 89 16
    ld a,(2d67h)        ;4b04 3a 67 2d
    ld c,a              ;4b07 4f
    ld hl,2d45h         ;4b08 21 45 2d
    call l153ch+1       ;4b0b cd 3d 15
    jr c,l4b38h         ;4b0e 38 28
l4b10h:
    bit 6,(ix+00h)      ;4b10 dd cb 00 76
    jr nz,l4b2ch        ;4b14 20 16
    bit 7,(ix+00h)      ;4b16 dd cb 00 7e
    jr nz,l4b2ch        ;4b1a 20 10
    ld hl,2051h         ;4b1c 21 51 20
    inc (hl)            ;4b1f 34
    ld (ix+01h),0ffh    ;4b20 dd 36 01 ff
    push de             ;4b24 d5
    call sub_16e3h      ;4b25 cd e3 16
    pop de              ;4b28 d1
    call sub_1789h      ;4b29 cd 89 17
l4b2ch:
    ld hl,2d45h         ;4b2c 21 45 2d
    ld a,(2d67h)        ;4b2f 3a 67 2d
    ld c,a              ;4b32 4f
    call 1544h          ;4b33 cd 44 15
    jr nc,l4b10h        ;4b36 30 d8
l4b38h:
    pop hl              ;4b38 e1
l4b39h:
    ld a,(hl)           ;4b39 7e
    inc hl              ;4b3a 23
    cp 2ch              ;4b3b fe 2c
    jr z,l4af8h         ;4b3d 28 b9
    cp 0dh              ;4b3f fe 0d
    jr nz,l4b39h        ;4b41 20 f6
    ld a,01h            ;4b43 3e 01
    jp 05dbh            ;4b45 c3 db 05
    call sub_1625h      ;4b48 cd 25 16
    call 15e3h          ;4b4b cd e3 15
    ld a,(2d67h)        ;4b4e 3a 67 2d
    ld hl,2d45h         ;4b51 21 45 2d
    call l153ch+1       ;4b54 cd 3d 15
l4b57h:
    ret c               ;4b57 d8
    ld hl,2bf5h         ;4b58 21 f5 2b
l4b5bh:
    ld a,(hl)           ;4b5b 7e
    inc hl              ;4b5c 23
    cp 0dh              ;4b5d fe 0d
    ret z               ;4b5f c8
    cp 2dh              ;4b60 fe 2d
    jr z,l4b82h         ;4b62 28 1e
    cp 48h              ;4b64 fe 48
    jr nz,l4b6eh        ;4b66 20 06
    set 5,(ix+00h)      ;4b68 dd cb 00 ee
    jr l4b9bh           ;4b6c 18 2d
l4b6eh:
    cp 57h              ;4b6e fe 57
    jr nz,l4b78h        ;4b70 20 06
    set 6,(ix+00h)      ;4b72 dd cb 00 f6
    jr l4b9bh           ;4b76 18 23
l4b78h:
    cp "G"              ;4b78 fe 47
    jr nz,l4b5bh        ;4b7a 20 df
    set 4,(ix+00h)      ;4b7c dd cb 00 e6
    jr l4b9bh           ;4b80 18 19
l4b82h:
    ld a,(hl)           ;4b82 7e
    cp "H"              ;4b83 fe 48
    jr nz,l4b8bh        ;4b85 20 04
    res 5,(ix+00h)      ;4b87 dd cb 00 ae
l4b8bh:
    cp "W"              ;4b8b fe 57
    jr nz,l4b93h        ;4b8d 20 04
    res 6,(ix+00h)      ;4b8f dd cb 00 b6
l4b93h:
    cp "G"              ;4b93 fe 47
    jr nz,l4b9bh        ;4b95 20 04
    res 4,(ix+00h)      ;4b97 dd cb 00 a6
l4b9bh:
    call sub_1789h      ;4b9b cd 89 17
    ld hl,2d45h         ;4b9e 21 45 2d
    ld a,(2d67h)        ;4ba1 3a 67 2d
    call 1544h          ;4ba4 cd 44 15
    jr l4b57h           ;4ba7 18 ae
    call sub_1625h      ;4ba9 cd 25 16
    call 15e3h          ;4bac cd e3 15
    ld a,(hl)           ;4baf 7e
    inc hl              ;4bb0 23
    cp ","              ;4bb1 fe 2c
    jr nz,l4bddh        ;4bb3 20 28
    ld a,(hl)           ;4bb5 7e
    sub "0"             ;4bb6 d6 30
    jr c,l4bddh         ;4bb8 38 23
    cp "9"+1-"0"        ;4bba fe 0a
    jr nc,l4bddh        ;4bbc 30 1f
    ld c,a              ;4bbe 4f
    push bc             ;4bbf c5
    ld a,(2d67h)        ;4bc0 3a 67 2d
    ld hl,2d45h         ;4bc3 21 45 2d
    call l153ch+1       ;4bc6 cd 3d 15
l4bc9h:
    pop bc              ;4bc9 c1
    ret c               ;4bca d8
    ld (ix+01h),c       ;4bcb dd 71 01
    push bc             ;4bce c5
    call sub_1789h      ;4bcf cd 89 17
    ld a,(2d67h)        ;4bd2 3a 67 2d
    ld hl,2d45h         ;4bd5 21 45 2d
    call 1544h          ;4bd8 cd 44 15
    jr l4bc9h           ;4bdb 18 ec
l4bddh:
    ld a,1eh            ;4bdd 3e 1e
    jp 05cfh            ;4bdf c3 cf 05

cmd_cpy:
    call sub_1625h      ;4be2 cd 25 16
    call 15e3h          ;4be5 cd e3 15
    push hl             ;4be8 e5
    ld a,0fh            ;4be9 3e 0f
    ld (2ae7h),a        ;4beb 32 e7 2a
    call sub_1689h      ;4bee cd 89 16
    ld a,(2d67h)        ;4bf1 3a 67 2d
    ld (iy+01h),a       ;4bf4 fd 77 01
    ld (iy+28h),000h    ;4bf7 fd 36 28 00
    ld (iy+27h),000h    ;4bfb fd 36 27 00
    ld (iy+26h),0ffh    ;4bff fd 36 26 ff
    ld hl,(2ae8h)       ;4c03 2a e8 2a
    ld de,0002h         ;4c06 11 02 00
    add hl,de           ;4c09 19
    ex de,hl            ;4c0a eb
    ld hl,2d45h         ;4c0b 21 45 2d
    ld bc,0010h         ;4c0e 01 10 00
    ldir                ;4c11 ed b0
    call sub_163bh      ;4c13 cd 3b 16
    ld a,21h            ;4c16 3e 21
    jp c,05cfh          ;4c18 da cf 05
    pop hl              ;4c1b e1
    ld a,(hl)           ;4c1c 7e
    cp "="              ;4c1d fe 3d
    ld a,1eh            ;4c1f 3e 1e
    jp nz,05cfh         ;4c21 c2 cf 05
    inc hl              ;4c24 23
    call 15e3h          ;4c25 cd e3 15
    push hl             ;4c28 e5
    ld a,(2d67h)        ;4c29 3a 67 2d
    cp (iy+01h)         ;4c2c fd be 01
    jr nz,l4c84h        ;4c2f 20 53
    ld b,10h            ;4c31 06 10
    ld hl,(2ae8h)       ;4c33 2a e8 2a
    ld de,0002h         ;4c36 11 02 00
    add hl,de           ;4c39 19
    ld de,2d45h         ;4c3a 11 45 2d
l4c3dh:
    ld a,(de)           ;4c3d 1a
    cp (hl)             ;4c3e be
    jr nz,l4c84h        ;4c3f 20 43
    inc hl              ;4c41 23
    inc de              ;4c42 13
    djnz l4c3dh         ;4c43 10 f8
    ld a,(2d67h)        ;4c45 3a 67 2d
    ld hl,2d45h         ;4c48 21 45 2d
    call l153ch+1       ;4c4b cd 3d 15
    ld a,3eh            ;4c4e 3e 3e
    jp c,05cfh          ;4c50 da cf 05
    ld iy,(2ae8h)       ;4c53 fd 2a e8 2a
    ld (iy+23h),e       ;4c57 fd 73 23
    ld (iy+24h),d       ;4c5a fd 72 24
    push ix             ;4c5d dd e5
    pop hl              ;4c5f e1
    ld de,(2ae8h)       ;4c60 ed 5b e8 2a
    ld bc,0020h         ;4c64 01 20 00
    ldir                ;4c67 ed b0
    ld a,(iy+12h)       ;4c69 fd 7e 12
    add a,01h           ;4c6c c6 01
    ld (iy+20h),a       ;4c6e fd 77 20
    ld a,(iy+13h)       ;4c71 fd 7e 13
    adc a,00h           ;4c74 ce 00
    ld (iy+21h),a       ;4c76 fd 77 21
    ld a,(iy+14h)       ;4c79 fd 7e 14
    adc a,00h           ;4c7c ce 00
    ld (iy+22h),a       ;4c7e fd 77 22
    jp l0ea5h           ;4c81 c3 a5 0e
l4c84h:
    ld hl,(2ae8h)       ;4c84 2a e8 2a
    ld de,0002h         ;4c87 11 02 00
    add hl,de           ;4c8a 19
    ld a,(iy+01h)       ;4c8b fd 7e 01
    call l153ch+1       ;4c8e cd 3d 15
    ld a,3fh            ;4c91 3e 3f
    jp nc,05cfh         ;4c93 d2 cf 05
    call 1586h          ;4c96 cd 86 15
    ld iy,(2ae8h)       ;4c99 fd 2a e8 2a
    ld (iy+23h),e       ;4c9d fd 73 23
    ld (iy+24h),d       ;4ca0 fd 72 24
    set 5,(iy+27h)      ;4ca3 fd cb 27 ee
    ld (iy+20h),000h    ;4ca7 fd 36 20 00
    ld (iy+21h),000h    ;4cab fd 36 21 00
    ld (iy+22h),000h    ;4caf fd 36 22 00
    ld hl,(2aeeh)       ;4cb3 2a ee 2a
    ld b,80h            ;4cb6 06 80
l4cb8h:
    ld (hl),0ffh        ;4cb8 36 ff
    inc hl              ;4cba 23
    djnz l4cb8h         ;4cbb 10 fb
    ld a,(2d67h)        ;4cbd 3a 67 2d
    ld hl,2d45h         ;4cc0 21 45 2d
    call l153ch+1       ;4cc3 cd 3d 15
    ld a,3eh            ;4cc6 3e 3e
    jp c,05cfh          ;4cc8 da cf 05
    ld iy,(2ae8h)       ;4ccb fd 2a e8 2a
    ld a,(ix+00h)       ;4ccf dd 7e 00
    ld (iy+00h),a       ;4cd2 fd 77 00
    ld a,(ix+15h)       ;4cd5 dd 7e 15
    ld (iy+15h),a       ;4cd8 fd 77 15
    ld (l460ch+1),de    ;4cdb ed 53 0d 46
    ld bc,0ffffh        ;4cdf 01 ff ff
    inc bc              ;4ce2 03
    push bc             ;4ce3 c5
    ld a,b              ;4ce4 78
    and 03h             ;4ce5 e6 03
    or c                ;4ce7 b1
    jr nz,l4d0dh        ;4ce8 20 23
    ld hl,4810h         ;4cea 21 10 48
    ld (2aeeh),hl       ;4ced 22 ee 2a
    ld (2aeah),hl       ;4cf0 22 ea 2a
    ld de,(l460ch+1)    ;4cf3 ed 5b 0d 46
    call sub_18beh      ;4cf7 cd be 18
    ld hl,4810h         ;4cfa 21 10 48
    pop bc              ;4cfd c1
    push bc             ;4cfe c5
    srl b               ;4cff cb 38
    ld e,b              ;4d01 58
    res 0,e             ;4d02 cb 83
    ld d,00h            ;4d04 16 00
    add hl,de           ;4d06 19
    ld e,(hl)           ;4d07 5e
    inc hl              ;4d08 23
    ld d,(hl)           ;4d09 56
    call l17b5h         ;4d0a cd b5 17
l4d0dh:
    pop de              ;4d0d d1
    push de             ;4d0e d5
    rr d                ;4d0f cb 1a
    rr e                ;4d11 cb 1b
    rr d                ;4d13 cb 1a
    rr e                ;4d15 cb 1b
    res 0,e             ;4d17 cb 83
    ld d,00h            ;4d19 16 00
    ld hl,4810h         ;4d1b 21 10 48
    add hl,de           ;4d1e 19
    ld e,(hl)           ;4d1f 5e
    inc hl              ;4d20 23
    ld d,(hl)           ;4d21 56
    ex de,hl            ;4d22 eb
    pop bc              ;4d23 c1
    push bc             ;4d24 c5
    ld a,c              ;4d25 79
    and 07h             ;4d26 e6 07
    ld e,a              ;4d28 5f
    xor a               ;4d29 af
    ld d,a              ;4d2a 57
    add hl,hl           ;4d2b 29
    adc a,a             ;4d2c 8f
    add hl,hl           ;4d2d 29
    adc a,a             ;4d2e 8f
    add hl,hl           ;4d2f 29
    adc a,a             ;4d30 8f
    add hl,de           ;4d31 19
    ld b,a              ;4d32 47
    ld de,(2031h)       ;4d33 ed 5b 31 20
    ld a,(2033h)        ;4d37 3a 33 20
    add hl,de           ;4d3a 19
    add a,b             ;4d3b 80
    ex de,hl            ;4d3c eb
    ld hl,2004h         ;4d3d 21 04 20
    ld b,(hl)           ;4d40 46
    ld hl,l4710h        ;4d41 21 10 47
    call sub_1982h      ;4d44 cd 82 19
    call sub_1689h      ;4d47 cd 89 16
    call 0bcah          ;4d4a cd ca 0b
    ld b,00h            ;4d4d 06 00
    pop de              ;4d4f d1
    push de             ;4d50 d5
    ld a,(ix+13h)       ;4d51 dd 7e 13
    cp e                ;4d54 bb
    jr nz,l4d61h        ;4d55 20 0a
    ld a,(ix+14h)       ;4d57 dd 7e 14
    cp d                ;4d5a ba
    jr nz,l4d61h        ;4d5b 20 04
    ld b,(ix+12h)       ;4d5d dd 46 12
    inc b               ;4d60 04
l4d61h:
    ld a,(2d6bh)        ;4d61 3a 6b 2d
    ld e,a              ;4d64 5f
    ld d,00h            ;4d65 16 00
    ld hl,(2aech)       ;4d67 2a ec 2a
    add hl,de           ;4d6a 19
    ld de,l4710h        ;4d6b 11 10 47
l4d6eh:
    ld a,(de)           ;4d6e 1a
    ld (hl),a           ;4d6f 77
    set 7,(iy+27h)      ;4d70 fd cb 27 fe
    inc hl              ;4d74 23
    inc de              ;4d75 13
    inc (iy+20h)        ;4d76 fd 34 20
    jr nz,l4d94h        ;4d79 20 19
    inc (iy+21h)        ;4d7b fd 34 21
    jr nz,l4d83h        ;4d7e 20 03
    inc (iy+22h)        ;4d80 fd 34 22
l4d83h:
    push bc             ;4d83 c5
    push de             ;4d84 d5
    call 17ebh          ;4d85 cd eb 17
    res 7,(iy+27h)      ;4d88 fd cb 27 be
    call 0bcah          ;4d8c cd ca 0b
    ld hl,(2aech)       ;4d8f 2a ec 2a
    pop de              ;4d92 d1
    pop bc              ;4d93 c1
l4d94h:
    djnz l4d6eh         ;4d94 10 d8
    pop bc              ;4d96 c1
    ld a,(ix+13h)       ;4d97 dd 7e 13
    cp c                ;4d9a b9
    jp nz,0de2h         ;4d9b c2 e2 0d
    ld a,(ix+14h)       ;4d9e dd 7e 14
    cp b                ;4da1 b8
    jp nz,0de2h         ;4da2 c2 e2 0d
    pop hl              ;4da5 e1
l4da6h:
    ld a,(hl)           ;4da6 7e
    inc hl              ;4da7 23
    cp 0dh              ;4da8 fe 0d
    jr z,l4dc5h         ;4daa 28 19
    cp 2ch              ;4dac fe 2c
    jr nz,l4da6h        ;4dae 20 f6
    call 15e3h          ;4db0 cd e3 15
    push hl             ;4db3 e5
    ld hl,2d45h         ;4db4 21 45 2d
    ld a,(2d67h)        ;4db7 3a 67 2d
    call l153ch+1       ;4dba cd 3d 15
    jp nc,l0ddbh        ;4dbd d2 db 0d
    ld a,3eh            ;4dc0 3e 3e
    jp 05cfh            ;4dc2 c3 cf 05
l4dc5h:
    ld iy,(2ae8h)       ;4dc5 fd 2a e8 2a
    ld a,(iy+20h)       ;4dc9 fd 7e 20
    sub 01h             ;4dcc d6 01
    ld (iy+12h),a       ;4dce fd 77 12
    ld a,(iy+21h)       ;4dd1 fd 7e 21
    sbc a,00h           ;4dd4 de 00
    ld (iy+13h),a       ;4dd6 fd 77 13
    ld a,(iy+22h)       ;4dd9 fd 7e 22
    sbc a,00h           ;4ddc de 00
    ld (iy+14h),a       ;4dde fd 77 14
    set 7,(iy+28h)      ;4de1 fd cb 28 fe
    set 7,(iy+00h)      ;4de5 fd cb 00 fe
    jp sub_08e7h        ;4de9 c3 e7 08
    ld a,1fh            ;4dec 3e 1f
    jp 05cfh            ;4dee c3 cf 05
    ld hl,2bf6h         ;4df1 21 f6 2b
    ld a,(hl)           ;4df4 7e
    inc hl              ;4df5 23
    ld ix,l0f19h        ;4df6 dd 21 19 0f
    ld b,04h            ;4dfa 06 04
l4dfch:
    cp (ix+00h)         ;4dfc dd be 00
    jr z,l4e0eh         ;4dff 28 0d
    inc ix              ;4e01 dd 23
    inc ix              ;4e03 dd 23
    inc ix              ;4e05 dd 23
    djnz l4dfch         ;4e07 10 f3
    ld a,1fh            ;4e09 3e 1f
    jp 05cfh            ;4e0b c3 cf 05
l4e0eh:
    ld e,(ix+01h)       ;4e0e dd 5e 01
    ld d,(ix+02h)       ;4e11 dd 56 02
    push de             ;4e14 d5
    pop iy              ;4e15 fd e1
    jp (iy)             ;4e17 fd e9
    ld b,h              ;4e19 44
    ld (hl),0fh         ;4e1a 36 0f
    ld c,b              ;4e1c 48
    ld c,a              ;4e1d 4f
    rrca                ;4e1e 0f
    ld c,(hl)           ;4e1f 4e
    ld b,h              ;4e20 44
    rrca                ;4e21 0f
    ld b,l              ;4e22 45
    ld e,(hl)           ;4e23 5e
    rrca                ;4e24 0f
    ld hl,2bf5h         ;4e25 21 f5 2b
l4e28h:
    ld a,(hl)           ;4e28 7e
    cp 0dh              ;4e29 fe 0d
    scf                 ;4e2b 37
    ret z               ;4e2c c8
    inc hl              ;4e2d 23
    cp 3dh              ;4e2e fe 3d
    ret z               ;4e30 c8
    cp 3ah              ;4e31 fe 3a
    ret z               ;4e33 c8
    jr l4e28h           ;4e34 18 f2
    call sub_164dh      ;4e36 cd 4d 16
    jr c,l4e3fh         ;4e39 38 04
    ld (2000h),a        ;4e3b 32 00 20
    ret                 ;4e3e c9
l4e3fh:
    ld a,1eh            ;4e3f 3e 1e
    jp 05cfh            ;4e41 c3 cf 05
    ld a,(2002h)        ;4e44 3a 02 20
    ld (2051h),a        ;4e47 32 51 20
    ld a,59h            ;4e4a 3e 59
    jp 05cfh            ;4e4c c3 cf 05
    ld a,02h            ;4e4f 3e 02
    ld (2051h),a        ;4e51 32 51 20
    ld a,04h            ;4e54 3e 04
    ld (2054h),a        ;4e56 32 54 20
    ld a,63h            ;4e59 3e 63
    jp 05cfh            ;4e5b c3 cf 05
    call sub_164dh      ;4e5e cd 4d 16
    and 0fh             ;4e61 e6 0f
    ld d,a              ;4e63 57
    ld e,00h            ;4e64 1e 00
    ld hl,5000h         ;4e66 21 00 50
    add hl,de           ;4e69 19
    jp (hl)             ;4e6a e9

cmd_drv:
;command to set default drive number "D"
;
;This disassembly: 4e6bh
;Real location:    0f6bh  OFFSET = 3F00h
;
    call sub_1625h      ;4e6b cd 25 16
    ld a,(hl)           ;4e6e 7e
    call l1680h+2       ;4e6f cd 82 16
    jr nc,l4e7ah        ;4e72 30 06
    sub 30h             ;4e74 d6 30
    ld (204fh),a        ;4e76 32 4f 20
    ret                 ;4e79 c9
l4e7ah:
    ld a,1eh            ;4e7a 3e 1e
    jp 05cfh            ;4e7c c3 cf 05

;command for init "I"
;
;This disassembly: 4e7fh
;Real location:    0f7fh  OFFSET = 3F00h
;
cmd_ini:
    ret                 ;4e7f c9

cmd_vfy:
;command for validate "V"
;
    ld hl,0000h         ;4e80 21 00 00
    ld (2d68h),hl       ;4e83 22 68 2d
l4e86h:
    call sub_15a6h      ;4e86 cd a6 15
    jr c,l4e9ah         ;4e89 38 0f
    bit 7,(ix+00h)      ;4e8b dd cb 00 7e
    jr z,l4e86h         ;4e8f 28 f5
    ld (ix+01h),0ffh    ;4e91 dd 36 01 ff
    call sub_1789h      ;4e95 cd 89 17
    jr l4e86h           ;4e98 18 ec
l4e9ah:
    ld a,(2002h)        ;4e9a 3a 02 20
    jp 020dh            ;4e9d c3 0d 02

cmd_ren:
;Command for rename "R"
;Format: "R0:DESTINATION=SOURCE"
;
;This disassembly: 4ea0h
;Real location:    0fa0h  OFFSET = 3F00h
;
    call sub_1625h      ;4ea0 cd 25 16
    call 15e3h          ;4ea3 cd e3 15
    ld a,(2d67h)        ;4ea6 3a 67 2d
    push af             ;4ea9 f5
    push hl             ;4eaa e5
    call sub_163bh      ;4eab cd 3b 16
    ld a,21h            ;4eae 3e 21
    jp c,05cfh          ;4eb0 da cf 05
    ld hl,2d45h         ;4eb3 21 45 2d
    ld de,2d56h         ;4eb6 11 56 2d
    ld bc,0010h         ;4eb9 01 10 00
    ldir                ;4ebc ed b0
    pop hl              ;4ebe e1
    ld a,(hl)           ;4ebf 7e
    cp 3dh              ;4ec0 fe 3d
    ld a,1eh            ;4ec2 3e 1e
    jp nz,05cfh         ;4ec4 c2 cf 05
    inc hl              ;4ec7 23
    call 15e3h          ;4ec8 cd e3 15
    call sub_163bh      ;4ecb cd 3b 16
    ld a,21h            ;4ece 3e 21
    jp c,05cfh          ;4ed0 da cf 05
    pop af              ;4ed3 f1
    push af             ;4ed4 f5
    ld hl,2d56h         ;4ed5 21 56 2d
    call l153ch+1       ;4ed8 cd 3d 15
    ld a,3fh            ;4edb 3e 3f
    jp nc,05cfh         ;4edd d2 cf 05
    pop af              ;4ee0 f1
    ld hl,2d45h         ;4ee1 21 45 2d
    call l153ch+1       ;4ee4 cd 3d 15
    ld a,3eh            ;4ee7 3e 3e
    jp c,05cfh          ;4ee9 da cf 05
    bit 7,(ix+00h)      ;4eec dd cb 00 7e
    ret nz              ;4ef0 c0
    ld hl,2d56h         ;4ef1 21 56 2d
    ld b,10h            ;4ef4 06 10
l4ef6h:
    ld a,(hl)           ;4ef6 7e
    ld (ix+02h),a       ;4ef7 dd 77 02
    inc hl              ;4efa 23
    inc ix              ;4efb dd 23
    djnz l4ef6h         ;4efd 10 f7
    jp sub_1789h        ;4eff c3 89 17

cmd_new:
;command for new drive name (header or format) "N"
;
;This disassembly: 4f02h
;Real location:    1002h  OFFSET = 3F00h
;
    call sub_1625h      ;4f02 cd 25 16
    call 15e3h          ;4f05 cd e3 15
    ld a,(hl)           ;4f08 7e
    cp 2ch              ;4f09 fe 2c
    ld a,1eh            ;4f0b 3e 1e
    jp nz,05cfh         ;4f0d c2 cf 05
    inc hl              ;4f10 23
    ex de,hl            ;4f11 eb
    ld hl,(2d67h)       ;4f12 2a 67 2d
    ld h,00h            ;4f15 26 00
    add hl,hl           ;4f17 29
    push hl             ;4f18 e5
    ld bc,l46b0h        ;4f19 01 b0 46
    add hl,bc           ;4f1c 09
    ex de,hl            ;4f1d eb
    ld bc,0002h         ;4f1e 01 02 00
    ldir                ;4f21 ed b0
    pop hl              ;4f23 e1
    add hl,hl           ;4f24 29
    add hl,hl           ;4f25 29
    add hl,hl           ;4f26 29
    ld bc,l460fh+1      ;4f27 01 10 46
    add hl,bc           ;4f2a 09
    ex de,hl            ;4f2b eb
    ld hl,2d45h         ;4f2c 21 45 2d
    ld bc,0010h         ;4f2f 01 10 00
l4f32h:
    ld a,(hl)           ;4f32 7e
sub_4f33h:
    or a                ;4f33 b7
    jr nz,l4f38h        ;4f34 20 02
    ld (hl),20h         ;4f36 36 20
l4f38h:
    ldi                 ;4f38 ed a0
    jp po,l193eh        ;4f3a e2 3e 19
    jr l4f32h           ;4f3d 18 f3
    ld a,(2bf6h)        ;4f3f 3a f6 2b
    and 0fh             ;4f42 e6 0f
    ld (2ae7h),a        ;4f44 32 e7 2a
    call sub_1689h      ;4f47 cd 89 16
    bit 7,(iy+28h)      ;4f4a fd cb 28 7e
    ret z               ;4f4e c8
    ld a,(iy+00h)       ;4f4f fd 7e 00
    and 03h             ;4f52 e6 03
    cp 03h              ;4f54 fe 03
    ret nz              ;4f56 c0
    call 0bcah          ;4f57 cd ca 0b
    ld a,(2bf9h)        ;4f5a 3a f9 2b
    dec a               ;4f5d 3d
    cp (iy+15h)         ;4f5e fd be 15
    jr c,l4f6ah         ;4f61 38 07
    ld a,(iy+15h)       ;4f63 fd 7e 15
    dec a               ;4f66 3d
    ld (2bf9h),a        ;4f67 32 f9 2b
l4f6ah:
    ld c,(iy+15h)       ;4f6a fd 4e 15
    ld de,(2bf7h)       ;4f6d ed 5b f7 2b
    ld a,d              ;4f71 7a
    or e                ;4f72 b3
    jr z,l4f76h         ;4f73 28 01
    dec de              ;4f75 1b
l4f76h:
    ld hl,0000h         ;4f76 21 00 00
    xor a               ;4f79 af
    ld b,08h            ;4f7a 06 08
l4f7ch:
    add hl,hl           ;4f7c 29
    adc a,a             ;4f7d 8f
    rl c                ;4f7e cb 11
    jr nc,l4f85h        ;4f80 30 03
    add hl,de           ;4f82 19
    adc a,00h           ;4f83 ce 00
l4f85h:
    djnz l4f7ch         ;4f85 10 f5
    ld de,(2bf9h)       ;4f87 ed 5b f9 2b
    ld d,00h            ;4f8b 16 00
    dec de              ;4f8d 1b
    add hl,de           ;4f8e 19
    adc a,00h           ;4f8f ce 00
    ld (iy+20h),l       ;4f91 fd 75 20
    ld l,a              ;4f94 6f
    ld a,(iy+15h)       ;4f95 fd 7e 15
    sub e               ;4f98 93
    ld (iy+25h),a       ;4f99 fd 77 25
    ld (iy+21h),h       ;4f9c fd 74 21
    ld (iy+22h),l       ;4f9f fd 75 22
    call 0bcah          ;4fa2 cd ca 0b
    call sub_10afh+1    ;4fa5 cd b0 10
    jp c,l17e0h         ;4fa8 da e0 17
    ld a,32h            ;4fab 3e 32
    jp 05cfh            ;4fad c3 cf 05
    push bc             ;4fb0 c5
    push hl             ;4fb1 e5
    ld l,(iy+12h)       ;4fb2 fd 6e 12
    ld h,(iy+13h)       ;4fb5 fd 66 13
    ld b,(iy+14h)       ;4fb8 fd 46 14
    inc hl              ;4fbb 23
    ld a,h              ;4fbc 7c
    or l                ;4fbd b5
    jr nz,l4fc1h        ;4fbe 20 01
    inc b               ;4fc0 04
l4fc1h:
    ld a,(iy+20h)       ;4fc1 fd 7e 20
    cp l                ;4fc4 bd
    ld a,(iy+21h)       ;4fc5 fd 7e 21
    sbc a,h             ;4fc8 9c
    ld a,(iy+22h)       ;4fc9 fd 7e 22
    sbc a,b             ;4fcc 98
    pop hl              ;4fcd e1
    pop bc              ;4fce c1
    ret                 ;4fcf c9
    ld hl,2bf5h         ;4fd0 21 f5 2b
l4fd3h:
    ld a,(hl)           ;4fd3 7e
    inc hl              ;4fd4 23
    cp 0dh              ;4fd5 fe 0d
    jr z,l5006h         ;4fd7 28 2d
    cp 2dh              ;4fd9 fe 2d
    jr nz,l4fd3h        ;4fdb 20 f6
    ld a,(hl)           ;4fdd 7e
    inc hl              ;4fde 23
    cp 0dh              ;4fdf fe 0d
    jr z,l5006h         ;4fe1 28 23
    cp 41h              ;4fe3 fe 41
    jp c,10ddh          ;4fe5 da dd 10
    cp 5bh              ;4fe8 fe 5b
    jp nc,10ddh         ;4fea d2 dd 10
    cp 57h              ;4fed fe 57
    jp z,110bh          ;4fef ca 0b 11
    cp 52h              ;4ff2 fe 52
    jp z,l111dh         ;4ff4 ca 1d 11
    cp 41h              ;4ff7 fe 41
    jp z,1142h          ;4ff9 ca 42 11
    cp 46h              ;4ffc fe 46
    jp z,l113bh         ;4ffe ca 3b 11
    cp 50h              ;5001 fe 50
    jp z,112fh          ;5003 ca 2f 11
l5006h:
    ld a,1eh            ;5006 3e 1e
    jp 05cfh            ;5008 c3 cf 05
    call sub_1226h      ;500b cd 26 12
    push af             ;500e f5
    push hl             ;500f e5
    ld a,(iy+20h)       ;5010 fd 7e 20
    dec a               ;5013 3d
    ld hl,(2aech)       ;5014 2a ec 2a
    ld (hl),a           ;5017 77
    pop hl              ;5018 e1
    pop af              ;5019 f1
    jp l19b3h           ;501a c3 b3 19
    call sub_1226h      ;501d cd 26 12
    call sub_1982h      ;5020 cd 82 19
    ld hl,(2aech)       ;5023 2a ec 2a
    ld a,(hl)           ;5026 7e
    ld (iy+25h),a       ;5027 fd 77 25
    ld (iy+20h),001h    ;502a fd 36 20 01
    ret                 ;502e c9
    call sub_12d5h      ;502f cd d5 12
    jr c,l5006h         ;5032 38 d2
    call sub_164dh      ;5034 cd 4d 16
    ld (iy+20h),a       ;5037 fd 77 20
    ret                 ;503a c9
    call sub_11cfh      ;503b cd cf 11
    and 7fh             ;503e e6 7f
    jr l5049h           ;5040 18 07
    call sub_11cfh      ;5042 cd cf 11
    jr c,l5053h         ;5045 38 0c
    or 80h              ;5047 f6 80
l5049h:
    rrca                ;5049 0f
    djnz l5049h         ;504a 10 fd
    ld (hl),a           ;504c 77
    call sub_1955h      ;504d cd 55 19
    jp 05d8h            ;5050 c3 d8 05
l5053h:
    inc b               ;5053 04
l5054h:
    push af             ;5054 f5
    ld ix,2054h         ;5055 dd 21 54 20
    inc (ix+00h)        ;5059 dd 34 00
sub_505ch:
    jr nz,l5066h        ;505c 20 08
    inc (ix+01h)        ;505e dd 34 01
    jr nz,l5066h        ;5061 20 03
    inc (ix+02h)        ;5063 dd 34 02
l5066h:
    ld a,(2011h)        ;5066 3a 11 20
    cp (ix+00h)         ;5069 dd be 00
    jr nz,l50b1h        ;506c 20 43
    ld a,(2012h)        ;506e 3a 12 20
    cp (ix+01h)         ;5071 dd be 01
    jr nz,l50b1h        ;5074 20 3b
    ld a,(2013h)        ;5076 3a 13 20
    cp (ix+02h)         ;5079 dd be 02
    jr nz,l50b1h        ;507c 20 33
    ld (ix+00h),000h    ;507e dd 36 00 00
    ld (ix+01h),000h    ;5082 dd 36 01 00
    ld (ix+02h),000h    ;5086 dd 36 02 00
    ld ix,2051h         ;508a dd 21 51 20
    inc (ix+00h)        ;508e dd 34 00
    jr nz,l5096h        ;5091 20 03
    inc (ix+01h)        ;5093 dd 34 01
l5096h:
    ld a,(200fh)        ;5096 3a 0f 20
    sub (ix+00h)        ;5099 dd 96 00
    ld a,(2010h)        ;509c 3a 10 20
    sbc a,(ix+01h)      ;509f dd 9e 01
    jr nc,l50b1h        ;50a2 30 0d
    ld (ix+00h),000h    ;50a4 dd 36 00 00
    ld (ix+01h),000h    ;50a8 dd 36 01 00
    ld a,41h            ;50ac 3e 41
    jp 05cfh            ;50ae c3 cf 05
l50b1h:
    pop af              ;50b1 f1
    djnz l50c7h         ;50b2 10 13
    inc hl              ;50b4 23
    ld a,l              ;50b5 7d
    cp 10h              ;50b6 fe 10
    jr nz,l50c4h        ;50b8 20 0a
    ld hl,204eh         ;50ba 21 4e 20
    inc (hl)            ;50bd 34
    call 194fh          ;50be cd 4f 19
    ld hl,4910h         ;50c1 21 10 49
l50c4h:
    ld a,(hl)           ;50c4 7e
    ld b,08h            ;50c5 06 08
l50c7h:
    rrca                ;50c7 0f
    jr c,l5054h         ;50c8 38 8a
    ld a,41h            ;50ca 3e 41
    jp 05cfh            ;50cc c3 cf 05
    call sub_1245h      ;50cf cd 45 12
    ld a,b              ;50d2 78
    ld b,03h            ;50d3 06 03
    push de             ;50d5 d5
l50d6h:
    rra                 ;50d6 1f
    rr d                ;50d7 cb 1a
    rr e                ;50d9 cb 1b
    djnz l50d6h         ;50db 10 f9
    push de             ;50dd d5
    ld a,d              ;50de 7a
    ld (204eh),a        ;50df 32 4e 20
    call 194fh          ;50e2 cd 4f 19
    pop de              ;50e5 d1
    ld d,00h            ;50e6 16 00
    ld hl,4910h         ;50e8 21 10 49
    add hl,de           ;50eb 19
    pop bc              ;50ec c1
    ld a,c              ;50ed 79
    and 07h             ;50ee e6 07
    ld c,a              ;50f0 4f
    xor 07h             ;50f1 ee 07
    ld b,a              ;50f3 47
    ld a,(hl)           ;50f4 7e
    rrca                ;50f5 0f
    dec c               ;50f6 0d
    jp p,11f5h          ;50f7 f2 f5 11
    ret                 ;50fa c9
    ld hl,2bf6h         ;50fb 21 f6 2b
    ld a,(hl)           ;50fe 7e
    inc hl              ;50ff 23
    and 0fh             ;5100 e6 0f
    cp 01h              ;5102 fe 01
    jr z,l5112h         ;5104 28 0c
    cp 02h              ;5106 fe 02
    jr z,l5120h         ;5108 28 16
    cp 0ah              ;510a fe 0a
    jp z,0200h          ;510c ca 00 02
    jp l1106h           ;510f c3 06 11
l5112h:
    call sub_1226h      ;5112 cd 26 12
    ld (iy+25h),0ffh    ;5115 fd 36 25 ff
    ld (iy+20h),000h    ;5119 fd 36 20 00
    jp sub_1982h        ;511d c3 82 19
l5120h:
    call sub_1226h      ;5120 cd 26 12
    jp l19b3h           ;5123 c3 b3 19
    call sub_12d5h      ;5126 cd d5 12
    ld a,1eh            ;5129 3e 1e
    jp c,05cfh          ;512b da cf 05
    call sub_1245h      ;512e cd 45 12
    call 064ch          ;5131 cd 4c 06
    ld hl,(2036h)       ;5134 2a 36 20
    ld a,(2038h)        ;5137 3a 38 20
    add hl,de           ;513a 19
    adc a,b             ;513b 88
    ex de,hl            ;513c eb
    ld hl,2004h         ;513d 21 04 20
    ld b,(hl)           ;5140 46
    ld hl,(2aech)       ;5141 2a ec 2a
    ret                 ;5144 c9
    call sub_164dh      ;5145 cd 4d 16
    jp c,12d0h          ;5148 da d0 12
    ld de,(200fh)       ;514b ed 5b 0f 20
    push hl             ;514f e5
    ld hl,0000h         ;5150 21 00 00
    ld b,08h            ;5153 06 08
    add hl,hl           ;5155 29
l5156h:
    rla                 ;5156 17
    jr nc,l515ah        ;5157 30 01
    add hl,de           ;5159 19
l515ah:
    djnz l5156h         ;515a 10 fa
    ex (sp),hl          ;515c e3
    call sub_164dh      ;515d cd 4d 16
    jr c,l51d0h         ;5160 38 6e
    inc d               ;5162 14
    dec d               ;5163 15
    jr nz,l51cbh        ;5164 20 65
    ld d,e              ;5166 53
    ld e,a              ;5167 5f
    ld (2051h),de       ;5168 ed 53 51 20
    dec de              ;516c 1b
    ld bc,(200fh)       ;516d ed 4b 0f 20
    ld a,e              ;5171 7b
    sub c               ;5172 91
    ld a,d              ;5173 7a
    sbc a,b             ;5174 98
    jr nc,l51cbh        ;5175 30 54
    ex (sp),hl          ;5177 e3
    add hl,de           ;5178 19
    ex de,hl            ;5179 eb
    ld ix,(2011h)       ;517a dd 2a 11 20
    ld bc,(2013h)       ;517e ed 4b 13 20
    ld b,18h            ;5182 06 18
    xor a               ;5184 af
    ld hl,0000h         ;5185 21 00 00
l5188h:
    add hl,hl           ;5188 29
    adc a,a             ;5189 8f
    add ix,ix           ;518a dd 29
    rl c                ;518c cb 11
    jr nc,l5193h        ;518e 30 03
    add hl,de           ;5190 19
    adc a,00h           ;5191 ce 00
l5193h:
    djnz l5188h         ;5193 10 f3
    ex (sp),hl          ;5195 e3
    push af             ;5196 f5
    call sub_164dh      ;5197 cd 4d 16
    jr c,l51d0h         ;519a 38 34
    ld (2054h),a        ;519c 32 54 20
    ld (2055h),de       ;519f ed 53 55 20
    ld b,a              ;51a3 47
    ld hl,2011h         ;51a4 21 11 20
    cp (hl)             ;51a7 be
    inc hl              ;51a8 23
    ld a,e              ;51a9 7b
    sbc a,(hl)          ;51aa 9e
    inc hl              ;51ab 23
    ld a,d              ;51ac 7a
    sbc a,(hl)          ;51ad 9e
    jr nc,l51cbh        ;51ae 30 1b
    ld a,d              ;51b0 7a
    ld d,e              ;51b1 53
    ld e,b              ;51b2 58
    pop bc              ;51b3 c1
    pop hl              ;51b4 e1
    add hl,de           ;51b5 19
    adc a,b             ;51b6 88
    ex de,hl            ;51b7 eb
    ld b,a              ;51b8 47
    ld hl,(200dh)       ;51b9 2a 0d 20
    ld c,00h            ;51bc 0e 00
    add hl,hl           ;51be 29
    rl c                ;51bf cb 11
    add hl,hl           ;51c1 29
    rl c                ;51c2 cb 11
    ld a,e              ;51c4 7b
    sub l               ;51c5 95
    ld a,d              ;51c6 7a
    sbc a,h             ;51c7 9c
    ld a,b              ;51c8 78
    sbc a,c             ;51c9 99
    ret c               ;51ca d8
l51cbh:
    ld a,42h            ;51cb 3e 42
    jp 05cfh            ;51cd c3 cf 05
l51d0h:
    ld a,1eh            ;51d0 3e 1e
    jp 05cfh            ;51d2 c3 cf 05
    call sub_164dh      ;51d5 cd 4d 16
    ret c               ;51d8 d8
    push af             ;51d9 f5
    and 0f0h            ;51da e6 f0
    or e                ;51dc b3
    or d                ;51dd b2
    scf                 ;51de 37
    ret nz              ;51df c0
    pop af              ;51e0 f1
    ld (2ae7h),a        ;51e1 32 e7 2a
    push hl             ;51e4 e5
    call sub_1689h      ;51e5 cd 89 16
    pop hl              ;51e8 e1
    bit 6,(iy+28h)      ;51e9 fd cb 28 76
    scf                 ;51ed 37
    ret z               ;51ee c8
    or a                ;51ef b7
    ret                 ;51f0 c9
    ld hl,2bf5h         ;51f1 21 f5 2b
l51f4h:
    ld a,(hl)           ;51f4 7e
    inc hl              ;51f5 23
    cp 0dh              ;51f6 fe 0d
    jr z,l5218h         ;51f8 28 1e
    cp 2dh              ;51fa fe 2d
    jr nz,l51f4h        ;51fc 20 f6
    ld a,(hl)           ;51fe 7e
    inc hl              ;51ff 23
    cp 0dh              ;5200 fe 0d
    jr z,l5218h         ;5202 28 14
    cp 41h              ;5204 fe 41
    jp c,l12feh         ;5206 da fe 12
    cp 5bh              ;5209 fe 5b
    jp nc,l12feh        ;520b d2 fe 12
    cp 57h              ;520e fe 57
    jp z,131dh          ;5210 ca 1d 13
    cp 52h              ;5213 fe 52
    jp z,132ch          ;5215 ca 2c 13
l5218h:
    ld a,1eh            ;5218 3e 1e
    jp 05cfh            ;521a c3 cf 05
    ld a,(2002h)        ;521d 3a 02 20
    or a                ;5220 b7
    ld a,5ch            ;5221 3e 5c
    jp nz,05cfh         ;5223 c2 cf 05
    call sub_134dh      ;5226 cd 4d 13
    jp l19b3h           ;5229 c3 b3 19
    call sub_134dh      ;522c cd 4d 13
    ld (iy+20h),000h    ;522f fd 36 20 00
    ld (iy+25h),0ffh    ;5233 fd 36 25 ff
    push af             ;5237 f5
    or d                ;5238 b2
    jr nz,l5240h        ;5239 20 05
    ld a,e              ;523b 7b
    cp 0ch              ;523c fe 0c
    jr c,l5249h         ;523e 38 09
l5240h:
    ld a,(2002h)        ;5240 3a 02 20
    or a                ;5243 b7
    ld a,5ch            ;5244 3e 5c
    jp nz,05cfh         ;5246 c2 cf 05
l5249h:
    pop af              ;5249 f1
    jp sub_1982h        ;524a c3 82 19
    call sub_12d5h      ;524d cd d5 12
    ld a,1eh            ;5250 3e 1e
    jp c,05cfh          ;5252 da cf 05
    call sub_164dh      ;5255 cd 4d 16
    push af             ;5258 f5
    call sub_164dh      ;5259 cd 4d 16
    push de             ;525c d5
    ld d,e              ;525d 53
    ld e,a              ;525e 5f
    pop af              ;525f f1
    pop bc              ;5260 c1
    ld hl,(2aech)       ;5261 2a ec 2a
    ret                 ;5264 c9
    set 2,(iy+28h)      ;5265 fd cb 28 d6
    set 7,(iy+28h)      ;5269 fd cb 28 fe
    ld hl,2c76h         ;526d 21 76 2c
    call 15e3h          ;5270 cd e3 15
l5273h:
    ld a,(hl)           ;5273 7e
    inc hl              ;5274 23
    cp 48h              ;5275 fe 48
    jr z,l527dh         ;5277 28 04
    cp 0dh              ;5279 fe 0d
    jr nz,l5273h        ;527b 20 f6
l527dh:
    ld (2d6eh),a        ;527d 32 6e 2d
    ld hl,2d45h         ;5280 21 45 2d
    ld de,l45f4h+3      ;5283 11 f7 45
    ld bc,0010h         ;5286 01 10 00
    ldir                ;5289 ed b0
    ld a,(2d67h)        ;528b 3a 67 2d
    ld (l45f4h+2),a     ;528e 32 f6 45
    ld e,a              ;5291 5f
    ld d,00h            ;5292 16 00
    ld hl,l4570h        ;5294 21 70 45
    ld (45f0h),hl       ;5297 22 f0 45
    ld (hl),01h         ;529a 36 01
    inc hl              ;529c 23
    ld (hl),04h         ;529d 36 04
    inc hl              ;529f 23
    inc hl              ;52a0 23
    inc hl              ;52a1 23
    ld (hl),e           ;52a2 73
    inc hl              ;52a3 23
    ld (hl),00h         ;52a4 36 00
    inc hl              ;52a6 23
    ld (hl),12h         ;52a7 36 12
    inc hl              ;52a9 23
    ld (hl),22h         ;52aa 36 22
    inc hl              ;52ac 23
    push de             ;52ad d5
    ex de,hl            ;52ae eb
    add hl,hl           ;52af 29
    add hl,hl           ;52b0 29
    add hl,hl           ;52b1 29
    add hl,hl           ;52b2 29
    ld bc,l460fh+1      ;52b3 01 10 46
    add hl,bc           ;52b6 09
    ld bc,0010h         ;52b7 01 10 00
    ldir                ;52ba ed b0
    ex de,hl            ;52bc eb
    ld (hl),22h         ;52bd 36 22
    inc hl              ;52bf 23
    ld (hl),20h         ;52c0 36 20
    inc hl              ;52c2 23
    ex de,hl            ;52c3 eb
    ld hl,l46b0h        ;52c4 21 b0 46
    pop bc              ;52c7 c1
    add hl,bc           ;52c8 09
    add hl,bc           ;52c9 09
    ld bc,0002h         ;52ca 01 02 00
    ldir                ;52cd ed b0
    ld hl,152eh         ;52cf 21 2e 15
    ld bc,0001h         ;52d2 01 01 00
    ldir                ;52d5 ed b0
    ex de,hl            ;52d7 eb
    ld a,(2002h)        ;52d8 3a 02 20
    push de             ;52db d5
    ld de,0000h         ;52dc 11 00 00
    call sub_0660h      ;52df cd 60 06
    pop de              ;52e2 d1
    ld (hl),00h         ;52e3 36 00
    inc hl              ;52e5 23
    ld (l45f1h+1),hl    ;52e6 22 f2 45
    ld de,0401h         ;52e9 11 01 04
    add hl,de           ;52ec 19
    ld de,l4570h+2      ;52ed 11 72 45
    or a                ;52f0 b7
    sbc hl,de           ;52f1 ed 52
    ld (l4570h+2),hl    ;52f3 22 72 45
    ld (l45f4h),hl      ;52f6 22 f4 45
    ld hl,0000h         ;52f9 21 00 00
    ld (2d68h),hl       ;52fc 22 68 2d
    ld hl,l45f4h+3      ;52ff 21 f7 45
    ld a,(hl)           ;5302 7e
    or a                ;5303 b7
    jp nz,l0376h        ;5304 c2 76 03
    ld (hl),2ah         ;5307 36 2a
    inc hl              ;5309 23
    ld (hl),00h         ;530a 36 00
    jp l0376h           ;530c c3 76 03
    ld hl,l45f4h+3      ;530f 21 f7 45
    ld a,(l45f4h+2)     ;5312 3a f6 45
    call 1544h          ;5315 cd 44 15
    jp c,l14dch         ;5318 da dc 14
    bit 5,(ix+00h)      ;531b dd cb 00 6e
    jr z,l5329h         ;531f 28 08
    ld a,(2d6eh)        ;5321 3a 6e 2d
    cp 48h              ;5324 fe 48
    jp nz,sub_140fh     ;5326 c2 0f 14
l5329h:
    ld hl,l4570h        ;5329 21 70 45
    ld (45f0h),hl       ;532c 22 f0 45
    inc hl              ;532f 23
    inc hl              ;5330 23
    ld e,(ix+13h)       ;5331 dd 5e 13
    ld d,(ix+14h)       ;5334 dd 56 14
    inc de              ;5337 13
    ld (hl),e           ;5338 73
    inc hl              ;5339 23
    ld (hl),d           ;533a 72
    inc hl              ;533b 23
    ld b,03h            ;533c 06 03
    ld iy,l06afh        ;533e fd 21 af 06
l5342h:
    ld a,e              ;5342 7b
    cp (iy+00h)         ;5343 fd be 00
    ld a,d              ;5346 7a
    sbc a,(iy+01h)      ;5347 fd 9e 01
    jr nc,l5357h        ;534a 30 0b
    ld (hl),20h         ;534c 36 20
    inc hl              ;534e 23
    inc iy              ;534f fd 23
    inc iy              ;5351 fd 23
    inc iy              ;5353 fd 23
sub_5355h:
    djnz l5342h         ;5355 10 eb
l5357h:
    ld (hl),22h         ;5357 36 22
    inc hl              ;5359 23
    push ix             ;535a dd e5
    ld b,10h            ;535c 06 10
l535eh:
    ld a,(ix+02h)       ;535e dd 7e 02
    or a                ;5361 b7
    jr z,l536ah         ;5362 28 06
    ld (hl),a           ;5364 77
    inc hl              ;5365 23
    inc ix              ;5366 dd 23
    djnz l535eh         ;5368 10 f4
l536ah:
    ld (hl),22h         ;536a 36 22
    inc hl              ;536c 23
    ld a,b              ;536d 78
    or a                ;536e b7
    jr z,l5376h         ;536f 28 05
l5371h:
    ld (hl),20h         ;5371 36 20
    inc hl              ;5373 23
    djnz l5371h         ;5374 10 fb
l5376h:
    pop ix              ;5376 dd e1
    ld (hl),20h         ;5378 36 20
    bit 7,(ix+00h)      ;537a dd cb 00 7e
    jr z,l5382h         ;537e 28 02
    ld (hl),2ah         ;5380 36 2a
l5382h:
    inc hl              ;5382 23
    ex de,hl            ;5383 eb
    ld a,(ix+00h)       ;5384 dd 7e 00
    and 03h             ;5387 e6 03
    ld b,a              ;5389 47
    add a,a             ;538a 87
    add a,b             ;538b 80
    ld c,a              ;538c 4f
    ld b,00h            ;538d 06 00
    ld hl,l1522h        ;538f 21 22 15
    add hl,bc           ;5392 09
    ld bc,0003h         ;5393 01 03 00
    ldir                ;5396 ed b0
    ex de,hl            ;5398 eb
    ld (hl),20h         ;5399 36 20
    inc hl              ;539b 23
    ld (hl),2dh         ;539c 36 2d
    bit 6,(ix+00h)      ;539e dd cb 00 76
    jr z,l53a6h         ;53a2 28 02
    ld (hl),57h         ;53a4 36 57
l53a6h:
    inc hl              ;53a6 23
    ld (hl),2dh         ;53a7 36 2d
    bit 4,(ix+00h)      ;53a9 dd cb 00 66
    jr z,l53b1h         ;53ad 28 02
    ld (hl),47h         ;53af 36 47
l53b1h:
    ld a,(2d6eh)        ;53b1 3a 6e 2d
    cp 48h              ;53b4 fe 48
    jr nz,l53c3h        ;53b6 20 0b
    inc hl              ;53b8 23
    ld (hl),2dh         ;53b9 36 2d
    bit 5,(ix+00h)      ;53bb dd cb 00 6e
    jr z,l53c3h         ;53bf 28 02
    ld (hl),48h         ;53c1 36 48
l53c3h:
    inc hl              ;53c3 23
    ld (hl),00h         ;53c4 36 00
    inc hl              ;53c6 23
    ld (l45f1h+1),hl    ;53c7 22 f2 45
    ld de,l4570h        ;53ca 11 70 45
    or a                ;53cd b7
    sbc hl,de           ;53ce ed 52
    ld de,(l45f4h)      ;53d0 ed 5b f4 45
    add hl,de           ;53d4 19
    ld (l4570h),hl      ;53d5 22 70 45
    ld (l45f4h),hl      ;53d8 22 f4 45
    ret                 ;53db c9
    call sub_175ch      ;53dc cd 5c 17
    ld (l4570h+2),hl    ;53df 22 72 45
    ld hl,l4570h        ;53e2 21 70 45
    ld (45f0h),hl       ;53e5 22 f0 45
    ld de,4574h         ;53e8 11 74 45
    ld hl,152fh         ;53eb 21 2f 15
    ld bc,000eh         ;53ee 01 0e 00
    ldir                ;53f1 ed b0
    ld hl,203eh         ;53f3 21 3e 20
    ld b,10h            ;53f6 06 10
l53f8h:
    ld a,(hl)           ;53f8 7e
    or a                ;53f9 b7
    jr z,l5401h         ;53fa 28 05
    ld (de),a           ;53fc 12
    inc hl              ;53fd 23
    inc de              ;53fe 13
    djnz l53f8h         ;53ff 10 f7
l5401h:
    xor a               ;5401 af
    ld (de),a           ;5402 12
    inc de              ;5403 13
    ld (de),a           ;5404 12
    inc de              ;5405 13
    ld (de),a           ;5406 12
    inc de              ;5407 13
    ld (l45f1h+1),de    ;5408 ed 53 f2 45
    dec de              ;540c 1b
    dec de              ;540d 1b
    ld hl,(l45f4h)      ;540e 2a f4 45
    add hl,de           ;5411 19
    ld bc,l4570h        ;5412 01 70 45
    or a                ;5415 b7
    sbc hl,bc           ;5416 ed 42
    ld (l4570h),hl      ;5418 22 70 45
    ld hl,0000h         ;541b 21 00 00
    ld (l45f4h),hl      ;541e 22 f4 45
    ret                 ;5421 c9
    db "SEQ"
    db "USR"
    db "PRG"
    db "REL"
    db " BLOCKS FREE : "
    db 11h
    nop                 ;543e 00
    nop                 ;543f 00
    ld (2d68h),de       ;5440 ed 53 68 2d
    ld c,a              ;5444 4f
    ld (l4608h),hl      ;5445 22 08 46
l5448h:
    push bc             ;5448 c5
    call sub_15a6h      ;5449 cd a6 15
l544ch:
    ld hl,(l4608h)      ;544c 2a 08 46
l544fh:
    pop bc              ;544f c1
    ret c               ;5450 d8
    push ix             ;5451 dd e5
    pop iy              ;5453 fd e1
    bit 7,(iy+01h)      ;5455 fd cb 01 7e
    jr nz,l5448h        ;5459 20 ed
    bit 4,(iy+00h)      ;545b fd cb 00 66
    jr nz,l5467h        ;545f 20 06
    ld a,(iy+01h)       ;5461 fd 7e 01
    cp c                ;5464 b9
    jr nz,l5448h        ;5465 20 e1
l5467h:
    ld b,10h            ;5467 06 10
l5469h:
    ld a,(hl)           ;5469 7e
    cp 2ah              ;546a fe 2a
    ret z               ;546c c8
    cp 3fh              ;546d fe 3f
    jr nz,l5479h        ;546f 20 08
    ld a,(iy+02h)       ;5471 fd 7e 02
    or a                ;5474 b7
    jr z,l5448h         ;5475 28 d1
    jr l547eh           ;5477 18 05
l5479h:
    cp (iy+02h)         ;5479 fd be 02
    jr nz,l5448h        ;547c 20 ca
l547eh:
    inc hl              ;547e 23
    inc iy              ;547f fd 23
    or a                ;5481 b7
    ret z               ;5482 c8
    djnz l5469h         ;5483 10 e4
    ret                 ;5485 c9
    ld hl,0000h         ;5486 21 00 00
    ld (2d68h),hl       ;5489 22 68 2d
l548ch:
    call sub_15a6h      ;548c cd a6 15
    bit 7,(ix+01h)      ;548f dd cb 01 7e
    ret nz              ;5493 c0
    inc de              ;5494 13
    ld a,(200bh)        ;5495 3a 0b 20
    cp e                ;5498 bb
    jr nz,l548ch        ;5499 20 f1
    ld a,(200ch)        ;549b 3a 0c 20
    cp d                ;549e ba
    jr nz,l548ch        ;549f 20 eb
    ld a,48h            ;54a1 3e 48
    jp 05cfh            ;54a3 c3 cf 05
    ld a,(l460ch)       ;54a6 3a 0c 46
    or a                ;54a9 b7
    ld a,54h            ;54aa 3e 54
    jp z,05cfh          ;54ac ca cf 05
    ld hl,(2d68h)       ;54af 2a 68 2d
    ld e,l              ;54b2 5d
    ld d,h              ;54b3 54
    inc hl              ;54b4 23
    ld (2d68h),hl       ;54b5 22 68 2d
    ld a,(200bh)        ;54b8 3a 0b 20
    cp e                ;54bb bb
    jr nz,l54c4h        ;54bc 20 06
    ld a,(200ch)        ;54be 3a 0c 20
    cp d                ;54c1 ba
    scf                 ;54c2 37
    ret z               ;54c3 c8
l54c4h:
    ld a,e              ;54c4 7b
    and 03h             ;54c5 e6 03
    jr nz,l54cch        ;54c7 20 03
    call sub_177eh      ;54c9 cd 7e 17
l54cch:
    ld ix,2af5h         ;54cc dd 21 f5 2a
    ld a,e              ;54d0 7b
    and 07h             ;54d1 e6 07
    rrca                ;54d3 0f
    rrca                ;54d4 0f
    rrca                ;54d5 0f
    ld c,a              ;54d6 4f
    ld b,00h            ;54d7 06 00
    add ix,bc           ;54d9 dd 09
    ld a,(ix+01h)       ;54db dd 7e 01
    xor 0e5h            ;54de ee e5
    ret nz              ;54e0 c0
    scf                 ;54e1 37
    ret                 ;54e2 c9
    ld a,(204fh)        ;54e3 3a 4f 20
    ld (2d67h),a        ;54e6 32 67 2d
    ld a,(hl)           ;54e9 7e
    ld e,a              ;54ea 5f
    call l1680h+2       ;54eb cd 82 16
    jr nc,l5503h        ;54ee 30 13
    inc hl              ;54f0 23
    ld a,(hl)           ;54f1 7e
    dec hl              ;54f2 2b
    cp 0dh              ;54f3 fe 0d
    jr z,l54fch         ;54f5 28 05
    cp 3ah              ;54f7 fe 3a
    jr nz,l5503h        ;54f9 20 08
    inc hl              ;54fb 23
l54fch:
    inc hl              ;54fc 23
    ld a,e              ;54fd 7b
    sub 30h             ;54fe d6 30
    ld (2d67h),a        ;5500 32 67 2d
l5503h:
    ld b,11h            ;5503 06 11
    ld de,2d45h         ;5505 11 45 2d
l5508h:
    ld a,(hl)           ;5508 7e
    ld (de),a           ;5509 12
    cp 0dh              ;550a fe 0d
    jr z,l551fh         ;550c 28 11
    cp 2ch              ;550e fe 2c
    jr z,l551fh         ;5510 28 0d
    cp 3dh              ;5512 fe 3d
    jr z,l551fh         ;5514 28 09
    inc hl              ;5516 23
    inc de              ;5517 13
    djnz l5508h         ;5518 10 ee
    ld a,1fh            ;551a 3e 1f
    jp 05cfh            ;551c c3 cf 05
l551fh:
    xor a               ;551f af
    ld (de),a           ;5520 12
    inc de              ;5521 13
    djnz l551fh         ;5522 10 fb
    ret                 ;5524 c9
    ld hl,2bf5h         ;5525 21 f5 2b
l5528h:
    ld a,(hl)           ;5528 7e
    cp 0dh              ;5529 fe 0d
    ld a,22h            ;552b 3e 22
    jp z,05cfh          ;552d ca cf 05
    ld a,(hl)           ;5530 7e
    cp 30h              ;5531 fe 30
    jr c,l5538h         ;5533 38 03
    cp 3ah              ;5535 fe 3a
    ret c               ;5537 d8
l5538h:
    inc hl              ;5538 23
    jr l5528h           ;5539 18 ed
    ld b,10h            ;553b 06 10
    ld hl,2d45h         ;553d 21 45 2d
l5540h:
    ld a,(hl)           ;5540 7e
    cp 3fh              ;5541 fe 3f
    scf                 ;5543 37
    ret z               ;5544 c8
    cp 2ah              ;5545 fe 2a
    scf                 ;5547 37
    ret z               ;5548 c8
    djnz l5540h         ;5549 10 f5
    or a                ;554b b7
    ret                 ;554c c9
l554dh:
    ld a,(hl)           ;554d 7e
    inc hl              ;554e 23
    cp 0dh              ;554f fe 0d
    scf                 ;5551 37
    ret z               ;5552 c8
    call l1680h+2       ;5553 cd 82 16
    jr nc,l554dh        ;5556 30 f5
    ld de,0000h         ;5558 11 00 00
    ld b,00h            ;555b 06 00
    dec hl              ;555d 2b
l555eh:
    push hl             ;555e e5
    ld h,d              ;555f 62
    ld l,e              ;5560 6b
    ld a,b              ;5561 78
    add a,a             ;5562 87
    adc hl,hl           ;5563 ed 6a
    add a,a             ;5565 87
    adc hl,hl           ;5566 ed 6a
    add a,b             ;5568 80
    adc hl,de           ;5569 ed 5a
    add a,a             ;556b 87
    adc hl,hl           ;556c ed 6a
    ex de,hl            ;556e eb
    pop hl              ;556f e1
    ld b,a              ;5570 47
    ld a,(hl)           ;5571 7e
    sub 30h             ;5572 d6 30
    add a,b             ;5574 80
    ld b,a              ;5575 47
    jr nc,l5579h        ;5576 30 01
    inc de              ;5578 13
l5579h:
    inc hl              ;5579 23
    ld a,(hl)           ;557a 7e
    call l1680h+2       ;557b cd 82 16
    jr c,l555eh         ;557e 38 de
    ld a,b              ;5580 78
    ret                 ;5581 c9
    cp 30h              ;5582 fe 30
    ccf                 ;5584 3f
    ret nc              ;5585 d0
    cp 3ah              ;5586 fe 3a
    ret                 ;5588 c9
    ld a,(2ae7h)        ;5589 3a e7 2a
    ld d,a              ;558c 57
    ld e,00h            ;558d 1e 00
    ld hl,2d6fh         ;558f 21 6f 2d
    add hl,de           ;5592 19
    ld (2aeah),hl       ;5593 22 ea 2a
    ld hl,5000h         ;5596 21 00 50
    add hl,de           ;5599 19
    ld (2aech),hl       ;559a 22 ec 2a
    ld hl,3d6fh         ;559d 21 6f 3d
    srl d               ;55a0 cb 3a
    rr e                ;55a2 cb 1b
    add hl,de           ;55a4 19
    ld (2aeeh),hl       ;55a5 22 ee 2a
    ld iy,2857h         ;55a8 fd 21 57 28
    ld de,0029h         ;55ac 11 29 00
l55afh:
    ld (2ae8h),iy       ;55af fd 22 e8 2a
    dec a               ;55b3 3d
    or a                ;55b4 b7
    ret m               ;55b5 f8
    add iy,de           ;55b6 fd 19
    jr l55afh           ;55b8 18 f5
    push de             ;55ba d5
    push bc             ;55bb c5
    call sub_1973h      ;55bc cd 73 19
    ld hl,0000h         ;55bf 21 00 00
l55c2h:
    ld a,(de)           ;55c2 1a
    ld b,08h            ;55c3 06 08
l55c5h:
    rra                 ;55c5 1f
    jr nc,l55ceh        ;55c6 30 06
    inc hl              ;55c8 23
    djnz l55c5h         ;55c9 10 fa
    inc de              ;55cb 13
    jr l55c2h           ;55cc 18 f4
l55ceh:
    scf                 ;55ce 37
l55cfh:
    rra                 ;55cf 1f
    djnz l55cfh         ;55d0 10 fd
    pop bc              ;55d2 c1
    push hl             ;55d3 e5
    or a                ;55d4 b7
    sbc hl,bc           ;55d5 ed 42
    jp nc,l16deh        ;55d7 d2 de 16
    pop hl              ;55da e1
    ld (de),a           ;55db 12
    pop de              ;55dc d1
    ret                 ;55dd c9
    ld a,48h            ;55de 3e 48
    jp 05cfh            ;55e0 c3 cf 05
    push ix             ;55e3 dd e5
    push iy             ;55e5 fd e5
    push hl             ;55e7 e5
    push de             ;55e8 d5
    push bc             ;55e9 c5
    call sub_1973h      ;55ea cd 73 19
    call sub_18beh      ;55ed cd be 18
    ld b,40h            ;55f0 06 40
    ld ix,(2aeeh)       ;55f2 dd 2a ee 2a
l55f6h:
    ld e,(ix+00h)       ;55f6 dd 5e 00
    ld d,(ix+01h)       ;55f9 dd 56 01
    bit 7,d             ;55fc cb 7a
    jr nz,l5625h        ;55fe 20 25
    push bc             ;5600 c5
    push de             ;5601 d5
    call l17b5h         ;5602 cd b5 17
    ld b,80h            ;5605 06 80
    ld iy,(2aeah)       ;5607 fd 2a ea 2a
l560bh:
    ld l,(iy+00h)       ;560b fd 6e 00
    ld h,(iy+01h)       ;560e fd 66 01
    ld de,2457h         ;5611 11 57 24
    call sub_173ch      ;5614 cd 3c 17
    inc iy              ;5617 fd 23
    inc iy              ;5619 fd 23
    djnz l560bh         ;561b 10 ee
    pop hl              ;561d e1
    ld de,2057h         ;561e 11 57 20
    call sub_173ch      ;5621 cd 3c 17
    pop bc              ;5624 c1
l5625h:
    inc ix              ;5625 dd 23
    inc ix              ;5627 dd 23
    djnz l55f6h         ;5629 10 cb
    pop bc              ;562b c1
    pop de              ;562c d1
    pop hl              ;562d e1
    pop iy              ;562e fd e1
    pop ix              ;5630 dd e1
    ret                 ;5632 c9
    bit 7,h             ;5633 cb 7c
    ret nz              ;5635 c0
    call 1746h          ;5636 cd 46 17
    or (hl)             ;5639 b6
    ld (hl),a           ;563a 77
    ret                 ;563b c9
    bit 7,h             ;563c cb 7c
    ret nz              ;563e c0
    call 1746h          ;563f cd 46 17
    cpl                 ;5642 2f
    and (hl)            ;5643 a6
    ld (hl),a           ;5644 77
    ret                 ;5645 c9
    push bc             ;5646 c5
    ld a,l              ;5647 7d
    push af             ;5648 f5
    ld b,03h            ;5649 06 03
    call sub_1a7ah      ;564b cd 7a 1a
    add hl,de           ;564e 19
    pop af              ;564f f1
    and 07h             ;5650 e6 07
    ld b,a              ;5652 47
    ld a,01h            ;5653 3e 01
    jr z,l565ah         ;5655 28 03
l5657h:
    rla                 ;5657 17
    djnz l5657h         ;5658 10 fd
l565ah:
    pop bc              ;565a c1
    ret                 ;565b c9
    ld ix,2457h         ;565c dd 21 57 24
    ld de,(2034h)       ;5660 ed 5b 34 20
    ld hl,0000h         ;5664 21 00 00
l5667h:
    ld b,08h            ;5667 06 08
    ld c,(ix+00h)       ;5669 dd 4e 00
    inc ix              ;566c dd 23
l566eh:
    rr c                ;566e cb 19
    jr c,l5673h         ;5670 38 01
    inc hl              ;5672 23
l5673h:
    dec de              ;5673 1b
    ld a,d              ;5674 7a
    or e                ;5675 b3
    jr z,l567ch         ;5676 28 04
    djnz l566eh         ;5678 10 f4
    jr l5667h           ;567a 18 eb
l567ch:
    add hl,hl           ;567c 29
    ret                 ;567d c9
    push de             ;567e d5
    push hl             ;567f e5
    call 1797h          ;5680 cd 97 17
    call sub_1982h      ;5683 cd 82 19
    pop hl              ;5686 e1
    pop de              ;5687 d1
    ret                 ;5688 c9
    push de             ;5689 d5
    push hl             ;568a e5
    call sub_1973h      ;568b cd 73 19
    call 1797h          ;568e cd 97 17
    call l19b3h         ;5691 cd b3 19
    pop hl              ;5694 e1
    pop de              ;5695 d1
    ret                 ;5696 c9
    ld a,(2004h)        ;5697 3a 04 20
    ld b,a              ;569a 47
    srl d               ;569b cb 3a
    rr e                ;569d cb 1b
    srl d               ;569f cb 3a
    rr e                ;56a1 cb 1b
    srl d               ;56a3 cb 3a
    rr e                ;56a5 cb 1b
    ld hl,(2024h)       ;56a7 2a 24 20
    add hl,de           ;56aa 19
    ex de,hl            ;56ab eb
    ld a,(2026h)        ;56ac 3a 26 20
    adc a,00h           ;56af ce 00
    ld hl,2af5h         ;56b1 21 f5 2a
    ret                 ;56b4 c9
    push de             ;56b5 d5
    push hl             ;56b6 e5
    call sub_17ceh      ;56b7 cd ce 17
    call sub_1982h      ;56ba cd 82 19
    pop de              ;56bd d1
    pop hl              ;56be e1
    ret                 ;56bf c9
    push de             ;56c0 d5
    push hl             ;56c1 e5
    call sub_1973h      ;56c2 cd 73 19
    call sub_17ceh      ;56c5 cd ce 17
    call l19b3h         ;56c8 cd b3 19
    pop de              ;56cb d1
    pop hl              ;56cc e1
    ret                 ;56cd c9
    ld a,(2004h)        ;56ce 3a 04 20
    ld b,a              ;56d1 47
    ld hl,(202ch)       ;56d2 2a 2c 20
    ld a,(202eh)        ;56d5 3a 2e 20
    add hl,de           ;56d8 19
    ex de,hl            ;56d9 eb
    adc a,00h           ;56da ce 00
    ld hl,(2aeah)       ;56dc 2a ea 2a
    ret                 ;56df c9
    push de             ;56e0 d5
    push hl             ;56e1 e5
    call 17f6h          ;56e2 cd f6 17
    call sub_1982h      ;56e5 cd 82 19
    pop hl              ;56e8 e1
    pop de              ;56e9 d1
    ret                 ;56ea c9
    push de             ;56eb d5
    push hl             ;56ec e5
    call 17f6h          ;56ed cd f6 17
    call l19b3h         ;56f0 cd b3 19
    pop hl              ;56f3 e1
    pop de              ;56f4 d1
    ret                 ;56f5 c9
    push ix             ;56f6 dd e5
    push iy             ;56f8 fd e5
    ld a,(2d6dh)        ;56fa 3a 6d 2d
    ld iy,(2ae8h)       ;56fd fd 2a e8 2a
    cp (iy+26h)         ;5701 fd be 26
    jr z,l5747h         ;5704 28 41
    ld (iy+26h),a       ;5706 fd 77 26
    ld c,a              ;5709 4f
    ld b,00h            ;570a 06 00
    ld ix,(2aeeh)       ;570c dd 2a ee 2a
    add ix,bc           ;5710 dd 09
    add ix,bc           ;5712 dd 09
    ld e,(ix+00h)       ;5714 dd 5e 00
    ld d,(ix+01h)       ;5717 dd 56 01
    ld a,e              ;571a 7b
    and d               ;571b a2
    inc a               ;571c 3c
    push af             ;571d f5
    call nz,l17b5h      ;571e c4 b5 17
    pop af              ;5721 f1
    jr nz,l5747h        ;5722 20 23
    ld de,2057h         ;5724 11 57 20
    ld bc,(202fh)       ;5727 ed 4b 2f 20
    call 16bah          ;572b cd ba 16
    ld (ix+00h),l       ;572e dd 75 00
    ld (ix+01h),h       ;5731 dd 74 01
    ld hl,(2aeah)       ;5734 2a ea 2a
    ld b,00h            ;5737 06 00
l5739h:
    ld (hl),0ffh        ;5739 36 ff
    inc hl              ;573b 23
    djnz l5739h         ;573c 10 fb
    ld e,(iy+23h)       ;573e fd 5e 23
    ld d,(iy+24h)       ;5741 fd 56 24
    call sub_18eeh      ;5744 cd ee 18
l5747h:
    ld a,(2d6ah)        ;5747 3a 6a 2d
    ld c,a              ;574a 4f
    ld b,00h            ;574b 06 00
    ld ix,(2aeah)       ;574d dd 2a ea 2a
    add ix,bc           ;5751 dd 09
    add ix,bc           ;5753 dd 09
    ld l,(ix+00h)       ;5755 dd 6e 00
    ld h,(ix+01h)       ;5758 dd 66 01
    ld a,l              ;575b 7d
    and h               ;575c a4
    inc a               ;575d 3c
    jr nz,l5786h        ;575e 20 26
    ld de,2457h         ;5760 11 57 24
    ld bc,(2034h)       ;5763 ed 4b 34 20
    call 16bah          ;5767 cd ba 16
    ld (ix+00h),l       ;576a dd 75 00
    ld (ix+01h),h       ;576d dd 74 01
    ld c,(iy+26h)       ;5770 fd 4e 26
    ld b,00h            ;5773 06 00
    ld ix,(2aeeh)       ;5775 dd 2a ee 2a
    add ix,bc           ;5779 dd 09
    add ix,bc           ;577b dd 09
    ld e,(ix+00h)       ;577d dd 5e 00
    ld d,(ix+01h)       ;5780 dd 56 01
    call sub_17c0h      ;5783 cd c0 17
l5786h:
    ld ix,(2aeah)       ;5786 dd 2a ea 2a
    ld a,(2d6ah)        ;578a 3a 6a 2d
    add a,a             ;578d 87
    ld e,a              ;578e 5f
    ld d,00h            ;578f 16 00
    add ix,de           ;5791 dd 19
    ld l,(ix+00h)       ;5793 dd 6e 00
    ld h,(ix+01h)       ;5796 dd 66 01
    xor a               ;5799 af
    ld b,03h            ;579a 06 03
l579ch:
    add hl,hl           ;579c 29
    adc a,a             ;579d 8f
    djnz l579ch         ;579e 10 fc
    ld de,(2d6ch)       ;57a0 ed 5b 6c 2d
    ld d,00h            ;57a4 16 00
    add hl,de           ;57a6 19
    ld de,(2031h)       ;57a7 ed 5b 31 20
    add hl,de           ;57ab 19
    ex de,hl            ;57ac eb
    ld b,a              ;57ad 47
    ld a,(2033h)        ;57ae 3a 33 20
    adc a,b             ;57b1 88
    ld hl,2004h         ;57b2 21 04 20
    ld b,(hl)           ;57b5 46
    ld hl,(2aech)       ;57b6 2a ec 2a
    pop iy              ;57b9 fd e1
    pop ix              ;57bb dd e1
    ret                 ;57bd c9
    push hl             ;57be e5
    push de             ;57bf d5
    push bc             ;57c0 c5
    srl d               ;57c1 cb 3a
    rr e                ;57c3 cb 1b
    push af             ;57c5 f5
    ld hl,(2027h)       ;57c6 2a 27 20
    ld a,(2029h)        ;57c9 3a 29 20
    add hl,de           ;57cc 19
    adc a,00h           ;57cd ce 00
    ex de,hl            ;57cf eb
    ld hl,2004h         ;57d0 21 04 20
    ld b,(hl)           ;57d3 46
    ld hl,l4710h        ;57d4 21 10 47
    call sub_1982h      ;57d7 cd 82 19
    pop af              ;57da f1
    ld hl,l4710h        ;57db 21 10 47
    ld bc,0080h         ;57de 01 80 00
    jr nc,l57e4h        ;57e1 30 01
    add hl,bc           ;57e3 09
l57e4h:
    ld de,(2aeeh)       ;57e4 ed 5b ee 2a
    ldir                ;57e8 ed b0
    pop bc              ;57ea c1
    pop de              ;57eb d1
    pop hl              ;57ec e1
    ret                 ;57ed c9
    push hl             ;57ee e5
    push de             ;57ef d5
    push bc             ;57f0 c5
    call sub_1973h      ;57f1 cd 73 19
    srl d               ;57f4 cb 3a
    rr e                ;57f6 cb 1b
    ex af,af'           ;57f8 08
    ld hl,(2027h)       ;57f9 2a 27 20
    ld a,(2029h)        ;57fc 3a 29 20
    add hl,de           ;57ff 19
    adc a,00h           ;5800 ce 00
    ex de,hl            ;5802 eb
    ld hl,2004h         ;5803 21 04 20
    ld b,(hl)           ;5806 46
    ld hl,l4710h        ;5807 21 10 47
    push af             ;580a f5
    push de             ;580b d5
    push bc             ;580c c5
    call sub_1982h      ;580d cd 82 19
    ex af,af'           ;5810 08
    ld hl,l4710h        ;5811 21 10 47
    ld bc,0080h         ;5814 01 80 00
    jr nc,l581ah        ;5817 30 01
    add hl,bc           ;5819 09
l581ah:
    ex de,hl            ;581a eb
    ld hl,(2aeeh)       ;581b 2a ee 2a
    ldir                ;581e ed b0
    pop bc              ;5820 c1
    pop de              ;5821 d1
    pop af              ;5822 f1
    ld hl,l4710h        ;5823 21 10 47
    call l19b3h         ;5826 cd b3 19
    pop bc              ;5829 c1
    pop de              ;582a d1
    pop hl              ;582b e1
    ret                 ;582c c9
    ld a,(2004h)        ;582d 3a 04 20
    ld b,a              ;5830 47
    ld de,(2005h)       ;5831 ed 5b 05 20
    ld a,(2007h)        ;5835 3a 07 20
    ld hl,l460fh+1      ;5838 21 10 46
    jp sub_1982h        ;583b c3 82 19
    ld a,(2004h)        ;583e 3a 04 20
    ld b,a              ;5841 47
    ld de,(2005h)       ;5842 ed 5b 05 20
    ld a,(2007h)        ;5846 3a 07 20
    ld hl,l460fh+1      ;5849 21 10 46
    jp l19b3h           ;584c c3 b3 19
    call sub_195bh      ;584f cd 5b 19
    jp sub_1982h        ;5852 c3 82 19
    call sub_195bh      ;5855 cd 5b 19
    jp l19b3h           ;5858 c3 b3 19
    ld de,(204eh)       ;585b ed 5b 4e 20
    ld d,00h            ;585f 16 00
    ld hl,(203bh)       ;5861 2a 3b 20
    ld a,(203dh)        ;5864 3a 3d 20
    add hl,de           ;5867 19
    adc a,00h           ;5868 ce 00
    ex de,hl            ;586a eb
    ld hl,2004h         ;586b 21 04 20
    ld b,(hl)           ;586e 46
    ld hl,4910h         ;586f 21 10 49
    ret                 ;5872 c9
    ld a,(200ah)        ;5873 3a 0a 20
    or a                ;5876 b7
    ret z               ;5877 c8
    ld a,(2002h)        ;5878 3a 02 20
    or a                ;587b b7
    ret z               ;587c c8
    ld a,5ch            ;587d 3e 5c
    jp 05cfh            ;587f c3 cf 05
    ld (l4a10h),de      ;5882 ed 53 10 4a
    ld (l4a12h),a       ;5886 32 12 4a
    push hl             ;5889 e5
    ld a,21h            ;588a 3e 21
    call 19f0h          ;588c cd f0 19
    call sub_1a29h      ;588f cd 29 1a
    call sub_1a0dh      ;5892 cd 0d 1a
    pop hl              ;5895 e1
    jr nz,l58dfh        ;5896 20 47
    ld a,41h            ;5898 3e 41
    call 19f0h          ;589a cd f0 19
    ld b,00h            ;589d 06 00
l589fh:
    in a,(18h)          ;589f db 18
    ld (hl),a           ;58a1 77
    inc hl              ;58a2 23
    ex (sp),hl          ;58a3 e3
    ex (sp),hl          ;58a4 e3
    djnz l589fh         ;58a5 10 f8
    call sub_1a0dh      ;58a7 cd 0d 1a
    ret z               ;58aa c8
    ld (2051h),a        ;58ab 32 51 20
    ld a,16h            ;58ae 3e 16
    jp 19dfh            ;58b0 c3 df 19
    ld (l4a10h),de      ;58b3 ed 53 10 4a
    ld (l4a12h),a       ;58b7 32 12 4a
    ld a,42h            ;58ba 3e 42
    call 19f0h          ;58bc cd f0 19
    ld b,00h            ;58bf 06 00
l58c1h:
    ld a,(hl)           ;58c1 7e
    out (18h),a         ;58c2 d3 18
    inc hl              ;58c4 23
    ex (sp),hl          ;58c5 e3
    ex (sp),hl          ;58c6 e3
    djnz l58c1h         ;58c7 10 f8
    call sub_1a0dh      ;58c9 cd 0d 1a
    jr nz,l58dfh        ;58cc 20 11
    ld a,22h            ;58ce 3e 22
    call 19f0h          ;58d0 cd f0 19
    call sub_1a29h      ;58d3 cd 29 1a
    call sub_1a0dh      ;58d6 cd 0d 1a
    ret z               ;58d9 c8
    ld (2051h),a        ;58da 32 51 20
    ld a,19h            ;58dd 3e 19
l58dfh:
    push af             ;58df f5
    ld hl,(l4a10h)      ;58e0 2a 10 4a
    ld (2054h),hl       ;58e3 22 54 20
    ld a,(l4a12h)       ;58e6 3a 12 4a
    ld (2056h),a        ;58e9 32 56 20
    pop af              ;58ec f1
    jp 05dbh            ;58ed c3 db 05
    ld b,a              ;58f0 47
    xor a               ;58f1 af
    out (18h),a         ;58f2 d3 18
l58f4h:
    in a,(18h)          ;58f4 db 18
    cp 0a0h             ;58f6 fe a0
    jr nz,l58f4h        ;58f8 20 fa
    ld a,b              ;58fa 78
    out (18h),a         ;58fb d3 18
l58fdh:
    in a,(18h)          ;58fd db 18
    cp 0a1h             ;58ff fe a1
    jr nz,l58fdh        ;5901 20 fa
    ld a,0ffh           ;5903 3e ff
    out (18h),a         ;5905 d3 18
    ld b,14h            ;5907 06 14
l5909h:
    nop                 ;5909 00
    djnz l5909h         ;590a 10 fd
    ret                 ;590c c9
    ld a,0ffh           ;590d 3e ff
    out (18h),a         ;590f d3 18
l5911h:
    in a,(18h)          ;5911 db 18
    inc a               ;5913 3c
    jr nz,l5911h        ;5914 20 fb
    ld a,0feh           ;5916 3e fe
    out (18h),a         ;5918 d3 18
l591ah:
    in a,(18h)          ;591a db 18
    rla                 ;591c 17
    jr c,l591ah         ;591d 38 fb
    in a,(18h)          ;591f db 18
    bit 6,a             ;5921 cb 77
    push af             ;5923 f5
    xor a               ;5924 af
    out (18h),a         ;5925 d3 18
    pop af              ;5927 f1
    ret                 ;5928 c9
    xor a               ;5929 af
    out (18h),a         ;592a d3 18
    ld hl,(l4a10h)      ;592c 2a 10 4a
    ld a,(l4a12h)       ;592f 3a 12 4a
    ld b,05h            ;5932 06 05
l5934h:
    rra                 ;5934 1f
    rr h                ;5935 cb 1c
    rr l                ;5937 cb 1d
    djnz l5934h         ;5939 10 f9
    ld a,(0133h)        ;593b 3a 33 01
    inc a               ;593e 3c
    add a,a             ;593f 87
    add a,a             ;5940 87
    add a,a             ;5941 87
    add a,a             ;5942 87
    ld b,a              ;5943 47
    ld c,00h            ;5944 0e 00
    ld de,0000h         ;5946 11 00 00
    ld a,0dh            ;5949 3e 0d
l594bh:
    ex de,hl            ;594b eb
    add hl,hl           ;594c 29
    ex de,hl            ;594d eb
    or a                ;594e b7
    sbc hl,bc           ;594f ed 42
    jr nc,l5956h        ;5951 30 03
l5953h:
    add hl,bc           ;5953 09
    jr l5957h           ;5954 18 01
l5956h:
    inc de              ;5956 13
l5957h:
    srl b               ;5957 cb 38
    rr c                ;5959 cb 19
    dec a               ;595b 3d
    jr nz,l594bh        ;595c 20 ed
    ld a,l              ;595e 7d
    out (18h),a         ;595f d3 18
    ld hl,(0134h)       ;5961 2a 34 01
    add hl,de           ;5964 19
    ld a,l              ;5965 7d
    out (18h),a         ;5966 d3 18
    ld a,h              ;5968 7c
    out (18h),a         ;5969 d3 18
    ld a,(l4a10h)       ;596b 3a 10 4a
    and 1fh             ;596e e6 1f
    out (18h),a         ;5970 d3 18
    xor a               ;5972 af
    out (18h),a         ;5973 d3 18
    out (18h),a         ;5975 d3 18
    out (18h),a         ;5977 d3 18
    ret                 ;5979 c9

hl_shr_b:
    srl h               ;597a cb 3c
    rr l                ;597c cb 1d
    djnz hl_shr_b       ;597e 10 fa
    ret                 ;5980 c9

    db 0                ;"OK"
    db " O", 80h+'K'

    db 01h              ;"FILES SCRATCHED"
    db 01h,"S SCRATCHE",80h+'D'

    db 16h              ;"READ ERROR"
    db 07h,83h

    db 19h              ;"WRITE ERROR"
    db 02h,83h

    db 1ah              ;"WRITE PROTECED"
    db 02h," PROTECTE",80h+'D'
    db 1eh,04h

    db 83h              ;"SYNTAX ERROR"
    db 1fh,04h

    db 03h               ;"SYNTAX ERROR (INVALID COMMAND)"
    db " (",05h," ",06h,80h+")"

    db 20h              ;"SYNTAX ERROR (LONG LINE)"
    db 04h,03h," (LONG LINE",80h+")"

    db 21h              ;"SYNTAX ERROR(INVALID FILENAME)"
    db 04h,03h,"(",05h," ",01h,08h,80h+")"

    db 22h              ;"SYNTAX ERROR(NO FILENAME)"
    db 04h,03h,28h,"NO ",01h,08h,80h+")"

    db 32h              ;"RECORD NOT PRESENT"
    db 09h,0bh," PRESEN",80h+"T"

    db 33h              ;"OVERFLOW IN RECORD"
    db "OVERFLOW IN ",89h

    db 34h              ;"FILE TOO LARGE"
    db 01h," TOO LARG",80h+"E"

    db 3ch              ;"WRITE FILE OPEN"
    db 02h," ", 01h,8ah

    db 3dh              ;"FILE NOT OPEN"
    db 01h,0bh,8ah

    db 3eh              ;"FILE NOT FOUND"
    db 01h,0bh," FOUN",80h+"D"

    db 3fh              ;"FILE EXISTS"
    db 01h," EXIST",80h+"S"

    db 40h              ;"FILE TYPE MISMATCH"
    db 01h," TYPE MISMATC",80h+"H"

    db 41h              ;"NO BLOCK"
    db "NO BLOC",80h+"K"

    db 42h              ;"ILLEGAL TRACK OR SECTOR"
    db "ILLEGAL TRACK OR SECTO",80h+"R"

    db 48h              ;"DISK FULL"
    db "DISK FUL",80h+"L"

    db 54h              ;"DRIVE NOT CONFIGURED"
    db 0eh,0bh," CONFIGURE",80h+"D"

    db 59h              ;"USER #"
    db 0ch," ",80h+"#"

    db 5ah              ;"INVALID USER NAME"
    db 05h," ",0ch," ",88h

    db 5bh              ;"PASSWORD INCORRECT"
    db "PASSWORD INCORREC",80h+"T"

    db 5ch              ;"PRIVILEGED COMMAND"
    db "PRIVILEGED ",86h

    db 63h              ;"SMALL SYSTEMS HARDBOX VERSION #"
    db "SMALL SYSTEMS HARDBOX",8dh

    db 0ffh             ;"UNKNOWN ERROR CODE"
    db "UNKNOWN",03h," COD",80h+"E"

    db "FIL",80h+"E"    ;01h: "FILE"
    db "WRIT",80h+"E"   ;02h: "WRITE"
    db " ERRO",80h+"R"  ;03h: " ERROR"
    db "SYNTA",80h+"X"  ;04h: "SYNTAX"
    db "INVALI",80h+"D" ;05h: "INVALID"
    db "COMMAN",80h+"D" ;06h: "COMMAND"
    db "REA",80h+"D"    ;07h: "READ"
    db "NAM",80h+"E"    ;08h: "NAME"
    db "RECOR",80h+"D"  ;09h: "RECORD"
    db " OPE",80h+"N"   ;0ah: " OPEN"
    db " NO",80h+"T"    ;0bh: " NOT"
    db "USE",80h+"R"    ;0ch: "USER"
    db " VERSION ",80h+"#" ;0dh: " VERSION #"
    db "DRIV",80h+"E"   ;0eh: " DRIVE"
    db "CORVU",80h+"S"  ;0fh: "CORVUS"

    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
