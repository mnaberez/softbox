;KLIB.VUE
;
;       All numbers in hex.  Suffix conventions:
;       '       code relative reference
;       "       data relative reference
;       !       COMMON relative reference
;       blank   absolute reference
;
;       Default origin
        CSEG
        ORG     0H
;
        NAME    ('XSTRIN')
        GLOBAL  $CHR
        GLOBAL  $PV0D
        GLOBAL  $PV1D
        GLOBAL  $PV2D
        GLOBAL  $HEX
;       Module DATA segment size is 05H bytes
;       Module CODE segment size is 070H bytes
        DEFB    03EH    ;00H'           '>'      LD A,
        DEFB    020H    ;01H'           ' '      JR NZ,
        DEFB    0CDH    ;02H'           'M'      CALL
        DEFB    00H     ;03H'                    NOP
        DEFB    00H     ;04H'                    NOP
        DEFB    0C9H    ;05H'           'I'      RET
        DEFB    03EH    ;06H'           '>'      LD A,
        DEFB    0AH     ;07H'                    LD A,(BC)
        DEFB    0CDH    ;08H'           'M'      CALL
        DEFW    03H'    ;09H'
        DEFB    03EH    ;0BH'           '>'      LD A,
        DEFB    0DH     ;0CH'                    DEC C
        DEFB    0CDH    ;0DH'           'M'      CALL
        DEFW    09H'    ;0EH'
        DEFB    0C9H    ;010H'          'I'      RET
        DEFB    03EH    ;011H'          '>'      LD A,
        DEFB    02H     ;012H'                   LD (BC),A
        DEFB    032H    ;013H'          '2'      LD (...),A
        DEFW    00H"    ;014H'
        DEFB    07DH    ;016H'          '}'      LD A,L
        DEFB    0CDH    ;017H'          'M'      CALL
        DEFW    028H'   ;018H'
        DEFB    032H    ;01AH'          '2'      LD (...),A
        DEFW    03H"    ;01BH'
        DEFB    07DH    ;01DH'          '}'      LD A,L
        DEFB    0CDH    ;01EH'          'M'      CALL
        DEFW    02CH'   ;01FH'
        DEFB    032H    ;021H'          '2'      LD (...),A
        DEFW    04H"    ;022H'
        DEFB    021H    ;024H'          '!'      LD HL,
        DEFW    00H"    ;025H'
        DEFB    0C9H    ;027H'          'I'      RET
        DEFB    0FH     ;028H'                   RRCA
        DEFB    0FH     ;029H'                   RRCA
        DEFB    0FH     ;02AH'                   RRCA
        DEFB    0FH     ;02BH'                   RRCA
        DEFB    0E6H    ;02CH'          'f'      AND
        DEFB    0FH     ;02DH'                   RRCA
        DEFB    0FEH    ;02EH'          '~'      CP
        DEFB    0AH     ;02FH'                   LD A,(BC)
        DEFB    0FAH    ;030H'          'z'      JP M,
        DEFW    035H'   ;031H'
        DEFB    0C6H    ;033H'          'F'      ADD A,
        DEFB    07H     ;034H'                   RLCA
        DEFB    0C6H    ;035H'          'F'      ADD A,
        DEFB    030H    ;036H'          '0'      JR NC,
        DEFB    0C9H    ;037H'          'I'      RET
        DEFB    03EH    ;038H'          '>'      LD A,
        DEFB    01H     ;039H'                   LD BC,
        DEFB    032H    ;03AH'          '2'      LD (...),A
        DEFW    00H"    ;03BH'
        DEFB    07DH    ;03DH'          '}'      LD A,L
        DEFB    032H    ;03EH'          '2'      LD (...),A
        DEFW    03H"    ;03FH'
        DEFB    021H    ;041H'          '!'      LD HL,
        DEFW    00H"    ;042H'
        DEFB    0C9H    ;044H'          'I'      RET
        DEFB    07EH    ;045H'          '~'      LD A,(HL)
        DEFB    0B7H    ;046H'          '7'      OR A
        DEFB    0CAH    ;047H'          'J'      JP Z,
        DEFW    06H'    ;048H'
        DEFB    0CDH    ;04AH'          'M'      CALL
        DEFW    062H'   ;04BH'
        DEFB    0C3H    ;04DH'          'C'      JP
        DEFW    06H'    ;04EH'
        DEFB    07EH    ;050H'          '~'      LD A,(HL)
        DEFB    0B7H    ;051H'          '7'      OR A
        DEFB    0C8H    ;052H'          'H'      RET Z
        DEFB    0CDH    ;053H'          'M'      CALL
        DEFW    062H'   ;054H'
        DEFB    0C9H    ;056H'          'I'      RET
        DEFB    07EH    ;057H'          '~'      LD A,(HL)
        DEFB    0B7H    ;058H'          '7'      OR A
        DEFB    0CAH    ;059H'          'J'      JP Z,
        DEFW    00H'    ;05AH'
        DEFB    0CDH    ;05CH'          'M'      CALL
        DEFW    062H'   ;05DH'
        DEFB    0C3H    ;05FH'          'C'      JP
        DEFW    00H'    ;060H'
        DEFB    047H    ;062H'          'G'      LD B,A
        DEFB    023H    ;063H'          '#'      INC HL
        DEFB    023H    ;064H'          '#'      INC HL
        DEFB    023H    ;065H'          '#'      INC HL
        DEFB    07EH    ;066H'          '~'      LD A,(HL)
        DEFB    0CDH    ;067H'          'M'      CALL
        DEFW    0EH'    ;068H'
        DEFB    05H     ;06AH'                   DEC B
        DEFB    023H    ;06BH'          '#'      INC HL
        DEFB    0C2H    ;06CH'          'B'      JP NZ,
        DEFW    066H'   ;06DH'
        DEFB    0C9H    ;06FH'          'I'      RET
        DSEG
        ORG     00H
        ORG     05H
