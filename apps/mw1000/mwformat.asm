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

check_error:
    ;IF (l0c3ch AND &H40) <> 0 THEN GOTO got_error
    ld a,(l0c3ch)
    and 40h
    jp nz,got_error

    ;RETURN
    ret

got_error:
    ;PRINT "DRIVE ERROR #";
    ld bc,drive_err_n
    call print_str

    ;IF l0c3ch <> &H40 THEN GOTO is_err_42h
    ld a,(l0c3ch)
    cp 40h
    jp nz,is_err_42h

    ;PRINT "40 - header write error";
    ld bc,e40_head_writ
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_42h:
    ;IF l0c3ch <> &H42 THEN GOTO is_err_44h
    ld a,(l0c3ch)
    cp 42h
    jp nz,is_err_44h

    ;PRINT "42 - header read error";
    ld bc,e42_head_read
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_44h:
    ;IF l0c3ch <> &H44 THEN GOTO is_err_46h
    ld a,(l0c3ch)
    cp 44h
    jp nz,is_err_46h

    ;PRINT "44 - data read error";
    ld bc,e44_data_read
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_46h:
    ;IF l0c3ch <> &H46 THEN GOTO is_err_47h
    ld a,(l0c3ch)
    cp 46h
    jp nz,is_err_47h

    ;PRINT "46 - write fault";
    ld bc,e46_writ_flt
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_47h:
    ;IF l0c3ch <> &H47 THEN GOTO is_err_49h
    ld a,(l0c3ch)
    cp 47h
    jp nz,is_err_49h

    ;PRINT "47 - disk not ready";
    ld bc,e47_not_ready
    call print_str

    ;GOTO got_error_done
    jp got_error_done

is_err_49h:
    ;IF l0c3ch <> &H49 THEN GOTO unknown_err
    ld a,(l0c3ch)
    cp 49h
    jp nz,unknown_err

    ;PRINT "49 - illegal command";
    ld bc,e49_illegal
    call print_str

    ;GOTO got_error_done
    jp got_error_done

unknown_err:
    ;PRINT "xx - unknown error code";
    ld bc,exx_unknown
    call print_str

got_error_done:
    ;PRINT
    call print_eol

    ;RETURN
    ret

readline:
    ld hl,l0c4dh        ;01f2 21 4d 0c
    ld (hl),80h         ;01f5 36 80
    ld de,l0c4dh        ;01f7 11 4d 0c
    ld c,0ah            ;01fa 0e 0a
    call 0005h          ;01fc cd 05 00
    ;PRINT
    call print_eol      ;01ff cd 93 02
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
    call l0aech         ;025d cd ec 0a
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

print_char:
;Print character in C
    ld hl,l0cd1h
    ld (hl),c
    ld c,02h
    ld a,(l0cd1h)
    ld e,a
    call 0005h
    ret

print_eol:
;Print end of line (CR+LF)
    ld c,0dh
    call print_char
    ld c,0ah
    call print_char
    ret

print_str:
;Print string at BC
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
    call print_char     ;02b6 cd 85 02
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
    call print_char     ;02f5 cd 85 02
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

    ;PRINT "0";
    ld bc,zero
    call print_str

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

    ;PRINT "-";
    ld bc,dash
    call print_str

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
    call print_char     ;0380 cd 85 02
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

