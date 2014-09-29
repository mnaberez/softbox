Const adTypeBinary = 1, adTypeText = 2

Dim Values(255)

Set objStream = CreateObject("ADODB.Stream")
  objStream.Open
  objStream.Type = adTypeBinary
  objStream.LoadFromFile("TBP24S10.bin")
  For I = 0 To 255
    Values(I) = AscB(objStream.Read(1))
  Next
Set objStream = Nothing

Out = ""
For I = 0 TO 255
  Rfsh   = (I And   1) <> 0 'Is Inverted
  Boot   = (I And   2) <> 0 'Is Inverted
  A13    = (I And   4) <> 0
  A14    = (I And   8) <> 0
  A15    = (I And  16) <> 0
  A12    = (I And  32) <> 0
  No_Mem = (I And  64) <> 0 '0=Memory enabled, 1=Memory disabled

  REM Possible normal ROM access at address F000-FFFF when no RAM Refresh
  Cs_Rom      = A15 And A14 And A13 And A12 And Rfsh

  REM ROM_All is accessable only if memory enabled when booting or at F000-FFFF
  Cs_Rom_All = Not( Not(No_Mem) And (Not(Boot) Or Cs_Rom))

  REM RAS is accessable if memory enabled when not booting at 0000-EFFF or if refreshing and memory disabled or refreshing while not booting
  Ras  = Not( Not(No_Mem) And Boot And Not(Cs_Rom) Or _
              Not(Rfsh) And (No_Mem Or Boot))

  Unused      = -1

  D = 12
  If Cs_Rom_All Then D = D Or 2 'Is inverted
  If Ras        Then D = D Or 1 'Is inverted

  If Out <> "" Then  
    If I mod 16 = 0 Then
      Out = Out & VBCrLf
    Else
      Out = Out & " "
    End If
  End If

  If D <> Values(I) Then
    MsgBox "Fehler: Calculate " & D & " but readed from dump " & Values(I)
    Out = Out & Hex(D) & "(" & Hex(Values(I)) & ")"
  Else
    Out = Out & Hex(D)
  End If
Next

MsgBox Out