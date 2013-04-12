; z80dasm 1.1.3
; command line: z80dasm --origin=256 --address --labels set.com

bdos:       equ  0005h  ;BDOS entry point
args:       equ  0080h  ;Command line arguments passed from CCP
dirsize:    equ 0d8b2h  ;CCP directory width: 0=1 col, 1=2 cols, 3=4 cols
lpt_dev:    equ 0ea61h  ;CBM printer (LPT:) IEEE-488 primary address
ptr_dev:    equ 0ea62h  ;Paper Tape Reader (PTR:) IEEE-488 primary address
ptp_dev:    equ 0ea63h  ;Paper Tape Punch (PTP:) IEEE-488 primary address
leadin:     equ 0ea68h  ;Terminal command lead-in: 1bh=escape, 7eh=tilde
xy_order:   equ 0ea69h  ;X,Y order when sending move-to: 0=X first, 1=Y first
y_offset:   equ 0ea6ah  ;Offset added to Y when sending move-to sequence
x_offset:   equ 0ea6bh  ;Offset added to X when sending move-to sequence
ul1_dev:    equ 0ea66h  ;ASCII printer (UL1:) IEEE-488 primary address
scrtab:     equ 0ea80h  ;64 byte buffer for tab stops
jp_conout:  equ 0ea0ch  ;Jumps to conout (Console Output) routine in BIOS

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
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
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
    cp 'T'              ;'T' = Set line spacing to tall
    jp z,set_t
    cp 'G'              ;'G' = Set line spacing to short
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
    ld c,15h            ;15h = Go to uppercase mode
    jp jp_conout        ;Jump out to conout (in BIOS) through jp_conout.
                        ;  It will return to CP/M.

set_l:
;Set lowercase mode
;  SET L
;
    ld c,16h            ;16h = Go to lowercase mode
    jp jp_conout        ;Jump out to conout (in BIOS) through jp_conout.
                        ;  It will return to CP/M.

set_g:
;Set line spacing to tall
;  SET T
;
    ld c,17h            ;17h = Set line spacing to tall
    jp jp_conout        ;Jump out to conout (in BIOS) through jp_conout.
                        ;  It will return to CP/M.

set_t:
;Set line spacing to short
;  SET G
;
    ld c,18h            ;18h = Set line spacing to short
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
    ld b,1bh            ;1bh = ESC
    jp z,l018eh
    cp 'T'
    jp nz,bad_syntax
    ld b,7eh            ;7eh = Tilde
l018eh:
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

    ld hl,tabs_adm_tv   ;HL = address of ADM-3A/TV-912 tabs table
                        ;TODO: This is not needed because HL will
                        ;      be set to the correct tabs table
                        ;      in both adm3a_tv912 and hz1500.

    cp 'A'              ;'A' = ADM-3A
    jp z,adm3a_tv912

    cp 'T'              ;'T' = TeleVideo 912
    jp z,adm3a_tv912

    cp 'H'              ;'H' = Hazeltine 1500 with ~ lead-in
    ld b,'~'            ;B = ~ lead-in
    jp z,hz1500

    cp 'E'              ;'E' = Hazeltine 1500 with ESC lead-in
    jp nz,bad_syntax    ;Jump to bad syntax if not 'E'

    ld b,1bh            ;B = ESC lead-in
                        ;Fall through into hz1500

hz1500:
;Hazeltine 1500
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

                        ;Copy tab stop data:
    ld hl,tabs_hz1500   ;  HL = address of Hazeltine 1500 tabs table
    ld de,scrtab        ;  DE = address of BIOS scrtab area
    ld bc,001bh         ;  BC = 27 bytes to copy
    ldir                ;  Copy BC bytes from (HL) to (DE)
    ret

adm3a_tv912:
;ADM-3A and TeleVideo 912
;
                        ;Set cursor move-to offsets:
    ld a,20h            ;  20h = offset used by ADM-3A and compatibles
    ld (y_offset),a     ;  Set Y offset for cursor move-to sequence
    ld (x_offset),a     ;  Set X offset

                        ;Set cursor move-to order:
    xor a               ;  A=0 indicates Y-first
    ld (xy_order),a     ;  Set X-Y order for cursor move-to sequence

                        ;Set lead-in:
    ld a,1bh            ;  A = ESC character
    ld (leadin),a       ;  Set terminal lead-in character

                        ;Copy tab stop data:
    ld hl,tabs_adm_tv   ;  HL = address of tabs_adm_tv
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
    ;XXX no jump
                        ;TODO: This is a bug.  There should be a jump here.
                        ;      Instead it just falls through, where DE will
                        ;      be immediately overwritten.

set_p:
;Set IEEE-488 primary address of LPT:
;  SET P=?
;
    ld de,lpt_dev       ;DE = address of LPT: device number
    jp store_dev

set_n:
;Set IEEE-488 primary address of PTP:
;  SET N=?
;
    ld de,ptp_dev       ;DE = address of PTP: device number
    jp store_dev

set_r:
;Set IEEE-488 primary address of PTR:
;  SET R=?
;
    ld de,ptr_dev       ;DE = address of PTR: device number
                        ;Fall through to store_dev

store_dev:
;DE = address to receive device number
;
    call sub_0223h      ;A = device number
    jp c,bad_syntax     ;Jump to syntax error if parsing number failed
    ld (de),a           ;Store device number
    ret

sub_0223h:
    inc hl
    ld a,(hl)
    dec c
    scf
    ret m
    sub 30h
    jp c,sub_0223h
    cp 0ah
    jp nc,sub_0223h
    ld b,a
    inc hl
    dec c
    jp m,l024dh
    ld a,(hl)
    sub 30h
    jp c,l024dh
    cp 0ah
    jp nc,l024dh
    push af
    ld a,b
    add a,a
    add a,a
    add a,b
    add a,a
    ld b,a
    pop af
    add a,b
    ret

l024dh:
    ld a,b
    dec hl
    inc c
    or a
    ret

syntax_err:
    db "Syntax error$"

tabs_hz1500:
;Tab stop data for Hazeltine 1500
    db 8bh,0bh,8ch,0ch,8fh,13h,91h,1bh,92h,1eh,93h,12h,97h,14h
    db 98h,14h,9ah,11h,9ch,1ah,9dh,1ah,99h,00h,9fh,00h,00h

tabs_adm_tv:
;Tab stop data for Lear Siegler ADM-3A and TeleVideo 912
    db 0b1h,04h,0b2h,05h,0b3h,06h,0eah,0eh,0ebh,0fh,0d1h,1ch,0d7h
    db 1dh,0c5h,11h,0d2h,12h,0d4h,13h,0f4h,13h,0d9h,14h,0f9h,14h
    db 0abh,1ah,0aah,1ah,0bah,1ah,0bbh,1ah,0dah,1ah,0bdh,1bh,0a8h
    db 00h,0a9h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
