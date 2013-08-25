; ------ CORVUS PUT/GET PROGRAM FOR CP/M -------
;		VERSION 1.3
;		  BY BRK
;
; -----------------------------------------------------
; SoftBox version 17/9/81 by KRF.   I/O ports etc. changed
; -----------------------------------------------------
;
; THIS PROGRAM PERFORMS THREE TASKS:
;
;    1. PUT:  TRANSFER A BLOCK OF CODE FROM MEMORY TO DISC.
;    2. GET:  TRANSFER A BLOCK OF CODE FROM DISC TO MEMORY.
;    3. FILL: FILL A CONTIGUOUS SECTION OF THE DISC WITH A
;	      SPECIFIED BYTE.
;
;--- COMMENTS ON PROGRAM INPUTS:
;
;	1.  THE DRIVE #, DISC ADDRESS, AND # OF SECTORS ARE ALL IN
;	    DECIMAL.  THE PROGRAM IS SETUP FOR 128 BYTE SECTORS.
;	    THE DISC ADDRESS IS A NUMBER FROM  0  TO  MAXSC-1.  THE
;	    PROGRAM IS SETUP TO CALCULATE MAXSC EITHER FROM DEFAULTS
;	    FOR THE REV A DRIVE OR BY READING IN THE STATUS STRING
;	    FROM THE REV B DRIVE.  FOR REFERENCE, NOTE THAT:
;
;		MAXSC-1 =	75743   (REV A DRIVE)
;				84879   (REV B 10MB DRIVE)
;			       153839	(REV B 20MB DRIVE)
;				44879	(REV B  5MB DRIVE)
;
;	2.  THE STARTING RAM ADDRESS IS IN HEX.
;	3.  A CONTROL-C INPUT IN RESPONSE TO THE PUT/GET/FILL QUERY
;	    WILL CAUSE A RETURN TO CP/M (WITHOUT RE-BOOTING).
;	4.  A CONTROL-C INPUT IN RESPONSE TO OTHER QUERYS WILL CAUSE
;	    A BRANCH TO THE PUT/GET/FILL QUERY.
;	5.  AN INVALID INPUT WILL EITHER BE IGNORED, CAUSE A REPEAT
;	    OF THE QUESTION, OR RESULT IN AN ERROR MESSAGE.
;	6.  THE FILL COMMAND IS CAPABLE OF FILLING THE ENTIRE DISC
;	    WITH A SPECIFIED BYTE.  HOWEVER, THIS WOULD TAKE NEARLY
;	    AN HOUR TO DO SO.  IT IS MAINLY USEFUL FOR FILLING
;	    SMALLER SECTIONS OF THE DISC (SUCH AS FILLING THE CP/M
;	    DIRECTORY AREAS WITH  0E5H  ).
;	7.  AFTER EACH SECTOR IS READ OR WRITTEN, THE CONSOLE STATUS
;	    IS CHECKED.  IF A CONTROL-C HAS BEEN ISSUED, THE DISC
;	    OPERATION WILL BE ABORTED.  IF SOME OTHER CHARACTER HAS
;	    BEEN HIT, A MESSAGE WILL BE DISPLAYED INDICATING THAT
;	    A DISC OPERATION IS STILL IN PROGRESS ( THIS IS USEFUL
;	    ON LONG   PUT   OR   FILL   OPERATIONS TO SHOW THAT
;	    SOMETHING IS REALLY HAPPENING).
;
;  NOTE:  THIS PROGRAM IS AN UPDATED VERSION OF PUTGET VERSION 1.0.
;	  MODIFICATIONS FROM THE OLDER VERSION INCLUDE:
;
;	1.  ADDITION OF THE   FILL  COMMAND.
;	2.  CHANGING THE READ/ WRITE COMMANDS TO THE NEW
;	    VARIABLE SECTOR SIZE COMMAND FORMAT INTRODUCED
;	    WITH "THE MIRROR".
;	3.  DOWNWARDS COMPATIBILITY WITH THE ORIGINAL 128 BYTE/SEC
;	    CONTROLLER CODE BY READING THE CONTROLLER CODE VERSION #
;	    AND PATCHING THE READ/WRITE COMMANDS APPROPRIATELY.
;	4.  CHANGING THE CALCULATION OF THE DISC SIZE TO USE THE
;	    STATUS COMMAND OF THE REV B CONTROLLER. (5/11/81)
;
;
;
; ---- CP/M EQUATES -----
;
BDOS	EQU	05	; BDOS ENTRY POINT
;
CR	EQU	0DH	; CARRIAGE RETURN
LF	EQU	0AH	; LINE FEED
;
; ---- CORVUS DISC EQUATES ----
;
DATA	EQU	18H	; DATA I/O PORT
STAT	EQU	16H	; STATUS INPUT PORT
DRDY	EQU	10H	; MASK FOR DRIVE READY BIT
DIFAC	EQU	20H	; MASK FOR DRIVE ACTIVE BIT
;
; --- DO NOT CHANGE RDCOM OR WRCOM WITHOUT ALSO CHANGING THE TEST
;     AT THE END OF THE INIT ROUTINE. ---
;
RDCOM	EQU	12H	; READ COMMAND (MIRROR COMPATIBLE)
WRCOM	EQU	13H	; WRITE COMMAND (MIRROR COMPATIBLE)
;
;
VERCOM	EQU	0	; COMMAND TO READ VERSION #
			;  AND # DRIVES (REV A)
