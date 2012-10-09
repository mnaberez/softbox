; Auto Disassembly of: k
;----- Equates
;
INTVEC = $0090   ;hardware interrupt vector LO
INTVEC+1 = $0091   ;hardware interupt vector HI
KEYBUF = $026F   ;Keyboard Input Buffer
KEYBUF+1 = $0270   ;Keyboard Input Buffer
SCREEN = $8000   ;start of screen ram
SCREEN2 = $8100   ;screen page 2
SCREEN3 = $8200   ;screen page 3
SCREEN4 = $8300   ;screen page 4
SCREEN5 = $8400   ;screen page 5
SCREEN6 = $8500   ;screen page 6
SCREEN7 = $8600   ;screen page 7
SCREEN8 = $8700   ;screen page 8
PIA1ROW = $E810   ;PIA#1 Keyboard Row Select
PIA1COL = $E812   ;PIA#1 Keyboard Columns Read
PIA2IEEE = $E820   ;PIA#2 IEEE Input
PIA2NDAC = $E821   ;PIA#2 IEEE NDAC control
PIA2IOUT = $E822   ;PIA#2 IEEE Output
PIA2DAV = $E823   ;PIA#2 IEEE DAV control
VIAPB = $E840   ;VIA PortB
VIA0C = $E84C   ;VIA Register C
CHROUT = $FFD2   ;Kernal Print a byte
;
*=0400
;
;----- Code
;
$0400:           .BYT 00,0D,04,32,00,9E,28,31 ;tokenized basic
$0408:           .BYT 30,33,39,29,00,00,00    ;tokenized basic
$040F: 4C 66 04  JMP  L_0466
$0412:           .BYT 20,20,53,4F,46,54,42,4F ;copyright text
$041A:           .BYT 58,20,4C,4F,41,44,45,52 ;copyright text
$0422:           .BYT 20,28,43,29,20,43,4F,50 ;copyright text
$042A:           .BYT 59,52,49,47,48,54,20,31 ;copyright text
$0432:           .BYT 39,38,31,20,4B,45,49,54 ;copyright text
$043A:           .BYT 48,20,46,52,45,57,49,4E ;copyright text
$0442:           .BYT 20,20,20,2D,2D,2D,2D,20 ;copyright text
$044A:           .BYT 20,52,45,56,49,53,4F,4E ;copyright text
$0452:           .BYT 20,3A,20,20,35,20,4A,55 ;copyright text
$045A:           .BYT 4C,59,20,31,39,38,31,20 ;copyright text
$0462:           .BYT 20,20,20,20             ;copyright text
:L_0466
$0466: 78        SEI
$0467: A9 4F     LDA #$4F
$0469: 85 90     STA $<INTVEC ;hardware interrupt vector LO
$046B: A9 06     LDA #$06
$046D: 85 91     STA $<INTVEC+1 ;hardware interupt vector HI
$046F: A9 00     LDA #$00
$0471: 85 08     STA $08
$0473: A9 00     LDA #$00
$0475: 85 14     STA $14
$0477: 85 15     STA $15
$0479: 85 16     STA $16
$047B: 85 17     STA $17
$047D: 85 18     STA $18
$047F: 85 19     STA $19
$0481: 85 1A     STA $1A
$0483: A9 0A     LDA #$0A
$0485: 8D 3D 0B  STA $0B3D
$0488: 58        CLI
$0489: A9 0E     LDA #$0E
$048B: 8D 4C E8  STA VIA0C ;VIA Register C
$048E: 20 84 07  JSR  L_0784
$0491: A9 14     LDA #$14
$0493: 85 01     STA $01
$0495: A9 00     LDA #$00
$0497: 85 06     STA $06
$0499: 85 0B     STA $0B
$049B: A9 28     LDA #$28
$049D: 85 09     STA $09
$049F: A9 55     LDA #$55
$04A1: 8D 00 80  STA SCREEN ;start of screen ram
$04A4: 0A        ASL A
$04A5: 8D 00 84  STA SCREEN5 ;screen page 5
$04A8: CD 00 84  CMP SCREEN5 ;screen page 5
$04AB: D0 08     BNE L_04B5
$04AD: 4A        LSR A
$04AE: CD 00 80  CMP SCREEN ;start of screen ram
$04B1: D0 02     BNE L_04B5
$04B3: 06 09     ASL $09
:L_04B5
$04B5: A9 1A     LDA #$1A
$04B7: 20 E8 06  JSR  L_06E8
$04BA: 20 D4 08  JSR  L_08D4
$04BD: AD 22 E8  LDA PIA2IOUT ;PIA#2 IEEE Output
$04C0: AD 40 E8  LDA VIAPB ;VIA PortB
$04C3: 29 FB     AND #$FB
$04C5: 8D 40 E8  STA VIAPB ;VIA PortB
$04C8: A9 34     LDA #$34
$04CA: 8D 23 E8  STA PIA2DAV ;PIA#2 IEEE DAV control
$04CD: A9 C6     LDA #$C6
$04CF: 8D 22 E8  STA PIA2IOUT ;PIA#2 IEEE Output
$04D2: A0 00     LDY #$00
:L_04D4
$04D4: 88        DEY
$04D5: D0 FD     BNE L_04D4
$04D7: A9 FF     LDA #$FF
$04D9: 8D 22 E8  STA PIA2IOUT ;PIA#2 IEEE Output
$04DC: A9 3C     LDA #$3C
$04DE: 8D 11 E8  STA $E811
$04E1: 8D 21 E8  STA PIA2NDAC ;PIA#2 IEEE NDAC control
$04E4: 8D 23 E8  STA PIA2DAV ;PIA#2 IEEE DAV control
:L_04E7
$04E7: A9 3C     LDA #$3C
$04E9: 8D 21 E8  STA PIA2NDAC ;PIA#2 IEEE NDAC control
$04EC: AD 40 E8  LDA VIAPB ;VIA PortB
$04EF: 09 06     ORA #$06
$04F1: 8D 40 E8  STA VIAPB ;VIA PortB
:L_04F4
$04F4: AD 23 E8  LDA PIA2DAV ;PIA#2 IEEE DAV control
$04F7: 0A        ASL A
$04F8: 90 FA     BCC L_04F4
$04FA: AD 22 E8  LDA PIA2IOUT ;PIA#2 IEEE Output
$04FD: A9 34     LDA #$34
$04FF: 8D 21 E8  STA PIA2NDAC ;PIA#2 IEEE NDAC control
$0502: AE 20 E8  LDX PIA2IEEE ;PIA#2 IEEE Input
$0505: 8A        TXA
$0506: 6A        ROR A
$0507: A9 7F     LDA #$7F
$0509: B0 06     BCS L_0511
$050B: A4 08     LDY $08
$050D: D0 02     BNE L_0511
$050F: A9 BF     LDA #$BF
:L_0511
$0511: 8D 22 E8  STA PIA2IOUT ;PIA#2 IEEE Output
:L_0514
$0514: AD 20 E8  LDA PIA2IEEE ;PIA#2 IEEE Input
$0517: 29 3F     AND #$3F
$0519: C9 3F     CMP #$3F
$051B: D0 F7     BNE L_0514
$051D: A9 FF     LDA #$FF
$051F: 8D 22 E8  STA PIA2IOUT ;PIA#2 IEEE Output
$0522: 8A        TXA
$0523: 6A        ROR A
$0524: 90 C1     BCC L_04E7
$0526: 6A        ROR A
$0527: 90 0C     BCC L_0535
$0529: 6A        ROR A
$052A: 90 0C     BCC L_0538
$052C: 6A        ROR A
$052D: 90 17     BCC L_0546
$052F: 6A        ROR A
$0530: 90 5D     BCC L_058F
$0532: 4C 5B 05  JMP  L_055B
:L_0535
$0535: 4C C6 05  JMP  L_05C6
:L_0538
$0538: 20 CF 05  JSR  L_05CF
$053B: A2 3C     LDX #$3C
$053D: 8E 21 E8  STX PIA2NDAC ;PIA#2 IEEE NDAC control
$0540: 20 E8 06  JSR  L_06E8
$0543: 4C E7 04  JMP  L_04E7
:L_0546
$0546: 20 CF 05  JSR  L_05CF
$0549: 85 0D     STA $0D
$054B: 20 CF 05  JSR  L_05CF
$054E: 85 0E     STA $0E
$0550: A2 3C     LDX #$3C
$0552: 8E 21 E8  STX PIA2NDAC ;PIA#2 IEEE NDAC control
$0555: 20 1B 07  JSR  L_071B
$0558: 4C E7 04  JMP  L_04E7
:L_055B
$055B: 20 CF 05  JSR  L_05CF
$055E: 85 11     STA $11
$0560: 20 CF 05  JSR  L_05CF
$0563: 85 12     STA $12
$0565: 20 CF 05  JSR  L_05CF
$0568: 85 0D     STA $0D
$056A: 20 CF 05  JSR  L_05CF
$056D: 85 0E     STA $0E
$056F: A0 00     LDY #$00
:L_0571
$0571: 20 CF 05  JSR  L_05CF
$0574: 91 0D     STA ($0D),Y
$0576: C8        INY
$0577: D0 02     BNE L_057B
$0579: E6 0E     INC $0E
:L_057B
$057B: A5 11     LDA $11
$057D: 38        SEC
$057E: E9 01     SBC #$01
$0580: 85 11     STA $11
$0582: A5 12     LDA $12
$0584: E9 00     SBC #$00
$0586: 85 12     STA $12
$0588: 05 11     ORA $11
$058A: D0 E5     BNE L_0571
$058C: 4C E7 04  JMP  L_04E7
:L_058F
$058F: 20 CF 05  JSR  L_05CF
$0592: 85 11     STA $11
$0594: 20 CF 05  JSR  L_05CF
$0597: 85 12     STA $12
$0599: 20 CF 05  JSR  L_05CF
$059C: 85 0D     STA $0D
$059E: 20 CF 05  JSR  L_05CF
$05A1: 85 0E     STA $0E
$05A3: A0 00     LDY #$00
:L_05A5
$05A5: 88        DEY
$05A6: D0 FD     BNE L_05A5
:L_05A8
$05A8: B1 0D     LDA ($0D),Y
$05AA: 20 FB 05  JSR  L_05FB
$05AD: C8        INY
$05AE: D0 02     BNE L_05B2
$05B0: E6 0E     INC $0E
:L_05B2
$05B2: A5 11     LDA $11
$05B4: 38        SEC
$05B5: E9 01     SBC #$01
$05B7: 85 11     STA $11
$05B9: A5 12     LDA $12
$05BB: E9 00     SBC #$00
$05BD: 85 12     STA $12
$05BF: 05 11     ORA $11
$05C1: D0 E5     BNE L_05A8
$05C3: 4C E7 04  JMP  L_04E7
:L_05C6
$05C6: 20 2E 06  JSR  L_062E
$05C9: 20 FB 05  JSR  L_05FB
$05CC: 4C E7 04  JMP  L_04E7
:L_05CF
$05CF: AD 40 E8  LDA VIAPB ;VIA PortB
$05D2: 09 02     ORA #$02
$05D4: 8D 40 E8  STA VIAPB ;VIA PortB
:L_05D7
$05D7: 2C 40 E8  BIT VIAPB ;VIA PortB
$05DA: 30 FB     BMI L_05D7
$05DC: AD 20 E8  LDA PIA2IEEE ;PIA#2 IEEE Input
$05DF: 49 FF     EOR #$FF
$05E1: 48        PHA
$05E2: AD 40 E8  LDA VIAPB ;VIA PortB
$05E5: 29 FD     AND #$FD
$05E7: 8D 40 E8  STA VIAPB ;VIA PortB
$05EA: A9 3C     LDA #$3C
$05EC: 8D 21 E8  STA PIA2NDAC ;PIA#2 IEEE NDAC control
:L_05EF
$05EF: 2C 40 E8  BIT VIAPB ;VIA PortB
$05F2: 10 FB     BPL L_05EF
$05F4: A9 34     LDA #$34
$05F6: 8D 21 E8  STA PIA2NDAC ;PIA#2 IEEE NDAC control
$05F9: 68        PLA
$05FA: 60        RTS
:L_05FB
$05FB: 49 FF     EOR #$FF
$05FD: 8D 22 E8  STA PIA2IOUT ;PIA#2 IEEE Output
$0600: AD 40 E8  LDA VIAPB ;VIA PortB
$0603: 09 02     ORA #$02
$0605: 8D 40 E8  STA VIAPB ;VIA PortB
$0608: A9 3C     LDA #$3C
$060A: 8D 21 E8  STA PIA2NDAC ;PIA#2 IEEE NDAC control
:L_060D
$060D: 2C 40 E8  BIT VIAPB ;VIA PortB
$0610: 50 FB     BVC L_060D
$0612: A9 34     LDA #$34
$0614: 8D 23 E8  STA PIA2DAV ;PIA#2 IEEE DAV control
:L_0617
$0617: AD 40 E8  LDA VIAPB ;VIA PortB
$061A: 4A        LSR A
$061B: 90 FA     BCC L_0617
$061D: A9 3C     LDA #$3C
$061F: 8D 23 E8  STA PIA2DAV ;PIA#2 IEEE DAV control
$0622: A9 FF     LDA #$FF
$0624: 8D 22 E8  STA PIA2IOUT ;PIA#2 IEEE Output
:L_0627
$0627: AD 40 E8  LDA VIAPB ;VIA PortB
$062A: 4A        LSR A
$062B: B0 FA     BCS L_0627
$062D: 60        RTS
:L_062E
$062E: A9 FF     LDA #$FF
$0630: 78        SEI
$0631: A6 08     LDX $08
$0633: F0 14     BEQ L_0649
$0635: AD 6F 02  LDA KEYBUF ;Keyboard Input Buffer
$0638: 48        PHA
$0639: A2 00     LDX #$00
$063B: C6 08     DEC $08
:L_063D
$063D: BD 70 02  LDA KEYBUF+1,X ;Keyboard Input Buffer
$0640: 9D 6F 02  STA KEYBUF,X ;Keyboard Input Buffer
$0643: E8        INX
$0644: E4 08     CPX $08
$0646: D0 F5     BNE L_063D
$0648: 68        PLA
:L_0649
$0649: 58        CLI
$064A: C9 FF     CMP #$FF
$064C: F0 E0     BEQ L_062E
$064E: 60        RTS
$064F: E6 1A     INC $1A
$0651: D0 06     BNE L_0659
$0653: E6 19     INC $19
$0655: D0 02     BNE L_0659
$0657: E6 18     INC $18
:L_0659
$0659: E6 14     INC $14
$065B: A5 14     LDA $14
$065D: CD 03 04  CMP $0403
$0660: D0 28     BNE L_068A
$0662: A9 00     LDA #$00
$0664: 85 14     STA $14
$0666: E6 15     INC $15
$0668: A5 15     LDA $15
$066A: C9 3C     CMP #$3C
$066C: D0 1C     BNE L_068A
$066E: A9 00     LDA #$00
$0670: 85 15     STA $15
$0672: E6 16     INC $16
$0674: A5 16     LDA $16
$0676: C9 3C     CMP #$3C
$0678: D0 10     BNE L_068A
$067A: A9 00     LDA #$00
$067C: 85 16     STA $16
$067E: E6 17     INC $17
$0680: A5 17     LDA $17
$0682: C9 18     CMP #$18
$0684: D0 04     BNE L_068A
$0686: A9 00     LDA #$00
$0688: 85 17     STA $17
:L_068A
$068A: A5 06     LDA $06
$068C: D0 11     BNE L_069F
$068E: C6 01     DEC $01
$0690: D0 0D     BNE L_069F
$0692: A9 14     LDA #$14
$0694: 85 01     STA $01
$0696: 20 88 09  JSR  L_0988
$0699: B1 02     LDA ($02),Y
$069B: 49 80     EOR #$80
$069D: 91 02     STA ($02),Y
:L_069F
$069F: AD 37 0B  LDA $0B37
$06A2: CD 3E 0B  CMP $0B3E
$06A5: F0 0A     BEQ L_06B1
$06A7: 8D 3E 0B  STA $0B3E
$06AA: A9 10     LDA #$10
$06AC: 8D 3C 0B  STA $0B3C
$06AF: D0 21     BNE L_06D2
:L_06B1
$06B1: C9 FF     CMP #$FF
$06B3: F0 1D     BEQ L_06D2
$06B5: AD 3C 0B  LDA $0B3C
$06B8: F0 05     BEQ L_06BF
$06BA: CE 3C 0B  DEC $0B3C
$06BD: D0 13     BNE L_06D2
:L_06BF
$06BF: CE 3D 0B  DEC $0B3D
$06C2: D0 0E     BNE L_06D2
$06C4: A9 04     LDA #$04
$06C6: 8D 3D 0B  STA $0B3D
$06C9: A9 00     LDA #$00
$06CB: 8D 37 0B  STA $0B37
$06CE: A9 02     LDA #$02
$06D0: 85 01     STA $01
:L_06D2
$06D2: 20 D4 09  JSR  L_09D4
$06D5: F0 0B     BEQ L_06E2
$06D7: A6 08     LDX $08
$06D9: E0 50     CPX #$50
$06DB: F0 05     BEQ L_06E2
$06DD: 9D 6F 02  STA KEYBUF,X ;Keyboard Input Buffer
$06E0: E6 08     INC $08
:L_06E2
$06E2: 68        PLA
$06E3: A8        TAY
$06E4: 68        PLA
$06E5: AA        TAX
$06E6: 68        PLA
$06E7: 40        RTI
:L_06E8
$06E8: 48        PHA
$06E9: A5 06     LDA $06
$06EB: 85 0C     STA $0C
$06ED: A9 FF     LDA #$FF
$06EF: 85 06     STA $06
$06F1: 20 88 09  JSR  L_0988
$06F4: A5 07     LDA $07
$06F6: 91 02     STA ($02),Y
$06F8: 68        PLA
$06F9: 25 13     AND $13
$06FB: A6 0B     LDX $0B
$06FD: D0 16     BNE L_0715
$06FF: C9 20     CMP #$20
$0701: B0 15     BCS L_0718
$0703: 0A        ASL A
$0704: AA        TAX
$0705: BD 1E 07  LDA $071E,X
$0708: 85 0D     STA $0D
$070A: BD 1F 07  LDA $071F,X
$070D: 85 0E     STA $0E
$070F: 20 1B 07  JSR  L_071B
$0712: 4C 8D 07  JMP  L_078D
:L_0715
$0715: 4C B8 09  JMP  L_09B8
:L_0718
$0718: 4C 99 07  JMP  L_0799
:L_071B
$071B: 6C 0D 00  JMP ($000D)

