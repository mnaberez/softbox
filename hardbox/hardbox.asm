;HardBox Firmware
;Version 2.3 and 2.4 (Corvus)
;Version 2.4 (Mini-Winchester 2.91)
;Version 3.1 (Sunol)

;version:  equ 23        ;for version 2.3 (Corvus)
;version:  equ 24        ;for version 2.4 (Corvus)
;version:  equ 291       ;for version 2.4 (Mini-Winchester 2.91)
;version:  equ 31        ;for version 3.1 (Sunol)

IF version = 291
;This is a disassembly of the HardBox code payload inside mwdos291.com.

;MW-1000 Memory Map:
;  F000-FFFF  ROM                   4096
;  0000-EFFF  RAM (IC24-IC31)      61440 (Must be 4164)
ELSE
;This is a disassembly of two original 2732 EPROMs from a HardBox,
;labeled "295" (IC3) and "296" (IC4) for version 2.3 and 3.1 and
;labeled "289" (IC3) and "290" (IC4) for version 2.4.

;HardBox Memory Map:
;  F000-FFFF  ROM High (IC4)        4096
;  E000-EFFF  ROM Low (IC3)         4096
;  C000-DFFF  Mirror of 0000-1FFF   8192
;  8000-BFFF  Mirror of 0000-3FFF  16384
;  4000-7FFF  Mirror of 0000-3FFF  16384
;  0000-3FFF  RAM (IC24-IC31)      16384 (Uses 4516 DRAMs instead of 4164)
ENDIF

ppi1:     equ 10h       ;8255 PPI #1 (IC17)
ppi1_pa:  equ ppi1+0    ;  Port A: IEEE-488 Data In
ppi1_pb:  equ ppi1+1    ;  Port B: IEEE-488 Data Out
ppi1_pc:  equ ppi1+2    ;  Port C: DIP Switches
ppi1_cr:  equ ppi1+3    ;  Control Register

ppi2:     equ 14h       ;8255 PPI #2 (IC16)
ppi2_pa:  equ ppi2+0    ;  Port A:
                        ;    PA7 IEEE-488 IFC in (unused)
                        ;    PA6 IEEE-488 REN in (unused)
                        ;    PA5 IEEE-488 SRQ in (unused)
                        ;    PA4 IEEE-488 EOI in
                        ;    PA3 IEEE-488 NRFD in
                        ;    PA2 IEEE-488 NDAC in
                        ;    PA1 IEEE-488 DAV in
                        ;    PA0 IEEE-488 ATN in
ppi2_pb:  equ ppi2+1    ;  Port B:
                        ;    PB7 IEEE-488 ATNA out (because LK3 is open)
                        ;    PB6 IEEE-488 REN out (unused)
                        ;    PB5 IEEE-488 SRQ out (unused)
                        ;    PB4 IEEE-488 EOI out
                        ;    PB3 IEEE-488 NRFD out
                        ;    PB2 IEEE-488 NDAC out
                        ;    PB1 IEEE-488 DAV out
                        ;    PB0 IEEE-488 ATN out (unused)
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

atna:     equ 10000000b ;ATNA (With installed IC37 this isn't IFC, leave LK3 open!)
ren:      equ 01000000b ;REN (unused)
srq:      equ 00100000b ;SRQ (unused)
eoi:      equ 00010000b ;EOI
nrfd:     equ 00001000b ;NRFD
ndac:     equ 00000100b ;NDAC
dav:      equ 00000010b ;DAV
atn:      equ 00000001b ;ATN

IF version != 291
dirc:     equ 00100000b ;Corvus DIRC
ready:    equ 00010000b ;Corvus READY
ledrdy:   equ 00000100b ;LED "Ready"
ledb:     equ 00000010b ;LED "B"
leda:     equ 00000001b ;LED "A"
ENDIF

corvus:   equ 18h       ;Corvus data bus

cr:       equ 0dh       ;Carriage Return
rvs:      equ 12h       ;Reverse on

error_00: equ 00h       ;"OK"
error_01: equ 01h       ;"FILES SCRATED"
error_22: equ 16h       ;"READ ERROR"
error_25: equ 19h       ;"WRITE ERROR"
error_26: equ 1ah       ;"WRITE PROTECTED"
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
error_84: equ 54h       ;" DRIVE NOT CONFIGURED"
error_89: equ 59h       ;"USER #"
error_90: equ 5ah       ;"INVALID USER NAME"
error_91: equ 5bh       ;"PASSWORD INCORRECT"
error_92: equ 5ch       ;"PRIVILEGED COMMAND"
IF version != 291
error_93: equ 5dh       ;"BAD SECTORS CORRECTED" (only used in version 2.3 and 2.4)
error_94: equ 5eh       ;"LOCK ALREADY IN USE"
IF version = 31         ;This is for a SUNOL Hard Drive
error_95: equ 5fh       ;  "SUNOL DRIVE ERROR"
error_96: equ 60h       ;  "SUNOL DRIVE SIZE"
error_98: equ 62h       ;  "VERSION #"
ELSE                    ;This is for a CORVUS Hard Drive
error_95: equ 5fh       ;  "CORVUSDRIVE ERROR"
error_96: equ 60h       ;  "CORVUSDRIVE SIZE"
error_97: equ 61h       ;  "CORVUS REV A VERSION #"
error_98: equ 62h       ;  "CORVUS REV B VERSION #"
ENDIF
ENDIF
error_99: equ 63h       ;"SMALL SYSTEMS HARDBOX VERSION #"

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
IF version = 31         ;This is for a SUNOL Hard Drive
t_drive:  equ 0eh       ;  " DRIVE"
t_sunol:  equ 0fh       ;  "SUNOL"
ELSE                    ;This is for a CORVUS Hard Drive
t_drive:  equ 0eh       ;  "DRIVE"
t_corvus: equ 0fh       ;  "CORVUS"
ENDIF

IF version = 291
devnum:   equ 2000h     ;Read from header or set via command "!D" (8 .. 15)
userid:   equ 2002h     ;Is constantly 0 (0 .. 63)
ELSE
                        ;DIP Switch
                        ;==========
                        ;Switch SW1 SW2 SW3 SW4 SW5 SW6 SW7 SW8
                        ;       <------userid-----> <-devnum-->
                        ;Pin     14  15  16  17  13  12  11  10
                        ;Port   PC0 PC4 PC5 PC6 PC7 PC3 PC2 PC1

devnum:   equ 0000h     ;Read via DIP switch or set via command "!D" (8 .. 15)
userid:   equ 0002h     ;Read via DIP switch (0 .. 31) or set via command "L" (0 .. 63)
ENDIF

                        ;Disk layout on Drive Number 1
                        ;=============================
                        ;Absolute Sector  0 Bytes   0 ..  15: User name (16 Characters) for User Number =  0
                        ;Absolute Sector  0 Bytes  16 ..  31: User name (16 Characters) for User Number =  1
                        ;Absolute Sector  0 Bytes  32 ..  47: User name (16 Characters) for User Number =  2
                        ;Absolute Sector  0 Bytes  48 ..  63: User name (16 Characters) for User Number =  3
                        ;Absolute Sector  0 Bytes  64 ..  79: User name (16 Characters) for User Number =  4
                        ;Absolute Sector  0 Bytes  80 ..  95: User name (16 Characters) for User Number =  5
                        ;Absolute Sector  0 Bytes  96 .. 111: User name (16 Characters) for User Number =  6
                        ;Absolute Sector  0 Bytes 112 .. 127: User name (16 Characters) for User Number =  7
                        ;Absolute Sector  0 Bytes 128 .. 143: User name (16 Characters) for User Number =  8
                        ;Absolute Sector  0 Bytes 144 .. 159: User name (16 Characters) for User Number =  9
                        ;Absolute Sector  0 Bytes 160 .. 175: User name (16 Characters) for User Number = 10
                        ;Absolute Sector  0 Bytes 176 .. 191: User name (16 Characters) for User Number = 11
                        ;Absolute Sector  0 Bytes 192 .. 207: User name (16 Characters) for User Number = 12
                        ;Absolute Sector  0 Bytes 208 .. 223: User name (16 Characters) for User Number = 13
                        ;Absolute Sector  0 Bytes 224 .. 239: User name (16 Characters) for User Number = 14
                        ;Absolute Sector  0 Bytes 240 .. 255: User name (16 Characters) for User Number = 15
                        ;Absolute Sector  1: Same as Sector 0 for User Number 16 .. 31
                        ;Absolute Sector  2: Same as Sector 0 for User Number 32 .. 47
                        ;Absolute Sector  3: Same as Sector 0 for User Number 48 .. 63

                        ;Absolute Sector  4 Bytes   0 ..  31: User parameter (32 Bytes, see below) for User Number =  0
                        ;Absolute Sector  4 Bytes  32 ..  63: User parameter (32 Bytes, see below) for User Number =  1
                        ;Absolute Sector  4 Bytes  64 ..  95: User parameter (32 Bytes, see below) for User Number =  2
                        ;Absolute Sector  4 Bytes  96 .. 127: User parameter (32 Bytes, see below) for User Number =  3
                        ;Absolute Sector  4 Bytes 128 .. 159: User parameter (32 Bytes, see below) for User Number =  4
                        ;Absolute Sector  4 Bytes 160 .. 191: User parameter (32 Bytes, see below) for User Number =  5
                        ;Absolute Sector  4 Bytes 192 .. 223: User parameter (32 Bytes, see below) for User Number =  6
                        ;Absolute Sector  4 Bytes 224 .. 255: User parameter (32 Bytes, see below) for User Number =  7
                        ;Absolute Sector  5: Same as Sector 4 for User Number  8 .. 15
                        ;Absolute Sector  6: Same as Sector 4 for User Number 16 .. 23
                        ;Absolute Sector  7: Same as Sector 4 for User Number 24 .. 31
                        ;Absolute Sector  8: Same as Sector 4 for User Number 32 .. 39
                        ;Absolute Sector  9: Same as Sector 4 for User Number 40 .. 47
                        ;Absolute Sector 10: Same as Sector 4 for User Number 48 .. 55
                        ;Absolute Sector 11: Same as Sector 4 for User Number 56 .. 63

                        ;Absolute Sector 12 Bytes   0 ..  15: User password (16 Characters) for User Number =  0
                        ;Absolute Sector 12 Bytes  16 ..  31: User password (16 Characters) for User Number =  1
                        ;Absolute Sector 12 Bytes  32 ..  47: User password (16 Characters) for User Number =  2
                        ;Absolute Sector 12 Bytes  48 ..  63: User password (16 Characters) for User Number =  3
                        ;Absolute Sector 12 Bytes  64 ..  79: User password (16 Characters) for User Number =  4
                        ;Absolute Sector 12 Bytes  80 ..  95: User password (16 Characters) for User Number =  5
                        ;Absolute Sector 12 Bytes  96 .. 111: User password (16 Characters) for User Number =  6
                        ;Absolute Sector 12 Bytes 112 .. 127: User password (16 Characters) for User Number =  7
                        ;Absolute Sector 12 Bytes 128 .. 143: User password (16 Characters) for User Number =  8
                        ;Absolute Sector 12 Bytes 144 .. 159: User password (16 Characters) for User Number =  9
                        ;Absolute Sector 12 Bytes 160 .. 175: User password (16 Characters) for User Number = 10
                        ;Absolute Sector 12 Bytes 176 .. 191: User password (16 Characters) for User Number = 11
                        ;Absolute Sector 12 Bytes 192 .. 207: User password (16 Characters) for User Number = 12
                        ;Absolute Sector 12 Bytes 208 .. 223: User password (16 Characters) for User Number = 13
                        ;Absolute Sector 12 Bytes 224 .. 239: User password (16 Characters) for User Number = 14
                        ;Absolute Sector 12 Bytes 240 .. 255: User password (16 Characters) for User Number = 15
                        ;Absolute Sector 13: Same as Sector 12 for User Number 16 .. 31
                        ;Absolute Sector 14: Same as Sector 12 for User Number 32 .. 47
                        ;Absolute Sector 15: Same as Sector 12 for User Number 48 .. 63

                        ;Absolute Sector 16 Byte          0: <Unknown or Undefined> (1 ???)
                        ;Absolute Sector 16 Byte          1: <Unknown or Undefined> (20 ??? for 20mb???)
                        ;Absolute Sector 16 Bytes  2 ..   7: <Unknown or Undefined>
                        ;Absolute Sector 16 Bytes  8 ..   9: "HB" as Magic Characters for "HardBox"
                        ;Absolute Sector 16 Bytes 10 .. 255: <Unknown or Undefined>

IF version = 291
                        ;Absolute Sector 32 to 63: Firmware for Hardbox (see payload from mwdos291.com)
ENDIF

                        ;User Parameter
                        ;==============
                        ;Byte         0: Physical Drive Number (1 .. 4 = Drive Number, 0 = Unused Entry)
                        ;Bytes  1 ..  3: Starting Sector Number on Disk
                        ;Bytes  4 ..  5: User Area Size in Kilobytes (1 Kilobyte are 4 Sectors or Blocks)
                        ;Byte         6: Type of User Area (Single User or 0aah for Multi User)
                        ;Bytes  7 ..  8: Maximum Numbers of Files allowed (Reserved for Directory Entries)
                        ;Bytes  9 .. 10: Size (in Kilobytes) allocated for Direct Access (1 Kilobyte are 4 Sectors or Blocks)
                        ;Bytes 11 .. 12: Number of "Tracks per Drive" for Direct Access
                        ;Bytes 13 .. 15: Number of "Sectors per Track" for Direct Access
                        ;Bytes 16 .. 31: User Area Name (16 Characters)

IF version = 291
usrdat:   equ 2004h     ;usrdat (32 Bytes) are copied from header (offset 0103h to 0122h)
ELSE
usrdat:   equ 0004h     ;usrdat (32 Bytes) are copied from sectors 4, 5, 6, 7, 8, 9, 10 or 12) depends on userid
ENDIF
phydrv:   equ usrdat+ 0 ;Physical drive number (1 .. 4, 1 Byte)
usrsrt:   equ usrdat+ 1 ;Starting sector number on drive (An Absolute Sector Number, 3 Bytes)
usrsiz:   equ usrdat+ 4 ;User area size in kilobytes, there are 4 blocks (2 Bytes, Maximum is 64 Megabytes)
l000ah:   equ usrdat+ 6 ;Type of user area (Single user or Multi-user) (1 Byte) (Disallow write)
maxdir:   equ usrdat+ 7 ;Maximum numbers of files allowed (2 Bytes, Maximum is 65535)
usrdir:   equ usrdat+ 9 ;Size (in kilobyte) allocated for direct access, these are 4 blocks (2 Bytes, Maximum is 64 Megabytes)
maxtrk:   equ usrdat+11 ;# of "tracks per drive" for direct access (2 Bytes)
maxsec:   equ usrdat+13 ;# of "sectors per track" for direct access (3 Bytes)
arenam:   equ usrdat+16 ;User area name (16 Bytes) ???

                        ;Every sector contain 256 bytes and is accessed via the commands
                        ; - 02h = Read a sector (256 byte sector) and
                        ; - 03h = Write a sector (256 byte sector).
                        ;These commands expected a absolute sector number (logical disk address - DADR) for the access.
                        ;This is a 3 byte address, but from the first byte only the upper nibble is for the address used.
                        ;The lower nibble represents the drive number. So the maximum address is 1048575. With a 256 byte
                        ;sector are 268435456 bytes (262144 kilobytes or 256 megabytes) addressable. The existing drives
                        ;have storages less than this value. The hardbox supports 6, 10 and 20 megabytes drives.

                        ;These storage space is partitioned into separated user areas. Each user ares is divided into
                        ;functional parts:
                        ; 1. Header sector
                        ;    This is one sector with 10 disk names and 10 disk ids. These names and ids can be defined by
                        ;    the dos commend new "N". A maximum of 10 virtual drive numbers are usable. After the header
                        ;    sector additional 3 sectors are reserved.
                        ; 2. Directory
                        ;    When a user area is defined, the number of allowed files must be specified. This number is
                        ;    used to calculate the size of the directory. For every file is a directory entry reseerved.
                        ;    A directory entry on disk need 32 bytes. So in one sector fits 8 directory entries.
                        ; 3. Allocation 1
                        ;    All data file sectors are linked with a side sector. The side sector are linked with a super
                        ;    side sector. For every directory entriy is space in the super side sectors reserved. Two
                        ;    directory entries use one super side sector, because for one directory entry only a maximum
                        ;    of 64 links (words with 2 bytes) to a side sector are needed. So every super side sector
                        ;    entry is 128 bytes.
                        ; 4. Allocation 2
                        ;    Every link in the super side sector points to a side sector. This is a real sector with 128
                        ;    links to data file sectors. Each link is a word (2 bytes), too. If a file is larger than 128
                        ;    clusters (262144 bytes) an additional side sector is needed. So the maximum size of 16777216
                        ;    bytes (16384 kilobytes or 16 megabytes) is possible.
                        ;    The DOS reserved for every file one side sector that is needed and an additional side sector
                        ;    for every 256 kilobyte user area size. So for 12.5% of all files exists enougth side sectors
                        ;    to create large files.
                        ; 5. Storage for files
                        ;    Every file is stored in a cluster that contains 8 real sectors with 256 bytes. (Remember the
                        ;    CBM DOS use only 254 bytes, because the first two bytes of a sector points to the next
                        ;    sector. So these two bytes are unusable for data.) Every data cluster has a cluster number
                        ;    as a word (2 bytes). This number is stored as link into the side sector. If the highest is
                        ;    set in the link, it's unused. So the maximum of 32768 sectors are addressable. In the memory
                        ;    BAM can only 1024 bytes with 8192 bits for 8192 clusters stored. So there are only 8192 used
                        ;    and the maximum capacity for all files are 16777216 bytes (16384 kilobytes or 16 megabytes).
                        ;    But this format is expandable up to 67108864 bytes (65536 kilobytes or 64 megabytes).
                        ;    When the user area is created, only the number of allowed files, the complete user ares size
                        ;    and the size allocated for direct access is defined. So the size available for files is
                        ;    calculated.
                        ; 6. Direct access sectors
                        ;    Additional to the storage for the files is a separated storage area for direct access
                        ;    possible. This area is also defined, when the user area is configured. The configured size
                        ;    is in kilobytes or in 4 sectors.
                        ; 7. BAM for direct access sectors
                        ;    For every direct access aector is a available bit needed. So we need a block available map.
                        ;    So for 2 kilobytes (8 sectors) we need a byte. Or with one BAM sector we can manage 2048
                        ;    direct access sectors (524288 bytes or 512 kilobytes).

                        ;Header Sector (The first Sector in a User Area)
                        ;===============================================
                        ;Bytes   0 ..  15: Drive Name for Drive Number 0 ("0:..")
                        ;Bytes  16 ..  31: Drive Name for Drive Number 1 ("1:..")
                        ;Bytes  32 ..  47: Drive Name for Drive Number 2 ("2:..")
                        ;Bytes  48 ..  63: Drive Name for Drive Number 3 ("3:..")
                        ;Bytes  64 ..  79: Drive Name for Drive Number 4 ("4:..")
                        ;Bytes  80 ..  95: Drive Name for Drive Number 5 ("5:..")
                        ;Bytes  96 .. 111: Drive Name for Drive Number 6 ("6:..")
                        ;Bytes 112 .. 127: Drive Name for Drive Number 7 ("7:..")
                        ;Bytes 128 .. 143: Drive Name for Drive Number 8 ("8:..")
                        ;Bytes 144 .. 159: Drive Name for Drive Number 9 ("9:..")
                        ;Bytes 160 .. 161: Drive ID for Drive Number 0 ("0:..")
                        ;Bytes 162 .. 163: Drive ID for Drive Number 1 ("1:..")
                        ;Bytes 164 .. 165: Drive ID for Drive Number 2 ("2:..")
                        ;Bytes 166 .. 167: Drive ID for Drive Number 3 ("3:..")
                        ;Bytes 168 .. 169: Drive ID for Drive Number 4 ("4:..")
                        ;Bytes 170 .. 171: Drive ID for Drive Number 5 ("5:..")
                        ;Bytes 172 .. 173: Drive ID for Drive Number 6 ("6:..")
                        ;Bytes 174 .. 175: Drive ID for Drive Number 7 ("7:..")
                        ;Bytes 176 .. 177: Drive ID for Drive Number 8 ("8:..")
                        ;Bytes 178 .. 179: Drive ID for Drive Number 9 ("9:..")
                        ;Bytes 180 .. 255: <Unknown or Undefined>

                        ;Directory Entry (32 Bytes for one File on Disk, additionaly 9 Bytes in Memory)
                        ;==============================================================================
f_attr:   equ 00h       ;Byte         0: File Attributes
                        ;                ---------------
                        ;                ------XX (Bits 0 .. 1): File Type
                        ;                                        ---------
                        ;                                        00: SEQ (Sequential file)
                        ;                                        01: USR (User file)
                        ;                                        10: PRG (Program file)
                        ;                                        11: REL (Relative file)
                        ;                ----XX-- (Bits 2 .. 3): <Unknown or Undefined>
                        ;                ---X---- (Bit       4): 1 = Global
                        ;                --X----- (Bit       5): 1 = Hidden
                        ;                -X------ (Bit       6): 1 = Write Protected
                        ;                X------- (Bit       7): 1 = Open File
f_drvn:   equ 01h       ;Byte         1: Drive Number
                        ;                  0 .. 9 = Drive Number
                        ;                    0e5h = End of Directory (Initialized Value)
                        ;                    0ffh = Unused Entry (Deleted Value)
f_name:   equ 02h       ;Bytes  2 .. 17: File Name (16 Characters)
f_size:   equ 12h       ;Bytes 18 .. 20: Size in Bytes (3 Bytes), 19 .. 20: Size in Blocks
f_rlen:   equ 15h       ;Byte        21: Record Length (1 Byte)
                        ;Bytes 22 .. 31: <Unknown or Undefined>
                        ;----- Now only temporary used data bytes, holded in memory only -----
f_cptr:   equ 20h       ;Bytes 32 .. 34: Current file pointer to read or write (3 Bytes)
f_dirn:   equ 23h       ;Bytes 35 .. 36: Number of Directory Entry - see dirnum also (2 Bytes)
                        ;Byte        37: ???
f_al1x:   equ 26h       ;Byte        38: Current Allocation 1 index number
                        ;Byte        39: ???
                        ;Byte        40: ???

