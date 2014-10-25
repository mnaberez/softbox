;SET.COM
;  Change SoftBox settings
;
;The settings are changed for the current session only.  To make
;permanent changes, use the NEWSYS utility.
;
;CBM screen settings:
;  "SET U"    Go to uppercase mode
;  "SET L"    Go to lowercase mode
;  "SET T"    Set line spacing for text
;  "SET G"    Set line spacing for graphics
;
;CBM terminal emulation:
;  "SET V=A"  Lear Siegler ADM-3A
;  "SET V=T"  TeleVideo 912
;  "SET V=H"  Hazeltine 1500 with tilde lead-in
;  "SET V=E"  Hazeltine 1500 with ESC lead-in
;
;CBM terminal emulation lead-in:
;  "SET E=E"  Escape
;  "SET E=T"  Tilde
;
;IEEE-488 primary addresses:
;  "SET P=#"  LPT:
;  "SET A=#"  UL1:  (Broken, see note in set_a routine)
;  "SET R=#"  PTR:
;  "SET N=#"  PTP:
;
;Directory width:
;  "SET D=1"  1 column
;  "SET D=2"  2 columns
;  "SET D=4"  4 columns
;

bdos:       equ  0005h  ;BDOS entry point
args:       equ  0080h  ;Command line arguments passed from CCP
dirsize:    equ 0d8b2h  ;CCP directory width: 0=1 col, 1=2 cols, 3=4 cols
lpt_dev:    equ 0ea61h  ;CBM printer (LPT:) IEEE-488 primary address
ptr_dev:    equ 0ea62h  ;Paper Tape Reader (PTR:) IEEE-488 primary address
ptp_dev:    equ 0ea63h  ;Paper Tape Punch (PTP:) IEEE-488 primary address
leadin:     equ 0ea68h  ;Terminal command lead-in: 1bh=escape, 7eh=tilde
xy_order:   equ 0ea69h  ;X,Y order when sending move-to: 0=Y first, 1=X first
y_offset:   equ 0ea6ah  ;Offset added to Y when sending move-to sequence
x_offset:   equ 0ea6bh  ;Offset added to X when sending move-to sequence
ul1_dev:    equ 0ea66h  ;ASCII printer (UL1:) IEEE-488 primary address
scrtab:     equ 0ea80h  ;64 byte table for terminal character translation
jp_conout:  equ 0ea0ch  ;Jumps to conout (Console Output) routine in BIOS

cwritestr:  equ 09h     ;Output String

ucase:      equ 15h     ;Uppercase mode
lcase:      equ 16h     ;Lowercase mode
sptxt:      equ 17h     ;Line spacing for text
spgfx:      equ 18h     ;Line spacing for graphics
esc:        equ 1bh     ;Escape
tilde:      equ '~'     ;Tilde

    org 0100h           ;CP/M TPA

    ld hl,args          ;HL = command line arguments from CCP: first byte is
                        ;       number of chars, followed by the chars
    ld c,(hl)           ;C = number of chars
next_char:
    inc hl              ;HL = HL + 1 (increment to next char)
    ld a,(hl)           ;A = char from args
    cp ' '              ;Is it a space?
    jp nz,dispatch      ;  No: jump to dispatch it
    dec c               ;C = C - 1 (decrement num of chars remaining)
                        ;End of command arguments?
    jp nz,next_char     ;   No: Loop to handle the next char.
    jp bad_syntax       ;  Yes: Exit with syntax error.

p_bad_syntax:
;Pop DE then fall through to bad_syntax
;
    pop de

bad_syntax:
;Write "Syntax error" to console out and return to CP/M.
;
    ld de,syntax_err    ;DE = address of "Syntax error" string
    ld c,cwritestr      ;Output String
    jp bdos             ;Jump out to BDOS System Call.  It will
                        ;  return to CP/M.

dispatch:
;Dispatch the first character of the command arguments.
;
    and 5fh             ;Normalize char to uppercase
    cp 'U'              ;'U' = Set uppercase mode
    jp z,set_u
    cp 'L'              ;'L' = Set lowercase mode
    jp z,set_l
    cp 'T'              ;'T' = Set line spacing for text
    jp z,set_t
    cp 'G'              ;'G' = Set line spacing for graphics
    jp z,set_g
    cp 'V'              ;'V' = Set video terminal type
    jp z,set_v
    cp 'D'              ;'D' = Set directory width
    jp z,set_d
    cp 'P'              ;'P' = Set IEEE-488 primary address of LPT:
    jp z,set_p
    cp 'A'              ;'A' = Set IEEE-488 primary address of UL1:
    jp z,set_a
    cp 'R'              ;'R' = Set IEEE-488 primary address of PTR:
    jp z,set_r
    cp 'N'              ;'N' = Set IEEE-488 primary address of PTP:
    jp z,set_n
    cp 'E'              ;'E' = Set terminal command lead-in (escape) char
    jp z,set_e
    jp bad_syntax       ;Syntax error if character is not matched