; Command Table
$071E:           .BYT 89,07    ;CMD_00 @ $0789
$0720:           .BYT 7F,07    ;CMD_01 @ $077F
$0722:           .BYT 84,07    ;CMD_02 @ $0784
$0724:           .BYT 89,07    ;CMD_03 @ $0789
$0726:           .BYT C9,08    ;CMD_04 @ $08C9
$0728:           .BYT CC,08    ;CMD_05 @ $08CC
$072A:           .BYT D4,08    ;CMD_06 @ $08D4
$072C:           .BYT 5E,07    ;CMD_07 @ $075E
$072E:           .BYT DD,07    ;CMD_08 @ $07DD
$0730:           .BYT DF,08    ;CMD_09 @ $08DF
$0732:           .BYT 0B,08    ;CMD_0A @ $080B
$0734:           .BYT ED,07    ;CMD_0B @ $07ED
$0736:           .BYT FF,07    ;CMD_0C @ $07FF
$0738:           .BYT 45,08    ;CMD_0D @ $0845
$073A:           .BYT 54,08    ;CMD_0E @ $0854
$073C:           .BYT 59,08    ;CMD_0F @ $0859
$073E:           .BYT 4A,08    ;CMD_10 @ $084A
$0740:           .BYT 3B,09    ;CMD_11 @ $093B
$0742:           .BYT 1E,09    ;CMD_12 @ $091E
$0744:           .BYT 5E,08    ;CMD_13 @ $085E
$0746:           .BYT 6B,08    ;CMD_14 @ $086B
$0748:           .BYT D1,07    ;CMD_15 @ $07D1
$074A:           .BYT D7,07    ;CMD_16 @ $07D7
$074C:           .BYT 71,07    ;CMD_17 @ $0771
$074E:           .BYT 63,07    ;CMD_18 @ $0763
$0750:           .BYT 4F,08    ;CMD_19 @ $084F
$0752:           .BYT 1F,08    ;CMD_1A @ $081F
$0754:           .BYT B3,09    ;CMD_1B @ $09B3
$0756:           .BYT EE,08    ;CMD_1C @ $08EE
$0758:           .BYT 06,09    ;CMD_1D @ $0906
$075A:           .BYT 18,08    ;CMD_1E @ $0818
$075C:           .BYT 89,07    ;CMD_1F @ $0789