ask_drv_typ:
    ;PRINT CHR$(26) ' Clear screen
    ld c,1ah
    call print_char

    ;PRINT "SoftBox Mini-Winchester Format Program"
    ld bc,format_prog
    call print_str
    call print_eol

    ;PRINT "------- ---- ---------- ------ -------"
    ld bc,dashes
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Revision 2.1"
    ld bc,rev_21
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "WARNING - use of this program will destroy "
    ld bc,warning
    call print_str
    call print_eol

    ;PRINT "destroy any existing data on the"
    ld bc,destroy
    call print_str
    call print_eol

    ;PRINT "hard disk."
    ld bc,hard_disk
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Drive sizes supported : "
    ld bc,drive_sizes
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "A.   3  Mbyte      (191 cyl)"
    ld bc,drv_a_3mb
    call print_str
    call print_eol

    ;PRINT "B.   6  Mbyte      (191 cyl)"
    ld bc,drv_b_6mb
    call print_str
    call print_eol

    ;PRINT "C.   12 Mbyte      (191 cyl)"
    ld bc,drv_c_12mb
    call print_str
    call print_eol

    ;PRINT "D.   5  Mbyte      (320 cyl)"
    ld bc,drv_d_5mb
    call print_str
    call print_eol

    ;PRINT "E.   10 Mbyte      (320 cyl)"
    ld bc,drv_e_10mb
    call print_str
    call print_eol

    ;PRINT "F.   15 Mbyte      (320 cyl)"
    ld bc,drv_f_15mb
    call print_str
    call print_eol

    ;PRINT "Z.   None of the above"
    ld bc,drv_z_other
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Which drive type (A-Z) ? ";
    ld bc,which_type
    call print_str

    ;GOSUB readline
    call readline

    ;IF l0c3fh <> &H41 THEN GOTO is_drv_type_b
    ld a,(l0c3fh)
    cp 'A'              ;Is it 'A': 3 Mbyte (191 cyl)?
    jp nz,is_drv_type_b ;  No: jump to check for 'B'

    ld hl,l0c3dh        ;044d 21 3d 0c
    ld (hl),02h         ;0450 36 02
    ld hl,00bfh         ;0452 21 bf 00
    ld (l0c40h),hl      ;0455 22 40 0c

    ;GOTO got_drv_type
    jp got_drv_type

is_drv_type_b:
    ;IF l0c3fh <> &H42 THEN GOTO is_drv_type_c
    ld a,(l0c3fh)
    cp 'B'              ;Is it 'B': 6 Mbyte (191 cyl)?
    jp nz,is_drv_type_c ;  No: jump to check for 'C'

    ld hl,l0c3dh        ;0463 21 3d 0c
    ld (hl),04h         ;0466 36 04
    ld hl,00bfh         ;0468 21 bf 00
    ld (l0c40h),hl      ;046b 22 40 0c

    ;GOTO got_drv_type
    jp got_drv_type

is_drv_type_c:
    ;IF l0c3fh <> &H43 THEN GOTO is_drv_type_d
    ld a,(l0c3fh)
    cp 'C'              ;Is it 'C': 12 Mbyte (191 cyl)?
    jp nz,is_drv_type_d ;  No: jump to check for 'D'

    ld hl,l0c3dh        ;0479 21 3d 0c
    ld (hl),08h         ;047c 36 08
    ld hl,00bfh         ;047e 21 bf 00
    ld (l0c40h),hl      ;0481 22 40 0c

    ;GOTO got_drv_type
    jp got_drv_type

is_drv_type_d:
    ;IF l0c3fh <> &H44 THEN GOTO is_drv_type_e
    ld a,(l0c3fh)
    cp 'D'              ;Is it 'D': 5 Mbyte (320 cyl)?
    jp nz,is_drv_type_e ;  No: jump to check for 'E'

    ld hl,l0c3dh        ;048f 21 3d 0c
    ld (hl),02h         ;0492 36 02
    ld hl,l0140h        ;0494 21 40 01
    ld (l0c40h),hl      ;0497 22 40 0c

    ;GOTO got_drv_type
    jp got_drv_type

is_drv_type_e:
    ;IF l0c3fh <> &H45 THEN GOTO is_drv_type_f
    ld a,(l0c3fh)
    cp 'E'              ;Is it 'E': 10 Mbyte (320 cyl)?
    jp nz,is_drv_type_f ;  No: jump to check for 'F'

    ld hl,l0c3dh        ;04a5 21 3d 0c
    ld (hl),04h         ;04a8 36 04
    ld hl,l0140h        ;04aa 21 40 01
    ld (l0c40h),hl      ;04ad 22 40 0c

    ;GOTO got_drv_type
    jp got_drv_type

