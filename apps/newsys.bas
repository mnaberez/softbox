0 ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1 ' +                                                           +
2 ' +  CP/M Reconfiguration program                             +
3 ' +  For the PET CP/M Box.                                    +
4 ' +                                                           +
5 ' +  (c) May 1981 by Keith Frewin                             +
6 ' +  Patches by David Goodman .  May 1983                     +
7 ' +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
8 '
9 ' Calls library module "LOADSAVE.MAC"
10'
15 OPTION BASE 0
20 DEFINT A-Z
21 MINI = 0  ' set to 1 if Mini Winnie,  0 if Corvus version
25 iobyte=0
30 DIM DRV(10),DISKDEV(10), AUTOLOAD (120), SCRTAB (64)
40 BIAS = &H0C00 'System buffer at 4000 hex
50 LOADER = &H6002 ' loader routine buffer (first 2 bytes are address)
200 GOSUB 9000 ' Clear screen
210 PRINT
220 PRINT "CP/M  Reconfiguration
230 PRINT "----  ---------------
240 PRINT
241 IF MINI=1 THEN PRINT "Mini-winchester version
242 PRINT "Revision 3   --   19 February 1982
243 PRINT: PRINT
250 PRINT "Source drive (A to P) ? ";
260 GOSUB 9100
270 IF R=0 THEN 300 '************ NO SOURCE DRIVE
280 IF (R<&H41) or (R>&H50) THEN GOTO 200
285 R=R-&H41 :DT=R : CALL DTYPE (DT) : IF DT >128 THEN 200 'Unassigned drive
286 IF (DT>=2) AND (DT <=5) THEN CALL CREAD(R): GOTO 300 ' Corvus drive
290 CALL IDISK(R): CALL RDSYS(R) : CALL DSKERR (E) ' Commodore floppy
295 IF E THEN END
300 DIRSIZE= PEEK (BIAS+&H38B2) ' Source system has been read - get values
310 IOBYTE = PEEK (BIAS+&H4A60)
320 LPT = PEEK (BIAS+&H4A61)
330 RDR = PEEK (BIAS+&H4A62)
340 PUN = PEEK (BIAS+&H4A63)
350 U = PEEK (BIAS+&H4A64)
360 BAUD = PEEK (BIAS+&H4A65)
361 UL1 = PEEK (BIAS+&H4A66)
365 TERMTYPE = PEEK (BIAS+&H4A67)
366 LEADIN = PEEK (BIAS+&H4A68)
367 ORDER = PEEK (BIAS+&H4A69)
368 ROWOFF = PEEK (BIAS+&H4A6A)
369 COLOFF = PEEK (BIAS+&H4A6B)
370 FOR J=0 TO 7: DRV(J)=PEEK (BIAS+&H4A70+J):DISKDEV(J)=PEEK(BIAS+&H4A78+J)
375 NEXT J
380 FOR J=0 TO 80: AUTOLOAD (J)=PEEK (BIAS+&H3407+J) : NEXT J
390 FOR J=0 TO 63: SCRTAB (J) = PEEK (BIAS+&H4A80+J) : NEXT J
400 CLOCK=PEEK (LOADER+3)
410 LPTYPE = PEEK (BIAS+&H4A6D)
990 ' *************************************************
1000 GOSUB 9000 : REM CLEAR SCREEN
1010 PRINT
1020 PRINT "CP/M  Re-configuration
1030 PRINT"----  ----------------
1040 PRINT
1060 PRINT"A - Autoload command
1070 PRINT
1080 PRINT "D - Disk drive assignment
1090 PRINT
1100 PRINT "I - I/O assignment
1110 PRINT 
1120 PRINT "P - PET terminal parameters
1130 PRINT
1140 PRINT "R - RS232 characteristics
1150 PRINT
1160 PRINT "S - Save new system
1170 PRINT 
1180 PRINT "E - Execute new system
1190 PRINT
1200 PRINT "Q - Quit this program
1210 PRINT 
1220 PRINT"Please enter the appropriate letter : ";
1230 GOSUB 9100
1240 IF R=&H52 THEN GOTO 2000
1250 IF R=&H51 THEN END
1260 IF R=&H49 THEN GOTO 3000
1270 IF R=&H44 THEN GOTO 4000
1280 IF R=&H41 THEN GOTO 5000
1290 IF R=&H45 THEN GOTO 6000
1295 IF R=&H53 THEN GOTO 7000
1296 IF R=&H50 THEN GOTO 8000
1300 GOTO 1000
2000 REM ******************************************
2001 ' RS232 setup
2002 GOSUB 9000
2010 PRINT "           RS232 Characteristics
2020 PRINT "           ----- ---------------
2030 PRINT
2040 PRINT" 1.  Character size :          ";
2050 PRINT CHR$((U AND 12) \4 + &H35)
2060 PRINT
2100 PRINT" 2.  Number of stop bits :     ";
2110 U1 = U AND &HC0 : IF U1=0 THEN PRINT"undefined
2120 IF U1=&H40 THEN PRINT"1"
2130 IF U1=&H80 THEN PRINT "1.5
2140 IF U1=&HC0 THEN PRINT"2
2150 PRINT
2200 PRINT" 3.  Parity :                  ";
2210 IF (U AND &H10) = 0 THEN PRINT"none
2220 IF (U AND &H30) = &H30 THEN PRINT"even
2230 IF (U AND &H30) = &H10 THEN PRINT"odd
2240 PRINT
2250 PRINT " 4.  Baud rate :               ";
2260 IF BAUD=&H22 THEN PRINT"110
2261 IF BAUD=&H55 THEN PRINT"300
2262 IF BAUD =&H77 THEN PRINT"1200
2263 IF BAUD =&HEE THEN PRINT"9600
2264 IF BAUD =&HFF THEN PRINT"19200
2265 IF BAUD =&HCC THEN PRINT"4800
2270 PRINT
2280 PRINT "Alter which characteristic (1-4) ? ";
2290 GOSUB 9100
2300 IF R=&H31 THEN GOTO 2500
2310 IF R=0 THEN GOTO 1000
2320 IF R=&H32 THEN GOTO 2600
2330 IF R=&H33 THEN GOTO 2700
2331 IF R=&H34 THEN GOTO 2800
2340 GOTO 2000
2500 PRINT "New character length (5 to 8) ? ";
2510 GOSUB 9100
2520 R=R-&H35
2530 IF (R>=0) AND (R<4) THEN U=(U AND &HF3) OR (R*4)
2540 GOTO 2000
2600 PRINT "Number of stop bits (1 or 2)  ? ";
2610 GOSUB 9100
2620 IF R=&H31 THEN U=(U AND &H3F) OR &H40
2630 IF R=&H32 THEN U=(U AND &H3F) OR &HC0
2640 GOTO 2000
2700 PRINT"O(dd), E(ven) or N(o parity) ? ";
2710 GOSUB 9100
2720 IF R=&H4F THEN U=(U AND &HCF) OR &H10
2730 IF R=&H45 THEN U=U OR &H30
2740 IF R=&H4E THEN U=U AND &HEF
2750 GOTO 2000
2800 PRINT: PRINT"110, 300, 1200, 4800, 9600 or
2801 PRINT"19200 baud ? ";
2820 GOSUB 9100
2830 IF N=110 THEN BAUD=&H22 ELSE IF N=300 THEN BAUD=&H55
2840 IF N=1200 THEN BAUD=&H77 ELSE IF N=9600 THEN BAUD=&HEE
2850 IF N=4800 THEN BAUD=&HCC
2860 IF N=19200 THEN BAUD=&HFF
2870 GOTO 2000
3000 '*********************************************
3010 'I/O SETUP
3020 '*********************************************
3030 GOSUB 9000
3040 PRINT"             I/O device assignment
3050 PRINT"             --- ------ ----------
3051 PRINT
3052 PRINT"1.  Pet printer device # :    "; LPT
3060 PRINT
3070 PRINT"2.  ASCII printer device # :  "; UL1
3080 PRINT
3090 PRINT"3.  Reader device # :         "; RDR
3100 PRINT
3101 PRINT"4.  Punch device # :          "; PUN
3102 PRINT
3103 PRINT"5.  Default LST: device :     ";
3104 IF (IOBYTE AND &HC0) =0 THEN PRINT"TTY:
3105 IF (IOBYTE AND &HC0) =&H40 THEN PRINT"CRT:
3106 IF (IOBYTE AND &HC0) =&H80 THEN PRINT"LPT:
3107 IF (IOBYTE AND &HC0) =&HC0 THEN PRINT"UL1:
3110 PRINT
3111 PRINT"6.  Default RDR: device :     ";
3112 IF (IOBYTE AND &H0C)= 0 THEN PRINT "TTY:" ELSE PRINT "PTR:"
3113 PRINT
3114 PRINT"7.  Default PUN: device :     ";
3115 IF (IOBYTE AND &H30)= 0 THEN PRINT "TTY:" ELSE PRINT "PTP:"
3116 PRINT
3120 PRINT"8.  PET printer type :        ";
3121 IF LPTYPE = 0 THEN PRINT "3022/4022
3122 IF LPTYPE = 1 THEN PRINT "8026/8027
3123 IF LPTYPE = 2 THEN PRINT "8024
3125 PRINT
3130 PRINT : PRINT"Alter which (1-8) ? ";
3140 GOSUB 9100
3141 IF R=0 THEN GOTO 1000
3142 IF R=&H36 THEN 3360
3143 IF R=&H37 THEN 3400
3146 IF R=&H35 THEN 3300
3147 IF R=&H38 THEN 3500
3150 R1 = R : PRINT"New device # ? "; : GOSUB 9100
3151 IF R1=&H31 THEN LPT=N
3160 IF R1= &H32 THEN UL1=N
3170 IF R1=&H33 THEN RDR=N
3180 IF R1=&H34 THEN PUN=N
3190 GOTO 3000
3300 PRINT
3301 PRINT"T(TY:) --  RS232 printer
3302 PRINT"C(RT:) --  PET screen
3303 PRINT"L(PT:) --  PET IEEE printer
3304 PRINT"U(L1:) --  ASCII IEEE printer
3305 PRINT
3310 PRINT "Which list device (T, C, L or U) ? ";:GOSUB 9100
3320 IF R=&H54 THEN IOBYTE=(IOBYTE AND &H3F)
3330 IF R=&H43 THEN IOBYTE=(IOBYTE AND &H3F) OR &H40
3340 IF R=&H4C THEN IOBYTE  =(IOBYTE AND &H3F) OR &H80
3341 IF R=&H55 THEN IOBYTE=(IOBYTE AND &H3F) OR &HC0
3350 GOTO 3000
3360 PRINT "T(TY:) or P(TR:) ? "; : GOSUB 9100
3370 IF R=&H54 THEN IOBYTE=(IOBYTE AND &HF3)
3380 IF R=&H50 THEN IOBYTE=(IOBYTE AND &HF3) OR &H04
3390 GOTO 3000  
3400 PRINT "T(TY:) or P(TP:) ? "; : GOSUB 9100
3410 IF R=&H54 THEN IOBYTE=(IOBYTE AND &HCF)
3420 IF R=&H50 THEN IOBYTE=(IOBYTE AND &HCF) OR &H10
3430 GOTO 3000
3500 PRINT
3510 PRINT "3 = 3022, 3023, 4022 or 4023
3520 PRINT "8 = 8024
3530 PRINT "D = 8026 or 8027 (daisywheel)
3540 PRINT : PRINT "Which type of printer (3, 8 or D) ? ";:GOSUB 9100
3550 IF R=&H33 THEN LPTYPE = 0
3560 IF R=&H38 THEN LPTYPE = 2
3570 IF R=&H44 THEN LPTYPE = 1
3580 GOTO 3000
4000 ' **************************************************
4010 'Disk drives
4020 GOSUB 9000
4030 PRINT"            Disk drive assignment
4040 PRINT"            ---- ----- ----------
4050 PRINT
4060 PRINT"A, B :     "; : D=0: GOSUB 4900
4070 PRINT"C, D :     "; : D=1: GOSUB 4900
4080 PRINT"E, F :     "; : D=2: GOSUB 4900
4090 PRINT"G, H :     "; : D=3: GOSUB 4900
4100 PRINT"I, J :     "; : D=4: GOSUB 4900
4110 PRINT"K, L :     "; : D=5: GOSUB 4900
4120 PRINT"M, N :     "; : D=6: GOSUB 4900
4130 PRINT"O, P :     "; : D=7: GOSUB 4900
4140 PRINT
4150 PRINT "Alter which drive pair (A to O) ? "; : GOSUB 9100
4153 IF R=0 THEN GOTO 1000
4155 IF (R<&H41) OR (R> &H50) THEN GOTO 4000
4160 D=(R-&H41)\2
4180 PRINT
4190 PRINT "f(loppy), h(ard) or u(nused) ? ";
4200 GOSUB 9100 
4210 IF R=&H46 THEN GOTO 9300
4230 IF R=&H55 THEN DRV (D) = 255 :GOTO 4000
4235 IF R<> &H48 THEN 4000
4240 IF MINI=1 THEN 4500  ' Mini Winchester version ?
4241 PRINT "5, 10 or 20 Mbyte drive ? "; : GOSUB 9100
4242 IF R=&H35 THEN DRV (D)=4 : GOTO 4260
4243 IF R=&H31 THEN DRV (D) = 2 : GOTO 4260
4244 IF R=&H32 THEN DRV (D) = 3 : GOTO 4260
4250 GOTO 4000
4260 PRINT
4265 PRINT "Device number for drive ? "; : GOSUB 9100 : DISKDEV(D)=N
4270 IF DRV(D) <> 4 THEN 4000
4280 PRINT "Configure as 1 or 2 CP/M drives ? ";
4290 GOSUB 9100 : IF R=&H32 THEN DRV(D) = 5
4300 GOTO 4000
4500 PRINT "3, 6 or 12 Mbyte drive ? ";
4510 GOSUB 9100
4520 IF N=3 THEN DRV(D)=2 : GOTO 4600
4530 IF N=6 THEN DRV(D)=3 : GOTO 4600
4540 IF N=12 THEN DRV(D)=4 : GOTO 4600
4550 GOTO 4000
4600 PRINT "Use the ENTIRE drive for CP/M,  or just
4610 PRINT "use the FIRST HALF (E/H)  ? ";
4620 GOSUB 9100 : IF R=&H48 THEN DRV(D)=DRV(D)+3
4630 GOTO 4000
4900 IF DRV (D) = 0 THEN PRINT"3040/4040  ";:GOTO 4950
4910 IF DRV (D) = 1 THEN PRINT"8050       ";:GOTO 4950
4920 IF DRV (D) >128 THEN PRINT"not used" : RETURN
4930 IF MINI = 1 THEN 4960
4940 IF DRV (D) = 2 THEN PRINT"Corvus 10Mb";
4941 IF DRV (D) = 3 THEN PRINT"Corvus 20Mb";
4942 IF DRV (D) = 4 THEN PRINT"Corvus 5Mb ";
4943 IF DRV (D) = 5 THEN PRINT"Corvus 5Mb*";
4945 IF DRV (D) = 6 THEN PRINT"8250       ";
4947 IF DRV (D) = 7 THEN PRINT"Undefined  ";
4950 PRINT "   Device #", DISKDEV (d) : RETURN
4960 PRINT "Winchester    ";
4970 IF DRV (D) = 2 THEN PRINT"3 Mbyte     
4971 IF DRV (D) = 3 THEN PRINT"6 Mbyte
4972 IF DRV (D) = 4 THEN PRINT"12 Mbyte     
4973 IF DRV (D) = 5 THEN PRINT"3 Mbyte (half)
4974 IF DRV (D) = 6 THEN PRINT"6 Mbyte (half)
4975 IF DRV (D) = 7 THEN PRINT"12Mbyte (half)
4980 RETURN
5000 '**********************************************
5010 'autoload
5020 GOSUB 9000
5040 IF AUTOLOAD (0) = 0 THEN PRINT"No current autoload command" : GOTO 5200
5100 PRINT"Current autoload command is :
5110 FOR J=1 TO AUTOLOAD(0): PRINT CHR$(AUTOLOAD(J));:NEXT
5200 PRINT
5210 PRINT"New autoload command (Y/N) ? ";
5220 GOSUB 9100
5230 IF R <> &H59 THEN 1000
5240 PRINT"Please enter the new command : "
5250 GOSUB 9100
5260 AUTOLOAD (0) = PEEK (BUF+1) ' # of chars in command
5270 FOR J=1 TO 80 : AUTOLOAD (J)= PEEK (BUF+1+J)
5280 IF(AUTOLOAD (J) >= &H61) AND (AUTOLOAD (J) <= &H7A) THEN GOSUB 5500
5290 NEXT
5295 AUTOLOAD (AUTOLOAD(0)+1)=0
5300 GOTO 1000
5500 AUTOLOAD (J)=AUTOLOAD(J)-&H20 :RETURN  ' Map to upper case
6000 ' *********************************************
6100 ' Execute new system
6110 GOSUB 6500 ' Poke back the configuration data
6120 CALL EXSYS '(NEVER RETURNS)
6500 FOR J=0 TO 7
6510 POKE &H4A70+BIAS+J, DRV(J)
6520 POKE &H4A78+BIAS+J, DISKDEV(J)
6530 NEXT
6531 data line 6540 +++++++++++++++++++++++++++++++++++++++
6540 POKE BIAS+&H4A60, IOBYTE
6550 POKE BIAS+&H4A61, LPT
6560 POKE BIAS+&H4A62, RDR
6570 POKE BIAS+&H4A63, PUN
6580 POKE BIAS+&H4A64, (U AND &HFC) OR 2  ' USART - set async. mode
6590 POKE BIAS+&H4A65, BAUD
6591 POKE BIAS+&H4A66, UL1
6595 POKE BIAS+&H4A67, TERMTYPE
6596 POKE BIAS+&H4A6D, LPTYPE
6600 POKE BIAS+&H38B2, DIRSIZE
6610 FOR J=0 TO 80: POKE BIAS+&H3407+J,AUTOLOAD(J) : NEXT
6620 POKE BIAS+&H4A68, LEADIN
6630 POKE BIAS+&H4A69, ORDER
6640 POKE BIAS+&H4A6A, ROWOFF
6650 POKE BIAS+&H4A6B, COLOFF
6660 FOR J=0 TO 63: POKE BIAS+&H4A80+J, SCRTAB(J) : NEXT
6670 POKE LOADER+3, CLOCK
6700 RETURN
7000 ' ********************************************
7010 ' Save new system
7030 PRINT "Save on which drive (A to P) ? ";
7040 GOSUB 9100
7045 IF (R < &H41) or (R > &H50) THEN 1000
7046 D=R-&H41 : DT=D : CALL DTYPE (DT)
7047 IF DT > 127 THEN PRINT "Drive not in system": GOTO 7030
7048 GOSUB 6500
7049 IF (DT>=2) AND (DT<=5) THEN CALL CWRITE(D) : GOTO 1000 ' Corvus drive
7050 CALL IDISK (D): CALL SAVESYS (D): CALL DSKERR (E)
7060 IF E = 0 THEN GOTO 1000
7080 PRINT "Re-try (Y/N) ? "; : GOSUB 9100
7090 IF R=&H59 THEN GOTO 7050 
7100 GOTO 1000
8000 ' ********************************************
8010 ' Pet terminal functions
8020 GOSUB 9000
8030 PRINT"      Pet terminal parameters
8040 PRINT"      --- -------- ----------
8050 PRINT
8060 PRINT"1.  Columns in DIR listing :   ";
8070 IF DIRSIZE=0 THEN PRINT "1" ELSE IF DIRSIZE =1 THEN PRINT"2" ELSE PRINT"4
8080 PRINT
8090 PRINT"2.  CRT in upper case mode :   ";
8100 IF TERMTYPE AND &H80 THEN PRINT "yes" ELSE PRINT "no"
8110 PRINT
8120 PRINT"3.  CRT terminal emulation :   ";
8130 IF (TERMTYPE AND &H7F) = 0 THEN PRINT "ADM3A" : GOTO 8200
8140 IF (TERMTYPE AND &H7F) = 2 THEN PRINT "TV912" : GOTO 8200
8150 IF (TERMTYPE AND &H7F) = 1 THEN PRINT "HZ1500" ELSE GOTO 8200
8160 IF LEADIN = &H1B THEN PRINT "                   (Lead-in = ESCAPE)"
8170 IF LEADIN = &H7E THEN PRINT "                   (Lead-in = TILDE)"
8200 PRINT
8201 PRINT"4.  Clock frequency (Hz) :     "; clock
8203 PRINT
8210 PRINT "Alter which (1-4) ? ";: GOSUB 9100
8220 IF R=0 THEN GOTO 1000
8230 IF R=&H31 THEN GOTO 8300
8240 IF R=&H32 THEN TERMTYPE = (TERMTYPE XOR &H80) : GOTO 8000
8250 IF R=&H33 THEN GOTO 8700
8260 IF R=&H34 THEN GOTO 8500
8280 GOTO 8000
8300 PRINT"Number of columns (1, 2 or 4) ? ";
8310 GOSUB 9100
8315 IF R=&H31 THEN DIRSIZE=0
8320 IF R=&H32 THEN DIRSIZE=1
8330 IF R=&H34 THEN DIRSIZE=3
8340 GOTO 8000
8500 PRINT "New clock frequency ? ";: GOSUB 9100: IF R<> 0 THEN CLOCK=N
8510 GOTO 8000
8700 PRINT "Screen type (ADM3A, HZ1500, TV912) ? ";
8710 GOSUB 9100
8720 IF R=&H41 THEN TERMTYPE=(TERMTYPE AND &H80) : GOTO 8800
8730 IF R=&H54 THEN TERMTYPE=(TERMTYPE AND &H80) OR 2 : GOTO 8800
8750 IF R<>&H48 THEN 8000
8760 PRINT "Lead-in code E(scape) or T(ilde) ? "; : GOSUB 9100
8770 IF R=&H45 THEN LEADIN=&H1B : GOTO 8780
8775 IF R=&H54 THEN LEADIN=&H7E ELSE GOTO 8000
8780 TERMTYPE = (TERMTYPE AND &H80) OR 1 : ROWOFF=0 : COLOFF=0 : ORDER=1
8781 SCRTAB(0)=&H8B: SCRTAB(1)=&H0B: SCRTAB(2)=&H8C: SCRTAB(3)=&H0C
8782 SCRTAB(4)=&H8F: SCRTAB(5)=&H13: SCRTAB(6)=&H91: SCRTAB(7)=&H1B
8783 SCRTAB(8)=&H92: SCRTAB(9)=&H1E: SCRTAB(10)=&H93: SCRTAB(11)=&H12
8784 SCRTAB(12)=&H97: SCRTAB(13)=&H14: SCRTAB(14)=&H98: SCRTAB(15)=&H14
8785 SCRTAB(16)=&H9A: SCRTAB(17)=&H11: SCRTAB(18)=&H9C: SCRTAB(19)=&H1A
8786 SCRTAB(20)=&H9D: SCRTAB(21)=&H1A: SCRTAB(22)=&H99: SCRTAB(23)=&H00
8787 SCRTAB(24)=&H9F: SCRTAB(25)=&H00: SCRTAB(26)=&H00
8790 GOTO 8000
8800 LEADIN = &H1B: ROWOFF=&H20 : COLOFF=&H20 : ORDER=0
8810 SCRTAB(0)=&HB1: SCRTAB(1)=&H04: SCRTAB(2)=&HB2: SCRTAB(3)=&H05
8811 SCRTAB(4)=&HB3: SCRTAB(5)=&H06: SCRTAB(6)=&HEA: SCRTAB(7)=&H0E
8812 SCRTAB(8)=&HEB: SCRTAB(9)=&H0F: SCRTAB(10)=&HD1: SCRTAB(11)=&H1C
8813 SCRTAB(12)=&HD7: SCRTAB(13)=&H1D: SCRTAB(14)=&HC5: SCRTAB(15)=&H11
8814 SCRTAB(16)=&HD2: SCRTAB(17)=&H12: SCRTAB(18)=&HD4: SCRTAB(19)=&H13
8815 SCRTAB(20)=&HF4: SCRTAB(21)=&H13: SCRTAB(22)=&HD9: SCRTAB(23)=&H14
8816 SCRTAB(24)=&HF9: SCRTAB(25)=&H14: SCRTAB(26)=&HAB: SCRTAB(27)=&H1A
8817 SCRTAB(28)=&HAA: SCRTAB(29)=&H1A: SCRTAB(30)=&HBA: SCRTAB(31)=&H1A
8818 SCRTAB(32)=&HBB: SCRTAB(33)=&H1A: SCRTAB(34)=&HDA: SCRTAB(35)=&H1A 
8819 SCRTAB(36)=&HBD: SCRTAB(37)=&H1B: SCRTAB(38)=&HA8: SCRTAB(39)=&H00
8820 SCRTAB(40)=&HA9: SCRTAB(41)=&H00: SCRTAB(42)=&H00
8830 GOTO 8000

