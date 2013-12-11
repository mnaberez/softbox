0 ' SoftBox disk format
1 ' This is a reconstruction of the original MBASIC source based on a
2 ' disassembly of FORMAT.COM, which was compiled with BASCOM.
3 '
10 OPTION BASE 0
25 DEFINT A-Z
100 PRINT : PRINT
110 PRINT "Disk formatting program"
115 PRINT "For PET CP/M "
120 PRINT "=== === ===="
1000 ' Main loop
1005 PRINT
1010 PRINT "Format disk on which drive"
1015 PRINT "(A to P, or RETURN to reboot) ? ";
1020 GOSUB 5000 : PRINT
1025 IF R = 0 THEN END
1030 D = R - &H41 ' Convert drive letter (A-P) to number (0-15)
1035 IF (D < 0) OR (D > 15) THEN PRINT "Drive doesn't exist !" : GOTO 1000
1040 DT = D : CALL DTYPE (DT)
1045 IF DT >= 128 THEN PRINT "Drive not in system" : GOTO 1000
1050 IF (DT < 2) OR (DT > 9) THEN GOTO 3000
2000 ' Format a Corvus hard drive
2005 PRINT CHR$(7);"Data on hard disk ";CHR$(R);": will be erased"
2010 PRINT "Proceed (Y/N) ? ";
2015 GOSUB 5000
2020 IF R - &H59 = 0 THEN GOTO 2030 ' Proceed only if "Y" is entered
2025 END
2030 PRINT : PRINT "Formatting hard disk"
2035 CALL CFORM (D)
2040 GOTO 4000
3000 ' Format a Commodore floppy drive
3005 PRINT "Disk on drive ";CHR$(R);": is to be formatted"
3010 PRINT "Press RETURN to continue, ^C to abort : ";
3015 GOSUB 5000
3020 IF R THEN END ' Proceed only if no input
3025 PRINT : PRINT "Formatting..."
3030 CALL FORMAT (D) : CALL DSKERR (E)
4000 ' Format complete
4005 PRINT
4010 IF E THEN GOTO 4020
4015 PRINT "Format complete" : GOTO 1000
4020 PRINT "Do not use diskette - try again..." : GOTO 1000
4025 END
5000 ' Get a key from the user, store its ASCII code in R
5005 BUF = &H80
5010 POKE BUF,80 ' Set buffer size (80 chars)
5015 CALL BUFFIN ' Perform buffered input using BDOS call CREADSTR
5020 IF PEEK(BUF+1)=0 THEN R=0 : RETURN ' Nothing entered
5025 R=PEEK(BUF+2) ' First char of input
5030 IF (R >= &H61) AND (R <= &H7A) THEN R=R-&H20 ' Normalize to uppercase
5035 RETURN
