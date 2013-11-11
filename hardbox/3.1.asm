; z80dasm 1.1.2
; command line: z80dasm.exe --labels --origin=57344 3.1.bin

;HardBox Memory Map:
;  F000-FFFF  BIOS ROM High (IC4)   4096
;  E000-EFFF  BIOS ROM Low (IC3)    4096
;
ppi1:     equ 10h       ;8255 PPI #1 (IC17)
ppi1_pa:  equ ppi1+0    ;  Port A: IEEE-488 Data In
ppi1_pb:  equ ppi1+1    ;  Port B: IEEE-488 Data Out
ppi1_pc:  equ ppi1+2    ;  Port C: DIP Switches
ppi1_cr:  equ ppi1+3    ;  Control Register

ppi2:     equ 14h       ;8255 PPI #2 (IC16)
ppi2_pa:  equ ppi2+0    ;  Port A:
                        ;    PA7 IEEE-488 IFC in
                        ;    PA6 IEEE-488 REN in
                        ;    PA5 IEEE-488 SRQ in
                        ;    PA4 IEEE-488 EOI in
                        ;    PA3 IEEE-488 NRFD in
                        ;    PA2 IEEE-488 NDAC in
                        ;    PA1 IEEE-488 DAV in
                        ;    PA0 IEEE-488 ATN in
ppi2_pb:  equ ppi2+1    ;  Port B:
                        ;    PB7 IEEE-488 IFC out
                        ;    PB6 IEEE-488 REN out
                        ;    PB5 IEEE-488 SRQ out
                        ;    PB4 IEEE-488 EOI out
                        ;    PB3 IEEE-488 NRFD out
                        ;    PB2 IEEE-488 NDAC out
                        ;    PB1 IEEE-488 DAV out
                        ;    PB0 IEEE-488 ATN out
ppi2_pc:  equ ppi2+2    ;  Port C:
                        ;    PC7 Unused
                        ;    PC6 Unused
                        ;    PC5 Corvus DIRC
                        ;    PC4 Corvus READY
                        ;    PC3 Unused
                        ;    PC2 LED "Ready"
                        ;    PC1 LED "B"
                        ;    PC0 LED "A"
ppi2_cr:  equ ppi2+3    ;  Control Register

corvus:   equ 18h       ;Corvus data bus

cr:       equ 0dh       ;Carriage Return
rvs:      equ 12h       ;Reverse on

ifc:      equ 80h       ;IFC
ren:      equ 40h       ;REN
srq:      equ 20h       ;SRQ
eoi:      equ 10h       ;EOI
nrfd:     equ 08h       ;NRFD
ndac:     equ 04h       ;NDAC
dav:      equ 02h       ;DAV
atn:      equ 01h       ;ATN 

error_00: equ 00h       ;"OK"
error_01: equ 01h       ;"FILES SCRATED"
error_22: equ 16h       ;"READ ERROR"
error_25: equ 19h       ;"WRITE ERROR"
error_26: equ 1ah       ;"WRITE PROTECED"
error_30: equ 1eh       ;"SYNTAX ERROR"
error_31: equ 1fh       ;"SYNTAX ERROR (INVALID COMMAND)"
error_32: equ 20h       ;"SYNTAX ERROR (LONG LINE)"
error_33: equ 21h       ;"SYNTAX ERROR(INVALID FILENAME)"
error_34: equ 22h       ;"SYNTAX ERROR(NO FILENAME)"
error_49: equ 31h
error_50: equ 32h       ;"RECORD NOT PRESENT"
error_51: equ 33h       ;"OVERFLOW IN RECORD"
error_52: equ 34h       ;"FILE TOO LARGE"
error_60: equ 3ch       ;"WRITE FILE OPEN"
error_61: equ 3dh       ;"FILE NOT OPEN"
error_62: equ 3eh       ;"FILE NOT FOUND"
error_63: equ 3fh       ;"FILE EXISTS"
error_64: equ 40h       ;"FILE TYPE MISMATCH"
error_65: equ 41h       ;"NO BLOCK"
error_66: equ 42h       ;"ILLEGAL TRACK OR SECTOR"
error_72: equ 48h       ;"DISK FULL"
error_84: equ 54h       ;"DRIVE NOT CONFIGURED"
error_89: equ 59h       ;"USER #"
error_90: equ 5ah       ;"INVALID USER NAME"
error_91: equ 5bh       ;"PASSWORD INCORRECT"
error_92: equ 5ch       ;"PRIVILEGED COMMAND"
error_93: equ 5dh       ;"BAD SECTORS CORRECTED" (unused!)
error_94: equ 5eh       ;"LOCK ALREADY IN USE"
error_95: equ 5fh       ;"SUNOL DRIVE ERROR"
error_96: equ 60h       ;"SUNOL DRIVE SIZE"
error_98: equ 62h       ;"VERSION #"
error_99: equ 63h       ;"SMALL SYSTEMS HARDBOXVERSION #"

t_file:   equ 01h       ;"FILE"
t_write:  equ 02h       ;"WRITE"
t_error:  equ 03h       ;" ERROR"
t_syntax: equ 04h       ;"SYNTAX"
t_invalid:equ 05h       ;"INVALID"
t_command:equ 06h       ;"COMMAND"
t_read:   equ 07h       ;"READ"
t_name:   equ 08h       ;"WRITE"
t_record: equ 09h       ;"RECORD"
t_open:   equ 0ah       ;" OPEN"
t_not:    equ 0bh       ;" NOT"
t_user:   equ 0ch       ;"USER"
t_version:equ 0dh       ;" VERSION #"
t_drive:  equ 0eh       ;" DRIVE"
t_sunol:  equ 0fh       ;"SUNOL"

typ_seq:  equ 0         ;File type for seq (seqentiell file)
typ_usr:  equ 1         ;File type for usr (user file)
typ_prg:  equ 2         ;File type for prg (program file)
typ_rel:  equ 3         ;File type for rel (relative file)

devnum:   equ 0000h     ;Read via DIP switch or set via command "!D"
userid:   equ 0002h     ;Read via DIP switch

usrdat    equ 0004h     ;usrdat to l00023 is copied from sector 4,5,6 or 7 (8, 9, 10 or 12) depended on (userid)
						;User Area name, User area size in kilobytes, Type of user area (Single user or Multi-user)
						;Maximum numbers of files allowed, Size (in kilobyte) allocated for direct access
						;Physical drive number, Starting sector number on drive (256 bytes sector)
						;# of "tracks per drive" for direct acceess, # of "sectors per track" for direct access
phydrv:   equ 0004h     ;Physical drive number (1 Byte)
usrsrt:   equ 0005h     ;Starting sector number on drive (3 Bytes)
l0008h:   equ 0008h     ;User area size in kilobytes, there are 4 blocks (2 Bytes)
l000ah:   equ 000ah     ;(1 Byte) (Disallow write)
maxdir:   equ 000bh     ;Maxumum numbers of files allowed (2 Bytes)
usrsiz:   equ 000dh     ;Size (in kilobyte) allocated for direct access, these are 4 blocks (2 Bytes)
l000fh:   equ 000fh     ;# of "tracks per drive" for direct access (2 Bytes)
l0011h:   equ 0011h     ;# of "sectors per track" for direct access (2 Bytes) l0011h and l0013h the same?
l0013h:   equ 0013h     ;(1 Byte)
;         equ 0014h     ;User area name (16 Bytes) ???

dirsrt:   equ 0024h     ;Absolute sector where directory starts (3 Bytes, 4 Sector after the user area starts)
l0027h:   equ 0027h     ;(3 Bytes)
l002ah:   equ 002ah     ;(2 Bytes)
l002ch:   equ 002ch     ;(3 Bytes)
l002fh:   equ 002fh     ;(2 Bytes)
l0031h:   equ 0031h     ;(3 bytes)
l0034h:   equ 0034h     ;Size (in kilobytes) usable for normal files, these are 4 blocks (2 Bytes)
l0036h:   equ 0036h     ;Starting sector number for direct access (3 bytes)
l0039h:   equ 0039h     ;(2 Bytes)
bamsrt:   equ 003bh     ;Starting sector number where BAM for direct access starts (3 Bytes)
username: equ 003eh     ;username is copied from sector 0 or 1 (2 or 3) depended on userid (16 Bytes)
bamsec:   equ 004eh     ;BAM sector number currently in bambuf (1 Byte)
drvnum:   equ 004fh     ;Drive number (0 or 1)
errcod:   equ 0050h     ;Error code in error message
errtrk:   equ 0051h     ;Track number in error message (3 Bytes)
errsec:   equ 0054h     ;Sector number in error message (3 Bytes)
l0057h:   equ 0057h     ;BAM for files? 8192 Bits 1024 Bytes? 8192 Blocks are 2 MB data
l0457h:   equ 0457h     ;BAM for direct access? 8192 Bits 1024 Bytes?
l0857h:   equ 0857h     ;(n-times 32 Bytes)

sa:       equ 0ae7h
l0ae8h:   equ 0ae8h     ;(2 Bytes points to l0857h)

dirbuf:   equ 0af5h     ;Directory block buffer (256 Bytes)
cmdbuf:   equ 0bf5h     ;(128 Bytes)
l0c75h:   equ 0c75h     ;(256 Bytes)

filnam:   equ 0d45h     ;(8 or 16 Bytes)

l0d56h:   equ 0d56h     ;(16 bytes)

l0d68h:   equ 0d68h

dirhid:   equ 0d6eh     ;Flag for show hidden files on directory ("H": Yes, else: no)
bufs:     equ 0d6fh     ;(16 Buffers)
bufsa0:   equ bufs+000h ;(256 Bytes)
bufsa1:   equ bufs+100h ;(256 Bytes)
bufsa2:   equ bufs+200h ;(256 Bytes)
bufsa3:   equ bufs+300h ;(256 Bytes)
bufsa4:   equ bufs+400h ;(256 Bytes)
bufsa5:   equ bufs+500h ;(256 Bytes)
bufsa6:   equ bufs+600h ;(256 Bytes)
bufsa7:   equ bufs+700h ;(256 Bytes)
bufsa8:   equ bufs+800h ;(256 Bytes)
bufsa9:   equ bufs+900h ;(256 Bytes)
bufsa10:  equ bufs+0a00h ;(256 Bytes)
bufsa11:  equ bufs+0b00h ;(256 Bytes)
bufsa12:  equ bufs+0c00h ;(256 Bytes)
bufsa13:  equ bufs+0d00h ;(256 Bytes)
bufsa14:  equ bufs+0e00h ;(256 Bytes)
bufsa15:  equ bufs+0f00h ;(256 Bytes)

eoisav:   equ 256fh
dirout:   equ 2570h     ;Here where a directory output line stored before output (??? Bytes)

wrtprt:   equ 25f0h     ;Points to current position to writee to ieee (2 Bytes)
endbuf:   equ 25f2h     ;Points to end of buffer to write to ieee (2 Bytes)

l260ch:   equ 260ch     ;Flag if drive is configured (0: Not Configured, 1: Configured)
wrtbuf:   equ 2610h     ;(256 Bytes)
rdbuf:    equ 2710h     ;(256 Bytes)
cpbuf:    equ 2810h     ;(256 Bytes)
bambuf:   equ 2910h     ;BAM sector bamsec used in read_bam and write_bam or for B-A and B-F (256 Bytes)

stack:    equ 2a93h

buffers:  equ 3000h     ;(16 Buffer)
buffer0:  equ buffers   ;(256 Bytes)
buffer1:  equ 3100h     ;(256 Bytes)
buffer2:  equ 3200h     ;(256 Bytes)
buffer3:  equ 3300h     ;(256 Bytes)
buffer4:  equ 3400h     ;(256 Bytes)
buffer5:  equ 3500h     ;(256 Bytes)
buffer6:  equ 3600h     ;(256 Bytes)
buffer7:  equ 3700h     ;(256 Bytes)
buffer8:  equ 3800h     ;(256 Bytes)
buffer9:  equ 3900h     ;(256 Bytes)
buffer10: equ 3a00h     ;(256 Bytes)
buffer11: equ 3b00h     ;(256 Bytes)
buffer12: equ 3c00h     ;(256 Bytes)
buffer13: equ 3d00h     ;(256 Bytes)
buffer14: equ 3e00h     ;(256 Bytes)
buffer15: equ 3f00h     ;(256 Bytes)

    org	0e000h

le000h:
	jp reset

reset:
	ld a,99h            ;Set PPI #1 control
                        ;  Bit 7: IO   1 = I/O mode (not BSR)
                        ;  Bit 6: GA1  0 = Group A as Mode 1 (Simple I/O)
                        ;  Bit 5: GA0  0
                        ;  Bit 4: PA   1 = Group A, Port A as Input
                        ;  Bit 3: PCu  1 = Group A, Port C upper as Input
                        ;  Bit 2: GB   0 = Group B as Mode 1 (Simple I/O)
                        ;  Bit 1: PB   0 = Group B, Port B as Output
                        ;  Bit 0: PCl  1 = Group B, Port C lower as Input
	out (ppi1_cr),a

	ld a,98h            ;Set PPI #2 control
                        ;  Bit 7: IO   1 = I/O mode (not BSR)
                        ;  Bit 6: GA1  0 = Group A as Mode 1 (Simple I/O)
                        ;  Bit 5: GA0  0
                        ;  Bit 4: PA   1 = Group A, Port A as Input
                        ;  Bit 3: PCu  1 = Group A, Port C upper as Input
                        ;  Bit 2: GB   0 = Group B as Mode 1 (Simple I/O)
                        ;  Bit 1: PB   0 = Group B, Port B as Output
                        ;  Bit 0: PCl  0 = Group B, Port C lower as Output
	out (ppi2_cr),a

	ld a,04h
	out (ppi2_pc),a     ;Turn off "Ready" LED, turn on "A" and "B" LEDs 

	xor a               ;A=0	
	out (ppi1_pb),a     ;Clear IEEE data out 

	ld a,ifc
	out (ppi2_pb),a     ;Clear IEEE control out 

	ld c,02h            ;C = 2 blinks for RAM failure
	ld hl,0000h         ;RAM start address 
	ld de,4000h         ;RAM end address + 1 
le01eh:
	ld (hl),l	
	inc hl	
	dec de	
	ld a,e	
	or d	
	jr nz,le01eh

	ld hl,0000h         ;RAM start address 
	ld de,4000h         ;RAM end address + 1 
le02bh:
	ld a,(hl)	
	cp l	
	jr nz,test_failed
	cpl	
	ld (hl),a	
	inc hl	
	dec de	
	ld a,e	
	or d	
	jr nz,le02bh

	ld hl,0000h         ;RAM start address 
	ld de,4000h         ;RAM end address + 1 
le03dh:
	ld a,(hl)	
	cpl	
	cp l	
	jr nz,test_failed
	inc hl	
	dec de	
	ld a,e	
	or d	
	jr nz,le03dh

	ld sp,stack

	ld hl,le000h        ;ROM start address 
	ld bc,1fffh         ;Number of code bytes in the ROM 
	call calc_checksum  ;Calculate ROM checksum 

	ld c,03h            ;C = 3 blinks for ROM failure 
	ld hl,checksum      ;HL = address of checksum byte in ROM 
	cp (hl)             ;Any difference from the calculated value? 	
	jr z,test_passed    ;  No: ROM check passed 

test_failed:
;Self-test failed.  Blink the LED forever.
;
;C = Number of blinks (2=RAM failed, 3=ROM failed)
; 
	ld b,c	

le05dh:
	xor a
	out (ppi2_pc),a     ;Turn on all LEDs ("Ready" LED, "A" and "B")

	ld de,0ffffh
le063h:
	dec de	
	ld a,e	
	or d	
	jr nz,le063h        ;Delay loop

	ld a,04h
	out (ppi2_pc),a     ;Turn off "Ready" LED, turn on "A" and "B" LEDs 

	ld de,0ffffh
le06fh:
	dec de	
	ld a,e	
	or d	
	jr nz,le06fh        ;Delay loop

	djnz le05dh         ;Decrement B, loop until B=0

	ld b,03h
	ld de,0ffffh
le07bh:
	dec de	
	ld a,e	
	or d	
	jr nz,le07bh        ;Delay loop
	djnz le07bh         ;Decrement B, loop until B=0

	jr test_failed

calc_checksum:
;Calculate the ROM checksum.
;
;HL = start address of ROM
;BC = number of bytes to process
;
;Returns the checksum in A.
;
	xor a               ;A=0	
le085h:
	add a,(hl)          ;Add byte at pointer to A 	
	rrca	
	ld d,a              ;Save A in D 	
	inc hl              ;Increment pointer 	
	dec bc              ;Decrement byte counter 	
	ld a,b	
	or c                ;Test if byte counter is zero 	
	ld a,d              ;Recall A from D 	
	jr nz,le085h        ;Loop if more bytes remaining 
	ret
	
test_passed:
	ld bc,0000h

le093h:
	in a,(ppi2_pc)
	xor 04h
	out (ppi2_pc),a     ;Invert "Ready" LED

	ld de,8000h
le09ch:
	in a,(ppi2_pc)
	and 010h            ;Corvus READY
	jr z,le0a3h
	inc bc	
le0a3h:
	dec de	
	ld a,e	
	or d	
	jr nz,le09ch
	ld a,b	
	or a	
	jr z,le093h

	ld a,04h
	out (ppi2_pc),a     ;Turn off "Ready" LED, turn on "A" and "B" LEDs 
	call corv_init      ;Initialize the Corvus controller 

	in a,(ppi1_pc)		;Read DIP switches
	cpl	
	rra					;Shift 1 bit right
	and 07h			    ;Use only these bits ----xxx-
	add a,008h			;plus 8 (0=8, 1=9, ... 7=15)
	ld (devnum),a

	in a,(ppi1_pc)		;Read DIP switches
	cpl	
	ld c,a	
	rra	
	rra	
	rra	
	rra					;Shift 4 bits right

	ld b,04h
