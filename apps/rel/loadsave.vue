;LOADSAVE.REL
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
        NAME    ('LOADSA')
        GLOBAL  EXSYS
        GLOBAL  SAVESY
        GLOBAL  RDSYS
        GLOBAL  BUFFIN
        GLOBAL  IDISK
        GLOBAL  DSKERR
        GLOBAL  FORMAT
        GLOBAL  CREAD
        GLOBAL  CWRITE
        GLOBAL  CFORM
        GLOBAL  DTYPE
        GLOBAL  CREAD2
        GLOBAL  CREAD1
        GLOBAL  CWRIT3
        GLOBAL  CWRIT2
        GLOBAL  CWRIT1
;       Module DATA segment size is 00H bytes
;       Module CODE segment size is 0346H bytes
        DEFB    0EH     ;00H'                    LD C,
        DEFB    0AH     ;01H'                    LD A,(BC)
        DEFB    011H    ;02H'                    LD DE,
        DEFB    080H    ;03H'                    ADD A,B
        DEFB    00H     ;04H'                    NOP
        DEFB    0C3H    ;05H'           'C'      JP
        DEFB    05H     ;06H'                    DEC B
        DEFB    00H     ;07H'                    NOP
        DEFB    01H     ;08H'                    LD BC,
        DEFB    00H     ;09H'                    NOP
        DEFB    01CH    ;0AH'                    INC E
        DEFB    021H    ;0BH'           '!'      LD HL,
        DEFB    00H     ;0CH'                    NOP
        DEFB    040H    ;0DH'           '@'      LD B,B
        DEFB    011H    ;0EH'                    LD DE,
        DEFB    00H     ;0FH'                    NOP
        DEFB    0D4H    ;010H'          'T'      CALL NC,
        DEFB    0EDH    ;011H'          'm'      Z80 lead-in
        DEFB    0B0H    ;012H'          '0'      OR B
        DEFB    0C3H    ;013H'          'C'      JP
        DEFB    075H    ;014H'          'u'      LD (HL),L
        DEFB    0F0H    ;015H'          'p'      RET P
        DEFB    07EH    ;016H'          '~'      LD A,(HL)
        DEFB    032H    ;017H'          '2'      LD (...),A
        DEFW    0344H'  ;018H'
        DEFB    0CDH    ;01AH'          'M'      CALL
        DEFB    054H    ;01BH'          'T'      LD D,H
        DEFB    0F0H    ;01CH'          'p'      RET P
        DEFB    01EH    ;01DH'                   LD E,
        DEFB    00H     ;01EH'                   NOP
        DEFB    0D5H    ;01FH'          'U'      PUSH DE
        DEFB    0CDH    ;020H'          'M'      CALL
        DEFW    013DH'  ;021H'
        DEFB    03AH    ;023H'          ':'      LD A,(...)
        DEFW    0344H'  ;024H'
        DEFB    0CDH    ;026H'          'M'      CALL
        DEFB    05AH    ;027H'          'Z'      LD E,D
        DEFB    0F0H    ;028H'          'p'      RET P
        DEFB    032H    ;029H'          '2'      LD (...),A
        DEFW    0345H'  ;02AH'
        DEFB    021H    ;02CH'          '!'      LD HL,
        DEFB    00H     ;02DH'                   NOP
        DEFB    040H    ;02EH'          '@'      LD B,B
        DEFB    01H     ;02FH'                   LD BC,
        DEFB    00H     ;030H'                   NOP
        DEFB    01CH    ;031H'                   INC E
        DEFB    0D1H    ;032H'          'Q'      POP DE
        DEFB    0B7H    ;033H'          '7'      OR A
        DEFB    0C0H    ;034H'          '@'      RET NZ
        DEFB    0D5H    ;035H'          'U'      PUSH DE
        DEFB    0CDH    ;036H'          'M'      CALL
        DEFB    039H    ;037H'          '9'      ADD HL,SP
        DEFB    0F0H    ;038H'          'p'      RET P
        DEFB    0CDH    ;039H'          'M'      CALL
        DEFB    03FH    ;03AH'          '?'      CCF
        DEFB    0F0H    ;03BH'          'p'      RET P
        DEFB    077H    ;03CH'          'w'      LD (HL),A
        DEFB    023H    ;03DH'          '#'      INC HL
        DEFB    0BH     ;03EH'                   DEC BC
        DEFB    078H    ;03FH'          'x'      LD A,B
        DEFB    0B1H    ;040H'          '1'      OR C
        DEFB    020H    ;041H'          ' '      JR NZ,
        DEFB    0F6H    ;042H'          'v'      OR
        DEFB    0CDH    ;043H'          'M'      CALL
        DEFB    03CH    ;044H'          '<'      INC A
        DEFB    0F0H    ;045H'          'p'      RET P
        DEFB    0D1H    ;046H'          'Q'      POP DE
        DEFB    0D5H    ;047H'          'U'      PUSH DE
        DEFB    0CDH    ;048H'          'M'      CALL
        DEFB    060H    ;049H'          '`'      LD H,B
        DEFB    0F0H    ;04AH'          'p'      RET P
        DEFB    0D1H    ;04BH'          'Q'      POP DE
        DEFB    0D5H    ;04CH'          'U'      PUSH DE
        DEFB    0CDH    ;04DH'          'M'      CALL
        DEFW    014FH'  ;04EH'
        DEFB    03AH    ;050H'          ':'      LD A,(...)
        DEFW    0344H'  ;051H'
        DEFB    0CDH    ;053H'          'M'      CALL
        DEFB    05AH    ;054H'          'Z'      LD E,D
        DEFB    0F0H    ;055H'          'p'      RET P
        DEFB    032H    ;056H'          '2'      LD (...),A
        DEFW    0345H'  ;057H'
        DEFB    021H    ;059H'          '!'      LD HL,
        DEFB    00H     ;05AH'                   NOP
        DEFB    060H    ;05BH'          '`'      LD H,B
        DEFB    01H     ;05CH'                   LD BC,
        DEFB    00H     ;05DH'                   NOP
        DEFB    08H     ;05EH'                   EX AF,AF'
        DEFB    0D1H    ;05FH'          'Q'      POP DE
        DEFB    0B7H    ;060H'          '7'      OR A
        DEFB    0C0H    ;061H'          '@'      RET NZ
        DEFB    0D5H    ;062H'          'U'      PUSH DE
        DEFB    0CDH    ;063H'          'M'      CALL
        DEFB    039H    ;064H'          '9'      ADD HL,SP
        DEFB    0F0H    ;065H'          'p'      RET P
        DEFB    0CDH    ;066H'          'M'      CALL
        DEFB    03FH    ;067H'          '?'      CCF
        DEFB    0F0H    ;068H'          'p'      RET P
        DEFB    077H    ;069H'          'w'      LD (HL),A
        DEFB    023H    ;06AH'          '#'      INC HL
        DEFB    0BH     ;06BH'                   DEC BC
        DEFB    078H    ;06CH'          'x'      LD A,B
        DEFB    0B1H    ;06DH'          '1'      OR C
        DEFB    020H    ;06EH'          ' '      JR NZ,
        DEFB    0F6H    ;06FH'          'v'      OR
        DEFB    0CDH    ;070H'          'M'      CALL
        DEFB    03CH    ;071H'          '<'      INC A
        DEFB    0F0H    ;072H'          'p'      RET P
        DEFB    0D1H    ;073H'          'Q'      POP DE
        DEFB    0CDH    ;074H'          'M'      CALL
        DEFB    060H    ;075H'          '`'      LD H,B
        DEFB    0F0H    ;076H'          'p'      RET P
        DEFB    03AH    ;077H'          ':'      LD A,(...)
        DEFW    0344H'  ;078H'
        DEFB    0CDH    ;07AH'          'M'      CALL
        DEFB    05AH    ;07BH'          'Z'      LD E,D
        DEFB    0F0H    ;07CH'          'p'      RET P
        DEFB    032H    ;07DH'          '2'      LD (...),A
        DEFW    0345H'  ;07EH'
        DEFB    0C9H    ;080H'          'I'      RET
        DEFB    04EH    ;081H'          'N'      LD C,(HL)
        DEFB    0CDH    ;082H'          'M'      CALL
        DEFB    01BH    ;083H'                   DEC DE
        DEFB    0F0H    ;084H'          'p'      RET P
        DEFB    011H    ;085H'                   LD DE,
        DEFB    00H     ;086H'                   NOP
        DEFB    040H    ;087H'          '@'      LD B,B
        DEFB    01H     ;088H'                   LD BC,
        DEFB    00H     ;089H'                   NOP
        DEFB    00H     ;08AH'                   NOP
        DEFB    0CDH    ;08BH'          'M'      CALL
        DEFB    01EH    ;08CH'                   LD E,
        DEFB    0F0H    ;08DH'          'p'      RET P
        DEFB    0C5H    ;08EH'          'E'      PUSH BC
        DEFB    01H     ;08FH'                   LD BC,
        DEFB    00H     ;090H'                   NOP
        DEFB    00H     ;091H'                   NOP
        DEFB    0CDH    ;092H'          'M'      CALL
        DEFB    021H    ;093H'          '!'      LD HL,
        DEFB    0F0H    ;094H'          'p'      RET P
        DEFB    0C5H    ;095H'          'E'      PUSH BC
        DEFB    0D5H    ;096H'          'U'      PUSH DE
        DEFB    0CDH    ;097H'          'M'      CALL
        DEFB    027H    ;098H'          '''      DAA
        DEFB    0F0H    ;099H'          'p'      RET P
        DEFB    0B7H    ;09AH'          '7'      OR A
        DEFB    020H    ;09BH'          ' '      JR NZ,
        DEFB    04CH    ;09CH'          'L'      LD C,H
        DEFB    0D1H    ;09DH'          'Q'      POP DE
        DEFB    01H     ;09EH'                   LD BC,
        DEFB    080H    ;09FH'                   ADD A,B
        DEFB    00H     ;0A0H'                   NOP
        DEFB    021H    ;0A1H'          '!'      LD HL,
        DEFB    080H    ;0A2H'                   ADD A,B
        DEFB    00H     ;0A3H'                   NOP
        DEFB    0EDH    ;0A4H'          'm'      Z80 lead-in
        DEFB    0B0H    ;0A5H'          '0'      OR B
        DEFB    0C1H    ;0A6H'          'A'      POP BC
        DEFB    0CH     ;0A7H'                   INC C
        DEFB    079H    ;0A8H'          'y'      LD A,C
        DEFB    0FEH    ;0A9H'          '~'      CP
        DEFB    040H    ;0AAH'          '@'      LD B,B
        DEFB    020H    ;0ABH'          ' '      JR NZ,
        DEFB    0E5H    ;0ACH'          'e'      PUSH HL
        DEFB    0C1H    ;0ADH'          'A'      POP BC
        DEFB    0CH     ;0AEH'                   INC C
        DEFB    079H    ;0AFH'          'y'      LD A,C
        DEFB    0FEH    ;0B0H'          '~'      CP
        DEFB    02H     ;0B1H'                   LD (BC),A
        DEFB    020H    ;0B2H'          ' '      JR NZ,
        DEFB    0D7H    ;0B3H'          'W'      RST 16
        DEFB    0C9H    ;0B4H'          'I'      RET
        DEFB    04EH    ;0B5H'          'N'      LD C,(HL)
        DEFB    0CDH    ;0B6H'          'M'      CALL
        DEFB    01BH    ;0B7H'                   DEC DE
        DEFB    0F0H    ;0B8H'          'p'      RET P
        DEFB    021H    ;0B9H'          '!'      LD HL,
        DEFB    00H     ;0BAH'                   NOP
        DEFB    040H    ;0BBH'          '@'      LD B,B
        DEFB    01H     ;0BCH'                   LD BC,
        DEFB    00H     ;0BDH'                   NOP
        DEFB    00H     ;0BEH'                   NOP
        DEFB    0CDH    ;0BFH'          'M'      CALL
        DEFB    01EH    ;0C0H'                   LD E,
        DEFB    0F0H    ;0C1H'          'p'      RET P
        DEFB    0C5H    ;0C2H'          'E'      PUSH BC
        DEFB    01H     ;0C3H'                   LD BC,
        DEFB    00H     ;0C4H'                   NOP
        DEFB    00H     ;0C5H'                   NOP
        DEFB    0CDH    ;0C6H'          'M'      CALL
        DEFB    021H    ;0C7H'          '!'      LD HL,
        DEFB    0F0H    ;0C8H'          'p'      RET P
        DEFB    0C5H    ;0C9H'          'E'      PUSH BC
        DEFB    01H     ;0CAH'                   LD BC,
        DEFB    080H    ;0CBH'                   ADD A,B
        DEFB    00H     ;0CCH'                   NOP
        DEFB    011H    ;0CDH'                   LD DE,
        DEFB    080H    ;0CEH'                   ADD A,B
        DEFB    00H     ;0CFH'                   NOP
        DEFB    0EDH    ;0D0H'          'm'      Z80 lead-in
        DEFB    0B0H    ;0D1H'          '0'      OR B
        DEFB    0E5H    ;0D2H'          'e'      PUSH HL
        DEFB    0CDH    ;0D3H'          'M'      CALL
        DEFB    02AH    ;0D4H'          '*'      LD HL,(...)
        DEFB    0F0H    ;0D5H'          'p'      RET P
        DEFB    0B7H    ;0D6H'          '7'      OR A
        DEFB    020H    ;0D7H'          ' '      JR NZ,
        DEFB    010H    ;0D8H'                   DJNZ
        DEFB    0E1H    ;0D9H'          'a'      POP HL
        DEFB    0C1H    ;0DAH'          'A'      POP BC
        DEFB    0CH     ;0DBH'                   INC C
        DEFB    079H    ;0DCH'          'y'      LD A,C
        DEFB    0FEH    ;0DDH'          '~'      CP
        DEFB    040H    ;0DEH'          '@'      LD B,B
        DEFB    020H    ;0DFH'          ' '      JR NZ,
        DEFB    0E5H    ;0E0H'          'e'      PUSH HL
        DEFB    0C1H    ;0E1H'          'A'      POP BC
        DEFB    0CH     ;0E2H'                   INC C
        DEFB    079H    ;0E3H'          'y'      LD A,C
        DEFB    0FEH    ;0E4H'          '~'      CP
        DEFB    02H     ;0E5H'                   LD (BC),A
        DEFB    020H    ;0E6H'          ' '      JR NZ,
        DEFB    0D7H    ;0E7H'          'W'      RST 16
        DEFB    0C9H    ;0E8H'          'I'      RET
        DEFB    0E1H    ;0E9H'          'a'      POP HL
        DEFB    0E1H    ;0EAH'          'a'      POP HL
        DEFB    0E1H    ;0EBH'          'a'      POP HL
        DEFB    0C3H    ;0ECH'          'C'      JP
        DEFW    02D9H'  ;0EDH'
        DEFB    07EH    ;0EFH'          '~'      LD A,(HL)
        DEFB    0CDH    ;0F0H'          'M'      CALL
        DEFB    051H    ;0F1H'          'Q'      LD D,C
        DEFB    0F0H    ;0F2H'          'p'      RET P
        DEFB    071H    ;0F3H'          'q'      LD (HL),C
        DEFB    023H    ;0F4H'          '#'      INC HL
        DEFB    036H    ;0F5H'          '6'      LD (HL),
        DEFB    00H     ;0F6H'                   NOP
        DEFB    0C9H    ;0F7H'          'I'      RET
        DEFB    07EH    ;0F8H'          '~'      LD A,(HL)
        DEFB    0C3H    ;0F9H'          'C'      JP
        DEFB    078H    ;0FAH'          'x'      LD A,B
        DEFB    0F0H    ;0FBH'          'p'      RET P
        DEFB    03AH    ;0FCH'          ':'      LD A,(...)
        DEFW    0345H'  ;0FDH'
        DEFB    077H    ;0FFH'          'w'      LD (HL),A
        DEFB    023H    ;0100H'         '#'      INC HL
        DEFB    0AFH    ;0101H'         '/'      XOR A
        DEFB    077H    ;0102H'         'w'      LD (HL),A
        DEFB    03AH    ;0103H'         ':'      LD A,(...)
        DEFW    0345H'  ;0104H'
        DEFB    0B7H    ;0106H'         '7'      OR A
        DEFB    0C8H    ;0107H'         'H'      RET Z
        DEFB    011H    ;0108H'                  LD DE,
        DEFW    012AH'  ;0109H'
        DEFB    0EH     ;010BH'                  LD C,
        DEFB    09H     ;010CH'                  ADD HL,BC
        DEFB    0CDH    ;010DH'         'M'      CALL
        DEFB    05H     ;010EH'                  DEC B
        DEFB    00H     ;010FH'                  NOP
        DEFB    021H    ;0110H'         '!'      LD HL,
        DEFB    0C0H    ;0111H'         '@'      RET NZ
        DEFB    0EAH    ;0112H'         'j'      JP PE,
        DEFB    05EH    ;0113H'         '^'      LD E,(HL)
        DEFB    0E5H    ;0114H'         'e'      PUSH HL
        DEFB    0EH     ;0115H'                  LD C,
        DEFB    02H     ;0116H'                  LD (BC),A
        DEFB    0CDH    ;0117H'         'M'      CALL
        DEFB    05H     ;0118H'                  DEC B
        DEFB    00H     ;0119H'                  NOP
        DEFB    0E1H    ;011AH'         'a'      POP HL
        DEFB    023H    ;011BH'         '#'      INC HL
        DEFB    07EH    ;011CH'         '~'      LD A,(HL)
        DEFB    0FEH    ;011DH'         '~'      CP
        DEFB    0DH     ;011EH'                  DEC C
        DEFB    020H    ;011FH'         ' '      JR NZ,
        DEFB    0F2H    ;0120H'         'r'      JP P,
        DEFB    011H    ;0121H'                  LD DE,
        DEFW    013AH'  ;0122H'
        DEFB    0EH     ;0124H'                  LD C,
        DEFB    09H     ;0125H'                  ADD HL,BC
        DEFB    0CDH    ;0126H'         'M'      CALL
        DEFB    05H     ;0127H'                  DEC B
        DEFB    00H     ;0128H'                  NOP
        DEFB    0C9H    ;0129H'         'I'      RET
        DEFB    0DH     ;012AH'                  DEC C
        DEFB    0AH     ;012BH'                  LD A,(BC)
        DEFB    044H    ;012CH'         'D'      LD B,H
        DEFB    069H    ;012DH'         'i'      LD L,C
        DEFB    073H    ;012EH'         's'      LD (HL),E
        DEFB    06BH    ;012FH'         'k'      LD L,E
        DEFB    020H    ;0130H'         ' '      JR NZ,
        DEFB    065H    ;0131H'         'e'      LD H,L
        DEFB    072H    ;0132H'         'r'      LD (HL),D
        DEFB    072H    ;0133H'         'r'      LD (HL),D
        DEFB    06FH    ;0134H'         'o'      LD L,A
        DEFB    072H    ;0135H'         'r'      LD (HL),D
        DEFB    020H    ;0136H'         ' '      JR NZ,
        DEFB    03AH    ;0137H'         ':'      LD A,(...)
        DEFB    020H    ;0138H'         ' '      JR NZ,
        DEFB    024H    ;0139H'         '$'      INC H
        DEFB    0DH     ;013AH'                  DEC C
        DEFB    0AH     ;013BH'                  LD A,(BC)
        DEFB    024H    ;013CH'         '$'      INC H
        DEFB    0EH     ;013DH'                  LD C,
        DEFB    06H     ;013EH'                  LD B,
        DEFB    021H    ;013FH'         '!'      LD HL,
        DEFW    0332H'  ;0140H'
        DEFB    03AH    ;0142H'         ':'      LD A,(...)
        DEFW    0344H'  ;0143H'
        DEFB    01FH    ;0145H'                  RRA
        DEFB    0D2H    ;0146H'         'R'      JP NC,
        DEFB    05DH    ;0147H'         ']'      LD E,L
        DEFB    0F0H    ;0148H'         'p'      RET P
        DEFB    021H    ;0149H'         '!'      LD HL,
        DEFW    0338H'  ;014AH'
        DEFB    0C3H    ;014CH'         'C'      JP
        DEFB    05DH    ;014DH'         ']'      LD E,L
        DEFB    0F0H    ;014EH'         'p'      RET P
        DEFB    0EH     ;014FH'                  LD C,
        DEFB    03H     ;0150H'                  INC BC
        DEFB    021H    ;0151H'         '!'      LD HL,
        DEFW    033EH'  ;0152H'
        DEFB    03AH    ;0154H'         ':'      LD A,(...)
        DEFW    0344H'  ;0155H'
        DEFB    01FH    ;0157H'                  RRA
        DEFB    0D2H    ;0158H'         'R'      JP NC,
        DEFB    05DH    ;0159H'         ']'      LD E,L
        DEFB    0F0H    ;015AH'         'p'      RET P
        DEFB    021H    ;015BH'         '!'      LD HL,
        DEFW    0341H'  ;015CH'
        DEFB    0C3H    ;015EH'         'C'      JP
        DEFB    05DH    ;015FH'         ']'      LD E,L
        DEFB    0F0H    ;0160H'         'p'      RET P
        DEFB    07EH    ;0161H'         '~'      LD A,(HL)
        DEFB    032H    ;0162H'         '2'      LD (...),A
        DEFW    0344H'  ;0163H'
        DEFB    0CDH    ;0165H'         'M'      CALL
        DEFB    054H    ;0166H'         'T'      LD D,H
        DEFB    0F0H    ;0167H'         'p'      RET P
        DEFB    0D5H    ;0168H'         'U'      PUSH DE
        DEFB    01EH    ;0169H'                  LD E,
        DEFB    0FH     ;016AH'                  RRCA
        DEFB    021H    ;016BH'         '!'      LD HL,
        DEFW    032AH'  ;016CH'
        DEFB    03AH    ;016EH'         ':'      LD A,(...)
        DEFW    0344H'  ;016FH'
        DEFB    01FH    ;0171H'                  RRA
        DEFB    030H    ;0172H'         '0'      JR NC,
        DEFB    03H     ;0173H'                  INC BC
        DEFB    021H    ;0174H'         '!'      LD HL,
        DEFW    032EH'  ;0175H'
        DEFB    0EH     ;0177H'                  LD C,
        DEFB    04H     ;0178H'                  INC B
        DEFB    0CDH    ;0179H'         'M'      CALL
        DEFB    05DH    ;017AH'         ']'      LD E,L
        DEFB    0F0H    ;017BH'         'p'      RET P
        DEFB    03AH    ;017CH'         ':'      LD A,(...)
        DEFW    0344H'  ;017DH'
        DEFB    0CDH    ;017FH'         'M'      CALL
        DEFB    05AH    ;0180H'         'Z'      LD E,D
        DEFB    0F0H    ;0181H'         'p'      RET P
        DEFB    032H    ;0182H'         '2'      LD (...),A
        DEFW    0345H'  ;0183H'
        DEFB    0D1H    ;0185H'         'Q'      POP DE
        DEFB    0FEH    ;0186H'         '~'      CP
        DEFB    01H     ;0187H'                  LD BC,
        DEFB    0C0H    ;0188H'         '@'      RET NZ
        DEFB    01EH    ;0189H'                  LD E,
        DEFB    01H     ;018AH'                  LD BC,
        DEFB    0D5H    ;018BH'         'U'      PUSH DE
        DEFB    0CDH    ;018CH'         'M'      CALL
        DEFW    014FH'  ;018DH'
        DEFB    03AH    ;018FH'         ':'      LD A,(...)
        DEFW    0344H'  ;0190H'
        DEFB    0CDH    ;0192H'         'M'      CALL
        DEFB    05AH    ;0193H'         'Z'      LD E,D
        DEFB    0F0H    ;0194H'         'p'      RET P
        DEFB    032H    ;0195H'         '2'      LD (...),A
        DEFW    0345H'  ;0196H'
        DEFB    0D1H    ;0198H'         'Q'      POP DE
        DEFB    0B7H    ;0199H'         '7'      OR A
        DEFB    0C0H    ;019AH'         '@'      RET NZ
        DEFB    0D5H    ;019BH'         'U'      PUSH DE
        DEFB    0CDH    ;019CH'         'M'      CALL
        DEFB    033H    ;019DH'         '3'      INC SP
        DEFB    0F0H    ;019EH'         'p'      RET P
        DEFB    021H    ;019FH'         '!'      LD HL,
        DEFB    00H     ;01A0H'                  NOP
        DEFB    060H    ;01A1H'         '`'      LD H,B
        DEFB    01H     ;01A2H'                  LD BC,
        DEFB    00H     ;01A3H'                  NOP
        DEFB    08H     ;01A4H'                  EX AF,AF'
        DEFB    07EH    ;01A5H'         '~'      LD A,(HL)
        DEFB    0CDH    ;01A6H'         'M'      CALL
        DEFB    042H    ;01A7H'         'B'      LD B,D
        DEFB    0F0H    ;01A8H'         'p'      RET P
        DEFB    023H    ;01A9H'         '#'      INC HL
        DEFB    0BH     ;01AAH'                  DEC BC
        DEFB    078H    ;01ABH'         'x'      LD A,B
        DEFB    0B1H    ;01ACH'         '1'      OR C
        DEFB    020H    ;01ADH'         ' '      JR NZ,
        DEFB    0F6H    ;01AEH'         'v'      OR
        DEFB    0CDH    ;01AFH'         'M'      CALL
        DEFB    036H    ;01B0H'         '6'      LD (HL),
        DEFB    0F0H    ;01B1H'         'p'      RET P
        DEFB    0D1H    ;01B2H'         'Q'      POP DE
        DEFB    0D5H    ;01B3H'         'U'      PUSH DE
        DEFB    0CDH    ;01B4H'         'M'      CALL
        DEFB    060H    ;01B5H'         '`'      LD H,B
        DEFB    0F0H    ;01B6H'         'p'      RET P
        DEFB    0D1H    ;01B7H'         'Q'      POP DE
        DEFB    0D5H    ;01B8H'         'U'      PUSH DE
        DEFB    0CDH    ;01B9H'         'M'      CALL
        DEFW    013DH'  ;01BAH'
        DEFB    03AH    ;01BCH'         ':'      LD A,(...)
        DEFW    0344H'  ;01BDH'
        DEFB    0CDH    ;01BFH'         'M'      CALL
        DEFB    05AH    ;01C0H'         'Z'      LD E,D
        DEFB    0F0H    ;01C1H'         'p'      RET P
        DEFB    032H    ;01C2H'         '2'      LD (...),A
        DEFW    0345H'  ;01C3H'
        DEFB    0D1H    ;01C5H'         'Q'      POP DE
        DEFB    0B7H    ;01C6H'         '7'      OR A
        DEFB    0C0H    ;01C7H'         '@'      RET NZ
        DEFB    0D5H    ;01C8H'         'U'      PUSH DE
        DEFB    0CDH    ;01C9H'         'M'      CALL
        DEFB    033H    ;01CAH'         '3'      INC SP
        DEFB    0F0H    ;01CBH'         'p'      RET P
        DEFB    021H    ;01CCH'         '!'      LD HL,
        DEFB    00H     ;01CDH'                  NOP
        DEFB    040H    ;01CEH'         '@'      LD B,B
        DEFB    01H     ;01CFH'                  LD BC,
        DEFB    00H     ;01D0H'                  NOP
        DEFB    01CH    ;01D1H'                  INC E
        DEFB    07EH    ;01D2H'         '~'      LD A,(HL)
        DEFB    0CDH    ;01D3H'         'M'      CALL
        DEFB    042H    ;01D4H'         'B'      LD B,D
        DEFB    0F0H    ;01D5H'         'p'      RET P
        DEFB    023H    ;01D6H'         '#'      INC HL
        DEFB    0BH     ;01D7H'                  DEC BC
        DEFB    078H    ;01D8H'         'x'      LD A,B
        DEFB    0B1H    ;01D9H'         '1'      OR C
        DEFB    020H    ;01DAH'         ' '      JR NZ,
        DEFB    0F6H    ;01DBH'         'v'      OR
        DEFB    0CDH    ;01DCH'         'M'      CALL
        DEFB    036H    ;01DDH'         '6'      LD (HL),
        DEFB    0F0H    ;01DEH'         'p'      RET P
        DEFB    0D1H    ;01DFH'         'Q'      POP DE
        DEFB    0CDH    ;01E0H'         'M'      CALL
        DEFB    060H    ;01E1H'         '`'      LD H,B
        DEFB    0F0H    ;01E2H'         'p'      RET P
        DEFB    03AH    ;01E3H'         ':'      LD A,(...)
        DEFW    0344H'  ;01E4H'
        DEFB    0CDH    ;01E6H'         'M'      CALL
        DEFB    05AH    ;01E7H'         'Z'      LD E,D
        DEFB    0F0H    ;01E8H'         'p'      RET P
        DEFB    032H    ;01E9H'         '2'      LD (...),A
        DEFW    0345H'  ;01EAH'
        DEFB    0C9H    ;01ECH'         'I'      RET
        DEFB    07EH    ;01EDH'         '~'      LD A,(HL)
        DEFB    032H    ;01EEH'         '2'      LD (...),A
        DEFW    0344H'  ;01EFH'
        DEFB    0CDH    ;01F1H'         'M'      CALL
        DEFB    054H    ;01F2H'         'T'      LD D,H
        DEFB    0F0H    ;01F3H'         'p'      RET P
        DEFB    03AH    ;01F4H'         ':'      LD A,(...)
        DEFW    0344H'  ;01F5H'
        DEFB    0E6H    ;01F7H'         'f'      AND
        DEFB    01H     ;01F8H'                  LD BC,
        DEFB    0C6H    ;01F9H'         'F'      ADD A,
        DEFB    030H    ;01FAH'         '0'      JR NC,
        DEFB    032H    ;01FBH'         '2'      LD (...),A
        DEFW    0306H'  ;01FCH'
        DEFB    01EH    ;01FEH'                  LD E,
        DEFB    0FH     ;01FFH'                  RRCA
        DEFB    0EH     ;0200H'                  LD C,
        DEFB    014H    ;0201H'                  INC D
        DEFB    021H    ;0202H'         '!'      LD HL,
        DEFW    0305H'  ;0203H'
        DEFB    0CDH    ;0205H'         'M'      CALL
        DEFB    05DH    ;0206H'         ']'      LD E,L
        DEFB    0F0H    ;0207H'         'p'      RET P
        DEFB    03AH    ;0208H'         ':'      LD A,(...)
        DEFW    0344H'  ;0209H'
        DEFB    0CDH    ;020BH'         'M'      CALL
        DEFB    05AH    ;020CH'         'Z'      LD E,D
        DEFB    0F0H    ;020DH'         'p'      RET P
        DEFB    032H    ;020EH'         '2'      LD (...),A
        DEFW    0345H'  ;020FH'
        DEFB    0B7H    ;0211H'         '7'      OR A
        DEFB    0C0H    ;0212H'         '@'      RET NZ
        DEFB    03AH    ;0213H'         ':'      LD A,(...)
        DEFW    0344H'  ;0214H'
        DEFB    0CDH    ;0216H'         'M'      CALL
        DEFB    078H    ;0217H'         'x'      LD A,B
        DEFB    0F0H    ;0218H'         'p'      RET P
        DEFB    021H    ;0219H'         '!'      LD HL,
        DEFB    00H     ;021AH'                  NOP
        DEFB    040H    ;021BH'         '@'      LD B,B
        DEFB    011H    ;021CH'                  LD DE,
        DEFB    01H     ;021DH'                  LD BC,
        DEFB    040H    ;021EH'         '@'      LD B,B
        DEFB    01H     ;021FH'                  LD BC,
        DEFB    0FFH    ;0220H'                  RST 56
        DEFB    00H     ;0221H'                  NOP
        DEFB    036H    ;0222H'         '6'      LD (HL),
        DEFB    0E5H    ;0223H'         'e'      PUSH HL
        DEFB    0EDH    ;0224H'         'm'      Z80 lead-in
        DEFB    0B0H    ;0225H'         '0'      OR B
        DEFB    03EH    ;0226H'         '>'      LD A,
        DEFB    07H     ;0227H'                  RLCA
        DEFB    032H    ;0228H'         '2'      LD (...),A
        DEFW    0329H'  ;0229H'
        DEFB    03EH    ;022BH'         '>'      LD A,
        DEFB    01H     ;022CH'                  LD BC,
        DEFB    032H    ;022DH'         '2'      LD (...),A
        DEFW    0328H'  ;022EH'
        DEFB    0CDH    ;0230H'         'M'      CALL
        DEFW    0246H'  ;0231H'
        DEFB    03AH    ;0233H'         ':'      LD A,(...)
        DEFW    0344H'  ;0234H'
        DEFB    0CDH    ;0236H'         'M'      CALL
        DEFB    05AH    ;0237H'         'Z'      LD E,D
        DEFB    0F0H    ;0238H'         'p'      RET P
        DEFB    032H    ;0239H'         '2'      LD (...),A
        DEFW    0345H'  ;023AH'
        DEFB    0B7H    ;023CH'         '7'      OR A
        DEFB    0C0H    ;023DH'         '@'      RET NZ
        DEFB    021H    ;023EH'         '!'      LD HL,
        DEFW    0329H'  ;023FH'
        DEFB    035H    ;0241H'         '5'      DEC (HL)
        DEFB    0F2H    ;0242H'         'r'      JP P,
        DEFW    0230H'  ;0243H'
        DEFB    0C9H    ;0245H'         'I'      RET
        DEFB    021H    ;0246H'         '!'      LD HL,
        DEFW    0320H'  ;0247H'
        DEFB    0EH     ;0249H'                  LD C,
        DEFB    06H     ;024AH'                  LD B,
        DEFB    03AH    ;024BH'         ':'      LD A,(...)
        DEFW    0344H'  ;024CH'
        DEFB    0CDH    ;024EH'         'M'      CALL
        DEFB    057H    ;024FH'         'W'      LD D,A
        DEFB    0F0H    ;0250H'         'p'      RET P
        DEFB    0CDH    ;0251H'         'M'      CALL
        DEFB    04BH    ;0252H'         'K'      LD C,E
        DEFB    0F0H    ;0253H'         'p'      RET P
        DEFB    03AH    ;0254H'         ':'      LD A,(...)
        DEFB    00H     ;0255H'                  NOP
        DEFB    040H    ;0256H'         '@'      LD B,B
        DEFB    0CDH    ;0257H'         'M'      CALL
        DEFB    045H    ;0258H'         'E'      LD B,L
        DEFB    0F0H    ;0259H'         'p'      RET P
        DEFB    0CDH    ;025AH'         'M'      CALL
        DEFB    036H    ;025BH'         '6'      LD (HL),
        DEFB    0F0H    ;025CH'         'p'      RET P
        DEFB    021H    ;025DH'         '!'      LD HL,
        DEFW    0319H'  ;025EH'
        DEFB    0EH     ;0260H'                  LD C,
        DEFB    07H     ;0261H'                  RLCA
        DEFB    03AH    ;0262H'         ':'      LD A,(...)
        DEFW    0344H'  ;0263H'
        DEFB    0CDH    ;0265H'         'M'      CALL
        DEFB    057H    ;0266H'         'W'      LD D,A
        DEFB    0F0H    ;0267H'         'p'      RET P
        DEFB    0CDH    ;0268H'         'M'      CALL
        DEFB    04BH    ;0269H'         'K'      LD C,E
        DEFB    0F0H    ;026AH'         'p'      RET P
        DEFB    0CDH    ;026BH'         'M'      CALL
        DEFB    048H    ;026CH'         'H'      LD C,B
        DEFB    0F0H    ;026DH'         'p'      RET P
        DEFB    0CDH    ;026EH'         'M'      CALL
        DEFB    036H    ;026FH'         '6'      LD (HL),
        DEFB    0F0H    ;0270H'         'p'      RET P
        DEFB    03AH    ;0271H'         ':'      LD A,(...)
        DEFW    0344H'  ;0272H'
        DEFB    0CDH    ;0274H'         'M'      CALL
        DEFB    054H    ;0275H'         'T'      LD D,H
        DEFB    0F0H    ;0276H'         'p'      RET P
        DEFB    01EH    ;0277H'                  LD E,
        DEFB    02H     ;0278H'                  LD (BC),A
        DEFB    0CDH    ;0279H'         'M'      CALL
        DEFB    033H    ;027AH'         '3'      INC SP
        DEFB    0F0H    ;027BH'         'p'      RET P
        DEFB    021H    ;027CH'         '!'      LD HL,
        DEFB    01H     ;027DH'                  LD BC,
        DEFB    040H    ;027EH'         '@'      LD B,B
        DEFB    0EH     ;027FH'                  LD C,
        DEFB    0FFH    ;0280H'                  RST 56
        DEFB    0CDH    ;0281H'         'M'      CALL
        DEFB    04BH    ;0282H'         'K'      LD C,E
        DEFB    0F0H    ;0283H'         'p'      RET P
        DEFB    0CDH    ;0284H'         'M'      CALL
        DEFB    036H    ;0285H'         '6'      LD (HL),
        DEFB    0F0H    ;0286H'         'p'      RET P
        DEFB    03AH    ;0287H'         ':'      LD A,(...)
        DEFW    0344H'  ;0288H'
        DEFB    0CDH    ;028AH'         'M'      CALL
        DEFB    057H    ;028BH'         'W'      LD D,A
        DEFB    0F0H    ;028CH'         'p'      RET P
        DEFB    021H    ;028DH'         '!'      LD HL,
        DEFW    0300H'  ;028EH'
        DEFB    0EH     ;0290H'                  LD C,
        DEFB    05H     ;0291H'                  DEC B
        DEFB    0CDH    ;0292H'         'M'      CALL
        DEFB    04BH    ;0293H'         'K'      LD C,E
        DEFB    0F0H    ;0294H'         'p'      RET P
        DEFB    03AH    ;0295H'         ':'      LD A,(...)
        DEFW    0344H'  ;0296H'
        DEFB    0E6H    ;0298H'         'f'      AND
        DEFB    01H     ;0299H'                  LD BC,
        DEFB    0C6H    ;029AH'         'F'      ADD A,
        DEFB    030H    ;029BH'         '0'      JR NC,
        DEFB    0CDH    ;029CH'         'M'      CALL
        DEFB    042H    ;029DH'         'B'      LD B,D
        DEFB    0F0H    ;029EH'         'p'      RET P
        DEFB    03AH    ;029FH'         ':'      LD A,(...)
        DEFW    0328H'  ;02A0H'
        DEFB    0CDH    ;02A2H'         'M'      CALL
        DEFB    04EH    ;02A3H'         'N'      LD C,(HL)
        DEFB    0F0H    ;02A4H'         'p'      RET P
        DEFB    03AH    ;02A5H'         ':'      LD A,(...)
        DEFW    0329H'  ;02A6H'
        DEFB    0CDH    ;02A8H'         'M'      CALL
        DEFB    04EH    ;02A9H'         'N'      LD C,(HL)
        DEFB    0F0H    ;02AAH'         'p'      RET P
        DEFB    0CDH    ;02ABH'         'M'      CALL
        DEFB    048H    ;02ACH'         'H'      LD C,B
        DEFB    0F0H    ;02ADH'         'p'      RET P
        DEFB    0C3H    ;02AEH'         'C'      JP
        DEFB    036H    ;02AFH'         '6'      LD (HL),
        DEFB    0F0H    ;02B0H'         'p'      RET P
        DEFB    04EH    ;02B1H'         'N'      LD C,(HL)
        DEFB    0CDH    ;02B2H'         'M'      CALL
        DEFB    01BH    ;02B3H'                  DEC DE
        DEFB    0F0H    ;02B4H'         'p'      RET P
        DEFB    021H    ;02B5H'         '!'      LD HL,
        DEFB    080H    ;02B6H'                  ADD A,B
        DEFB    00H     ;02B7H'                  NOP
        DEFB    036H    ;02B8H'         '6'      LD (HL),
        DEFB    0E5H    ;02B9H'         'e'      PUSH HL
        DEFB    02CH    ;02BAH'         ','      INC L
        DEFB    020H    ;02BBH'         ' '      JR NZ,
        DEFB    0FBH    ;02BCH'         '{'      EI
        DEFB    01H     ;02BDH'                  LD BC,
        DEFB    02H     ;02BEH'                  LD (BC),A
        DEFB    00H     ;02BFH'                  NOP
        DEFB    0CDH    ;02C0H'         'M'      CALL
        DEFB    01EH    ;02C1H'                  LD E,
        DEFB    0F0H    ;02C2H'         'p'      RET P
        DEFB    01H     ;02C3H'                  LD BC,
        DEFB    00H     ;02C4H'                  NOP
        DEFB    00H     ;02C5H'                  NOP
        DEFB    0C5H    ;02C6H'         'E'      PUSH BC
        DEFB    0CDH    ;02C7H'         'M'      CALL
        DEFB    021H    ;02C8H'         '!'      LD HL,
        DEFB    0F0H    ;02C9H'         'p'      RET P
        DEFB    0CDH    ;02CAH'         'M'      CALL
        DEFB    02AH    ;02CBH'         '*'      LD HL,(...)
        DEFB    0F0H    ;02CCH'         'p'      RET P
        DEFB    0C1H    ;02CDH'         'A'      POP BC
        DEFB    0B7H    ;02CEH'         '7'      OR A
        DEFB    0C2H    ;02CFH'         'B'      JP NZ,
        DEFW    02D9H'  ;02D0H'
        DEFB    03H     ;02D2H'                  INC BC
        DEFB    079H    ;02D3H'         'y'      LD A,C
        DEFB    0FEH    ;02D4H'         '~'      CP
        DEFB    040H    ;02D5H'         '@'      LD B,B
        DEFB    020H    ;02D6H'         ' '      JR NZ,
        DEFB    0EEH    ;02D7H'         'n'      XOR
        DEFB    0C9H    ;02D8H'         'I'      RET
        DEFB    011H    ;02D9H'                  LD DE,
        DEFW    02E6H'  ;02DAH'
        DEFB    0EH     ;02DCH'                  LD C,
        DEFB    09H     ;02DDH'                  ADD HL,BC
        DEFB    0CDH    ;02DEH'         'M'      CALL
        DEFB    05H     ;02DFH'                  DEC B
        DEFB    00H     ;02E0H'                  NOP
        DEFB    0EH     ;02E1H'                  LD C,
        DEFB    01H     ;02E2H'                  LD BC,
        DEFB    0C3H    ;02E3H'         'C'      JP
        DEFB    05H     ;02E4H'                  DEC B
        DEFB    00H     ;02E5H'                  NOP
        DEFB    0DH     ;02E6H'                  DEC C
        DEFB    0AH     ;02E7H'                  LD A,(BC)
        DEFB    048H    ;02E8H'         'H'      LD C,B
        DEFB    069H    ;02E9H'         'i'      LD L,C
        DEFB    074H    ;02EAH'         't'      LD (HL),H
        DEFB    020H    ;02EBH'         ' '      JR NZ,
        DEFB    061H    ;02ECH'         'a'      LD H,C
        DEFB    06EH    ;02EDH'         'n'      LD L,(HL)
        DEFB    079H    ;02EEH'         'y'      LD A,C
        DEFB    020H    ;02EFH'         ' '      JR NZ,
        DEFB    06BH    ;02F0H'         'k'      LD L,E
        DEFB    065H    ;02F1H'         'e'      LD H,L
        DEFB    079H    ;02F2H'         'y'      LD A,C
        DEFB    020H    ;02F3H'         ' '      JR NZ,
        DEFB    074H    ;02F4H'         't'      LD (HL),H
        DEFB    06FH    ;02F5H'         'o'      LD L,A
        DEFB    020H    ;02F6H'         ' '      JR NZ,
        DEFB    061H    ;02F7H'         'a'      LD H,C
        DEFB    062H    ;02F8H'         'b'      LD H,D
        DEFB    06FH    ;02F9H'         'o'      LD L,A
        DEFB    072H    ;02FAH'         'r'      LD (HL),D
        DEFB    074H    ;02FBH'         't'      LD (HL),H
        DEFB    020H    ;02FCH'         ' '      JR NZ,
        DEFB    03AH    ;02FDH'         ':'      LD A,(...)
        DEFB    020H    ;02FEH'         ' '      JR NZ,
        DEFB    024H    ;02FFH'         '$'      INC H
        DEFB    055H    ;0300H'         'U'      LD D,L
        DEFB    032H    ;0301H'         '2'      LD (...),A
        DEFB    020H    ;0302H'         ' '      JR NZ,
        DEFB    032H    ;0303H'         '2'      LD (...),A
        DEFB    020H    ;0304H'         ' '      JR NZ,
        DEFB    04EH    ;0305H'         'N'      LD C,(HL)
        DEFB    030H    ;0306H'         '0'      JR NC,
        DEFB    03AH    ;0307H'         ':'      LD A,(...)
        DEFB    043H    ;0308H'         'C'      LD B,E
        DEFB    050H    ;0309H'         'P'      LD D,B
        DEFB    02FH    ;030AH'         '/'      CPL
        DEFB    04DH    ;030BH'         'M'      LD C,L
        DEFB    020H    ;030CH'         ' '      JR NZ,
        DEFB    056H    ;030DH'         'V'      LD D,(HL)
        DEFB    032H    ;030EH'         '2'      LD (...),A
        DEFB    02EH    ;030FH'         '.'      LD L,
        DEFB    032H    ;0310H'         '2'      LD (...),A
        DEFB    020H    ;0311H'         ' '      JR NZ,
        DEFB    044H    ;0312H'         'D'      LD B,H
        DEFB    049H    ;0313H'         'I'      LD C,C
        DEFB    053H    ;0314H'         'S'      LD D,E
        DEFB    04BH    ;0315H'         'K'      LD C,E
        DEFB    02CH    ;0316H'         ','      INC L
        DEFB    058H    ;0317H'         'X'      LD E,B
        DEFB    058H    ;0318H'         'X'      LD E,B
        DEFB    042H    ;0319H'         'B'      LD B,D
        DEFB    02DH    ;031AH'         '-'      DEC L
        DEFB    050H    ;031BH'         'P'      LD D,B
        DEFB    020H    ;031CH'         ' '      JR NZ,
        DEFB    032H    ;031DH'         '2'      LD (...),A
        DEFB    020H    ;031EH'         ' '      JR NZ,
        DEFB    031H    ;031FH'         '1'      LD SP,
        DEFB    04DH    ;0320H'         'M'      LD C,L
        DEFB    02DH    ;0321H'         '-'      DEC L
        DEFB    057H    ;0322H'         'W'      LD D,A
        DEFB    00H     ;0323H'                  NOP
        DEFB    013H    ;0324H'                  INC DE
        DEFB    01H     ;0325H'                  LD BC,
        DEFB    023H    ;0326H'         '#'      INC HL
        DEFB    032H    ;0327H'         '2'      LD (...),A
        ORG     0329H
        ORG     032AH
        DEFB    053H    ;032AH'         'S'      LD D,E
        DEFB    030H    ;032BH'         '0'      JR NC,
        DEFB    03AH    ;032CH'         ':'      LD A,(...)
        DEFB    02AH    ;032DH'         '*'      LD HL,(...)
        DEFB    053H    ;032EH'         'S'      LD D,E
        DEFB    031H    ;032FH'         '1'      LD SP,
        DEFB    03AH    ;0330H'         ':'      LD A,(...)
        DEFB    02AH    ;0331H'         '*'      LD HL,(...)
        DEFB    030H    ;0332H'         '0'      JR NC,
        DEFB    03AH    ;0333H'         ':'      LD A,(...)
        DEFB    043H    ;0334H'         'C'      LD B,E
        DEFB    050H    ;0335H'         'P'      LD D,B
        DEFB    02FH    ;0336H'         '/'      CPL
        DEFB    04DH    ;0337H'         'M'      LD C,L
        DEFB    031H    ;0338H'         '1'      LD SP,
        DEFB    03AH    ;0339H'         ':'      LD A,(...)
        DEFB    043H    ;033AH'         'C'      LD B,E
        DEFB    050H    ;033BH'         'P'      LD D,B
        DEFB    02FH    ;033CH'         '/'      CPL
        DEFB    04DH    ;033DH'         'M'      LD C,L
        DEFB    030H    ;033EH'         '0'      JR NC,
        DEFB    03AH    ;033FH'         ':'      LD A,(...)
        DEFB    04BH    ;0340H'         'K'      LD C,E
        DEFB    031H    ;0341H'         '1'      LD SP,
        DEFB    03AH    ;0342H'         ':'      LD A,(...)
        DEFB    04BH    ;0343H'         'K'      LD C,E
        ORG     0345H
        ORG     0346H
BUFFIN  EQU     00H'
CFORM   EQU     02B1H'
CREAD   EQU     081H'
CREAD1  EQU     092H'
CREAD2  EQU     08BH'
CWRIT1  EQU     0C6H'
CWRIT2  EQU     0BFH'
CWRIT3  EQU     0E9H'
CWRITE  EQU     0B5H'
DSKERR  EQU     0FCH'
DTYPE   EQU     0EFH'
EXSYS   EQU     08H'
FORMAT  EQU     01EDH'
IDISK   EQU     0F8H'
RDSYS   EQU     016H'
SAVESY  EQU     0161H'
        END

;       end of file