;START OF COMMAND 07
:CMD_07
$075E: A9 07     LDA #$07
$0760: 4C D2 FF  JMP CHROUT ;Kernal Print a byte

;START OF COMMAND 18
:CMD_18
$0763: AD 4C E8  LDA VIA0C ;VIA Register C
$0766: 48        PHA
$0767: A9 0E     LDA #$0E
$0769: 20 D2 FF  JSR CHROUT ;Kernal Print a byte
$076C: 68        PLA
$076D: 8D 4C E8  STA VIA0C ;VIA Register C
$0770: 60        RTS

;START OF COMMAND 17
;CMD_17
$0771: AD 4C E8  LDA VIA0C ;VIA Register C
$0774: 48        PHA
$0775: A9 8E     LDA #$8E
$0777: 20 D2 FF  JSR CHROUT ;Kernal Print a byte
$077A: 68        PLA
$077B: 8D 4C E8  STA VIA0C ;VIA Register C
$077E: 60        RTS

;START OF COMMAND 01
:CMD_01
$077F: A9 FF     LDA #$FF
$0781: 85 13     STA $13
$0783: 60        RTS

;START OF COMMAND 02
:CMD_02
:L_0784
$0784: A9 7F     LDA #$7F
$0786: 85 13     STA $13
$0788: 60        RTS

