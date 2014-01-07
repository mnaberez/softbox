Const adTypeBinary = 1, adTypeText = 2

Dim Values(255)

Set objStream = CreateObject("ADODB.Stream")
  objStream.Open
  objStream.Type = adTypeBinary
  objStream.LoadFromFile("ls287.bin")
  For I = 0 To 255
    Values(I) = AscB(objStream.Read(1))
  Next
Set objStream = Nothing

Out = ""
For I = 0 TO 255
  Rfsh = (I And   1) <> 0 'Is Inverted
  Boot = (I And   2) <> 0 'Is Inverted
  A13  = (I And   4) <> 0
  A14  = (I And   8) <> 0
  A15  = (I And  16) <> 0
  A12  = (I And  32) <> 0
  S_h  = (I And  64) <> 0 '0=4k, 1=8k
  A11  = (I And 128) <> 0

  REM Possible normal ROM access at address E000-FFFF when no RAM Refresh
  Cs_Rom      = A15 And A14 And A13 And Rfsh

  REM Low ROM is accessable when Booting or in 4k mode at F000-FFFF or in 8k mode at E000-EFFF
  Cs_Rom_Low  = Not( Not(Boot)              Or (Not(S_h) And A12 Or S_h And Not(A12)) And Cs_Rom )

  REM High ROM is accessable when Booting in 4k mode or at F000-FFFF when not Booting
  Cs_Rom_High = Not( Not(Boot) And Not(S_h) Or                           Boot And A12 And Cs_Rom )

  REM Ram is accessable when no ROM is selected
  Ras         = Not( Cs_Rom_Low And Cs_Rom_High )

  Unused      = -1

  D = 8
  If Cs_Rom_High Then D = D Or 4 'Is inverted
  If Cs_Rom_Low  Then D = D Or 2 'Is inverted
  If Ras         Then D = D Or 1 'Is inverted

  If Out <> "" Then  
    If I mod 16 = 0 Then
      Out = Out & VBCrLf
    Else
      Out = Out & " "
    End If
  End If

  If D <> Values(I) Then
    MsgBox "Error: Calculate " & D & " but readed from dump " & Values(I)
    Out = Out & Hex(D) & "(" & Hex(Values(I)) & ")"
  Else
    Out = Out & Hex(D)
  End If
Next

MsgBox Out