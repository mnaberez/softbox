0 ' SoftBox disk format
1 ' This is a reconstruction of the original MBASIC source based on a
2 ' disassembly of FORMAT.COM, which was compiled with BASCOM.
3 '
100 PRINT : PRINT
110 PRINT "Disk formatting program"
115 PRINT "For PET CP/M "
120 PRINT "=== === ===="
130 PRINT
135 PRINT "Format disk on which drive"
140 PRINT "(A to P, or RETURN to reboot) ? "
145 GOSUB 1000
150 IF R = 0 THEN END
1000 ' Get a key from the user, store its ASCII code in R
1005 BUF = &H80
1010 POKE BUF,80 ' Set buffer size (80 chars)
1015 CALL BUFFIN ' Perform buffered input using BDOS call CREADSTR
1020 PRINT
1025 IF PEEK(BUF+1)=0 THEN R=0 : RETURN ' Nothing entered
1030 R=PEEK(BUF+2) ' First char of input
1035 RETURN
