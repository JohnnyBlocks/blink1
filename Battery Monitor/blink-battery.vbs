' blink-battery.vbs --  Visual Battery Indication
'        Blue = On Charge
'        Green -> Red = Full power -> No Power
'
' Run this script on the command line With:
'   cscript.exe //nologo blink-battery.vbs
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
wscript.echo "Blink(1) Battery Monitor"

' prepare the to fetch data from WMI
strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
set objRefresher = CreateObject("WbemScripting.SWbemRefresher")
Set colBatteries = objRefresher.AddEnum _
    (objWMIService, "Win32_Battery"). _
        objectSet
objRefresher.Refresh

' loop forever
Do While 1
    For Each objBattery in colBatteries  ' I stole this model from todbot
        If objBattery.BatteryStatus = "1" Then
			
            'wscript.echo "On Battery..." & objBattery.EstimatedChargeRemaining
            if objBattery.EstimatedChargeRemaining > 50 then
                      v_red = int(255.0*(1.0-2.0*(objBattery.EstimatedChargeRemaining-50.0)/100.0))
                      v_green = int(255.0*(1.0))
                 else
                      v_red = int(255.0*(1.0))
                      v_green = int(((objBattery.EstimatedChargeRemaining/100.0)*2.0)*255.0)
			End if
			'wscript.echo objBattery.EstimatedChargeRemaining & " - " & v_red & "|" & v_green
			Run "blink1-tool.exe --rgb " & v_red & "," & v_green & ",0" 
        ElseIf objBattery.BatteryStatus = "2" Then
			'wscript.echo "On Power..."
			Run "blink1-tool.exe --rgb 0,0,255"
		END IF
		Wscript.Sleep 1000
        objRefresher.Refresh
    Next
Loop