typ_seq:  equ 0         ;File Type for SEQ (Sequential file)
typ_usr:  equ 1         ;File Type for USR (User file)
typ_prg:  equ 2         ;File Type for PRG (Program file)
typ_rel:  equ 3         ;File Type for REL (Relative file)

                        ;Every File has one Allocation Entry 1. This can have up to 64 Allocation Entries 2, because it
                        ;have a size from 128 bytes. The size from an Allocation Entry 2 is 256 bytes. So this can have
                        ;up to 128 sectors allocated for a file. The biggest size for a file is 8192 sectors or 2097152
                        ;bytes. The data sectors are numbered by a word (16 Bit). It can't be more than 65536 sector
                        ;exists. So the maximum of an user area to use for files is 16777216 bytes or 16384 kilobytes.

                        ;Allocation Entry 1 (128 Bytes for one File)
                        ;===========================================
                        ;Bytes 0 ..   1: (0 .. 32767 = Points to Allocation Entry 2, 32768 .. 65535 = Unused Entry)
                        ;Bytes 2 .. 127: Same as Bytes 0 .. 1

                        ;Allocation Entry 2 (256 Bytes for one Allocation Entry 1)
                        ;=========================================================
                        ;Bytes 0 ..   1: (0 .. 32767 = Points to Data Sector, 32768 .. 65535 = Unused Entry)
                        ;Bytes 2 .. 255: Same as Bytes 0 .. 1

IF version = 291
dirsrt:   equ 2024h     ;Absolute sector where directory starts (3 bytes, 4 sector after the user area starts)
al1srt:   equ 2027h     ;Absolute sector where allocation 1 (128 bytes) starts (3 bytes)
al1max:   equ 202ah     ;Maximum number of Files for Allocation 1 Sectors (2 bytes)
al2srt:   equ 202ch     ;Absolute sector where allocation 2 (256 bytes) starts (3 bytes)
al2max:   equ 202fh     ;(2 bytes)
filsrt:   equ 2031h     ;Absolute sector where the files starts (3 bytes)
l0034h:   equ 2034h     ;Size (in kilobytes) usable for normal files, these are 4 blocks (2 bytes)
l0036h:   equ 2036h     ;Starting sector number for direct access (3 bytes)
l0039h:   equ 2039h     ;(2 bytes)
bamsrt:   equ 203bh     ;Starting sector number where BAM for direct access starts (3 bytes)
usrnam:   equ 203eh     ;User name is copied from sector 0, 1, 2 or 3 depends on userid (16 bytes)
bamsec:   equ 204eh     ;BAM sector number currently in bambuf (1 byte)
defdnu:   equ 204fh     ;Default Drive number (0 .. 9) set via command "D"
errcod:   equ 2050h     ;Error code in error message
errtrk:   equ 2051h     ;Track number in error message (3 bytes)
errsec:   equ 2054h     ;Sector number in error message (3 bytes)

l0057h:   equ 2057h     ;BAM table for allocation 2 sectors (1 bit for 1 sector, 1024 bytes are 8192 bits or 8192 sectors)
l0457h:   equ 2457h     ;BAM table for data files (1 bit for 1 kilobyte, 1024 byte are 8192 bits or 8192 kilobyte) ???

entbufs:  equ 2857h     ;(16 Directory entry buffer with 41 bytes)
entbuf0:  equ entbufs+ 0*41;(Directory entry buffer for channel number  0 with 41 bytes)
entbuf1:  equ entbufs+ 1*41;(Directory entry buffer for channel number  1 with 41 bytes)
entbuf2:  equ entbufs+ 2*41;(Directory entry buffer for channel number  2 with 41 bytes)
entbuf3:  equ entbufs+ 3*41;(Directory entry buffer for channel number  3 with 41 bytes)
entbuf4:  equ entbufs+ 4*41;(Directory entry buffer for channel number  4 with 41 bytes)
entbuf5:  equ entbufs+ 5*41;(Directory entry buffer for channel number  5 with 41 bytes)
entbuf6:  equ entbufs+ 6*41;(Directory entry buffer for channel number  6 with 41 bytes)
entbuf7:  equ entbufs+ 7*41;(Directory entry buffer for channel number  7 with 41 bytes)
entbuf8:  equ entbufs+ 8*41;(Directory entry buffer for channel number  8 with 41 bytes)
entbuf9:  equ entbufs+ 9*41;(Directory entry buffer for channel number  9 with 41 bytes)
entbuf10: equ entbufs+10*41;(Directory entry buffer for channel number 10 with 41 bytes)
entbuf11: equ entbufs+11*41;(Directory entry buffer for channel number 11 with 41 bytes)
entbuf12: equ entbufs+12*41;(Directory entry buffer for channel number 12 with 41 bytes)
entbuf13: equ entbufs+13*41;(Directory entry buffer for channel number 13 with 41 bytes)
entbuf14: equ entbufs+14*41;(Directory entry buffer for channel number 14 with 41 bytes)
entbuf15: equ entbufs+15*41;(Directory entry buffer for channel number 15 with 41 bytes)

sa:       equ 2ae7h     ;Current channel number, comes with the secondary address (sa)
entptr:   equ 2ae8h     ;Pointer to a buffer (entbufs) of directory entry with 41 bytes (2 bytes)
al2ptr:   equ 2aeah     ;Pointer to a buffer (al2bufs) of a Allocation 2 sector with 256 bytes (2 bytes)
bufptr:   equ 2aech     ;Pointer to a buffer (buffers) of a sector buffer with 256 bytes (2 bytes)
al1ptr:   equ 2aeeh     ;Pointer to a buffer (al1bufs) of a Allocation 1 sector with 128 bytes (2 bytes)
lsntlk:   equ 2af0h     ;State of ieee bus (1 byte: bit 1 = TALK active, bit 2 = LISTEN active)
staptr:   equ 2af1h     ;Pointer to current position of stabuf when writing to control channel (2 bytes)
cmdptr:   equ 2af3h     ;Pointer to current position of cmdbuf when reading from control channel(2 bytes)

dirbuf:   equ 2af5h     ;Directory block buffer (256 bytes)
cmdbuf:   equ 2bf5h     ;Command buffer for writing to control channel 15 (128 bytes)
getbuf:   equ 2c75h     ;Buffer to read after SA or OPEN bytes, this stores commands (SA and OPEN) or filenames (OPEN) (128 bytes)
stabuf:   equ 2cf5h     ;Status buffer for reading from control channel 15 (80 Bytes)

filnam:   equ 2d45h     ;(17 bytes: 16 for the characters and one for end marker or delimiter)
dstnam:   equ 2d56h     ;(17 bytes: 16 for the characters and one for end marker or delimiter)
drvnum:   equ 2d67h     ;Drive number (1 byte: 0 .. 9)
dirnum:   equ 2d68h     ;The number of directory entry to process (2 bytes)
al2idx:   equ 2d6ah     ;Allocation 2 sector index (1 byte: 0 .. 127)
secidx:   equ 2d6bh     ;Data sector index (1 byte: 0 .. 255)
l0d6ch:   equ 2d6ch     ;??? (1 byte)
al1idx:   equ 2d6dh     ;Allocation 1 sector index (1 byte: 0 .. 63)
dirhid:   equ 2d6eh     ;Flag for show hidden files on directory ("H": Yes, else: no)

al2bufs:  equ 2d6fh     ;(16 Allocation 2 sector buffers with 256 bytes)
al2buf0:  equ al2bufs+ 0*256;(Allocation 2 sector buffer for channel number  0 with 256 bytes)
al2buf1:  equ al2bufs+ 1*256;(Allocation 2 sector buffer for channel number  1 with 256 bytes)
al2buf2:  equ al2bufs+ 2*256;(Allocation 2 sector buffer for channel number  2 with 256 bytes)
al2buf3:  equ al2bufs+ 3*256;(Allocation 2 sector buffer for channel number  3 with 256 bytes)
al2buf4:  equ al2bufs+ 4*256;(Allocation 2 sector buffer for channel number  4 with 256 bytes)
al2buf5:  equ al2bufs+ 5*256;(Allocation 2 sector buffer for channel number  5 with 256 bytes)
al2buf6:  equ al2bufs+ 6*256;(Allocation 2 sector buffer for channel number  6 with 256 bytes)
al2buf7:  equ al2bufs+ 7*256;(Allocation 2 sector buffer for channel number  7 with 256 bytes)
al2buf8:  equ al2bufs+ 8*256;(Allocation 2 sector buffer for channel number  8 with 256 bytes)
al2buf9:  equ al2bufs+ 9*256;(Allocation 2 sector buffer for channel number  9 with 256 bytes)
al2buf10: equ al2bufs+10*256;(Allocation 2 sector buffer for channel number 10 with 256 bytes)
al2buf11: equ al2bufs+11*256;(Allocation 2 sector buffer for channel number 11 with 256 bytes)
al2buf12: equ al2bufs+12*256;(Allocation 2 sector buffer for channel number 12 with 256 bytes)
al2buf13: equ al2bufs+13*256;(Allocation 2 sector buffer for channel number 13 with 256 bytes)
al2buf14: equ al2bufs+14*256;(Allocation 2 sector buffer for channel number 14 with 256 bytes)
al2buf15: equ al2bufs+15*256;(Allocation 2 sector buffer for channel number 15 with 256 bytes)

al1bufs:  equ 3d6fh     ;(16 Allocation 1 sector buffers with 128 bytes)
al1buf0:  equ al1bufs+ 0*128;(Allocation 1 sector buffer for channel number  0 with 128 bytes)
al1buf1:  equ al1bufs+ 1*128;(Allocation 1 sector buffer for channel number  1 with 128 bytes)
al1buf2:  equ al1bufs+ 2*128;(Allocation 1 sector buffer for channel number  2 with 128 bytes)
al1buf3:  equ al1bufs+ 3*128;(Allocation 1 sector buffer for channel number  3 with 128 bytes)
al1buf4:  equ al1bufs+ 4*128;(Allocation 1 sector buffer for channel number  4 with 128 bytes)
al1buf5:  equ al1bufs+ 5*128;(Allocation 1 sector buffer for channel number  5 with 128 bytes)
al1buf6:  equ al1bufs+ 6*128;(Allocation 1 sector buffer for channel number  6 with 128 bytes)
al1buf7:  equ al1bufs+ 7*128;(Allocation 1 sector buffer for channel number  7 with 128 bytes)
al1buf8:  equ al1bufs+ 8*128;(Allocation 1 sector buffer for channel number  8 with 128 bytes)
al1buf9:  equ al1bufs+ 9*128;(Allocation 1 sector buffer for channel number  9 with 128 bytes)
al1buf10: equ al1bufs+10*128;(Allocation 1 sector buffer for channel number 10 with 128 bytes)
al1buf11: equ al1bufs+11*128;(Allocation 1 sector buffer for channel number 11 with 128 bytes)
al1buf12: equ al1bufs+12*128;(Allocation 1 sector buffer for channel number 12 with 128 bytes)
al1buf13: equ al1bufs+13*128;(Allocation 1 sector buffer for channel number 13 with 128 bytes)
al1buf14: equ al1bufs+14*128;(Allocation 1 sector buffer for channel number 14 with 128 bytes)
al1buf15: equ al1bufs+15*128;(Allocation 1 sector buffer for channel number 15 with 128 bytes)

eoisav:   equ 456fh
dirout:   equ 4570h     ;Here where a directory output line stored before output (??? bytes)
wrtprt:   equ 45f0h     ;Points to current position to writee to ieee (2 bytes)
endbuf:   equ 45f2h     ;Points to end of buffer to write to ieee (2 bytes)
l25f4h:   equ 45f4h     ;(2 bytes)
dirdrv:   equ 45f6h     ;Save the Drive Number (drvnum) when Directory (open_dir) is processed (1 byte)
dirnam:   equ 45f7h     ;open_dir parameter (17 bytes: 16 for the characters and one for end marker or delimiter)
pattfn:   equ 4608h     ;Points to pattern for filename, used in find_first and find_next (2 bytes)
tmpdrv:   equ 460ah     ;Temporary drive number, used in corv_read_sec und corv_writ_sec (2 bytes)
drvcnf:   equ 460ch     ;Flag if drive is configured (0: Not Configured, 1: Configured)
l260dh:   equ 460dh     ;Temporary in cmd_cpy (2 bytes)
l260fh:   equ 460fh     ;Temporary in put_number (1 byte)
hdrbuf:   equ 4610h     ;Buffer of header sector (first sector of user area with 256 bytes)
drvnam:   equ hdrbuf+  0;Position   0 starts the drive names of the ten drives
drvid:    equ hdrbuf+160;Position 160 starts the drive ids of the ten drives
rdbuf:    equ 4710h     ;(256 bytes)
cpybuf:   equ 4810h     ;Temporary buffer, only used for concat command (256 bytes)
bambuf:   equ 4910h     ;Buffer of BAM sector bamsec used in bam_read_sec and bam_writ_sec or for B-A and B-F (256 bytes)

l4a10h:   equ 4a10h     ;??? (3 Bytes)

stack:    equ 4a93h

buffers:  equ 5000h     ;(16 sector buffers with 256 bytes)
buffer0:  equ buffers+ 0*256;(sector buffer for channel number  0 with 256 bytes)
buffer1:  equ buffers+ 1*256;(sector buffer for channel number  1 with 256 bytes)
buffer2:  equ buffers+ 2*256;(sector buffer for channel number  2 with 256 bytes)
buffer3:  equ buffers+ 3*256;(sector buffer for channel number  3 with 256 bytes)
buffer4:  equ buffers+ 4*256;(sector buffer for channel number  4 with 256 bytes)
buffer5:  equ buffers+ 5*256;(sector buffer for channel number  5 with 256 bytes)
buffer6:  equ buffers+ 6*256;(sector buffer for channel number  6 with 256 bytes)
buffer7:  equ buffers+ 7*256;(sector buffer for channel number  7 with 256 bytes)
buffer8:  equ buffers+ 8*256;(sector buffer for channel number  8 with 256 bytes)
buffer9:  equ buffers+ 9*256;(sector buffer for channel number  9 with 256 bytes)
buffer10: equ buffers+10*256;(sector buffer for channel number 10 with 256 bytes)
buffer11: equ buffers+11*256;(sector buffer for channel number 11 with 256 bytes)
buffer12: equ buffers+12*256;(sector buffer for channel number 12 with 256 bytes)
buffer13: equ buffers+13*256;(sector buffer for channel number 13 with 256 bytes)
buffer14: equ buffers+14*256;(sector buffer for channel number 14 with 256 bytes)
buffer15: equ buffers+15*256;(sector buffer for channel number 15 with 256 bytes)
ELSE
dirsrt:   equ 0024h     ;Absolute sector where directory starts (3 bytes, 4 sector after the user area starts)
al1srt:   equ 0027h     ;Absolute sector where allocation 1 (128 bytes) starts (3 bytes)
al1max:   equ 002ah     ;Maximum number of Files for Allocation 1 Sectors (2 bytes)
al2srt:   equ 002ch     ;Absolute sector where allocation 2 (256 bytes) starts (3 bytes)
al2max:   equ 002fh     ;(2 bytes)
filsrt:   equ 0031h     ;Absolute sector where the files starts (3 bytes)
l0034h:   equ 0034h     ;Size (in kilobytes) usable for normal files, these are 4 blocks (2 bytes)
l0036h:   equ 0036h     ;Starting sector number for direct access (3 bytes)
l0039h:   equ 0039h     ;(2 bytes)
bamsrt:   equ 003bh     ;Starting sector number where BAM for direct access starts (3 bytes)
usrnam:   equ 003eh     ;User name is copied from sector 0, 1, 2 or 3 depends on userid (16 bytes)
bamsec:   equ 004eh     ;BAM sector number currently in bambuf (1 byte)
defdnu:   equ 004fh     ;Default Drive number (0 .. 9) set via command "D"
errcod:   equ 0050h     ;Error code in error message
errtrk:   equ 0051h     ;Track number in error message (3 bytes)
errsec:   equ 0054h     ;Sector number in error message (3 bytes)

l0057h:   equ 0057h     ;BAM table for allocation 2 sectors (1 bit for 1 sector, 1024 bytes are 8192 bits or 8192 sectors)
l0457h:   equ 0457h     ;BAM table for data files (1 bit for 1 kilobyte, 1024 byte are 8192 bits or 8192 kilobyte) ???

entbufs:  equ 0857h     ;(16 Directory entry buffer with 41 bytes)
entbuf0:  equ entbufs+ 0*41;(Directory entry buffer for channel number  0 with 41 bytes)
entbuf1:  equ entbufs+ 1*41;(Directory entry buffer for channel number  1 with 41 bytes)
entbuf2:  equ entbufs+ 2*41;(Directory entry buffer for channel number  2 with 41 bytes)
entbuf3:  equ entbufs+ 3*41;(Directory entry buffer for channel number  3 with 41 bytes)
entbuf4:  equ entbufs+ 4*41;(Directory entry buffer for channel number  4 with 41 bytes)
entbuf5:  equ entbufs+ 5*41;(Directory entry buffer for channel number  5 with 41 bytes)
entbuf6:  equ entbufs+ 6*41;(Directory entry buffer for channel number  6 with 41 bytes)
entbuf7:  equ entbufs+ 7*41;(Directory entry buffer for channel number  7 with 41 bytes)
entbuf8:  equ entbufs+ 8*41;(Directory entry buffer for channel number  8 with 41 bytes)
entbuf9:  equ entbufs+ 9*41;(Directory entry buffer for channel number  9 with 41 bytes)
entbuf10: equ entbufs+10*41;(Directory entry buffer for channel number 10 with 41 bytes)
entbuf11: equ entbufs+11*41;(Directory entry buffer for channel number 11 with 41 bytes)
entbuf12: equ entbufs+12*41;(Directory entry buffer for channel number 12 with 41 bytes)
entbuf13: equ entbufs+13*41;(Directory entry buffer for channel number 13 with 41 bytes)
entbuf14: equ entbufs+14*41;(Directory entry buffer for channel number 14 with 41 bytes)
entbuf15: equ entbufs+15*41;(Directory entry buffer for channel number 15 with 41 bytes)

sa:       equ 0ae7h     ;Current channel number, comes with the secondary address (sa)
entptr:   equ 0ae8h     ;Pointer to a buffer (entbufs) of directory entry with 41 bytes (2 bytes)
al2ptr:   equ 0aeah     ;Pointer to a buffer (al2bufs) of a Allocation 2 sector with 256 bytes (2 bytes)
bufptr:   equ 0aech     ;Pointer to a buffer (buffers) of a sector buffer with 256 bytes (2 bytes)
al1ptr:   equ 0aeeh     ;Pointer to a buffer (al1bufs) of a Allocation 1 sector with 128 bytes (2 bytes)
lsntlk:   equ 0af0h     ;State of ieee bus (1 byte: bit 1 = TALK active, bit 2 = LISTEN active)
staptr:   equ 0af1h     ;Pointer to current position of stabuf when writing to control channel (2 bytes)
cmdptr:   equ 0af3h     ;Pointer to current position of cmdbuf when reading from control channel(2 bytes)

dirbuf:   equ 0af5h     ;Directory block buffer (256 bytes)
cmdbuf:   equ 0bf5h     ;Command buffer for writing to control channel 15 (128 bytes)
getbuf:   equ 0c75h     ;Buffer to read after SA or OPEN bytes, this stores commands (SA and OPEN) or filenames (OPEN) (128 bytes)
stabuf:   equ 0cf5h     ;Status buffer for reading from control channel 15 (80 Bytes)

filnam:   equ 0d45h     ;(17 bytes: 16 for the characters and one for end marker or delimiter)
dstnam:   equ 0d56h     ;(17 bytes: 16 for the characters and one for end marker or delimiter)
drvnum:   equ 0d67h     ;Drive number (1 byte: 0 .. 9)
dirnum:   equ 0d68h     ;The number of directory entry to process (2 bytes)
al2idx:   equ 0d6ah     ;Allocation 2 sector index (1 byte: 0 .. 127)
secidx:   equ 0d6bh     ;Data sector index (1 byte: 0 .. 255)
l0d6ch:   equ 0d6ch     ;??? (1 byte)
al1idx:   equ 0d6dh     ;Allocation 1 sector index (1 byte: 0 .. 63)
dirhid:   equ 0d6eh     ;Flag for show hidden files on directory ("H": Yes, else: no)

al2bufs:  equ 0d6fh     ;(16 Allocation 2 sector buffers with 256 bytes)
al2buf0:  equ al2bufs+ 0*256;(Allocation 2 sector buffer for channel number  0 with 256 bytes)
al2buf1:  equ al2bufs+ 1*256;(Allocation 2 sector buffer for channel number  1 with 256 bytes)
al2buf2:  equ al2bufs+ 2*256;(Allocation 2 sector buffer for channel number  2 with 256 bytes)
al2buf3:  equ al2bufs+ 3*256;(Allocation 2 sector buffer for channel number  3 with 256 bytes)
al2buf4:  equ al2bufs+ 4*256;(Allocation 2 sector buffer for channel number  4 with 256 bytes)
al2buf5:  equ al2bufs+ 5*256;(Allocation 2 sector buffer for channel number  5 with 256 bytes)
al2buf6:  equ al2bufs+ 6*256;(Allocation 2 sector buffer for channel number  6 with 256 bytes)
al2buf7:  equ al2bufs+ 7*256;(Allocation 2 sector buffer for channel number  7 with 256 bytes)
al2buf8:  equ al2bufs+ 8*256;(Allocation 2 sector buffer for channel number  8 with 256 bytes)
al2buf9:  equ al2bufs+ 9*256;(Allocation 2 sector buffer for channel number  9 with 256 bytes)
al2buf10: equ al2bufs+10*256;(Allocation 2 sector buffer for channel number 10 with 256 bytes)
al2buf11: equ al2bufs+11*256;(Allocation 2 sector buffer for channel number 11 with 256 bytes)
al2buf12: equ al2bufs+12*256;(Allocation 2 sector buffer for channel number 12 with 256 bytes)
al2buf13: equ al2bufs+13*256;(Allocation 2 sector buffer for channel number 13 with 256 bytes)
al2buf14: equ al2bufs+14*256;(Allocation 2 sector buffer for channel number 14 with 256 bytes)
al2buf15: equ al2bufs+15*256;(Allocation 2 sector buffer for channel number 15 with 256 bytes)

