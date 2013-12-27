; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels --output=devnum.asm devnum.com

corvus:        equ  18h   ;Corvus data bus

warm:          equ  0000h ;Warm start entry point
bdos:          equ  0005h ;BDOS entry point

    org 0100h

    jp start

unused_1:
    nop
    nop
    nop
    nop
    nop
    nop
    nop

; Start of BASIC variables ==================================================

l010ah:
    dw 0
l010ch:
    dw 0
l010eh:
    dw 0
rr:
    dw 0                ;First char of user input from any prompt
nn:
    dw 0                ;Integer parsed from user input
l0114h:
    dw 0
buf:
    dw 0                ;Address of buffer used in readline
jj:
    dw 0                ;Loop index
l011ah:
    dw 0
    dw 0
    dw 0
    dw 0
l0122h:
    dw 0
    dw 0

; End of BASIC variables ====================================================

start:
    ld hl,main
    jp ini              ;Perform JP (main)

unused_2:
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

main:
    call n5_0

    ;PRINT CHR$(26) ' Clear screen
    call pr0a
    ld hl,001ah
    call chr
    call pv2d

    ;PRINT "Alter PET DOS device number of Mini-Winchester"
    call pr0a
    ld hl,alter_pet_dos
    call pv2d

    ;PRINT "----- --- --- ------ ------ -- ---------------"
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

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;POKE &H4033, 1
    ld a,01h
    ld (4033h),a

    ;l010ah = &H4000
    ld hl,4000h
    ld (l010ah),hl

    ;l010ch = &H20
    ld hl,0020h
    ld (l010ch),hl

    ;CALL mw_read (l010ah, l010ch, l010eh)
    ld bc,l010ah
    ld de,l010ch
    ld hl,l010eh
    call mw_read

    ;GOSUB check_error
    call check_error

    ;PRINT "current device number is :  "
    call pr0a
    ld hl,cur_dev_num
    call pv1d

    ;PRINT PEEK (&H4036)
    ld a,(4036h)
    ld l,a
    ld h,00h
    call pv2c

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "new device number ? "
    call pr0a
    ld hl,new_dev_num
    call pv1d

    ;GOSUB readline
    call readline

    ;IF R <> 0 THEN GOTO l01c8h
    ld hl,(rr)
    ld a,h
    or l
    jp nz,l01c8h

    ;END
    call end

l01c8h:
    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;PRINT "changing device number to ";
    call pr0a
    ld hl,chg_dev_num
    call pv1d

    ;PRINT N
    ld hl,(nn)
    call sub_06ceh

    ;PRINT " ..."
    ld hl,ellipsis
    call pv2d

    ;POKE &H4036, N
    ld hl,(nn)
    ld a,l
    ld (4036h),a

    ;l010ch = &H20
    ld hl,0020h
    ld (l010ch),hl

    ;CALL mw_write (l010ah, l010ch, l010eh)
    ld bc,l010ah
    ld de,l010ch
    ld hl,l010eh
    call mw_write

    ;GOSUB check_error
    call check_error

    ;END
    call end

check_error:
    ;IF (l010eh AND &H40) <> 0 THEN GOTO got_error
    ld hl,(l010eh)
    ld a,l
    and 40h
    ld l,a
    ld a,h
    and 00h
    ld h,a
    ld a,h
    or l
    jp nz,got_error

    ;RETURN
    ret

got_error:
    ;PRINT "DRIVE ERROR #";
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
    ;IF l0114h <> &H44 THEN GOTO is_err_46h
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
    ;IF l0114h <> &H46 THEN GOTO is_err_47h
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
    ;BUF = &H80
    ld hl,0080h
    ld (buf),hl

    ;POKE BUF, 80
    ld hl,(buf)
    ld (hl),50h

    ;CALL BUFFIN
    call buffin

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;IF PEEK (BUF+1) <> 0 GOTO l02eeh
    ld hl,(buf)
    inc hl
    ld l,(hl)
    ld h,00h
    ld a,h
    or l
    jp nz,l02eeh

    ;R = 0
    ld hl,0000h
    ld (rr),hl

    ;RETURN
    ret

