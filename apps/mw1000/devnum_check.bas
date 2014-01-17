0 ' This BASIC source is a reengineering of the disassembly devnum.asm from the devnum.com.
2 '
3 ' First test version, mhv 2014-01-17
4 '
5 ' TODO: Check with BASCOM!
8 '
9 ' Calls library module "???"
10'
15 OPTION BASE 0
20 DEFINT A-Z
200 PRINT CHR$(26) ' Clear screen
210 PRINT "Alter PET DOS device number of Mini-Winchester"
220 PRINT "----- --- --- ------ ------ -- ---------------"
230 PRINT:PRINT:PRINT
240 POKE &H4033,1
250 BA=&H4000:SA=32
260 CALL MW_READ (BA, SA, EC)
270 GOSUB 2000
280 PRINT "current device number is :  "; PEEK(&H4036)
290 PRINT "new device number ? ";
300 GOSUB 9100
310 IF R=0 THEN END
320 PRINT:PRINT
330 PRINT "changing device number to "; N; " ..."
340 POKE &H4036,N:SA=32
350 CALL MW_WRITE (BA, SA, EC)
360 GOSUB 2000:END
2000 REM check error
2010 IF (EC AND &H40)=0 THEN RETURN
2020 PRINT "DRIVE ERROR #";
2030 IF E=&H40 THEN PRINT "40 - header write error":END
2040 IF E=&H42 THEN PRINT "42 - header read error":END
2050 IF E=&H44 THEN PRINT "44 - data read error":END
2060 IF E=&H46 THEN PRINT "46 - write fault":END
2070 IF E=&H47 THEN PRINT "47 - disk not ready":END
2080 IF E=&H49 THEN PRINT "49 - illegal command":END
2090 PRINT "xx - unknown error code":END
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