$CHR    EQU     038H'
$HEX    EQU     011H'
$PV0D   EQU     057H'
$PV1D   EQU     050H'
$PV2D   EQU     045H'
        EXTERNAL CONOUT ;Chain head at 068H'
        END

        NAME    ('BDOS')
        GLOBAL  BDOS
;       Module DATA segment size is 00H bytes
;       Module CODE segment size is 05H bytes
        DEFB    0AH     ;00H'                    LD A,(BC)
        DEFB    04FH    ;01H'           'O'      LD C,A
        DEFB    0C3H    ;02H'           'C'      JP
        DEFB    05H     ;03H'                    DEC B
        DEFB    00H     ;04H'                    NOP
BDOS    EQU     00H'
        END

        NAME    ('DIV1')
        GLOBAL  $IDVD
        GLOBAL  $IDVA
        GLOBAL  $IDVB
        GLOBAL  $IDVE
;       Module DATA segment size is 00H bytes
;       Module CODE segment size is 03EH bytes
        DEFB    0EBH    ;00H'           'k'      EX DE,HL
        DEFB    0E1H    ;01H'           'a'      POP HL
        DEFB    04EH    ;02H'           'N'      LD C,(HL)
        DEFB    023H    ;03H'           '#'      INC HL
        DEFB    046H    ;04H'           'F'      LD B,(HL)
        DEFB    0C3H    ;05H'           'C'      JP
        DEFW    0EH'    ;06H'
        DEFB    044H    ;08H'           'D'      LD B,H
        DEFB    04DH    ;09H'           'M'      LD C,L
        DEFB    0E1H    ;0AH'           'a'      POP HL
        DEFB    05EH    ;0BH'           '^'      LD E,(HL)
        DEFB    023H    ;0CH'           '#'      INC HL
        DEFB    056H    ;0DH'           'V'      LD D,(HL)
        DEFB    023H    ;0EH'           '#'      INC HL
        DEFB    0E5H    ;0FH'           'e'      PUSH HL
        DEFB    0C3H    ;010H'          'C'      JP
        DEFW    016H'   ;011H'
        DEFB    0EBH    ;013H'          'k'      EX DE,HL
        DEFB    044H    ;014H'          'D'      LD B,H
        DEFB    04DH    ;015H'          'M'      LD C,L
        DEFB    07AH    ;016H'          'z'      LD A,D
        DEFB    02FH    ;017H'          '/'      CPL
        DEFB    057H    ;018H'          'W'      LD D,A
        DEFB    07BH    ;019H'          '{'      LD A,E
        DEFB    02FH    ;01AH'          '/'      CPL
        DEFB    05FH    ;01BH'          '_'      LD E,A
        DEFB    013H    ;01CH'                   INC DE
        DEFB    021H    ;01DH'          '!'      LD HL,
        DEFB    00H     ;01EH'                   NOP
        DEFB    00H     ;01FH'                   NOP
        DEFB    03EH    ;020H'          '>'      LD A,
        DEFB    011H    ;021H'                   LD DE,
        DEFB    0E5H    ;022H'          'e'      PUSH HL
        DEFB    019H    ;023H'                   ADD HL,DE
        DEFB    0D2H    ;024H'          'R'      JP NC,
        DEFW    028H'   ;025H'
        DEFB    0E3H    ;027H'          'c'      EX (SP),HL
        DEFB    0E1H    ;028H'          'a'      POP HL
        DEFB    0F5H    ;029H'          'u'      PUSH AF
        DEFB    079H    ;02AH'          'y'      LD A,C
        DEFB    017H    ;02BH'                   RLA
        DEFB    04FH    ;02CH'          'O'      LD C,A
        DEFB    078H    ;02DH'          'x'      LD A,B
        DEFB    017H    ;02EH'                   RLA
        DEFB    047H    ;02FH'          'G'      LD B,A
        DEFB    07DH    ;030H'          '}'      LD A,L
        DEFB    017H    ;031H'                   RLA
        DEFB    06FH    ;032H'          'o'      LD L,A
        DEFB    07CH    ;033H'          '|'      LD A,H
        DEFB    017H    ;034H'                   RLA
        DEFB    067H    ;035H'          'g'      LD H,A
        DEFB    0F1H    ;036H'          'q'      POP AF
        DEFB    03DH    ;037H'          '='      DEC A
        DEFB    0C2H    ;038H'          'B'      JP NZ,
        DEFW    022H'   ;039H'
        DEFB    069H    ;03BH'          'i'      LD L,C
        DEFB    060H    ;03CH'          '`'      LD H,B
        DEFB    0C9H    ;03DH'          'I'      RET
$IDVA   EQU     08H'
$IDVB   EQU     013H'
$IDVD   EQU     00H'
$IDVE   EQU     014H'
        END

        NAME    ('MUL1')
        GLOBAL  $IMUG
        GLOBAL  $IMUH
;       Module DATA segment size is 00H bytes
;       Module CODE segment size is 025H bytes
        DEFB    044H    ;00H'           'D'      LD B,H
        DEFB    04DH    ;01H'           'M'      LD C,L
        DEFB    0E1H    ;02H'           'a'      POP HL
        DEFB    05EH    ;03H'           '^'      LD E,(HL)
        DEFB    023H    ;04H'           '#'      INC HL
        DEFB    056H    ;05H'           'V'      LD D,(HL)
        DEFB    023H    ;06H'           '#'      INC HL
        DEFB    0E5H    ;07H'           'e'      PUSH HL
        DEFB    069H    ;08H'           'i'      LD L,C
        DEFB    060H    ;09H'           '`'      LD H,B
        DEFB    07CH    ;0AH'           '|'      LD A,H
        DEFB    0B5H    ;0BH'           '5'      OR L
        DEFB    0C8H    ;0CH'           'H'      RET Z
        DEFB    0EBH    ;0DH'           'k'      EX DE,HL
        DEFB    07CH    ;0EH'           '|'      LD A,H
        DEFB    0B5H    ;0FH'           '5'      OR L
        DEFB    0C8H    ;010H'          'H'      RET Z
        DEFB    044H    ;011H'          'D'      LD B,H
        DEFB    04DH    ;012H'          'M'      LD C,L
        DEFB    021H    ;013H'          '!'      LD HL,
        DEFB    00H     ;014H'                   NOP
        DEFB    00H     ;015H'                   NOP
        DEFB    03EH    ;016H'          '>'      LD A,
        DEFB    010H    ;017H'                   DJNZ
        DEFB    029H    ;018H'          ')'      ADD HL,HL
        DEFB    0EBH    ;019H'          'k'      EX DE,HL
        DEFB    029H    ;01AH'          ')'      ADD HL,HL
        DEFB    0EBH    ;01BH'          'k'      EX DE,HL
        DEFB    0D2H    ;01CH'          'R'      JP NC,
        DEFW    020H'   ;01DH'
        DEFB    09H     ;01FH'                   ADD HL,BC
        DEFB    03DH    ;020H'          '='      DEC A
        DEFB    0C2H    ;021H'          'B'      JP NZ,
        DEFW    018H'   ;022H'
        DEFB    0C9H    ;024H'          'I'      RET
