Private Sub Application_NewMailEx(ByVal EntryIDCollection As String)
    Dim varEntryIDs
    Dim objItem
    Dim i As Integer
    
    'Runs different Blink1 batch files based on subject key words
    'Used batch files to make the blink so it's easier to adjust and track the library of blinks
    
    varEntryIDs = Split(EntryIDCollection, ",")
    For i = 0 To UBound(varEntryIDs)
        Set objItem = Application.Session.GetItemFromID(varEntryIDs(i))
        If InStr(UCase(objItem.Subject), UCase("Major Incident")) Then
            'Major Incident Alert
            CreateObject("Wscript.Shell").Run "D:\johnham\blink(1)\blinkOutlookMajorIncident.bat", 0, False
        Else
            'Standard New Mail Alert
            CreateObject("Wscript.Shell").Run "D:\johnham\blink(1)\blinkOutlookNewMail.bat", 0, False
        End If
    Next
    
End Sub

Private Sub Application_Reminder(ByVal Item As Object)
    CreateObject("Wscript.Shell").Run "D:\johnham\blink(1)\blinkOutlookReminder.bat", 0, False
End Sub