al1bufs:  equ 1d6fh     ;(16 Allocation 1 sector buffers with 128 bytes)
al1buf0:  equ al1bufs+ 0*128;(Allocation 1 sector buffer for channel number  0 with 128 bytes)
al1buf1:  equ al1bufs+ 1*128;(Allocation 1 sector buffer for channel number  1 with 128 bytes)
al1buf2:  equ al1bufs+ 2*128;(Allocation 1 sector buffer for channel number  2 with 128 bytes)
al1buf3:  equ al1bufs+ 3*128;(Allocation 1 sector buffer for channel number  3 with 128 bytes)
al1buf4:  equ al1bufs+ 4*128;(Allocation 1 sector buffer for channel number  4 with 128 bytes)
al1buf5:  equ al1bufs+ 5*128;(Allocation 1 sector buffer for channel number  5 with 128 bytes)
al1buf6:  equ al1bufs+ 6*128;(Allocation 1 sector buffer for channel number  6 with 128 bytes)
al1buf7:  equ al1bufs+ 7*128;(Allocation 1 sector buffer for channel number  7 with 128 bytes)
al1buf8:  equ al1bufs+ 8*128;(Allocation 1 sector buffer for channel number  8 with 128 bytes)
al1buf9:  equ al1bufs+ 9*128;(Allocation 1 sector buffer for channel number  9 with 128 bytes)
al1buf10: equ al1bufs+10*128;(Allocation 1 sector buffer for channel number 10 with 128 bytes)
al1buf11: equ al1bufs+11*128;(Allocation 1 sector buffer for channel number 11 with 128 bytes)
al1buf12: equ al1bufs+12*128;(Allocation 1 sector buffer for channel number 12 with 128 bytes)
al1buf13: equ al1bufs+13*128;(Allocation 1 sector buffer for channel number 13 with 128 bytes)
al1buf14: equ al1bufs+14*128;(Allocation 1 sector buffer for channel number 14 with 128 bytes)
al1buf15: equ al1bufs+15*128;(Allocation 1 sector buffer for channel number 15 with 128 bytes)

eoisav:   equ 256fh
dirout:   equ 2570h     ;Here where a directory output line stored before output (??? bytes)
wrtprt:   equ 25f0h     ;Points to current position to writee to ieee (2 bytes)
endbuf:   equ 25f2h     ;Points to end of buffer to write to ieee (2 bytes)
l25f4h:   equ 25f4h     ;(2 bytes)
dirdrv:   equ 25f6h     ;Save the Drive Number (drvnum) when Directory (open_dir) is processed (1 byte)
dirnam:   equ 25f7h     ;open_dir parameter (17 bytes: 16 for the characters and one for end marker or delimiter)
pattfn:   equ 2608h     ;Points to pattern for filename, used in find_first and find_next (2 bytes)
tmpdrv:   equ 260ah     ;Temporary drive number, used in corv_read_sec und corv_writ_sec (2 bytes)
drvcnf:   equ 260ch     ;Flag if drive is configured (0: Not Configured, 1: Configured)
l260dh:   equ 260dh     ;Temporary in cmd_cpy (2 bytes)
l260fh:   equ 260fh     ;Temporary in put_number (1 byte)
hdrbuf:   equ 2610h     ;Buffer of header sector (first sector of user area with 256 bytes)
drvnam:   equ hdrbuf+  0;Position   0 starts the drive names of the ten drives
drvid:    equ hdrbuf+160;Position 160 starts the drive ids of the ten drives
rdbuf:    equ 2710h     ;(256 bytes)
cpybuf:   equ 2810h     ;Temporary buffer, only used for concat command (256 bytes)
bambuf:   equ 2910h     ;Buffer of BAM sector bamsec used in bam_read_sec and bam_writ_sec or for B-A and B-F (256 bytes)

stack:    equ 2a93h

buffers:  equ 3000h     ;(16 sector buffers with 256 bytes)
buffer0:  equ buffers+ 0*256;(sector buffer for channel number  0 with 256 bytes)
buffer1:  equ buffers+ 1*256;(sector buffer for channel number  1 with 256 bytes)
buffer2:  equ buffers+ 2*256;(sector buffer for channel number  2 with 256 bytes)
buffer3:  equ buffers+ 3*256;(sector buffer for channel number  3 with 256 bytes)
buffer4:  equ buffers+ 4*256;(sector buffer for channel number  4 with 256 bytes)
buffer5:  equ buffers+ 5*256;(sector buffer for channel number  5 with 256 bytes)
buffer6:  equ buffers+ 6*256;(sector buffer for channel number  6 with 256 bytes)
buffer7:  equ buffers+ 7*256;(sector buffer for channel number  7 with 256 bytes)
buffer8:  equ buffers+ 8*256;(sector buffer for channel number  8 with 256 bytes)
buffer9:  equ buffers+ 9*256;(sector buffer for channel number  9 with 256 bytes)
buffer10: equ buffers+10*256;(sector buffer for channel number 10 with 256 bytes)
buffer11: equ buffers+11*256;(sector buffer for channel number 11 with 256 bytes)
buffer12: equ buffers+12*256;(sector buffer for channel number 12 with 256 bytes)
buffer13: equ buffers+13*256;(sector buffer for channel number 13 with 256 bytes)
buffer14: equ buffers+14*256;(sector buffer for channel number 14 with 256 bytes)
buffer15: equ buffers+15*256;(sector buffer for channel number 15 with 256 bytes)
ENDIF

IF version = 291
    org 0100h

    jp reset            ;0100 c3 00 02

l0103h:                 ;user data block
    db    1             ;Physical drive number (1 .. 4, 1 Byte)
    db 0,0,0            ;Starting sector number on drive (An Absolute Sector Number, 3 Bytes)
    dw 6080             ;User area size in kilobytes, there are 4 blocks (2 Bytes, Maximum is 64 Megabytes)
    db    0             ;Type of user area (Single user or Multi-user) (1 Byte) (Disallow write)
    dw  992             ;Maximum numbers of files allowed (2 Bytes, Maximum is 65535)
    dw 1017             ;Size (in kilobyte) allocated for direct access, these are 4 blocks (2 Bytes, Maximum is 64 Megabytes)
    dw   77             ;# of "tracks per drive" for direct access (2 Bytes)
    db 29,0,0           ;# of "sectors per track" for direct access (3 Bytes)
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

l0123h:                 ;user name
    db "HARD DISK       "

l0133h:
    db 07h              ;Max. head number (starting from 0)

l0134h:
    dw 0060h            ;First cylinder number used for HardBox

l0136h:
    db 08h              ;IEEE-488 primary address

                        ;unused data (filler)
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0

reset:
    xor a               ;A=0
    out (ppi1_pb),a     ;Clear IEEE data out

    ld a,atna
    out (ppi2_pb),a     ;Clear IEEE control out, except ATNA (inactive)

    ld a,(l0136h)
    ld (devnum),a       ;Store device number from header
ELSE
    org    0e000h

le000h:
    jp reset

reset:
    ld a,10011001b      ;Set PPI #1 control
                        ;  Bit 7: IO   1 = I/O mode (not BSR)
                        ;  Bit 6: GA1  0 = Group A as Mode 1 (Simple I/O)
                        ;  Bit 5: GA0  0
                        ;  Bit 4: PA   1 = Group A, Port A as Input
                        ;  Bit 3: PCu  1 = Group A, Port C upper as Input
                        ;  Bit 2: GB   0 = Group B as Mode 1 (Simple I/O)
                        ;  Bit 1: PB   0 = Group B, Port B as Output
                        ;  Bit 0: PCl  1 = Group B, Port C lower as Input
    out (ppi1_cr),a

    ld a,10011000b      ;Set PPI #2 control
                        ;  Bit 7: IO   1 = I/O mode (not BSR)
                        ;  Bit 6: GA1  0 = Group A as Mode 1 (Simple I/O)
                        ;  Bit 5: GA0  0
                        ;  Bit 4: PA   1 = Group A, Port A as Input
                        ;  Bit 3: PCu  1 = Group A, Port C upper as Input
                        ;  Bit 2: GB   0 = Group B as Mode 1 (Simple I/O)
                        ;  Bit 1: PB   0 = Group B, Port B as Output
                        ;  Bit 0: PCl  0 = Group B, Port C lower as Output
    out (ppi2_cr),a

    ld a,ledrdy
    out (ppi2_pc),a     ;Turn off "Ready" LED, turn on "A" and "B" LEDs

    xor a               ;A=0
    out (ppi1_pb),a     ;Clear IEEE data out

    ld a,atna
    out (ppi2_pb),a     ;Clear IEEE control out, except ATNA (inactive)

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

    ld a,ledrdy
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
    xor ledrdy
    out (ppi2_pc),a     ;Invert "Ready" LED

    ld de,8000h
le09ch:
    in a,(ppi2_pc)
    and ready           ;Corvus READY
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

    ld a,ledrdy
    out (ppi2_pc),a     ;Turn off "Ready" LED, turn on "A" and "B" LEDs
    call corv_init      ;Initialize the Corvus controller

    in a,(ppi1_pc)      ;Read DIP switches
    cpl
    rra                 ;Shift 1 bit right
    and 00000111b       ;Use only these bits ----xxx-
    add a,8             ;plus 8 (0=8, 1=9, ... 7=15)
    ld (devnum),a

    in a,(ppi1_pc)      ;Read DIP switches
    cpl
    ld c,a
    rra
    rra
    rra
    rra                 ;Shift 4 bits right

    ld b,4              ;B=04h (4 bits to process)
le0c8h:
    rra
    rl c
    djnz le0c8h

    ld a,c
    and 00011111b       ;Now we have ---04567
ENDIF

init_user:
;Init user with user data
;A=User Number
;
    ld sp,stack

                        ;Clear memory from 0004h .. 2a13h
    ld hl,usrdat        ;HL=0004h
    ld de,usrdat+1      ;DE=0005h
    ld bc,2a0eh         ;BC=2a0eh
    ld (hl),00h         ;(0004h)=0
                        ;(0005h)=(0004h) or 00h .. (2a13h)=(2a12h) or 00h
    ldir                ;Copy BC bytes from (HL) to (DE)

IF version = 291
    xor a
    ld (userid),a       ;(userid)=0

    ld a,1
    ld (drvcnf),a       ;(drvcnf)=1

    ld hl,cmdbuf        ;When we start reading from control channel, we store it into command buffer (cmdbuf)
    ld (cmdptr),hl      ;(cmdptr)=cmdbuf

    ld hl,l0103h        ;Pointer to user data block from header
ELSE
    ld (userid),a       ;Store User Number

    xor a
    ld (drvcnf),a       ;(drvcnf)=0

    ld a,error_84       ;" DRIVE NOT CONFIGURED"
    call error_out      ;Writes the error message " DRIVE NOT CONFIGURED" into the status buffer

    ld hl,cmdbuf        ;When we start reading from control channel, we store it into command buffer (cmdbuf)
    ld (cmdptr),hl      ;(cmdptr)=cmdbuf

    ld a,(userid)       ;Get User Number
    cp 01fh             ;Is it 31?
    jr nz,le100h
    xor a               ;A=0
    ld (userid),a       ;  Yes: Set it to 0
    jp le2aeh           ;  And don't configure the drive!

le100h:
    ld de,16
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

    ld hl,drvcnf        ;Okay, drive is configured
    inc (hl)            ;(drvcnf)=(drvcnf)+1
    call error_ok       ;"OK" overwrites " DRIVE NOT CONFIGURED"

    ld a,(userid)
    rr a
    rr a
    rr a
    rr a
    and 00001111b
    ld e,a              ;E=(userid)/16
    xor a               ;A=0
    ld d,a              ;ADE=0, 1, 2 or 3 depends on (userid) to read the user name
    ld b,1              ;B=Corvus drive number (1)
    ld hl,rdbuf         ;HL=rdbuf (target address)
    call corv_read_sec  ;Reads the sector (256 bytes) with the user name

    ld a,(userid)
    add a,a
    add a,a
    add a,a
    add a,a
    ld c,a
    ld b,0              ;BC=(userid)*16
    ld hl,rdbuf
    add hl,bc           ;HL=rdbuf+BC
    ld de,usrnam
    ld bc,16            ;BC=0010h (16 bytes for the user name)
    ldir                ;Copy BC bytes from (HL) to (DE)

    ld a,(userid)
    rra
    rra
    rra
    and 00011111b
    add a,4
    ld e,a              ;E=(userid)/8+4
    xor a               ;A=0
    ld d,a              ;ADE=4, 5, 6, 7, 8, 9, 10 or 11 depends on (userid) to read the user parameter
    ld b,1              ;B=Corvus drive number (1)
    ld hl,rdbuf         ;HL=rdbuf (target address)
    call corv_read_sec  ;Reads the sector (256 bytes) with the user parameter

    ld a,(userid)
    and 00000111b
    rrca
    rrca
    rrca
    ld c,a
    ld b,0              ;BC=(userid)*32
    ld hl,rdbuf
    add hl,bc           ;HL=rdbuf+BC
ENDIF

    ld de,phydrv
    ld bc,32            ;BC=0020h (32 bytes for the user parameter)
    ldir                ;Copy BC bytes from (HL) to (DE)

IF version = 291
    ld hl,l0123h        ;"HARD DISK       "
    ld de,usrnam
    ld bc,16            ;BC=0010h (16 bytes for the user name)
    ldir                ;Copy the user name "HARD DISK"

    call error_ok       ;0242 cd d8 05
ENDIF

    call head_read_sec  ;Read the header sector into the header buffer (hdrbuf)

                        ;For Allocation 1 sectors we need the same count as for directory entries.
    ld hl,(maxdir)      ;HL=Maximum directory entries in the user area (maxdir)
    ld (al1max),hl      ;Store it as (al1max), too

                        ;For half the user space we reserved Allocation 2 sectors to build large files.
    ld a,(usrsiz+1)
    ld e,a              ;A Allocation 2 sector can hold 128 file data sectors, we calculate with 256
    ld d,0              ;DE=(usrsiz)/256
    add hl,de
    ld (al2max),hl      ;(al2max)=HL+DE

                        ; ???? (BAM???)
    ld hl,(usrdir)      ;HL=User area size for direct access in kb (usrdir)

    ld a,h
    ld b,9              ;A ??? need 2 Bytes for 1 megabyte direct access
    call hl_shr_b       ;HL=HL/512

    inc hl
    ld (l0039h),hl      ;(l0039h)=HL+1

                        ;Now we calculate the management space in kilobytes to subtract from user space
    ld hl,(maxdir)      ;Number of Directory Entries with 32 bytes
    ld b,5              ;A Directory entry is 8*4 Bytes long
    call hl_shr_b       ;HL=(maxdir)/32

    inc hl              ;HL=HL+1

    ex de,hl
    ld hl,(al1max)      ;Number of Allocation 1 sectors with 128 bytes
    ld b,3              ;A Allocation 1 sector is 32*4 Bytes long
    call hl_shr_b       ;HL=(al1max)/8

    inc hl
    add hl,de           ;HL=HL+DE+1

    ex de,hl
    ld hl,(al2max)      ;Number of Allocation 2 sectors with 256 bytes
    ld b,2              ;A Allocation 2 sectors is 64*4 Bytes long
    call hl_shr_b
    inc hl              ;DE=(al2max)/4+1

    add hl,de           ;HL=HL+DE

    ld de,(usrdir)      ;The size in kilobytes from the user space for direct access
    add hl,de           ;HL=HL+User area size for direct access in kb (usrdir)

    ld de,(l0039h)      ; ????
    add hl,de           ;HL=HL+(l0039h)

    ex de,hl
    ld hl,(usrsiz)
    scf
    sbc hl,de
    srl h
    rr l
    ld (l0034h),hl      ;(l0034h)=((usrsiz)-HL)/2

    ld hl,(usrsrt)
    ld a,(usrsrt+2)
    ld de,4             ;Directory starts 4 sectors after the user ares starts
    add hl,de
    adc a,0             ;AHL=(usrsrt)+4

    ld (dirsrt),hl
    ld (dirsrt+2),a     ;(dirsrt)=AHL

    ex de,hl
    ld hl,(maxdir)
    ld b,3              ;A Directory Entry is 32 Bytes long
    call hl_shr_b       ;DE=(maxdir)/8

    inc hl
    add hl,de
    adc a,0             ;AHL=AHL+DE+1

    ld (al1srt),hl      ;Allocation 1 Entries starts after the Directory
    ld (al1srt+2),a     ;(al1srt)=AHL

    ld de,(al1max)      ;Number of Allocation 1 sectors with 128 bytes
    srl d
    rr e                ;A Allocation 1 Entry is 128 bytes long
    inc de
    add hl,de
    adc a,0             ;AHL=AHL+((al1max)/2)+1

    ld (al2srt),hl      ;Allocation 2 Entries starts after Allocation 1 Entries
    ld (al2srt+2),a     ;(al2srt)=AHL

    ld de,(al2max)      ;Number of Allocation 2 sectors with 256 bytes
    add hl,de
    adc a,0             ;AHL=AHL+(al2max)

    ld (filsrt),hl      ;Files starts after Allocation 2 Entries
    ld (filsrt+2),a     ;(filsrt)=AHL

    ld de,(l0034h)
    ld b,8
le21eh:
    add hl,de
    adc a,0
    djnz le21eh         ;AHL=AHL+8*(l0034h)

    ld (bamsrt),hl      ;BAM starts after Allocation 2 Entries
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
    ld (sa),a           ;(sa)=0fh (15 = control channel)

    call sub_f7d0h

    ld hl,0
    ld (dirnum),hl      ;(dirnum)=0

                        ;Build own BAM for files from directory entries
le246h:
    call dir_get_next   ;Get the next directory entry into DE
    jr c,le26eh         ;End reached? Skipping ...
    bit 7,(ix+f_drvn)   ;Is this directory entry used?
    jr nz,le246h        ;  NO: next directory entry

    call loc1_read_sec  ;Read allocation 1 sector DE to (al1ptr)
    ld b,64             ;B=40h (64 links to allocation 2 sectors)
    ld ix,(al1ptr)      ;IX=(al1ptr)

le25ah:
    ld l,(ix+0)
    ld h,(ix+1)         ;HL=(IX)
    ld de,l0057h        ;DE=l0057h (BAM table for allocation 2 sectors)
    call set_bam_bit    ;Set a bit in a BAM table for allocation 2 sectors (l0057h)
    inc ix
    inc ix              ;Increment the pointer
    djnz le25ah         ;All done? NO: next link
    jr le246h           ;next directory entry

le26eh:
    ld de,0             ;DE=0000h (Start with allocation 2 sector 0)
    ld hl,l0057h        ;HL=l0057h (BAM table for allocation 2 sectors)

le274h:
    ld b,8              ;Loop over all 8 bits
    ld c,(hl)           ;Get the byte with 8 bits from the BAM
    inc hl

le278h:
    rr c                ;Rotate the bits
    jr nc,le29dh        ;If this bit is cleared, skip

    push bc
    push hl
    push de
    call loc2_read_sec  ;Read (256 bytes)
    ld b,128            ;B=80h (128 links to data file sectors)
    ld ix,(al2ptr)

le288h:
    ld l,(ix+0)
    ld h,(ix+1)         ;HL=(IX)
    inc ix
    inc ix              ;Increment the pointer
    ld de,l0457h        ;DE=l0457h (BAM table for data files)
    call set_bam_bit    ;Set a bit in a BAM table for data files (l0457h)
    djnz le288h         ;All done? NO: next link
    pop de
    pop hl
    pop bc

le29dh:
    inc de              ;Increment allocation 2 sector
    ld a,(al2max)
    cp e
    jr nz,le2aah
    ld a,(al2max+1)
    cp d                ;If the maximum of allocation 2 sectors reached?
    jr z,le2aeh         ;  YES: finish

le2aah:
    djnz le278h         ;check next bit
    jr le274h           ;check next byte

le2aeh:
    xor a
    out (ppi2_pc),a     ;Turn on all LEDs ("Ready" LED, "A" and "B")
    out (ppi1_pb),a

    in a,(ppi2_pb)
    and 00000000b
    out (ppi2_pb),a     ;ATNA=high (inactive), EOI_out=high, NRFD_out=high, NDAC_out=high, DAV_out=high, ATN_out=high

le2b9h:
    in a,(ppi2_pa)
    and atn
    jr z,le2b9h         ;Wait until ATN=low

le2bfh:
;After we detect a ATN=low, now we wait for DAV=low before we can read
;
    in a,(ppi2_pb)
    or atna+ndac
    out (ppi2_pb),a     ;ATNA=low (active), NDAC_OUT=low

    in a,(ppi2_pb)
    and 255-nrfd
    out (ppi2_pb),a     ;NRFD_OUT=high

le2cbh:
    in a,(ppi2_pa)
    and dav
    jr nz,le2dah        ;If DAV=low, read attention data

    in a,(ppi2_pa)
    and atn
    jr nz,le2cbh        ;Wait until ATN=high

    jp le34dh           ;Now we proceed the normal data exchange after ATN

le2dah:
;After detection an ATN=low, now is DAV=low. So we must read the primary address (TALK or LISTEN)
;
    ld hl,lsntlk

    in a,(ppi2_pb)
    or nrfd
    out (ppi2_pb),a     ;NRFD_OUT=low

    in a,(ppi1_pa)
    ld c,a

    in a,(ppi2_pb)
    and 255-ndac
    out (ppi2_pb),a     ;NDAC_OUT=high

    ld a,(devnum)
    or 20h              ;Generate LISTEN address
    cp c
    jr z,do_listn       ;If found LISTEN execute do_listn

    xor 60h             ;Generate TALK address
    cp c
    jr z,do_talk        ;If found TALK execute do_talk

    ld a,c
    cp 3fh              ;3Fh=UNLISTEN
    jr z,do_unlst       ;If found UNLISTEN execute do_unlst

    cp 5fh              ;5Fh=UNTALK
    jr z,do_untlk       ;If found UNTALK execute do_untlk
    and 60h
    cp 60h              ;Is the byte a SA, OPEN or CLOSE?
    jr nz,le312h        ;  NO: finish this data cyclus and skip data

    ld a,c              ;We store the channel number as SA
    ld (sa),a           ;(sa)=C

    and 0f0h
    cp 0e0h             ;Is this byte a CLOSE?
    jr z,sa_close       ;  YES: process a close

le312h:
    in a,(ppi2_pa)
    and dav
    jr nz,le312h        ;Wait until DAV_IN=high

    jr le2bfh

do_listn:
    set 2,(hl)          ;Set marker for LISTEN is active
    xor a               ;A=0
    ld (sa),a
    jr le312h

do_talk:
    set 1,(hl)          ;Set marker for TALK is active
    xor a               ;A=0
    ld (sa),a
    jr le312h

do_unlst:
    res 2,(hl)          ;Clear marker for LISTEN is active
    jr le312h

do_untlk:
    res 1,(hl)          ;Clear marker for TALK is active
    jr le312h

sa_close:
    ld (hl),0           ;Clear all marker for LISTEN and TALK active
    ld a,c
    and 0fh
    ld (sa),a
    push af
    cp 02h
    call nc,error_ok
    pop af
    cp 0fh              ;Is Control Channel?
    push af
    call z,sub_e86ah
    pop af
    call nz,sub_e81fh
    jr le312h

