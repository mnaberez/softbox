;Prints a table of sector mappings:
;  CP/M track, CP/M sector, PET track, PET sector
;
;Must be run against the 1983-06-09 BIOS.

dos_trk:        equ 004dh   ;CBM track
dos_sec:        equ 004eh   ;CBM sector

conout:         equ 0f00ch  ;Print char in C
seldsk:         equ 0f01bh  ;Select disk drive
settrk:         equ 0f01eh  ;Set track number
setsec:         equ 0f021h  ;Set sector number
put_hex_byte:   equ 0f402h  ;Print byte in A as hex
sub_f6b9h:      equ 0f6b9h
find_trk_sec:   equ 0f8dah

lf:             equ 0ah     ;Line Feed
cr:             equ 0dh     ;Carriage Return

drive_num:      equ 02h     ;Drive number of disk to read (2 = C:)
last_track:     equ 7dh     ;Last CP/M track (4040=27h, 8050=7Dh, 8250=0FDh)

    org 0100h   ;CP/M TPA

init:
    ld de,0             ;log disk in as new
    ld c,drive_num      ;drive 2 (c:)
    call seldsk         ;select disk

    xor a
    ld (cur_track),a    ;zero the current cp/m track
    ld (cur_sector),a   ;zero the current cp/m sector

loop:
    ;set cp/m track and sector

    ld b,0
    ld a,(cur_track)
    ld c,a
    call settrk         ;set track

    ld b,0
    ld a,(cur_sector)
    ld c,a
    call setsec         ;set sector

    ;print cp/m track and sector

    ld a,(cur_track)    ;track
    call put_hex_byte   ;print track
    ld c,','            ;comma character
    call conout         ;print comma
    ld a,(cur_sector)   ;sector
    call put_hex_byte   ;print sector
    ld c,','            ;comma character
    call conout         ;print comma

    ;compute dos_trk and dos_sec

    call sub_f6b9h
    call find_trk_sec

    ;print cbm track and sector

    ld a,(dos_trk)      ;cbm track
    call put_hex_byte
    ld c,','            ;comma character
    call conout         ;print comma
    ld a,(dos_sec)      ;cbm sector
    call put_hex_byte

    ;print newline

    ld c,cr
    call conout
    ld c,lf
    call conout

    ;increment sector

    ld a,(cur_sector)   ;sector
    inc a               ;increment to next sector
    ld (cur_sector),a   ;save it
    cp 20h              ;past last sector on track?
    jp nz,loop          ;  no: loop to do next sector

    ;increment track

    xor a
    ld (cur_sector),a   ;zero sector
    ld a,(cur_track)    ;track
    inc a               ;increment to next track
    ld (cur_track),a    ;save it
    cp last_track+1     ;past last track?
    jp nz,loop          ;  no: loop to do next track

    ret                 ;all done

cur_track:
    db 0

cur_sector:
    db 0
