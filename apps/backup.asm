;BACKUP.COM
;  Duplicate a floppy disk in a CBM dual drive unit

args:           equ  0080h  ;Command line arguments passed from CCP
dos_msg:        equ 0eac0h  ;Last error message returned from CBM DOS
get_ddev:       equ 0f054h  ;BIOS Get device address for a CP/M drive number
ieee_read_err:  equ 0f05ah  ;BIOS Read error channel of an IEEE-488 device
ieee_open:      equ 0f05dh  ;BIOS Open a file on an IEEE-488 device

    org 0100h           ;CP/M TPA

    ld hl,args
    ld c,(hl)
next_char:
    inc hl
    ld a,(hl)
    cp ' '
    jp nz,backup
    dec c
    jp z,exit_syntax
    jp next_char

backup:
                        ;Check that args has exactly 3 characters:
    dec c               ;  Destination drive letter
    dec c               ;  Equals character
    dec c               ;  Source drive letter
    jp nz,exit_syntax   ;  Jump if wrong number of chars for args

                        ;Parse first char as destination, store in B:
    and 5fh
    sub 41h
    jp c,exit_syntax
    cp 10h
    jp nc,exit_syntax
    ld b,a

                        ;Check second char is equals sign ("="):
    inc hl              ;HL = address of second char
    ld a,(hl)           ;A = second char
    cp '='              ;Is it the equals sign?
    jp nz,exit_syntax   ;  No: exit, bad syntax

                        ;Parse third char as source drive, store in A:
    inc hl
    ld a,(hl)
    and 5fh
    sub 41h
    jp c,exit_syntax
    cp 10h
    jp nc,exit_syntax
    cp b
    jp z,exit_syntax
    xor 01h
    cp b
    jp nz,exit_units

    push af
    ld de,disk_on_drive ;DE = address of "Disk on drive" string
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
    call 0005h          ;BDOS System Call
    pop af

    push af
    add a,41h
    ld e,a
    ld c,02h
    call 0005h

    ld de,will_be_erasd
    ld c,09h
    call 0005h

    ld c,01h
    call 0005h
    cp 0dh
    jp nz,exit_abort
    pop af

    push af
    call get_ddev       ;  D = IEEE-488 primary address
    ld e,0fh            ;  E = IEEE-488 secondary address 15 (command)
    pop af

    push af
    ld hl,dos_d1_to_d0
    rra
    jp c,l017ch
    ld hl,dos_d0_to_d1
l017ch:
    ld c,04h
    call ieee_open
    pop af

    call ieee_read_err
    jp nz,exit_error

    ld de,copy_complete
    ld c,09h
    jp 0005h

copy_complete:
    db 0dh,0ah,"Copy complete$"
syntax_err:
    db 0dh,0ah,"Syntax error$"
not_same_unit:
    db 0dh,0ah,"Drives must be on the same unit !$"
disk_error:
    db 0dh,0ah,"Disk error : $"
disk_on_drive:
    db 0dh,0ah,"Disk on drive $"
will_be_erasd:
    db ": will be erased.",0dh,0ah
    db "Press RETURN to continue,",0dh,0ah
    db "Press the SPACE BAR to abort : $"

dos_d1_to_d0:
    db "D1=0"
dos_d0_to_d1:
    db "D0=1"

exit_syntax:
;Exit to CP/M: Bad arguments
;
    ld de,syntax_err
    ld c,09h
    jp 0005h

exit_abort:
;Exit to CP/M: User aborted
;
    pop af
    ret

exit_units:
;Exit to CP/M: Drives are not on the same unit
;
    ld de,not_same_unit
    ld c,09h
    jp 0005h

exit_error:
;Exit to CP/M: Error reported by CBM DOS
;
    ld de,disk_error
    ld c,09h
    call 0005h
    ld hl,dos_msg
l0267h:
    ld a,(hl)
    cp 0dh
    ret z
    push hl
    ld e,a
    ld c,02h
    call 0005h
    pop hl
    inc hl
    jp l0267h
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