set_u:
;Set uppercase mode
;  SET U
;
    ld c,ucase          ;Go to uppercase mode
    jp jp_conout        ;Jump out to conout (in BIOS) through jp_conout.
                        ;  It will return to CP/M.

set_l:
;Set lowercase mode
;  SET L
;
    ld c,lcase          ;Go to lowercase mode
    jp jp_conout        ;Jump out to conout (in BIOS) through jp_conout.
                        ;  It will return to CP/M.

set_g:
;Set line spacing for text
;  SET T
;
    ld c,sptxt          ;Set line spacing for text
    jp jp_conout        ;Jump out to conout (in BIOS) through jp_conout.
                        ;  It will return to CP/M.

set_t:
;Set line spacing for graphics
;  SET G
;
    ld c,spgfx          ;Set line spacing to graphics
    jp jp_conout        ;Jump out to conout (in BIOS) through jp_conout.
                        ;  It will return to CP/M.

get_value:
;Get the value for the setting from args.  If the command was
;"SET A=B" then "B" would be returned in A.
;
                        ;Check for equals sign:
    inc hl              ;  Move to next character in args
    ld a,(hl)           ;  A = char from args
    cp '='              ;  Is it an equals sign?
    jp nz,p_bad_syntax  ;    No: bad syntax

                        ;Get value after equals sign:
    inc hl              ;  Move to next character in args
    ld a,(hl)           ;  A = char from args

                        ;Check that args has exactly three chars ("A=B"):
    dec c               ;  "A"
    dec c               ;  "="
    dec c               ;  "B"
    jp m,p_bad_syntax   ;  Jump if sign flag is set (decremented past 0)
    ret

set_e:
;Set terminal command lead-in (escape) character
;  SET E=E  Escape
;  SET E=T  Tilde
;
    call get_value      ;A = value char
    and 5fh             ;Normalize char to uppercase
    cp 'E'
    ld b,esc            ;Escape
    jp z,store_leadin
    cp 'T'
    jp nz,bad_syntax
    ld b,tilde          ;Tilde
store_leadin:
    ld hl,leadin
    ld (hl),b
    ret

set_v:
;Set video terminal type
;  SET V=A  Lear Siegler ADM-3A
;  SET V=T  TeleVideo 912
;  SET V=H  Hazeltine 1500 with tilde lead-in
;  SET V=E  Hazeltine 1500 with ESC lead-in
;
    call get_value      ;A = value char
    and 5fh             ;Normalize char to uppercase

    ld hl,trans_adm_tv  ;HL = address of ADM-3A/TV-912 table
                        ;TODO: This is not needed because HL will
                        ;      be set to the correct tabs table
                        ;      in both adm3a_tv912 and hz1500.

    cp 'A'              ;'A' = ADM-3A
    jp z,adm3a_tv912

    cp 'T'              ;'T' = TeleVideo 912
    jp z,adm3a_tv912

    cp 'H'              ;'H' = Hazeltine 1500 with ~ lead-in
    ld b,tilde          ;B = ~ lead-in
    jp z,hz1500

    cp 'E'              ;'E' = Hazeltine 1500 with ESC lead-in
    jp nz,bad_syntax    ;Jump to bad syntax if not 'E'

    ld b,esc            ;B = ESC lead-in
                        ;Fall through into hz1500

hz1500:
;Set terminal type to Hazeltine 1500
;B = lead-in (escape) character
;
                        ;Set lead-in:
    ld a,b              ;  A = B (lead-in)
    ld (leadin),a       ;  Set terminal lead-in character

                        ;Set cursor move-to offsets:
    xor a               ;  A=0 (no offset)
    ld (x_offset),a     ;  Set Y offset for cursor move-to sequence
    ld (y_offset),a     ;  Set X offset

                        ;Set cursor move-to order:
    ld a,01h            ;  A=1 indicates X-first
    ld (xy_order),a     ;  Set X-Y order for cursor move-to sequence

                        ;Copy character translation table:
    ld hl,trans_hz1500  ;  HL = address of Hazeltine 1500 table
    ld de,scrtab        ;  DE = address of BIOS scrtab area
    ld bc,001bh         ;  BC = 27 bytes to copy
    ldir                ;  Copy BC bytes from (HL) to (DE)
    ret

