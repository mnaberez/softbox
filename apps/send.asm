bdos: equ 5             ;BDOS call entry point

    org 0100h

    lxi d,5ch           ;address of file control block
    mvi c,15            ;open the file
    call bdos
    inr a               ;any error ?
    lxi d, errmsg
    mvi c,9
    jz bdos             ;print message - no such file
    mvi a,7fh           ;clear junk from receiver
    call send
    mvi a,7fh           ;by sending two DELETE characters
    call send

nxtblk:
    lxi d,5ch           ;address of file control block
    mvi c,20            ;read next data block (128 bytes)
    call bdos
    ora a               ;end of file?
    mvi a, '#'          ;yes - send EOF and exit
    jnz send
    mvi a, ':'          ;else send block marker
    call send
    lxi h,80h
    xra a               ;clear checksum
nxtbyt:
    sub m               ;update checksum
    push h              ;save buffer pointer
    push psw            ;save checksum
    mov a,m             ;get data byte from buffer
    call sndhex         ;send byte in hex
    pop psw             ;get checksum back in A
    pop h               ;get buffer pointer back
    inr l               ;finished?
    jnz nxtbyt          ;no
    call sndhex         ;yes - send checksum
    jmp nxtblk          ;back for next block

errmsg:
    db 'File not found.$'

;Send a hex byte to the RS232 port

sndhex:
    push psw            ;save value to send
    rar                 ;get high nibble
    rar
    rar
    rar
    call sndnib         ;send high nibble
    pop psw             ;send low nibble
sndnib:
    ani 0fh             ;want lower 4 bits only
    adi 30h             ;convert to ASCII hex.
    cpi 3ah
    jc send
    adi 7

; Send a byte from accumulator to the RS232 port.
; This routine uses the CP/M list device but may be replaced by
; your own driver routine if necessary.

send:
    mov e, a            ;send a char (user patch)
    mvi c, 5
    jmp bdos            ;send to list device
    end