le34dh:
    in a,(ppi2_pb)
    and 255-atna
    out (ppi2_pb),a     ;ATNA=high (inactive)

    ld a,(lsntlk)       ;Is neither LISTEN nor TALK active set?
    or a
    jp z,le2aeh         ;  YES: Nothing to do
    bit 2,a             ;Is marker for LISTEN active set?
    jr nz,do_read       ;  YES: do reading from ieee
                        ;  NO: do writing to ieee
do_write:
    in a,(ppi2_pb)
    and 255-ndac
    out (ppi2_pb),a     ;NDAC_OUT=high (inactive, we want to talk)

    ld a,(sa)
    or a
    jp z,le2aeh
    and 0fh
    ld (sa),a
    cp 0fh              ;Is Control Channel?
    jp nz,do_wr_chan    ;  NO: We write from data channel to ieee
                        ;  YES: We write the disk status from status buffer to ieee
le375h:
    ld hl,(staptr)      ;HL=(staptr) (staptr is current position in stabuf)
    ld a,(hl)           ;Read the character from stabuf
    call sub_e448h
    jp c,le2aeh
    ld a,(hl)           ;Read the character from stabuf again
    inc hl              ;Increment the position in stabuf
    cp cr               ;Is the end marker (cr) reached?
    jr nz,le388h        ;  NO: continue
                        ;  YES: Set the pointer to the start of status buffer
    ld hl,stabuf        ;HL=stabuf

le388h:
    ld (staptr),hl      ;(staptr)=HL (Store the current position)
    jr le375h           ;Write the next character

do_read:
    ld a,(sa)
    or a
    jp z,le2aeh
    push af
    and 0fh             ;Get only the channel number from the secondary address
    ld (sa),a           ;And store it
    cp 02h              ;Is the channel number is 0 or 1?
    call nc,error_ok    ;Set the error message to "OK"

    pop af              ;Is the secondary address a OPEN or CLOSE
    jp p,le3d3h         ;No, this must be a command or data for a channel

    ld hl,getbuf        ;HL=getbuf (Parameter for OPEN command, e.g. filename)
    ld b,7fh            ;B=7fh (127 Characters of .... )

le3a8h:
    call rdieee
    jp c,le2aeh
    bit 7,b             ;Is bit 7 of B set, this means B is negative and we read more than 128 bytes
    jr nz,le3b5h        ;  YES: Don't store the readed character

    ld (hl),a           ;Store the character in getbuf
    inc hl              ;Increment the position in getbuf
    dec b               ;Decrement the counter B

le3b5h:
    ld a,(eoisav)       ;Read the last state of EOI
    or a                ;Is EOI detected?
    jr z,le3a8h         ;  NO: Read next characters

    ld (hl),cr          ;Save end marker in buffer getbuf

    ld a,(sa)           ;Get secondary address
    cp 0fh              ;Is Control Channel?
    jp nz,do_open       ;  NO: do a open file or channel

                        ;Copy all 128 characters from getbuf to command buffer (cmdbuf)
    ld hl,getbuf        ;HL=getbuf
    ld de,cmdbuf        ;DE=cmdbuf
    ld bc,128           ;BC=0080h (128 bytes)
    ldir                ;Copy BC bytes from (HL) to (DE)
    jp le4a2h

le3d3h:
    ld a,(sa)
    cp 0fh              ;Is Control Channel?
    jp nz,do_rd_chan    ;  NO: We read from ieee to data channels
                        ;  YES: We read the command from ieee to command buffer
    ld hl,(cmdptr)      ;HL=(cmdptr) (cmdptr is current position in cmdbuf)

le3deh:
    call rdieee
    jp c,le2aeh
    ld (hl),a           ;Store the character in cmdbuf
    ld a,l
    cp (cmdbuf+0x7f) & 0xff
    jr z,le3eeh

    inc hl              ;Increment the position in cmdbuf
    ld (cmdptr),hl      ;(cmdptr)=HL (Store the current position)

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

    ld a,1
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
    jr nz,le473h        ;Wait until NDAC_IN=high

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
    ld de,cmd_char

    ld hl,cmdbuf        ;When we start reading from control channel, we store it into command buffer (cmdbuf)
    ld (cmdptr),hl      ;(cmdptr)=cmdbuf

    ld b,cmd_addr-cmd_char ;B=12h (18 Commands)
    ld ix,cmd_addr
le4b4h:
    ld a,(de)
    cp (hl)
    jr z,cmd_found
    inc de
    inc ix
    inc ix
    djnz le4b4h
    ld a,error_31       ;"SYNTAX ERROR (INVALID COMMAND)"
    jp error

cmd_found:
    ld l,(ix+0)
    ld h,(ix+1)         ;HL=(IX)
    call do_cmd
    jp le2aeh

do_cmd:
    jp (hl)

cmd_char:
    db "NSDIRGHW-VLT!PBUAC"

cmd_addr:
    dw cmd_new          ;"N": New Drive Name
    dw cmd_del          ;"S": Scratch Files
    dw cmd_drv          ;"D": Set Default Drive Number
    dw cmd_ini          ;"I": Initialize
    dw cmd_ren          ;"R": Rename File
    dw cmd_flg          ;"G": Set Global
    dw cmd_flg          ;"H": Set Hide a File
    dw cmd_flg          ;"W": Set Write Protect
    dw cmd_flg          ;"-": Reset (Global | Hide a File | Write Protect)
    dw cmd_vfy          ;"V": Validate
    dw cmd_lgn          ;"L": Login
    dw lebdfh           ;"T": Transfer Files
    dw leeceh           ;"!"
    dw cmd_pos          ;"P": Record Position
    dw cmd_blk          ;"B": Block commands
    dw cmd_usr          ;"U": User commands
    dw cmd_abs          ;"A": Absolute commands
    dw cmd_cpy          ;"C": Copy and Concat

error:
    call error_out      ;Writes the error message defined in A into the status buffer
    ld sp,stack
    jp le2aeh

error_ok:
;Writes the error message "OK" into the status buffer
;
    call clrerrts

error_out:
;Writes the error message defined in A into the status buffer
;
;        A = Error Code
; (errtrk) = Error Track
; (errsec) = Error Sector
;
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
    ld hl,stabuf        ;HL=stabuf
    ld de,0             ;DEA=(errcod)
    call put_number     ;Put a number into buffer

    ld (hl),","         ;Put comma into buffer
    inc hl

    pop de
le538h:
    ld a,(de)           ;Get the character from error text
    and 01111111b       ;Mask off the highest bit (end marker bit)
    ld (hl),a           ;Store it into buffer

    cp 020h             ;Is this an error token?
    jr nc,le55bh        ;  NO: leave unchanged

    push de
    ld de,error_tok     ;Get address of error token table
    ld b,a              ;B=error token

le545h:
    dec b               ;Decrement error token
    jr z,le54fh         ;Is error token found? YES: Put the token into buffer

le548h:
    ld a,(de)           ;Get the character from error token
    inc de
    rla                 ;Is highest bit set (end marker bit)?
    jr nc,le548h        ;  NO: get next character
    jr le545h           ;  YES: Check next error token

le54fh:
    ld a,(de)           ;Get the character from error token
    and 01111111b       ;Mask off the highest bit (end marker bit)
    ld (hl),a           ;Store it into buffer
    ld a,(de)           ;Get last character from error token
    inc hl
    inc de
    rla                 ;Is highest bit set (end marker bit)?
    jr nc,le54fh        ;  NO: get next character
    pop de
    dec hl

le55bh:
    ld a,(de)           ;Get last character from error text
    rla                 ;Is highest bit set (end marker bit)?
    inc hl
    inc de
    jr nc,le538h        ;  NO: get next character

    ld (hl),","         ;Put comma into buffer
    inc hl

    ld a,(errtrk)
    ld de,(errtrk+1)    ;DEA=(errtrk)
    call put_number     ;Put a number into buffer

    ld (hl),","         ;Put comma into buffer
    inc hl

    ld a,(errsec)
    ld de,(errsec+1)    ;DEA=(errsec)
    call put_number     ;Put a number into buffer

    ld (hl),cr          ;Put cr into buffer

    ld hl,stabuf        ;When we start writing to control channel, we take it from status buffer (stabuf)
    ld (staptr),hl      ;(staptr)=stabuf
    ret

clrerrts:
;clear error track and sector number
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
    ld b,6              ;B=06h (Maximum 6 digits)
    ld iy,l260fh
    res 0,(iy+0)
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
    bit 0,(iy+0)
    jr nz,le5ceh
    ld a,b
    cp 02h
    jr nz,le5d6h
le5ceh:
    set 0,(iy+0)
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
    db 0a0h,86h,01h     ;100000
    db 10h,27h,00h      ;10000

le5e7h:
    db 0e8h,03h,00h     ;1000
    db 64h,00h,00h      ;100
    db 0ah,00h,00h      ;10
    db 01h,00h,00h      ;1

do_open:
    call error_ok
    call sub_f7d0h
    bit 7,(iy+028h)
    call nz,sub_e81fh
    ld iy,(entptr)
    ld (iy+028h),000h
    ld (iy+027h),000h
    ld (iy+f_al1x),0ffh ;No valid Allocation 1 index number
    ld hl,getbuf        ;HL=getbuf

le613h:
    ld a,(hl)
    cp "$"
    jp z,open_dir
    cp "#"
    jp z,open_chn
    cp "@"
    jr nz,le629h
    set 5,(iy+028h)     ;Set marker for "Command Access"
    inc hl
    jr le613h

le629h:
    call get_filename   ;Get a filename

    ld (iy+f_attr),typ_seq
    ld a,(sa)
    cp 02h
    jr nc,le63fh
    ld (iy+f_attr),typ_prg
    set 0,(iy+028h)     ;Set marker for file type
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
    ld (iy+f_rlen),a    ;Save detected record length

le680h:
    ld a,(iy+f_attr)    ;Get file attributes
    and 11111100b
    or b
    ld (iy+f_attr),a    ;Save detected file type

    set 0,(iy+28h)      ;Set marker for file type
    jr le63fh

le68fh:
    set 4,(iy+28h)      ;Set marker for "Append"
    jr le63fh

le695h:
    set 3,(iy+28h)      ;Set marker for "Write"
    jr le63fh

le69bh:
    ld a,(sa)
    cp 02h              ;Is (sa) >= 2
    jr nc,le6adh        ;  YES: No changes (can be read and write)

    res 3,(iy+28h)      ;Reset marker for "Write"
    or a                ;Is (sa) equal 0
    jr z,le6adh         ;  YES: This is a read channel

    set 3,(iy+28h)      ;Set marker for "Write"

le6adh:
    bit 3,(iy+28h)      ;Is marker for "Write" set?
    jp z,le748h         ;  YES: do write
                        ;  NO: do read
le6b4h:
    call check_wild
    ld a,error_33       ;"SYNTAX ERROR(INVALID FILENAME)"
    jp c,error          ;If invalid filename, SYNTAX ERROR(INVALID FILENAME)

    ld hl,filnam
    ld a,(drvnum)
    call find_first
    ld iy,(entptr)
    jr c,le6e2h
    bit 5,(iy+28h)      ;Is marker for command access set
    ld a,error_63       ;"FILE EXISTS"
    jp z,error

    bit 6,(ix+f_attr)   ;is marker for "Write Protect" set?
    ld a,error_26       ;"WRITE PROTECTED"
    jp nz,error         ;If yes, WRITE PROTECTED

    call sub_f82ah
    jr le6e5h

le6e2h:
    call find_free      ;Find the first free directory entry
le6e5h:
    push de
    push ix
    ld a,(drvnum)
    ld (iy+f_drvn),a    ;(IY+f_drvn)=(drvnum)

    ld (iy+f_dirn+0),e
    ld (iy+f_dirn+1),d  ;(IY+f_dirn)=DE

    set 7,(iy+f_attr)   ;set marker for "Open File"
    set 7,(iy+28h)

    ld b,3              ;B=03h (3 Bytes for file size)

    ld a,(iy+f_rlen)
    ld (iy+025h),a      ;(IY+025h)=(IY+f_rlen)
    or a                ;Was this zero?
    jr nz,le70fh        ;  NO: all okay, else change it to the maximum 254

    ld (iy+f_rlen),254  ;(IY+f_rlen)=0feh
    ld (iy+025h),254    ;(IY+025h)=0feh

le70fh:
    ld (iy+f_size),255  ;(IY+f_size)=0ffffffh (all 3 bytes)
    ld (iy+f_cptr),0    ;(IY+f_cptr)=000000h (all 3 bytes)
    inc iy
    djnz le70fh

                        ;Fill all 128 bytes from the Allocation 1 sector (al1ptr) with 0ffh
    ld hl,(al1ptr)      ;HL=(al1ptr)
    ld b,128            ;B=80h (128 Bytes for a full Allocation 1 sector)
le720h:
    ld (hl),0ffh        ;(HL)=0ffh
    inc hl
    djnz le720h

    call loc1_writ_sec  ;Write sector (al1srt)+DE with 128 bytes from (al1ptr)

                        ;Copy the filename from filnam into directory entry
    ld hl,(entptr)
    ld de,f_name
    add hl,de
    ex de,hl            ;DE=(entptr)+f_name
    ld hl,filnam
    ld bc,16            ;BC=0010h (16 characters for a filename)
    ldir                ;Copy BC bytes from (HL) to (DE)

                        ;Copy entire directory entry into directory sector
    ld hl,(entptr)
    pop de
    ld bc,32            ;BC=0020h (32 bytes for a directory entry)
    ldir                ;Copy BC bytes from (HL) to (DE)
    pop de
    call dir_writ_sec
    jp le2aeh

le748h:
    ld hl,filnam
    ld a,(drvnum)
    call find_first
    ld iy,(entptr)
    jr nc,le766h
    ld a,(iy+f_attr)    ;Get file type
    and 00000011b
    cp typ_rel          ;Is it file type equal relative?
    jp z,le6b4h         ;  YES: ???
    ld a,error_62       ;"FILE NOT FOUND"
    jp error

le766h:
    bit 0,(iy+28h)      ;Is marker for file type set?
    jr z,le78ah

    ld a,(iy+f_attr)    ;Get file type
    xor (ix+f_attr)
    and 00000011b
    jr z,le78ah

    ld hl,filnam
    ld a,(drvnum)
    call find_next
    ld iy,(entptr)
    jr nc,le766h

    ld a,error_64       ;"FILE TYPE MISMATCH"
    jp error

le78ah:
    call loc1_read_sec  ;Read allocation 1 sector DE to (al1ptr)
    ld (iy+f_dirn+0),e  ;Store the directory entry number
    ld (iy+f_dirn+1),d  ;(IY+f_dirn)=DE

    ld (iy+f_cptr+0),0  ;Current buffer pointer start at 0
    ld (iy+f_cptr+1),0
    ld (iy+f_cptr+2),0  ;(IY+f_cptr)=000000h

    set 7,(iy+028h)

    ld b,32             ;B=20h (32 Bytes)
le7a5h:
    ld a,(ix+0)
    ld (iy+0),a         ;(IY)=(IX) (Copy all 32 bytes from IX to IY)
    inc ix
    inc iy
    djnz le7a5h

    ld iy,(entptr)
    ld a,(iy+f_rlen)
    ld (iy+025h),a
    bit 4,(iy+028h)     ;Is marker for "Append" set?
    jr nz,le7ebh        ;  YES: Dont cut

    ld a,(iy+f_size+0)
    and (iy+f_size+1)
    and (iy+f_size+2)
    inc a               ;Is file size equal 0ffffffh?
    jr nz,le7e2h        ;  NO: ...

    ld a,(iy+f_attr)    ;Get file type
    and 00000011b
    cp typ_rel          ;Is it file type equal relative?
    jr z,le7e8h         ;  YES: Nothing to do

    xor a               ;A=0
    ld (iy+f_size+0),a
    ld (iy+f_size+1),a
    ld (iy+f_size+2),a    ;Set file size to 0
    jr le7e8h

le7e2h:
    call sub_eb00h
    call file_read_sec  ;Read a file sector
le7e8h:
    jp le2aeh

le7ebh:
    ld a,(iy+f_size+0)
    add a,1
    ld (iy+f_cptr+0),a
    ld a,(iy+f_size+1)
    adc a,0
    ld (iy+f_cptr+1),a
    ld a,(iy+f_size+2)
    adc a,0
    ld (iy+f_cptr+2),a    ;(IY+f_cptr)=(IY+f_size)+1

    call sub_eb00h
    ld a,(secidx)
    or a
    call nz,file_read_sec;Read a file sector
    jp le2aeh

open_chn:
    set 7,(iy+028h)
    set 6,(iy+028h)     ;Set marker for "Channel Access"
    ld (iy+f_cptr),0
    jp le2aeh

sub_e81fh:
    call sub_f7d0h
    bit 7,(iy+028h)
    ret z
    res 7,(iy+028h)
    call sub_eb00h
    bit 7,(iy+027h)
    call nz,file_writ_sec;Write a file sector
    bit 4,(iy+027h)
    jr nz,le840h
    bit 7,(iy+f_attr)   ;set marker for "Open File"
    ret z
le840h:
    ld e,(iy+f_dirn+0)
    ld d,(iy+f_dirn+1)  ;DE=(IY+f_dirn)
    push de
    call dir_read_sec
    res 7,(iy+f_attr)   ;reset marker for "Open File"
    ld bc,00020h
    ld a,e
    and 07h
    add a,a
    add a,a
    add a,a
    add a,a
    add a,a
    ld e,a
    ld d,00h
    ld hl,dirbuf
    add hl,de
    ex de,hl
    ld hl,(entptr)
    ldir                ;Copy BC bytes from (HL) to (DE)
    pop de
    jp dir_writ_sec
sub_e86ah:
    xor a               ;A=0
le86bh:
    ld (sa),a
    push af
    call sub_e81fh
    pop af
    inc a
    cp 0fh
    jr nz,le86bh
    ret

do_wr_chan:
    call sub_f7d0h
    bit 7,(iy+28h)
    jp z,le2aeh
    bit 6,(iy+28h)      ;Is marker for "Channel Access" set?
    jp nz,le921h
    bit 4,(iy+28h)      ;Is marker for "Append" set?
    jp nz,le2aeh
    bit 3,(iy+28h)      ;Is marker for "Write" set?
    jp nz,le2aeh
    bit 2,(iy+28h)      ;Is marker for "Directory" set?
    jp nz,le949h
    call sub_eb00h
    ld a,(iy+f_attr)    ;Get file type
    and 00000011b
    cp typ_rel          ;Is it file type equal relative?
    jr nz,le8b3h        ;  NO: No check

    call sub_f1f7h
    ld a,error_50       ;"RECORD NOT PRESENT"
    jp nc,error

le8b3h:
    ld a,(secidx)
    ld e,a
    ld d,00h
    ld hl,(bufptr)
    add hl,de           ;HL=(bufptr) + (secidx)

le8bdh:
    ld a,(iy+f_attr)    ;Get file type
    and 00000011b
    cp typ_rel          ;Is it file type equal relative?
    jr nz,le8d7h        ;  NO: ???
    dec (iy+025h)
    jr nz,le8d7h
    ld a,(iy+f_rlen)
    ld (iy+025h),a

    in a,(ppi2_pb)
    or eoi
    out (ppi2_pb),a     ;EOI_OUT=low

le8d7h:
    ld a,(iy+f_cptr+0)
    cp (iy+f_size+0)
    jr nz,le8efh
    ld a,(iy+f_cptr+1)
    cp (iy+f_size+1)
    jr nz,le8efh
    ld a,(iy+f_cptr+2)
    cp (iy+f_size+2)    ;Is (IY+f_cptr) = (IY+f_size)?
    jr z,le912h         ;  YES: Last byte reached, write with EOI

le8efh:
    ld a,(hl)           ;Get byte from buffer
    call wrieee         ;and write to ieeee
    jp c,le91bh         ;If error, ????

    inc hl              ;Increment data buffer pointer
    inc (iy+f_cptr+0)
    jr nz,le90dh
    inc (iy+f_cptr+1)
    jr nz,le904h
    inc (iy+f_cptr+2)   ;(IY+f_cptr)=(IY+f_cptr)+1

le904h:
    call sub_eb00h
    call file_read_sec  ;Read a file sector
    ld hl,(bufptr)
le90dh:
    call sub_e492h
    jr le8bdh

le912h:
    ld a,(hl)           ;Get byte from buffer
    call wreoi          ;and write to ieee with EOI
    jp c,le2aeh         ;If error, ???
    jr le912h           ;Loop until error to exit

le91bh:
    inc (iy+025h)
    jp le2aeh
le921h:
    ld hl,(bufptr)
    ld c,(iy+f_cptr)
    ld b,00h
    add hl,bc
    ld a,(iy+025h)
    cp c
    jr z,le93ch
    ld a,(hl)
    call sub_e448h
    jp c,le2aeh
    inc (iy+f_cptr)
    jr le921h
le93ch:
    ld a,(hl)
    call wreoi
    jp c,le2aeh
    ld (iy+f_cptr),000h
    jr le921h

le949h:
    ld hl,(wrtprt)      ;HL=(wrtptr)
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
    ld hl,(l25f4h)
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

do_rd_chan:
    call sub_f7d0h
    bit 7,(iy+028h)     ;Is marker for "???" set?
    jp z,le2aeh         ;  NO: aborting

    bit 6,(iy+028h)     ;Is marker for "Channel Access" set?
    jp nz,leaebh

    ld a,(iy+f_attr)    ;Get file type
    and 00000011b
    cp typ_rel          ;Is it file type equal relative?
    jr z,le9e7h         ;  YES: do special case for relative files

    bit 3,(iy+028h)     ;Is marker for "Write" set?
    jr nz,le9a7h        ;  YES: write

    bit 4,(iy+028h)     ;Is marker for "Append" set?
    jp z,le2aeh         ;  NO: aborting

le9a7h:
    call sub_eb00h

    ld a,(secidx)
    ld e,a
    ld d,00h
    ld hl,(bufptr)
    add hl,de           ;HL=(bufptr) + (secidx)

le9b4h:
    call rdieee         ;Read character from ieee
    jp c,le2aeh         ;If error, abort

    ld (hl),a           ;Store character into buffer

    set 7,(iy+027h)
    set 4,(iy+027h)

    inc hl              ;Increment pointer to buffer

    inc (iy+f_size+0)
    jr nz,le9d1h
    inc (iy+f_size+1)
    jr nz,le9d1h
    inc (iy+f_size+2)   ;Increment file size

le9d1h:
    inc (iy+f_cptr+0)   ;Increment current file pointer
    jr nz,le9b4h        ;Same Sector? YES: Next character
    inc (iy+f_cptr+1)
    jr nz,le9deh
    inc (iy+f_cptr+2)
                        ;  NO: Write this sector and start with a new one

le9deh:
    call file_writ_sec  ;Write a file sector
    res 7,(iy+027h)
    jr le9a7h

