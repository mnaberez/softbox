;DEVNUM.COM
;  Change the HardBox device number on the MW-1000.
;
;The MW-1000 stores the IEEE-488 primary address for its HardBox mode
;on the hard disk.  This is different than the original HardBox product
;where the address is configured with DIP switches.
;
;This program was not written in assembly language.  It was written
;in MBASIC and compiled with BASCOM.  This is a disassembly of
;the compiled program.
;

corvus:        equ  18h   ;Corvus data bus

warm:          equ  0000h ;Warm start entry point
bdos:          equ  0005h ;BDOS entry point

cread:         equ 01h    ;Console Input
cwrite:        equ 02h    ;Console Output
creadstr:      equ 0ah    ;Buffered Console Input

lf:            equ 0ah    ;Line Feed
cr:            equ 0dh    ;Carriage Return
cls:           equ 1ah    ;Clear Screen

    org 0100h

    jp start

unused_1:
    db 0,0,0,0,0,0,0

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
    ld bc,011ah         ;0133 01 1a 01
    nop                 ;0136 00
    nop                 ;0137 00
    ld h,01h            ;0138 26 01

main:
    call n5_0

    ;PRINT CHR$(26) ' Clear screen
    call pr0a
    ld hl,cls
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
    ld (4033h),a        ;TODO: heads = 1?

    ;l010ah = &H4000
    ld hl,4000h
    ld (l010ah),hl      ;TODO: buffer address?

    ;l010ch = 32
    ld hl,0020h
    ld (l010ch),hl      ;TODO: absolute sector address?

    ;CALL mw_read (l010ah, l010ch, l010eh)
    ld bc,l010ah        ;bc = pointer to buffer address?
    ld de,l010ch        ;de = pointer to absolute sector address?
    ld hl,l010eh        ;hl = pointer to error?
    call mw_read

    ;GOSUB check_error
    call check_error

    ;PRINT "current device number is :  ";
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

    ;PRINT "new device number ? ";
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

    ;l010ch = 32
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

    ;IF PEEK (BUF+1) <> 0 THEN GOTO l02eeh
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
    ;R = PEEK(BUF+2)
    ld hl,(buf)
    inc hl
    inc hl
    ld l,(hl)
    ld h,00h
    ld (rr),hl

    ;IF NOT(R >= &H61 AND R <= &H7A) THEN GOTO l0331h
    ld hl,(rr)          ;02f9 2a 10 01
    ld de,0-'a'         ;02fc 11 9f ff
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
    ld de,0-('z'+1)     ;030e 11 85 ff
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
    ld de,0-('a'-'A')
    ld hl,(rr)
    add hl,de
    ld (rr),hl

l0331h:
    ;N = 0
    ld hl,0
    ld (nn),hl

    ;J = 2
    ld hl,2
    ld (jj),hl

l033dh:
    ;WHILE(PEEK(BUF+J) >= &H30) AND (PEEK(BUF+J) < &H39) AND (J-2 < PEEK(BUF+1))
    ld hl,(buf)         ;033d 2a 16 01
    ex de,hl            ;0340 eb
    ld hl,(jj)          ;0341 2a 18 01
    add hl,de           ;0344 19
    ld l,(hl)           ;0345 6e
    ld h,00h            ;0346 26 00
    push hl             ;0348 e5
    ld de,0-'0'         ;0349 11 d0 ff
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
    ld de,0-('9'+1)     ;035b 11 c6 ff
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

    ;N=N*10+(PEEK(BUF+J)-&H30)
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
    ld de,0-'0'         ;03b3 11 d0 ff
    add hl,de           ;03b6 19
    ld (nn),hl          ;03b7 22 12 01

    ;J = J + 1
    ld hl,(jj)          ;03ba 2a 18 01
    inc hl              ;03bd 23
    ld (jj),hl          ;03be 22 18 01

    ;WEND
    jp l033dh           ;03c1 c3 3d 03

l03c4h:
    ;RETURN
    ret

    ;END
    call end

unknown_err:
    db unknown_err_len
    dw unknown_err+3
    db "xx - unknown error code"
unknown_err_len: equ $-unknown_err-3

illegal_cmd:
    db illegal_cmd_len
    dw illegal_cmd+3
    db "49 - illegal command"
illegal_cmd_len: equ $-illegal_cmd-3

not_ready:
    db not_ready_len
    dw not_ready+3
    db "47 - disk not ready"
not_ready_len: equ $-not_ready-3

write_fault:
    db write_fault_len
    dw write_fault+3
    db "46 - write fault"