$IMUG   EQU     00H'
$IMUH   EQU     0AH'
        END

        NAME    ('N16')
        GLOBAL  $PV0C
        GLOBAL  $PV1C
        GLOBAL  $PV2C
;       Module DATA segment size is 00H bytes
;       Module CODE segment size is 065H bytes
        DEFB    0CDH    ;00H'           'M'      CALL
        DEFW    017H'   ;01H'
        DEFB    03EH    ;03H'           '>'      LD A,
        DEFB    020H    ;04H'           ' '      JR NZ,
        DEFB    0CDH    ;05H'           'M'      CALL
        DEFB    00H     ;06H'                    NOP
        DEFB    00H     ;07H'                    NOP
        DEFB    0C9H    ;08H'           'I'      RET
        DEFB    0CDH    ;09H'           'M'      CALL
        DEFW    017H'   ;0AH'
        DEFB    03EH    ;0CH'           '>'      LD A,
        DEFB    0AH     ;0DH'                    LD A,(BC)
        DEFB    0CDH    ;0EH'           'M'      CALL
        DEFW    06H'    ;0FH'
        DEFB    03EH    ;011H'          '>'      LD A,
        DEFB    0DH     ;012H'                   DEC C
        DEFB    0CDH    ;013H'          'M'      CALL
        DEFW    0FH'    ;014H'
        DEFB    0C9H    ;016H'          'I'      RET
        DEFB    0E5H    ;017H'          'e'      PUSH HL
        DEFB    07CH    ;018H'          '|'      LD A,H
        DEFB    0E6H    ;019H'          'f'      AND
        DEFB    080H    ;01AH'                   ADD A,B
        DEFB    0CAH    ;01BH'          'J'      JP Z,
        DEFW    02AH'   ;01CH'
        DEFB    07DH    ;01EH'          '}'      LD A,L
        DEFB    02FH    ;01FH'          '/'      CPL
        DEFB    06FH    ;020H'          'o'      LD L,A
        DEFB    07CH    ;021H'          '|'      LD A,H
        DEFB    02FH    ;022H'          '/'      CPL
        DEFB    067H    ;023H'          'g'      LD H,A
        DEFB    023H    ;024H'          '#'      INC HL
        DEFB    03EH    ;025H'          '>'      LD A,
        DEFB    02DH    ;026H'          '-'      DEC L
        DEFB    0CDH    ;027H'          'M'      CALL
        DEFW    014H'   ;028H'
        DEFB    0EH     ;02AH'                   LD C,
        DEFB    030H    ;02BH'          '0'      JR NC,
        DEFB    011H    ;02CH'                   LD DE,
        DEFB    010H    ;02DH'                   DJNZ
        DEFB    027H    ;02EH'          '''      DAA
        DEFB    0CDH    ;02FH'          'M'      CALL
        DEFW    04CH'   ;030H'
        DEFB    011H    ;032H'                   LD DE,
        DEFB    0E8H    ;033H'          'h'      RET PE
        DEFB    03H     ;034H'                   INC BC
        DEFB    0CDH    ;035H'          'M'      CALL
        DEFW    04CH'   ;036H'
        DEFB    011H    ;038H'                   LD DE,
        DEFB    064H    ;039H'          'd'      LD H,H
        DEFB    00H     ;03AH'                   NOP
        DEFB    0CDH    ;03BH'          'M'      CALL
        DEFW    04CH'   ;03CH'
        DEFB    011H    ;03EH'                   LD DE,
        DEFB    0AH     ;03FH'                   LD A,(BC)
        DEFB    00H     ;040H'                   NOP
        DEFB    0CDH    ;041H'          'M'      CALL
        DEFW    04CH'   ;042H'
        DEFB    011H    ;044H'                   LD DE,
        DEFB    01H     ;045H'                   LD BC,
        DEFB    00H     ;046H'                   NOP
        DEFB    0CDH    ;047H'          'M'      CALL
        DEFW    04CH'   ;048H'
        DEFB    0E1H    ;04AH'          'a'      POP HL
        DEFB    0C9H    ;04BH'          'I'      RET
        DEFB    0CDH    ;04CH'          'M'      CALL
        DEFW    05EH'   ;04DH'
        DEFB    0DAH    ;04FH'          'Z'      JP C,
        DEFW    056H'   ;050H'
        DEFB    0CH     ;052H'                   INC C
        DEFB    0C3H    ;053H'          'C'      JP
        DEFW    04CH'   ;054H'
        DEFB    079H    ;056H'          'y'      LD A,C
        DEFB    0CDH    ;057H'          'M'      CALL
        DEFW    028H'   ;058H'
        DEFB    019H    ;05AH'                   ADD HL,DE
        DEFB    0EH     ;05BH'                   LD C,
        DEFB    030H    ;05CH'          '0'      JR NC,
        DEFB    0C9H    ;05DH'          'I'      RET
        DEFB    07DH    ;05EH'          '}'      LD A,L
        DEFB    093H    ;05FH'                   SUB E
        DEFB    06FH    ;060H'          'o'      LD L,A
        DEFB    07CH    ;061H'          '|'      LD A,H
        DEFB    09AH    ;062H'                   SBC A,D
        DEFB    067H    ;063H'          'g'      LD H,A
        DEFB    0C9H    ;064H'          'I'      RET