NSTAT	EQU	10H	; REV B STATUS COMMAND
SSIZE	EQU	128	; SECTOR SIZE ( IN BYTES)
MAXDRV	EQU	4	; MAX # OF DRIVES
;
;
	ORG 100H	; STANDARD CP/M TPA ORIGIN
;
START:	LXI	H,0
	DAD	SP	; GET STACK POINTER IN (H,L)
	SHLD	SBUF	; SAVE IT
;   -- SETUP DIRECT CONSOLE I/O JUMPS ---
	LHLD	1	; GET ADDRESS OF WARM BOOT (BIOS+3)
	LXI	D,3
	DAD	D	; COMPUTE ADDRESS OF CONST
	SHLD	CONST+1	; PATCH IN JUMP
	DAD	D
	SHLD	CONIN+1
	DAD	D
	SHLD	CONOUT+1
	JMP	SIGNON	; SIGN ON AND START PROGRAM
;
CONST:	JMP	0	; JUMP TO BIOS ROUTINES
CONIN:	JMP	0
CONOUT:	JMP	0
;
SIGNON:	LXI	SP,STACK	;SETUP LOCAL STACK
	LXI	D,SMSG		;POINT TO MESSAGE
	CALL	PTMSG	; PRINT SIGN ON MESSAGE
PGQ:	LXI	D,PGMSG
	CALL	PTMSG	; ASK IF PUT OR GET
P1:	CALL	CIN	; GET CONSOLE CHAR.
	CPI	'C'-40H	; IS IT A CONTROL-C ?
	JNZ	PGQ1	; NO, SO CONTINUE
CEXIT:	LXI	D,CMSG	; YES, SO ISSUE MESSAGE AND EXIT PROGRAM
	CALL 	PTMSG
	LHLD	SBUF	; GET OLD STACK POINTER
	SPHL
	RET		; RE-ENTER CP/M
;
PGQ1:	CPI	'G'	; IS IT A GET COMMAND?
	MVI	B,RDCOM	; GET READ COMMAND
	JZ	PGQ2
	CPI	'P'	; IS IT A PUT COMMAND?
	MVI	B,WRCOM	; GET WRITE COMMAND
	JZ	PGQ2
	CPI	'F'	; IS IT A FILL COMMAND?
	JNZ	P1	; IF INVALID, GET ANOTHER CHAR.
PGQ2:	STA	COMD	; SAVE COMMAND FOR REF.
	MOV	A,B	; GET READ/ WRITE DISC COMMAND
	STA	RWCOM	; SAVE IT
	CALL	COUT	; ECHO VALID COMMAND
;
; --- GET DRIVE # ----
;
GTDRV:	LXI	D,DMSG
	CALL	PTMSG	; ASK FOR DRIVE #