le9e7h:
    call rdieee         ;Read character from ieee
    jp c,le2aeh         ;If error, abort

    push af
    call error_ok
    call sub_eb00h
    call sub_f1f7h
    jp c,lea83h

    ld l,(iy+f_cptr+0)
    ld h,(iy+f_cptr+1)
    ld a,(iy+f_cptr+2)  ;AHL=(IY+f_cptr)
    push af
    push hl

    ld a,(iy+f_size+0)
    add a,1
    ld (iy+f_cptr+0),a
    ld a,(iy+f_size+1)
    adc a,0
    ld (iy+f_cptr+1),a
    ld a,(iy+f_size+2)
    adc a,0
    ld (iy+f_cptr+2),a  ;(IY+f_cptr)=(IY+f_size)

    call sub_eb00h
    call file_read_sec  ;Read a file sector

    ld c,(iy+f_cptr)
    ld b,00h
    ld hl,(bufptr)
    add hl,bc           ;HL=(bufptr)+(IY+f_cptr)

lea2ch:
    pop de
    pop bc
    push bc
    push de

    ld a,(iy+f_cptr+0)
    cp e
    ld a,(iy+f_cptr+1)
    sbc a,d
    ld a,(iy+f_cptr+2)
    sbc a,b
    jr nc,lea63h

    ld a,0ffh
    ld b,(iy+f_rlen)

lea43h:
    ld (hl),a           ;Store character into buffer
    inc hl              ;Increment pointer to buffer

    inc (iy+f_cptr+0)
    jr nz,lea5dh
    inc (iy+f_cptr+1)
    jr nz,lea52h
    inc (iy+f_cptr+2)   ;(IY+f_cptr)=(IY+f_cptr)+1

lea52h:
    push bc
    call file_writ_sec  ;Write a file sector
    call sub_eb00h
    pop bc

    ld hl,(bufptr)
lea5dh:
    ld a,cr
    djnz lea43h
    jr lea2ch

lea63h:
    pop hl
    pop hl

    ld a,(iy+f_rlen)
    dec a
    add a,(iy+f_cptr+0)
    ld (iy+f_size+0),a
    ld a,(iy+f_cptr+1)
    adc a,0
    ld (iy+f_size+1),a
    ld a,(iy+f_cptr+2)
    adc a,0
    ld (iy+f_size+2),a  ;(IY+f_size)=(IY+f_cptr)+(IY+f_rlen)-1

    set 4,(iy+027h)
lea83h:
    call sub_eb00h

    ld bc,(secidx)
    ld b,00h
    ld hl,(bufptr)
    add hl,bc           ;HL=(bufptr) + (secidx)

    pop af
    jr lea99h

lea93h:
    call rdieee
IF version = 31
    jp c,le2aeh
ELSE
    jr nc,lea99h
    call file_writ_sec
    jp le2aeh
ENDIF

lea99h:
    ld c,a
    ld a,(iy+025h)
    or a
    ld a,c
    push af
    push iy
    ld a,error_51       ;"OVERFLOW IN RECORD"
    call z,error_out    ;Writes the error message "OVERFLOW IN RECORD" into the status buffer
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
IF version = 31
    call file_writ_sec  ;Write a file sector
ENDIF
    ld a,(iy+f_rlen)
    ld (iy+025h),a
    jr lea93h

sub_eacah:
    ld (hl),a
    dec (iy+025h)
    inc hl
    inc (iy+f_cptr+0)
    ret nz
    inc (iy+f_cptr+1)
    jr nz,leadbh
    inc (iy+f_cptr+2)
leadbh:
    call file_writ_sec  ;Write a file sector
    call sub_eb00h
    call sub_f1f7h
    call c,file_read_sec;Read a file sector
    ld hl,(bufptr)
    ret

leaebh:
    call rdieee
    jp c,le2aeh
    ld hl,(bufptr)
    ld c,(iy+f_cptr)
    inc (iy+f_cptr)
    ld b,00h
    add hl,bc
    ld (hl),a
    jr leaebh

sub_eb00h:
;
;Split a file pointer into used index parts (allocation 1, allocation 2, ???, sector)
;  +2  Hi   +1  Mi   +0  Lo
; 76543210 76543210 76543210
;                   ^^^^^^^^. (secidx): 0 .. 255 = sector pointer
;               ^^^.......... (l0d6ch): 0 ..   7 = ???
;       ^^ ^^^^^............. (al2idx): 0 .. 127 = allocation 2 sector number (index)
; ^^^^^^..................... (al1idx): 0 ..  63 = allocation 1 sector number (index)
;
    ld iy,(entptr)      ;IY=(entptr)

    ld a,(iy+f_cptr+0)
    ld (secidx),a       ;(secidx)=(IY+f_cptr)

    ld l,(iy+f_cptr+1)
    ld h,(iy+f_cptr+2)  ;HL=(IY+f_cptr+1)

    ld a,l
    and 07h
    ld (l0d6ch),a       ;(l0d6ch)=HL mod 8

    ld b,3
    call hl_shr_b       ;HL=HL / 8

    ld a,l
    and 7fh
    ld (al2idx),a       ;(al2idx)=HL mod 128

    ld b,7
    call hl_shr_b       ;HL=HL / 128

    ld a,l
    ld (al1idx),a       ;(al1idx)=L
    ret

cmd_del:
;command for scratch files "S"
;
    call find_drvlet    ;Find drive letter
leb2eh:
    call get_filename   ;Get a filename

    push hl
    ld a,0fh
    ld (sa),a           ;(sa)=0fh (15 = control channel)
    call sub_f7d0h

    ld a,(drvnum)
    ld c,a
    ld hl,filnam
    call find_first     ;Search for first file entry in directory
    jr c,leb6eh         ;If nothing found, nothing to do (skip)

leb46h:
    bit 6,(ix+f_attr)   ;is marker for "Write Protect" set?
    jr nz,leb62h        ;  YES: Skip scratching this file
    bit 7,(ix+f_attr)   ;is marker for "Open File" set?
    jr nz,leb62h        ;  YES: Skip scratching this file

    ld hl,errtrk
    inc (hl)            ;Increment the scratched files counter for output

    ld (ix+f_drvn),0ffh ;Set this directory entry as unused

    push de
    call sub_f82ah
    pop de

    call dir_writ_sec   ;Write changed directory sector

leb62h:
    ld hl,filnam
    ld a,(drvnum)
    ld c,a
    call find_next      ;Search for next file entry in directory
    jr nc,leb46h        ;If found, loop

leb6eh:
    pop hl
leb6fh:
    ld a,(hl)           ;Get next character from command buffer
    inc hl
    cp ","              ;Is there a comma?
    jr z,leb2eh         ;  YES: Look next file pattern
    cp cr               ;Is there a end marker
    jr nz,leb6fh        ;  NO: Check next character
    ld a,error_01       ;"FILES SCRATCHED"
    jp error_out        ;Writes the error message "FILES SCRATCHED" into the status buffer

cmd_flg:
;Command set or reset a flag (Global, Hide a File, Write Protect)
;
    call find_drvlet    ;Find drive letter
    call get_filename   ;Get a filename

    ld a,(drvnum)
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
    set 5,(ix+f_attr)   ;set marker for "Hide"
    jr lebd1h
leba4h:
    cp "W"              ;check for "Write Protect"
    jr nz,lebaeh
    set 6,(ix+f_attr)   ;set marker for "Write Protect"
    jr lebd1h
lebaeh:
    cp "G"              ;check for "Global"
    jr nz,leb91h
    set 4,(ix+f_attr)   ;set marker for "Global"
    jr lebd1h
lebb8h:
    ld a,(hl)
    cp "H"              ;check for "Hide"
    jr nz,lebc1h
    res 5,(ix+f_attr)   ;reset marker for "Hide"
lebc1h:
    cp "W"              ;check for "Write Protect"
    jr nz,lebc9h
    res 6,(ix+f_attr)   ;reset marker for "Write Protect"
lebc9h:
    cp "G"              ;check for "Global"
    jr nz,lebd1h
    res 4,(ix+f_attr)   ;reset marker for "Global"
lebd1h:
    call dir_writ_sec

    ld hl,filnam
    ld a,(drvnum)
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
    cp "9"+1-"0"
    jr nc,lec13h
    ld c,a
    push bc
    ld a,(drvnum)
    ld hl,filnam
    call find_first
lebffh:
    pop bc
    ret c
    ld (ix+001h),c
    push bc
    call dir_writ_sec
    ld a,(drvnum)
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
    ld a,0fh
    ld (sa),a           ;(sa)=0fh (15 = control channel)
    call sub_f7d0h
    ld a,(drvnum)
    ld (iy+f_drvn),a
    ld (iy+028h),000h
    ld (iy+027h),000h
    ld (iy+f_al1x),0ffh ;No valid Allocation 1 index number

                        ;Copy the filename from filnam into directory entry
    ld hl,(entptr)
    ld de,f_name
    add hl,de
    ex de,hl            ;DE=(entptr)+f_name
    ld hl,filnam
    ld bc,16            ;BC=0010h (16 characters for a filename)
    ldir                ;Copy BC bytes from (HL) to (DE)

    call check_wild
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
    ld a,(drvnum)
    cp (iy+f_drvn)
    jr nz,lecbah
    ld b,10h
    ld hl,(entptr)
    ld de,0002h
    add hl,de
    ld de,filnam
lec73h:
    ld a,(de)
    cp (hl)
    jr nz,lecbah
    inc hl
    inc de
    djnz lec73h
    ld a,(drvnum)
    ld hl,filnam
    call find_first
    ld a,error_62       ;"FILE NOT FOUND"
    jp c,error

    ld iy,(entptr)
    ld (iy+f_dirn+0),e
    ld (iy+f_dirn+1),d  ;(IY+f_dirn)=DE
    push ix
    pop hl
    ld de,(entptr)
    ld bc,0020h         ;BC=0020h (32 ... ???)
    ldir                ;Copy BC bytes from (HL) to (DE)

    ld a,(iy+f_size+0)
    add a,1
    ld (iy+f_cptr+0),a
    ld a,(iy+f_size+1)
    adc a,0
    ld (iy+f_cptr+1),a
    ld a,(iy+f_size+2)
    adc a,0
    ld (iy+f_cptr+2),a  ;(IY+f_cptr)=(IY-f_size)+1
    jp leddbh

lecbah:
    ld hl,(entptr)
    ld de,0002h
    add hl,de
    ld a,(iy+f_drvn)
    call find_first
    ld a,error_63       ;"FILE EXISTS"
    jp nc,error

    call find_free      ;Find the first free directory entry
    ld iy,(entptr)

    ld (iy+f_dirn+0),e
    ld (iy+f_dirn+1),d  ;(IY+f_dirn)=DE

    set 5,(iy+027h)

    ld (iy+f_cptr+0),0
    ld (iy+f_cptr+1),0
    ld (iy+f_cptr+2),0  ;(IY+f_cptr)=000000h

    ld hl,(al1ptr)
    ld b,080h
leceeh:
    ld (hl),0ffh
    inc hl
    djnz leceeh
    ld a,(drvnum)
    ld hl,filnam
    call find_first
    ld a,error_62       ;"FILE NOT FOUND"
    jp c,error

    ld iy,(entptr)
    ld a,(ix+f_attr)
    ld (iy+f_attr),a
    ld a,(ix+f_rlen)
    ld (iy+f_rlen),a
led11h:
    ld (l260dh),de
    ld bc,0ffffh
led18h:
    inc bc
    push bc
    ld a,b
    and 03h
    or c
    jr nz,led43h
    ld hl,cpybuf
    ld (al1ptr),hl
    ld (al2ptr),hl
    ld de,(l260dh)
    call loc1_read_sec  ;Read allocation 1 sector DE to (al1ptr)
    ld hl,cpybuf
    pop bc
    push bc
    srl b
    ld e,b
    res 0,e
    ld d,00h
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    call loc2_read_sec
led43h:
    pop de
    push de
    rr d
    rr e
    rr d
    rr e
    res 0,e
    ld d,00h
    ld hl,cpybuf
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    pop bc
    push bc
    ld a,c
    and 07h
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
    ld de,(filsrt)
    ld a,(filsrt+2)     ;ADE=(filsrt) Absolute sector where the files starts
    add hl,de
    add a,b
    ex de,hl

    ld hl,phydrv
    ld b,(hl)           ;B=Corvus drive number

    ld hl,rdbuf
    call corv_read_sec  ;Reads a sector (256 bytes)
    call sub_f7d0h
    call sub_eb00h
    ld b,00h
    pop de
    push de
    ld a,(ix+f_size+1)
    cp e
    jr nz,led97h
    ld a,(ix+f_size+2)
    cp d
    jr nz,led97h
    ld b,(ix+f_size)
    inc b
led97h:

    ld a,(secidx)
    ld e,a
    ld d,00h
    ld hl,(bufptr)
    add hl,de           ;HL=(bufptr) + (secidx)

    ld de,rdbuf
leda4h:
    ld a,(de)
    ld (hl),a
    set 7,(iy+027h)
    inc hl
    inc de
    inc (iy+f_cptr+0)
    jr nz,ledcah
    inc (iy+f_cptr+1)
    jr nz,ledb9h
    inc (iy+f_cptr+2)
ledb9h:
    push bc
    push de
    call file_writ_sec  ;Write a file sector
    res 7,(iy+027h)
    call sub_eb00h
    ld hl,(bufptr)
    pop de
    pop bc
ledcah:
    djnz leda4h
    pop bc
    ld a,(ix+f_size+1)
    cp c
    jp nz,led18h
    ld a,(ix+f_size+2)
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
    ld a,(drvnum)
    call find_first
    jp nc,led11h
    ld a,error_62       ;"FILE NOT FOUND"
    jp error

ledfbh:
    ld iy,(entptr)
    ld a,(iy+f_cptr+0)
    sub 1
    ld (iy+f_size+0),a
    ld a,(iy+f_cptr+1)
    sbc a,0
    ld (iy+f_size+1),a
    ld a,(iy+f_cptr+2)
    sbc a,0
    ld (iy+f_size+2),a  ;(IY+f_size)=(IY+f_cptr)-1

    set 7,(iy+028h)
    set 7,(iy+f_attr)   ;set marker for "Open File"
    jp sub_e81fh

cmd_lgn:
;command for login "L"
;
IF version = 291
    ld a,1fh            ;0eec 3e 1f
    jp error            ;0eee c3 cf 05
ELSE
    call find_delim     ;Search for delimiter '=' or ':', abort if cr readed
    ld a,error_30       ;"SYNTAX ERROR"
    jp c,error

    call get_filename   ;Get a filename

    push hl
    ld hl,filnam
    ld de,dstnam
    ld bc,0010h         ;BC=0010h (16 bytes)
    ldir                ;Copy BC bytes from (HL) to (DE)

    ld b,10h            ;B=10h (16 bytes)
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

    ld de,0000h
    ld c,00h

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
    ld de,dstnam
    push bc
    ld b,10h
    ld c,00h
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
    and 0fh
    jr nz,lee69h
    pop de
    inc de
    ld a,e
    cp 04h
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
    add a,0ch
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
ENDIF

leeceh:
    ld hl,cmdbuf+1
    ld a,(hl)
    inc hl
    ld ix,leef6h
    ld b,(leef6h_end-leef6h)/3
leed9h:
    cp (ix+0)
    jr z,leeebh
    inc ix
    inc ix
    inc ix
    djnz leed9h
    ld a,error_31       ;"SYNTAX ERROR (INVALID COMMAND)"
    jp error

leeebh:
    ld e,(ix+1)
    ld d,(ix+2)
    push de
    pop iy
    jp (iy)

leef6h:
    db "D"              ;Set Device Number
    dw cmd_dev

    db "H"              ;Get Hardbox Version
    dw cmd_hbv

    db "N"              ;Number of current User
    dw cmd_uid

    db "E"              ;Execute
    dw cmd_exe

IF version != 291
    db "P"              ;Set Password
    dw cmd_pwd

    db "C"              ;Clear
    dw cmd_clr

    db "L"              ;Lock
    dw cmd_lck

    db "U"              ;Unlock
    dw cmd_ulk

IF version = 31         ;This is for a SUNOL Hard Drive
    db "S"              ;  Get Disk Size
    dw cmd_siz

    db "V"              ;  Get Version
    dw cmd_ver
ELSE                    ;This is for a CORVUS Hard Drive
    db "F"              ;  ???
    dw lf045h

    db "V"              ;  Get Version
    dw cmd_ver

    db "S"              ;  Get Disk Size
    dw cmd_siz
ENDIF
ENDIF
leef6h_end:

IF version != 291
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
    ld bc,0010h         ;BC=0010h (16 bytes)
    ldir                ;Copy BC bytes from (HL) to (DE)

    pop de              ;Restore absolute sector number
    xor a               ;A=0
    ld b,1              ;B=Corvus drive number (1)
    ld hl,rdbuf         ;HL=rdbuf (Address to write the sector)
    jp corv_writ_sec    ;Write a sector (256 bytes)
ENDIF

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
; command for get current user number "!N"
;
    ld a,(userid)       ;get userid
    ld (errtrk),a       ;store as error track number

    ld a,error_89       ;"USER #"
    jp error            ;and give it out

cmd_hbv:
;command for get hardbox version "!H"
;
IF version = 23
    ld a,2              ;Set major version
    ld (errtrk),a
    ld a,3              ;Set minor version
    ld (errsec),a
ENDIF
IF version = 24
    ld a,2              ;Set major version
    ld (errtrk),a
    ld a,4              ;Set minor version
    ld (errsec),a
ENDIF
IF version = 291
    ld a,2              ;Set major version
    ld (errtrk),a
    ld a,4              ;Set minor version
    ld (errsec),a
ENDIF
IF version = 31
    ld a,3              ;Set major version
    ld (errtrk),a
    ld a,1              ;Set minor version
    ld (errsec),a
ENDIF

    ld a,error_99       ;"SMALL SYSTEMS HARDBOX VERSION #"
    jp error

cmd_exe:
;command to execute program in buffer "!E"
;
    call get_numeric    ;Get buffer number after command
    and 0fh             ;Use only 0 to 15

    ld d,a
    ld e,0
    ld hl,buffers
    add hl,de           ;HL=buffers+A*256

    jp (hl)             ;jump to the code at the buffer

IF version != 291
cmd_ver:
;command for get version "!V"
;
    call corv_init      ;Initialize the Corvus controller
IF version = 31
ELSE                    ;This is for a CORVUS Hard Drive
    jr nz,lefc2h
    push af             ;Save version byte on stack
    rra
    rra
    rra
    rra                 ;Shift high nibble into low nibble
    and 0fh             ;Mask out only 4 bits for nibble
    ld (errtrk),a       ;Store it (high nibble) into errtrk
    pop af              ;Restore version byte from stack
    and 0fh             ;Mask out only 4 bits for nibble
    ld (errsec),a       ;Store it (low nibble) into errsec
    ld a,error_97       ;"CORVUS REV A VERSION #"
    jp error
lefc2h:
ENDIF
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
    ld bc,256           ;BC=0100h (256 bytes)
    ldir                ;Copy BC bytes from (HL) to (DE)

    ld a,0ffh
    ld (entbuf14+025h),a

IF version = 31         ;This is for a SUNOL Hard Drive
    ld a,error_98       ;  "VERSION #"
ELSE                    ;This is for a CORVUS Hard Drive
    ld a,error_98       ;  "CORVUS REV B VERSION #"
ENDIF
    jp error

cmd_siz:
;command for get disk size "!S"
;
    ld hl,cmdbuf
    call get_numeric    ;Get drive number
IF version = 31         ;This is for a SUNOL Hard Drive
    ld (errtrk),a       ;  Store drive number as error track
ELSE                    ;This is for a CORVUS Hard Drive
    ld b,a              ;  Save drive number in B
ENDIF
    ld a,error_30       ;"SYNTAX ERROR"
    jp c,error          ;If no drive number was read, "SYNTAX ERROR"

IF version = 31         ;This is for a SUNOL Hard Drive
    ld a,(errtrk)       ;  Get drive number into A
ELSE                    ;This is for a CORVUS Hard Drive
    ld a,b              ;  Restore drive Number to A
ENDIF
    dec a               ;Decrement drive number, because it starts with 1
IF version = 31         ;This is for a SUNOL Hard Drive
    and 0f0h            ;  Allow valid drive numbers from 1 .. 16
ELSE                    ;This is for a CORVUS Hard Drive
    and 0fch            ;  Allow valid drive numbers from 1 .. 4
ENDIF
    or d
    or e
    ld a,error_30       ;"SYNTAX ERROR"
    jp nz,error         ;If drive number are invalid, "SYNTAX ERROR"

IF version = 31         ;This is for a SUNOL Hard Drive
    ld a,10h            ;10h=Get drive parameter
    call corv_put_byte  ;Send first command byte
    ld a,(errtrk)
    call corv_put_byte  ;Send second command byte (drive number for Get drive parameter - starts at 1)

    call sub_fae8h
    jp nz,lf036h

    scf                 ;Set the carry flag
    ccf                 ;Invert the carry flag (it is now clear)

    ld a,(rdbuf+107)
    adc a,4             ;Add 4 to round the value after devided by 8
    srl a
    srl a
    srl a               ;A=A/8
    ld (errsec),a

    scf                 ;Set the carry flag
    ccf                 ;Invert the carry flag (it is now clear)

    ld a,(rdbuf+107+1)
    sla a
    sla a
    sla a
    sla a
    sla a               ;A=A*32

    scf                 ;Set the carry flag
    ccf                 ;Invert the carry flag (it is now clear)

    push hl
    ld hl,errsec
    add a,(hl)          ;Add low/8 and high*32
    pop hl

    ld (errsec),a       ;errsec = round([rdbuf+107] / 8)

    ld a,error_96       ;"SUNOL DRIVE SIZE"
    jp error
ELSE                    ;This is for a CORVUS Hard Drive
    ld de,0             ;DE=0000h (0 bytes)
    call corv_try_read  ;Try to read sector 0
    ld a,0              ;A=00h (no drive detected)
    jr nz,lf02eh        ;If an error detected, no readable disc is present

    ld de,30000         ;DE=7530h (7680000 bytes = 7500 kilobytes)
    call corv_try_read  ;Try to read sector 30000
    ld a,5              ;A=05h (5 MB drive detected)
    jr nz,lf02eh        ;If an error detected, drive space must be less then 7.5 MB

    ld de,60000         ;DE=0ea60h (15360000 bytes = 15000 kilobytes)
    call corv_try_read  ;Try to read sector 60000
    ld a,10             ;A=0ah (10 MB drive detected)
    jr nz,lf02eh        ;If an error detected, drive space must be less then 10 MB
                        ;Else it must be the greatest veersion: 20 MB
    ld a,20             ;A=14h (20 MB drive detected)