adm3a_tv912:
;Set terminal type to ADM-3A and TeleVideo 912
;
                        ;Set cursor move-to offsets:
    ld a,20h            ;  20h = offset used by ADM-3A and compatibles
    ld (y_offset),a     ;  Set Y offset for cursor move-to sequence
    ld (x_offset),a     ;  Set X offset

                        ;Set cursor move-to order:
    xor a               ;  A=0 indicates Y-first
    ld (xy_order),a     ;  Set X-Y order for cursor move-to sequence

                        ;Set lead-in:
    ld a,esc            ;  A = ESC character
    ld (leadin),a       ;  Set terminal lead-in character

                        ;Copy character translation table:
    ld hl,trans_adm_tv  ;  HL = address of ADM-3A/TV-912 table
    ld de,scrtab        ;  DE = address of BIOS scrtab area
    ld bc,002bh         ;  BC = 43 bytes to copy
    ldir                ;  Copy BC bytes from (HL) to (DE)
    ret

set_d:
;Set directory width
;  SET D=1
;  SET D=2  Listings from DIR command will be 1,2,4 columns
;  SET D=4
;
    call get_value      ;A = value char

                        ;Select 1 column directory:
    ld b,00h            ;  B=0
    cp '1'              ;  Value = 1?
    jp z,store_dirsize  ;    Yes: jump to store B in dirsize

                        ;Select 2 column directory:
    ld b,01h            ;  B=1
    cp '2'              ;  Value = 2?
    jp z,store_dirsize  ;    Yes: jump to store B in dirsize

                        ;Select 4 column directory:
    ld b,03h            ;  B=3
    cp '4'              ;  Value = 4?
    jp nz,bad_syntax    ;    No:  jump to syntax error, no options left
                        ;    Yes: fall through to store B in dirsize
store_dirsize:
    ld a,b
    ld (dirsize),a      ;Set CCP directory width to B
    ret

set_a:
;Set IEEE-488 primary address of UL1:
;  SET A=?
;
    ld de,ul1_dev       ;DE = address of UL1: device number
                        ;XXX This is a bug.  There should be a "jp store_dev"
                        ;    here.  Instead it just falls through, where DE
                        ;    will be immediately overwritten.

set_p:
;Set IEEE-488 primary address of LPT:
;  SET P=#
;
    ld de,lpt_dev       ;DE = address of LPT: device number
    jp store_dev

set_n:
;Set IEEE-488 primary address of PTP:
;  SET N=#
;
    ld de,ptp_dev       ;DE = address of PTP: device number
    jp store_dev

set_r:
;Set IEEE-488 primary address of PTR:
;  SET R=#
;
    ld de,ptr_dev       ;DE = address of PTR: device number
                        ;Fall through to store_dev

store_dev:
;DE = address to receive device number
;
    call get_dec        ;A = device number
    jp c,bad_syntax     ;Jump to syntax error if parsing number failed
    ld (de),a           ;Store device number
    ret

get_dec:
;Get a one or two character decimal number from the args buffer,
;convert it to a binary number, and return it in A.
;
;If the current args char at HL is not a digit, HL will be advanced
;until a digit is reached.
;
;On exit, HL will be pointing at the last char of the decimal number
;in the args buffer.
;
;Returns carry flag set on error.
;
                        ;Get first char from args:
    inc hl              ;  Increment HL to point to next char in args
    ld a,(hl)           ;  A = char from args at HL
    dec c               ;  Decrement C (number of chars remaining in args)
    scf                 ;  Set carry flag to indicate error status
    ret m               ;  Return if sign flag is set (decremented past 0)

                        ;Convert first char from ASCII to binary number:
    sub 30h             ;  Subtract 30h to convert it (ASCII "0" = 30h)
    jp c,get_dec        ;  Jump if carry is set, indicating A < 0
    cp 0ah              ;  Compare to check upper bounds
    jp nc,get_dec       ;  Jump if A >= 0Ah (ASCII "9" = 39h)
    ld b,a              ;  Save the valid binary number in B

                        ;Get second char from args:
    inc hl              ;  Increment HL to point to next char in args
    dec c               ;  Decrement C (number of chars remaining in args)
    jp m,get_dec_one    ;  Jump if sign flag is set (decremented past 0)
    ld a,(hl)           ;  A = char from args at HL

                        ;Convert second char from ASCII to binary number:
    sub 30h             ;  Subtract 30h to convert it (ASCII "0" = 30h)
    jp c,get_dec_one    ;  Jump if carry is set, indicating A < 0
    cp 0ah              ;  Compare to check upper bounds
    jp nc,get_dec_one   ;  Jump if A >= 0Ah (ASCII "9" = 39h)

                        ;B = first number, A = second number

                        ;Multiply first number (B) by 10:
    push af             ;  Save A
    ld a,b              ;  Both A and B contain the first number
    add a,a             ;  A = A + A
    add a,a             ;  A = A + A
    add a,b             ;  A = A + B
    add a,a             ;  A = A + A
    ld b,a              ;  Save result in B
    pop af              ;  Recall A

                        ;B = (first number * 10), A = second number

    add a,b             ;Add them to make the final number
    ret                 ;Return the number