GT1:	CALL	CIN
	CPI	'C'-40H	; IS IT A CONTROL-C
	JZ	PGQ	; YES, SO RESTART
	SUI	'0'	; REMOVE ASCII BIAS
	JC	GT1	; IF INVALID, GET ANOTHER CHAR
	JZ	GT1
	CPI	MAXDRV+1	; TEST IF DRIVE # TO LARGE
	JNC	GT1
	STA	DRIVE	; SAVE DRIVE #
	CALL	COUT	; ECHO CHARACTER
;
	CALL	INIT	; INIT CONTROLLER AND FIND DRIVE TYPE
;
; --- SETUP MAXIMUM 128 BYTE DISC ADDRESS ---
;
SETMAX:	CPI	8FH		; TEST RETURN CODE
	CZ	BSTAT1		; IF REV B DRIVE
	CNZ	REVAFIX		; IF REV A DRIVE
;
; --- COMPUTE OUTER SEEK ADDRESS ---
;
	LHLD	STATBF+37	; GET LOWER PART OF MAX BLOCK ADD
	LDA	STATBF+39	;  AND GET ITS UPPER BYTE
	DAD	H		; MULTIPLY BY 4 ( FOR 128 BYTE SEC)
	ADC	A
	DAD	H
	ADC	A
	SHLD	MAXSC		; SAVE MAX # OF 128 BYTE SECTORS
	STA	MAXSC+2
;
; -----
	LDA	COMD	; GET PUT, GET, FILL COMMAND
	CPI	'F'	; WAS IT A FILL COMMAND?
	JNZ	GTAD	; NO, SO ASSUME PUT OR GET
;
; --- GET FILL BYTE ---
;
GTFIL:	LXI	D,FMSG	; ASK FOR FILL BYTE
	CALL	PTMSG
	CALL	INHEX
	JC	GTFIL
	XRA	A
	CMP	H	; IS UPPER BYTE 0?
	JNZ	GTFIL	; NO, TRY AGAIN
	MOV	A,L	; GET BYTE
	STA	FILLB	; SAVE IT
	JMP	GTDAD
;
; --- GET DMA START ADDRESS ---
;
GTAD:	LXI	D,AMSG	; ASK FOR MEMORY ADDRESS
	CALL	PTMSG
	CALL	INHEX
	JC	GTAD	; IF ERROR, ASK AGAIN
	SHLD	RADD	; SAVE ADDRESS
;
; --- GET STARTING DISC ADDRESS (DECIMAL) ---
;
GTDAD:	LXI	D,DDMSG
	CALL	PTMSG	; ASK FOR DISC ADDRESS
	CALL	INDEC
	JC	GTDAD	; IF INVALID, ASK AGAIN
	LXI	H,CONV	; POINT TO CONVERSION BUFFER
	LXI	D,DADD	; POINT TO BUFFER FOR DISC ADDRESS
	CALL	COPY3	; COPY TO BUFFER
;
; --- GET # OF SECTORS ----
;
GTNS:	LXI	D,BMSG	; ASK FOR # OF SECTORS
	CALL	PTMSG
	CALL	INDEC
	JC	GTNS	; IF INVALID, ASK AGAIN
	LXI	H,CONV	; POINT TO CONVERSION BUFFER
	LXI	D,NBLKS	; POINT TO BUFFER FOR # OF SECTORS
	CALL	COPY3	; COPY TO BUFFER
	LXI	H,NBLKS+2	; POINT TO THIRD BYTE OF # SECTORS
	XRA	A	; CLEAR A
	ORA	M
	DCX	H
	ORA	M
	DCX	H
	ORA	M
	JZ	GTNS	; IF # SECTORS =0
;
	LXI	H,NBLKS
	LXI	D,DADD
	CALL	ADDM	; ADD # SEC AND DISC ADDRESS
	LXI	D,MAXSC
	LXI	H,ABUF	; SUBTRACT RESULT FROM MAX DISC ADD.+1
	CALL	SUBM
	JC	ROLD	; IF, TOO BIG