lf02eh:
    ld (errsec),a       ;Store the capacity as sector number

    ld a,b              ;A=B (Drive number)
    ld (errtrk),a       ;Store drive number as track number

    ld a,error_96       ;"CORVUSDRIVE SIZE"
    jp error

corv_try_read:
;Try to read a sector
;Returns with zero flag set, if sector is readable, else zero is cleared
;
; BC = Absolute sector number
;
    push bc             ;Save BC
    xor a               ;Set high byte of absolute sector number to zero
    call corv_read_sec  ;Reads a sector (256 bytes)
    pop bc              ;Restore BC
    ld a,(errcod)       ;Load error code into A
    or a                ;And set zero flag for "No error"
    ret

lf045h:
    ld a,(userid)       ;Get user number
    or a
    ld a,error_92       ;"PRIVILEGED COMMAND"
    jp nz,error         ;If user number not equal zero (supervisor), "PRIVILEGED COMMAND"

    call get_numeric    ;Get drive number
    push af             ;Store drive number on stack
    ld a,error_30       ;"SYNTAX ERROR"
    jp c,error          ;If no drive number was read, "SYNTAX ERROR"

    call corv_init      ;Initialize the Corvus controller

    pop bc
    ld a,b
    push af             ;Change zero flag into word with drive number on stack

    call nz,corv_park_heads
    jr nz,lf036h

    ld a,07h
    call corv_put_byte  ;Send first command byte (07h for Verify)
    pop af
    call z,corv_put_byte;If corv_init was without errors, send drive number

    call sub_fae8h
    jr nz,lf088h

    xor a              ;A=0
    call corv_put_byte ;Send 00h byte
    call corv_read_err ;Read the error code

    ld a,(rdbuf)
    or a
    ret z

    srl a
    srl a
    ld (errtrk),a       ;(errtrk)=(rdbuf)/4
    ld a,error_93       ;"BAD SECTORS CORRECTED"
    jp error

lf088h:
    push af
    xor a
    call corv_put_byte
    call corv_read_err
    pop af
ENDIF

lf036h:
    and 00011111b
    ld (errtrk),a
IF version = 31         ;This is for a SUNOL Hard Drive
    ld a,error_95       ;  "SUNOL DRIVE ERROR"
ELSE                    ;This is for a CORVUS Hard Drive
    ld a,error_95       ;  "CORVUSDRIVE ERROR"
ENDIF
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
    ld bc,8             ;BC=0008h (Send 8 Bytes)
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
    ld bc,8             ;BC=0008h (Send 8 Bytes)
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
    jp nz,error         ;only allowed for userid=0

    call corv_init      ;Initialize the Corvus controller
    ld bc,4             ;BC=0004h (Send 4 Bytes)
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
    db 0ah,10h          ;???
    db 00h,00h

lf0adh:
    db 1ah,10h          ;Semaphore Initialize
    db 00h,00h,00h
ENDIF

cmd_drv:
    call find_drvlet    ;Find drive letter
    ld a,(hl)           ;Get character
    call is_digit       ;Check if character is a digit
    jr nc,lf0c1h        ;  No: Jump to error
    sub "0"             ;Conver character to value
    ld (defdnu),a
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
    ld hl,0
    ld (dirnum),hl      ;(dirnum)=0

lf0cdh:
    call dir_get_next   ;Get the next directory entry into DE
    jr c,lf0e1h         ;All done? Restart
    bit 7,(ix+f_attr)   ;Is marker for "Open File" set?
    jr z,lf0cdh         ;  NO: Test next entry
                        ;  YES: We delete this open file

    ld (ix+f_drvn),0ffh ;Set this directory entry as unused
    call dir_writ_sec   ;And write this changed directory sector back
    jr lf0cdh           ;Next entry

lf0e1h:
    ld a,(userid)       ;Get the user number
    jp init_user        ;and initialize all data

cmd_ren:
;Command for rename "R"
;Format: "R0:DESTINATION=SOURCE"
;
    call find_drvlet    ;Find drive letter
    call get_filename   ;Get destination filename from command

    ld a,(drvnum)
    push af
    push hl

                        ;Abort if destination filename contains wildcards:
    call check_wild     ;  Set carry if wildcards are present
    ld a,error_33       ;  A = error code for "SYNTAX ERROR(INVALID FILENAME)"
    jp c,error          ;  Jump out to send error if carry is set

                        ;Copy destination filename into dstnam:
    ld hl,filnam        ;  HL = address of filename
    ld de,dstnam        ;  DE = address of destination filename
    ld bc,16            ;  BC = 16 bytes to copy (length of a filename)
    ldir                ;  Copy BC bytes from (HL) to (DE)

    pop hl

                        ;Abort if char is not equals ("="):
    ld a,(hl)           ;  Get character after destination filename
    cp "="              ;  Compare to "="
    ld a,error_30       ;  A = error code for "SYNTAX ERROR"
    jp nz,error         ;  Jump out to send error if char is not "="

    inc hl              ;Increment pointer to first char of source filename
    call get_filename   ;Get the source filename from command

                        ;Abort if source filename contains wildcards:
    call check_wild     ;  Set carry if wildcards are present
    ld a,error_33       ;  A = error code for "SYNTAX ERROR(INVALID FILENAME)"
    jp c,error          ;  Jump out to send error if carry is set

    pop af
    push af

                        ;Abort if destination filename already exists:
    ld hl,dstnam        ;  HL = address of destination filename
    call find_first     ;  Clears carry flag if file exists
    ld a,error_63       ;  A = error code for "FILE EXISTS"
    jp nc,error         ;  Jump out to send error if carry is clear

    pop af

                        ;Abort if source filename does not exist:
    ld hl,filnam        ;  HL = address of source filename
    call find_first     ;  Sets carry flag if file does not exist
    ld a,error_62       ;  A = error code for "FILE NOT FOUND"
    jp c,error          ;  Jump out to send error if carry is set

    bit 7,(ix+f_attr)   ;is marker for "Open File" set?
    ret nz              ;  YES: return

                        ;Copy the new filename into the directory
    ld hl,dstnam        ;  HL = address of destination filename
    ld b,16             ;  B = 16 chars in filename
lf13dh:
    ld a,(hl)           ;  Get the characters from destination filename
    ld (ix+f_name),a    ;  Write them into directory
    inc hl              ;  Increment pointer to destination filename
    inc ix              ;  Increment pointer to directory
    djnz lf13dh         ;  All done? NO: repeat

    jp dir_writ_sec     ;Write the changed directory sector back

cmd_new:
;command for new drive name (header or format) "N"
;
    call find_drvlet    ;Find drive letter
    call get_filename   ;Get a filename

    ld a,(hl)
    cp ","
    ld a,error_30       ;"SYNTAX ERROR"
    jp nz,error

    inc hl              ;Skip the comma

                        ;Copy drive id to position starting at 160
    ex de,hl
    ld hl,(drvnum)
    ld h,0
    add hl,hl           ;HL=(drvnum)*2 (2 characters for drive id)
    push hl
    ld bc,drvid
    add hl,bc
    ex de,hl            ;DE=drvid+HL

    ld bc,2             ;BC=0002h (2 characters for drive id)
    ldir                ;Copy BC bytes from (HL) to (DE)

                        ;Copy drive name to position starting at 0
    pop hl
    add hl,hl
    add hl,hl
    add hl,hl           ;HL=(drvnum)*16 (16 characters for drive name)
    ld bc,drvnam
    add hl,bc
    ex de,hl            ;DE=drvnam+HL

    ld hl,filnam
    ld bc,16            ;BC=0010h (16 characters for drive name)
lf179h:
    ld a,(hl)
    or a
    jr nz,lf17fh
    ld (hl)," "
lf17fh:
    ldi
    jp po,head_writ_sec ;Write the header sector from hdrbuf
    jr lf179h

cmd_pos:
;command to set record position "P"
;
    ld a,(cmdbuf+1)     ;Get channel number from command buffer
    and 00001111b
    ld (sa),a
    call sub_f7d0h

    bit 7,(iy+028h)
    ret z
    ld a,(iy+f_attr)    ;Get file type
    and 00000011b
    cp typ_rel          ;Is it file type equal relative?
    ret nz              ;  NO: return
    call sub_eb00h

    ld a,(cmdbuf+4)     ;Get record position from command buffer
    dec a
    cp (iy+f_rlen)
    jr c,lf1b1h

    ld a,(iy+f_rlen)
    dec a
    ld (cmdbuf+4),a

lf1b1h:
    ld c,(iy+f_rlen)    ;Get record length
    ld de,(cmdbuf+2)    ;Get record number from command buffer
    ld a,d
    or e
    jr z,lf1bdh
    dec de

lf1bdh:                 ;multiply record length (C) by record number (DE), result in AHL
    ld hl,0
    xor a               ;AHL=0
    ld b,8              ;B=08h (8 ????)
lf1c3h:
    add hl,hl           ;AHL=AHL*2
    adc a,a
    rl c
    jr nc,lf1cch
    add hl,de           ;AHL=AHL+DE
    adc a,0
lf1cch:
    djnz lf1c3h

    ld de,(cmdbuf+4)    ;Get record position from command buffer
    ld d,0
    dec de              ;DE=record position - 1
    add hl,de
    adc a,0             ;AHL=AHL+DE

    ld (iy+f_cptr),l    ;Set the block pointer for this channel to the low byte

    ld l,a
    ld a,(iy+f_rlen)
    sub e
    ld (iy+025h),a      ;(IY+025h)=(IY+f_rlen)-E
IF version = 23
    ld a,(iy+f_cptr+1)
    cp h
    jr nz,lf24ah
    ld a,(iy+f_cptr+2)
    cp l
    jr z,lf259h
lf24ah:
ENDIF
    ld (iy+f_cptr+1),h  ;Set block address for this channel
    ld (iy+f_cptr+2),l  ;(IY+f_cptr+1)=LH

    call sub_eb00h
    call sub_f1f7h
IF version = 23
    call c,file_read_sec

lf259h:
    call sub_f1f7h
    ld a,error_50       ;"RECORD NOT PRESENT"
    jp nc,error
    ret
ELSE
    jp c,file_read_sec  ;Read a file sector
    ld a,error_50       ;"RECORD NOT PRESENT"
    jp error
ENDIF

sub_f1f7h:
    push bc
    push hl

    ld l,(iy+f_size+0)
    ld h,(iy+f_size+1)
    ld b,(iy+f_size+2)  ;BHL=(IY+f_size) file size in bytes

    inc hl
    ld a,h
    or l
    jr nz,lf208h
    inc b               ;BHL=BHL+1

lf208h:
    ld a,(iy+f_cptr+0)
    cp l
    ld a,(iy+f_cptr+1)
    sbc a,h
    ld a,(iy+f_cptr+2)
    sbc a,b             ;Carry is set if BHL > (IY-f_cptr)

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

    ld a,(iy+f_cptr)    ;Get the block pointer for this channel
    dec a               ;Decrement it
    ld hl,(bufptr)      ;Get buffer address
    ld (hl),a           ;Store the block pointer minus 1 at the first byte into the buffer

    pop hl
    pop af
    jp corv_writ_sec    ;Write a sector (256 bytes)

blk_rd:
;command for block read "B-R"
;
    call sub_f36dh
    call corv_read_sec  ;Reads a sector (256 bytes)

    ld hl,(bufptr)      ;Get buffer address
    ld a,(hl)           ;Get first byte of this buffer
    ld (iy+025h),a      ;Store it as the count of valid bytes
    ld (iy+f_cptr),1    ;Set the block pointer for this channel to 1
    ret

blk_ptr:
;command for block pointer "B-P"
;
    call get_chan       ;Get channel number
    jr c,lf24dh         ;If missing or wrong number, SYNTAX ERROR

    call get_numeric    ;Get block pointer after command to DEA
    ld (iy+f_cptr),a    ;Save this block pointer for this channel
    ret

blk_fre:
;command for block free "B-F"
;
    call get_bam_bit    ;Read track and sector and get the BAM bit from BAM sector
    and 01111111b       ;Clear block allocated bit
    jr lf290h           ;and write back

blk_use:
;command for block allocate "B-A"
;
    call get_bam_bit    ;Read track and sector and get the BAM bit from BAM sector
    jr c,lf29ah         ;If this block als already allocated, search the next free sector
    or 10000000b        ;Set block allocated bit

lf290h:
    rrca                ;rotate this bit to the correct position
    djnz lf290h
    ld (hl),a           ;Store it
    call bam_writ_sec   ;Write a BAM sector
    jp error_ok         ;Done

                        ;Search the next free sector
lf29ah:
    inc b
lf29bh:
    push af
    ld ix,errsec
    inc (ix+000h)       ;Increment the sector number
    jr nz,lf2adh
    inc (ix+001h)
    jr nz,lf2adh
    inc (ix+002h)

lf2adh:
    ld a,(maxsec)
    cp (ix+000h)
    jr nz,lf2f8h
    ld a,(maxsec+1)
    cp (ix+001h)
    jr nz,lf2f8h
    ld a,(maxsec+2)
    cp (ix+002h)
    jr nz,lf2f8h        ;If the sector number is less than the maximum of sectors per track, check this sector

    ld (ix+000h),0      ;Now use zero as sector number
    ld (ix+001h),0
    ld (ix+002h),0

    ld ix,errtrk
    inc (ix+000h)       ;Increment the track number
    jr nz,lf2ddh
    inc (ix+001h)

lf2ddh:
    ld a,(maxtrk)
    sub (ix+000h)
    ld a,(maxtrk+1)
    sbc a,(ix+001h)
    jr nc,lf2f8h        ;If the track number is less than the maximum of tracks, check this sector
                        ;  Else: "NO BLOCK"
    ld (ix+000h),0      ;Now use zero as error track number (error sector number is zero, too)
    ld (ix+001h),0
    ld a,error_65       ;"NO BLOCK"
    jp error

lf2f8h:
    pop af
    djnz lf30eh         ;All bits checked? No, doit
    inc hl              ;Use next byte in the BAM
    ld a,l
    cp bambuf & 0xff    ;All byte checked?
    jr nz,lf30bh        ;No, continue

    ld hl,bamsec        ;Take next BAM sector
    inc (hl)
    call bam_read_sec   ;Read a BAM sector

    ld hl,bambuf        ;Restore the HL to bambuf

lf30bh:
    ld a,(hl)           ;Read the byte from BAM
    ld b,008h           ;And chech all 8 bits

lf30eh:
    rrca                ;is this bit cleared? So this block is free and the next free block found
    jr c,lf29bh         ;  ELSE: Check nect sector

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
    call bam_read_sec   ;Read a BAM sector

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
    ld hl,cmdbuf+1
    ld a,(hl)
    inc hl
    and 00001111b
    cp 1                ;Check for "U1" or "UA": Block Raad
    jr z,cmd_u1
    cp 2                ;Check for "U2" or "UB": Block Write
    jr z,cmd_u2
    cp 10               ;Check for "U:" or "UJ": Reset
    jp z,reset
    jp lf24dh

cmd_u1:
;command for user 1 "U1"
;
    call sub_f36dh
    ld (iy+025h),0ffh   ;Set all 255 plus 1 bytes als valid
    ld (iy+f_cptr),0    ;Set the block pointer for this channel to 0
    jp corv_read_sec    ;Reads a sector (256 bytes)

cmd_u2:
;command for user 2 "U2"
;
    call sub_f36dh
    jp corv_writ_sec    ;Write a sector (256 bytes)

sub_f36dh:
    call get_chan       ;Get channel number
    ld a,error_30       ;"SYNTAX ERROR"
    jp c,error          ;If missing or wrong channel number, SYNTAX ERROR

    call get_ts         ;Get track and sector to absolute sector BDE
    call clrerrts

    ld hl,(l0036h)
    ld a,(l0036h+2)
    add hl,de
    adc a,b
    ex de,hl            ;ADE=(l0036)+BDE

    ld hl,phydrv
    ld b,(hl)           ;B=Corvus drive number

    ld hl,(bufptr)
    ret

get_ts:
;Get track and sector from command buffer
;
    call get_numeric    ;Get drive number after command to DEA
    jp c,lf417h         ;If missing drive number, SYNTAX ERROR

    ld de,(maxtrk)
    push hl

                        ;HL=maxtrk*A
    ld hl,0             ;HL=0000h
    ld b,8              ;B=08h (A has 8 bits)

;!!!! This must be an error! The label lf39dh must before the add instruction! !!!!
    add hl,hl           ;HL=HL*2

lf39dh:
    rla                 ;A=A*2
    jr nc,lf3a1h        ;If no carry, no addition

    add hl,de           ;HL=HL+DE

lf3a1h:
    djnz lf39dh         ;Next Bit

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
    ld bc,(maxtrk)

    ld a,e
    sub c
    ld a,d
    sbc a,b
    jr nc,lf412h        ;If track number (DE) is greater than max. track (BC), ILLEGAL TRACK OR SECTOR

    ex (sp),hl

    add hl,de
    ex de,hl

                        ;AHL=maxsec*DE
    ld ix,(maxsec)
    ld bc,(maxsec+2)    ;CIX=maxsec
    ld b,24             ;B=18h (CIX have 18 bits)

    xor a
    ld hl,0             ;AHL=000000h

lf3cfh:
    add hl,hl
    adc a,a             ;AHL=AHL*2

    add ix,ix
    rl c                ;CIX=CIX*2

    jr nc,lf3dah        ;If no carry, no addition

    add hl,de
    adc a,0             ;AHL=AHL+DE

lf3dah:
    djnz lf3cfh         ;Next Bit

    ex (sp),hl
    push af

    call get_numeric    ;Get sector number after command to DEA
    jr c,lf417h         ;If missing sector number, SYNTAX ERROR

    ld (errsec),a
    ld (errsec+1),de    ;Save as error sector (if it must be used)

    ld b,a
    ld hl,maxsec
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

    ld hl,(usrdir)
    ld c,0              ;CHL=User area size in kb (usrdir)
    add hl,hl
    rl c
    add hl,hl
    rl c                ;CHL=CHL*4 (4 blocks are 1 kb)

    ld a,e
    sub l
    ld a,d
    sbc a,h
    ld a,b
    sbc a,c             ;If BDE < CHL
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

    pop af              ;Restore valid channel number
    ld (sa),a           ;Save the channel number as secondary address

    push hl
    call sub_f7d0h
    pop hl
    bit 6,(iy+028h)     ;Is marker for "Channel Access" set?
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
    jp nz,error         ;only allowed for userid=0

    call sub_f494h
    jp corv_writ_sec    ;Write a sector (256 bytes)

abs_rd:
;command for absolute read "A-R"
;
    call sub_f494h
    ld (iy+f_cptr),0    ;Set the block pointer for this channel to 0
    ld (iy+025h),0ffh   ;Set all 255 plus 1 bytes als valid
    push af
    or d
    jr nz,lf487h
    ld a,e
    cp 12               ;Is absolute sector number is less than 12? (Why 12?, at 12 starts the passwords!)
    jr c,lf490h         ;  NO: It's not protected, read the sector

lf487h:
    ld a,(userid)
    or a
    ld a,error_92       ;"PRIVILEGED COMMAND"
    jp nz,error         ;only allowed for userid=0

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
    ld hl,(bufptr)
    ret

open_dir:
;Open a channel to the directory and create the output into a buffer
;
    set 2,(iy+028h)     ;Set marker for "Directory"
    set 7,(iy+028h)
    ld hl,getbuf+1
    call get_filename   ;Get a filename

lf4bah:
    ld a,(hl)           ;Get next character from command
    inc hl
    cp "H"              ;Is it a "H" for "show Hidden"?
    jr z,lf4c4h         ;  Yes: Jump and store
    cp cr               ;Is it a end marker?
    jr nz,lf4bah        ;  No: Jump and read next

lf4c4h:
    ld (dirhid),a       ;Store Marker for "Show Hidden"

    ld hl,filnam
    ld de,dirnam
    ld bc,16            ;BC=0010h (16 characters)
    ldir                ;Copy BC bytes from (HL) to (DE)

    ld a,(drvnum)
    ld (dirdrv),a       ;(dirdrv)=(drvnum)
    ld e,a
    ld d,0              ;DE=(drvnum)

    ld hl,dirout        ;HL=dirout
    ld (wrtprt),hl      ;(wrtprt)=HL

    ld (hl),01h
    inc hl              ;put start address (low from 0401h) into buffer
    ld (hl),04h
    inc hl              ;put start address (high from 0401h) into buffer

    inc hl
    inc hl              ;skip two bytes in buffer (unused link address)

    ld (hl),e
    inc hl              ;put drive number (low) into buffer
    ld (hl),0
    inc hl              ;put zero as drive number (high) into buffer

    ld (hl),rvs
    inc hl              ;put "rvs on" in buffer
    ld (hl),"""
    inc hl              ;put starting quote into buffer

    push de

    ex de,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld bc,drvnam
    add hl,bc           ;HL=drvnam+16*(drvnum) (16 characters for drive name)
    ld bc,16            ;BC=0010h (16 characters for drive name)
    ldir                ;Copy BC bytes from (HL) to (DE)
    ex de,hl

    ld (hl),"""
    inc hl              ;put ending quote in buffer
    ld (hl)," "
    inc hl              ;put a space as delimiter into buffer

    ex de,hl
    ld hl,drvid
    pop bc

    add hl,bc
    add hl,bc           ;HL=drvid+2*(drvnum) (2 characters for drive id)
    ld bc,2             ;BC=0002h (2 characters for drive id)
    ldir                ;Copy BC bytes from (HL) to (DE)
    ld hl,msg_space     ;" "
    ld bc,msg_space_end-msg_space
    ldir                ;Copy BC bytes from (HL) to (DE)
    ex de,hl

    ld a,(userid)
    push de
    ld de,0000h         ;DEA=(userid)
    call put_number     ;Put the user number as a number into buffer
    pop de

    ld (hl),0           ;put end of line (ascii 0) into buffer
    inc hl

    ld (endbuf),hl
    ld de,0401h         ;DE=0401h (Start address for BASIC program)
    add hl,de
    ld de,dirout+2
    or a
    sbc hl,de
    ld (dirout+2),hl
    ld (l25f4h),hl

    ld hl,0000h
    ld (dirnum),hl      ;(dirnum)=0

    ld hl,dirnam
    ld a,(hl)
    or a
    jp nz,le2aeh

    ld (hl),"*"         ;put asteriks in buffer
    inc hl

    ld (hl),0           ;put end of line (ascii 0) into buffer
    jp le2aeh

sub_f556h:
    ld hl,dirnam
    ld a,(dirdrv)
    call find_next
    jp c,lf623h         ;All entries readed? Yes: we are finish, write "Blocks free"

    bit 5,(ix+f_attr)   ;is marker for "Hide" set?
    jr z,lf570h         ;  No: show this entry
    ld a,(dirhid)
    cp "H"              ;Was a "Show hidden" command read?
    jp nz,sub_f556h     ;  No: Skip find next directory entry

