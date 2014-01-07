;MWFORMAT.COM
;  Low-level format a hard disk on the MW-1000.
;
;This program was not written in assembly language.  It was written
;in a high level language but the compiler is unknown.  This is a
;disassembly of the compiled program.
;

corvus:        equ  18h   ;Corvus data bus

warm:          equ  0000h ;Warm start entry point
bdos:          equ  0005h ;BDOS entry point

cwrite:        equ 02h    ;Console Output
creadstr:      equ 0ah    ;Buffered Console Input

bell:          equ 07h    ;Bell
lf:            equ 0ah    ;Line Feed
cr:            equ 0dh    ;Carriage Return
cls:           equ 1ah    ;Clear Screen

    org 0100h

    jp start

end:
;Exit back to CP/M.
    jp warm             ;Jump to CP/M warm start
    ret

corvus_out:
;Write the value C to port corvus
    ld hl,l0c4ah        ;0107 21 4a 0c
    ld (hl),c           ;010a 71
    ld a,(l0c4ah)       ;010b 3a 4a 0c
    out (corvus),a      ;010e d3 18
    ret                 ;0110 c9

corvus_in:
;Read value from port corvus to A
    in a,(corvus)       ;0111 db 18
    ret                 ;0113 c9

    ld a,00h            ;0114 3e 00
    ret                 ;0116 c9
    ret                 ;0117 c9

mw_comout:
;Send the command in A to the Konan David Junior II controller.
;
    ld hl,l0c4bh
    ld (hl),c           ;Save command
    ld c,00h
    call corvus_out     ;Clear David Junior II port
mw_rdy1:
    call corvus_in
    cp 0a0h
    jp nz,mw_rdy1       ;Wait for David Junior II to go ready
    ld hl,l0c4bh
    ld c,(hl)           ;Recall command
    call corvus_out     ;Send command
mw_rdy2:
    call corvus_in
    cp 0a1h
    jp nz,mw_rdy2       ;Wait until the David Junior II has it
    ld c,0ffh
    call corvus_out     ;Send execute code
    ld hl,l0c4ch
    ld (hl),01h
    jp l0149h
mw_rdy3:
    ld hl,l0c4ch
    inc (hl)
l0149h:
    ld a,(l0c4ch)
    cp 15h
    jp m,mw_rdy3        ;Delay loop
    ret

mw_status:
;Get status from the Konan David Junior II, return it in A.
;
    ld c,0ffh
    call corvus_out     ;Transfer done
l0157h:
    call corvus_in
    cp 0ffh
    jp nz,l0157h        ;Wait for David Junior II to get out
                        ;  of internal DMA mode
    ld c,0feh
    call corvus_out     ;Signal that we are ready for status
l0164h:
    call corvus_in
    and 80h
    jp nz,l0164h        ;Wait for status

    call corvus_in      ;Read status byte
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
    ;buff_size = 128
    ld hl,buff_size
    ld (hl),80h

    ld de,buffer        ;01f7 11 4d 0c
    ld c,creadstr       ;01fa 0e 0a
    call bdos           ;BDOS entry point

    ;PRINT
    call print_eol

    ;N = 0
    ld hl,0000h
    ld (nn),hl

    ;IF buff_len <> 0 THEN GOTO l0217h
    ld a,(buff_len)     ;0208 3a 4e 0c
    or a                ;020b b7
    jp nz,l0217h        ;020c c2 17 02

    ;R = 0
    ld hl,rr
    ld (hl),00h

    ;GOTO l0284h
    jp l0284h

l0217h:
    ;R = buff_data(0)
    ;IF R < &H61 OR R >= &H7B THEN GOTO l022eh
    ld a,(buff_data)    ;0217 3a 4f 0c
    ld (rr),a           ;021a 32 3f 0c
    cp 'a'              ;021d fe 61
    jp m,l022eh         ;021f fa 2e 02
    cp 'z'+1            ;0222 fe 7b
    jp p,l022eh         ;0224 f2 2e 02

    ;R = R - &H20
    ld hl,rr
    ld a,(hl)
    add a,0e0h
    ld (hl),a

