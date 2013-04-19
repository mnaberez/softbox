; z80dasm 1.1.3
; command line: z80dasm --labels --address read.com

usart:      equ 08h     ;8251 USART (IC15)
usart_db:   equ usart+0 ;  Data Buffer
usart_st:   equ usart+1 ;  Status Register

warm:       equ  0000h  ;Warm start entry point
bdos:       equ  0005h  ;BDOS entry point
fcb:        equ  005ch  ;BDOS default FCB
const:      equ 0f006h  ;BIOS Console status
conin:      equ 0f009h  ;BIOS Console input

    org 0100h

    ld hl,5ch+12
    ld c,15h
clrfcb:
    ld (hl),00h         ;clear the file control block
    inc hl
    dec c
    jp nz,clrfcb

    ld de,fcb+1         ;check for file name
    ld a,(de)
    cp 20h
    ret z               ;none - return

    ld c,0bh
chkwld:
    ld a,(de)           ;check no wildcards
    inc de
    cp '?'
    ret z
    dec c
    jp nz,chkwld
    ld de,fcb           ;none - ok to delete file

    ld c,13h            ;C = 13h, F_DELETE (Delete File)
    call bdos           ;BDOS System Call
    ld de,fcb           ;0126 11 5c 00

    ld c,16h            ;C = 16h, F_MAKE (Create File)
    call bdos           ;BDOS System Call
    inc a               ;check for directory error
    jp z,error

    ld de,ready         ;0132 11 a5 01
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
    call bdos           ;ready to receive
sync:
    call read           ;synchronize with sender
    cp 7fh              ;RUBOUT - ignore
    jp nz,sync

nxtblk:
    call read           ;read a character
    cp 7fh
    jp z,nxtblk         ;rubout - ignore
    cp '#'              ;end of file?
    jp z,eof
    cp ':'              ;data block?
    jp nz,chkerr        ;no - signal an error
    ld hl,0080h         ;yes
    ld b,00h            ;clear checksum
nxtbyt:
    push hl
    push bc
    call rdhex          ;read next byte
    pop bc
    pop hl
    ld (hl),a           ;save in buffer
    add a,b             ;update checksum
    ld b,a
    inc l
    jp nz,nxtbyt        ;not finished
    push bc
    call rdhex          ;finished - read checksum
    pop bc
    add a,b
    jp nz,chkerr        ;checksum error ?
    ld e,'.'
    ld c,02h            ;C = 02h, C_WRITE (Console Output)
    call bdos           ;BDOS System Call
    ld de,fcb           ;write data block to file
    ld c,15h            ;C = 15h, F_WRITE (Write Next Record)
    call bdos           ;BDOS System Call
    or a
    jp z,nxtblk         ;disk full ?
error:
    ld de,errmsg        ;yes - complain to user
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
    call bdos           ;BDOS System Call
    jp exit
chkerr:
    ld de,chkser
    ld c,09h            ;C = 09h, C_WRITESTR (Output String)
    call bdos           ;BDOS System Call
eof:
    ld de,fcb
    ld c,10h            ;C = 10h, C_READSTR (Buffered Console Input)
    call bdos           ;BDOS System Call
exit:
    ld a,37h
    out (usart_st),a
    jp warm
ready:
    db 0dh,0ah,"Ready to receive",0dh,0ah,"$"
errmsg:
    db 0dh,0ah,"Disk write error$"
chkser:
    db 0dh,0ah,"Checksum error$"
rdhex:
    call rdnib          ;read high nibble
    add a,a             ;multiple by 16
    add a,a
    add a,a
    add a,a
    push af             ;save
    call rdnib          ;read low nibble
    pop bc
    add a,b             ;add to high nibble * 16
    ret

rdnib:
    call read           ;read one character
    sub 30h             ;convert to binary nibble
    cp 0ah
    ret c
    sub 07h
    ret

read:
    call const          ;call CONST vector
    or a
    jp z,nokey
    call conin          ;key pressed - call conin
    cp 03h              ;control-c?
    jp z,eof            ;yes - abort

nokey:
    ld a,37h            ;else assert CLEAR TO SEND signal
    out (usart_st),a
wait:
    in a,(usart_st)     ;wait for character
    and 02h
    jp z,wait
    ld a,17h            ;remove CLEAR TO SEND signal
    out (usart_st),a
    in a,(usart_db)     ;read the character into a
    and 7fh             ;remove the parity bit
    ret
