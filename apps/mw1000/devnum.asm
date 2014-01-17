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
dma_buf:       equ  0080h ;Default DMA buffer area (128 bytes) for disk I/O

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

buf_addr:
    dw 0                ;Buffer address to read and write sectors

sec_addr:
    dw 0                ;Absolute sector address to read and write sectors

err_code:
    dw 0                ;Error code from read and write sectors

rr:
    dw 0                ;First char of user input from any prompt

nn:
    dw 0                ;Integer parsed from user input

l0114h:
    dw 0                ;This error code is displayed in got_error

buf:
    dw 0                ;Address of buffer used in readline

jj:
    dw 0                ;Loop index

    dw 0
    dw 0
    dw 0
    dw 0

l0122h:
    dw 0                ;Temporary used for complex expression

    dw 0

; End of BASIC variables ====================================================

start:
    ld hl,main
    jp ini              ;Perform JP (main)

unused_2:
    db 3bh,05h,00h,00h,3dh,05h,03h,01h
    db 1ah,01h,00h,00h,26h,01h

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
    ld a,1
    ld (4033h),a        ;We have minimum two heads. So the sector 32 is the first sector on head 1, track 0

    ;buf_addr = &H4000
    ld hl,4000h
    ld (buf_addr),hl

    ;sec_addr = 32
    ld hl,32
    ld (sec_addr),hl    ;The HardBox code starts at absolute sector 32

    ;CALL MW_READ (buf_addr, sec_addr, err_code)
    ld bc,buf_addr      ;bc = pointer to buffer address
    ld de,sec_addr      ;de = pointer to absolute sector address
    ld hl,err_code      ;hl = pointer to error code
    call mw_read

    ;GOSUB check_error
    call check_error

    ;PRINT "current device number is :  ";
    call pr0a
    ld hl,cur_dev_num
    call pv1d

    ;PRINT PEEK(&H4036);
    ld a,(4036h)
    ld l,a
    ld h,0
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

    ;IF R<>0 THEN GOTO l01c8h
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

    ;sec_addr = 32
    ld hl,32
    ld (sec_addr),hl

    ;CALL MW_WRITE (buf_addr, sec_addr, err_code)
    ld bc,buf_addr      ;bc = pointer to buffer address
    ld de,sec_addr      ;de = pointer to absolute sector address
    ld hl,err_code      ;hl = pointer to error code
    call mw_write

    ;GOSUB check_error
    call check_error

    ;END
    call end

check_error:
    ;IF (err_code AND &H40)<>0 THEN GOTO got_error
    ld hl,(err_code)
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

    ;IF l0114h<>&H40 THEN GOTO is_err_42h
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
    ;IF l0114h<>&H42 THEN GOTO is_err_44h
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
    ;IF l0114h<>&H44 THEN GOTO is_err_46h
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
    ;IF l0114h<>&H46 THEN GOTO is_err_47h
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
    ;IF l0114h<>&H47 THEN GOTO is_err_49h
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
    ;IF l0114h<>&H49 THEN GOTO unknown_error
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
    ld hl,80h
    ld (buf),hl

    ;POKE BUF, 80
    ld hl,(buf)
    ld (hl),80

    ;CALL BUFFIN
    call buffin

    ;PRINT
    call pr0a
    ld hl,empty_string
    call pv2d

    ;IF PEEK(BUF+1)<>0 THEN GOTO l02eeh
    ld hl,(buf)
    inc hl
    ld l,(hl)
    ld h,0
    ld a,h
    or l
    jp nz,l02eeh

    ;R = 0
    ld hl,0
    ld (rr),hl

    ;RETURN
    ret

l02eeh:
    ;R = PEEK(BUF+2)
    ld hl,(buf)
    inc hl
    inc hl
    ld l,(hl)
    ld h,0
    ld (rr),hl

    ;IF NOT(R>=&H61 AND R<=&H7A) THEN GOTO l0331h
    ld hl,(rr)          ;HL=(rr)
    ld de,0-'a'         ;DE=-61h
    ld a,h
    rla
    jp c,l0306h
    add hl,de
    add hl,hl