l022eh:
    ;l0cd0h = 0
    ld hl,l0cd0h        ;022e 21 d0 0c
    ld (hl),00h         ;0231 36 00

l0233h:
    ;IF buff_data(l0cd0h) < &H30 THEN GOTO l0284h
    ld a,(l0cd0h)       ;0233 3a d0 0c
    ld l,a              ;0236 6f
    rla                 ;0237 17
    sbc a,a             ;0238 9f
    ld bc,buff_data     ;0239 01 4f 0c
    ld h,a              ;023c 67
    add hl,bc           ;023d 09
    ld a,(hl)           ;023e 7e
    cp '0'              ;023f fe 30
    jp m,l0284h         ;0241 fa 84 02

    ;IF buff_data(l0cd0h) >= &H3A THEN GOTO l0284h
    ld a,(l0cd0h)       ;0244 3a d0 0c
    ld l,a              ;0247 6f
    rla                 ;0248 17
    sbc a,a             ;0249 9f
    ld bc,buff_data     ;024a 01 4f 0c
    ld h,a              ;024d 67
    add hl,bc           ;024e 09
    ld a,(hl)           ;024f 7e
    cp '9'+1            ;0250 fe 3a
    jp p,l0284h         ;0252 f2 84 02

    ;N = buff_data(l0cd0h) - &H30 + N * 10
    ld hl,(nn)          ;0255 2a 48 0c
    ld b,h              ;0258 44
    ld c,l              ;0259 4d
    ld de,10            ;025a 11 0a 00
    call l0aech         ;025d cd ec 0a (Library MUL)
    ld a,(l0cd0h)       ;0260 3a d0 0c
    ld l,a              ;0263 6f
    rla                 ;0264 17
    sbc a,a             ;0265 9f
    ld bc,buff_data     ;0266 01 4f 0c
    ld h,a              ;0269 67
    add hl,bc           ;026a 09
    ld a,(hl)           ;026b 7e
    ld l,a              ;026c 6f
    rla                 ;026d 17
    sbc a,a             ;026e 9f
    ld bc,0-'0'         ;026f 01 d0 ff
    ld h,a              ;0272 67
    add hl,bc           ;0273 09
    add hl,de           ;0274 19
    ld (nn),hl          ;0275 22 48 0c

    ;l0cd0h = l0cd0h + 1
    ld hl,l0cd0h        ;0278 21 d0 0c
    inc (hl)            ;027b 34

    ;IF l0cd0h < buff_len THEN GOTO l0233h
    ld a,(hl)           ;027c 7e
    ld hl,buff_len      ;027d 21 4e 0c
    cp (hl)             ;0280 be
    jp m,l0233h         ;0281 fa 33 02

l0284h:
    ret                 ;0284 c9

print_char:
;Print character in C
    ld hl,l0cd1h
    ld (hl),c
    ld c,cwrite
    ld a,(l0cd1h)
    ld e,a
    call bdos           ;BDOS entry point
    ret

print_eol:
;Print end of line (CR+LF)
    ld c,cr
    call print_char
    ld c,lf
    call print_char
    ret

print_str:
;Print string at BC
    ld hl,l0cd2h+1      ;029e 21 d3 0c
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
    db 00h, 02h
    dw l0cd5h
    ld hl,l0cd5h+1      ;02ca 21 d6 0c
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
    ld de,10            ;02dd 11 0a 00
    call sub_0b48h      ;02e0 cd 48 0b (Library DIV)
    call sub_02c3h      ;02e3 cd c3 02
    ld hl,(l0cd5h)      ;02e6 2a d5 0c
    ld b,h              ;02e9 44
    ld c,l              ;02ea 4d
    ld de,10            ;02eb 11 0a 00
    call sub_0b48h      ;02ee cd 48 0b (Library DIV - HL=MOD)
    ld a,l              ;02f1 7d
    add a,'0'           ;02f2 c6 30
    ld c,a              ;02f4 4f
    call print_char     ;02f5 cd 85 02