l02eeh:
    ;R = PEEK (BUF+2)
    ld hl,(buf)
    inc hl
    inc hl
    ld l,(hl)
    ld h,00h
    ld (rr),hl

    ld hl,(rr)          ;02f9 2a 10 01
    ld de,0-61h         ;02fc 11 9f ff
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
    ld hl,(rr)          ;030b 2a 10 01
    ld de,0-7bh         ;030e 11 85 ff
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

    ;R = R - &H20
    ld de,0-20h
    ld hl,(rr)
    add hl,de
    ld (rr),hl

l0331h:
	;N = 0
    ld hl,0000h
    ld (nn),hl

    ;J = 2
    ld hl,0002h
    ld (jj),hl

l033dh:
    ld hl,(buf)         ;033d 2a 16 01
    ex de,hl            ;0340 eb
    ld hl,(jj)          ;0341 2a 18 01
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
    ld hl,(buf)         ;0375 2a 16 01
    inc hl              ;0378 23
    ld l,(hl)           ;0379 6e
    ld h,00h            ;037a 26 00
    push hl             ;037c e5
    ld hl,(jj)          ;037d 2a 18 01
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
    ld hl,(nn)          ;039d 2a 12 01
    call imug           ;03a0 cd a9 06
    ld a,(bc)           ;03a3 0a
    nop                 ;03a4 00
    push hl             ;03a5 e5
    ld hl,(buf)         ;03a6 2a 16 01
    ex de,hl            ;03a9 eb
    ld hl,(jj)          ;03aa 2a 18 01
    add hl,de           ;03ad 19
    ld l,(hl)           ;03ae 6e
    ld h,00h            ;03af 26 00
    pop de              ;03b1 d1
    add hl,de           ;03b2 19
    ld de,0ffd0h        ;03b3 11 d0 ff
    add hl,de           ;03b6 19
    ld (nn),hl          ;03b7 22 12 01
    ld hl,(jj)          ;03ba 2a 18 01
    inc hl              ;03bd 23
    ld (jj),hl          ;03be 22 18 01
    jp l033dh           ;03c1 c3 3d 03
l03c4h:
    ;RETURN
    ret

    ;END
    call end

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

cur_dev_num:
    db 1ch
    dw cur_dev_num+3
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

; Start of Unknown Library ==================================================

buffin:
;Buffered Console Input.  Caller must store buffer size at 80h.  On
;return, 81h will contain the number of data bytes and the data
;will start at 82h.
    ld c,0ah
    ld de,0080h
    jp bdos

mw_read:
    ld (var_4),hl       ;0546 22 32 06
    xor a               ;0549 af
    ld (hl),a           ;054a 77
    inc hl              ;054b 23
    ld (hl),a           ;054c 77
    ld (var_3),a        ;054d 32 31 06
    ld a,(de)           ;0550 1a
    ld (var_1),a        ;0551 32 2f 06
    inc de              ;0554 13
    ld a,(de)           ;0555 1a
    ld (var_2),a        ;0556 32 30 06
l0559h:
    ld a,(bc)           ;0559 0a
    ld l,a              ;055a 6f
    inc bc              ;055b 03
    ld a,(bc)           ;055c 0a
    ld h,a              ;055d 67
    push hl             ;055e e5
    ld a,21h            ;055f 3e 21
l0561h:
    call mw_sub_05c0h   ;0561 cd c0 05
    call mw_sub_05f9h   ;0564 cd f9 05
    call mw_sub_05ddh   ;0567 cd dd 05
    pop hl              ;056a e1
    jr nz,l05bbh        ;056b 20 4e
    ld a,41h            ;056d 3e 41
    call mw_sub_05c0h   ;056f cd c0 05
    ld b,00h            ;0572 06 00
l0574h:
    in a,(corvus)       ;0574 db 18
    ld (hl),a           ;0576 77