le0c8h:
	rra	
	rl c
	djnz le0c8h

	ld a,c	
	and 01fh			;Now we have ---04567

init_user:
;Init user with user data
;A=User ID
;
	ld sp,stack

	ld hl,00004h
	ld de,00005h
	ld bc,02a0eh
	ld (hl),000h
	ldir                ;Copy BC bytes from (HL) to (DE)
	
	ld (userid),a
	xor a               ;A=0	
	ld (l260ch),a
	ld a,error_84       ;"DRIVE NOT CONFIGURED"
	call error_out
	ld hl,cmdbuf
	ld (00af3h),hl
	ld a,(userid)       ;Get User ID
	cp 01fh             ;Is it 31?
	jr nz,le100h
	xor a               ;A=0	
	ld (userid),a       ;  Yes: Set it to 0
	jp le2aeh           ;  And don't configure the drive!

le100h:
	ld de,0010h
	xor a               ;ADE=000010h (Sector 16)	
	ld b,1              ;B=Corvus drive number (1)
	ld hl,rdbuf         ;HL=rdbuf (target address)
	call corv_read_sec  ;Reads a sector (256 bytes)

	ld a,(rdbuf+8)
	cp "H"              ;H for Hard?
	jp nz,le2aeh        ;  No: Unknown format, skip configuring
	ld a,(rdbuf+9)
	cp "B"              ;B for Box?
	jp nz,le2aeh        ;  No: Unknown format, skip configuring

	ld hl,l260ch
	inc (hl)
	call error_ok       ;"OK" overwrites "DRIVE NOT CONFIGURED"

	ld a,(userid)
	rr a
	rr a
	rr a
	rr a
	and 00001111b
	ld e,a              ;E=0 for User ID 0 .. 15, or E=1 for User ID 16..30
	xor a               ;A=0	
	ld d,a              ;ADE=0 or 1 (2 or 3) depended on (userid) to read the username
	ld b,1              ;B=Corvus drive number (1)
	ld hl,rdbuf         ;HL=rdbuf (target address)
	call corv_read_sec  ;Reads a sector (256 bytes)

	ld a,(userid)
	add a,a	
	add a,a	
	add a,a	
	add a,a	
	ld c,a
	ld b,0              ;BC=(userid)*16
	ld hl,rdbuf
	add hl,bc           ;HL=rdbuf+BC
	ld de,username
	ld bc,0010h         ;BC=0010h (16 bytes)
	ldir                ;Copy BC bytes from (HL) to (DE) 

	ld a,(userid)
	rra	
	rra	
	rra	
	and 00011111b
	add a,4
	ld e,a              ;E=(userid)/8+4
	xor a               ;A=0	
	ld d,a              ;ADE=4,5,6 or 7 (8, 9, 10 or 11) depended on (userid)
	ld b,1              ;B=Corvus drive number (1)
	ld hl,rdbuf         ;HL=rdbuf (target address)
	call corv_read_sec  ;Reads a sector (256 bytes)

	ld a,(userid)
	and 00000111b
	rrca	
	rrca	
	rrca	
	ld c,a
	ld b,0              ;BC=(userid)*32
	ld hl,rdbuf
	add hl,bc           ;HL=rdbuf+BC
	ld de,phydrv
	ld bc,0020h         ;BC=0020h (32 bytes)
	ldir                ;Copy BC bytes from (HL) to (DE) 

	call sub_fa74h      ;???

	ld hl,(maxdir)      ;HL=Maximum directory entries in the user area (maxdir)
	ld (l002ah),hl      ;(l002ah)=HL

	ld a,(l0008h+1)
	ld e,a              ;A ??? entry is 256 Bytes long
	ld d,0              ;DE=(l0008h)/256
	add hl,de
	ld (l002fh),hl      ;(l002fh)=HL+DE

	ld hl,(usrsiz)      ;HL=User area size in kb (usrsiz)

	ld a,h	
	ld b,9              ;A ??? need 2 Bytes for 1 kilobyte
	call hl_shr_b       ;HL=HL/512

	inc hl
	ld (l0039h),hl      ;(l0039h)=HL+1

	ld hl,(maxdir)
	ld b,5              ;A ??? entry is 8 Bytes long
	call hl_shr_b       ;HL=(maxdir)/32

	inc hl              ;HL=HL+1	

	ex de,hl	
	ld hl,(l002ah)
	ld b,3              ;A Directory is 32 Bytes long
	call hl_shr_b       ;HL=(l002ah)/8

	inc hl
	add hl,de           ;HL=HL+DE+1

	ex de,hl	
	ld hl,(l002fh)
	ld b,2              ;A ??? is 64 Bytes long
	call hl_shr_b
	inc hl              ;DE=(l002fh)/4+1

	add hl,de           ;HL=HL+DE

	ld de,(usrsiz)
	add hl,de           ;HL=HL+User area size in kb (usrsiz)

	ld de,(l0039h)
	add hl,de           ;HL=HL+(l0039h)

	ex de,hl	
	ld hl,(l0008h)
	scf	
	sbc hl,de
	srl h
	rr l
	ld (l0034h),hl      ;(l0034h)=((l0008h)-HL)/2

	ld hl,(usrsrt)
	ld a,(usrsrt+2)
	ld de,4             ;Directory starts 4 sectors after the user ares starts
	add hl,de	
	adc a,0             ;AHL=(usrsrt)+4

	ld (dirsrt),hl
	ld (dirsrt+2),a     ;(dirsrt)=AHL

	ex de,hl	
	ld hl,(maxdir)
	ld b,3              ;A Directory is 32 Bytes long
	call hl_shr_b       ;DE=(maxdir)/8

	inc hl
	add hl,de	
	adc a,0             ;AHL=AHL+DE+1

	ld (l0027h),hl
	ld (l0027h+2),a     ;(l0027h)=AHL

    ld de,(l002ah)
	srl d
	rr e                ;A ??? is 128 bytes long
	inc de	
	add hl,de	
	adc a,0             ;AHL=AHL+((l002ah)/2)+1

	ld (l002ch),hl
	ld (l002ch+2),a     ;(l002ch)=AHL

	ld de,(l002fh)
	add hl,de	
	adc a,0             ;AHL=AHL+(l002fh)

	ld (l0031h),hl
	ld (l0031h+2),a     ;(l0031h)=AHL

	ld de,(l0034h)
	ld b,8
le21eh:
	add hl,de	
	adc a,0
	djnz le21eh         ;AHL=AHL+8*(l0034h)

	ld (bamsrt),hl
	ld (bamsrt+2),a     ;(bamsrt)=AHL

	ex de,hl	
	ld hl,(l0039h)
	add hl,hl	
	add hl,hl	
	add hl,de	
	adc a,0             ;AHL=AHL+(l0039h)*4

	ld (l0036h),hl
	ld (l0036h+2),a     ;(l0036h)=AHL

	ld a,0fh
	ld (sa),a           ;sa=15

	call sub_f7d0h

	ld hl,0000h
	ld (l0d68h),hl      ;(l0d68h)=0

	                    ;Build own BAM for files from directory entries
le246h:
	call sub_f6edh      ;DE=(00d68h)
	jr c,le26eh         ;End reached? Skipping ...
	bit 7,(ix+001h)
	jr nz,le246h
	call read_128       ;Read sector (l0027h)+DE with 128 bytes to (00aeeh)
	ld b,040h           ;B=40h (64 word entries in 128 bytes)
	ld ix,(00aeeh)
le25ah:
	ld l,(ix+000h)
	ld h,(ix+001h)
	ld de,l0057h
	call sub_f87ah      ;Set marker for ix in bit set l0057h
	inc ix
	inc ix
	djnz le25ah
	jr le246h

le26eh:
	ld de,00000h
	ld hl,l0057h

le274h:
	ld b,8              ;Loop oveer all 8 bits
	ld c,(hl)           ;Get the byte with 8 bits
	inc hl

le278h:
	rr c                ;Rotate the bits
	jr nc,le29dh        ;If this bit is cleared, skip

	push bc	
	push hl	
	push de	
	call sub_f8fch      ;Read (256 bytes)
	ld b,080h           ;B=80h (128 word entries in 256 bytes)
	ld ix,(00aeah)

le288h:
	ld l,(ix+000h)
	ld h,(ix+001h)
	inc ix
	inc ix
	ld de,l0457h
	call sub_f87ah      ;Set marker for ix in bit set l0457h
	djnz le288h
	pop de	
	pop hl	
	pop bc
	
le29dh:
	inc de              ;Increment counter
	ld a,(l002fh)
	cp e	
	jr nz,le2aah
	ld a,(l002fh+1)
	cp d               ;If counter reached the end
	jr z,le2aeh        ;  YES: finish

le2aah:
	djnz le278h         ;check next bit
	jr le274h           ;check next byte

le2aeh:
	xor a
	out (ppi2_pc),a     ;Turn on all LEDs ("Ready" LED, "A" and "B")
	out (ppi1_pb),a

	in a,(ppi2_pb)
	and 000h
	out (ppi2_pb),a

le2b9h:
	in a,(ppi2_pa)
	and atn
	jr z,le2b9h
le2bfh:
	in a,(ppi2_pb)
	or ifc+ndac
	out (ppi2_pb),a     ;IFC_OUT=low, NDAC_OUT=low

	in a,(ppi2_pb)
	and 255-nrfd
	out (ppi2_pb),a     ;NRFD_OUT=high 
le2cbh:
	in a,(ppi2_pa)
	and dav
	jr nz,le2dah
	in a,(ppi2_pa)
	and atn
	jr nz,le2cbh
	jp le34dh
le2dah:
	ld hl,00af0h

	in a,(ppi2_pb)
	or nrfd
	out (ppi2_pb),a     ;NRFD_OUT=low

	in a,(ppi1_pa)
	ld c,a	

	in a,(ppi2_pb)
	and 255-ndac
	out (ppi2_pb),a     ;NDAC_OUT=high 

	ld a,(devnum)
	or 20h		 		;Generate LISTEN address
	cp c	
	jr z,do_listn		;If found execute do_listn
	xor 60h	            ;Generate TALK address
	cp c	
	jr z,do_talk		;If found execute do_talk
	ld a,c	
	cp 3fh				;3Fh=UNLISTEN
	jr z,do_unlst		;If found execute do_unlst
	cp 5fh				;5Fh=UNTALK
	jr z,do_untlk		;If found execute do_untlk
	and 60h
	cp 60h
	jr nz,le312h
	ld a,c	
	ld (sa),a
	and 0f0h
	cp 0e0h
	jr z,le332h

le312h:
	in a,(ppi2_pa)
	and dav
	jr nz,le312h        ;Wait until DAV_IN=high

	jr le2bfh

do_listn:
	set 2,(hl)
	xor a               ;A=0	
	ld (sa),a
	jr le312h

do_talk:
	set 1,(hl)
	xor a               ;A=0	
	ld (sa),a
	jr le312h

do_unlst:
	res 2,(hl)
	jr le312h

do_untlk:
	res 1,(hl)
	jr le312h

le332h:
	ld (hl),000h
	ld a,c	
	and 00fh
	ld (sa),a
	push af	
	cp 002h
	call nc,error_ok
	pop af	
	cp 00fh
	push af	
	call z,sub_e86ah
	pop af	
	call nz,sub_e81fh
	jr le312h

le34dh:
	in a,(ppi2_pb)
	and 255-ifc
	out (ppi2_pb),a     ;IFC_OUT=high

	ld a,(00af0h)
	or a	
	jp z,le2aeh
	bit 2,a
	jr nz,le38dh

	in a,(ppi2_pb)
	and 255-ndac
	out (ppi2_pb),a     ;NDAC_OUT=high 

	ld a,(sa)
	or a	
	jp z,le2aeh
	and 00fh
	ld (sa),a
	cp 0fh              ;Is Control Channel?
	jp nz,le879h

le375h:
	ld hl,(00af1h)
	ld a,(hl)	
	call sub_e448h
	jp c,le2aeh
	ld a,(hl)	
	inc hl	
	cp cr
	jr nz,le388h
	ld hl,00cf5h
le388h:
	ld (00af1h),hl
	jr le375h
le38dh:
	ld a,(sa)
	or a	
	jp z,le2aeh
	push af	
	and 00fh
	ld (sa),a
	cp 02h
	call nc,error_ok
	pop af	
	jp p,le3d3h
	ld hl,l0c75h
	ld b,07fh
le3a8h:
	call rdieee
	jp c,le2aeh
	bit 7,b
	jr nz,le3b5h
	ld (hl),a	
	inc hl	
	dec b	
le3b5h:
	ld a,(eoisav)
	or a	
	jr z,le3a8h         ;No EOI detected, read next characters

	ld (hl),cr          ;Save end marker in buffer

	ld a,(sa)           ;Get secondary address
	cp 0fh              ;Is Control Channel?
	jp nz,le5f3h        ;  No, jump

	ld hl,l0c75h
	ld de,cmdbuf
	ld bc,00080h
	ldir                ;Copy BC bytes from (HL) to (DE) 
	jp le4a2h

le3d3h:
	ld a,(sa)
	cp 0fh              ;Is Control Channel?
	jp nz,le980h
	ld hl,(00af3h)
le3deh:
	call rdieee
	jp c,le2aeh
	ld (hl),a	
	ld a,l	
	cp low (l0c75h+255)
	jr z,le3eeh
	inc hl	
	ld (00af3h),hl
le3eeh:
	ld a,(eoisav)
	or a	
	jr z,le3deh
	ld (hl),cr
	jp le4a2h

rdieee:
;Read a byte from the current IEEE-488 device
;No timeout; waits forever for DAV_IN=low.
;
;Returns the byte in A.
;Stores ppi2_pa in eoisav so EOI state can be checked later.
;
	in a,(ppi2_pa)
	and atn
	jr nz,le43eh

	in a,(ppi2_pb)
	and 255-nrfd
	out (ppi2_pb),a     ;NRFD_OUT=high

le405h:
	in a,(ppi2_pa)
	and atn
	jr nz,le43eh

	in a,(ppi2_pa)
	and dav
	jr z,le405h         ;Wait until DAV_IN=low

	in a,(ppi1_pa)
	push af
	
	xor a
	ld (eoisav),a       ;eoisav=0
	in a,(ppi2_pa)
	and eoi
	jr z,le423h

	ld a,001h
	ld (eoisav),a       ;eoisav=1

le423h:
	in a,(ppi2_pb)
	or nrfd
	out (ppi2_pb),a     ;NRFD_OUT=low

	in a,(ppi2_pb)
	and 255-ndac
	out (ppi2_pb),a     ;NDAC_OUT=high 

le42fh:
	in a,(ppi2_pa)
	and dav
	jr nz,le42fh        ;Wait until DAV_IN=high

	in a,(ppi2_pb)
	or ndac
	out (ppi2_pb),a     ;NDAC_OUT=low

	pop af	
	or a	
	ret	
le43eh:
	scf	
	ret	

wreoi:
;Send the byte in A to IEEE-488 device with EOI asserted
;
	push af	
	in a,(ppi2_pb)
	or eoi
	out (ppi2_pb),a     ;EOI_OUT=low

	pop af	
sub_e448h:
	call wrieee         ;Send the byte 
	ret c	
	call sub_e492h
	or a	
	ret
	
wrieee:
;Send a byte to an IEEE-488 device
;
;A = byte to send
;
;Returns carry flag set if an error occurred, clear if OK.
;
	push af             ;Push data byte 	
le452h:
	in a,(ppi2_pa)
	and atn
	jr nz,le48fh        ;Jump to error if ATN_IN=low
	in a,(ppi2_pa)
	and nrfd
	jr nz,le452h        ;Wait until NRFD_IN=high

	in a,(ppi2_pa)
	and atn
	jr nz,le48fh        ;Jump to error if ATN_IN=low

	in a,(ppi2_pa)
	and ndac
	jr z,le48fh         ;Jump to error if NDAC_IN=high 

	pop af              ;Push data byte 	
	out (ppi1_pb),a     ;Write byte to IEEE-488 data lines

	in a,(ppi2_pb)
	or dav
	out (ppi2_pb),a     ;DAV_OUT=low

le473h:
	in a,(ppi2_pa)
	and nrfd
	jr nz,le48dh
	in a,(ppi2_pa)
	and ndac
	jr nz,le473h         ;Wait until NDAC_IN=high

	in a,(ppi2_pa)
	and nrfd
	jr nz,le48dh
	in a,(ppi2_pb)
	and 255-dav
	out (ppi2_pb),a     ;DAV_OUT=high

	scf	
	ret
	
le48dh:
	or a	
	ret

le48fh:
	pop af	
	scf	
	ret
	
sub_e492h:
	in a,(ppi2_pa)
	and ndac
	jr nz,sub_e492h     ;Wait until NDAC_IN=high
	in a,(ppi2_pb)
	and 255-eoi-dav     ;EOI_OUT=high, DAV_OUT=high
	out (ppi2_pb),a
	xor a               ;A=0	
	out (ppi1_pb),a
	ret

le4a2h:
	call error_ok
	ld de,le4d1h
	ld hl,cmdbuf
	ld (00af3h),hl
	ld b,012h
	ld ix,le4e3h
le4b4h:
	ld a,(de)	
	cp (hl)	
	jr z,le4c4h
	inc de	
	inc ix
	inc ix
	djnz le4b4h
	ld a,error_31       ;"SYNTAX ERROR (INVALID COMMAND)" 
	jp error
le4c4h:
	ld l,(ix+000h)
	ld h,(ix+001h)
	call sub_e4d0h
	jp le2aeh
sub_e4d0h:
	jp (hl)

le4d1h:
    db "NSDIRGHW-VLT!PBUAC"