l02f8h:
    call sub_0c17h      ;02f8 cd 17 0c
    db 02h
    dw l0cd5h

print_int:
    ld hl,l0cd7h+1      ;02fe 21 d8 0c
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

l031eh:
    ld hl,l0cd9h+1      ;031e 21 da 0c
    ld (hl),b           ;0321 70
    dec hl              ;0322 2b
    ld (hl),c           ;0323 71
    ld hl,(l0cd9h)      ;0324 2a d9 0c
    add hl,hl           ;0327 29
    jp nc,l0341h        ;0328 d2 41 03

    ;PRINT "-";
    ld bc,dash
    call print_str

    ;l0cd9h = -l0cd9h
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
    ;PRINT l0cd9h
    ld hl,(l0cd9h)      ;0341 2a d9 0c
    ld b,h              ;0344 44
    ld c,l              ;0345 4d
    call print_int      ;0346 cd fe 02
    ret                 ;0349 c9

l034ah:
    ld hl,l0cdbh+1      ;034a 21 dc 0c
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
    cp 10               ;0370 fe 0a
    jp m,l037ah         ;0372 fa 7a 03
    add a,'A'-10        ;0375 c6 37
    jp l037fh           ;0377 c3 7f 03

l037ah:
    ld a,(l0cdeh)       ;037a 3a de 0c
    add a,'0'           ;037d c6 30
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

start:
    ld hl,(0006h)       ;03a0 2a 06 00
    ld sp,hl            ;03a3 f9

ask_drv_type:
    ;PRINT CHR$(26); ' Clear screen
    ld c,cls
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

    ;IF R <> &H41 THEN GOTO is_drv_type_b
    ld a,(rr)
    cp 'A'              ;Is it 'A': 3 Mbyte (191 cyl)?
    jp nz,is_drv_type_b ;  No: jump to check for 'B'

    ;REM User selected 'A' for 3 Mbyte (191 cyl)

    ;heads = 2
    ld hl,heads
    ld (hl),2

    ;cylinders = 191
    ld hl,191
    ld (cylinders),hl

    ;GOTO got_drv_type
    jp got_drv_type

is_drv_type_b:
    ;IF R <> &H42 THEN GOTO is_drv_type_c
    ld a,(rr)
    cp 'B'              ;Is it 'B': 6 Mbyte (191 cyl)?
    jp nz,is_drv_type_c ;  No: jump to check for 'C'

    ;REM User selected 'B' for 6 Mbyte (191 cyl)

    ;heads = 4
    ld hl,heads
    ld (hl),4

    ;cylinders = 191
    ld hl,191
    ld (cylinders),hl

    ;GOTO got_drv_type
    jp got_drv_type

is_drv_type_c:
    ;IF R <> &H43 THEN GOTO is_drv_type_d
    ld a,(rr)
    cp 'C'              ;Is it 'C': 12 Mbyte (191 cyl)?
    jp nz,is_drv_type_d ;  No: jump to check for 'D'

    ;REM User selected 'C' for 12 Mbyte (191 cyl)

    ;heads = 8
    ld hl,heads
    ld (hl),8

    ;cylinders = 191
    ld hl,191
    ld (cylinders),hl

    ;GOTO got_drv_type
    jp got_drv_type

is_drv_type_d:
    ;IF R <> &H44 THEN GOTO is_drv_type_e
    ld a,(rr)
    cp 'D'              ;Is it 'D': 5 Mbyte (320 cyl)?
    jp nz,is_drv_type_e ;  No: jump to check for 'E'

    ;REM User selected 'D' for 5 Mbyte (320 cyl)

    ;heads = 2
    ld hl,heads
    ld (hl),2

    ;cylinders = 320
    ld hl,320
    ld (cylinders),hl

    ;GOTO got_drv_type
    jp got_drv_type