lf570h:
    ld hl,dirout
    ld (wrtprt),hl

    inc hl
    inc hl              ;skip two bytes in buffer (unused link address)

    ld e,(ix+f_size+1)
    ld d,(ix+f_size+2)  ;DE=block size
    inc de              ;Increment block size
    ld (hl),e           ;Put low block size into buffer
    inc hl
    ld (hl),d           ;Put low block size into buffer
    inc hl

    ld b,3              ;B=03h (Check for 1000, 100, 10)
    ld iy,le5e7h        ;IY=le5e7h
lf589h:
    ld a,e
    cp (iy+0)
    ld a,d
    sbc a,(iy+1)        ;Is DE >= value to check?
    jr nc,lf59eh        ;Yes, all spaces are print, skip
    ld (hl)," "         ;Put a space into buffer
    inc hl
    inc iy
    inc iy
    inc iy              ;Move pointer IY to next value to check
    djnz lf589h         ;If not all checked, do it

lf59eh:
    ld (hl),"""
    inc hl              ;put starting quote into buffer

    push ix
    ld b,16             ;(16 characters for a filename)
lf5a5h:
    ld a,(ix+f_name)
    or a
    jr z,lf5b1h         ;end marker reached?
    ld (hl),a           ;put character from filename into buffer
    inc hl
    inc ix
    djnz lf5a5h

lf5b1h:
    ld (hl),"""
    inc hl              ;put ending quote into buffer

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
    bit 7,(ix+f_attr)   ;is marker for "Open File" set?
    jr z,lf5c9h
    ld (hl),"*"
lf5c9h:
    inc hl

    ex de,hl
    ld a,(ix+f_attr)    ;Get file type
    and 00000011b
    ld b,a
    add a,a
    add a,b             ;A=A*3
    ld c,a
    ld b,00h            ;BC=(file type) * 3
    ld hl,filetypes
    add hl,bc
    ld bc,3             ;file type has 3 characters
    ldir                ;Copy BC bytes from (HL) to (DE)
                        ;Copy file type into buffer
    ex de,hl

    ld (hl)," "         ;put a space as delimiter into buffer
    inc hl

    ld (hl),"-"         ;Minus for not write proteected
    bit 6,(ix+f_attr)   ;is marker for "Write Protect" set?
    jr z,lf5edh
    ld (hl),"W"
lf5edh:
    inc hl

    ld (hl),"-"         ;Minus for not global
    bit 4,(ix+f_attr)   ;is marker for "Global" set?
    jr z,lf5f8h
    ld (hl),"G"
lf5f8h:

    ld a,(dirhid)
    cp "H"
    jr nz,lf60ah
    inc hl

    ld (hl),"-"         ;minus for not hidden
    bit 5,(ix+f_attr)   ;is marker for "Hide" set?
    jr z,lf60ah
    ld (hl),"H"
lf60ah:
    inc hl

    ld (hl),0           ;put end of line (ascii 0) into buffer
    inc hl

    ld (endbuf),hl
    ld de,dirout
    or a
    sbc hl,de
    ld de,(l25f4h)
    add hl,de
    ld (dirout),hl
    ld (l25f4h),hl
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

    ld hl,usrnam        ;Current user name
    ld b,16             ;B=10h (16 characters for the user name)
lf63fh:
    ld a,(hl)           ;Get character from user name
    or a                ;Is end marker (ascii 0) detected?
    jr z,lf648h         ;  YES: break
    ld (de),a           ;  NO: put character into buffer
    inc hl
    inc de
    djnz lf63fh         ;Next character

lf648h:
    xor a               ;A=0
    ld (de),a           ;put end of line (ascii 0) into buffer
    inc de

    ld (de),a           ;put 0 as low byte of link address into buffer
    inc de

    ld (de),a           ;put 0 as high byte of link address into buffer
    inc de

    ld (endbuf),de

    dec de
    dec de
    ld hl,(l25f4h)

    add hl,de
    ld bc,dirout
    or a
    sbc hl,bc
    ld (dirout),hl

    ld hl,0000h
    ld (l25f4h),hl      ;(l25f4h)=0
    ret

filetypes:
    db "SEQ"
    db "USR"
    db "PRG"
    db "REL"

msg_space:
    db " "
msg_space_end:

msg_blk_free:
    db "BLOCKS FREE : "
msg_blk_free_end:

find_first:
;Find the first result from directory
;Returns carry set if file is not found, clear if found.
;
;See find_next
;
    ld de,0000h
    ld (dirnum),de      ;(dirnum)=0
                        ;Fall through into find_next

find_next:
;Find the next result from directory
;Returns carry set if file is not found, clear if found.
;
;  A = Drive Number (0..9)
; HL = Pattern for filename
;
    ld c,a
    ld (pattfn),hl

lf68fh:
    push bc
    call dir_get_next   ;Get the next directory entry into DE
    ld hl,(pattfn)
    pop bc
    ret c
    push ix
    pop iy
    bit 7,(iy+f_drvn)   ;Is entry valid?
    jr nz,lf68fh        ;  NO: check next entry
    bit 4,(iy+f_attr)   ;Is marker for "Global" set?
    jr nz,lf6aeh        ;  YES: found, check filename
    ld a,(iy+f_drvn)    ;Get drive number
    cp c                ;Equal with wanted drive number
    jr nz,lf68fh        ;  NO: check next entry

lf6aeh:
    ld b,16            ;B=10h (Maximum of 16 characters for filename)
lf6b0h:
    ld a,(hl)          ;Get character from wanted filename
    cp "*"             ;Compare with wildcard "*"
    ret z              ;  YES: Return with zero flag set for found
    cp "?"             ;Compare with wildcard "?"
    jr nz,lf6c0h       ;  NO: Must compare

    ld a,(iy+f_name)   ;Get character from directory filename
    or a               ;Is this the end marker?
    jr z,lf68fh        ;  YES: check next entry
    jr lf6c5h          ;  NO: check next character

lf6c0h:
    cp (iy+f_name)     ;Compare with character from directory filename
    jr nz,lf68fh       ;  NO: check next entry

lf6c5h:
    inc hl             ;Increment pointer in wanted filename
    inc iy             ;Increment pointer in directory filename
    or a               ;Is this the end marker?
    ret z              ;  YES: Return with zero flag set for found
    djnz lf6b0h        ;All 16 characters done? NO: do the next
    ret                ;Return with zero flag set for found

find_free:
;Find the first free directory entry.
;If nothing is left, give a "DISK FULL" error out.
;
    ld hl,0000h
    ld (dirnum),hl      ;(dirnum)=0

lf6d3h:
    call dir_get_next   ;Get the next directory entry into DE
    bit 7,(ix+f_drvn)   ;Is this entry free?
    ret nz              ;  YES: found and return

    inc de              ;Increment the directory entry number

    ld a,(maxdir)
    cp e
    jr nz,lf6d3h
    ld a,(maxdir+1)
    cp d                ;Is this number equal to the maximum of files?
    jr nz,lf6d3h        ;  NO: check the next entry
    ld a,error_72       ;"DISK FULL"
    jp error

dir_get_next:
;Get the next directory entry. Returns the entry number in DE.
;If all entries are passed, carry is set.
;
; (dirnum) = Current directory number
; (maxdir) = Maximal count of directory entries
;
    ld a,(drvcnf)
    or a
    ld a,error_84       ;" DRIVE NOT CONFIGURED"
    jp z,error

    ld hl,(dirnum)
    ld e,l
    ld d,h              ;DE=(dirnum)
    inc hl
    ld (dirnum),hl      ;(dirnum)=DE+1

    ld a,(maxdir)
    cp e
    jr nz,lf70bh
    ld a,(maxdir+1)
    cp d                ;If DE=(maxdir)?
    scf                 ;Set carry flag
    ret z               ;  YES: Return with carry set (All directory proceed)

lf70bh:
    ld a,e
    and 03h             ;A=DE mod 4
    jr nz,lf713h        ;Is this zero? NO: block must be read and exists in buffer
    call dir_read_sec   ;Else read the directory block

lf713h:
    ld ix,dirbuf
    ld a,e
    and 07h
    rrca
    rrca
    rrca
    ld c,a
    ld b,0
    add ix,bc           ;IX=dirbuf+(E Mod 8) * 32

    ld a,(ix+f_drvn)
    xor 0e5h            ;Is Drive Number equal 0e5h? (Unused directory entry)
    ret nz              ;  NO: return without carry set (All okay)
    scf                 ;  YES: Return with carry set (End of directory reached)
    ret

get_filename:
;Get a filename (max. 16 characters) from HL and store it. Read a heading drive number, too.
;
; HL = Pointer to command buffer
;
    ld a,(defdnu)       ;Get the defdnu as default, if we don't read it
    ld (drvnum),a       ;(drvnum)=(defdnu)

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
    inc hl              ;Skip the colon

lf743h:
    inc hl              ;Skip the device number
    ld a,e              ;Restore it
    sub "0"             ;Conver character to value
    ld (drvnum),a       ;Store it

lf74ah:
    ld b,16+1           ;B=11h (16 characters plus end marker or delimiter)
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

lf766h:                 ;Padding filename with ascii 0
    xor a               ;  A=0
    ld (de),a           ;Store it as filename
    inc de
    djnz lf766h         ;Loop all 17 Characters
    ret

find_drvlet:
;Find drive letter
;
; HL = Pointer to command buffer
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

check_wild:
;Check if the filename contains wildcards.
;Returns carry set if wildcards are found, carry clear if not.
;
    ld b,16             ;B = 16 characters in filename
    ld hl,filnam        ;HL = address of filename
cw1:
    ld a,(hl)           ;A = Get next char from filename

    cp "?"              ;Compare char to "?"
    scf                 ;Set carry
    ret z               ;Return with carry set if char is "?"

    cp "*"              ;Compare char to "*"
    scf                 ;Set carry
    ret z               ;Return with carry set if char is "*"

    djnz cw1            ;Decrement B, loop until all chars are checked
    or a                ;Clear carry (no wildcards found)
    ret

get_numeric:
;Get a number from HL and return in DEA
;
; HL = Pointer to command buffer
;
    ld a,(hl)           ;Get Character from buffer
    inc hl
    cp cr               ;Is the end marker?
    scf
    ret z               ;  Yes: return with carry set

    call is_digit       ;Check if character is a digit
    jr nc,get_numeric   ;  No: Jump, get next character

    ld de,0
    ld b,0              ;DEB=000000h

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
    ld e,0              ;DE=(sa)*256

    ld hl,al2bufs
    add hl,de
    ld (al2ptr),hl      ;(al2ptr)=al2bufs+DE

    ld hl,buffers
    add hl,de
    ld (bufptr),hl      ;(bufptr)=buffers+DE

    ld hl,al1bufs
    srl d
    rr e
    add hl,de
    ld (al1ptr),hl      ;(al1ptr)=al1bufs+DE/2

    ld iy,entbufs
    ld de,0029h
lf7f6h:
    ld (entptr),iy
    dec a
    or a
    ret m
    add iy,de
    jr lf7f6h

allocate_blk:
;Allocate a block
;
;BC=maximum sector allowed
;HL=Pointer to BAM table in memory
;
    push de             ;Save DE
    push bc             ;Save BC
    call chk_wrt_rights

    ld hl,0             ;HL=0000h (Start with sector 0)
lf809h:
    ld a,(de)           ;Get one byte with 8 bits for 8 sectors
    ld b,8              ;B=08h (8 bits for one byte)
lf80ch:
    rra                 ;Shift least bit into carry
    jr nc,lf815h        ;If it's not set, jump ...
    inc hl              ;Increment sector counter HL
    djnz lf80ch         ;Next bit? Yes, doit ...
    inc de              ;Increment Pointer DE for next byte
    jr lf809h           ;Check it

lf815h:
    scf                 ;Set the carry, because this block is now allocated
lf816h:
    rra                 ;Shift this carry into the right position
    djnz lf816h         ;All bits correct shifted? No, doit ...

    pop bc              ;Restore BC
    push hl             ;Save HL
    or a
    sbc hl,bc           ;Is sector counter HL greater than maximum value BC
    jp nc,lf825h        ;  YES: "DISK FULL"
    pop hl              ;Restore HL
    ld (de),a           ;Save the new byte with the allocated sector bit set
    pop de              ;Restore DE
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
    call loc1_read_sec  ;Read allocation 1 sector DE to (al1ptr)
    ld b,64             ;B=40 (64 ???)
    ld ix,(al1ptr)
lf83dh:
    ld e,(ix+0)
    ld d,(ix+1)         ;DE=(IX)
    bit 7,d
    jr nz,lf86ch
    push bc
    push de
    call loc2_read_sec

    ld b,128            ;B=80h (128 entries)
    ld iy,(al2ptr)

lf852h:
    ld l,(iy+0)
    ld h,(iy+1)         ;HL=(IY)
    ld de,l0457h        ;DE=l0457h (BAM table for data files)
    call clr_bam_bit    ;Clear a bit in a BAM table for data files (l0457h)

    inc iy
    inc iy
    djnz lf852h

    pop hl
    ld de,l0057h        ;DE=l0057h (BAM table for allocation 2 sectors)
    call clr_bam_bit    ;Clear a bit in a BAM table for allocation 2 sectors (l0057h)

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

set_bam_bit:
;Set a bit in a BAM table
;
; Inputs
;   HL = Sector number
;   DE = Starting address to BAM table in memory
;
    bit 7,h
    ret nz
    call calc_bam_pos   ;Calculate the position for a BAM entry
    or (hl)             ;Set bit with mask (HL mod 8)
    ld (hl),a
    ret

clr_bam_bit:
;Clear a bit in a BAM table
;
; Inputs
;   HL = Sector number
;   DE = Starting address to BAM table in memory
;
    bit 7,h
    ret nz
    call calc_bam_pos   ;Calculate the position for a BAM entry
    cpl
    and (hl)            ;Clear bit with mask (HL mod 8)
    ld (hl),a
    ret

calc_bam_pos:
;Calculate the position for a BAM entry
; Inputs
;   HL = Sector number
;   DE = Starting address to BAM table in memory
; Outputs
;   HL = Byte position in the BAM table
;    A = Bit position in the byte (0 = 00000001b .. 7 = 10000000b)
;
    push bc
    ld a,l
    push af             ;Save HL mod 8 on stack
    ld b,3
    call hl_shr_b       ;HL=HL/8
    add hl,de           ;HL=HL+DE
    pop af
    and 07h             ;Restore HL mod 8 from stack
    ld b,a
    ld a,00000001b      ;A=00000001b
    jr z,lf8a1h
lf89eh:
    rla                 ;Shift A left, (HL mod 8) times
    djnz lf89eh
lf8a1h:
    pop bc
    ret

sub_f8a3h:
    ld ix,l0457h        ;IX=l0457h (BAM table for data files)
    ld de,(l0034h)
    ld hl,0000h
lf8aeh:
    ld b,08h
    ld c,(ix+00h)
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

dir_read_sec:
;Read a directory sector from Corvus drive to dirbuf
;
;DE = Directory entry number
;
    push de
    push hl
    call calc_dir_sec   ;Calculate Directory sector
    call corv_read_sec  ;Reads a sector (256 bytes)
    pop hl
    pop de
    ret

dir_writ_sec:
;Write a directory sector to Corvus drive from dirbuf
;
;DE = Directory entry number
;
    push de
    push hl
    call chk_wrt_rights
    call calc_dir_sec   ;Calculate Directory sector
    call corv_writ_sec  ;Write a sector (256 bytes)
    pop hl
    pop de
    ret

calc_dir_sec:
;Calculate the absolute sector to read/write from the directory entry number DE
;
;DE = Directory entry number
;
;(phydrv) = Corvus device number
;(dirsrt) = Directory start sector
;
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
    adc a,0             ;ADE=dirsrt+DE

    ld hl,dirbuf
    ret

loc2_read_sec:
;Read allocation 2 sector DE with 256 bytes from Corvus hard drive to (al2ptr)
;
;DE = Allocation 2 sector number
;
    push de
    push hl
    call calc_loc2_sec  ;Calculate Allocation 2 sector
    call corv_read_sec  ;Reads a sector (256 bytes)
    pop de
    pop hl
    ret

loc2_writ_sec:
;Write allocation 2 sector DE with 256 bytes to Corvus drive drive from (al2ptr)
;
;DE = Allocation 2 sector number
;
    push de
    push hl
    call chk_wrt_rights
    call calc_loc2_sec  ;Calculate Allocation 2 sector
    call corv_writ_sec  ;Write a sector (256 bytes)
    pop de
    pop hl
    ret

calc_loc2_sec:
;Calculate the absolute sector to read/write from the Allocation 2 sector number DE
;
;DE = Allocation 2 sector number
;
;(phydrv) = Corvus device number
;(al2srt) = Allocation 2 start sector
;
    ld a,(phydrv)
    ld b,a              ;B=Corvus drive number

    ld hl,(al2srt)
    ld a,(al2srt+2)
    add hl,de
    ex de,hl
    adc a,0             ;ADE=al2srt + DE
    ld hl,(al2ptr)      ;HL=(al2ptr)
    ret

file_read_sec:
;Read a file sector
;
    push de
    push hl
    call calc_file_sec  ;Calculate the absolute sector to read from a file sector
    call corv_read_sec  ;Reads a sector (256 bytes)
    pop hl
    pop de
    ret

file_writ_sec:
;Write a file sector
;
    push de
    push hl
    call calc_file_sec  ;Calculate the absolute sector to write to a file sector
    call corv_writ_sec  ;Write a sector (256 bytes)
    pop hl
    pop de
    ret

calc_file_sec:
;Calculate the absolute sector to read/write from a file sector
;
;(phydrv) = Corvus device number
;(al1srt) = Allocation 1 sectors starts
;(al2srt) = Allocation 2 sectors starts
;(filsrt) = File sectors starts
;(bufptr) = target address
;
    push ix
    push iy             ;Save IX and IY

    ld a,(al1idx)       ;Get calculated Allocation 1 index number
    ld iy,(entptr)      ;IY=(entptr)
    cp (iy+f_al1x)      ;Is this index number identically to the processed index number from the direectory?
    jr z,lf98eh         ;  YES: Update the Allocation 1 sector is not needed

    ld (iy+f_al1x),a    ;Store the new Allocation 1 index number
    ld c,a
    ld b,0              ;BC(IY+f_al1x)

    ld ix,(al1ptr)
    add ix,bc
    add ix,bc           ;IX=(al1ptr)+2*BC

    ld e,(ix+0)
    ld d,(ix+1)         ;DE=(IX)
    ld a,e
    and d
    inc a
    push af
    call nz,loc2_read_sec
    pop af
    jr nz,lf98eh

    ld de,l0057h        ;DE=l0057h (BAM table for allocation 2 sectors)
    ld bc,(al2max)      ;BC=(al2max)
    call allocate_blk   ;Allocate a block in BAM table for allocation 2 sectors
    ld (ix+0),l
    ld (ix+1),h         ;(IX)=HL

    ld hl,(al2ptr)      ;HL=(al2ptr)
    ld b,00h            ;B=00h (256 bytes for 1 sector)
lf980h:
    ld (hl),0ffh        ;Fill all bytes with 0ffh
    inc hl
    djnz lf980h

    ld e,(iy+f_dirn+0)
    ld d,(iy+f_dirn+1)  ;DE=(IY+f_dirn)
    call loc1_writ_sec  ;Write allocation 1 sector DE with 128 bytes from (al1ptr)

lf98eh:
    ld a,(al2idx)
    ld c,a
    ld b,0              ;BC=(al2idx)
    ld ix,(al2ptr)
    add ix,bc
    add ix,bc           ;IX=(al2ptr)+2*BC
    ld l,(ix+0)
    ld h,(ix+1)         ;HL=(IX)

    ld a,l
    and h
    inc a
    jr nz,lf9cdh

    ld de,l0457h        ;DE=l0457h (BAM table for data files)
    ld bc,(l0034h)      ;BC=(l0034h)
    call allocate_blk   ;Allocate a block in BAM table for data files
    ld (ix+0),l
    ld (ix+1),h         ;(IX)=HL

    ld c,(iy+f_al1x)    ;C=(iy+f_al1x)
    ld b,0
    ld ix,(al1ptr)
    add ix,bc
    add ix,bc           ;IX=(al1ptr)+2*C

    ld e,(ix+0)
    ld d,(ix+1)         ;DE=(IX)
    call loc2_writ_sec  ;Write allocation 2 sector DE with 256 bytes from (al2ptr)

lf9cdh:
    ld ix,(al2ptr)
    ld a,(al2idx)
    add a,a
    ld e,a
    ld d,0              ;DE=(al2idx)*2
    add ix,de           ;IX=(al2ptr)+DE
    ld l,(ix+0)
    ld h,(ix+1)
    xor a               ;AHL=(IX)

    ld b,3              ;B=03h
lf9e3h:
    add hl,hl
    adc a,a
    djnz lf9e3h         ;AHL=AHL*8

    ld de,(l0d6ch)
    ld d,0
    add hl,de           ;HL=HL+(l0d6ch)

    ld de,(filsrt)
    add hl,de
    ex de,hl
    ld b,a
    ld a,(filsrt+2)
    adc a,b             ;ADE=(filsrt)+AHL

    ld hl,phydrv        ;HL=phydrv (target address)
    ld b,(hl)           ;B=Corvus drive number

    ld hl,(bufptr)      ;HL=(bufptr)

    pop iy
    pop ix              ;Restore IX and IY
    ret

loc1_read_sec:
;Read allocation 1 sector DE with 128 bytes to (al1ptr)
;
;      DE = Allocation 1 sector number (128 byte)
;
;(phydrv) = Corvus device number
;(al1srt) = Allocation 1 sectors starts at (al1srt)
;(al1ptr) = target address
;
    push hl
    push de
    push bc
    srl d
    rr e                ;DE=DE/2
    push af
    ld hl,(al1srt)
    ld a,(al1srt+2)     ;AHL=al1srt
    add hl,de
    adc a,0
    ex de,hl            ;ADE=AHL+DE

    ld hl,phydrv
    ld b,(hl)           ;B=Corvus drive number

    ld hl,rdbuf         ;HL=rdbuf as target
    call corv_read_sec  ;Reads a sector (256 bytes)
    pop af

    ld hl,rdbuf         ;HL=rdbuf is source
    ld bc,128           ;BC=0080h (128 bytes)
    jr nc,lfa2bh        ;First of second half? (DE mod 2)
    add hl,bc           ; SECOND: Add the size of one half