;START OF COMMANDS 00, 03, 1F
:CMD_00
:CMD_03
:CMD_1F
$0789: 60        RTS

:L_078A
$078A: 20 F4 07  JSR  L_07F4
:L_078D
$078D: 20 88 09  JSR  L_0988
$0790: B1 02     LDA ($02),Y
$0792: 85 07     STA $07
$0794: A5 0C     LDA $0C
$0796: 85 06     STA $06
$0798: 60        RTS
:L_0799
$0799: C9 40     CMP #$40
$079B: 90 ED     BCC L_078A
$079D: C9 60     CMP #$60
$079F: B0 05     BCS L_07A6
$07A1: 29 3F     AND #$3F
$07A3: 4C AC 07  JMP  L_07AC
:L_07A6
$07A6: C9 80     CMP #$80
$07A8: B0 20     BCS L_07CA
$07AA: 29 5F     AND #$5F
:L_07AC
$07AC: AA        TAX
$07AD: 29 3F     AND #$3F
$07AF: F0 15     BEQ L_07C6
$07B1: C9 1B     CMP #$1B
$07B3: B0 11     BCS L_07C6
$07B5: 8A        TXA
$07B6: 49 40     EOR #$40
$07B8: AA        TAX
$07B9: AD 4C E8  LDA VIA0C ;VIA Register C
$07BC: 4A        LSR A
$07BD: 4A        LSR A
$07BE: B0 06     BCS L_07C6
$07C0: 8A        TXA
$07C1: 29 1F     AND #$1F
$07C3: 4C 8A 07  JMP  L_078A
:L_07C6
$07C6: 8A        TXA
$07C7: 4C 8A 07  JMP  L_078A
:L_07CA
$07CA: 29 7F     AND #$7F
$07CC: 09 40     ORA #$40
$07CE: 4C 8A 07  JMP  L_078A