is_drv_type_e:
    ;IF R <> &H45 THEN GOTO is_drv_type_f
    ld a,(rr)
    cp 'E'              ;Is it 'E': 10 Mbyte (320 cyl)?
    jp nz,is_drv_type_f ;  No: jump to check for 'F'

    ;REM User selected 'E' for 10 Mbyte (320 cyl)

    ;heads = 4
    ld hl,heads
    ld (hl),4

    ;cylinders = 320
    ld hl,320
    ld (cylinders),hl

    ;GOTO got_drv_type
    jp got_drv_type

is_drv_type_f:
    ;IF R <> &H46 THEN GOTO is_drv_type_z
    ld a,(rr)
    cp 'F'              ;Is it 'F': 15 Mbyte (320 cyl)?
    jp nz,is_drv_type_z ;  No: jump to check for 'Z'

    ;REM User selected 'F' for 15 Mbyte (320 cyl)

    ;heads = 6
    ld hl,heads
    ld (hl),6

    ;cylinders = 320
    ld hl,320
    ld (cylinders),hl

    ;GOTO got_drv_type
    jp got_drv_type

is_drv_type_z:
    ;IF R <> &H5A THEN GOTO bad_drv_type
    ld a,(rr)
    cp 'Z'              ;Is it 'Z': None of the above?
    jp nz,bad_drv_type  ;  No: bad drive type entered

    ;REM User selected 'Z' for arbitrary heads/cylinders

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "How many heads ? ";
    ld bc,num_heads
    call print_str

    ;GOSUB readline
    call readline

    ;heads = N
    ld a,(nn)
    ld (heads),a

    ;PRINT
    call print_eol

    ;PRINT "How many cylinders ? ";
    ld bc,num_cylinders
    call print_str

    ;GOSUB readline
    call readline

    ;cylinders = N
    ld hl,(nn)
    ld (cylinders),hl

    ;GOTO got_drv_type
    jp got_drv_type

bad_drv_type:
    ;GOTO ask_drv_type
    jp ask_drv_type

got_drv_type:
    ;PRINT CHR$(26); ' Clear screen
    ld c,cls
    call print_char

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Drive has ";
    ld bc,drive_has
    call print_str

    ;PRINT heads;
    ld a,(heads)        ;050f 3a 3d 0c
    ld l,a              ;0512 6f
    rla                 ;0513 17
    sbc a,a             ;0514 9f
    ld b,a              ;0515 47
    ld c,l              ;0516 4d
    call print_int      ;0517 cd fe 02

    ;PRINT " heads and ";
    ld bc,heads_and
    call print_str

    ;PRINT cylinders;
    ld hl,(cylinders)   ;0520 2a 40 0c
    ld b,h              ;0523 44
    ld c,l              ;0524 4d
    call print_int      ;0525 cd fe 02

    ;PRINT " cylinders."
    ld bc,cylinders_
    call print_str
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "The formatted capacity is ";
    ld bc,capacity_is
    call print_str

    ;PRINT cylinder*heads*8;
    ld a,(heads)        ;053a 3a 3d 0c
    ld l,a              ;053d 6f
    rla                 ;053e 17
    sbc a,a             ;053f 9f
    ld b,a              ;0540 47
    ld c,l              ;0541 4d
    ld hl,(cylinders)   ;0542 2a 40 0c
    ex de,hl            ;0545 eb
    call l0aech         ;0546 cd ec 0a (Library MUL)
    ex de,hl            ;0549 eb
    add hl,hl           ;054a 29
    add hl,hl           ;054b 29
    add hl,hl           ;054c 29
    ld b,h              ;054d 44
    ld c,l              ;054e 4d
    call print_int      ;054f cd fe 02

    ;PRINT " Kbytes.";
    ld bc,kbytes
    call print_str

