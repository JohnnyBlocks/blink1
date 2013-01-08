' blink-CountDown.vbs --  Green to Red fader
'        Used to test color patterns for things going from 100% (green) to 0% (red)
'
' Run this script on the command line With:
'   cscript.exe //nologo blink-CountDown.vbs
'
'
' And make sure "blink1-tool.exe" is in your PATH or in same dir as this script
'
' 2012, John A Hamilton is YoYo-Pete, http://yoyo-pete.com
' Modeled After blink1DiskActivity.vbs from Tod E. Kurt, http://todbot.com/blog/ http://thingm.com/
'

' helper function to run a program 
Sub Run(ByVal sFile)
    Dim WShell : Set WShell = CreateObject("WScript.Shell")
    WShell.Run sFile, 0, true 
End Sub
wscript.echo 
wscript.echo "Blink(1) CountDown"

PercentCounter = 100

While PercentCounter > -1
	
	if PercentCounter > 50 then
			  v_red = int(255.0*(1.0-2.0*(PercentCounter-50.0)/100.0))
			  v_green = int(255.0*(1.0))
		 else
			  v_red = int(255.0*(1.0))
			  v_green = int(((PercentCounter/100.0)*2.0)*255.0)
	End if
	wscript.echo PercentCounter & " - " & v_red & "|" & v_green
	Run "blink1-tool.exe --rgb " & v_red & "," & v_green & ",0"
	
	
	
	PercentCounter = PercentCounter -1
	Wscript.Sleep 50
Wend