lfa2bh:
    ld de,(al1ptr)      ;Get target address
    ldir                ;Copy BC bytes from (HL) to (DE)
    pop bc
    pop de
    pop hl
    ret

loc1_writ_sec:
;Write allocation 1 sector DE with 128 bytes from (al1ptr)
;
;      DE = Allocation 1 sector number (128 byte)
;
;(phydrv) = Corvus device number
;(al1srt) = Allocation 1 sectors starts at (al1srt)
;(al1ptr) = source address
;
    push hl
    push de
    push bc
    call chk_wrt_rights
    srl d
    rr e                ;DE=DE/2
    ex af,af'
    ld hl,(al1srt)
    ld a,(al1srt+2)     ;AHL=al1srt
    add hl,de
    adc a,0
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
    ld bc,128           ;BC=0080h (128 bytes)
    jr nc,lfa61h        ;First of second half? (DE mod 2)
    add hl,bc           ; SECOND: Add the size of one half

lfa61h:
    ex de,hl
    ld hl,(al1ptr)      ;Get source address
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

head_read_sec:
;Read the header sector at user starting sector (usrsrt) from Corvus hard drive into hdrbuf
;
;(phydrv) = Corvus device number
;(usrsrt) = Absolute sector number
;
    ld a,(phydrv)
    ld b,a              ;B=Corvus drive number
    ld de,(usrsrt)
    ld a,(usrsrt+2)     ;ADE=usrsrt
    ld hl,hdrbuf
    jp corv_read_sec    ;Reads a sector (256 bytes)

head_writ_sec:
;Write the header sector at user starting sector (usrsrt) to Corvus hard drive from hdrbuf
;
;(phydrv) = Corvus device number
;(usrsrt) = Absolute sector number
;
    ld a,(phydrv)
    ld b,a              ;B=Corvus drive number
    ld de,(usrsrt)
    ld a,(usrsrt+2)     ;ADE=usrsrt
    ld hl,hdrbuf
    jp corv_writ_sec    ;Write a sector (256 bytes)

bam_read_sec:
;Read the BAM sector number (bamsec) from Corvus hard drive to bambuf
;
;(bamsec) = BAM Sector
;
    call calc_bam_sec   ;Calculate BAM sector
    jp corv_read_sec    ;Reads a sector (256 bytes)

bam_writ_sec:
;Write the BAM sector number (bamsec) to Corvus hard drive from bambuf
;
;(bamsec) = BAM sector number
;
    call calc_bam_sec   ;Calculate BAM sector
    jp corv_writ_sec    ;Write a sector (256 bytes)

calc_bam_sec:
;Calculate the absolute sector to read/write from the BAM sector number (bamsec)
;
;(bamsec) = BAM Sector
;
;(phydrv) = Corvus device number
;(bamsrt) = BAM start sector
;
    ld de,(bamsec)
    ld d,0              ;D=(bamsec)
    ld hl,(bamsrt)
    ld a,(bamsrt+2)     ;AHL=(bamsrt)
    add hl,de
    adc a,0
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

IF version != 291
corv_init:
;Initialize the Corvus hard drive controller
;
    ld a,0ffh           ;0ffh = byte that is an invalid command
    out (corvus),a      ;Send it to the controller

    ld b,255            ;B=0ffh
lfacfh:
    djnz lfacfh         ;Delay loop

    in a,(ppi2_pc)
    and dirc
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
    ld bc,0000h

lfaf2h:
    in a,(ppi2_pc)
    and ready
    jr z,lfaf2h         ;Wait until Corvus READY=high

    in a,(ppi2_pc)
    and dirc            ;Corvus DIRC
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
ENDIF

corv_read_sec:
IF version = 291
;Read a sector (256 bytes) from the Konan David Junior II controller
;Note: Use only Drive 0 (Register B is ignored)
;
; (l4a10h) = Sector address (20 bit address)
;       HL = DMA buffer address
;
    ld (l4a10h),de      ;Store the sector address to access from corv_send_para
    ld (l4a10h+2),a
    push hl             ;Store the DMA buffer address

    ld a,21h            ;21h = Read a sector (Type 2 command)
    call corv_send_cmd
    call corv_send_para ;Send sector address

    call corv_read_err  ;Check the status
    pop hl              ;Restore the DMA buffer address
    jr nz,corv_err      ;Handle error if occurred

    ld a,41h            ;41h = Read from buffer (Type 4 command)
    call corv_send_cmd

    ld b,00h            ;B = 0 (256 bytes to send)
l199fh:
    in a,(corvus)       ;Read data byte from the controller buffer
    ld (hl),a           ;Store it to local buffer
    inc hl
    ex (sp),hl          ;Short delay
    ex (sp),hl
    djnz l199fh         ;Do it for the next byte

    call corv_read_err  ;Check the status
    ret z               ;Return if no error

    ld (errtrk),a       ;Store error code as error track
    ld a,error_22       ;"READ ERROR"
    jp corv_err         ;Handle error code
ELSE
;Reads a sector (256 bytes) from the Corvus hard drive
;
;  B = Drive number
;ADE = Sector address (20 bit address)
; HL = DMA buffer address
;
    ld (tmpdrv),bc
    ld c,02h            ;02h = Read a sector (256 byte sector)
    call corv_send_cmd
    call corv_read_err
    jr nz,read_err

    ld bc,corvus        ;B=0 (counts 256)
                        ;C=corvus (io port)

lfb1ch:
    in a,(ppi2_pc)
    and ready
    jr z,lfb1ch         ;Wait until Corvus READY=high

    ini                 ;Reads from io port (C) to (HL), B is decremented
    jr nz,lfb1ch
    ret

read_err:
    and 00011111b
    ld (errtrk),a       ;Store error code as error track
    ld a,(tmpdrv+1)
    ld (errsec),a       ;Store drive number as error sector
    ld a,error_22       ;"READ ERROR"
    jp error_out        ;Writes the error message "READ ERROR" into the status buffer
ENDIF

corv_writ_sec:
IF version = 291
;Write a sector (256 bytes) to the Konan David Junior II controller
;Note: Use only Drive 0 (Register B is ignored)
;
; (l4a10h) = Sector address (20 bit address)
;       HL = DMA buffer address
;
    ld (l4a10h),de      ;Store the sector address to access from corv_send_para
    ld (l4a10h+2),a

    ld a,42h            ;42h = Write to buffer (Type 4 command)
    call corv_send_cmd

    ld b,00h            ;B = 0 (256 bytes to send)
l19c1h:
    ld a,(hl)           ;Get data byte from local buffer
    out (corvus),a      ;Send it to the controller buffer
    inc hl
    ex (sp),hl          ;Short delay
    ex (sp),hl
    djnz l19c1h         ;Do it for the next byte

    call corv_read_err  ;Check the status
    jr nz,corv_err      ;Handle error if occurred

    ld a,22h            ;22h = Write a sector (Type 2 command)
    call corv_send_cmd
    call corv_send_para ;Send sector address

    call corv_read_err  ;Check the status
    ret z               ;Return if no error

    ld (errtrk),a       ;Store error code as error track
    ld a,error_25       ;"WRITE ERROR"

corv_err:
    push af

    ld hl,(l4a10h)      ;Store sector address as error sector
    ld (errsec),hl
    ld a,(l4a10h+2)
    ld (errsec+2),a

    pop af
    jp error_out        ;Writes the error message "READ ERROR" into the status buffer
ELSE
;Write a sector (256 bytes) to the Corvus hard drive
;
;  B = Drive Number
;ADE = Sector address (20 bit address)
; HL = DMA buffer address
;
    ld (tmpdrv),bc
    ld c,03h            ;03h = Write a sector (256 byte sector)
    call corv_send_cmd

    ld bc,corvus        ;B=0 (counts 256)
                        ;C=corvus (io port)

lfb43h:
    in a,(ppi2_pc)
    and ready
    jr z,lfb43h         ;Wait until Corvus READY=high

    outi                ;Reads from (HL) to io port (C), B is decremented
    jr nz,lfb43h
    call corv_read_err
    ret z

    and 00011111b
    ld (errtrk),a       ;Store error code as error track
    ld a,(tmpdrv+1)
    ld (errsec),a       ;Store drive Number as error sector
    ld a,error_25       ;"WRITE ERROR"
    jp error_out        ;Writes the error message "WRITE ERROR" into the status buffer
ENDIF

IF version = 291
corv_send_cmd:
;Send the command to the Konan David Junior II controller
;
;  A = Command
;        01h = Abort command (unused)
;        02h = Init (unused)
;        07h = Init1 (unused)
;        21h = Read sector into buffer
;        22h = Write sector from buffer
;        23h = Read ID (unused)
;        24h = Status (unused)
;        25h = Drive status (unused)
;        26h = Format spare (unused)
;        27h = Format (unused)
;        28h = Seek (unused)
;        2Ah = Append Map (unused)
;        41h = Read from buffer
;        42h = Write into buffer
;
    ld b,a              ;Save the command

    xor a               ;00h = All before is done
    out (corvus),a      ;Send byte (00h) to the Konan David Junior II controller

l19f4h:
    in a,(corvus)       ;Read from Konan David Junior II controller
    cp 0a0h
    jr nz,l19f4h        ;Wait until readed data = 0a0h (Ready to received commands)

    ld a,b              ;Restore the command
    out (corvus),a      ;Send byte (command) to the Konan David Junior II controller

l19fdh:
    in a,(corvus)       ;Read from Konan David Junior II controller
    cp 0a1h
    jr nz,l19fdh        ;Wait until readed data = 0a1h (Has received the command)

    ld a,0ffh           ;0ffh = Allow to execute the command
    out (corvus),a      ;Send byte (0ffh) to the Konan David Junior II controller

    ld b,20             ;B=14h
l1a09h:
    nop
    djnz l1a09h         ;Delay loop (min. 50 us)

    ret

corv_read_err:
;Read the status code from the Konan David Junior II controller
;
;Returns the status code in A and also changes
;the Z flag: Z=1 if OK, Z=0 if hard error.
;
;The upper 3 bits of the error code are flags:
;
;  Bit 7: Clear if status is ready (will wait until is cleared).
;  Bit 6: Set if a hard error occurred.
;  Bit 5: Set if there was a recoverable error.
;
;The lower 5 bits of the error code are reserved for the code itself.
;
;  01 Header Read (Read)
;  02 Header Write (Write)
;  04 Data Read (Read)
;
;  20 Data Corrected (Read)
;
;  40 Header Read Error (Read)
;  41 Header Read ID Error (Read ID)
;  42 Header Write Error (Write)
;  43 Seek Error (Seek)
;  44 Data Read Error (Read)
;  45 Write Protected (Write)
;  46 Write Fault (Drive Select)
;  47 Drive Not Ready (Drive Select)
;  48 Out of Spares (Format)
;  49 Illegal Command (Command)
;  4A Accessed Spare Track Error (Read/Write)
;
    ld a,0ffh           ;0ffh = Request to Read status byte
    out (corvus),a      ;Send byte (0ffh) to the Konan David Junior II controller

l1a11h:
    in a,(corvus)       ;Read from Konan David Junior II controller
    inc a
    jr nz,l1a11h        ;Wait until readed data = 0ffh (controller no longer in its internal DMA mode)

    ld a,0feh           ;0feh = Read status byte
    out (corvus),a      ;Send byte (0feh) to the Konan David Junior II controller

l1a1ah:
    in a,(corvus)       ;Check if bit 7 (status byte is ready to read)
    rla
    jr c,l1a1ah         ;Wait until bit 7 is cleared (now status is ready)

    in a,(corvus)       ;Read the status byte from the Konan David Junior II controller
    bit 6,a             ;Test bit 6 for hard error
    push af

    xor a               ;00h = Acknowledge the status is readed
    out (corvus),a      ;Send byte (00h) to the Konan David Junior II controller

    pop af
    ret

corv_send_para:
;Send an eight bytes address block to the Konan David Junior II controller
;Note: Use only Drive 0 (Register B is ignored)
;
; (l4a10h) = Sector address (20 bit address)
;       HL = DMA buffer address
;
;Sample translating for 8 heads:
;  +2  Hi   +1  Mi   +0  Lo
; ----3210 76543210 76543210 (Only using 20 Bit)
;                      ^^^^^..: 0 ..   31 =   sector number (31 sectors for 256 bytes sectors)
;                   ^^^.......: 0 ..    7 =     head number (max. 8 heads are allowed)
;     ^^^^ ^^^^^^^^...........: 0 .. 4095 = cylinder number (can be up to 32000)
;
; 1. Byte:            Drive (0)
; 2. Byte:             Head (0 .. (l0133h))
; 3. and 4. Bytes: Cylinder ((l0134h) .. max. cylinder number)
; 5. Byte:           Sector (0 .. 31)
; 6. Byte:         Reserved (00h)
; 7. Byte:         Reserved (00h)
; 8. Byte:         Reserved (00h)
;
    xor a               ;Take a zero for the drive number
    out (corvus),a      ;Send 1. Byte (Drive number) to the Konan David Junior II controller

    ld hl,(l4a10h)
    ld a,(l4a10h+2)     ;AHL = (l4a10h)

    ld b,05h
l1a34h:
    rra
    rr h
    rr l
    djnz l1a34h         ;HL = AHL / 32

    ld a,(l0133h)
    inc a               ;A = (l0133h) + 1

    add a,a
    add a,a
    add a,a
    add a,a
    ld b,a
    ld c,00h            ;BC = A * 4096
    ld de,0000h         ;DE = 0000h
    ld a,13             ;A = 0dh (13 Loops)

                        ;DE = HL DIV ((l0133h) + 1)
                        ; L = HL MOD ((l0133h) + 1)
l1a4bh:
    ex de,hl
    add hl,hl
    ex de,hl            ;DE = DE * 2

    or a                ;1a4e b7
    sbc hl,bc           ;1a4f ed 42
    jr nc,l1a56h        ;1a51 30 03
    add hl,bc           ;1a53 09
    jr l1a57h           ;1a54 18 01
l1a56h:
    inc de              ;1a56 13
l1a57h:
    srl b
    rr c                ;BC = BC / 2
    dec a               ;A = A - 1
    jr nz,l1a4bh        ;1a5c 20 ed

    ld a,l              ;Take the low byte
    out (corvus),a      ;Send 2. Byte (Head number) to the Konan David Junior II controller

    ld hl,(l0134h)      ;Add to the cylinder count the starting cylinder value
    add hl,de           ;HL = (l0134h) + DE

    ld a,l              ;Take the low byte of the cylinder number
    out (corvus),a      ;Send 3. Byte (Cylinder number low byte) to the Konan David Junior II controller

    ld a,h              ;Take the high byte of the cylinder number
    out (corvus),a      ;Send 4. Byte (Cylinder number high byte) to the Konan David Junior II controller

    ld a,(l4a10h)       ;From the Sector address
    and 1fh             ;take the lowest five bits to generate the sector number
    out (corvus),a      ;Send 5. Byte (Sector number) to the Konan David Junior II controller

    xor a               ;All three reserved bytes are zero
    out (corvus),a      ;Send 6. Byte (Reserved) to the Konan David Junior II controller
    out (corvus),a      ;Send 7. byte (Reserved) to the Konan David Junior II controller
    out (corvus),a      ;Send 8. Byte (Reserved) to the Konan David Junior II controller
    ret
ELSE
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
    xor ready
    and dirc+ready
    jr nz,corv_read_err

    ld b,25             ;B=19h
lfb6bh:
    djnz lfb6bh         ;Delay loop

    in a,(ppi2_pc)
    xor ready
    and dirc+ready
    jr nz,corv_read_err
                        ;Fall through into corv_wait_read

corv_wait_read:
;Wait until Corvus READY=high, then a data byte from Corvus.
;
;Returns the data byte in A and sets the Z flag: Z=1 if OK, Z=0 if error.
;
    in a,(ppi2_pc)
    and ready           ;Mask off all but bit 4 (Corvus READY)
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
    and ready
    jr z,lfb94h         ;Wait until Corvus READY=high
    pop af
    out (corvus),a      ;Put byte on Corvus data bus
    ret

corv_park_heads:
;Park the heads from corvus hard drive (only used in version 2.3 and 2.4 for Corvus drives)
;
;A = Drive number
;
    push af
    ld hl,buffer13
    ld bc,512           ;BC=0200h (512 bytes)
    call calc_checksum
    cp 84h
    ld a,error_49
    jp nz,error

    ld a,11h            ;11h = Park Heads
    call corv_put_byte  ;Send first command byte
    pop af
    call corv_put_byte  ;Send second command byte (drive number for Get drive parameter - starts at 1)
    ld hl,buffer13
    ld bc,512           ;BC=0200h (Send 512 Bytes)
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
ENDIF

hl_shr_b:
;Shift B times HL right, so HL is divided by 2^B
;
    srl h
    rr l
    djnz hl_shr_b
    ret

error_txt:
    db error_00         ;"OK"
    db " O",80h+"K"

    db error_01         ;"FILES SCRATCHED"
    db t_file,"S SCRATCHE",80h+"D"

    db error_22         ;"READ ERROR"
    db t_read,80h+t_error

    db error_25         ;"WRITE ERROR"
    db t_write,80h+t_error

    db error_26         ;"WRITE PROTECTED"
    db t_write," PROTECTE",80h+"D"

    db error_30         ;"SYNTAX ERROR"
    db t_syntax,80h+t_error

    db error_31         ;"SYNTAX ERROR (INVALID COMMAND)"
    db t_syntax,t_error," (",t_invalid," ",t_command,80h+")"

    db error_32         ;"SYNTAX ERROR (LONG LINE)"
    db t_syntax,t_error," (LONG LINE",80h+")"

    db error_33         ;"SYNTAX ERROR(INVALID FILENAME)"
    db t_syntax,t_error,"(",t_invalid," ",t_file,t_name,80h+")"

    db error_34         ;"SYNTAX ERROR(NO FILENAME)"
    db t_syntax,t_error,"(NO ",t_file,t_name,80h+")"

    db error_50         ;"RECORD NOT PRESENT"
    db t_record,t_not," PRESEN",80h+"T"

    db error_51         ;"OVERFLOW IN RECORD"
    db "OVERFLOW IN ",80h+t_record

    db error_52         ;"FILE TOO LARGE"
    db t_file," TOO LARG",80h+"E"

    db error_60         ;"WRITE FILE OPEN"
    db t_write," ",t_file,80h+t_open

    db error_61         ;"FILE NOT OPEN"
    db t_file,t_not,80h+t_open

    db error_62         ;"FILE NOT FOUND"
    db t_file,t_not," FOUN",80h+"D"

    db error_63         ;"FILE EXISTS"
    db t_file," EXIST",80h+"S"

    db error_64         ;"FILE TYPE MISMATCH"
    db t_file," TYPE MISMATC",80h+"H"

    db error_65         ;"NO BLOCK"
    db "NO BLOC",80h+"K"

    db error_66         ;"ILLEGAL TRACK OR SECTOR"
    db "ILLEGAL TRACK OR SECTO",80h+"R"

    db error_72         ;"DISK FULL"
    db "DISK FUL",80h+"L"

    db error_84         ;" DRIVE NOT CONFIGURED"
    db t_drive,t_not," CONFIGURE",80h+"D"

    db error_89         ;"USER #"
    db t_user," ",80h+"#"

    db error_90         ;"INVALID USER NAME"
    db t_invalid," ",t_user," ",80h+t_name

    db error_91         ;"PASSWORD INCORRECT"
    db "PASSWORD INCORREC",80h+"T"

    db error_92         ;"PRIVILEGED COMMAND"
    db "PRIVILEGED ",80h+t_command

IF version != 291
    db error_93         ;"BAD SECTORS CORRECTED" (unused!)
    db "BAD SECTORS CORRECTE",80h+"D"

    db error_94         ;"LOCK ALREADY IN USE"
    db "LOCK ALREADY IN US",80h+"E"

IF version = 31         ;This is for a SUNOL Hard Drive
    db error_95         ;  "SUNOL DRIVE ERROR"
    db t_sunol,t_drive,80h+t_error

    db error_96         ;  "SUNOL DRIVE SIZE"
    db t_sunol,t_drive," SIZ",80h+"E"

    db error_98         ;  "VERSION #"
    db 80h+t_version
ELSE                    ;This is for a CORVUS Hard Drive
    db error_95         ;  "CORVUSDRIVE ERROR"
    db t_corvus,t_drive,80h+t_error

    db error_96         ;  "CORVUSDRIVE SIZE"
    db t_corvus,t_drive," SIZ",80h+"E"

    db error_97         ;  "CORVUS REV A VERSION #"
    db t_corvus," REV A",80h+t_version

    db error_98         ;  "CORVUS REV B VERSION #"
    db t_corvus," REV B",80h+t_version
ENDIF
ENDIF

    db error_99         ;"SMALL SYSTEMS HARDBOX VERSION #"
    db "SMALL SYSTEMS HARDBOX",80h+t_version

    db 0ffh             ;"UNKNOWN ERROR CODE"
    db "UNKNOWN",t_error," COD",80h+"E"

error_tok:
    db "FIL",80h+"E"       ;01h: "FILE"
    db "WRIT",80h+"E"      ;02h: "WRITE"
    db " ERRO",80h+"R"     ;03h: " ERROR"
    db "SYNTA",80h+"X"     ;04h: "SYNTAX"
    db "INVALI",80h+"D"    ;05h: "INVALID"
    db "COMMAN",80h+"D"    ;06h: "COMMAND"
    db "REA",80h+"D"       ;07h: "READ"
    db "NAM",80h+"E"       ;08h: "NAME"
    db "RECOR",80h+"D"     ;09h: "RECORD"
    db " OPE",80h+"N"      ;0ah: " OPEN"
    db " NO",80h+"T"       ;0bh: " NOT"
    db "USE",80h+"R"       ;0ch: "USER"
    db " VERSION ",80h+"#" ;0dh: " VERSION #"
IF version = 31            ;This is for a SUNOL Hard Drive
    db " DRIV",80h+"E"     ;  0eh: " DRIVE"
    db "SUNO",80h+"L"      ;  0fh: "SUNOL"
ELSE                       ;This is for a CORVUS Hard Drive
    db "DRIV",80h+"E"      ;  0eh: "DRIVE"
    db "CORVU",80h+"S"     ;  0fh: "CORVUS"
ENDIF

filler:
IF version = 291
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
ELSE
IF version = 24
    db 0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 0a9h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 0a8h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 050h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 02ch,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h,0ffh,000h,0ffh,000h,0ffh
    db 000h,0ffh,000h, 0ffh,000h,0ffh,000h
ELSE
IF version = 31
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
ENDIF
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
ENDIF
checksum:
IF version = 23
    db 0dfh
ENDIF
IF version = 24
    db 85h
ENDIF
IF version = 31
    db 32h
ENDIF
ENDIF