;
	LDA	COMD	; GET PUT, GET, FILL COMMAND
	CPI	'F'	; IS IT A FILL COMMAND?
	JZ	OK	; YES, SO TESTS ARE DONE
;
	LDA	NBLKS+2	; GET UPPER BYTE OF SECTOR COUNT
	ORA	A
	JNZ	ROLL	; IF FAR TOO BIG, ISSUE ERROR MESSAGE
	LXI	B,-1	; SETUP TO TEST IF MEMORY ROLLOVER
	LHLD	RADD	; GET RAM ADD
	LXI	D,SSIZE
GTN1:	DAD	D	; LOOP TO FIND # SECTORS THAT COULD FIT
	INX	B	; INC SECTOR COUNTER
	JNC	GTN1
	MOV	A,H
	ORA	L
	JNZ	GTN2	; IF NOT EXACTLY ZERO
	INX	B	; IF EXTRA SECTOR JUST FITS
GTN2:	LHLD	NBLKS	; COMPUTE #FIT-#SEC
	MOV	A,C
	SUB	L
	MOV	A,B
	SBB	H
	JNC	OK	; OK SO CONTINUE
ROLL:	LXI	D,RLMSG	; ERROR IF ROLL OVER TOP OF MEMORY
	CALL	PTMSG
	JMP	GTNS
ROLD:	LXI	D,RDMSG	; IF POSSIBLE ROLL OVER DISC TOP
	CALL	PTMSG
	JMP	GTNS
;
; -- INPUTS ARE NOW ASSUMED TO BE VALID, SO SETUP TO DO OPERATION
;
;--  MERGE UPPER DISC ADDRESS NIBBLE WITH DRIVE #
;
OK:	LDA	DADD+2
	ANI	0FH
	RLC
	RLC
	RLC
	RLC
	LXI	H,DRIVE
	ORA	M
	MOV	M,A
;
;
; --- DO BLOCK OPERATION ---
;
BLOCK:	LHLD	RADD	; GET RAM ADDRESS
	CALL	RWSEC	; READ OR WRITE ONE SECTOR
	SHLD	RADD
;
	CALL	CONST	; WAS A KEY HIT?
	ORA	A
	JNZ	BLK3	; YES, SO ISSUE MESSAGE OR ABORT
;
BLK1:	LHLD	NBLKS
	DCX	H
	SHLD	NBLKS
	MOV	A,H
	ORA	L
	JNZ	BLK2	; NOT DONE YET, SO CONTINUE
	LXI	H,NBLKS+2	; POINT TO UPPER BYTE OF SECTOR COUNT
	ORA	M	; TEST IF ZERO
	JZ	PGQ	; DONE, SO RETURN TO FIRST QUESTION
	DCR	M	; DECREMENT COUNT AND CONTINUE
BLK2:	LHLD	DADD	; GET DISC ADDRESS
	LXI	D,1
	DAD	D
	SHLD	DADD	; UPDATE IT
	JNC	BLOCK	; DO ANOTHER SECTOR
	LDA	DRIVE
	ADI	10H	; IF CARRY, INCREMENT ADDRESS NIBBLE
	STA	DRIVE
	JMP	BLOCK
;
BLK3:	CALL	CONIN	; GET INPUT CHAR.
	ANI	5FH	; MASK TO UPPER CASE
	CPI	'C'-40H	; IS IT A CONTROL-C?
	LXI	D,MSG1	; POINT TO MESSAGE
	JNZ	BLK4
	LXI	D,MSG2	; POINT TO MESSAGE
BLK4:	PUSH	PSW	; SAVE FLAGS
	CALL	PTMSG	; PRINT MESSAGE
	POP	PSW	; RESTORE FLAGS
	JNZ	BLK1		; RETURN IF NOT CONTROL-C
	JMP	PGQ	; RESTART MENU SELECTION