;START OF COMMAND 15
:CMD_15
$07D1: A9 0C     LDA #$0C
$07D3: 8D 4C E8  STA VIA0C ;VIA Register C
$07D6: 60        RTS

;START OF COMMAND 16
:CMD_16
$07D7: A9 0E     LDA #$0E
$07D9: 8D 4C E8  STA VIA0C ;VIA Register C
$07DC: 60        RTS

;START OF COMMAND 08
:CMD_08
$07DD: A6 04     LDX $04
$07DF: D0 08     BNE L_07E9
$07E1: A6 09     LDX $09
$07E3: A5 05     LDA $05
$07E5: F0 05     BEQ L_07EC
$07E7: C6 05     DEC $05
:L_07E9
$07E9: CA        DEX
$07EA: 86 04     STX $04
:L_07EC
$07EC: 60        RTS

;START OF COMMAND 0B
;CMD_0B
$07ED: A4 05     LDY $05
$07EF: F0 FB     BEQ L_07EC
$07F1: C6 05     DEC $05
$07F3: 60        RTS
:L_07F4
$07F4: A6 0A     LDX $0A
$07F6: F0 02     BEQ L_07FA
$07F8: 49 80     EOR #$80
:L_07FA
$07FA: 20 88 09  JSR  L_0988
$07FD: 91 02     STA ($02),Y

;START OF COMMAND 0C
:CMD_0C
$07FF: E6 04     INC $04
$0801: A6 04     LDX $04
$0803: E4 09     CPX $09
$0805: D0 10     BNE L_0817
$0807: A9 00     LDA #$00
$0809: 85 04     STA $04

;START OF COMMAND 0A
:CMD_0A
$080B: A4 05     LDY $05
$080D: C0 18     CPY #$18
$080F: D0 03     BNE L_0814
$0811: 4C 8E 08  JMP  L_088E
:L_0814
$0814: E6 05     INC $05
$0816: 60        RTS
:L_0817
$0817: 60        RTS

;START OF COMMAND 1E
:CMD_1E
$0818: A9 00     LDA #$00
$081A: 85 05     STA $05
$081C: 85 04     STA $04
$081E: 60        RTS

;START OF COMMAND 1A
:CMD_1A
$081F: A2 00     LDX #$00
$0821: 86 04     STX $04
$0823: 86 05     STX $05
$0825: 86 0A     STX $0A
$0827: A9 20     LDA #$20
:L_0829
$0829: 9D 00 80  STA SCREEN,X ;start of screen ram
$082C: 9D 00 81  STA SCREEN2,X ;screen page 2
$082F: 9D 00 82  STA SCREEN3,X ;screen page 3
$0832: 9D 00 83  STA SCREEN4,X ;screen page 4
$0835: 9D 00 84  STA SCREEN5,X ;screen page 5
$0838: 9D 00 85  STA SCREEN6,X ;screen page 6
$083B: 9D 00 86  STA SCREEN7,X ;screen page 7
$083E: 9D 00 87  STA SCREEN8,X ;screen page 8
$0841: E8        INX
$0842: D0 E5     BNE L_0829
$0844: 60        RTS

;START OF COMMAND 0D
:CMD_0D
$0845: A9 00     LDA #$00
$0847: 85 04     STA $04
$0849: 60        RTS

;START OF COMMAND 10
:CMD_10
$084A: A9 00     LDA #$00
$084C: 85 0C     STA $0C
$084E: 60        RTS

;START OF COMMAND 19
:CMD_19
$084F: A9 FF     LDA #$FF
$0851: 85 0C     STA $0C
$0853: 60        RTS