l0558h:
    ;l0c3eh = (heads-1) OR &H80
    ld a,(heads)        ;0558 3a 3d 0c
    dec a               ;055b 3d
    or 80h              ;055c f6 80
    ld (l0c3eh),a       ;055e 32 3e 0c

    ;l0c42h = (cylinders-1) OR &H8000
    ld hl,(cylinders)   ;0561 2a 40 0c
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

    ;IF R <> &H4E THEN GOTO l064bh
    ld a,(rr)
    cp 'N'
    jp nz,l064bh

l0583h:
    ;PRINT
    call print_eol

    ;PRINT "Format which surface (0 to ";
    ld bc,which_surface
    call print_str

    ;PRINT heads-1;
    ld a,(heads)        ;058c 3a 3d 0c
    ld l,a              ;058f 6f
    rla                 ;0590 17
    sbc a,a             ;0591 9f
    ld h,a              ;0592 67
    dec hl              ;0593 2b
    ld b,h              ;0594 44
    ld c,l              ;0595 4d
    call print_int      ;0596 cd fe 02

    ;PRINT ") ? ";
    ld bc,p_q_1
    call print_str

    ;GOSUB readline
    call readline

    ;IF N < 0 THEN GOTO l05bbh
    ld hl,(nn)          ;05a2 2a 48 0c
    add hl,hl           ;05a5 29
    jp c,l05bbh         ;05a6 da bb 05

    ;IF N < heads THEN GOTO l05c7h
    ld a,(heads)        ;05a9 3a 3d 0c
    ld l,a              ;05ac 6f
    rla                 ;05ad 17
    sbc a,a             ;05ae 9f
    ex de,hl            ;05af eb
    ld hl,(nn)          ;05b0 2a 48 0c
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
    ;l0c3eh = N
    ld a,(nn)           ;05c7 3a 48 0c
    ld (l0c3eh),a       ;05ca 32 3e 0c

l05cdh:
    ;PRINT
    call print_eol

    ;PRINT "Format all tracks on surface #";
    ld bc,all_tracks_on
    call print_str

    ;PRINT l0c3eh;
    ld a,(l0c3eh)       ;05d6 3a 3e 0c
    ld l,a              ;05d9 6f
    rla                 ;05da 17
    sbc a,a             ;05db 9f
    ld b,a              ;05dc 47
    ld c,l              ;05dd 4d
    call print_int      ;05de cd fe 02

    ;PRINT " ? ";
    ld bc,q_1
    call print_str

    ;GOSUB readline
    call readline

    ;IF R <> &H4E THEN GOTO l0637h
    ld a,(rr)
    cp 'N'
    jp nz,l0637h

l05f2h:
    ;PRINT
    call print_eol

    ;PRINT "Format which track (0 to ";
    ld bc,which_track
    call print_str

    ;PRINT cylinders-1;
    ld hl,(cylinders)   ;05fb 2a 40 0c
    dec hl              ;05fe 2b
    ld b,h              ;05ff 44
    ld c,l              ;0600 4d
    call print_int      ;0601 cd fe 02

    ;PRINT ") ? ";
    ld bc,p_q_2
    call print_str

    ;GOSUB readline
    call readline

    ;IF N < 0 THEN GOTO l0622h
    ld hl,(nn)          ;060d 2a 48 0c
    add hl,hl           ;0610 29
    jp c,l0622h         ;0611 da 22 06

    ;IF N < cylinders THEN GOTO l062eh
    ld hl,(nn)          ;0614 2a 48 0c
    ld a,l              ;0617 7d
    ex de,hl            ;0618 eb
    ld hl,(cylinders)   ;0619 2a 40 0c
    sub l               ;061c 95
    ld a,d              ;061d 7a
    sbc a,h             ;061e 9c
    jp m,l062eh         ;061f fa 2e 06

l0622h:
    ;PRINT "??"
    ld bc,q_q_2
    call print_str
    call print_eol

    ;GOTO l05f2h
    jp l05f2h

l062eh:
    ;l0c42h = N
    ld hl,(nn)          ;062e 2a 48 0c
    ld (l0c42h),hl      ;0631 22 42 0c

    ;GOTO l0648h
    jp l0648h