;
RWSEC:	LDA	RWCOM	; GET COMMAND
	CALL	WAITO	; WAIT AND SEND IT
	LDA	DRIVE	; GET DRIVE #
	CALL	WAITO
	LDA	DADD	; GET LOW BYTE OF DISC ADDRESS
	CALL	WAITO
	LDA	DADD+1	; GET UPPER BYTE OF DISC ADDRESS
	CALL	WAITO
	LDA	COMD	; GET COMMAND
	CPI	'F'	; WAS IT A FILL COMMAND?
	JZ	FILL	; YES, SO FILL A SECTOR
	CPI	'P'	; WAS IT A PUT COMMAND?
	JZ	WRIT	; YES, SO WRITE A SECTOR
RWSC1:	CALL	WERR	; NO, SO ASSUME READ AND GET ERROR CODE
RSEC:	MVI	B,SSIZE
RLP:	IN	STAT	; READ STATUS PORT
	ANI	DRDY	; LOOK AT READY LINE
	JZ	RLP	; LOOP UNTIL READY
	IN	DATA	; READ BYTE FROM DISC
	MOV	M,A	; SAVE IT IN MEMORY
	INX	H
	DCR	B	; DECREMENT BYTE COUNT
	JNZ	RLP	; LOOP UNTIL DONE
	RET
;
FILL:	MVI	B,SSIZE
	LDA	FILLB	; GET FILL BYTE
	MOV	C,A	; INTO (C)
FLP:	IN	STAT	; READ STATUS PORT
	ANI	DRDY
	JZ	FLP
	MOV	A,C	; GET FILL BYTE
	OUT	DATA	; WRITE IT TO DISC
	DCR	B
	JNZ	FLP	; LOOP UNTIL DONE
	JMP	WERR
;
WRIT:	MVI	B,SSIZE
WLP:	IN	STAT	; READ STATUS PORT
	ANI	DRDY
	JZ	WLP
	MOV	A,M	; GET BYTE FROM MEMORY
	OUT	DATA	; WRITE IT TO DISC
	INX	H
	DCR	B
	JNZ	WLP	; LOOP UNTIL DONE
WERR:	CALL	TURN	; TURN AROUND BUSS
	CALL	WAITI	; WAIT FOR ERROR BYTE
	MOV	B,A	; SAVE BYTE
	ANI	80H	; LOOK FOR FATAL ERRORS
	RZ		; OK, SO RETURN
	PUSH	B	; SAVE ERROR
	LXI	D,ERMSG	; ERROR, SO ISSUE MESSAGE
	CALL	PTMSG
	POP	PSW	; GET ERROR BYTE BACK IN ACC
	CALL	HEXOT	; OUTPUT IN HEX
	LXI	D,ERMSG1
	CALL	PTMSG
	JMP 	SIGNON	; RESTART PROGRAM
;
TURN:	IN	STAT
	ANI	DIFAC	; LOOK AT BUSS ACTIVE BIT
	JNZ	TURN
	MVI	B,6	; GOOD AT 4MHZ ALSO
DELAY:	DCR	B
	JNZ	DELAY
	RET
;
WAITI:	IN	STAT	; READ STATUS PORT
	ANI	DRDY	; LOOK AT READY LINE
	JZ	WAITI	; LOOP UNTIL READY
	IN	DATA	; READ BYTE FROM DISC
	RET
;
WAITO:	PUSH	PSW	; SAVE COMMAND
	IN	STAT	; READ STATUS PORT
	ANI	DRDY	; LOOK AT READY LINE
	JZ	WAITO+1	; LOOP UNTIL READY
	POP	PSW
	OUT	DATA	; WRITE BYTE TO DISC
	RET
;
;-- INITIALIZE CONTROLLER ----
;
INIT:	MVI	A,0FFH	; GET AN INVALID COMMAND
	OUT	DATA	; SEND IT TO CONTROLLER
	MVI	B,150	; SET FOR LONG DELAY
	CALL	DELAY
	IN	STAT
	ANI	DIFAC	; LOOK AT DRIVE ACTIVE BIT
	JNZ	INIT	; LOOP UNTIL NOT ACTIVE
	CALL	WAITI	; GET ERROR CODE
	CPI	8FH	; CHECK RETURN CODE
	JNZ	INIT	; IF NOT RIGHT, TRY AGAIN