le4e3h:
    dw cmd_new          ;"N": New Disk Name
    dw cmd_del          ;"S": Scratch Files
    dw lf0b2h           ;"D"
    dw cmd_ini          ;"I": Initialize
    dw lf0e7h           ;"R"
    dw leb7eh           ;"G": Global
    dw leb7eh           ;"H": Hide a File
    dw leb7eh           ;"W": Write Protect
    dw leb7eh           ;"-"
    dw cmd_vfy          ;"V": Validate
    dw cmd_lgn          ;"L": Login
	dw lebdfh           ;"T": Trasfer Files
    dw leeceh           ;"!"
    dw cmd_pos          ;"P": Record Position
    dw cmd_blk          ;"B": Block commands
	dw cmd_usr          ;"U": User commands
    dw cmd_abs          ;"A": Absolute commands
    dw cmd_cpy          ;"C": Copy and Concat

error:
	call error_out
	ld sp,stack
	jp le2aeh

error_ok:
	call clrerrts

error_out:
	ld (errcod),a
	ld hl,error_txt     ;Get address of error code/text table

le519h:
	bit 7,(hl)          ;Is this a valid error code (less than 128)
	jr nz,le528h        ;  NO: We reached the end of the error list, UNKNOWN ERROR CODE
	cp (hl)             ;Is this the wanted error code
	jr z,le528h         ;  YES: We reached the correct position
	inc hl              ;Now begin to skip the error text
le521h:
	bit 7,(hl)          ;Is the end of this error text reached
	inc hl	
	jr z,le521h         ;  NO: loop
	jr le519h           ;  YES: Check the next error text

le528h:
	ex de,hl	
	inc de	
	push de	
	ld hl,00cf5h
	ld de,00000h
	call put_number     ;Put a number into buffer

	ld (hl),","         ;Put colon into buffer
	inc hl	

	pop de	
le538h:
	ld a,(de)           ;Get the charcter from error text
	and 07fh            ;Mask off the highest bit (end marker bit)
	ld (hl),a           ;Store it into buffer

	cp 020h             ;Is this a error token?
	jr nc,le55bh        ;  NO: leave unchanged

	push de	
	ld de,error_tok     ;Get address of error token table
	ld b,a              ;B=error token

le545h:
	dec b               ;Decrement error token
	jr z,le54fh         ;Is error token found? YES: Put the token into buffer

le548h:
	ld a,(de)           ;Get the charcter from error token
	inc de	
	rla                 ;Is higest bit set (end marker bit)?
	jr nc,le548h        ;  NO: get next character
	jr le545h           ;  YES: Check next error token

le54fh:
	ld a,(de)           ;Get the charcter from error token
	and 07fh            ;Mask off the highest bit (end marker bit)
	ld (hl),a           ;Store it into buffer
	ld a,(de)           ;Get last charcter from error token
	inc hl	
	inc de	
	rla                 ;Is higest bit set (end marker bit)?
	jr nc,le54fh        ;  NO: get next character
	pop de	
	dec hl	

le55bh:
	ld a,(de)           ;Get last charcter from error text
	rla                 ;Is higest bit set (end marker bit)?
	inc hl	
	inc de	
	jr nc,le538h        ;  NO: get next character

	ld (hl),","         ;Put colon into buffer
	inc hl

	ld a,(errtrk)
	ld de,(errtrk+1)
	call put_number     ;Put a number into buffer

	ld (hl),","         ;Put colon into buffer
	inc hl	

	ld a,(errsec)
	ld de,(errsec+1)
	call put_number     ;Put a number into buffer

	ld (hl),cr          ;Put cr into buffer

	ld hl,00cf5h
	ld (00af1h),hl
	ret

clrerrts:
;clear error track and sector
;
	xor a
	ld (errtrk),a
	ld (errtrk+1),a
	ld (errtrk+2),a     ;errtrk=0

	ld (errsec),a
	ld (errsec+1),a
	ld (errsec+2),a     ;errsec=0
	ret

put_number:
;Put a number into buffer
;
;Input DEA: Number
;Input HL: Buffer address
;
	ld ix,le5e1h
	ld b,06h
	ld iy,0260fh
	res 0,(iy+000h)
	push hl	
	ex de,hl	
le5a8h:
	ld e,(ix+1)
	ld d,(ix+2)
	ld c,"0"-1
le5b0h:
	inc c	
	sub (ix+0)
	sbc hl,de
	jr nc,le5b0h
	add a,(ix+0)
	adc hl,de
	ld e,a	
	ld a,c	
	cp "0"
	jr nz,le5ceh
	bit 0,(iy+000h)
	jr nz,le5ceh
	ld a,b	
	cp 02h
	jr nz,le5d6h
le5ceh:
	set 0,(iy+000h)
	ex (sp),hl	
	ld (hl),c	
	inc hl	
	ex (sp),hl	
le5d6h:
	ld a,e	
	inc ix
	inc ix
	inc ix
	djnz le5a8h
	pop hl	
	ret
	
le5e1h:
	dt 100000
	dt 10000

le5e7h:
    dt 1000
	dt 100
	dt 10
	dt 1

le5f3h:
	call error_ok
	call sub_f7d0h
	bit 7,(iy+028h)
	call nz,sub_e81fh
	ld iy,(l0ae8h)
	ld (iy+028h),000h
	ld (iy+027h),000h
	ld (iy+026h),0ffh
	ld hl,l0c75h

le613h:
	ld a,(hl)	
	cp "$"
	jp z,open_dir
	cp "#"
	jp z,open_chn
	cp "@"
	jr nz,le629h
	set 5,(iy+028h)		;Set marker for command access
	inc hl	
	jr le613h

le629h:
	call get_filename   ;Get a filename

	ld (iy+000h),typ_seq
	ld a,(sa)
	cp 02h
	jr nc,le63fh
	ld (iy+000h),typ_prg
	set 0,(iy+028h)		;Set marker for file type
le63fh:
	ld a,(hl)	
	cp cr
	jr z,le69bh
	cp ","
	inc hl	
	jr nz,le63fh
	ld a,(hl)	
	ld b,typ_seq
	cp "S"              ;check for "SEQ"
	jr z,le680h
	ld b,typ_usr
	cp "U"              ;check for "USR"
	jr z,le680h
	ld b,typ_prg
	cp "P"              ;check for "PRG"
	jr z,le680h
	cp "W"              ;Write
	jr z,le695h
	cp "A"              ;Append
	jr z,le68fh
	cp "R"              ;check for "REL"
	jr nz,le66fh
	inc hl	
	ld a,(hl)	
	cp "E"
	jr nz,le63fh
	inc hl	
le66fh:
	cp "L"              ;(Record) Length
	jr nz,le63fh
	ld b,typ_rel
	inc hl	
	ld a,(hl)	
	cp ","
	jr nz,le680h
	inc hl	
	ld a,(hl)	
	ld (iy+015h),a		;Save detected record length
le680h:
	ld a,(iy+000h)
	and 0fch
	or b	
	ld (iy+000h),a      ;Save detected file type

	set 0,(iy+028h)		;Set marker for file type
	jr le63fh

le68fh:
	set 4,(iy+028h)     ;Set marker for Append
	jr le63fh

le695h:
	set 3,(iy+028h)     ;Set marker for Write
	jr le63fh

le69bh:
	ld a,(sa)
	cp 02h
	jr nc,le6adh
	res 3,(iy+028h)     ;Reset marker for Write
	or a	
	jr z,le6adh
	set 3,(iy+028h)     ;Set marker for Write
le6adh:
	bit 3,(iy+028h)     ;Is marker for Write set?
	jp z,le748h

le6b4h:
	call sub_f782h
	ld a,error_33       ;"SYNTAX ERROR(INVALID FILENAME)"
	jp c,error          ;If invalid filename, SYNTAX ERROR(INVALID FILENAME)

	ld hl,filnam
	ld a,(00d67h)
	call find_first
	ld iy,(l0ae8h)
	jr c,le6e2h
	bit 5,(iy+028h)		;Is marker for command access set
	ld a,error_63       ;"FILE EXISTS" 
	jp z,error

	bit 6,(ix+000h)     ;is marker for "Write Protect" set?
	ld a,error_26       ;"WRITE PROTECED"
	jp nz,error         ;If yes, WRITE PROTECTED

	call sub_f82ah
	jr le6e5h
le6e2h:
	call sub_f6cdh
le6e5h:
	push de	
	push ix
	ld a,(00d67h)
	ld (iy+001h),a
	ld (iy+023h),e
	ld (iy+024h),d
	set 7,(iy+000h)
	set 7,(iy+028h)
	ld b,003h
	ld a,(iy+015h)
	ld (iy+025h),a
	or a	
	jr nz,le70fh
	ld (iy+015h),0feh
	ld (iy+025h),0feh
le70fh:
	ld (iy+012h),0ffh
	ld (iy+020h),000h
	inc iy
	djnz le70fh
	ld hl,(00aeeh)
	ld b,080h
le720h:
	ld (hl),0ffh
	inc hl	
	djnz le720h
	call write_128      ;Write sector (l0027h)+DE with 128 bytes from (00aeeh)
	ld hl,(l0ae8h)
	ld de,00002h
	add hl,de	
	ex de,hl	
	ld hl,filnam
	ld bc,00010h
	ldir                ;Copy BC bytes from (HL) to (DE) 
	ld hl,(l0ae8h)
	pop de	
	ld bc,00020h
	ldir                ;Copy BC bytes from (HL) to (DE) 
	pop de	
	call wr_dir_blk
	jp le2aeh
le748h:
	ld hl,filnam
	ld a,(00d67h)
	call find_first
	ld iy,(l0ae8h)
	jr nc,le766h
	ld a,(iy+000h)
	and 003h
	cp 003h
	jp z,le6b4h
	ld a,error_62       ;"FILE NOT FOUND"
	jp error

le766h:
	bit 0,(iy+028h)		;Is marker for file type set?
	jr z,le78ah
	ld a,(iy+000h)
	xor (ix+000h)
	and 003h
	jr z,le78ah
	ld hl,filnam
	ld a,(00d67h)
	call find_next
	ld iy,(l0ae8h)
	jr nc,le766h
	ld a,error_64       ;"FILE TYPE MISMATCH"
	jp error

le78ah:
	call read_128       ;Read sector (l0027h)+DE with 128 bytes to (00aeeh)
	ld (iy+023h),e
	ld (iy+023h+1),d
	ld (iy+020h),000h
	ld (iy+020h+1),000h
	ld (iy+020h+2),000h
	set 7,(iy+028h)

	ld b,020h           ;B=32 Bytes
le7a5h:
	ld a,(ix+000h)
	ld (iy+000h),a
	inc ix
	inc iy
	djnz le7a5h

	ld iy,(l0ae8h)
	ld a,(iy+015h)
	ld (iy+025h),a
	bit 4,(iy+028h)     ;Is marker for Append set?
	jr nz,le7ebh        ;  YES: Dont cut

	ld a,(iy+012h)
	and (iy+012h+1)
	and (iy+012h+2)
	inc a               ;Is file size equal 0ffffffh?
	jr nz,le7e2h        ;  NO: ...

	ld a,(iy+000h)      ;Get file type
	and 003h
	cp typ_rel          ;Is it file type equal relative?
	jr z,le7e8h         ;  YES: Nothing to do

	xor a               ;A=0	
	ld (iy+012h),a
	ld (iy+012h+1),a
	ld (iy+012h+2),a    ;Set file size to 0
	jr le7e8h

le7e2h:
	call sub_eb00h
	call sub_f927h
le7e8h:
	jp le2aeh

le7ebh:
	ld a,(iy+012h)
	add a,001h
	ld (iy+020h),a
	ld a,(iy+012h+1)
	adc a,000h
	ld (iy+020h+1),a
	ld a,(iy+012h+2)
	adc a,000h
	ld (iy+020h+2),a    ;[iy+020h]=[iy+012h]+1

	call sub_eb00h
	ld a,(00d6bh)
	or a	
	call nz,sub_f927h
	jp le2aeh

open_chn:
	set 7,(iy+028h)
	set 6,(iy+028h)     ;Set marker for channel access
	ld (iy+020h),000h
	jp le2aeh

sub_e81fh:
	call sub_f7d0h
	bit 7,(iy+028h)
	ret z	
	res 7,(iy+028h)
	call sub_eb00h
	bit 7,(iy+027h)
	call nz,sub_f932h
	bit 4,(iy+027h)
	jr nz,le840h
	bit 7,(iy+000h)
	ret z	
le840h:
	ld e,(iy+023h)
	ld d,(iy+023h+1)
	push de	
	call rd_dir_blk
	res 7,(iy+000h)
	ld bc,00020h
	ld a,e	
	and 007h
	add a,a	
	add a,a	
	add a,a	
	add a,a	
	add a,a	
	ld e,a	
	ld d,000h
	ld hl,dirbuf
	add hl,de	
	ex de,hl	
	ld hl,(l0ae8h)
	ldir                ;Copy BC bytes from (HL) to (DE) 
	pop de	
	jp wr_dir_blk
sub_e86ah:
	xor a               ;A=0	
le86bh:
	ld (sa),a
	push af	
	call sub_e81fh
	pop af	
	inc a	
	cp 00fh
	jr nz,le86bh
	ret	
le879h:
	call sub_f7d0h
	bit 7,(iy+028h)
	jp z,le2aeh
	bit 6,(iy+028h)     ;Ist marker for channel access set?
	jp nz,le921h
	bit 4,(iy+028h)     ;Ist marker for Append set?
	jp nz,le2aeh
	bit 3,(iy+028h)     ;Is marker for Write set?
	jp nz,le2aeh
	bit 2,(iy+028h)		;Is marker for directory set?
	jp nz,le949h
	call sub_eb00h
	ld a,(iy+000h)
	and 003h
	cp 003h
	jr nz,le8b3h
	call sub_f1f7h
	ld a,error_50       ;"RECORD NOT PRESENT"
	jp nc,error

le8b3h:
	ld a,(00d6bh)
	ld e,a	
	ld d,000h
	ld hl,(00aech)
	add hl,de	
le8bdh:
	ld a,(iy+000h)
	and 003h
	cp 003h
	jr nz,le8d7h
	dec (iy+025h)
	jr nz,le8d7h
	ld a,(iy+015h)
	ld (iy+025h),a

	in a,(ppi2_pb)
	or eoi
	out (ppi2_pb),a     ;EOI_OUT=low 

le8d7h:
	ld a,(iy+020h)
	cp (iy+012h)
	jr nz,le8efh
	ld a,(iy+020h+1)
	cp (iy+012h+1)
	jr nz,le8efh
	ld a,(iy+020h+2)
	cp (iy+012h+2)
	jr z,le912h
le8efh:
	ld a,(hl)	
	call wrieee
	jp c,le91bh
	inc hl	
	inc (iy+020h)
	jr nz,le90dh
	inc (iy+020h+1)
	jr nz,le904h
	inc (iy+020h+2)
le904h:
	call sub_eb00h
	call sub_f927h
	ld hl,(00aech)
le90dh:
	call sub_e492h
	jr le8bdh
le912h:
	ld a,(hl)	
	call wreoi
	jp c,le2aeh
	jr le912h
le91bh:
	inc (iy+025h)
	jp le2aeh
le921h:
	ld hl,(00aech)
	ld c,(iy+020h)
	ld b,000h
	add hl,bc	
	ld a,(iy+025h)
	cp c	
	jr z,le93ch
	ld a,(hl)	
	call sub_e448h
	jp c,le2aeh
	inc (iy+020h)
	jr le921h
le93ch:
	ld a,(hl)	
	call wreoi
	jp c,le2aeh
	ld (iy+020h),000h
	jr le921h

le949h:
	ld hl,(wrtprt)      ;HL=(wrtbuf)
	ld a,(endbuf)       ; A=(endbuf)
	cp l                ;Is end reached?
	jr z,le977h         ;  YES: Must send with active EOI
	ld a,(hl)           ;Get character from buffer
	call wrieee         ;Give out on ieee
	jp c,le2aeh         ;If error, aborting
	inc hl              ;Increment pointer
	ld (wrtprt),hl      ;and store it
	ld a,(endbuf)       ; A=(endbuf)
	cp l                ;Is now end reached?
	jr z,le968h         ;  YES: Skip

	call sub_e492h
	jr le949h

le968h:
	ld hl,(025f4h)
	ld a,l	
	or h	
	push af	
	call nz,sub_f556h
	call sub_e492h
	pop af	
	jr nz,le949h

le977h:
	xor a               ;A=0
	call wreoi          ;Write ascii 0 with active EOI
	jr nc,le977h        ;If no error, repeat it
	jp le2aeh           ;Else aborting

le980h:
	call sub_f7d0h
	bit 7,(iy+028h)
	jp z,le2aeh
	bit 6,(iy+028h)     ;Ist marker for channel access set?
	jp nz,leaebh
	ld a,(iy+000h)
	and 003h
	cp 003h
	jr z,le9e7h
	bit 3,(iy+028h)     ;Is marker for Write set?
	jr nz,le9a7h
	bit 4,(iy+028h)     ;Is marker for Append set?
	jp z,le2aeh
le9a7h:
	call sub_eb00h
	ld a,(00d6bh)
	ld e,a	
	ld d,000h
	ld hl,(00aech)
	add hl,de	
le9b4h:
	call rdieee
	jp c,le2aeh
	ld (hl),a	
	set 7,(iy+027h)
	set 4,(iy+027h)
	inc hl	
	inc (iy+012h)
	jr nz,le9d1h
	inc (iy+012h+1)
	jr nz,le9d1h
	inc (iy+012h+2)
le9d1h:
	inc (iy+020h)
	jr nz,le9b4h
	inc (iy+020h+1)
	jr nz,le9deh
	inc (iy+020h+2)
le9deh:
	call sub_f932h
	res 7,(iy+027h)
	jr le9a7h