l0306h:
    ccf
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL>=DE
    push hl             ;Save value
    ld hl,(rr)          ;HL=(rr)
    ld de,0-('z'+1)     ;DE=-7bh
    ld a,h
    rla
    jp c,l0318h
    add hl,de
    add hl,hl
l0318h:
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL<DE
    pop de              ;Restore value
    ld a,h
    and d
    ld h,a
    ld a,l
    and e
    ld l,a              ;HL=HL and DE
    ld a,h
    or l
    jp z,l0331h         ;IF HL=0 THEN GOTO l0331h

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
    ;WHILE(PEEK(BUF+J)>=&H30) AND (PEEK(BUF+J)<&H39) AND (J-2 < PEEK(BUF+1))
    ld hl,(buf)
    ex de,hl
    ld hl,(jj)
    add hl,de           ;HL=(buf)+(jj)
    ld l,(hl)
    ld h,0              ;HL=PEEK(HL)
    push hl             ;Save value
    ld de,0-'0'         ;DE=-30h
    ld a,h
    rla
    jp c,l0353h
    add hl,de
    add hl,hl
l0353h:
    ccf
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL>=DE
    ld (l0122h),hl      ;(l0122h)=HL
    pop hl              ;Restore value
    ld de,0-('9'+1)     ;DE=-3ah
    ld a,h
    rla
    jp c,l0365h
    add hl,de
    add hl,hl
l0365h:
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL<DE
    push hl             ;Save value
    ld hl,(l0122h)
    ex de,hl            ;DE=(l0122h)
    pop hl              ;Restore value
    ld a,h
    and d
    ld h,a
    ld a,l
    and e
    ld l,a              ;HL=HL and DE
    push hl             ;Save value
    ld hl,(buf)
    inc hl              ;HL=(buf)+1
    ld l,(hl)
    ld h,0              ;HL=PEEK(HL)
    push hl             ;Save value
    ld hl,(jj)
    dec hl
    dec hl              ;HL=(jj)-2
    pop de              ;Restore value
    ld a,d
    xor h
    ld a,h
    jp m,l038dh
    ld a,l
    sub e
    ld a,h
    sbc a,d
l038dh:
    rla
    sbc a,a
    ld h,a
    ld l,a              ;HL=HL<DE
    pop de              ;Restore value
    ld a,h
    and d
    ld h,a
    ld a,l
    and e
    ld l,a              ;HL=HL and DE
    ld a,h
    or l
    jp z,l03c4h         ;IF HL=0 THEN GOTO l03c4h

    ;N = N * 10 + (PEEK(BUF+J) - &H30)
    ld hl,(nn)          ;HL=(nn)
    call imug
    dw 10               ;HL=HL*10
    push hl             ;Save value
    ld hl,(buf)
    ex de,hl
    ld hl,(jj)
    add hl,de           ;HL=(buf)+(jj)
    ld l,(hl)
    ld h,0              ;HL=PEEK(HL)
    pop de              ;Restore value
    add hl,de
    ld de,0-'0'
    add hl,de           ;HL=HL+DE-30h
    ld (nn),hl          ;(nn)=HL

    ;J = J + 1
    ld hl,(jj)
    inc hl
    ld (jj),hl

    ;WEND
    jp l033dh

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
    ld de,dma_buf
    jp bdos             ;BDOS entry point