is_drv_type_f:
    ;IF l0c3fh <> &H46 THEN GOTO is_drv_type_z
    ld a,(l0c3fh)
    cp 'F'              ;Is it 'F': 15 Mbyte (320 cyl)?
    jp nz,is_drv_type_z ;  No: jump to check for 'Z'

    ld hl,l0c3dh        ;04bb 21 3d 0c
    ld (hl),06h         ;04be 36 06
    ld hl,l0140h        ;04c0 21 40 01
    ld (l0c40h),hl      ;04c3 22 40 0c

    ;GOTO got_drv_type
    jp got_drv_type

is_drv_type_z:
    ;IF l0c3fh <> &H5A THEN GOTO bad_drv_type
    ld a,(l0c3fh)
    cp 'Z'              ;Is it 'Z': None of the above?
    jp nz,bad_drv_type  ;  No: bad drive type entered

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "How many heads ? ";
    ld bc,num_heads
    call print_str

    ;GOSUB readline
    call readline

    ld a,(l0c48h)       ;04e0 3a 48 0c
    ld (l0c3dh),a       ;04e3 32 3d 0c

    ;PRINT
    call print_eol

    ;PRINT "How many cylinders ? ";
    ld bc,num_cylinders
    call print_str

    ;GOSUB readline
    call readline

    ld hl,(l0c48h)      ;04f2 2a 48 0c
    ld (l0c40h),hl      ;04f5 22 40 0c

    ;GOTO got_drv_type
    jp got_drv_type

bad_drv_type:
    ;GOTO ask_drv_typ
    jp ask_drv_typ

got_drv_type:
    ;PRINT CHR$(26) ' Clear screen
    ld c,1ah
    call print_char

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Drive has ";
    ld bc,drive_has
    call print_str

    ld a,(l0c3dh)       ;050f 3a 3d 0c
    ld l,a              ;0512 6f
    rla                 ;0513 17
    sbc a,a             ;0514 9f
    ld b,a              ;0515 47
    ld c,l              ;0516 4d
    call sub_02feh      ;0517 cd fe 02

    ;PRINT " heads and ";
    ld bc,heads_and
    call print_str

    ld hl,(l0c40h)      ;0520 2a 40 0c
    ld b,h              ;0523 44
    ld c,l              ;0524 4d
    call sub_02feh      ;0525 cd fe 02

    ;PRINT " cylinders."
    ld bc,cylinders
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "The formatted capacity is "
    ld bc,capacity_is
    call print_str

    ld a,(l0c3dh)       ;053a 3a 3d 0c
    ld l,a              ;053d 6f
    rla                 ;053e 17
    sbc a,a             ;053f 9f
    ld b,a              ;0540 47
    ld c,l              ;0541 4d
    ld hl,(l0c40h)      ;0542 2a 40 0c
    ex de,hl            ;0545 eb
    call l0aech         ;0546 cd ec 0a
    ex de,hl            ;0549 eb
    add hl,hl           ;054a 29
    add hl,hl           ;054b 29
    add hl,hl           ;054c 29
    ld b,h              ;054d 44
    ld c,l              ;054e 4d
    call sub_02feh      ;054f cd fe 02

    ;PRINT " Kbytes.";
    ld bc,kbytes
    call print_str

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

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Format all surfaces (Y/N) ? ";
    ld bc,all_surfaces
    call print_str

    ;GOSUB readline
    call readline

    ;IF l0c3fh <> &H4E THEN GOTO l064bh
    ld a,(l0c3fh)
    cp 'N'
    jp nz,l064bh