le9e7h:
	call rdieee
	jp c,le2aeh
	push af	
	call error_ok
	call sub_eb00h
	call sub_f1f7h
	jp c,lea83h
	ld l,(iy+020h)
	ld h,(iy+020h+1)
	ld a,(iy+020h+2)
	push af	
	push hl	
	ld a,(iy+012h)
	add a,001h
	ld (iy+020h),a
	ld a,(iy+012h+1)
	adc a,000h
	ld (iy+020h+1),a
	ld a,(iy+012h+2)
	adc a,000h
	ld (iy+020h+2),a
	call sub_eb00h
	call sub_f927h
	ld c,(iy+020h)
	ld b,000h
	ld hl,(00aech)
	add hl,bc	
lea2ch:
	pop de	
	pop bc	
	push bc	
	push de	
	ld a,(iy+020h)
	cp e	
	ld a,(iy+020h+1)
	sbc a,d	
	ld a,(iy+020h+2)
	sbc a,b	
	jr nc,lea63h
	ld a,0ffh
	ld b,(iy+015h)
lea43h:
	ld (hl),a	
	inc hl	
	inc (iy+020h)
	jr nz,lea5dh
	inc (iy+020h+1)
	jr nz,lea52h
	inc (iy+020h+2)
lea52h:
	push bc	
	call sub_f932h
	call sub_eb00h
	pop bc	
	ld hl,(00aech)
lea5dh:
	ld a,cr
	djnz lea43h
	jr lea2ch
lea63h:
	pop hl	
	pop hl	

	ld a,(iy+015h)
	dec a	
	add a,(iy+020h)
	ld (iy+012h),a
	ld a,(iy+020h+1)
	adc a,000h
	ld (iy+012h+1),a
	ld a,(iy+020h+2)
	adc a,000h
	ld (iy+012h+2),a

	set 4,(iy+027h)
lea83h:
	call sub_eb00h
	ld bc,(00d6bh)
	ld b,000h
	ld hl,(00aech)
	add hl,bc	
	pop af	
	jr lea99h
lea93h:
	call rdieee
	jp c,le2aeh
lea99h:
	ld c,a	
	ld a,(iy+025h)
	or a	
	ld a,c	
	push af	
	push iy
	ld a,error_51       ;"OVERFLOW IN RECORD"
	call z,error_out
	pop iy
	pop af	
	call nz,sub_eacah
	ld a,(eoisav)
	or a	
	jr z,lea93h
leab3h:
	ld a,(iy+025h)
	or a	
	jr z,leabfh
	xor a               ;A=0	
	call sub_eacah
	jr leab3h
leabfh:
	call sub_f932h
	ld a,(iy+015h)
	ld (iy+025h),a
	jr lea93h
sub_eacah:
	ld (hl),a	
	dec (iy+025h)
	inc hl	
	inc (iy+020h)
	ret nz	
	inc (iy+020h+1)
	jr nz,leadbh
	inc (iy+020h+2)
leadbh:
	call sub_f932h
	call sub_eb00h
	call sub_f1f7h
	call c,sub_f927h
	ld hl,(00aech)
	ret	
leaebh:
	call rdieee
	jp c,le2aeh
	ld hl,(00aech)
	ld c,(iy+020h)
	inc (iy+020h)
	ld b,000h
	add hl,bc	
	ld (hl),a	
	jr leaebh
sub_eb00h:
	ld iy,(l0ae8h)
	ld a,(iy+020h)
	ld (00d6bh),a
	ld l,(iy+020h+1)
	ld h,(iy+020h+2)
	ld a,l	
	and 007h
	ld (00d6ch),a
	ld b,003h
	call hl_shr_b
	ld a,l	
	and 07fh
	ld (00d6ah),a
	ld b,007h
	call hl_shr_b
	ld a,l	
	ld (00d6dh),a
	ret

cmd_del:
;command for scratch files "S"
;
	call find_drvlet    ;Find drive letter
leb2eh:
	call get_filename   ;Get a filename

	push hl	
	ld a,00fh
	ld (sa),a
	call sub_f7d0h

	ld a,(00d67h)
	ld c,a	
	ld hl,filnam
	call find_first     ;Search for first file entry in directory
	jr c,leb6eh         ;If nothing found, nothing to do (skip)

leb46h:
	bit 6,(ix+000h)     ;is marker for "Write Protect" set?
	jr nz,leb62h        ;  YES: Skip scratching this file
	bit 7,(ix+000h)     ;is marker for "Open File" set?
	jr nz,leb62h        ;  YES: Skip scratching this file

	ld hl,errtrk
	inc (hl)            ;Increment the scratched files counter for output

	ld (ix+001h),0ffh
	push de	
	call sub_f82ah
	pop de	
	call wr_dir_blk

leb62h:
	ld hl,filnam
	ld a,(00d67h)
	ld c,a	
	call find_next      ;Search for next file entry in directory
	jr nc,leb46h        ;If found, loop

leb6eh:
	pop hl	
leb6fh:
	ld a,(hl)           ;Get next charcter from command buffer
	inc hl	
	cp ","              ;Is there a comma?
	jr z,leb2eh         ;  YES: Look next file pattern
	cp cr               ;Is there a end marker
	jr nz,leb6fh        ;  NO: Check next character
	ld a,error_01       ;"FILES SCRATCHED"
	jp error_out

leb7eh:
	call find_drvlet    ;Find drive letter
	call get_filename   ;Get a filename

	ld a,(00d67h)
	ld hl,filnam
	call find_first     ;Search for first file entry in directory
leb8dh:
	ret c               ;If not found, return

	ld hl,cmdbuf
leb91h:
	ld a,(hl)	
	inc hl	
	cp cr
	ret z	
	cp "-"              ;check for "-" for negation
	jr z,lebb8h
	cp "H"              ;check for "Hide"
	jr nz,leba4h
	set 5,(ix+000h)     ;set marker for "Hide"
	jr lebd1h
leba4h:
	cp "W"              ;check for "Write Protect"
	jr nz,lebaeh
	set 6,(ix+000h)     ;set marker for "Write Protect"
	jr lebd1h
lebaeh:
	cp "G"              ;check for "Global"
	jr nz,leb91h
	set 4,(ix+000h)     ;set marker for "Global"
	jr lebd1h
lebb8h:
	ld a,(hl)	
	cp "H"              ;check for "Hide"
	jr nz,lebc1h
	res 5,(ix+000h)     ;reset marker for "Hide"
lebc1h:
	cp "W"              ;check for "Write Protect"
	jr nz,lebc9h
	res 6,(ix+000h)     ;reset marker for "Write Protect"
lebc9h:
	cp "G"              ;check for "Global"
	jr nz,lebd1h
	res 4,(ix+000h)     ;reset marker for "Global"
lebd1h:
	call wr_dir_blk
	ld hl,filnam
	ld a,(00d67h)
	call find_next      ;Search for next file entry in directory
	jr leb8dh           ;Loop

lebdfh:
	call find_drvlet    ;Find drive letter
	call get_filename   ;Get a filename

	ld a,(hl)	
	inc hl	
	cp ","
	jr nz,lec13h
	ld a,(hl)	
	sub "0"
	jr c,lec13h
	cp 00ah
	jr nc,lec13h
	ld c,a	
	push bc	
	ld a,(00d67h)
	ld hl,filnam
	call find_first
lebffh:
	pop bc	
	ret c	
	ld (ix+001h),c
	push bc	
	call wr_dir_blk
	ld a,(00d67h)
	ld hl,filnam
	call find_next
	jr lebffh
lec13h:
	ld a,error_30       ;"SYNTAX ERROR"
	jp error

cmd_cpy:
;command for copy and concat "C"
;
	call find_drvlet    ;Find drive letter
	call get_filename   ;Get a filename

	push hl	
	ld a,00fh
	ld (sa),a
	call sub_f7d0h
	ld a,(00d67h)
	ld (iy+001h),a
	ld (iy+028h),000h
	ld (iy+027h),000h
	ld (iy+026h),0ffh
	ld hl,(l0ae8h)
	ld de,00002h
	add hl,de	
	ex de,hl	
	ld hl,filnam
	ld bc,00010h
	ldir                ;Copy BC bytes from (HL) to (DE) 
	call sub_f782h
	ld a,error_33       ;"SYNTAX ERROR(INVALID FILENAME)" 
	jp c,error

	pop hl	
	ld a,(hl)	
	cp "="
	ld a,error_30       ;"SYNTAX ERROR"
	jp nz,error

	inc hl	
	call get_filename   ;Get a filename

	push hl	
	ld a,(00d67h)
	cp (iy+001h)
	jr nz,lecbah
	ld b,010h
	ld hl,(l0ae8h)
	ld de,userid
	add hl,de	
	ld de,filnam
lec73h:
	ld a,(de)	
	cp (hl)	
	jr nz,lecbah
	inc hl	
	inc de	
	djnz lec73h
	ld a,(00d67h)
	ld hl,filnam
	call find_first
	ld a,error_62       ;"FILE NOT FOUND"
	jp c,error

	ld iy,(l0ae8h)
	ld (iy+023h),e
	ld (iy+024h),d
	push ix
	pop hl	
	ld de,(l0ae8h)
	ld bc,00020h
	ldir                ;Copy BC bytes from (HL) to (DE) 
	ld a,(iy+012h)
	add a,001h
	ld (iy+020h),a
	ld a,(iy+012h+1)
	adc a,000h
	ld (iy+020h+1),a
	ld a,(iy+012h+2)
	adc a,000h
	ld (iy+020h+2),a
	jp leddbh
lecbah:
	ld hl,(l0ae8h)
	ld de,userid
	add hl,de	
	ld a,(iy+001h)
	call find_first
	ld a,error_63       ;"FILE EXISTS"
	jp nc,error

	call sub_f6cdh
	ld iy,(l0ae8h)
	ld (iy+023h),e
	ld (iy+024h),d
	set 5,(iy+027h)
	ld (iy+020h),000h
	ld (iy+020h+1),000h
	ld (iy+020h+2),000h
	ld hl,(00aeeh)
	ld b,080h
leceeh:
	ld (hl),0ffh
	inc hl	
	djnz leceeh
	ld a,(00d67h)
	ld hl,filnam
	call find_first
	ld a,error_62       ;"FILE NOT FOUND"
	jp c,error

	ld iy,(l0ae8h)
	ld a,(ix+000h)
	ld (iy+000h),a
	ld a,(ix+015h)
	ld (iy+015h),a
led11h:
	ld (0260dh),de
	ld bc,0ffffh
led18h:
	inc bc	
	push bc	
	ld a,b	
	and 003h
	or c	
	jr nz,led43h
	ld hl,cpbuf
	ld (00aeeh),hl
	ld (00aeah),hl
	ld de,(0260dh)
	call read_128       ;Read sector (l0027h)+DE with 128 bytes to (00aeeh)
	ld hl,cpbuf
	pop bc	
	push bc	
	srl b
	ld e,b	
	res 0,e
	ld d,000h
	add hl,de	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	call sub_f8fch
led43h:
	pop de	
	push de	
	rr d
	rr e
	rr d
	rr e
	res 0,e
	ld d,000h
	ld hl,cpbuf
	add hl,de	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	ex de,hl	
	pop bc	
	push bc	
	ld a,c	
	and 007h
	ld e,a	
	xor a               ;A=0	
	ld d,a	
	add hl,hl	
	adc a,a	
	add hl,hl	
	adc a,a	
	add hl,hl	
	adc a,a	
	add hl,de	
	ld b,a	
	ld de,(l0031h)
	ld a,(l0031h+2)
	add hl,de	
	add a,b	
	ex de,hl
	
	ld hl,phydrv
	ld b,(hl)           ;B=Corvus drive number

	ld hl,rdbuf
	call corv_read_sec  ;Reads a sector (256 bytes)
	call sub_f7d0h
	call sub_eb00h
	ld b,000h
	pop de	
	push de	
	ld a,(ix+012h+1)
	cp e	
	jr nz,led97h
	ld a,(ix+012h+2)
	cp d	
	jr nz,led97h
	ld b,(ix+012h)
	inc b	
led97h:
	ld a,(00d6bh)
	ld e,a	
	ld d,000h
	ld hl,(00aech)
	add hl,de	
	ld de,rdbuf
leda4h:
	ld a,(de)	
	ld (hl),a	
	set 7,(iy+027h)
	inc hl	
	inc de	
	inc (iy+020h)
	jr nz,ledcah
	inc (iy+020h+1)
	jr nz,ledb9h
	inc (iy+020h+2)
ledb9h:
	push bc	
	push de	
	call sub_f932h
	res 7,(iy+027h)
	call sub_eb00h
	ld hl,(00aech)
	pop de	
	pop bc	
ledcah:
	djnz leda4h
	pop bc	
	ld a,(ix+013h)
	cp c	
	jp nz,led18h
	ld a,(ix+014h)
	cp b	
	jp nz,led18h
leddbh:
	pop hl	
leddch:
	ld a,(hl)	
	inc hl	
	cp cr
	jr z,ledfbh
	cp ","
	jr nz,leddch
	call get_filename   ;Get a filename

	push hl	
	ld hl,filnam
	ld a,(00d67h)
	call find_first
	jp nc,led11h
	ld a,error_62       ;"FILE NOT FOUND"
	jp error

ledfbh:
	ld iy,(l0ae8h)
	ld a,(iy+020h)
	sub 001h
	ld (iy+012h),a
	ld a,(iy+020h+1)
	sbc a,000h
	ld (iy+012h+1),a
	ld a,(iy+020h+2)
	sbc a,000h
	ld (iy+012h+2),a    ;file size in bytes ???
	set 7,(iy+028h)
	set 7,(iy+000h)
	jp sub_e81fh

cmd_lgn:
;command for login "L"
;
	call find_delim     ;Search for delimiter '=' or ':', abort if cr readed
	ld a,error_30       ;"SYNTAX ERROR"
	jp c,error

	call get_filename   ;Get a filename

	push hl	
	ld hl,filnam
	ld de,l0d56h
	ld bc,00010h        ;BC=0010h (16 bytes)
	ldir                ;Copy BC bytes from (HL) to (DE)

	ld b,010h           ;B=10h (16 bytes)
	ld hl,filnam        ;HL=filnam
lee3eh:
	ld (hl),00h         ;Clear filnam
	inc hl	
	djnz lee3eh         ;Loop all 16 characters
	pop hl

	ld a,(hl)	
	cp ","
	jr nz,lee4dh
	inc hl	
	call get_filename   ;Get a filename

lee4dh:
	ld a,(hl)	
	cp cr
	ld a,error_30       ;"SYNTAX ERROR"
	jp nz,error

	ld de,00000h
	ld c,000h

lee5ah:
	push de	
	push bc	
	xor a               ;A=0
                        ;ADE=0,1,2 to 3 via loop
	ld b,1              ;B=Corvus drive number (1)
	ld hl,rdbuf         ;HL=rdbuf (target)
	call corv_read_sec  ;Reads a sector (256 bytes)
	pop bc

	ld hl,rdbuf
lee69h:
	ld de,l0d56h
	push bc	
	ld b,010h
	ld c,000h
lee71h:
	ld a,(de)	
	xor (hl)	
	or c	
	ld c,a	
	inc hl	
	inc de	
	djnz lee71h
	pop bc	
	or a	
	jr z,lee8fh
	inc c	
	ld a,c	
	and 00fh
	jr nz,lee69h
	pop de	
	inc de	
	ld a,e	
	cp 004h
	jr nz,lee5ah
	ld a,error_90       ;"INVALID USER NAME"
	jp error

lee8fh:
	push bc	
	ld a,c	
	rra	
	rra	
	rra	
	rra	
	and 00001111b
	add a,00ch
	ld e,a	
	ld d,0
	xor a               ;A=0
                        ;ADE=12,13,14 or 15 depends in userid
	ld b,1              ;B=Corvus drive number (1)
	ld hl,rdbuf         ;HL=rdbuf
	call corv_read_sec  ;Reads a sector (256 bytes)
	pop bc

	push bc	
	ld a,c	
	and 00001111b
	add a,a	
	add a,a	
	add a,a	
	add a,a	
	ld l,a	
	ld h,0
	ld bc,rdbuf
	add hl,bc	
	ld a,(hl)	
	or a	
	jr z,leec9h
	ld de,filnam
	ld b,10h            ;B=10h (16 Bytes)
leebeh:
	ld a,(de)	
	cp (hl)	
	ld a,error_91       ;"PASSWORD INCORRECT"
	jp nz,error

	inc de	
	inc hl	
	djnz leebeh
leec9h:
	pop bc	
	ld a,c	
	jp init_user

leeceh:
	ld hl,00bf6h
	ld a,(hl)	
	inc hl	
	ld ix,leef6h
	ld b,00ah
leed9h:
	cp (ix+000h)
	jr z,leeebh
	inc ix
	inc ix
	inc ix
	djnz leed9h
	ld a,error_31       ;"SYNTAX ERROR (INVALID COMMAND)"
	jp error

leeebh:
	ld e,(ix+001h)
	ld d,(ix+001h+1)
	push de	
	pop iy
	jp (iy)

leef6h:
    db "D"				;Set Device Number
    dw cmd_dev

    db "H"              ;Hardbox Version
    dw cmd_hbv

    db "N"              ;Number of current User
    dw cmd_uid

    db "E"              ;Execute
    dw cmd_exe

    db "P"              ;Set Password
    dw cmd_pwd

    db "C"              ;Clear
    dw cmd_clr

    db "L"              ;Lock
    dw cmd_lck

    db "U"              ;Unlock
    dw cmd_ulk

    db "S"              ;Get Disk Size
    dw cmd_siz

    db "V"              ;Version
    dw cmd_ver

