;BACKUP.COM
;  Duplicate a floppy disk in a CBM dual drive unit

bdos:           equ  0005h  ;BDOS entry point
args:           equ  0080h  ;Command line arguments passed from CCP
dos_msg:        equ 0eac0h  ;Last error message returned from CBM DOS
get_ddev:       equ 0f054h  ;BIOS Get device address for a CP/M drive number
ieee_read_err:  equ 0f05ah  ;BIOS Read error channel of an IEEE-488 device
ieee_open:      equ 0f05dh  ;BIOS Open a file on an IEEE-488 device

    org 0100h           ;CP/M TPA

    ld hl,args          ;HL = command line arguments from CCP: first byte is
                        ;       number of chars, followed by the chars
    ld c,(hl)           ;C = number of chars
next_char:
    inc hl              ;HL = HL + 1 (increment to next char)
    ld a,(hl)           ;A = char from args
    cp ' '              ;Is it a space?
    jp nz,backup        ;  No: jump to handle next char as start of args
    dec c               ;C = C - 1 (decrement num of chars remaining)
                        ;End of command arguments?
    jp z,exit_syntax    ;  Yes: exit, syntax error
    jp next_char        ;  No:  loop to handle the next char

backup:
                        ;Check that args count is exactly 3 chars:
    dec c               ;  Destination drive (CP/M drive letter)
    dec c               ;  Equals sign
    dec c               ;  Source drive (CP/M drive letter)
    jp nz,exit_syntax   ;  Jump to exit if wrong number of chars

                        ;Parse first char as destination, store in B:
                        ;  Char is already in A
    and 5fh             ;  Normalize to uppercase
    sub 41h             ;  Convert char to binary CP/M drive number
    jp c,exit_syntax    ;  Jump to exit if drive number is < 0
    cp 10h              ;  Is it < 10h? (last drive is P: 0fh)
    jp nc,exit_syntax   ;    No: jump to exit
    ld b,a              ;  Store this drive (destination) in B

                        ;Check second char is equals sign ("="):
    inc hl              ;  HL = address of second char
    ld a,(hl)           ;  A = second char
    cp '='              ;  Is it the equals sign?
    jp nz,exit_syntax   ;    No: exit, bad syntax

                        ;Parse third char as source drive, store in A:
    inc hl              ;  Move to next char in args
    ld a,(hl)           ;  A = char
    and 5fh             ;  Normalize char to uppercase
    sub 41h             ;  Convert char to binary CP/M drive number
    jp c,exit_syntax    ;  Jump to exit if drive number is < 0
    cp 10h              ;  Is it < 10h? (last drive is P: 0fh)
    jp nc,exit_syntax   ;    No: jump to exit

                        ;Check source and destination are different:
    cp b                ;  A = B?
    jp z,exit_syntax    ;    Yes: exit, same drive letter for both

                        ;Check both drives are on same CBM dual drive unit:
    xor 01h             ;  Flip bit 0 of A.
                        ;    If both drive letters are on the same CBM drive
                        ;    unit, then now A = B (destination drive).
    cp b                ;  Same CBM drive unit?
    jp nz,exit_units    ;    No: exit, not same unit

                        ;Destination CP/M drive number is now in A and B

                        ;Write "Disk on drive " to console out:
    push af             ;
    ld de,disk_on_drive ;  DE = address of "Disk on drive" string
    ld c,09h            ;  C = 09h, C_WRITESTR (Output String)
    call bdos           ;  BDOS System Call
    pop af              ;

    push af             ;Push destination CP/M drive number

                        ;Write drive letter of destination to console out:
    add a,41h           ;  A = drive letter in ASCII
    ld e,a              ;  E = A
    ld c,02h            ;  C = 02h, C_WRITE (Console Output)
    call bdos           ;  BDOS System Call

                        ;Write "will be erased..." to console out
    ld de,will_be_erasd ;  HL = address of string
    ld c,09h            ;  C = 09h, C_WRITESTR (Output String)
    call bdos           ;  BDOS System Call

                        ;Get a key from the console:
    ld c,01h            ;  C = 01h, C_READ (Console Input)
    call bdos           ;  BDOS System Call

                        ;Check for RETURN to continue, other key aborts:
    cp 0dh              ;  Key pressed = RETURN?
    jp nz,exit_abort    ;    No: jump to abort

    pop af              ;Pop destination CP/M drive number

                        ;Get IEEE-488 primary address from CP/M drive number:
    push af             ;
    call get_ddev       ;  D = IEEE-488 primary address
    ld e,0fh            ;  E = IEEE-488 secondary address 15 (command)
    pop af              ;

                        ;Send CBM DOS backup command to the drive:
    push af             ;
    ld hl,dos_d1_to_d0  ;  HL = address of "D1=0" (from drive 0 to drive 1)
    rra                 ;  Rotate bit 0 of CP/M drive number into carry
                        ;    (indicates CBM drive: 0=drive 0, 1=drive 1)
    jp c,send_cmd       ;  Jump to keep HL if destination is drive 1
    ld hl,dos_d0_to_d1  ;  HL = address of "D0=1" (from drive 1 to drive 0)
send_cmd:
    ld c,04h            ;  C = 4 bytes in string
    call ieee_open      ;  Send OPEN with the backup command
    pop af              ;

                        ;Wait for backup to finish, check for error:
    call ieee_read_err  ;  A = error code from CBM DOS
                        ;      (blocks until the backup has finished)
    jp nz,exit_error    ;  Jump to exit if error code != 0 (OK)

                        ;Write success message and exit:
    ld de,copy_complete ;  HL = address of "Copy complete" string
    ld c,09h            ;  C = 09h, C_WRITESTR (Output String)
    jp bdos             ;  Jump out to BDOS System Call.
                        ;    It will return to CP/M.

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
    ld de,syntax_err    ;DE = address of "Syntax error" string
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
    jp bdos             ;Jump out to BDOS System Call.
                        ;  It will return to CP/M.

exit_abort:
;Exit to CP/M: User aborted
;
    pop af
    ret                 ;Return to CP/M.

exit_units:
;Exit to CP/M: Drives are not on the same unit
;
    ld de,not_same_unit ;DE = address of "Drives must be same unit" string
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
    jp bdos             ;Jump out to BDOS System Call.
                        ;  It will return to CP/M.

exit_error:
;Exit to CP/M: Error reported by CBM DOS
;
    ld de,disk_error    ;DE = address of "Drive error: " string
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
    call bdos           ;BDOS System Call

    ld hl,dos_msg       ;HL = address of CBM DOS error string
dos_msg_loop:
    ld a,(hl)           ;A = next char in string
    cp 0dh              ;Is it a carriage return?
    ret z               ;  Yes: end of DOS message, return to CP/M.

    push hl
    ld e,a              ;E = A (pass char to C_WRITE)
    ld c,02h            ;C = 02h, C_WRITE (Console Output)
    call bdos           ;BDOS System Call
    pop hl

    inc hl              ;Move to next char in string
    jp dos_msg_loop     ;Loop to handle next char