;
; --- TEST DRIVE TYPE AND REV A CODE VERSION # ---
;
VCHK:	MVI	A,VERCOM ; GET A ZERO
	CALL	WAITO	; SEND IT
	CALL	TURN	; WAIT FOR ACCEPTANCE
	CALL	WAITI	; GET ANSWER
	STA	SRTN
	MOV	B,A	; SAVE IT
	ANI	0F0H	; MASK OUT DRIVE # AND TEST VERSION #
	MOV	A,B	; GET CODE BACK
	RNZ		; NOT VERS. 0   SO RETURN
	LDA	RWCOM	; GET READ/ WRITE COMMAND
	ANI	0FH	; MASK TO REV 0 CONTROLLER CODE VERSION
	STA	RWCOM	; RESAVE IT
	MOV	A,B	; GET CODE BACK
	RET
;
; --- SET REV A EQUIV. STATUS INFORMATION ---
;
REVAFIX: LDA	SRTN	; GET RETURN CODE
	CPI	8FH	; REV B DRIVE ?
	RZ		; YES, SO EXIT
	PUSH	PSW
	LXI	H,REVADTA ; POINT TO REV A DATA
	LXI	D,STATBF+33 ; SET DESTINATION
	MVI	C,7	; LENGTH OF TABLE TO MOVE
	CALL	COPY	; DO IT
	POP	PSW	; RESTORE RTN CODE
	RET
;
;
; --- READ REV B STATUS STRING ---
;
BSTAT1:	MVI	A,NSTAT		; GET STATUS COMMAND
	CALL	WAITO
	LDA	DRIVE
	CALL	WAITO
;
	LXI	H,STATBF	; SET BUFFER ADDRESS
	CALL	RWSC1		; USE R/W ROUTINE TO GET DATA
	LXI	H,STATBF+33	; POINT TO #SECTORS/TRACK
	XRA	A
	CMP	M		; IS VALUE 0 (BUG IN EARLY ROM)
	RNZ			; NO, SO RETURN
	MVI	M,20		; YES, SO FIX IT
	RET
;
;
; --- COPY ROUTINE ---
;
COPY3:	MVI	C,3
COPY:	MOV	A,M
	STAX	D
	INX	H
	INX	D
	DCR	C
	JNZ	COPY
	RET
;
; --- MULTI BYTE ADDITION ---
;  (H,L) AND (D,E) POINT TO ADDENDS
;  RESULT IS PUT IN CONVERSION BUFFER: ABUF
;
ADDM:	PUSH	H
	PUSH	D
	PUSH	B
	LXI	B,ABUF	; DESTINATION ADDRESS
	PUSH	B
	MVI	C,3	; ARITHMETIC PRECISION
	XRA	A	; CLEAR FLAGS
AD1:	LDAX	D
	ADC	M
	XTHL
	MOV	M,A	; SAVE RESULT IN BUFFER
	INX	H
	XTHL
	INX	H
	INX	D
	DCR	C
	JNZ	AD1	; LOOP UNTIL DONE
	POP	B
	POP	B
	POP	D
	POP	H
	RET
;
; --- MULTI BYTE SUBTRACTION ---
;  (D,E) POINTS TO THE MINUEND
;  (H,L) POINTS TO THE SUBTRAHEND
;  [D,E]-[H,L]
;  RESULT IS PUT IN CONVERSION BUFFER: ABUF
;
SUBM:	PUSH	H
	PUSH	D
	PUSH	B
	LXI	B,ABUF	; DESTINATION ADDRESS
	PUSH	B
	MVI	C,3	; ARITHMETIC PRECISION
	XRA	A	; CLEAR FLAGS
SD1:	LDAX	D
	SBB	M
	XTHL
	MOV	M,A	; SAVE RESULT IN BUFFER
	INX	H
	XTHL
	INX	H
	INX	D
	DCR	C
	JNZ	SD1	; LOOP UNTIL DONE
	POP	B
	POP	B
	POP	D
	POP	H
	RET