cmd_pwd:
;command for set password "!P"
;
	call find_delim     ;Search for delimiter '=' or ':', abort if cr readed
	call get_filename   ;Get a filename

	ld a,(hl)	
	cp cr
	ld a,error_30       ;"SYNTAX ERROR" 
	jp nz,error

                        ;Read the sector where the password is stored, change the password and write it back.
                        ;This starts at sector 12. Every password is 16 Character long.
                        ;So we need for 64 users 4 sectors with 256 bytes.

	ld a,(userid)
	rra	
	rra	
	rra	
	rra	
	and 00001111b
	add a,0ch
	ld e,a              ;E=12 for (userid)<16 or E=13 for (userid)>15

	ld d,0
	xor a               ;ADE=12 or 13 (14 or 15) depends on (userid)
	ld b,1              ;B=Corvus drive number (1)
	ld hl,rdbuf         ;HL=rdbuf (Address to read the sector)
	push de             ;Save absolute sector number
	call corv_read_sec  ;Reads a sector (256 bytes)

	ld a,(userid)
	and 00001111b
	add a,a	
	add a,a	
	add a,a	
	add a,a
	ld c,a
	ld b,0              ;BC=(userid)*16
	ld hl,rdbuf
	add hl,bc	
	ex de,hl            ;DE=rdbuf+BC
	ld hl,filnam        ;HL=filnam
	ld bc,0010h         ;0010h (16 bytes)
	ldir                ;Copy BC bytes from (HL) to (DE)

	pop de              ;Restore absolute sector number
	xor a               ;A=0	
	ld b,1              ;B=Corvus drive number (1)
	ld hl,rdbuf         ;HL=rdbuf (Address to write the sector)
	jp corv_writ_sec    ;Write a sector (256 bytes)

find_delim:
;Search for delimiter '=' or ':', abort if cr readed
;
	ld hl,cmdbuf
lef60h:
	ld a,(hl)	
	cp cr
	scf                 ;Set carry flag
	ret z               ;If end of line, return with HL point to cr
	inc hl	
	cp "="
	ret z               ;If '=' detected, return with HL points to next character
	cp ":"
	ret z               ;If ':' detected, return with HL points to next character
	jr lef60h

cmd_dev:
;command for set device number "!D"
;
	call get_numeric    ;Get buffer number after command
	jr c,lef77h
	ld (devnum),a       ;Store it as device number
	ret
	
lef77h:
	ld a,error_30       ;"SYNTAX ERROR" 
	jp error

cmd_uid:
; command for get current user id "!N"
;
	ld a,(userid)       ;get userid
	ld (errtrk),a       ;store as error track number

	ld a,error_89       ;"USER #"
	jp error            ;and give it out

cmd_hbv:
;command for get hardbox version "!H"
;
	ld a,3              ;Set major version 3
	ld (errtrk),a

	ld a,1              ;Set minor version 1
	ld (errsec),a

	ld a,error_99       ;"SMALL SYSTEMS HARDBOXVERSION #"
	jp error

cmd_exe:
;command to execute program in buffer "!E"
;
	call get_numeric    ;Get buffer number after command
	and 0fh             ;Use only 0 to 15

	ld d,a	
	ld e,0
	ld hl,buffers
	add hl,de	        ;HL=buffers+A*256

	jp (hl)             ;jump to the code at the buffer

cmd_ver:
;command for get version "!V"
;
	call corv_init      ;Initialize the Corvus controller

	ld a,10h            ;10h=Get drive parameter
	call corv_put_byte  ;Send first command byte
	ld hl,cmdbuf
	call get_numeric    ;Get drive number
	call corv_put_byte  ;Send second command byte (drive number for Get drive parameter - starts at 1)

	call sub_fae8h
	jp nz,lf036h

	ld a,(rdbuf+31)
	ld (errtrk),a
	ld a,(rdbuf+31+1)
	ld (errsec),a       ;errtrk/errsec=Last two bytes from firmware message

	ld de,buffer14
	ld hl,rdbuf
	ld bc,0100h         ;0100h (256 bytes)
	ldir                ;Copy BC bytes from (HL) to (DE)
	
	ld a,0ffh
	ld (00abah),a

	ld a,error_98       ;"VERSION #"
	jp error

cmd_siz:
;command for get disk size "!S"
;
	ld hl,cmdbuf
	call get_numeric    ;Get drive number
	ld (errtrk),a
	ld a,error_30       ;"SYNTAX ERROR"
	jp c,error

	ld a,(errtrk)
	dec a	
	and 0f0h
	or d	
	or e	
	ld a,error_30       ;"SYNTAX ERROR"
	jp nz,error

	ld a,10h            ;10h=Get drive parameter
	call corv_put_byte  ;Send first command byte
	ld a,(errtrk)
	call corv_put_byte  ;Send second command byte (drive number for Get drive parameter - starts at 1)

	call sub_fae8h
	jp nz,lf036h

	scf	
	ccf                 ;Clear carry flag

	ld a,(rdbuf+107)
	adc a,4             ;Add 4 to round the value after devided by 8
	srl a
	srl a
	srl a               ;A=A/8
	ld (errsec),a

	scf	
	ccf                 ;Clear carry flag

	ld a,(rdbuf+107+1)
	sla a
	sla a
	sla a
	sla a
	sla a               ;A=A*32

	scf	
	ccf                 ;Clear carry flag

	push hl	
	ld hl,errsec
	add a,(hl)          ;Add low/8 and high*32
	pop hl

	ld (errsec),a       ;errsec = round([rdbuf+107] / 8)

	ld a,error_96       ;"SUNOL DRIVE SIZE"
	jp error

lf036h:
	and 01fh
	ld (errtrk),a
	ld a,error_95       ;"SUNOL DRIVE ERROR" 
	jp error

cmd_lck:
;command for lock "!L"
;
	call find_delim     ;Search for delimiter '=' or ':', abort if cr readed
	call get_filename   ;Get a filename

	ld a,0bh
	call corv_put_byte  ;Send first command byte (0bh for Semaphore Lock)

	ld a,01h
	call corv_put_byte  ;Send second command byte (01h for Semaphore Lock)

	ld hl,filnam
	ld bc,0008h         ;Send 8 Bytes
	call corv_put_str   ;Send Filename

	call sub_fae8h
	jr nz,lf036h
	ld a,(rdbuf)
	or a	
	ret z	
	ld a,error_94       ;"LOCK ALREADY IN USE"
	jp error

cmd_ulk:
;command for unlock "!U"
;
	call find_delim     ;Search for delimiter '=' or ':', abort if cr readed
	call get_filename   ;Get a filename

	ld a,0bh
	call corv_put_byte  ;Send first command byte (0bh for Semaphore Unlock)

	ld a,11h
	call corv_put_byte  ;Send second command byte (11h for Semaphore Unlock)

	ld hl,filnam
	ld bc,0008h         ;Send 8 Bytes
	call corv_put_str   ;Send Filename

	call sub_fae8h
	jr nz,lf036h
	ret	

cmd_clr:
;command for clear "!C"
;
	ld a,(userid)
	or a	
	ld a,error_92       ;"PRIVILEGED COMMAND"
	jp nz,error         ;only allowd for userid=0

	call corv_init      ;Initialize the Corvus controller
	ld bc,0004h         ;Send 4 Bytes
	ld hl,lf0a9h
	jr z,lf09fh         ;If corv_init not failed, send it (4 bytes)
	ld hl,lf0adh
	inc bc              ;Send 5 Bytes	
lf09fh:
	call corv_put_str

	call sub_fae8h
	jp nz,lf036h
	ret	

lf0a9h:
    db 0ah,10h
	db 00h,00h

lf0adh:
    db 1ah,10h          ;Semaphore Initialize
	db 00h,00h,00h

lf0b2h:	
	call find_drvlet    ;Find drive letter
	ld a,(hl)           ;Get character
	call is_digit       ;Check if character is a digit
	jr nc,lf0c1h        ;  No: Jump to error
	sub "0"             ;Conver character to value
	ld (drvnum),a
	ret	
lf0c1h:
	ld a,error_30       ;"SYNTAX ERROR"
	jp error

cmd_ini:
;command for init "I"
;
	ret

cmd_vfy:
;command for verify "V"
;
	ld hl,00000h
	ld (l0d68h),hl
lf0cdh:
	call sub_f6edh
	jr c,lf0e1h
	bit 7,(ix+000h)     ;is marker for "Open File" set?
	jr z,lf0cdh
	ld (ix+001h),0ffh
	call wr_dir_blk
	jr lf0cdh

lf0e1h:
	ld a,(userid)
	jp init_user

lf0e7h:
	call find_drvlet    ;Find drive letter
	call get_filename   ;Get a filename

	ld a,(00d67h)
	push af	
	push hl	
	call sub_f782h
	ld a,error_33       ;"SYNTAX ERROR(INVALID FILENAME)"
	jp c,error

	ld hl,filnam
	ld de,l0d56h
	ld bc,00010h
	ldir                ;Copy BC bytes from (HL) to (DE) 
	pop hl	
	ld a,(hl)	
	cp "="
	ld a,error_30       ;"SYNTAX ERROR"
	jp nz,error

	inc hl	
	call get_filename   ;Get a filename

	call sub_f782h
	ld a,error_33       ;"SYNTAX ERROR(INVALID FILENAME)"
	jp c,error

	pop af	
	push af	
	ld hl,l0d56h
	call find_first
	ld a,error_63       ;"FILE EXISTS" 
	jp nc,error

	pop af	
	ld hl,filnam
	call find_first
	ld a,error_62       ;"FILE NOT FOUND" 
	jp c,error

	bit 7,(ix+000h)     ;is marker for "Open File" set?
	ret nz	
	ld hl,l0d56h
	ld b,010h
lf13dh:
	ld a,(hl)	
	ld (ix+002h),a
	inc hl	
	inc ix
	djnz lf13dh
	jp wr_dir_blk

cmd_new:
;command for new drive name (header or format) "N"
;
	call find_drvlet    ;Find drive letter
	call get_filename   ;Get a filename

	ld a,(hl)	
	cp ","
	ld a,error_30       ;"SYNTAX ERROR"
	jp nz,error

	inc hl	
	ex de,hl	
	ld hl,(00d67h)
	ld h,000h
	add hl,hl	
	push hl	
	ld bc,026b0h
	add hl,bc	
	ex de,hl	
	ld bc,00002h
	ldir                ;Copy BC bytes from (HL) to (DE) 
	pop hl	
	add hl,hl	
	add hl,hl	
	add hl,hl	
	ld bc,wrtbuf
	add hl,bc	
	ex de,hl	
	ld hl,filnam
	ld bc,00010h
lf179h:
	ld a,(hl)	
	or a	
	jr nz,lf17fh
	ld (hl),020h
lf17fh:
	ldi
	jp po,lfa85h
	jr lf179h

cmd_pos:
;command to set record position "P"
;
	ld a,(cmdbuf+1)     ;Get channel number from command buffer
	and 00fh
	ld (sa),a
	call sub_f7d0h

	bit 7,(iy+028h)
	ret z	
	ld a,(iy+000h)
	and 003h
	cp 003h
	ret nz
	call sub_eb00h

	ld a,(cmdbuf+4)     ;Get record position from command buffer
	dec a	
	cp (iy+015h)
	jr c,lf1b1h
	ld a,(iy+015h)
	dec a	
	ld (00bf9h),a
lf1b1h:
	ld c,(iy+015h)      ;Get record length
	ld de,(cmdbuf+2)    ;Get record number from command buffer
	ld a,d	
	or e	
	jr z,lf1bdh
	dec de	

lf1bdh:                 ;multiply record length (C) by record number (DE), result in AHL
	ld hl,00000h
	xor a               ;AHL=0	
	ld b,008h
lf1c3h:
	add hl,hl           ;AHL=AHL*2
	adc a,a
	rl c
	jr nc,lf1cch
	add hl,de           ;AHL=AHL+DE
	adc a,000h
lf1cch:
	djnz lf1c3h

	ld de,(cmdbuf+4)    ;Get record position from command buffer
	ld d,000h
	dec de              ;DE=record position - 1
	add hl,de	
	adc a,000h          ;AHL=AHL+DE

	ld (iy+020h),l      ;Set the block pointer for this channel to the low byte

	ld l,a	
	ld a,(iy+015h)
	sub e	
	ld (iy+025h),a      ;(iy+025h)=(iy+015h)-E
	ld (iy+020h+1),h    ;Set block address for this channel
	ld (iy+020h+2),l    ;(iy+020h+1)=LH

	call sub_eb00h
	call sub_f1f7h
	jp c,sub_f927h
	ld a,error_50       ;"RECORD NOT PRESENT"
	jp error

sub_f1f7h:
	push bc	
	push hl	
	ld l,(iy+012h)
	ld h,(iy+012h+1)
	ld b,(iy+012h+2)    ;BHL=file size in bytes
	inc hl	
	ld a,h	
	or l	
	jr nz,lf208h
	inc b	
lf208h:
	ld a,(iy+020h)
	cp l	
	ld a,(iy+020h+1)
	sbc a,h	
	ld a,(iy+020h+2)
	sbc a,b	
	pop hl	
	pop bc	
	ret

cmd_blk:	
;command for block "B"
;
	ld hl,cmdbuf
lf21ah:
	ld a,(hl)	
	inc hl	
	cp cr
	jr z,lf24dh
	cp "-"
	jr nz,lf21ah
lf224h:
	ld a,(hl)	
	inc hl	
	cp cr
	jr z,lf24dh
	cp "A"
	jp c,lf224h
	cp "Z"+1
	jp nc,lf224h
	cp "W"              ;Check for "B-W": Block Write
	jp z,blk_wr
	cp "R"              ;Check for "B-R": Block Read
	jp z,blk_rd
	cp "A"              ;Check for "B-A": Block Allocate
	jp z,blk_use
	cp "F"              ;Check for "B-F": Block Free
	jp z,blk_fre
	cp "P"              ;Check for "B-P": Buffer Pointer
	jp z,blk_ptr
lf24dh:
	ld a,error_30       ;"SYNTAX ERROR"
	jp error

blk_wr:
;command for block write "B-W"
;
	call sub_f36dh
	push af	
	push hl	

	ld a,(iy+020h)      ;Get the block pointer for this channel
	dec a               ;Decrement it
	ld hl,(00aech)      ;Get buffer address
	ld (hl),a           ;Store the block pointer minus 1 at the first byte into the buffer

	pop hl	
	pop af
	jp corv_writ_sec    ;Write a sector (256 bytes)

blk_rd:
;command for block read "B-R"
;
	call sub_f36dh
	call corv_read_sec  ;Reads a sector (256 bytes)

	ld hl,(00aech)      ;Get buffer address
	ld a,(hl)           ;Get first byte of this buffer
	ld (iy+025h),a      ;Store it as the count of valid bytes
	ld (iy+020h),001h   ;Set the block pointer for this channel to 1
	ret

blk_ptr:
;command for block pointer "B-P"
;
	call get_chan       ;Get channel number
	jr c,lf24dh         ;If missing or wrong number, SYNTAX ERROR

	call get_numeric    ;Get block pointer after command to DEA
	ld (iy+020h),a      ;Save this block pointer for this channel
	ret

blk_fre:
;command for block free "B-F"
;
	call get_bam_bit    ;Read track and sector and get the BAM bit from BAM sector
	and 07fh
	jr lf290h

blk_use:
;command for block allocate "B-A"
;
	call get_bam_bit    ;Read track and sector and get the BAM bit from BAM sector
	jr c,lf29ah
	or 080h

lf290h:
	rrca	
	djnz lf290h
	ld (hl),a	
	call write_bam      ;Write a BAM sector
	jp error_ok

lf29ah:
	inc b	
lf29bh:
	push af	
	ld ix,errsec
	inc (ix+000h)
	jr nz,lf2adh
	inc (ix+001h)
	jr nz,lf2adh
	inc (ix+002h)
lf2adh:
	ld a,(l0011h)
	cp (ix+000h)
	jr nz,lf2f8h
	ld a,(l0011h+1)
	cp (ix+001h)
	jr nz,lf2f8h
	ld a,(l0013h)
	cp (ix+002h)
	jr nz,lf2f8h
	ld (ix+000h),000h
	ld (ix+001h),000h
	ld (ix+002h),000h
	ld ix,errtrk
	inc (ix+000h)
	jr nz,lf2ddh
	inc (ix+001h)

lf2ddh:
	ld a,(l000fh)
	sub (ix+000h)
	ld a,(l000fh+1)
	sbc a,(ix+001h)
	jr nc,lf2f8h

	ld (ix+000h),000h
	ld (ix+001h),000h
	ld a,error_65       ;"NO BLOCK"
	jp error

lf2f8h:
	pop af	
	djnz lf30eh
	inc hl	
	ld a,l	
	cp 010h
	jr nz,lf30bh

	ld hl,bamsec        ;Take next BAM sector
	inc (hl)	
	call read_bam       ;Read a BAM sector

	ld hl,bambuf
lf30bh:
	ld a,(hl)	
	ld b,008h
lf30eh:
	rrca	
	jr c,lf29bh
	ld a,error_65       ;"NO BLOCK"
	jp error

get_bam_bit:
;Read track and sector and get the BAM bit from BAM sector
;
	call get_ts         ;Get track and sector to absolute sector BDE

	ld a,b              ;ADE=BDE
	ld b,003h
	push de             ;Save DE
lf31dh:
	rra	
	rr d
	rr e
	djnz lf31dh         ;ADE=ADE/8 (8 blocks are coded in 1 byte)

	push de             ;Save DE
	ld a,d
	ld (bamsec),a       ;(bamsec)=D
	call read_bam       ;Read a BAM sector

	pop de              ;Restore DE (absolute sector/8)
	ld d,000h
	ld hl,bambuf
	add hl,de           ;HL=bambuf+E

	pop bc              ;Restore BC (absolute sector)
	ld a,c
	and 007h            ;A=C MOD 8
	ld c,a              ;C=A
	xor 007h
	ld b,a              ;B=7-A

	ld a,(hl)
lf33ch:
	rrca	
	dec c	
	jp p,lf33ch
	ret
	
