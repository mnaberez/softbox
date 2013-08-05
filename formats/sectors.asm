;Prints a table of sector mappings:
;  CP/M track, CP/M sector, PET track, PET sector
;
;Must be run against the 1983-06-09 BIOS.
;
;CBM 8050:
;
;  3984: 128 Byte Record Capacity
;   498: Kilobyte Drive  Capacity
;    64: 32  Byte Directory Entries
;    64: Checked  Directory Entries
;   256: Records/ Extent
;    16: Records/ Block
;    32: Sectors/ Track
;     0: Reserved Tracks
;
;CBM 4040:
;
;  1232: 128 Byte Record Capacity
;   154: Kilobyte Drive  Capacity
;    64: 32  Byte Directory Entries
;    64: Checked  Directory Entries
;   256: Records/ Extent
;    16: Records/ Block
;    32: Sectors/ Track
;     0: Reserved Tracks
;

x_drive:        equ 0044h   ;CP/M drive number
x_track:        equ 0045h   ;CP/M track
x_sector:       equ 0047h   ;CP/M sector
dos_trk:        equ 004dh   ;CBM track
dos_sec:        equ 004eh   ;CBM sector

conout:         equ 0f00ch  ;char in C
put_hex_byte:   equ 0f402h  ;byte in A
find_trk_sec:   equ 0f8dah

lf:             equ 0ah     ;Line Feed
cr:             equ 0dh     ;Carriage Return

    org 0100h   ;CP/M TPA

init:
    ld a,2              ;drive 2 (c:)
    ld (x_drive),a

    xor a
    ld (x_track),a
    ld (x_sector),a

loop:
    ;print cp/m track and sector

    ld a,(x_track)      ;track
    call put_hex_byte   ;print track
    ld c,','            ;comma character
    call conout         ;print comma
    ld a,(x_sector)     ;sector
    call put_hex_byte   ;print sector
    ld c,','            ;comma character
    call conout         ;print comma

    ;compute dos_trk and dos_sec

    call find_trk_sec

    ;print cbm track and sector

    ld a,(dos_trk)      ;cbm track
    call put_hex_byte
    ld c,','            ;comma character
    call conout         ;print comma
    ld a,(dos_sec)      ;cbm sector

    ;print newline

    call put_hex_byte
    ld c,cr
    call conout
    ld c,lf
    call conout

    ;increment sector

    ld a,(x_sector)     ;sector
    inc a               ;increment to next sector
    ld (x_sector),a     ;save it
    cp 20h              ;past last sector on track?
    jp nz,loop          ;  no: loop to do next sector

    ;increment track

    xor a
    ld (x_sector),a     ;zero sector
    ld a,(x_track)      ;track
    inc a               ;increment to next track
    ld (x_track),a      ;save it
    cp 7eh              ;past last track?
    jp nz,loop          ;  no: loop to do next track

    ret                 ;all done