l0637h:
    ;IF R = 'Y' THEN GOTO l0648h
    ld a,(rr)
    cp 'Y'
    jp z,l0648h

    ;PRINT "Please answer Y or N : ";
    ld bc,pls_yn_1
    call print_str

    ;GOTO l05cdh
    jp l05cdh

l0648h:
    ;GOTO l065ch
    jp l065ch

l064bh:
    ;IF R = &H59 THEN GOTO l065ch
    ld a,(rr)
    cp 'Y'
    jp z,l065ch

    ;PRINT "Please answer Y or N : ";
    ld bc,pls_yn_2
    call print_str

    ;GOTO l0558h
    jp l0558h

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

    ;CALL mw_comout(&H42)
    ld c,42h            ;A = 42h (Write Buffer)
    call mw_comout      ;Send command

                        ;Transfer xx bytes to David Junior II:
    ;l0c44h = 0
    ld hl,0000h         ;0673 21 00 00
    ld (l0c44h),hl      ;0676 22 44 0c

    ;GOTO l068ah
    jp l068ah           ;0679 c3 8a 06

l067ch:
    ;CALL corvus_out(l0c44h)
    ld hl,l0c44h        ;067c 21 44 0c
    ld c,(hl)           ;  Read data byte our buffer
    call corvus_out     ;  Write it to the David Junior II

    ;l0c44h = l0c44h + 1
    ld hl,(l0c44h)
    inc hl              ;  Increment buffer pointer
    ld (l0c44h),hl

l068ah:
    ;IF l0c44h < 32 THEN GOTO l067ch
    ld bc,-32           ;068a 01 e0 ff
    ld hl,(l0c44h)      ;068d 2a 44 0c
    add hl,bc           ;0690 09
    add hl,hl           ;0691 29
    jp c,l067ch         ;0692 da 7c 06

    ;l0c44h = 32
    ld hl,32            ;0695 21 20 00
    ld (l0c44h),hl      ;0698 22 44 0c

    ;GOTO l06aah
    jp l06aah           ;069b c3 aa 06

l069eh:
    ;CALL corvus_out(0)
    ld c,00h
    call corvus_out

    ;l0c44h = l0c44h + 1
    ld hl,(l0c44h)
    inc hl              ;  Increment buffer pointer
    ld (l0c44h),hl

l06aah:
    ;IF l0c44h < 512 THEN GOTO l069eh
    ld bc,-512          ;06aa 01 00 fe
    ld hl,(l0c44h)      ;06ad 2a 44 0c
    add hl,bc           ;06b0 09
    add hl,hl           ;06b1 29
    jp c,l069eh         ;06b2 da 9e 06

    ;GOSUB mw_status
    call mw_status      ;Read status

    ;GOSUB check_error
    call check_error

    ;PRINT
    call print_eol

    ;PRINT
    call print_eol

    ;PRINT "Formatting ...";
    ld bc,formatting
    call print_str

    ;CALL mw_comout(&H27)
    ld c,27h            ;06c7 0e 27
    call mw_comout      ;06c9 cd 18 01

    ;CALL corvus_out(0)
    ld c,00h            ;06cc 0e 00
    call corvus_out     ;06ce cd 07 01

    ;CALL corvus_out(l0c3eh)
    ld hl,l0c3eh        ;06d1 21 3e 0c
    ld c,(hl)           ;06d4 4e
    call corvus_out     ;06d5 cd 07 01

    ;CALL corvus_out(l0c42h AND &HFF) 'Low Byte
    ld hl,l0c42h        ;06d8 21 42 0c
    ld c,(hl)           ;06db 4e
    call corvus_out     ;06dc cd 07 01

    ;CALL corvus_out(l0c42h SHR 8) 'High Byte
    ld b,08h            ;06df 06 08
    ld hl,(l0c42h)      ;06e1 2a 42 0c
    jp l06eeh
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
    call corvus_out     ;06f3 cd 07 01

    ;CALL corvus_out(31)
    ld c,1fh            ;06f6 0e 1f
    call corvus_out     ;06f8 cd 07 01

    ;CALL corvus_out(0)
    ld c,00h            ;06fb 0e 00
    call corvus_out     ;06fd cd 07 01

    ;CALL corvus_out(0)
    ld c,00h            ;0700 0e 00
    call corvus_out     ;0702 cd 07 01

    ;CALL corvus_out(0)
    ld c,00h            ;0705 0e 00
    call corvus_out     ;0707 cd 07 01

    ;GOSUB mw_status
    call mw_status      ;070a cd 52 01

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

    ;END
    call end