cmd_usr:
;command for user "U"
;
	ld hl,00bf6h
	ld a,(hl)	
	inc hl	
	and 00fh
	cp 01h				;Check for "U1" or "UA": Block Raad
	jr z,cmd_u1
	cp 02h				;Check for "U2" or "UB": Block Write
	jr z,cmd_u2
	cp 0ah				;Check for "U:" or "UJ": Reset
	jp z,reset
	jp lf24dh

cmd_u1:
;command for user 1 "U1"
;
	call sub_f36dh
	ld (iy+025h),0ffh   ;Set all 255 plus 1 bytes als valid
	ld (iy+020h),000h   ;Set the block pointer for this channel to 0
	jp corv_read_sec    ;Reads a sector (256 bytes)

cmd_u2:
;command for user 2 "U2"
;
	call sub_f36dh
	jp corv_writ_sec    ;Write a sector (256 bytes)

sub_f36dh:
	call get_chan       ;Get channel number
	ld a,error_30       ;"SYNTAX ERROR"
	jp c,error          ;If missung or wrong channel number, SYNTAX ERROR

	call get_ts         ;Get track and sector to absolute sector BDE
	call clrerrts

	ld hl,(l0036h)
	ld a,(l0036h+2)
	add hl,de	
	adc a,b	
	ex de,hl            ;ADE=(l0036)+BDE
	
	ld hl,phydrv
	ld b,(hl)           ;B=Corvus drive number

	ld hl,(00aech)
	ret
	
get_ts:
;Get track and sector from command buffer
;
	call get_numeric    ;Get drive number after command to DEA
	jp c,lf417h         ;If missing drive number, SYNTAX ERROR

	ld de,(l000fh)
	push hl	
	ld hl,00000h        ;HL=0
	ld b,008h
	add hl,hl           ;HL=HL*2
lf39dh:
	rla
	jr nc,lf3a1h
	add hl,de	
lf3a1h:
	djnz lf39dh
	ex (sp),hl	

	call get_numeric    ;Get track number after command to DEA
	jr c,lf417h         ;If missing track number, SYNTAX ERROR

	inc d	
	dec d	
	jr nz,lf412h        ;If track is greater than 65535, ILLEGAL TRACK OR SECTOR

	ld d,e	
	ld e,a              ;Now DE contain the track number
	ld (errtrk),de      ;Save as error track (if it must be used)

	dec de              ;Decrement track number, because it starts with 1
	ld bc,(l000fh)

	ld a,e
	sub c	
	ld a,d	
	sbc a,b	
	jr nc,lf412h        ;If track number (DE) is greater than max. track (BC), ILLEGAL TRACK OR SECTOR

	ex (sp),hl
	
	add hl,de	
	ex de,hl	
	ld ix,(l0011h)
	ld bc,(l0013h)
	ld b,018h
	xor a               ;A=0	
	ld hl,00000h
lf3cfh:
	add hl,hl	
	adc a,a	
	add ix,ix
	rl c
	jr nc,lf3dah
	add hl,de	
	adc a,000h
lf3dah:
	djnz lf3cfh
	ex (sp),hl	
	push af

	call get_numeric    ;Get sector number after command to DEA
	jr c,lf417h         ;If missing sector number, SYNTAX ERROR

	ld (errsec),a
	ld (errsec+1),de    ;Save as error seector (if it must be used)

	ld b,a	
	ld hl,l0011h
	cp (hl)	
	inc hl	
	ld a,e	
	sbc a,(hl)	
	inc hl	
	ld a,d	
	sbc a,(hl)	
	jr nc,lf412h
	ld a,d	
	ld d,e	
	ld e,b	
	pop bc	
	pop hl	
	add hl,de	
	adc a,b	
	ex de,hl	
	ld b,a

	ld hl,(usrsiz)
	ld c,000h           ;CHL=User area size in kb (usrsiz)
	add hl,hl	
	rl c
	add hl,hl	
	rl c                ;CHL=CHL*4 (4 blocks are 1 kb)

	ld a,e	
	sub l	
	ld a,d	
	sbc a,h	
	ld a,b	
	sbc a,c             ;If BDE <= CHL
	ret c               ;  YES: All okay, return

lf412h:
	ld a,error_66       ;"ILLEGAL TRACK OR SECTOR"
	jp error

lf417h:
	ld a,error_30       ;"SYNTAX ERROR"
	jp error

get_chan:
;Get channel number from command buffer
;
	call get_numeric    ;Get channel number after command to DEA
	ret c               ;If missing number, return with carry set

	push af             ;Save the channel number on stack
	and 0f0h
	or e	
	or d	
	scf	
	ret nz              ;If number ist greater than 15, return with carry set

	pop af				;Restore valid channel number
	ld (sa),a           ;Save the channel number as secondary address

	push hl	
	call sub_f7d0h
	pop hl	
	bit 6,(iy+028h)     ;Ist marker for channel access set?
	scf	
	ret z	
	or a	
	ret

cmd_abs:
;command for absolute access "A"
;
	ld hl,cmdbuf
lf43bh:
	ld a,(hl)	
	inc hl	
	cp cr
	jr z,lf45fh
	cp "-"
	jr nz,lf43bh
lf445h:
	ld a,(hl)	
	inc hl	
	cp cr
	jr z,lf45fh
	cp "A"
	jp c,lf445h
	cp "Z"+1
	jp nc,lf445h
	cp "W"              ;Check for "A-W": Absolute Read
	jp z,abs_wr
	cp "R"              ;Check for "A-R": Absolute Write
	jp z,abs_rd
lf45fh:
	ld a,error_30       ;"SYNTAX ERROR"
	jp error

abs_wr:
;command for absolute write "A-W"
;
	ld a,(userid)
	or a	
	ld a,error_92       ;"PRIVILEGED COMMAND"
	jp nz,error         ;only allowd for userid=0

	call sub_f494h
	jp corv_writ_sec    ;Write a sector (256 bytes)

abs_rd:
;command for absolute read "A-R"
;
	call sub_f494h
	ld (iy+020h),000h   ;Set the block pointer for this channel to 0
	ld (iy+025h),0ffh   ;Set all 255 plus 1 bytes als valid
	push af	
	or d	
	jr nz,lf487h
	ld a,e	
	cp 00ch             ;Is absolute sector number is less than 12? (Why 12?, at 12 starts the passwords!)
	jr c,lf490h         ;  NO: It's not protected, read the sector

lf487h:
	ld a,(userid)
	or a	
	ld a,error_92       ;"PRIVILEGED COMMAND"
	jp nz,error         ;only allowd for userid=0

lf490h:
	pop af	
	jp corv_read_sec    ;Reads a sector (256 bytes)

sub_f494h:
	call get_chan       ;Get channel number
	ld a,error_30       ;"SYNTAX ERROR"
	jp c,error

	call get_numeric
	push af	
	call get_numeric
	push de	
	ld d,e	
	ld e,a	
	pop af	
	pop bc	
	ld hl,(00aech)
	ret
	
open_dir:
;Open a channel to the directory and create the output into a buffer
;
	set 2,(iy+028h)		;Set marker for directory
	set 7,(iy+028h)
	ld hl,00c76h
	call get_filename   ;Get a filename

lf4bah:
	ld a,(hl)           ;Get next charcter from command
	inc hl	
	cp "H"              ;Is it a "H" for "show Hidden"?
	jr z,lf4c4h         ;  Yes: Jump and store
	cp cr               ;Is it a end marker?
	jr nz,lf4bah        ;  No: Jump and read next

lf4c4h:
	ld (dirhid),a       ;Store Marker for "Show Hidden"

	ld hl,filnam
	ld de,025f7h
	ld bc,00010h        ;16 Characters
	ldir                ;Copy BC bytes from (HL) to (DE) 
	ld a,(00d67h)
	ld (025f6h),a
	ld e,a	
	ld d,000h
	ld hl,dirout
	ld (wrtprt),hl

	ld (hl),low 0401h
	inc hl              ;put start address (low) in buffer
	ld (hl),high 0401h
	inc hl              ;put start address (high) in buffer

	inc hl	
	inc hl              ;skip two bytes in buffer (unused link address)

	ld (hl),e	
	inc hl              ;put drive number (low) in buffer
	ld (hl),0
	inc hl              ;put zero as drive number (high) in buffer

	ld (hl),rvs
	inc hl              ;put "rvs on" in buffer
	ld (hl),"""
	inc hl	            ;put starting quote in buffer	

	push de	

	ex de,hl	
	add hl,hl	
	add hl,hl	
	add hl,hl	
	add hl,hl	
	ld bc,wrtbuf
	add hl,bc	
	ld bc,16            ;16 Characters
	ldir                ;Copy BC bytes from (HL) to (DE) 
	ex de,hl	

	ld (hl),"""
	inc hl	            ;put ending quote in buffer
	ld (hl)," "
	inc hl              ;put a space as delemiter in buffer

	ex de,hl	
	ld hl,026b0h
	pop bc	

	add hl,bc	
	add hl,bc	
	ld bc,2             ;2 Characters
	ldir                ;Copy BC bytes from (HL) to (DE) 
	ld hl,lf675h        ;" "
	ld bc,1             ;1 Character
	ldir                ;Copy BC bytes from (HL) to (DE) 
	ex de,hl	

	ld a,(userid)
	push de	
	ld de,00000h        ;Give user id as number out
	call put_number     ;Put a number into buffer
	pop de

	ld (hl),0           ;put end of line (ascii 0) in buffer
	inc hl

	ld (endbuf),hl
	ld de,00401h
	add hl,de	
	ld de,dirout+2
	or a	
	sbc hl,de
	ld (dirout+2),hl
	ld (025f4h),hl

	ld hl,00000h
	ld (l0d68h),hl

	ld hl,025f7h
	ld a,(hl)	
	or a	
	jp nz,le2aeh

	ld (hl),"*"         ;put asteriks in buffer
	inc hl	

	ld (hl),0           ;put end of line (ascii 0) in buffer
	jp le2aeh

sub_f556h:
	ld hl,025f7h
	ld a,(025f6h)
	call find_next
	jp c,lf623h         ;All entries readed? Yes: we are finish, write "Blocks free"

	bit 5,(ix+000h)     ;is marker for "Hide" set?
	jr z,lf570h         ;  No: show this entry
	ld a,(dirhid)
	cp "H"              ;Was a "Show hidden" command read?
	jp nz,sub_f556h     ;  No: Skip find next directory entry

lf570h:
	ld hl,dirout
	ld (wrtprt),hl

	inc hl	
	inc hl              ;skip two bytes in buffer (unused link address)

	ld e,(ix+012h+1)    ;E=low block size
	ld d,(ix+012h+2)    ;D=high block size
	inc de              ;Increment block size
	ld (hl),e           ;Put low block size in buffer
	inc hl	
	ld (hl),d           ;Put low block size in buffer	
	inc hl

	ld b,003h
	ld iy,le5e7h
lf589h:
	ld a,e	
	cp (iy+000h)
	ld a,d	
	sbc a,(iy+001h)
	jr nc,lf59eh
	ld (hl)," "
	inc hl	
	inc iy
	inc iy
	inc iy
	djnz lf589h

lf59eh:
	ld (hl),"""
	inc hl	            ;put starting quote in buffer

	push ix
	ld b,010h
lf5a5h:
	ld a,(ix+002h)
	or a	
	jr z,lf5b1h         ;end marker reached?
	ld (hl),a           ;put charcter from filename in buffer
	inc hl	
	inc ix
	djnz lf5a5h

lf5b1h:
	ld (hl),"""
	inc hl	            ;put ending quote in buffer

	ld a,b	
	or a	
	jr z,lf5bdh

lf5b8h:
	ld (hl)," "
	inc hl	
	djnz lf5b8h         ;fill with spaces

lf5bdh:
	pop ix
	ld (hl)," "         ;Space for not open file
	bit 7,(ix+000h)     ;is marker for "Open File" set?
	jr z,lf5c9h
	ld (hl),"*"
lf5c9h:
	inc hl

	ex de,hl	
	ld a,(ix+000h)
	and 003h            ;get file type from attribute flag
	ld b,a	
	add a,a	
	add a,b	            ;A=A*3
	ld c,a	
	ld b,000h           ;BC=(file type) * 3
	ld hl,filetypes
	add hl,bc	
	ld bc,3             ;file type has 3 charcters
	ldir                ;Copy BC bytes from (HL) to (DE)
	                    ;Copy file type into buffer
	ex de,hl
	
	ld (hl)," "         ;put a space as delemiter in buffer
	inc hl

	ld (hl),"-"         ;Minus for not write proteected
	bit 6,(ix+000h)     ;is marker for "Write Protect" set?
	jr z,lf5edh
	ld (hl),"W"
lf5edh:
	inc hl	

	ld (hl),"-"         ;Minus for not global
	bit 4,(ix+000h)     ;is marker for "Global" set?
	jr z,lf5f8h
	ld (hl),"G"
lf5f8h:

	ld a,(dirhid)
	cp "H"
	jr nz,lf60ah
	inc hl	

	ld (hl),"-"         ;minus for not hidden
	bit 5,(ix+000h)     ;is marker for "Hide" set?
	jr z,lf60ah
	ld (hl),"H"
lf60ah:
	inc hl	

	ld (hl),0           ;put end of line (ascii 0) in buffer
	inc hl
	
	ld (endbuf),hl
	ld de,dirout
	or a	
	sbc hl,de
	ld de,(025f4h)
	add hl,de	
	ld (dirout),hl
	ld (025f4h),hl
	ret

lf623h:
	call sub_f8a3h
	ld (dirout+2),hl
	ld hl,dirout
	ld (wrtprt),hl
	ld de,dirout+4
	ld hl,msg_blk_free  ;"BLOCKS FREE : "
	ld bc,msg_blk_free_end-msg_blk_free
	ldir                ;Copy BC bytes from (HL) to (DE)

	ld hl,username      ;Current username
	ld b,010h           ;B=10h (16 bytes)
lf63fh:
	ld a,(hl)           ;Get charcter from username
	or a                ;Is end marker (ascii 0) detected?
	jr z,lf648h         ;  YES: break
	ld (de),a           ;  NO: put charcter into buffer
	inc hl
	inc de	
	djnz lf63fh         ;Next character

lf648h:
	xor a               ;A=0	
	ld (de),a           ;put end of line (ascii 0) in buffer
	inc de	

	ld (de),a           ;put 0 for low byte of link address in buffer
	inc de	

	ld (de),a           ;put 0 for high byte of link address in buffer	
	inc de	

	ld (endbuf),de

	dec de	
	dec de	
	ld hl,(025f4h)

	add hl,de	
	ld bc,dirout
	or a	
	sbc hl,bc
	ld (dirout),hl

	ld hl,00000h
	ld (025f4h),hl
	ret
	
filetypes:
    db "SEQ"
    db "USR"
    db "PRG"
    db "REL"

lf675h:
    db " "

msg_blk_free:
	db "BLOCKS FREE : "
msg_blk_free_end:

find_first:
	ld de,00000h
	ld (l0d68h),de

find_next:
	ld c,a	
	ld (02608h),hl

lf68fh:
	push bc	
	call sub_f6edh
	ld hl,(02608h)
	pop bc	
	ret c	
	push ix
	pop iy
	bit 7,(iy+001h)
	jr nz,lf68fh
	bit 4,(iy+000h)
	jr nz,lf6aeh
	ld a,(iy+001h)
	cp c	
	jr nz,lf68fh
lf6aeh:
	ld b,010h
lf6b0h:
	ld a,(hl)	
	cp "*"
	ret z	
	cp "?"
	jr nz,lf6c0h
	ld a,(iy+002h)
	or a	
	jr z,lf68fh
	jr lf6c5h
lf6c0h:
	cp (iy+002h)
	jr nz,lf68fh
lf6c5h:
	inc hl	
	inc iy
	or a	
	ret z	
	djnz lf6b0h
	ret
	
sub_f6cdh:
	ld hl,00000h
	ld (l0d68h),hl
lf6d3h:
	call sub_f6edh
	bit 7,(ix+001h)
	ret nz	
	inc de	
	ld a,(maxdir)
	cp e	
	jr nz,lf6d3h
	ld a,(maxdir+1)
	cp d	
	jr nz,lf6d3h
	ld a,error_72       ;"DISK FULL" 
	jp error

sub_f6edh:
	ld a,(l260ch)
	or a	
	ld a,error_84       ;"DRIVE NOT CONFIGURED"
	jp z,error

	ld hl,(l0d68h)
	ld e,l	
	ld d,h              ;DE=(l0d68h)
	inc hl	
	ld (l0d68h),hl      ;(l0d68h)=DE+1

	ld a,(maxdir)
	cp e	
	jr nz,lf70bh
	ld a,(maxdir+1)
	cp d                ;If DE=(maxdir)?
	scf                 ;Set carry flag
	ret z               ;  YES: Return with carry set

lf70bh:
	ld a,e	
	and 003h            ;A=DE mod 4
	jr nz,lf713h        ;Is this zero? NO: block must be read and exists in buffer
	call rd_dir_blk     ;Else read the directory block

lf713h:
	ld ix,dirbuf
	ld a,e	
	and 007h
	rrca	
	rrca	
	rrca	
	ld c,a	
	ld b,000h
	add ix,bc
	ld a,(ix+001h)
	xor 0e5h
	ret nz	
	scf	
	ret

get_filename:
;Get a filename (max. 16 characters) from HL and store it. Read a heading drive number, too.
;
; HL = Poniter to command buffer
;
	ld a,(drvnum)       ;Get the drvnum as default, if we don't read it
	ld (00d67h),a       ;(00d67h)=(drvnum)

	ld a,(hl)           ;Get character from buffer
	ld e,a              ;And save it in E
	call is_digit       ;Check if character is a digit
	jr nc,lf74ah        ;  No: Jump
	inc hl	
	ld a,(hl)           ;Get next character from buffer
	dec hl	
	cp cr               ;Is the end marker?
	jr z,lf743h         ;  YES: Take the number as drive number
	cp ":"              ;Is the delimiter between drive number and filename?
	jr nz,lf74ah        ;  NO: The number is part of the filename
	inc hl              ;Skip the ':'