l0577h:
    inc hl              ;0577 23
    ex (sp),hl          ;0578 e3
    ex (sp),hl          ;0579 e3
    djnz l0574h         ;057a 10 f8
    call mw_sub_05ddh   ;057c cd dd 05
    ret z               ;057f c8
    jp l05bbh           ;0580 c3 bb 05

mw_write:
    ld (var_4),hl       ;0583 22 32 06
    xor a               ;0586 af
    ld (hl),a           ;0587 77
    inc hl              ;0588 23
    ld (hl),a           ;0589 77
    ld (var_3),a        ;058a 32 31 06
    ld a,(de)           ;058d 1a
l058eh:
    ld (var_1),a        ;058e 32 2f 06
    inc de              ;0591 13
    ld a,(de)           ;0592 1a
    ld (var_2),a        ;0593 32 30 06
l0596h:
    ld a,(bc)           ;0596 0a
    ld l,a              ;0597 6f
    inc bc              ;0598 03
    ld a,(bc)           ;0599 0a
    ld h,a              ;059a 67
    ld a,42h            ;059b 3e 42
    call mw_sub_05c0h   ;059d cd c0 05
    ld b,00h            ;05a0 06 00
l05a2h:
    ld a,(hl)           ;05a2 7e
    out (corvus),a      ;05a3 d3 18
    inc hl              ;05a5 23
    ex (sp),hl          ;05a6 e3
    ex (sp),hl          ;05a7 e3
    djnz l05a2h         ;05a8 10 f8
    call mw_sub_05ddh   ;05aa cd dd 05
    jr nz,l05bbh        ;05ad 20 0c
    ld a,22h            ;05af 3e 22
    call mw_sub_05c0h   ;05b1 cd c0 05
    call mw_sub_05f9h   ;05b4 cd f9 05
    call mw_sub_05ddh   ;05b7 cd dd 05
    ret z               ;05ba c8
l05bbh:
    ld hl,(var_4)       ;05bb 2a 32 06
    ld (hl),a           ;05be 77
    ret                 ;05bf c9

mw_sub_05c0h:
    ld b,a              ;05c0 47
    xor a               ;05c1 af
    out (corvus),a      ;05c2 d3 18
l05c4h:
    in a,(corvus)       ;05c4 db 18
    cp 0a0h             ;05c6 fe a0
    jr nz,l05c4h        ;05c8 20 fa
    ld a,b              ;05ca 78
    out (corvus),a      ;05cb d3 18
l05cdh:
    in a,(corvus)       ;05cd db 18
    cp 0a1h             ;05cf fe a1
    jr nz,l05cdh        ;05d1 20 fa
    ld a,0ffh           ;05d3 3e ff
    out (corvus),a      ;05d5 d3 18
    ld b,14h            ;05d7 06 14
l05d9h:
    nop                 ;05d9 00
    djnz l05d9h         ;05da 10 fd
    ret                 ;05dc c9

mw_sub_05ddh:
    ld a,0ffh           ;05dd 3e ff
    out (corvus),a      ;05df d3 18
l05e1h:
    in a,(corvus)       ;05e1 db 18
    inc a               ;05e3 3c
    jr nz,l05e1h        ;05e4 20 fb
    ld a,0feh           ;05e6 3e fe
    out (corvus),a      ;05e8 d3 18
l05eah:
    in a,(corvus)       ;05ea db 18
    rla                 ;05ec 17
    jr c,l05eah         ;05ed 38 fb
    in a,(corvus)       ;05ef db 18
    bit 6,a             ;05f1 cb 77
    push af             ;05f3 f5
    xor a               ;05f4 af
    out (corvus),a      ;05f5 d3 18
    pop af              ;05f7 f1
    ret                 ;05f8 c9

mw_sub_05f9h:
    xor a               ;05f9 af
    out (corvus),a      ;05fa d3 18
    ld hl,(var_1)       ;05fc 2a 2f 06
    ld a,(var_3)        ;05ff 3a 31 06
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
    out (corvus),a      ;0610 d3 18
