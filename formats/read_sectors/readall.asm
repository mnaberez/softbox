;Prints a table of sector mappings:
;  CP/M track, CP/M sector, first four bytes of sector

warm:           equ  0000h  ;Warm start
const:          equ 0f006h  ;Console status
conin:          equ 0f009h  ;Console input
seldsk:         equ 0f01bh  ;Select disk drive
settrk:         equ 0f01eh  ;Set track number
setsec:         equ 0f021h  ;Set sector number
setdma:         equ 0f024h  ;Set DMA address
read:           equ 0f027h  ;Read selected sector
conout:         equ 0f00ch  ;Print char in C
put_hex_byte:   equ 0f402h  ;Print byte in A as hex

lf:             equ 0ah     ;Line Feed
cr:             equ 0dh     ;Carriage Return

drive_num:      equ 02h     ;Drive number of disk to read (2 = C:)
last_track:     equ 7dh     ;Last CP/M track (4040=27h, 8050=7Dh, 8250=0FDh)

    org 0100h   ;CP/M TPA

init:
    xor a               ;zero
    ld (cur_track),a    ;current cp/m track
    ld (cur_sector),a   ;current cp/m sector

loop:
    ;check for user abort

    call const          ;0=no key, 0ffh=key
    jp nz,abort         ;abort if key pressed

    ;read sector

    ld de,0             ;log disk in as new
    ld c,drive_num
    call seldsk         ;select disk

    ld bc,0080h         ;usual cp/m dma area
    call setdma         ;set dma address

    ld b,0              ;BC = current track
    ld a,(cur_track)
    ld c,a
    call settrk         ;set track

    ld b,0              ;BC = current sector
    ld a,(cur_sector)
    ld c,a
    call setsec         ;set sector

    call read           ;read sector
    jp nz,error

    ;print cp/m track and sector

    ld a,(cur_track)
    call put_hex_byte   ;print track
    ld c,','
    call conout         ;print comma
    ld a,(cur_sector)
    call put_hex_byte   ;print sector
    ld c,','
    call conout         ;print comma

    ;print first four bytes of sector

    ld hl,0080h
    ld c,(hl)
    call conout         ;print first byte
    inc hl
    ld c,(hl)
    call conout         ;print second byte
    inc hl
    ld c,(hl)
    call conout         ;print third byte
    inc hl
    ld c,(hl)
    call conout         ;print fourth byte

    ;print newline

    ld c,cr
    call conout
    ld c,lf
    call conout

    ;increment sector

    ld a,(cur_sector)   ;get current sector
    inc a               ;increment it
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

done:
    jp warm             ;all done

abort:
    call conin          ;consume the key pressed
                        ;fall through into error
error:
    ld c,'!'
    call conout
    jp warm

cur_track:
    db 00h

cur_sector:
    db 00h