lf743h:
	inc hl              ;Skip the device number
	ld a,e              ;Restore it
	sub "0"             ;Conver character to value
	ld (00d67h),a       ;Store it

lf74ah:
	ld b,011h           ;B=11h (16 Bytes plus end marker or delimiter)
	ld de,filnam        ;DE=filnam
lf74fh:
	ld a,(hl)           ;Get character of filename from buffer
	ld (de),a           ;Store it as filename
	cp cr               ;Is the end marker?
	jr z,lf766h         ;  YES: We are finish
	cp ","              ;Is the delimiter ','?
	jr z,lf766h         ;  YES: We are finish, too
	cp "="              ;Is the delimietr '='?
	jr z,lf766h         ;  YES: We are finish, too, too
	inc hl
	inc de
	djnz lf74fh         ;Loop all 17 Characters
                        ;If we don't found a end marker or delimiter, this is an error

	ld a,error_31       ;"SYNTAX ERROR (INVALID COMMAND)"
	jp error

lf766h:
	xor a               ;A=0
	ld (de),a	
	inc de	
	djnz lf766h
	ret
	
find_drvlet:
;Find drive letter
;
; HL = Poniter to command buffer
;
	ld hl,cmdbuf
lf76fh:
	ld a,(hl)	
	cp cr
	ld a,error_34       ;"SYNTAX ERROR(NO FILENAME)"
	jp z,error

	ld a,(hl)	
	cp "0"
	jr c,lf77fh
	cp "9"+1
	ret c	
lf77fh:
	inc hl	
	jr lf76fh

sub_f782h:
	ld b,010h
	ld hl,filnam
lf787h:
	ld a,(hl)	
	cp "?"
	scf	
	ret z	
	cp "*"
	scf	
	ret z	
	djnz lf787h
	or a	
	ret
	
get_numeric:
;Get a number from HL and return in DEA
;
; HL = Poniter to command buffer
;
	ld a,(hl)           ;Get Character from buffer
	inc hl	
	cp cr               ;Is the end marker?
	scf	
	ret z               ;  Yes: return with carry set

	call is_digit       ;Check if character is a digit
	jr nc,get_numeric   ;  No: Jump, get next charcter

	ld de,00000h        ;We start with 000000h (DEB)
	ld b,000h

	dec hl              ;We want to reread this digit character
	
lf7a5h:
	                    ;This will calculate DEB = DEB * 10
	push hl             ;Save HL on stack
	ld h,d
	ld l,e              ;Save DE in HL
	ld a,b              ;Restore low byte in A
	add a,a
	adc hl,hl           ;HLA = HLA * 2
	add a,a
	adc hl,hl           ;HLA = HLA * 2
	add a,b	
	adc hl,de           ;HLA = HLA + DEB
	add a,a	
	adc hl,hl           ;HLA = HLA * 2
	ex de,hl            ;DE=HL
	pop hl              ;Restore HL from stack
	ld b,a              ;Save low byte in B

	ld a,(hl)           ;Get Character from buffer
	sub "0"             ;Conver character to value
	add a,b             ;add saved low byte
	ld b,a              ;save low byte in B

	jr nc,lf7c0h        ;Is overflow? No: Need no increment
	inc de	

lf7c0h:
	inc hl              ;Next character
	ld a,(hl)           ;Get Character from buffer
	call is_digit       ;Check if character is a digit
	jr c,lf7a5h         ;  Yes: read next digit
	ld a,b              ;Restore low byte in A
	ret
	
is_digit:
;Check if character in A is a digit
;Returns carry set (1) if it's a digit
;Returns carry clear (0) if not
;
	cp "0"
	ccf                 ;Invert the carry flag
	ret nc              ;Less than '0', return with clear carry
	cp "9"+1
	ret                 ;Between than '0' and '9' (incl.), return with set carry
	
sub_f7d0h:
	ld a,(sa)
	ld d,a	
	ld e,000h
	ld hl,bufs
	add hl,de	
	ld (00aeah),hl
	ld hl,buffers
	add hl,de	
	ld (00aech),hl
	ld hl,01d6fh
	srl d
	rr e
	add hl,de	
	ld (00aeeh),hl
	ld iy,l0857h
	ld de,l0027h+2
lf7f6h:
	ld (l0ae8h),iy
	dec a	
	or a	
	ret m	
	add iy,de
	jr lf7f6h

sub_f801h:
	push de	
	push bc	
	call chk_wrt_rights
	ld hl,00000h
lf809h:
	ld a,(de)	
	ld b,008h
lf80ch:
	rra	
	jr nc,lf815h
	inc hl	
	djnz lf80ch
	inc de	
	jr lf809h
lf815h:
	scf	
lf816h:
	rra	
	djnz lf816h
	pop bc	
	push hl	
	or a	
	sbc hl,bc
	jp nc,lf825h
	pop hl	
	ld (de),a	
	pop de	
	ret	
lf825h:
	ld a,error_72       ;"DISK FULL"
	jp error

sub_f82ah:
	push ix
	push iy
	push hl	
	push de	
	push bc	
	call chk_wrt_rights
	call read_128       ;Read sector (l0027h)+DE with 128 bytes to (00aeeh)
	ld b,040h
	ld ix,(00aeeh)
lf83dh:
	ld e,(ix+000h)
	ld d,(ix+001h)
	bit 7,d
	jr nz,lf86ch
	push bc	
	push de	
	call sub_f8fch

	ld b,080h
	ld iy,(00aeah)

lf852h:
	ld l,(iy+000h)
	ld h,(iy+001h)
	ld de,l0457h
	call sub_f883h

	inc iy
	inc iy
	djnz lf852h

	pop hl	
	ld de,l0057h
	call sub_f883h

	pop bc	
lf86ch:
	inc ix
	inc ix
	djnz lf83dh
	pop bc	
	pop de	
	pop hl	
	pop iy
	pop ix
	ret
	
sub_f87ah:
; Inputs 
;   HL =
;   DE =
;
	bit 7,h
	ret nz	
	call sub_f88dh
	or (hl)             ;Set bit with mask (HL mod 8)
	ld (hl),a	
	ret
	
sub_f883h:
; Inputs 
;   HL =
;   DE =
;
	bit 7,h
	ret nz	
	call sub_f88dh
	cpl	
	and (hl)            ;Clear bit with mask (HL mod 8)
	ld (hl),a	
	ret	

sub_f88dh:
; Inputs 
;   HL =
;   DE =
; Outputs
;   HL = (HL / 8) + DE
;    A = bitmask(HL mod 8) with bitmask(0)=00000001b ... bitmask(7)=10000000b
;
	push bc	
	ld a,l	
	push af             ;Save HL mod 8 on stack
	ld b,3
	call hl_shr_b       ;HL=HL/8
	add hl,de           ;HL=HL+DE
	pop af	
	and 007h            ;Restore HL mod 8 from stack
	ld b,a	
	ld a,001h           ;A=00000001b
	jr z,lf8a1h
lf89eh:
	rla                 ;Shift A left, (HL mod 8) times
	djnz lf89eh
lf8a1h:
	pop bc
	ret
	
sub_f8a3h:
	ld ix,l0457h
	ld de,(00034h)
	ld hl,00000h
lf8aeh:
	ld b,008h
	ld c,(ix+000h)
	inc ix
lf8b5h:
	rr c
	jr c,lf8bah
	inc hl	
lf8bah:
	dec de	
	ld a,d	
	or e	
	jr z,lf8c3h
	djnz lf8b5h
	jr lf8aeh
lf8c3h:
	add hl,hl	
	ret	

rd_dir_blk:
;Read a directory block from Corvus drive to dirbuf
;
;DE = Directory entry
;
	push de	
	push hl	
	call calc_dir_blk
	call corv_read_sec  ;Reads a sector (256 bytes)
	pop hl	
	pop de	
	ret	

wr_dir_blk:
;Write a directory block to Corvus drive from dirbuf
;
;DE = Directory entry
;
	push de	
	push hl	
	call chk_wrt_rights
	call calc_dir_blk
	call corv_writ_sec  ;Write a sector (256 bytes)
	pop hl	
	pop de	
	ret	

calc_dir_blk:
	ld a,(phydrv)
	ld b,a              ;B=Corvus drive number
	
	srl d
	rr e
	srl d
	rr e
	srl d
	rr e                ;DE=DE / 8

	ld hl,(dirsrt)
	add hl,de	
	ex de,hl	
	ld a,(dirsrt+2)
	adc a,000h          ;ADE=dirsrt+DE

	ld hl,dirbuf
	ret
	
sub_f8fch:
;Read
;
	push de	
	push hl	
	call sub_f915h
	call corv_read_sec  ;Reads a sector (256 bytes)
	pop de	
	pop hl	
	ret

sub_f907h:
;Write
;
	push de	
	push hl	
	call chk_wrt_rights
	call sub_f915h
	call corv_writ_sec  ;Write a sector (256 bytes)
	pop de	
	pop hl	
	ret

sub_f915h:
	ld a,(phydrv)
	ld b,a              ;B=Corvus drive number

	ld hl,(l002ch)
	ld a,(l002ch+2)
	add hl,de	
	ex de,hl	
	adc a,000h          ;ADE=l002ch + DE
	ld hl,(00aeah)
	ret

sub_f927h:
; Read
;
	push de	
	push hl	
	call sub_f93dh
	call corv_read_sec  ;Reads a sector (256 bytes)
	pop hl	
	pop de	
	ret

sub_f932h:
;Write
;
	push de	
	push hl	
	call sub_f93dh
	call corv_writ_sec  ;Write a sector (256 bytes)
	pop hl	
	pop de	
	ret

sub_f93dh:
	push ix
	push iy
	ld a,(00d6dh)
	ld iy,(l0ae8h)
	cp (iy+026h)
	jr z,lf98eh
	ld (iy+026h),a
	ld c,a	
	ld b,000h
	ld ix,(00aeeh)
	add ix,bc
	add ix,bc
	ld e,(ix+000h)
	ld d,(ix+001h)
	ld a,e	
	and d	
	inc a	
	push af	
	call nz,sub_f8fch
	pop af	
	jr nz,lf98eh
	ld de,l0057h
	ld bc,(l002fh)
	call sub_f801h
	ld (ix+000h),l
	ld (ix+001h),h
	ld hl,(00aeah)
	ld b,000h
lf980h:
	ld (hl),0ffh
	inc hl	
	djnz lf980h
	ld e,(iy+023h)
	ld d,(iy+024h)
	call write_128      ;Write sector (l0027h)+DE with 128 bytes from (00aeeh)
lf98eh:
	ld a,(00d6ah)
	ld c,a	
	ld b,000h
	ld ix,(00aeah)
	add ix,bc
	add ix,bc
	ld l,(ix+000h)
	ld h,(ix+001h)
	ld a,l	
	and h	
	inc a	
	jr nz,lf9cdh
	ld de,l0457h
	ld bc,(00034h)
	call sub_f801h
	ld (ix+000h),l
	ld (ix+001h),h
	ld c,(iy+026h)
	ld b,000h
	ld ix,(00aeeh)
	add ix,bc
	add ix,bc
	ld e,(ix+000h)
	ld d,(ix+001h)
	call sub_f907h
lf9cdh:
	ld ix,(00aeah)
	ld a,(00d6ah)
	add a,a	
	ld e,a	
	ld d,000h
	add ix,de
	ld l,(ix+000h)
	ld h,(ix+001h)
	xor a               ;A=0

	ld b,003h
lf9e3h:
	add hl,hl	
	adc a,a	
	djnz lf9e3h         ;AHL=AHL*8

	ld de,(00d6ch)
	ld d,000h
	add hl,de           ;HL=HL+(00d6ch)

	ld de,(l0031h)
	add hl,de	
	ex de,hl
	ld b,a	
	ld a,(l0031h+2)
	adc a,b             ;ADE=(l0031h)+AHL

	ld hl,phydrv        ;HL=phydrv (target address)
	ld b,(hl)           ;B=Corvus drive number

	ld hl,(00aech)
	pop iy
	pop ix
	ret

read_128:
;Read sector (l0027h) with 128 bytes to (00aeeh)
;
;      DE = 128 byte sector number
;(phydrv) = Curvus device number
;(l0027h) = sector offset
;(00aeeh) = target address
;
	push hl	
	push de	
	push bc	
	srl d
	rr e                ;DE=DE/2
	push af	
	ld hl,(l0027h)
	ld a,(l0027h+2)     ;AHL=l0027h
	add hl,de	
	adc a,000h
	ex de,hl            ;ADE=AHL+DE

	ld hl,phydrv
	ld b,(hl)           ;B=Corvus drive number
	
	ld hl,rdbuf
	call corv_read_sec  ;Reads a sector (256 bytes)
	pop af

	ld hl,rdbuf         ;HL=rdbuf is source
	ld bc,00080h        ;BC=128 Bytes
	jr nc,lfa2bh        ;First of second half? (DE mod 2)
	add hl,bc           ; SECOND: Add the size of one half

lfa2bh:
	ld de,(00aeeh)      ;Get target address
	ldir                ;Copy BC bytes from (HL) to (DE) 
	pop bc	
	pop de	
	pop hl	
	ret

write_128:
;Write sector (l0027h) with 128 bytes from (00aeeh)
;
;      DE = 128 byte sector number
;(phydrv) = Curvus device number
;(l0027h) = sector offset
;(00aeeh) = source address
;
	push hl	
	push de	
	push bc	
	call chk_wrt_rights
	srl d
	rr e                ;DE=DE/2
	ex af,af'	
	ld hl,(l0027h)
	ld a,(l0027h+2)     ;AHL=l0027h
	add hl,de	
	adc a,000h
	ex de,hl            ;ADE=AHL+DE
	
	ld hl,phydrv
	ld b,(hl)           ;B=Corvus drive number	

	ld hl,rdbuf
	push af	
	push de	
	push bc	
	call corv_read_sec  ;Reads a sector (256 bytes)
	ex af,af'

	ld hl,rdbuf         ;HL=rdbuf is target
	ld bc,00080h        ;BC=128 Bytesc
	jr nc,lfa61h        ;First of second half? (DE mod 2)
	add hl,bc           ; SECOND: Add the size of one half

lfa61h:
	ex de,hl	
	ld hl,(00aeeh)      ;Get source address
	ldir                ;Copy BC bytes from (HL) to (DE)
	
	pop bc	
	pop de	
	pop af	
	ld hl,rdbuf
	call corv_writ_sec  ;Write a sector (256 bytes)

	pop bc	
	pop de	
	pop hl	
	ret
	
sub_fa74h:
;Read an absolute sector from Corvus hard drive into wrtbuf
;
;(phydrv) = Curvus device number
;(usrsrt) = Absolute sector number
;
	ld a,(phydrv)
	ld b,a              ;B=Corvus drive number	
	ld de,(usrsrt)
	ld a,(usrsrt+2)     ;ADE=usrsrt
	ld hl,wrtbuf
	jp corv_read_sec    ;Reads a sector (256 bytes)

lfa85h:
;Write an absolute sector to Corvus hard drive from wrtbuf
;
;(phydrv) = Curvus device number
;(usrsrt) = Absolute sector number
;
	ld a,(phydrv)
	ld b,a              ;B=Corvus drive number	
	ld de,(usrsrt)
	ld a,(usrsrt+2)     ;ADE=usrsrt
	ld hl,wrtbuf
	jp corv_writ_sec    ;Write a sector (256 bytes)

read_bam:
;Read a BAM sector from Corvus hard drive to bambuf
;
;(phydrv) = Curvus device number
;(bamsrt) = BAM start sector
;(bamsec) = BAM Sector
;
	call sub_faa2h
	jp corv_read_sec    ;Reads a sector (256 bytes)

write_bam:
;Write a BAM sector to Corvus hard drive from bambuf
;
;(phydrv) = Curvus device number
;(bamsrt) = BAM start sector
;(bamsec) = BAM Sector
;
	call sub_faa2h
	jp corv_writ_sec    ;Write a sector (256 bytes)

sub_faa2h:
	ld de,(bamsec)
	ld d,000h           ;D=(bamsec)
	ld hl,(bamsrt)
	ld a,(bamsrt+2)     ;AHL=(bamsrt)
	add hl,de	
	adc a,000h
	ex de,hl            ;ADE=AHL+D

	ld hl,phydrv
	ld b,(hl)           ;B=Corvus drive number

	ld hl,bambuf        ;HL=Address of BAM buffer
	ret
	
chk_wrt_rights:
	ld a,(l000ah)
	or a	
	ret z	
	ld a,(userid)
	or a	
	ret z	
	ld a,error_92       ;"PRIVILEGED COMMAND"
	jp error

corv_init:
;Initialize the Corvus hard drive controller
;
	ld a,0ffh           ;0ffh = byte that is an invalid command 
	out (corvus),a      ;Send it to the controller

	ld b,0ffh
lfacfh:
	djnz lfacfh         ;Delay loop

	in a,(ppi2_pc)
	and 20h
	jr nz,corv_init     ;Loop until Corvus DIRC=low
	call corv_wait_read ;Wait until Corvus READY=high, then read byte 

	cp 8fh              ;Response should be 8fh (Illegal Command) 
	jr nz,corv_init     ;Loop until the expected response is received

	xor a               ;A=0	
	call corv_put_byte  ;Send command byte (00h = Reset Drive)

	call corv_read_err
	bit 7,a
	ret

sub_fae8h:
	call corv_read_err
	push af	
	ld hl,rdbuf
	ld bc,00000h