drive_err_n:
    db drive_err_n_len
    db "DRIVE ERROR #"
drive_err_n_len: equ $-drive_err_n-1

e40_head_writ:
    db e40_head_writ_len
    db "40 - header write error"
e40_head_writ_len: equ $-e40_head_writ-1

e42_head_read:
    db e42_head_read_len
    db "42 - header read error"
e42_head_read_len: equ $-e42_head_read-1

e44_data_read:
    db e44_data_read_len
    db "44 - data read error"
e44_data_read_len: equ $-e44_data_read-1

e46_writ_flt:
    db e46_writ_flt_len
    db "46 - write fault"
e46_writ_flt_len: equ $-e46_writ_flt-1

e47_not_ready:
    db e47_not_ready_len
    db "47 - disk not ready"
e47_not_ready_len: equ $-e47_not_ready-1

e49_illegal:
    db e49_illegal_len
    db "49 - illegal command"
e49_illegal_len: equ $-e49_illegal-1

exx_unknown:
    db exx_unknown_len
    db "xx - unknown error code"
exx_unknown_len: equ $-exx_unknown-1

zero:
    db zero_len
    db "0"
zero_len: equ $-zero-1

dash:
    db dash_len
    db "-"
dash_len: equ $-dash-1

format_prog:
    db format_prog_len
    db "SoftBox Mini-Winchester Format Program"
format_prog_len: equ $-format_prog-1

dashes:
    db dashes_len
    db "------- ---- ---------- ------ -------"
dashes_len: equ $-dashes-1

rev_21:
    db rev_21_len
    db "Revision 2.1"
rev_21_len: equ $-rev_21-1

warning:
    db warning_len
    db "WARNING - use of this program will"
warning_len: equ $-warning-1

destroy:
    db destroy_len
    db "destroy any existing data on the"
destroy_len: equ $-destroy-1

hard_disk:
    db hard_disk_len
    db "hard disk."
hard_disk_len: equ $-hard_disk-1

drive_sizes:
    db drive_sizes_len
    db "Drive sizes supported : "
drive_sizes_len: equ $-drive_sizes-1

drv_a_3mb:
    db drv_a_3mb_len
    db "A.   3  Mbyte      (191 cyl)"
drv_a_3mb_len: equ $-drv_a_3mb-1

drv_b_6mb:
    db drv_b_6mb_len
    db "B.   6  Mbyte      (191 cyl)"
drv_b_6mb_len: equ $-drv_b_6mb-1

drv_c_12mb:
    db drv_c_12mb_len
    db "C.   12 Mbyte      (191 cyl)"
drv_c_12mb_len: equ $-drv_c_12mb-1

drv_d_5mb:
    db drv_d_5mb_len
    db "D.   5  Mbyte      (320 cyl)"
drv_d_5mb_len: equ $-drv_d_5mb-1

drv_e_10mb:
    db drv_e_10mb_len
    db "E.   10 Mbyte      (320 cyl)"
drv_e_10mb_len: equ $-drv_e_10mb-1

drv_f_15mb:
    db drv_f_15mb_len
    db "F.   15 Mbyte      (320 cyl)"
drv_f_15mb_len: equ $-drv_f_15mb-1

drv_z_other:
    db drv_z_other_len
    db "Z.   None of the above"
drv_z_other_len: equ $-drv_z_other-1

which_type:
    db which_type_len
    db "Which drive type (A-Z) ? "