get_dec_one:
;Called from get_dec when the decimal number in args was found to have
;only one digit.  The digit is in B.  HL and C are rolled back because
;get_dec will advanced past the digit.
;
    ld a,b              ;A = B
    dec hl              ;Roll back HL
    inc c               ;Roll back C
    or a                ;Clear carry flag
    ret

syntax_err:
    db "Syntax error$"

trans_hz1500:
;Character translation table for Hazeltine 1500
;Bit 7 set (+80h) indicates the byte must be preceeded by the lead-in.
;
    db 0bh+80h, 0bh     ;0Bh -> 0Bh Cursor up
    db 0ch+80h, 0ch     ;0Ch -> 0Ch Cursor right
    db 0fh+80h, 13h     ;0Fh -> 13h Clear to end of line
    db 11h+80h, 1bh     ;11h -> 1Bh Move cursor to X,Y position
    db 12h+80h, 1eh     ;11h -> 1Eh Home cursor
    db 13h+80h, 12h     ;13h -> 12h Scroll up one line
    db 17h+80h, 14h     ;17h -> 14h Clear to end of screen
    db 18h+80h, 14h     ;18h -> 14h Clear to end of screen
    db 1ah+80h, 11h     ;1Ah -> 11h Insert a blank line
    db 1ch+80h, 1ah     ;1Ch -> 1Ah Clear screen
    db 1dh+80h, 1ah     ;1Dh -> 1Ah Clear screen
    db 19h+80h, 00h     ;19h -> 00h Null
    db 1fh+80h, 00h     ;1Fh -> 00h Null
    db 00h              ;End of table

trans_adm_tv:
;Character translation table for Lear Siegler ADM-3A and TeleVideo 912
;Bit 7 set (+80h) indicates the byte must be preceeded by the lead-in.
;
    db 31h+80h, 04h     ;31h -> 04h Set a TAB stop at current position
    db 32h+80h, 05h     ;32h -> 05h Clear TAB stop at current position
    db 33h+80h, 06h     ;33h -> 06h Clear all TAB stops
    db 6ah+80h, 0eh     ;6Ah -> 0Eh Reverse video on
    db 6bh+80h, 0fh     ;6Bh -> 0Fh Reverse video off
    db 51h+80h, 1ch     ;51h -> 1Ch Insert a space on current line
    db 57h+80h, 1dh     ;57h -> 1Dh Delete character at cursor
    db 45h+80h, 11h     ;45h -> 11h Insert a blank line
    db 52h+80h, 12h     ;52h -> 12h Scroll up one line
    db 54h+80h, 13h     ;54h -> 13h Clear to end of line
    db 74h+80h, 13h     ;74h -> 13h Clear to end of line
    db 59h+80h, 14h     ;59h -> 14h Clear to end of screen
    db 79h+80h, 14h     ;79h -> 14h Clear to end of screen
    db 2bh+80h, 1ah     ;2Bh -> 1Ah Clear screen
    db 2ah+80h, 1ah     ;2Ah -> 1Ah Clear screen
    db 3ah+80h, 1ah     ;3Ah -> 1Ah Clear screen
    db 3bh+80h, 1ah     ;3Bh -> 1Ah Clear screen
    db 5ah+80h, 1ah     ;5Ah -> 1Ah Clear screen
    db 3dh+80h, 1bh     ;3Dh -> 1Bh Move cursor to X,Y position
    db 28h+80h, 00h     ;28h -> 00h Null
    db 29h+80h, 00h     ;29h -> 00h Null
    db 00h              ;End of table