lfaf2h:
	in a,(ppi2_pc)
	and 010h
	jr z,lfaf2h         ;Wait until Corvus READY=high

	in a,(ppi2_pc)
	and 020h            ;Corvus DIRC
	jr nz,lfb09h

	ld a,b	
	or a	
	in a,(corvus)       ;Read data byte from Corvus 
	inc bc	
	jr nz,lfaf2h
	ld (hl),a           ;Store it in the buffer 	
	inc hl              ;Increment to next position in DMA buffer 	
	jr lfaf2h
lfb09h:
	pop af	
	ret	

corv_read_sec:
;Reads a sector (256 bytes) from the Corvus hard drive
;
;  B = Drive number
;ADE = Sector address (20 bit address)
; HL = DMA buffer address
;
	ld (0260ah),bc
	ld c,02h            ;02h = Read a sector (256 byte sector)
	call corv_send_cmd
	call corv_read_err
	jr nz,read_err

	ld bc,corvus        ;B=0 (counts 256)
                        ;C=corvus (io port)

lfb1ch:
	in a,(ppi2_pc)
	and 010h
	jr z,lfb1ch         ;Wait until Corvus READY=high

	ini                 ;Reads from io port (C) to (HL), B is decremented
	jr nz,lfb1ch
	ret

read_err:
	and 01fh
	ld (errtrk),a       ;Store error code as error track
	ld a,(0260ah+1)
	ld (errsec),a       ;Store drive number as error sector
	ld a,error_22       ;"READ ERROR"
	jp error_out

corv_writ_sec:
;Write a sector (256 bytes) to the Corvus hard drive
;
;  B = Drive Number
;ADE = Sector address (20 bit address)
; HL = DMA buffer address
;
	ld (0260ah),bc
	ld c,03h            ;03h = Write a sector (256 byte sector)
	call corv_send_cmd

	ld bc,corvus        ;B=0 (counts 256)
                        ;C=corvus (io port)

lfb43h:
	in a,(ppi2_pc)
	and 010h
	jr z,lfb43h         ;Wait until Corvus READY=high

	outi                ;Reads from (HL) to io port (C), B is decremented
	jr nz,lfb43h
	call corv_read_err
	ret z
	
	and 01fh
	ld (errtrk),a       ;Store error code as error track
	ld a,(0260ah+1)
	ld (errsec),a       ;Store drive Number as error sector
	ld a,error_25       ;"WRITE ERROR"
	jp error_out

corv_read_err:
;Read the error code from a Corvus hard drive.
;
;Returns the error code in A (0=OK) and also changes
;the Z flag: Z=1 if OK, Z=0 if error.
;
;The upper 3 bits of the error code are flags:
;
;  Bit 7: Set if any fatal error has occurred.  Most utility programs
;         from Corvus will not show the error unless bit 7 is set.
;
;  Bit 6: Set if an error occurred on a re-read (verification)
;         following a disk write.
;
;  Bit 5: Set if there was a recoverable error (as in a retry
;         of a read or write).
;
;The lower 5 bits of the error code are reserved for the code itself
;but only the lower 4 bits are actually used:
;
;  00 Disk Header Fault         10 Drive Not Acknowledged
;  01 Seek Timeout              11 Acknowledge Stuck Active
;  02 Seek Fault                12 Timeout
;  03 Seek Error                13 Fault
;  04 Header CRC Error          14 CRC
;  05 Re-zero (Head) Fault      15 Seek
;  06 Re-zero Timeout           16 Verification
;  07 Drive Not On Line         17 Drive Speed Error
;  08 Write Fault               18 Drive Illegal Address Error
;  09 (Unused)                  19 Drive R/W Fault Error
;  0A Read Data Fault           1A Drive Servo Error
;  0B Data CRC Error            1B Drive Guard Band
;  0C Sector Locate Error       1C Drive PLO (Phase Lockout) Error
;  0D Write Protected           1D Drive R/W Unsafe
;  0E Illegal Sector Address    1E (Unused)
;  0F Illegal Command           1F (Unused)
;
	in a,(ppi2_pc)
	xor 010h
	and 030h
	jr nz,corv_read_err

	ld b,019h
lfb6bh:
	djnz lfb6bh         ;Delay loop

	in a,(ppi2_pc)
	xor 010h
	and 030h
	jr nz,corv_read_err
                        ;Fall through into corv_wait_read 

corv_wait_read:
;Wait until Corvus READY=high, then a data byte from Corvus.
;
;Returns the data byte in A and sets the Z flag: Z=1 if OK, Z=0 if error.
;
	in a,(ppi2_pc)
	and 10h             ;Mask off all but bit 4 (Corvus READY) 
	jr z,corv_wait_read
	in a,(corvus)
	bit 7,a             ;Bit 7 of Corvus error byte is set if fatal error
                        ;Z = opposite of bit 7 (Z=1 if OK, Z=0 if error) 
	ret

corv_send_cmd:
;Send the command to Corvus hard drive
;
;  C = Command
;        02h = Read a sector (256 byte sector)
;        03h = Write a sector (256 byte sector)
;  B = Drive Number (0-15)
;ADE = Sector address (20 bit address)
;
	add a,a	
	add a,a	
	add a,a	
	add a,a	
	add a,b             ;A=A*16 + B	
	push af	
	ld a,c	
	call corv_put_byte  ;Send command byte (C)
	pop af	
	call corv_put_byte  ;Send A*16 + B (DADR byte 0) 
	ld a,e	
	call corv_put_byte  ;Send E (DADR byte 1) 
	ld a,d
                        ;Send D (DADR byte 2) 
                        ;Fall through into corv_put_byte

corv_put_byte:
;Send a byte to the Corvus hard drive.  Waits until the Corvus
;is ready to accept the byte, sends it, then returns immediately.
;
;A = byte to send
; 
	push af	
lfb94h:
	in a,(ppi2_pc)
	and 10h
	jr z,lfb94h         ;Wait until Corvus READY=high 
	pop af	
	out (corvus),a      ;Put byte on Corvus data bus 
	ret

corv_park_heads:
;Park the heads from corvus hard drive
;
;A = Drive number
;
	push af	
	ld hl,buffer13
	ld bc,00200h
	call calc_checksum
	cp 084h
	ld a,error_49
	jp nz,error

	ld a,011h
	call corv_put_byte  ;Send first command byte (11h = Park Heads)
	pop af	
	call corv_put_byte  ;Send second command byte (drive number for Get drive parameter - starts at 1)
	ld hl,buffer13
	ld bc,0200h         ;Send 512 Bytes
	call corv_put_str
	jp corv_read_err

corv_put_str:
;Send a string to the Corvus hard drive.
;
;HL = buffer of string
;BC = count of bytes to send
;
	ld a,(hl)           ;Get the byte
	inc hl	
	call corv_put_byte  ;Send the byte
	dec bc              ;Decrement the counter
	ld a,c	
	or b	
	jr nz,corv_put_str  ;If not zero, loop
	ret
	
hl_shr_b:
;Shift B times HL right, so HL is divided by 2^B
;
	srl h
	rr l
	djnz hl_shr_b
	ret
	
error_txt:
	db error_00         ;"OK"
	db " O","K"+80h

    db error_01         ;"FILES SCRATCHED"
	db t_file, "S SCRATCHE","D"+80h

	db error_22         ;"READ ERROR"
	db t_read,t_error+80h

	db error_25         ;"WRITE ERROR"
	db t_write,t_error+80h

	db error_26         ;"WRITE PROTECED"
	db t_write," PROTECTE","D"+80h

	db error_30         ;"SYNTAX ERROR"
	db t_syntax,t_error+80h

	db error_31         ;"SYNTAX ERROR (INVALID COMMAND)"
	db t_syntax,t_error," (",t_invalid," ",t_command,")"+80h

	db error_32         ;"SYNTAX ERROR (LONG LINE)"
	db t_syntax,t_error," (LONG LINE",")"+80h

	db error_33         ;"SYNTAX ERROR(INVALID FILENAME)"
	db t_syntax,t_error,"(",t_invalid," ",t_file,t_name,")"+80h

	db error_34         ;"SYNTAX ERROR(NO FILENAME)"
	db t_syntax,t_error,"(NO ",t_file,t_name,")"+80h

	db error_50         ;"RECORD NOT PRESENT"
	db t_record,t_not," PRESEN","T"+80h

	db error_51         ;"OVERFLOW IN RECORD"
	db "OVERFLOW IN ",t_record+80h

	db error_52         ;"FILE TOO LARGE"
	db t_file," TOO LARG","E"+80h

	db error_60         ;"WRITE FILE OPEN"
	db t_write," ",t_file,t_open+80h

	db error_61         ;"FILE NOT OPEN"
	db t_file,t_not,t_open+80h

	db error_62         ;"FILE NOT FOUND"
	db t_file,t_not," FOUN","D"+80h

	db error_63         ;"FILE EXISTS"
	db t_file," EXIST","S"+80h

	db error_64         ;"FILE TYPE MISMATCH"
	db t_file," TYPE MISMATC","H"+80h

	db error_65         ;"NO BLOCK"
	db "NO BLOC","K"+80h

	db error_66         ;"ILLEGAL TRACK OR SECTOR"
	db "ILLEGAL TRACK OR SECTO","R"+80h

	db error_72         ;"DISK FULL"
	db "DISK FUL","L"+80h

    db error_84         ;"DRIVE NOT CONFIGURED"
	db t_drive,t_not," CONFIGURE","D"+80h

	db error_89         ;"USER #"
	db t_user," ","#"+80h

	db error_90         ;"INVALID USER NAME"
	db t_invalid," ",t_user," ",t_name+80h

	db error_91         ;"PASSWORD INCORRECT"
	db "PASSWORD INCORREC","T"+80h

	db error_92         ;"PRIVILEGED COMMAND"
	db "PRIVILEGED ",t_command+80h

	db error_93         ;"BAD SECTORS CORRECTED" (unused!)
	db "BAD SECTORS CORRECTE","D"+80h

	db error_94         ;"LOCK ALREADY IN USE"
	db "LOCK ALREADY IN US","E"+80h

	db error_95         ;"SUNOL DRIVE ERROR"
	db t_sunol,t_drive,t_error+80h

	db error_96         ;"SUNOL DRIVE SIZE"
	db t_sunol,t_drive," SIZ","E"+80h

	db error_98         ;"VERSION #"
	db t_version+80h

	db error_99         ;"SMALL SYSTEMS HARDBOXVERSION #"
	db "SMALL SYSTEMS HARDBOX",t_version+80h

	db 0ffh             ;"UNKNWON ERROR CODE"
	db "UNKNOWN",t_error," COD","E"+80h

error_tok:
	db "FIL","E"+80h       ;01h: "FILE"
	db "WRIT","E"+80h      ;02h: "WRITE"
	db " ERRO","R"+80h     ;03h: " ERROR"
	db "SYNTA","X"+80h     ;04h: "SYNTAX"
	db "INVALI","D"+80h    ;05h: "INVALID"
	db "COMMAN","D"+80h    ;06h: "COMMAND"
	db "REA","D"+80h       ;07h: "READ"
	db "NAM","E"+80h       ;08h: "NAME"
	db "RECOR","D"+80h     ;09h: "RECORD"
	db " OPE","N"+80h      ;0ah: " OPEN"
	db " NO","T"+80h       ;0bh: " NOT"
	db "USE","R"+80h       ;0ch: "USER"
	db " VERSION ","#"+80h ;0dh: " VERSION #"
	db " DRIV","E"+80h     ;0eh: " DRIVE"
	db "SUNO","L"+80h      ;0fh: "SUNOL"

filler:
	jp nz,02383h
	ret	
	call 005eeh
	call 005dah
	ex de,hl	
	call 00607h
	ld a,d	
	or e	
	ret z	
	ld a,(hl)	
	inc hl	
	call 023a4h
	inc de	
	jp 02398h
	push de	
	push hl	
	push af	
	ld hl,01e46h
	ld a,(01f1ah)
	ld e,a	
	ld d,000h
	add hl,de	
	pop af	
	ld (hl),a	
	ld a,e	
	inc a	
	call m,023beh
	ld (01f1ah),a
	pop hl	
	pop de	
	ret	
	push bc	
	ld de,01eebh
	ld c,015h
	call 00005h
	or a	
	jp nz,0240ch
	pop bc	
	xor a
	ret	
	call 005d1h
	ld (023f4h),hl
	push hl	
	push bc	
	ld a,c	
	xor 002h
	ld c,a	
	call 005f7h
	pop bc	
	pop de	
	call 00607h
	ex de,hl	
	inc hl	
	ld (023f7h),hl
	ld de,0ffe7h
	ld hl,023f3h
	call 02398h
	jp 0236ah
	ld hl,00000h
	ld bc,00000h
	ld de,0011ch
	add hl,bc	
	ex de,hl	
	add hl,bc	
	inc bc	
	ld a,(hl)	
	ex de,hl	
	ld (hl),a	
	ex de,hl	
	dec hl	
	dec de	
	dec bc	
	ld a,b	
	or c	
	jp nz,0010dh
	ld hl,02412h
	jp 001d0h

	db "?Can't save object file", 0

	call 005f7h
	ex de,hl	
	call 005d1h
	ex de,hl	
	push de	
	call 00607h
	ld a,e	
	or d	
	pop hl	
	ret z	
	push bc	
	push hl	
	push de	
	call 005eeh
	ex de,hl	
	pop de	
	ld a,e	
	sub 020h
	ld e,a	
	ld a,d	
	sbc a,000h
	ld d,a	
	jp c,02452h
	ld a,020h
	jp 02458h
	ld a,e	
	add a,020h
	ld de,00000h
	or a	
	jp nz,0245fh
	pop bc	
	pop bc	
	ret	
	ld c,a	
	ld b,000h
	ld a,03ah
	call 023a4h
	ld a,c	
	call 00daeh
	ex (sp),hl	
	push de	
	call 00da9h
	ld d,000h
	ld e,c	
	add hl,de	
	pop de	
	ex (sp),hl	
	xor a
	call 00daeh
	ld a,(hl)	
	inc hl	
	call 00daeh
	dec c	
	jp nz,0247ah
	xor a
	sub b	
	call 00daeh
	call 00dc5h
	jp 02442h
	ld a,03ah
	call 023a4h
	xor a
	ld b,a	
	call 00daeh
	ld hl,(01db2h)
	call 00da9h
	ld a,001h
	call 00daeh
	xor a
	sub b	
	call 00daeh
	call 00dc5h
	ld a,01ah
	jp 023a4h
	push hl	
	inc de	
	ld hl,02541h
	call 025b5h
	ld hl,02547h
	call 025b5h
	ld hl,0254ah
	call 025b5h
	ld hl,02550h
	ld b,006h
	call 025b5h
	inc hl	
	inc hl	
	dec b	
	jp nz,024c9h
	inc hl	
	inc hl	
	ld b,003h
	call 025b5h
	inc hl	
	inc hl	
	dec b	
	jp nz,024d6h
	inc hl	
	call 025b5h
	ld hl,02591h
	call 025b5h
	ld hl,0259ch
	call 025b5h
	push de	
	ld hl,(01f24h)
	ld (025a0h),hl
	ex de,hl	
	ld hl,(01f1ch)
	call 00607h
	ex de,hl	
	ld (0259eh),hl
	ld hl,(01f3eh)
	ld (025a2h),hl
	ld hl,(01f26h)
	ld (025a6h),hl
	ex de,hl	
	ld hl,(01f1eh)
	call 00607h
	ex de,hl	
	ld (025a4h),hl
	ld hl,(01f40h)
	ld (025a8h),hl
	pop de	
	pop hl	
	pop bc	
	ld sp,hl	
	push bc	
	ex de,hl	
	ld de,0253dh
	ld bc,0006dh
	jp 0253dh
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	call 025aah
	jp 02543h
	ld bc,00000h
	call 0256dh
	jp c,0255eh
	ld bc,00006h
	call 0256dh
	call nc,02583h
	call c,02593h
	call 0256dh
	jp 02583h
	call 02593h
	ld c,006h
	call 0256dh
	call nc,02583h
	call c,02593h
	ret	
	ld hl,0259eh
	add hl,bc	
	ld c,(hl)	
	inc hl	
	ld b,(hl)	
	inc hl	
	ld e,(hl)	
	inc hl	
	ld d,(hl)	
	inc hl	
	ld a,(hl)	
	inc hl	
	ld h,(hl)	
	ld l,a	
	ld a,h	
	sub d	
	ret nz	
	ld a,l	
	sub e	
	ret	
	add hl,bc	
	ex de,hl	
	add hl,bc	
	dec hl	
	dec de	
	ld a,b	
	or c	
	ret z	
	ld a,(hl)	
	ld (de),a	
	dec hl	
	dec de	
	dec bc	
	jp 02588h
	ld a,b	
	or c	
	ret z	
	ld a,(de)	
	ld (hl),a	
	inc de	
	inc hl	
	dec bc	
	jp 02593h
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	ld a,b	
	or c	
	ret z	
	ld a,(de)	
	ld (hl),a	
	inc de	
	inc hl	
	dec bc	
	jp 025aah
	push bc	
	push hl	
	push de	
	ld a,(hl)	
	inc hl	
	ld h,(hl)	
	ld l,a	
	ld de,0253dh
	call 00607h
	ex de,hl	
	pop de	
	add hl,de	
	push hl	
	pop bc	
	pop hl	
	ld (hl),c	
	inc hl	
	ld (hl),b	
	pop bc	
	ret	
	ld a,(02659h)
	or a	
	ret z	
	push hl	
	pop de	
	ld hl,(01f28h)
	call 00d32h
	ret z	
	ex de,hl	
	ld a,(hl)	
	and 007h
	cp 003h
	ld bc,025d3h
	push bc	
	push hl	
	jp z,0186ah
	call 018afh
	pop hl	
	ex (sp),hl	
	jp (hl)	
	call 02632h
	ld a,(01dach)
	ld (02658h),a
	ld hl,(01d9dh)
	ld (01f1ch),hl
	xor a

checksum:
	db 32h