which_type_len: equ $-which_type-1

num_heads:
    db num_heads_len
    db "How many heads ? "
num_heads_len: equ $-num_heads-1

num_cylinders:
    db num_cylinders_len
    db "How many cylinders ? "
num_cylinders_len: equ $-num_cylinders-1

drive_has:
    db drive_has_len
    db "Drive has "
drive_has_len: equ $-drive_has-1

heads_and:
    db heads_and_len
    db " heads and "
heads_and_len: equ $-heads_and-1

cylinders_:
    db cylinders__len
    db " cylinders."
cylinders__len: equ $-cylinders_-1

capacity_is:
    db capacity_is_len
    db "The formatted capacity is "
capacity_is_len: equ $-capacity_is-1

kbytes:
    db kbytes_len
    db " Kbytes."
kbytes_len: equ $-kbytes-1

all_surfaces:
    db all_surfaces_len
    db "Format all surfaces (Y/N) ? "
all_surfaces_len: equ $-all_surfaces-1

which_surface:
    db which_surface_len
    db "Format which surface (0 to "
which_surface_len: equ $-which_surface-1

p_q_1:
    db p_q_1_len
    db ") ? "
p_q_1_len: equ $-p_q_1-1

q_q_1:
    db q_q_1_len
    db "??"
q_q_1_len: equ $-q_q_1-1

all_tracks_on:
    db all_tracks_on_len
    db "Format all tracks on surface #"
all_tracks_on_len: equ $-all_tracks_on-1

q_1:
    db q_1_len
    db " ? "
q_1_len: equ $-q_1-1

which_track:
    db which_track_len
    db "Format which track (0 to "
which_track_len: equ $-which_track-1

p_q_2:
    db p_q_2_len
    db ") ? "
p_q_2_len: equ $-p_q_2-1

q_q_2:
    db q_q_2_len
    db "??"
q_q_2_len: equ $-q_q_2-1

pls_yn_1:
    db pls_yn_1_len
    db "Please answer Y or N : "
pls_yn_1_len: equ $-pls_yn_1-1

pls_yn_2:
    db pls_yn_2_len
    db "Please answer Y or N : "
pls_yn_2_len: equ $-pls_yn_2-1

press_return:
    db press_return_len
    db "Press return to format disk,"
press_return_len: equ $-press_return-1

press_ctrl_c:
    db press_ctrl_c_len
    db "press control-C to abort ... "
press_ctrl_c_len: equ $-press_ctrl_c-1

formatting:
    db formatting_len
    db "Formatting ..."
formatting_len: equ $-formatting-1

complete:
    db complete_len
    db "Format complete."
complete_len: equ $-complete-1

l0aech:                 ;Library MUL
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
    db 0
heads:
    db 0
l0c3eh:
    db 0
rr:
    db 0                ;First char of user input from any prompt
cylinders:
    dw 0
l0c42h:
    dw 0
l0c44h:
    dw 0

    nop                 ;0c46 00
    nop                 ;0c47 00

nn:
    dw 0                ;Integer parsed from user input
l0c4ah:
    db 0
l0c4bh:
    db 0
l0c4ch:
    db 0

buffer:                 ;User input buffer struct
buff_size:
    db 0                ;  Buffer size (contain 128) as byte
buff_len:
    db 0                ;  Used buffer length as byte
buff_data:              ;  128 bytes input buffer
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    db 0

l0cd0h:
    db 0
l0cd1h:
    db 0                ;TODO Used by print_char
l0cd2h:
    dw 0                ;TODO Used by print_str
l0cd4h:
    db 0                ;TODO Used by print_str
l0cd5h:
    dw 0                ;TODO Used by sub_02c3h
l0cd7h:
    dw 0                ;TODO Used by print_int
l0cd9h:
    dw 0
l0cdbh:
    dw 0
l0cddh:
    db 0
l0cdeh:
    db 0

    db 1ah
    db 1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah
    db 1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah,1ah