write_fault_len: equ $-write_fault-3

data_read_err:
    db data_read_err_len
    dw data_read_err+3
    db "44 - data read error"
data_read_err_len: equ $-data_read_err-3

head_read_err:
    db head_read_err_len
    dw head_read_err+3
    db "42 - header read error"
head_read_err_len: equ $-head_read_err-3

head_writ_err:
    db head_writ_err_len
    dw head_writ_err+3
    db "40 - header write error"
head_writ_err_len: equ $-head_writ_err-3

drive_err_num:
    db drive_err_num_len
    dw drive_err_num+3
    db "DRIVE ERROR #"
drive_err_num_len: equ $-drive_err_num-3

ellipsis:
    db ellipsis_len
    dw ellipsis+3
    db " ..."
ellipsis_len: equ $-ellipsis-3

chg_dev_num:
    db chg_dev_num_len
    dw chg_dev_num+3
    db "changing device number to "
chg_dev_num_len: equ $-chg_dev_num-3

new_dev_num:
    db new_dev_num_len
    dw new_dev_num+3
    db "new device number ? "
new_dev_num_len: equ $-new_dev_num-3

cur_dev_num:
    db cur_dev_num_len
    dw cur_dev_num+3
    db "current device number is :  "
cur_dev_num_len: equ $-cur_dev_num-3

dashes:
    db dashes_len
    dw dashes+3
    db "----- --- --- ------ ------ -- ---------------"
dashes_len: equ $-dashes-3

alter_pet_dos:
    db alter_pet_dos_len
    dw alter_pet_dos+3
    db "Alter PET DOS device number of Mini-Winchester"
alter_pet_dos_len: equ $-alter_pet_dos-3

empty_string:
    db empty_string_len
    dw empty_string+3
empty_string_len: equ $-empty_string-3

    db 0, 0, 0

; Start of Unknown Library ==================================================

buffin:
;Buffered Console Input.  Caller must store buffer size at 80h.  On
;return, 81h will contain the number of data bytes and the data
;will start at 82h.
    ld c,creadstr       ;Buffered Console Input
    ld de,0080h
    jp bdos             ;BDOS entry point

mw_read:
;Read a sector from the Konan David Junior II controller.
;
    ld (err_ptr),hl     ;Save pointer to error word

                        ;Initialize error word to 0:
    xor a               ;  A=0
    ld (hl),a           ;  Error word low byte = 0
    inc hl              ;  Increment to high byte
    ld (hl),a           ;  Error word high byte = 0

    ld (var_3),a        ;054d 32 31 06
    ld a,(de)           ;0550 1a
    ld (var_1),a        ;0551 32 2f 06
    inc de              ;0554 13
    ld a,(de)           ;0555 1a
    ld (var_2),a        ;0556 32 30 06
    ld a,(bc)           ;0559 0a
    ld l,a              ;055a 6f
    inc bc              ;055b 03
    ld a,(bc)           ;055c 0a
    ld h,a              ;055d 67
    push hl             ;055e e5

    ld a,21h            ;A = 21h (Read Disk)
    call mw_comout      ;Send command
    call mw_send_addr   ;Send disk/track/sector sequence

    call mw_status      ;Read status
    pop hl
    jr nz,mw_error      ;Status not OK?  Jump to handle error.

    ld a,41h            ;A = 41h (Read Buffer)
    call mw_comout      ;Send command

                        ;Transfer 256 bytes from David Junior II:
    ld b,00h            ;  Seed loop index to count 256 bytes
l0574h:                 ;
    in a,(corvus)       ;  Read data byte from David Junior II
    ld (hl),a           ;  Store it in our buffer
    inc hl              ;  Increment buffer pointer
    ex (sp),hl          ;  Delay
    ex (sp),hl          ;  Delay
    djnz l0574h         ;  Decrement B, loop until B=0

    call mw_status      ;Read David Junior II status.  Is it OK?
    ret z               ;  Yes: return.
    jp mw_error         ;  No: jump to handle error.

mw_write:
;Write a sector to the Konan David Junior II controller.
;
    ld (err_ptr),hl     ;Save pointer to error word

                        ;Initialize error word to 0:
    xor a               ;  A=0
    ld (hl),a           ;  Error word low byte = 0
    inc hl              ;  Increment to high byte
    ld (hl),a           ;  Error word high byte = 0

    ld (var_3),a        ;058a 32 31 06
    ld a,(de)           ;058d 1a
    ld (var_1),a        ;058e 32 2f 06
    inc de              ;0591 13
    ld a,(de)           ;0592 1a
    ld (var_2),a        ;0593 32 30 06
    ld a,(bc)           ;0596 0a
    ld l,a              ;0597 6f
    inc bc              ;0598 03
    ld a,(bc)           ;0599 0a
    ld h,a              ;059a 67

    ld a,42h            ;A = 42h (Write Buffer)
    call mw_comout      ;Send Command

                        ;Transfer 256 bytes to David Junior II:
    ld b,00h            ;  Seed loop index to count 256 bytes