;START OF COMMAND 0E
:CMD_0E
$0854: A9 01     LDA #$01
$0856: 85 0A     STA $0A
$0858: 60        RTS

;START OF COMMAND 0F
;CMD_OF
$0859: A9 00     LDA #$00
$085B: 85 0A     STA $0A
$085D: 60        RTS

;START OF COMMAND 13
:CMD_13
:L_085E
$085E: 20 88 09  JSR  L_0988
$0861: A9 20     LDA #$20
:L_0863
$0863: 91 02     STA ($02),Y
$0865: C8        INY
$0866: C4 09     CPY $09
$0868: D0 F9     BNE L_0863
$086A: 60        RTS

;START OF COMMAND 14
:CMD_14
$086B: 20 5E 08  JSR  L_085E
$086E: A6 05     LDX $05
:L_0870
$0870: E8        INX
$0871: E0 19     CPX #$19
$0873: F0 18     BEQ L_088D
$0875: 18        CLC
$0876: A5 02     LDA $02
$0878: 65 09     ADC $09
$087A: 85 02     STA $02
$087C: 90 02     BCC L_0880
$087E: E6 03     INC $03
:L_0880
$0880: A9 20     LDA #$20
$0882: A0 00     LDY #$00
:L_0884
$0884: 91 02     STA ($02),Y
$0886: C8        INY
$0887: C4 09     CPY $09
$0889: D0 F9     BNE L_0884
$088B: F0 E3     BEQ L_0870
:L_088D
$088D: 60        RTS
:L_088E
$088E: A9 00     LDA #$00
$0890: 85 02     STA $02
$0892: A5 09     LDA $09
$0894: 85 0D     STA $0D
$0896: A9 80     LDA #$80
$0898: 85 03     STA $03
$089A: 85 0E     STA $0E
$089C: A2 18     LDX #$18
:L_089E
$089E: A0 00     LDY #$00
:L_08A0
$08A0: B1 0D     LDA ($0D),Y
$08A2: 91 02     STA ($02),Y
$08A4: C8        INY
$08A5: C4 09     CPY $09
$08A7: D0 F7     BNE L_08A0
$08A9: A5 0D     LDA $0D
$08AB: 85 02     STA $02
$08AD: 18        CLC
$08AE: 65 09     ADC $09
$08B0: 85 0D     STA $0D
$08B2: A5 0E     LDA $0E
$08B4: 85 03     STA $03
$08B6: 69 00     ADC #$00
$08B8: 85 0E     STA $0E
$08BA: CA        DEX
$08BB: D0 E1     BNE L_089E
$08BD: A0 00     LDY #$00
$08BF: A9 20     LDA #$20
:L_08C1
$08C1: 91 02     STA ($02),Y
$08C3: C8        INY
$08C4: C4 09     CPY $09
$08C6: D0 F9     BNE L_08C1
$08C8: 60        RTS

;START OF COMMAND 04
:CMD_04
$08C9: A9 01     LDA #$01
$08CB:           .BYT 2C

;START OF COMMAND 05
:CMD_05
$08CC: A9 00     LDA #$00
$08CE: A6 04     LDX $04
$08D0: 9D 3F 0B  STA $0B3F,X
$08D3: 60        RTS

;START OF COMMAND 06
:CMD_06
:L_08D4
$08D4: A2 4F     LDX #$4F
$08D6: A9 00     LDA #$00
:L_08D8
$08D8: 9D 3F 0B  STA $0B3F,X
$08DB: CA        DEX
$08DC: 10 FA     BPL L_08D8
$08DE: 60        RTS

;START OF COMMAND 09
:CMD_09
$08DF: A6 04     LDX $04
:L_08E1
$08E1: E8        INX
$08E2: E0 50     CPX #$50
$08E4: B0 07     BCS L_08ED
$08E6: BD 3F 0B  LDA $0B3F,X
$08E9: F0 F6     BEQ L_08E1
$08EB: 86 04     STX $04
:L_08ED
$08ED: 60        RTS

;START OF COMMAND 1C
:CMD_1C
$08EE: 20 88 09  JSR  L_0988
$08F1: A4 09     LDY $09
$08F3: 88        DEY
:L_08F4
$08F4: C4 04     CPY $04
$08F6: F0 09     BEQ L_0901
$08F8: 88        DEY
$08F9: B1 02     LDA ($02),Y
$08FB: C8        INY
$08FC: 91 02     STA ($02),Y
$08FE: 88        DEY
$08FF: D0 F3     BNE L_08F4
:L_0901
$0901: A9 20     LDA #$20
$0903: 91 02     STA ($02),Y
$0905: 60        RTS

;START OF COMMAND 1D
:CMD_1D
$0906: 20 88 09  JSR  L_0988
$0909: A4 04     LDY $04
:L_090B
$090B: C8        INY
$090C: C4 09     CPY $09
$090E: F0 08     BEQ L_0918
$0910: B1 02     LDA ($02),Y
$0912: 88        DEY
$0913: 91 02     STA ($02),Y
$0915: C8        INY
$0916: D0 F3     BNE L_090B
:L_0918
$0918: 88        DEY
$0919: A9 20     LDA #$20
$091B: 91 02     STA ($02),Y
$091D: 60        RTS

;START OF COMMAND 12
:CMD_12
$091E: A9 00     LDA #$00
$0920: 85 04     STA $04
$0922: 20 88 09  JSR  L_0988
$0925: A5 02     LDA $02
$0927: 18        CLC
$0928: 65 09     ADC $09
$092A: 85 0D     STA $0D
$092C: A5 03     LDA $03
$092E: 69 00     ADC #$00
$0930: 85 0E     STA $0E
$0932: A9 18     LDA #$18
$0934: 38        SEC
$0935: E5 05     SBC $05
$0937: AA        TAX
$0938: 4C 9E 08  JMP  L_089E