l0583h:
    ;PRINT
    call print_eol

    ;PRINT "Format which surface (0 to ";
    ld bc,which_surface
    call print_str

    ld a,(l0c3dh)       ;058c 3a 3d 0c
    ld l,a              ;058f 6f
    rla                 ;0590 17
    sbc a,a             ;0591 9f
    ld h,a              ;0592 67
    dec hl              ;0593 2b
    ld b,h              ;0594 44
    ld c,l              ;0595 4d
    call sub_02feh      ;0596 cd fe 02

    ;PRINT ") ? ";
    ld bc,p_q_1
    call print_str

    ;GOSUB readline
    call readline

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
    ;PRINT "??"
    ld bc,q_q_1
    call print_str
    call print_eol

    ;GOTO l0583h
    jp l0583h

l05c7h:
    ld a,(l0c48h)       ;05c7 3a 48 0c
    ld (l0c3eh),a       ;05ca 32 3e 0c

l05cdh:
    ;PRINT
    call print_eol

    ;PRINT "Format all tracks on surface #";
    ld bc,all_tracks_on
    call print_str

    ld a,(l0c3eh)       ;05d6 3a 3e 0c
    ld l,a              ;05d9 6f
    rla                 ;05da 17
    sbc a,a             ;05db 9f
    ld b,a              ;05dc 47
    ld c,l              ;05dd 4d
    call sub_02feh      ;05de cd fe 02

    ;PRINT " ? ";
    ld bc,q_1
    call print_str

    ;GOSUB readline
    call readline

    ;IF l0c3fh <> &H4E THEN GOTO l0637h
    ld a,(l0c3fh)
    cp 'N'
    jp nz,l0637h

l05f2h:
    ;PRINT
    call print_eol

    ;PRINT "Format which track (0 to ";
    ld bc,which_track
    call print_str

    ld hl,(l0c40h)      ;05fb 2a 40 0c
    dec hl              ;05fe 2b
    ld b,h              ;05ff 44
    ld c,l              ;0600 4d
    call sub_02feh      ;0601 cd fe 02

    ;PRINT ") ? ";
    ld bc,p_q_2
    call print_str

    ;GOSUB readline
    call readline

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
    ;PRINT "??"
    ld bc,q_q_2
    call print_str
    call print_eol

    jp l05f2h           ;062b c3 f2 05
l062eh:
    ld hl,(l0c48h)      ;062e 2a 48 0c
    ld (l0c42h),hl      ;0631 22 42 0c
    jp l0648h           ;0634 c3 48 06
l0637h:
    ld a,(l0c3fh)       ;0637 3a 3f 0c
    cp 'Y'              ;063a fe 59
    jp z,l0648h         ;063c ca 48 06

    ;PRINT "Please answer Y or N : ";
    ld bc,pls_yn_1
    call print_str

    jp l05cdh           ;0645 c3 cd 05
l0648h:
    jp l065ch           ;0648 c3 5c 06
l064bh:
    ld a,(l0c3fh)       ;064b 3a 3f 0c
    cp 'Y'              ;064e fe 59
    jp z,l065ch         ;0650 ca 5c 06

    ;PRINT "Please answer Y or N : ";
    ld bc,pls_yn_2
    call print_str

    jp l0558h           ;0659 c3 58 05
l065ch:
    ;PRINT "Press return to format disk,"
    ld bc,press_return
    call print_str
    call print_eol

    ;PRINT "press control-C to abort ... ";
    ld bc,press_ctrl_c
    call print_str

    ;GOSUB readline
    call readline

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

    ;GOSUB check_error
    call check_error

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Formatting ...";
    ld bc,formatting
    call print_str

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

    ;GOSUB check_error
    call check_error

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Format complete."
    ld bc,complete
    call print_str
    call print_eol

    call sub_0103h      ;071f cd 03 01

drive_err_n:
    db 0dh
    db "DRIVE ERROR #"
e40_head_writ:
    db 17h
    db "40 - header write error"