;
CIN:	PUSH	H	; BUFFERED CONSOLE INPUT
	PUSH	D
	PUSH	B
	CALL	CONIN
	POP	B
	POP	D
	POP	H
	MOV	C,A	; SAVE FOR ECHO
	CPI	60H	; IS IT LOWER CASE?
	RC		; NO, SO RETURN
	ANI	5FH	; YES, SO CONVERT TO UPPER CASE
	RET
;
COUT:	PUSH	PSW	; SAVE ACC
	PUSH	H	; BUFFERED CONSOLE OUTPUT
	PUSH	D
	PUSH	B
	CALL	CONOUT
	POP	B
	POP	D
	POP	H
	POP	PSW
	RET
;
; --- MESSAGE PRINT ROUTINE---
;
PTMSG:	MVI	C,9	; CP/M WRITE LIST COMMAND
	CALL	BDOS
	RET
;
; --- OUTPUT BYTE IN ACC IN HEX ---
;
HEXOT:	PUSH	PSW	; SAVE BYTE
	RRC		; SHIFT UPPER NIBBLE DOWN
	RRC
	RRC
	RRC
	CALL	HEXB	; OUTPUT UPPER NIBBLE IN HEX
	POP	PSW	; GET BYTE BACK
HEXB:	ANI	0FH	; MASK OFF UPPER NIBBLE
	ADI	'0'	; ADD ASCII BIAS
	CPI	'9'+1	; TEST IF NUMERIC
	JC	PRT	; YES, SO DO IT
	ADI	7	; NO, SO ADD BIAS FOR A-F
PRT:	MOV	C,A	; SETUP FOR OUTPUT
	JMP	COUT	; OUTPUT HEX NIBBLE
;
;  --- HEX INPUT ROUTINE ----
;
INHEX:	LXI	H,0	; CLEAR CONVERSION REGISTER
H1:	CALL	CIN	; GET CHAR.
	CPI	'C'-40H
	JZ	RT1
	CPI	' '	; IS IT A SPACE
	JZ	H1	; IGNORE IT
	CPI	CR	; IS IT A CR
	JNZ	HEX2
	ORA	A	; CLEAR FLAGS
	RET
HEX2:	CALL	COUT	; ECHO CHARACTER
	SUI	'0'	; REMOVE ASCII BIAS
	RC
	CPI	'G'-'0'
	CMC
	RC
	CPI	10
	JC	HEX1
	SUI	7	; ADJUST FOR A-F CHARACTERS
	CPI	10
	RC
HEX1:	DAD	H	; SHIFT 16 BIT REGISTER OVER 4 PLACES
	DAD	H
	DAD	H
	DAD	H
	ADD	L	; ADD IN NEW NIBBLE
	MOV	L,A
	JMP	H1
RT1:	POP	PSW	; CLEAR RETURN ADDRESS FROM STACK
	JMP	PGQ	; RETURN TO INITIAL QUERY
;
;--- 3 BYTE DECIMAL INPUT ROUTINE ---
;   THE BINARY RESULT IS SAVED IN THE CONVERSION BUFFER: CONV
;
INDEC:	LXI	H,CONV
	CALL	ZERO3	; CLEAR BUFFER
IN1:	CALL	CIN	; GET CHAR.
	CPI	'C'-40H
	JZ	RT1
	CPI	' '
	JZ	IN1	; IGNORE SPACES
	CPI	CR	; IS IT A CR?
	JNZ	DEC2
	LXI	D,CONV
	LXI	H,MAXSC
	CALL	SUBM	; TEST IF # IS TOO BIG
	CMC
	RNC
BIG:	LXI	D,BGMSG
	CALL	PTMSG	; ISSUE ERROR MESSAGE
	STC
	RET
DEC2:	CALL	COUT	; ECHO CHARACTER
	SUI	'0'	; REMOVE ASCII BIAS
	RC
	CPI	10
	CMC
	RC
