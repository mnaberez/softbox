0 ' SoftBox disk format
1 ' This is a reconstruction of the original MBASIC source based on a
2 ' disassembly of FORMAT.COM, which was compiled with BASCOM.
3 '
100 PRINT : PRINT
110 PRINT "Disk formatting program"
115 PRINT "For PET CP/M "
120 PRINT "=== === ===="
1000 ' Main loop
1005 PRINT
1010 PRINT "Format disk on which drive"
1015 PRINT "(A to P, or RETURN to reboot) ? "
1020 GOSUB 2000
1025 IF R = 0 THEN END
1030 D = R - &H41 ' Convert drive letter (A-P) to number (0-15)
1035 IF (D < 0) OR (D > 15) THEN PRINT "Drive doesn't exist !" : GOTO 1000
1040 DT = D : CALL DTYPE (DT)
1045 IF DT > 128 THEN PRINT "Drive not in system" : GOTO 1000
1050 IF (DT < 2) OR (DT > 5) THEN GOTO 3000
2000 ' Format a Corvus hard drive
3000 ' Format a Commodore floppy drive
4000 ' Get a key from the user, store its ASCII code in R
4005 BUF = &H80
4010 POKE BUF,80 ' Set buffer size (80 chars)
4015 CALL BUFFIN ' Perform buffered input using BDOS call CREADSTR
4020 PRINT
4025 IF PEEK(BUF+1)=0 THEN R=0 : RETURN ' Nothing entered
4030 R=PEEK(BUF+2) ' First char of input
4035 IF (R >= &H61) AND (R <= &H7A) THEN R=R-&H20 ' Normalize to uppercase
4040 RETURN
