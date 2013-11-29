Const adTypeBinary = 1, adTypeText = 2

Dim Values(255)

Set objStream = CreateObject("ADODB.Stream")
  objStream.Open
  objStream.Type = adTypeBinary
  objStream.LoadFromFile("LS287.bin")
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

  Ras         =      Not(Boot) Or (A12 Or S_h)                           And A15 And A14 And A13          And Rfsh
  Cs_Rom_Low  = Not( Not(Boot) Or (A12 And Not(S_h) Or Not(A12) And S_h) And A15 And A14 And A13          And Rfsh )
  Cs_Rom_High = Not( Not(Boot) And Not(S_h) Or A12                       And A15 And A14 And A13 And Boot And Rfsh)
  Unused      = -1

  D = 8
  If Cs_Rom_High Then D = D Or 4 'Is inverted
  If Cs_Rom_Low  Then D = D Or 2 'Is inverted
  If Ras         Then D = D Or 1 'Is inverted

  If D <> Values(I) Then MsgBox "Fehler: Calculate " & D & " but readed from dump " & Values(I)

  If Out <> "" Then  
    If I mod 16 = 0 Then
      Out = Out & VBCrLf
    Else
      Out = Out & " "
    End If
  End If
  Out = Out & Hex(D)
Next

MsgBox Out