DEC1:	STA	CONVX	; SAVE CHAR
	LXI	H,CONV
	LXI	D,CONV
	CALL	ADDM	; DOUBLE BUFFER VALUE
	LXI	H,ABUF
	LXI	D,ABUF
	PUSH	D
	CALL	ADDM	; DOUBLE IT AGAIN
	LXI	D,CONV
	CALL	ADDM	; NOW 5X STARTING VALUE
	POP	D
	CALL	ADDM	; NOW 10X STARTING VALUE
	LXI	D,CONVX
	CALL	ADDM	; ADD IN NEW UNITS DIGIT VALUE
	JC	BIG	; IF CARRY OUT OF THIRD BYTE
	LXI	D,CONV
	CALL	COPY3	; COPY TOTAL BACK TO CONV
	JMP	IN1	; LOOP FOR MORE
;
ZERO3:	MVI	C,3
ZERO:	MVI	M,0
	INX	H
	DCR	C
	JNZ	ZERO
	RET
;
; ---- MESSAGES ----
;
SMSG:	DB CR,LF,' --- CORVUS PUT/GET ROUTINE ---'
	DB CR,LF,'         ( VERSION 1.3 )',CR,LF,'$'
;
PGMSG:	DB CR,LF,'  PUT, GET, OR FILL (P/G/F) ? $'
;
DMSG:	DB CR,LF,'              DRIVE # (1-4) ? $'
;
AMSG:	DB CR,LF,'   STARTING HEX RAM ADDRESS ? $'
;
FMSG:	DB CR,LF,' HEX BYTE TO FILL DISC WITH ? $'
;
DDMSG:	DB CR,LF,'      STARTING DISC ADDRESS ? $'
;
BMSG:	DB CR,LF,'          NUMBER OF SECTORS ? $'
;
MSG1:	DB CR,LF,CR,LF,' DISC OPERATION IN PROGRESS ',CR,LF,'$'
;
MSG2:	DB CR,LF,CR,LF,' -- DISC OPERATION ABORTED --',CR,LF,CR,LF,'$'
;
BGMSG:	DB CR,LF,CR,LF,07,' -- NUMBER IS TOO BIG -- ',CR,LF,'$'
;
RLMSG:	DB CR,LF,CR,LF,07,' -- THIS WOULD ROLL OVER THE TOP OF MEMORY --'
	DB CR,LF,'$'
;
RDMSG:	DB CR,LF,CR,LF,07,' -- THIS WOULD EXCEED DISC SIZE --',CR,LF,'$'
;
ERMSG:	DB CR,LF,CR,LF,07,' ** DISC R/W ERROR # $'
;
ERMSG1:	DB 'H **',CR,LF,'$'
;
CMSG:	DB '^C',CR,LF,'$'
;
; --- FAKE COPY OF DATA FOR REV A STATUS STRING ---
;
REVADTA: DB	18	; # SECTORS/TRACK
	DB	3	; # HEADS
	DW	350	; # OF CYLINDERS
	DW	18936	; # OF 512 BYTE SECTORS
	DB	0
;
; ---- BUFFERS AND DATA ----
;
MAXSC:	DS	3	; BUFFER FOR MAXIMUM DISC ADDRESS
;
CONVX:	DB	0	; BUFFER FOR INDEC ROUTINE
	DB	0
	DB	0
;
SBUF:	DS	2	; OLD STACK POINTER
RWCOM:	DS	1	; R/W COMMAND
COMD:	DS	1	; FUNCTION COMMAND (G, P, OR F)
DRIVE:	DS	1	; DRIVE # AND UPPER DISC ADDRESS NIBBLE
RADD:	DS	2	; RAM ADDRESS FOR DMA
DADD:	DS	3	; DISC ADDRESS
NBLKS:	DS	3	; # DISC SECTORS TO R/W
CONV:	DS	3	; CONVERSION BUFFER FOR INDEC
ABUF:	DS	3	; BUFFER FOR ADDM AND SUBM
FILLB:	DS	1	; FILL BYTE
SRTN:	DS	1	; BUFFER FOR RETURN CODE
STATBF:	DS	130	; BUFFER FOR STATUS STRING
	DS	80	; STACK SPACE
STACK:	NOP
;
	END