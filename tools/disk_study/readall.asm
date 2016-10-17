;Prints a table of sector mappings:
;  CP/M track, CP/M sector, first four bytes of sector

warm:           equ  0000h  ;Warm start
dma_buf:        equ  0080h  ;Default DMA buffer area (128 bytes) for disk I/O
const:          equ 0f006h  ;Console status
conin:          equ 0f009h  ;Console input
seldsk:         equ 0f01bh  ;Select disk drive
settrk:         equ 0f01eh  ;Set track number
setsec:         equ 0f021h  ;Set sector number
setdma:         equ 0f024h  ;Set DMA address
read:           equ 0f027h  ;Read selected sector
conout:         equ 0f00ch  ;Print char in C

lf:             equ 0ah     ;Line Feed
cr:             equ 0dh     ;Carriage Return

drive_num:      equ 02h     ;Drive number of disk to read (2 = C:)
tracks:         equ 7eh     ;Total CP/M tracks (4040=28h, 8050=7Eh, 8250=0FEh)
sectors:        equ 20h     ;CP/M sectors per track (same for all CBM drives)

    org 0100h   ;CP/M TPA

init:
    xor a               ;zero
    ld (cur_track),a    ;current cp/m track
    ld (cur_sector),a   ;current cp/m sector

loop:
    ;check for user abort

    call const          ;0=no key, 0ffh=key
    or a                ;set flags
    jp nz,abort         ;abort if key pressed

    ;read sector

    ld de,0             ;log disk in as new
    ld c,drive_num
    call seldsk         ;select disk

    ld bc,dma_buf       ;usual cp/m dma area
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

    ;print bytes 2-5 of sector

    ld hl,dma_buf+2
    ld c,(hl)
    call conout         ;print byte 2
    inc hl
    ld c,(hl)
    call conout         ;print byte 3
    inc hl
    ld c,(hl)
    call conout         ;print byte 4
    inc hl
    ld c,(hl)
    call conout         ;print byte 5

    ;print newline

    ld c,cr
    call conout
    ld c,lf
    call conout

    ;increment sector

    ld a,(cur_sector)   ;get current sector
    inc a               ;increment it
    ld (cur_sector),a   ;save it
    cp sectors          ;past last sector on track?
    jp nz,loop          ;  no: loop to do next sector

    ;increment track

    xor a
    ld (cur_sector),a   ;zero sector
    ld a,(cur_track)    ;track
    inc a               ;increment to next track
    ld (cur_track),a    ;save it
    cp tracks           ;past last track?
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

put_hex_byte:
;Write the byte in A to console out as a two digit hex number.
;
    push af             ;Preserve A
    rra                 ;Rotate high nibble into low
    rra
    rra
    rra
    call put_hex_nib    ;Write it to console out
    pop af              ;Recall A for the low nibble
                        ;Fall through to write it to console out
put_hex_nib:
;Write the nibble in A to console out as a one digit hex number.
;
    and 0fh             ;Mask off high nibble
    cp 0ah              ;Convert low nibble to ASCII char
    jr c,nib1
    add a,07h
nib1:
    add a,30h
    ld c,a
    jp conout           ;Write char to console out and return.

cur_track:
    db 00h

cur_sector:
    db 00h