l05a2h:                 ;
    ld a,(hl)           ;  Read data byte our buffer
    out (corvus),a      ;  Write it to the David Junior II
    inc hl              ;  Increment buffer pointer
    ex (sp),hl          ;  Delay
    ex (sp),hl          ;  Delay
    djnz l05a2h         ;  Decrement B, loop until B=0

    call mw_status      ;Read David Junior II status.  Is it OK?
    jr nz,mw_error      ;  No: jump to handle error.

    ld a,22h            ;A = 22h (Write Disk)
    call mw_comout      ;Send Command
    call mw_send_addr   ;Send disk/track/sector sequence

    call mw_status      ;Read David Junior II status.  Is it OK?
    ret z               ;  Yes: return.
                        ;  No: fall through to mw_error to handle error.

mw_error:
;An error occurred from the Konan David Junior II controller.
;
    ld hl,(err_ptr)     ;HL = pointer to error word
    ld (hl),a           ;Save A as error word low byte (high byte always 0)
    ret

mw_comout:
;Send the command in A to the Konan David Junior II controller.
;
    ld b,a              ;Save command
    xor a
    out (corvus),a      ;Clear David Junior II port
mw_rdy1:
    in a,(corvus)
    cp 0a0h
    jr nz,mw_rdy1       ;Wait for David Junior II to go ready
    ld a,b              ;Recall command
    out (corvus),a      ;Send command
mw_rdy2:
    in a,(corvus)
    cp 0a1h
    jr nz,mw_rdy2       ;Wait until the David Junior II has it
    ld a,0ffh
    out (corvus),a      ;Send execute code
    ld b,14h
mw_rdy3:
    nop
    djnz mw_rdy3        ;Delay loop
    ret

mw_status:
;Get status from the Konan David Junior II, return it in A.
;
    ld a,0ffh
    out (corvus),a      ;Transfer done
l05e1h:
    in a,(corvus)
    inc a
    jr nz,l05e1h        ;Wait for David Junior II to get out
                        ;  of internal DMA mode
    ld a,0feh
    out (corvus),a      ;Signal that we are ready for status
l05eah:
    in a,(corvus)
    rla
    jr c,l05eah         ;Wait for status

    in a,(corvus)       ;Read status byte
    bit 6,a             ;Bit 6 of David Junior status is set if error
                        ;  Z = opposite of bit 6 (Z=1 if OK, Z=0 if error)
    push af             ;Save status byte
    xor a
    out (corvus),a      ;Clear the port to acknowledge receiving the status
    pop af              ;Recall status byte
    ret

mw_send_addr:
;Send an 8-byte address to the David Junior II controller.
;
    xor a
    out (corvus),a      ;Send byte 0: unit number (always 0)
    ld hl,(var_1)
    ld a,(var_3)
    ld b,05h
l0604h:
    rra
    rr h
    rr l
    djnz l0604h         ;Decrement B, loop until B=0

    ld a,(4033h)
    ld b,a
    and l
    out (corvus),a      ;Send byte 1: Head number (0..7)
l0612h:
    srl h
    rr l
    srl b
    jr nz,l0612h
    ld a,l
    out (corvus),a      ;Send byte 2: Track low (0..FF)
    ld a,h
    out (corvus),a      ;Send byte 3: Track high (0 or 1)
    ld a,(var_1)
    and 1fh
    out (corvus),a      ;Send byte 4: Sector
    xor a
    out (corvus),a      ;Send byte 5: Reserved
    out (corvus),a      ;Send byte 6: Reserved
    out (corvus),a      ;Send byte 7: Reserved
    ret

var_1:
    db 20h
var_2:
    db 02h
var_3:
    db 21h
err_ptr:
    dw 0                ;Pointer: error code

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
    ld a,lf
    call conout
    ld a,cr
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
    jp warm             ;Warm start entry point

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
    ld c,cwrite         ;Console Output
    ld e,a
    call bdos           ;BDOS entry point
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
    ld c,cread          ;Console Input
    call bdos           ;BDOS entry point
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
