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
2000 ' Get a key from the user, store its ASCII code in R
2005 BUF = &H80
2010 POKE BUF,80 ' Set buffer size (80 chars)
2015 CALL BUFFIN ' Perform buffered input using BDOS call CREADSTR
2020 PRINT
2025 IF PEEK(BUF+1)=0 THEN R=0 : RETURN ' Nothing entered
2030 R=PEEK(BUF+2) ' First char of input
2035 IF (R >= &H61) AND (R <= &H7A) THEN R=R-&H20 ' Normalize to uppercase
2040 RETURN
