!  9"j*  "" "#�%�  �  �  1��͖�͖1�q͖�RO!V͖�=�Ͳ�ÖL.HkBqVoI�RFQfK�1�&�4>2��!9	͖�>��q�2�Ē!�
"z!;�>2vO��"t�	͖�	͖���	͖��
͖��>P2v
͖��7
͖��2�Y
͖�R����
͖(��̈́���!�
"z!�͵
͖͢�1�:���4�
�1͖:����1�&�4>	2��͖�>��q�2�Ē!"z�͖!���2� ͵:o��ʡͨ�4!���2�ͲÊ͢�1�?��!���2�Ͷ��!���2�Ͳá:�2�!� ͵��Ԣ�4�&�4!J"z$͖!|Ͳ!�"t͢��4*p���4n͖�y���͖�yo�yg���͖>2v��_�	�_
�_
�_>@2v
�_+
�_�4�&�4!c"z:͖!�Ͳͨ�4!�ͲÇ~#� ^#V�##7�͢�1�?�!�Ͳ!�"tͥT͖�yo�yg���͖�y�y���͖�y�������Ö�͖�R�� �͖7�:��������C:�O!J͖�;A͖:����͖�17���?�1�������͖:vG�yͱ�g�͖���*t~#"t�������*z�͖���Mw#x��!�����͂�"p� ~�Y#x�µ����MG2y�������͖�͝�͖7�̈́��0����H��0����H����x�����g> �Y���M2oG��x����͖7�:o���m�V*�"l:�2n*l"�!  "��:o����!������q!�"z>�Y:��Y���4!�� ͖!����6�	� ���ͦ���0�:ڱ�O����Y� �������0������������� ��/"w��*wy��� ò ò���o& 0������!  ��R�� ���Ͳ�0��
?�]T)))_ ��*l����?���R�Y�L�N�><�Ͳ���O�`�]�_��	͖�͖*j���͖�R�1�w�5�w�02�2�2�ò_	͖�ڒ"�{	͖�ڡ|�ʡ"��*��*l���	͖Ò�R�F ���N��Ͳx��N�#��/<��}�o|�g�:v5
� *t�:v_ "t�!6~��N#~#��!�6 #x��'��Ͳ����0��9�H��H���0��M�����0�0�Z���>����H��0��g�M���g�  �O��y� � ʠ�Mw#Å���
 --- CORVUS MIRROR UTILITY ---
 VERSION 1.33  /   FOR SOFTBOX
$
 --- MIRROR MENU ---

 L:  LIST THIS MENU
 H:  LIST HELP DATA
 B:  BACKUP 
 V:  VERIFY 
 I:  IDENTIFY
 R:  RESTORE 
 Q:  QUIT 
$
 TASK (L TO LIST) : $
 ->> THIS FEATURE IS NOT AVAILABLE UNDER VERS. 0 CONTROLLER CODE
$

 ** DISC R/W ERROR # $H **
$
 CORVUS DRIVE #  (1-4) ? $^C
$
 -- THIS WOULD EXCEED DISC SIZE --
$
 BACKUP ENTIRE CORVUS DISC (Y/N) ? $
 STARTING DISC BLOCK # ? $
      NUMBER OF BLOCKS ? $
 ** THIS WOULD EXCEED DISC SIZE **
$

 --- ENTER TAPE FILE HEADER INFORMATION ---
$
    DATE : $
    TIME : $
    NAME : $
 COMMENT : $
           $
 NORMAL OR FAST FORMAT (N/F) ? $
 STARTUP RECORDER AND PRESS RETURN $
 >> BACKUP HAS STARTED <<
$

 WAITING FOR RECORDER TO SPEED UP ...
$
 BACKUP IN PROGRESS ...
$
 BACKUP DONE -- NO DISC ERRORS
$
 THERE WERE $ DISC READ ERRORS DURING BACKUP $

 START RECORDER AT BEGINNING OF IMAGE

 VERIFY IN PROGRESS ...
$
 IMAGE ID NOT EQUAL TO 1
$
 ILLEGAL RESTORE COMMAND
$
ILLEGAL RETRY COMMAND
$
 IMAGE SIZE MISMATCH
$
 ILLEGAL COMMAND
$
 TIMEOUT - NO IMAGE FOUND
$
 TAPE DROPOUT DURING PLAYBACK
$
 MIRROR ERROR # $
 --- ERROR STATISTICS ---

 # SOFT ERRORS :$
 # DISC ERRORS :  $
 # OF BLOCKS NEEDING RETRYS :  $

 ALL DATA RECEIVED 
$
 -- RETRY NEEDED --
 START RECORDER AT BEGINNING OF IMAGE -- PRESS RETURN $
 POSITION TAPE AND START PLAYBACK 

 SEARCHING FOR IMAGE HEADER ...
$
 --- IMAGE RECORDED FROM CORVUS DRIVE ---

 IMAGE ID : $
 IMAGE LENGTH : $ BLOCKS 
$
  SYSTEM : $
 RESTORE ENTIRE DISC (Y/N) ? $

 POSITION TAPE AND START PLAYBACK 

 RESTORE IN PROGRESS ...
$CP/M            

     THIS PROGRAM PROVIDES THE BASIC CONTROL FUNCTIONS
 FOR THE CORVUS "MIRROR" DISC BACKUP SYSTEM.  IT WILL
 ONLY WORK ON SYSTEMS WITH CONTROLLER CODE VERSION > 0.
 FUNCTIONS PROVIDED ARE:

  B: BACKUP
     COPY A CONTIGUOUS SECTION OF INFORMATION ON THE
     CORVUS DRIVE ONTO A VIDEO TAPE FILE.
  V: VERIFY
     RE-READ A VIDEO TAPE FILE AND VERIFY THAT IT HAS
     BEEN RECORDED CORRECTLY.  THIS IS DONE BY TESTING
     THE  CRC  (A FORM OF CHECKSUM) OF EACH RECORD.
  I: IDENTIFY
     READ THE HEADER OF A VIDEO TAPE FILE AND LIST IT
     ON THE CONSOLE.
  R: RESTORE
     COPY A VIDEO TAPE FILE BACK TO THE CORVUS DRIVE.
     IT NEED NOT BE RESTORED TO THE SAME PLACE IT WAS 
     COPIED FROM.

  -  RETRY
     THIS FUNCTION IS BUILT IN TO THE  VERIFY  AND  RESTORE
     FUNCTIONS.  A RETRY WILL BE REQUESTED IF THE REDUNDANCY
     BUILT INTO "THE MIRROR" RECORDING FORMAT WAS NOT
     SUFFICIENT TO RECOVER FROM AN ERROR DETECTED IN ONE OR
     MORE TAPE RECORDS.  IN THIS CASE, THE ERROR STATISTICS
     WILL SHOW HOW MANY BLOCKS NEED RETRYS (NOTE: IF THIS
     NUMBER IS ZERO THEN ALL OF THE DATA WAS RECOVERED).

 A CONTROL - C ISSUED IN RESPONSE TO A PROMPT WILL CAUSE
 AN EXIT BACK TO CP/M.  A NON DECIMAL INPUT, IN RESPONSE
 TO A PROMPT REQUESTING A NUMBER, WILL CAUSE A REPEAT OF
 THE QUESTION ( CONTROL - C WILL ALWAYS CAUSE AN EXIT).
 THE ONLY NUMERICAL INPUTS REQUIRED ARE ALL IN DECIMAL.
 THE  BACKUP  AND  RESTORE  COMMANDS MAY ASK FOR THE
 " STARTING DISC BLOCK # " AND THE " # OF BLOCKS " 
 (IF YOU ARE NOT SAVING OR RESTORING AN ENTIRE DISC).
 THIS REFERS TO THE ACTUAL INTERNAL ORGANIZATION OF
 THE DRIVE - WHICH USES 512 BYTE SECTORS (BLOCKS).
 THE RELATION BETWEEN THE  BLOCK ADDRESS  
 AND THE USUAL  128 BYTE DISC ADDRESS  
 IS SIMPLE:

   DISC ADDRESS (128 BYTE) = 4 X BLOCK ADDRESS

 THIS MAY CAUSE A SLIGHT PROBLEM IF YOU WANT TO SAVE 
 OR RESTORE DISC DATA AT   DISC ADDRESSES (128 BYTE)
 THAT ARE NOT DIVISIBLE BY 4.  FOR REFERENCE,
 THE MAXIMUM BLOCK ADDRESS FOR VARIOUS CORVUS
 DRIVES ARE:

       18935   (REV A 10 MB DRIVE)
       21219   (REV B 10 MB DRIVE)
       38459   (REV B 20 MB DRIVE)
       11219   (REV B  5 MB DRIVE)
       11539   (REV H  6 MB DRIVE)
       23699   (REV H 11 MB DRIVE)
       35859   (REV H 20 MB DRIVE)

$
       18935   (R
  
 
 
  ^�I 
 22 9 (E  	                                                                                           