$PV0C   EQU     00H'
$PV1C   EQU     00H'
$PV2C   EQU     09H'
        EXTERNAL CONOUT ;Chain head at 058H'
        END

        NAME    ('XXXLIB')
        GLOBAL  $END
        GLOBAL  $INI
        GLOBAL  $5.0
;       Module DATA segment size is 00H bytes
;       Module CODE segment size is 05H bytes
        DEFB    0C3H    ;00H'           'C'      JP
        DEFB    00H     ;01H'                    NOP
        DEFB    00H     ;02H'                    NOP
        DEFB    0E9H    ;03H'           'i'      JP (HL)
        DEFB    0C9H    ;04H'           'I'      RET
$5.0    EQU     04H'
$END    EQU     00H'
$INI    EQU     03H'
        END

        NAME    ('CPMIO')
        GLOBAL  CONIN
        GLOBAL  CONOUT
        GLOBAL  CHAR
        GLOBAL  $PR0A
        GLOBAL  CHARIN
;       Module DATA segment size is 00H bytes
;       Module CODE segment size is 029H bytes
        DEFB    021H    ;00H'           '!'      LD HL,
        DEFB    0FEH    ;01H'           '~'      CP
        DEFB    0FFH    ;02H'                    RST 56
        DEFB    0C3H    ;03H'           'C'      JP
        DEFW    015H'   ;04H'
        DEFB    0E5H    ;06H'           'e'      PUSH HL
        DEFB    0D5H    ;07H'           'U'      PUSH DE
        DEFB    0C5H    ;08H'           'E'      PUSH BC
        DEFB    0F5H    ;09H'           'u'      PUSH AF
        DEFB    0EH     ;0AH'                    LD C,
        DEFB    02H     ;0BH'                    LD (BC),A
        DEFB    05FH    ;0CH'           '_'      LD E,A
        DEFB    0CDH    ;0DH'           'M'      CALL
        DEFB    05H     ;0EH'                    DEC B
        DEFB    00H     ;0FH'                    NOP
        DEFB    0F1H    ;010H'          'q'      POP AF
        DEFB    0C1H    ;011H'          'A'      POP BC
        DEFB    0D1H    ;012H'          'Q'      POP DE
        DEFB    0E1H    ;013H'          'a'      POP HL
        DEFB    0C9H    ;014H'          'I'      RET
        DEFB    0D5H    ;015H'          'U'      PUSH DE
        DEFB    0C5H    ;016H'          'E'      PUSH BC
        DEFB    0E5H    ;017H'          'e'      PUSH HL
        DEFB    0EH     ;018H'                   LD C,
        DEFB    01H     ;019H'                   LD BC,
        DEFB    0CDH    ;01AH'          'M'      CALL
        DEFB    05H     ;01BH'                   DEC B
        DEFB    00H     ;01CH'                   NOP
        DEFB    0E1H    ;01DH'          'a'      POP HL
        DEFB    077H    ;01EH'          'w'      LD (HL),A
        DEFB    023H    ;01FH'          '#'      INC HL
        DEFB    036H    ;020H'          '6'      LD (HL),
        DEFB    00H     ;021H'                   NOP
        DEFB    0C1H    ;022H'          'A'      POP BC
        DEFB    0D1H    ;023H'          'Q'      POP DE
        DEFB    0C9H    ;024H'          'I'      RET
        DEFB    07EH    ;025H'          '~'      LD A,(HL)
        DEFB    0C3H    ;026H'          'C'      JP
        DEFW    06H'    ;027H'