l0612h:
    srl h               ;0612 cb 3c
    rr l                ;0614 cb 1d
    srl b               ;0616 cb 38
    jr nz,l0612h        ;0618 20 f8
    ld a,l              ;061a 7d
    out (corvus),a      ;061b d3 18
    ld a,h              ;061d 7c
    out (corvus),a      ;061e d3 18
    ld a,(var_1)        ;0620 3a 2f 06
    and 1fh             ;0623 e6 1f
    out (corvus),a      ;0625 d3 18
    xor a               ;0627 af
    out (corvus),a      ;0628 d3 18
    out (corvus),a      ;062a d3 18
    out (corvus),a      ;062c d3 18
    ret                 ;062e c9

var_1:
    db 20h
var_2:
    db 02h
var_3:
    db 21h
var_4:
    dw 0

; Start of KLIB.REL =========================================================

; XSTRIN --------------------------------------------------------------------

tmp:
    db 0c9h             ;header: string length
    dw 50cdh            ;header: start address of string
    db 20h, 06h         ;string data (not at start address ??)

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
l069fh:
    ld a,(hl)
    call conout
    dec b
    inc hl
    jp nz,l069fh
    ret

; MUL1 ----------------------------------------------------------------------

imug:
;MUL1: IMUG
    ld b,h
    ld c,l
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push hl
    ld l,c
    ld h,b

imuh:
;MUL1: IMUH
    ld a,h
    or l
    ret z
    ex de,hl
    ld a,h
    or l
    ret z
    ld b,h
    ld c,l
    ld hl,0000h
    ld a,10h
l06c1h:
    add hl,hl
    ex de,hl
    add hl,hl
    ex de,hl
    jp nc,l06c9h
    add hl,bc
l06c9h:
    dec a
    jp nz,l06c1h
    ret

; N16 -----------------------------------------------------------------------

sub_06ceh:
    call sub_06e5h

pv0c:
pv1c:
;N16: PV0C and PV1C
    ld a,20h
    call conout
    ret

pv2c:
;N16: PV2C
    call sub_06e5h
    ld a,0ah
    call conout
    ld a,0dh
    call conout
    ret

sub_06e5h:
    push hl
    ld a,h
    and 80h
    jp z,l06f8h
    ld a,l
    cpl
    ld l,a
    ld a,h
    cpl
    ld h,a
    inc hl
    ld a,2dh
    call conout
l06f8h:
    ld c,'0'
    ld de,10000
    call sub_071ah
    ld de,1000
    call sub_071ah
    ld de,100
    call sub_071ah
    ld de,10
    call sub_071ah
    ld de,1
    call sub_071ah
    pop hl
    ret

sub_071ah:
    call sub_072ch
    jp c,l0724h
    inc c
    jp sub_071ah

l0724h:
    ld a,c
    call conout
    add hl,de
    ld c,30h
    ret

sub_072ch:
    ld a,l
    sub e
    ld l,a
    ld a,h
    sbc a,d
    ld h,a
    ret

; XXXLIB --------------------------------------------------------------------

end:
;XXXLIB: $END
;Jump to CP/M warm start
;Implements BASIC command: END
    jp warm

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
    ld hl,0fffeh
    jp conin

conout:
;CPMIO: CONOUT
;Write the char in A to the console
    push hl
    push de
    push bc
    push af
    ld c,02h
    ld e,a
    call bdos
    pop af
    pop bc
    pop de
    pop hl

pr0a:
;CPMIO: $PR0A
;Do nothing and return
    ret

conin:
;CPMIO: CONIN
    push de
    push bc
    push hl
    ld c,01h
    call bdos
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

    call conout         ;0761 cd 3e 07
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
    call conout         ;0775 cd 3e 07
    ld c,30h            ;0778 0e 30
    ld de,2710h         ;077a 11 10 27
    call sub_071ah      ;077d cd 1a 07

; End of KLIB.REL ===========================================================