;START OF COMMAND 11
:CMD_11
$093B: A9 C0     LDA #$C0
$093D: A0 83     LDY #$83
$093F: A6 09     LDX $09
$0941: E0 50     CPX #$50
$0943: D0 04     BNE L_0949
$0945: A9 80     LDA #$80
$0947: A0 87     LDY #$87
:L_0949
$0949: 85 0D     STA $0D
$094B: 84 0E     STY $0E
$094D: A9 00     LDA #$00
$094F: 85 04     STA $04
:L_0951
$0951: A5 0D     LDA $0D
$0953: C5 02     CMP $02
$0955: D0 06     BNE L_095D
$0957: A5 0E     LDA $0E
$0959: C5 03     CMP $03
$095B: F0 1F     BEQ L_097C
:L_095D
$095D: A5 0D     LDA $0D
$095F: 85 0F     STA $0F
$0961: 38        SEC
$0962: E5 09     SBC $09
$0964: 85 0D     STA $0D
$0966: A5 0E     LDA $0E
$0968: 85 10     STA $10
$096A: E9 00     SBC #$00
$096C: 85 0E     STA $0E
$096E: A0 00     LDY #$00
:L_0970
$0970: B1 0D     LDA ($0D),Y
$0972: 91 0F     STA ($0F),Y
$0974: C8        INY
$0975: C4 09     CPY $09
$0977: D0 F7     BNE L_0970
$0979: 4C 51 09  JMP  L_0951
:L_097C
$097C: A0 00     LDY #$00
$097E: A9 20     LDA #$20
:L_0980
$0980: 91 02     STA ($02),Y
$0982: C8        INY
$0983: C4 09     CPY $09
$0985: D0 F9     BNE L_0980
$0987: 60        RTS
:L_0988
$0988: 48        PHA
$0989: A9 00     LDA #$00
$098B: 85 03     STA $03
$098D: A5 05     LDA $05
$098F: 85 02     STA $02
$0991: 0A        ASL A
$0992: 0A        ASL A
$0993: 65 02     ADC $02
$0995: 0A        ASL A
$0996: 0A        ASL A
$0997: 26 03     ROL $03
$0999: 0A        ASL A
$099A: 26 03     ROL $03
$099C: 85 02     STA $02
$099E: A5 09     LDA $09
$09A0: C9 50     CMP #$50
$09A2: D0 04     BNE L_09A8
$09A4: 06 02     ASL $02
$09A6: 26 03     ROL $03
:L_09A8
$09A8: 18        CLC
$09A9: A4 04     LDY $04
$09AB: A5 03     LDA $03
$09AD: 69 80     ADC #$80
$09AF: 85 03     STA $03
$09B1: 68        PLA
$09B2: 60        RTS