e42_head_read:
    db 16h
    db "42 - header read error"
e44_data_read:
    db 14h
    db "44 - data read error"
e46_writ_flt:
    db 10h
    db "46 - write fault"
e47_not_ready:
    db 13h
    db "47 - disk not ready"
e49_illegal:
    db 14h
    db "49 - illegal command"
exx_unknown:
    db 17h
    db "xx - unknown error code"
zero:
    db 01h
    db "0"
dash:
    db 01h
    db "-"
format_prog:
    db 26h
    db "SoftBox Mini-Winchester Format Program"
dashes:
    db 26h
    db "------- ---- ---------- ------ -------"
rev_21:
    db 0ch
    db "Revision 2.1"
warning:
    db 22h
    db "WARNING - use of this program will"
destroy:
    db 20h
    db "destroy any existing data on the"
hard_disk:
    db 0ah
    db "hard disk."
drive_sizes:
    db 18h
    db "Drive sizes supported : "
drv_a_3mb:
    db 1ch
    db "A.   3  Mbyte      (191 cyl)"
drv_b_6mb:
    db 1ch
    db "B.   6  Mbyte      (191 cyl)"
drv_c_12mb:
    db 1ch
    db "C.   12 Mbyte      (191 cyl)"
drv_d_5mb:
    db 1ch
    db "D.   5  Mbyte      (320 cyl)"
drv_e_10mb:
    db 1ch
    db "E.   10 Mbyte      (320 cyl)"
drv_f_15mb:
    db 1ch
    db "F.   15 Mbyte      (320 cyl)"
drv_z_other:
    db 16h
    db "Z.   None of the above"
which_type:
    db 19h
    db "Which drive type (A-Z) ? "
num_heads:
    db 11h
    db "How many heads ? "
num_cylinders:
    db 15h
    db "How many cylinders ? "
drive_has:
    db 0ah
    db "Drive has "
heads_and:
    db 0bh
    db " heads and "
cylinders:
    db 0bh
    db " cylinders."
capacity_is:
    db 1ah
    db "The formatted capacity is "
kbytes:
    db 08h
    db " Kbytes."
all_surfaces:
    db 1ch
    db "Format all surfaces (Y/N) ? "
which_surface:
    db 1bh
    db "Format which surface (0 to "
p_q_1:
    db 04h
    db ") ? "
q_q_1:
    db 02h
    db "??"
all_tracks_on:
    db 1eh
    db "Format all tracks on surface #"
q_1:
    db 03h
    db " ? "
which_track:
    db 19h
    db "Format which track (0 to "
p_q_2:
    db 04h
    db ") ? "
q_q_2:
    db 02h
    db "??"
pls_yn_1:
    db 17h
    db "Please answer Y or N : "
pls_yn_2:
    db 17h
    db "Please answer Y or N : "
press_return:
    db 1ch
    db "Press return to format disk,"
press_ctrl_c:
    db 1dh
    db "press control-C to abort ... "
formatting:
    db 0eh
    db "Formatting ..."
complete:
    db 10h
    db "Format complete."

l0aech:
    xor a               ;0aec af
    ld h,a              ;0aed 67
    add a,b             ;0aee 80
    jp m,l0af9h         ;0aef fa f9 0a
    or c                ;0af2 b1
    jp z,l0b44h         ;0af3 ca 44 0b
    jp l0b00h           ;0af6 c3 00 0b
l0af9h:
    inc h               ;0af9 24
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
    jp l0b13h           ;0b09 c3 13 0b
l0b0ch:
    inc h               ;0b0c 24
    cpl                 ;0b0d 2f
    ld d,a              ;0b0e 57
    ld a,e              ;0b0f 7b
    cpl                 ;0b10 2f
    ld e,a              ;0b11 5f
    inc de              ;0b12 13
l0b13h:
    push hl             ;0b13 e5
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