9000 ' ********************************************
9010 PRINT CHR$(26): RETURN : REM clear screen
9100 REM get char from console
9110 BUF=&H80
9120 POKE BUF,80 ' BUFFER SIZE
9140 CALL BUFFIN 'buffered input BDOS
9141 PRINT
9150 IF PEEK (BUF+1)=0 THEN R=0: RETURN 'blank line
9160 R=PEEK (BUF+2) ' single character reply
9161 IF (R >= &H61) AND (R<= &H7A) THEN R=R-&H20
9170 N=0:J=2
9180 WHILE (PEEK(BUF+J) >= &H30) AND (PEEK (BUF+J) <= &H39) AND (J-2<PEEK (BUF+1))
9190 N=N*10+(PEEK(BUF+J)-&H30)
9195 J=J+1:WEND:RETURN
9300 PRINT:PRINT"A (3040), B (8050), C (8250) ? ";
9310 GOSUB 9100
9320 IF R=&H41 THEN DRV (D) = 0 : GOTO 4260
9330 IF R=&H42 THEN DRV (D) = 1 : GOTO 4260
9340 IF R=&H43 THEN DRV (D) = 6 : GOTO 4260
9350 IF R=&H44 THEN DRV (D) = 7 : GOTO 4260
9360 GOTO 4000