;START OF COMMAND 1B
:CMD_1B
$09B3: A9 02     LDA #$02
$09B5: 85 0B     STA $0B
$09B7: 60        RTS
:L_09B8
$09B8: C6 0B     DEC $0B
$09BA: F0 0C     BEQ L_09C8
$09BC: 38        SEC
$09BD: E9 20     SBC #$20
$09BF: C5 09     CMP $09
$09C1: B0 02     BCS L_09C5
$09C3: 85 04     STA $04
:L_09C5
$09C5: 4C 8D 07  JMP  L_078D
:L_09C8
$09C8: 38        SEC
$09C9: E9 20     SBC #$20
$09CB: C9 19     CMP #$19
$09CD: B0 F6     BCS L_09C5
$09CF: 85 05     STA $05
$09D1: 4C 8D 07  JMP  L_078D
:L_09D4
$09D4: AD 37 0B  LDA $0B37
$09D7: 8D 38 0B  STA $0B38
$09DA: A2 00     LDX #$00
$09DC: 8E 3A 0B  STX $0B3A
$09DF: 8E 3B 0B  STX $0B3B
$09E2: 8E 10 E8  STX PIA1ROW ;PIA#1 Keyboard Row Select
$09E5: A9 FF     LDA #$FF
$09E7: 8D 37 0B  STA $0B37
$09EA: A9 0A     LDA #$0A
$09EC: 8D 39 0B  STA $0B39
:L_09EF
$09EF: A0 08     LDY #$08
:L_09F1
$09F1: AD 12 E8  LDA PIA1COL ;PIA#1 Keyboard Columns Read
$09F4: CD 12 E8  CMP PIA1COL ;PIA#1 Keyboard Columns Read
$09F7: D0 F8     BNE L_09F1
:L_09F9
$09F9: 4A        LSR A
$09FA: 48        PHA
$09FB: B0 22     BCS L_0A1F
$09FD: A5 09     LDA $09
$09FF: C9 50     CMP #$50
$0A01: D0 06     BNE L_0A09
$0A03: BD E7 0A  LDA $0AE7,X
$0A06: 4C 0C 0A  JMP  L_0A0C
:L_0A09
$0A09: BD 97 0A  LDA $0A97,X
:L_0A0C
$0A0C: C9 01     CMP #$01
$0A0E: F0 07     BEQ L_0A17
$0A10: 90 0A     BCC L_0A1C
$0A12: 8D 37 0B  STA $0B37
$0A15: B0 08     BCS L_0A1F
:L_0A17
$0A17: EE 3A 0B  INC $0B3A
$0A1A: D0 03     BNE L_0A1F
:L_0A1C
$0A1C: EE 3B 0B  INC $0B3B
:L_0A1F
$0A1F: 68        PLA
$0A20: E8        INX
$0A21: 88        DEY
$0A22: D0 D5     BNE L_09F9
$0A24: EE 10 E8  INC PIA1ROW ;PIA#1 Keyboard Row Select
$0A27: CE 39 0B  DEC $0B39
$0A2A: D0 C3     BNE L_09EF
$0A2C: AD 37 0B  LDA $0B37
$0A2F: C9 FF     CMP #$FF
$0A31: F0 22     BEQ L_0A55
$0A33: CD 38 0B  CMP $0B38
$0A36: F0 1D     BEQ L_0A55
$0A38: C9 00     CMP #$00
$0A3A: 10 0A     BPL L_0A46
$0A3C: 29 7F     AND #$7F
$0A3E: AC 3A 0B  LDY $0B3A
$0A41: F0 03     BEQ L_0A46
$0A43: 49 10     EOR #$10
$0A45: 60        RTS
:L_0A46
$0A46: C9 40     CMP #$40
$0A48: 90 25     BCC L_0A6F
$0A4A: C9 60     CMP #$60
$0A4C: B0 21     BCS L_0A6F
$0A4E: AC 3B 0B  LDY $0B3B
$0A51: F0 03     BEQ L_0A56
$0A53: 29 1F     AND #$1F
:L_0A55
$0A55: 60        RTS
:L_0A56
$0A56: C9 40     CMP #$40
$0A58: F0 15     BEQ L_0A6F
$0A5A: C9 5B     CMP #$5B
$0A5C: B0 11     BCS L_0A6F
$0A5E: AC 3A 0B  LDY $0B3A
$0A61: D0 0C     BNE L_0A6F
$0A63: 48        PHA
$0A64: AD 4C E8  LDA VIA0C ;VIA Register C
$0A67: 4A        LSR A
$0A68: 4A        LSR A
$0A69: 68        PLA
$0A6A: 90 03     BCC L_0A6F
$0A6C: 09 20     ORA #$20
$0A6E: 60        RTS
:L_0A6F
$0A6F: AC 3A 0B  LDY $0B3A
$0A72: F0 20     BEQ L_0A94
$0A74: A2 0B     LDX #$0B
$0A76: C9 0A     CMP #$0A
$0A78: F0 18     BEQ L_0A92
$0A7A: A2 08     LDX #$08
$0A7C: C9 0C     CMP #$0C
$0A7E: F0 12     BEQ L_0A92
$0A80: A2 1A     LDX #$1A
$0A82: C9 1E     CMP #$1E
$0A84: F0 0C     BEQ L_0A92
$0A86: 48        PHA
$0A87: AD 4C E8  LDA VIA0C ;VIA Register C
$0A8A: 4A        LSR A
$0A8B: 4A        LSR A
$0A8C: 68        PLA
$0A8D: B0 05     BCS L_0A94
$0A8F: 09 80     ORA #$80
$0A91: 60        RTS
:L_0A92
$0A92: 8A        TXA
$0A93: 60        RTS
:L_0A94
$0A94: C9 00     CMP #$00
$0A96: 60        RTS
$0A97:           .BYT 21,23,25,26,28,5F,1E,0C ;keyboard table 1
$0A9F:           .BYT 22,24,27,5C,29,FF,0A,7F ;keyboard table 1
$0AA7:           .BYT 51,45,54,55,4F,5E,37,39 ;keyboard table 1
$0AAF:           .BYT 57,52,59,49,50,FF,38,2F ;keyboard table 1
$0AB7:           .BYT 41,44,47,4A,4C,FF,34,36 ;keyboard table 1
$0ABF:           .BYT 53,46,48,4B,3A,FF,35,2A ;keyboard table 1
$0AC7:           .BYT 5A,43,42,4D,3B,0D,31,33 ;keyboard table 1
$0ACF:           .BYT 58,56,4E,2C,3F,FF,32,2B ;keyboard table 1
$0AD7:           .BYT 01,40,5D,FF,3E,01,30,2D ;keyboard table 1
$0ADF:           .BYT 00,5B,20,3C,1B,FF,2E,3D ;keyboard table 1
$0AE7:           .BYT B2,B5,B8,AD,38,0C,FF,FF ;keyboard table 2
$0AEF:           .BYT B1,B4,B7,30,37,5E,FF,39 ;keyboard table 2
$0AF7:           .BYT 1B,53,46,48,5D,4B,BB,35 ;keyboard table 2
$0AFF:           .BYT 41,44,47,4A,0D,4C,40,36 ;keyboard table 2
$0B07:           .BYT 09,57,52,59,5C,49,50,7F ;keyboard table 2
$0B0F:           .BYT 51,45,54,55,0A,4F,5B,34 ;keyboard table 2
$0B17:           .BYT 01,43,42,AE,2E,FF,01,33 ;keyboard table 2
$0B1F:           .BYT 5A,56,4E,AC,30,FF,FF,32 ;keyboard table 2
$0B27:           .BYT 00,58,20,4D,1E,FF,AF,31 ;keyboard table 2
$0B2F:           .BYT 5F,B3,B6,B9,FF,BA,FF,FF ;keyboard table 2
$0B37:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B3F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B47:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B4F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B57:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B5F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B67:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B6F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B77:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B7F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B87:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B8F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B97:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0B9F:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0BA7:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0BAF:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0BB7:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0BBF:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0BC7:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0BCF:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0BD7:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0BDF:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0BE7:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0BEF:           .BYT AA,AA,AA,AA,AA,AA,AA,AA ;filler
$0BF7:           .BYT AA,AA,AA,AA,AA,AA       ;filler