$PR0A   EQU     014H'
CHAR    EQU     025H'
CHARIN  EQU     00H'
CONIN   EQU     015H'
CONOUT  EQU     06H'
        END

        NAME    ('OUTA')
        GLOBAL  $OUTA
        GLOBAL  $INPA
;       Module DATA segment size is 03H bytes
;       Module CODE segment size is 027H bytes
        DEFB    03EH    ;00H'           '>'      LD A,
        DEFB    0D3H    ;01H'           'S'      OUT (...),A
        DEFB    032H    ;02H'           '2'      LD (...),A
        DEFW    00H"    ;03H'
        DEFB    07DH    ;05H'           '}'      LD A,L
        DEFB    032H    ;06H'           '2'      LD (...),A
        DEFW    01H"    ;07H'
        DEFB    03EH    ;09H'           '>'      LD A,
        DEFB    0C9H    ;0AH'           'I'      RET
        DEFB    032H    ;0BH'           '2'      LD (...),A
        DEFW    02H"    ;0CH'
        DEFB    07BH    ;0EH'           '{'      LD A,E
        DEFB    0C3H    ;0FH'           'C'      JP
        DEFW    00H"    ;010H'
        DEFB    03EH    ;012H'          '>'      LD A,
        DEFB    0DBH    ;013H'          '['      IN A,(...)
        DEFB    032H    ;014H'          '2'      LD (...),A
        DEFW    00H"    ;015H'
        DEFB    07DH    ;017H'          '}'      LD A,L
        DEFB    032H    ;018H'          '2'      LD (...),A
        DEFW    01H"    ;019H'
        DEFB    03EH    ;01BH'          '>'      LD A,
        DEFB    0C9H    ;01CH'          'I'      RET
        DEFB    032H    ;01DH'          '2'      LD (...),A
        DEFW    02H"    ;01EH'
        DEFB    0CDH    ;020H'          'M'      CALL
        DEFW    00H"    ;021H'
        DEFB    026H    ;023H'          '&'      LD H,
        DEFB    00H     ;024H'                   NOP
        DEFB    06FH    ;025H'          'o'      LD L,A
        DEFB    0C9H    ;026H'          'I'      RET
        DSEG
        ORG     00H
        ORG     03H
$INPA   EQU     012H'
$OUTA   EQU     00H'
        END

        NAME    ('SOD')
        GLOBAL  SODON
        GLOBAL  SODOFF
;       Module DATA segment size is 00H bytes
;       Module CODE segment size is 0CH bytes
        DEFB    0F5H    ;00H'           'u'      PUSH AF
        DEFB    03EH    ;01H'           '>'      LD A,
        DEFB    0C0H    ;02H'           '@'      RET NZ
        DEFB    030H    ;03H'           '0'      JR NC,
        DEFB    0F1H    ;04H'           'q'      POP AF
        DEFB    0C9H    ;05H'           'I'      RET
        DEFB    0F5H    ;06H'           'u'      PUSH AF
        DEFB    03EH    ;07H'           '>'      LD A,
        DEFB    040H    ;08H'           '@'      LD B,B
        DEFB    030H    ;09H'           '0'      JR NC,
        DEFB    0F1H    ;0AH'           'q'      POP AF
        DEFB    0C9H    ;0BH'           'I'      RET
SODOFF  EQU     06H'
SODON   EQU     00H'
        END

        NAME    ('INTLIB')
        GLOBAL  DISABL
        GLOBAL  ENABL
;       Module DATA segment size is 00H bytes
;       Module CODE segment size is 04H bytes
        DEFB    0FBH    ;00H'           '{'      EI
        DEFB    0C9H    ;01H'           'I'      RET
        DEFB    0F3H    ;02H'           's'      DI
        DEFB    0C9H    ;03H'           'I'      RET
DISABL  EQU     02H'
ENABL   EQU     00H'
        END

;       end of file