mw_read:
;Read a sector from the Konan David Junior II controller.
;
;  BC = pointer to buffer address
;  DE = pointer to absolute sector address
;  HL = pointer to error code
;
    ld (err_ptr),hl     ;Save pointer to error word

                        ;Initialize error word to 0:
    xor a               ;  A=0
    ld (hl),a           ;  Error word low byte = 0
    inc hl              ;  Increment to high byte
    ld (hl),a           ;  Error word high byte = 0

                        ;Store the absolute sector number
    ld (var_1+2),a      ;  Absolute sector address high byte = 0  
    ld a,(de)           ;  Get absolute sector address low byte
    ld (var_1),a        ;  Store it
    inc de
    ld a,(de)           ;  Get absolute sector address middle byte
    ld (var_1+1),a      ;  Store it

                        ;Store the buffer address
    ld a,(bc)           ;  Get buffer address low byte
    ld l,a              ;  Move it
    inc bc
    ld a,(bc)           ;  Get buffer address high byte
    ld h,a              ;  move it
    push hl             ;  save it

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
;  BC = pointer to buffer address
;  DE = pointer to absolute sector address
;  HL = pointer to error code
;
    ld (err_ptr),hl     ;Save pointer to error word

                        ;Initialize error word to 0:
    xor a               ;  A=0
    ld (hl),a           ;  Error word low byte = 0
    inc hl              ;  Increment to high byte
    ld (hl),a           ;  Error word high byte = 0

                        ;Store the absolute sector number
    ld (var_1+2),a      ;  Absolute sector address high byte = 0  
    ld a,(de)           ;  Get absolute sector address low byte
    ld (var_1),a        ;  Store it
    inc de
    ld a,(de)           ;  Get absolute sector address middle byte
    ld (var_1+1),a      ;  Store it

                        ;Store the buffer address
    ld a,(bc)           ;  Get buffer address low byte
    ld l,a              ;  Move it
    inc bc
    ld a,(bc)           ;  Get buffer address high byte
    ld h,a              ;  move it

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
    ld b,20
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
    ld a,(var_1+2)
    ld b,5
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
    db 20h,02h,21h      ;Absolute sector address (24 Bit)
                        ;x=unused, t=track, h=head, s=sector
                        ;76543210 76543210 76543210 bits
                        ;xxtttttt tttttttt tthsssss - for heads (4033h) = 1 (for mw_read used!)
                        ;xttttttt tttttttt thhsssss - for heads (4033h) = 3
                        ;tttttttt tttttttt hhhsssss - for heads (4033h) = 7

err_ptr:
    dw 0                ;Pointer: error code

; Start of KLIB.REL =========================================================

; XSTRIN --------------------------------------------------------------------

tmp:
    db 0c9h             ;header: string length
    dw 50cdh            ;header: start address of string (is ignored)
    db 20h, 06h         ;string data (not at start address!)

print_spc:
    ld a,' '
    call conout         ;Write the char in A to the console
    ret

print_eol:
    ld a,lf
    call conout         ;Write the char in A to the console
    ld a,cr
    call conout         ;Write the char in A to the console
    ret

hex:
;XSTRIN: HEX
;Make a temporary string (length 2 bytes) with the hexadecimal
;representation of the byte in HL and return a pointer to it in HL.
;Implements BASIC function: HEX$(x)
;
    ld a,2              ;A = 2 bytes in string
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
    cp 10
    jp m,xstrin_5
    add a,0+'A'-('9'+1)
xstrin_5:
    add a,'0'
    ret

chr:
;XSTRIN: CHR
;Make a temporary string from the char in L and
;return a pointer to it in HL.
;Implements BASIC function: CHR$(x)
;
    ld a,1              ;A = 1 byte in string
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
    call conout         ;Write the char in A to the console
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
    ld hl,0
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
    ld a,' '
    call conout         ;Write the char in A to the console
    ret

pv2c:
;N16: PV2C
    call sub_06e5h
    ld a,lf
    call conout         ;Write the char in A to the console
    ld a,cr
    call conout         ;Write the char in A to the console
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
    ld a,'-'
    call conout         ;Write the char in A to the console
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
    call conout         ;Write the char in A to the console
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
    ld (hl),0
    pop bc
    pop de
    ret

char:
;CPMIO: CHAR
    ld a,(hl)
    jp conout           ;Write the char in A to the console

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
    ld a,'-'            ;0773 3e 2d
    call conout         ;0775 cd 3e 07
    ld c,'0'            ;0778 0e 30
    ld de,10000         ;077a 11 10 27
    call sub_071ah      ;077d cd 1a 07

; End of KLIB.REL ===========================================================
