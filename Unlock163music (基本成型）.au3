
#include <MsgBoxConstants.au3>
#NoTrayIcon
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Outfile_x64=Unlock163music_x64.exe
#AccAu3Wrapper_UseUpx=y
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****

#include <InetConstants.au3>

#include <WinAPIFiles.au3>


#include <Array.au3> ; Only required to display the arrays
#include <File.au3>
;#include <MsgBoxConstants.au3>







Local $sFilePath =@ScriptDir&"\temp.zip"

    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("https://github.com/nondanee/UnblockNeteaseMusic/archive/master.zip", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)

    ; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
    Do
        Sleep(250)
    Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

    ; Retrieve the number of total bytes received and the filesize.
    Local $iBytesSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
    Local $iFileSize = FileGetSize($sFilePath)

    ; Close the handle returned by InetGet.
    InetClose($hDownload)

    ; Display details about the total number of bytes read and the filesize.
    MsgBox($MB_SYSTEMMODAL, "", "The total download size: " & $iBytesSize & @CRLF & _
            "The total filesize: " & $iFileSize)

    ; Delete the file.
 

Local $sFilePath2 =@ScriptDir&"\node.zip"

    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("https://npm.taobao.org/mirrors/node/v14.15.5/node-v14.15.5-win-x64.zip", $sFilePath2, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)

    ; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
    Do
        Sleep(250)
    Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

    ; Retrieve the number of total bytes received and the filesize.
    Local $iBytesSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
    Local $iFileSize = FileGetSize($sFilePath2)

    ; Close the handle returned by InetGet.
    InetClose($hDownload)

    ; Display details about the total number of bytes read and the filesize.
    MsgBox($MB_SYSTEMMODAL, "", "The total download size: " & $iBytesSize & @CRLF & _
            "The total filesize: " & $iFileSize)

    ; Delete the file.






FileInstall("7z.exe",@ScriptDir&"\7z.exe",1)
FileInstall("7z.dll",@ScriptDir&"\7z.dll",1)
;FileInstall("Unlock163music.zip",@ScriptDir&"\Unlock163music.zip",1)


;Local $sFilePath ="temp.zip"
;Local $sFilePath2 ="node.zip"
;MsgBox(0,"",@ScriptDir&"\7z.exe  x "&$sFilePath&" -y -o"&@WorkingDir&"\Music\")
;MsgBox(0,"",@ScriptDir&"\7z.exe  e "&$sFilePath2&" node.ex?  -r0 -o"&@WorkingDir&"\Music\")
RunWait(@ScriptDir&"\7z.exe  x "&$sFilePath&" -y")
RunWait(@ScriptDir&"\7z.exe  e "&$sFilePath2&" node.ex?  -r0 -y -o"&@WorkingDir&"\UnblockNeteaseMusic-master\")

;" e "&$sFilePath2&" node.ex?  -r0 -o"&@ScriptFullPath&"\Music"


;FileDelete(@LocalAppDataDir&"\Netease\CloudMusic\config")
;FileInstall("config",@LocalAppDataDir&"\Netease\CloudMusic\config",1)
;~ FileDelete($sFilePath)
;~ FileDelete($sFilePath2)
;FileDelete("7z.exe")
;FileDelete("7z.dll")
;FileDelete("Unlock163music.zip")





$filelist=_FileListToArrayRec ( @ScriptDir ,  "node.exe" ,1 ,1, 2, 2 )
_ArrayDisplay($filelist)


TCPStartup()
$sIP = TCPNameToIP("music.163.com")
TCPShutdown()

;~ MsgBox(0,$sIP,$sIP)
MsgBox(0,"",$filelist[1] &' '& "app.js" &" -p 2333 -f "&$sIP&@CRLF&@WorkingDir&"\UnblockNeteaseMusic-master\")
$pid=Run($filelist[1] &' '& "app.js" &" -p 2333 -f "&$sIP,@WorkingDir&"\UnblockNeteaseMusic-master\")
config()
$pid2=Run(RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\cloudmusic.exe",""))
Do
	Sleep(100)
Until Not ProcessExists($pid2)
ProcessClose($pid)
ProcessClose("node.exe")

Func config()
  Local $proxy[11],$temparray,$proxyc[9]
$proxy[0]= '{'
$proxy[1]='     "Proxy": {'
$proxy[2]='      "Type": "http",'
$proxy[3]='   		 "http": {'
$proxy[4]='		     "Host": "127.0.0.1",'
$proxy[5]='			 "Password": "",'
$proxy[6]='     	 "Port": "2333",'
$proxy[7]='      	 "UserName": ""'
$proxy[8]='    				}'
$proxy[9]='  			}'
$proxy[10]='}'
  

$proxyc[0]='     "Proxy": {'
$proxyc[1]='      "Type": "http",'
$proxyc[2]='    "http": {'
$proxyc[3]='       "Host": "127.0.0.1",'
$proxyc[4]='      "Password": "",'
$proxyc[5]='     "Port": "2333",'
$proxyc[6]='      "UserName": ""'
$proxyc[7]='    }'
$proxyc[8]='  },'

  
  
  
  _ArrayDisplay($proxy)
  $file=@LocalAppDataDir&"\Netease\CloudMusic\config"
  If Not FileExists($file) Then
	  $sfile=FileOpen($file,256+1)
	  _FileWriteFromArray($sfile,$proxy,0)
	  FileClose($sfile)
  Else
	  _FileReadToArray($file,$temparray,0)
	  _ArrayDisplay($temparray)
	   _ArrayInsert($temparray, "1;1;1;1;1;1;1;1;1",$proxyc)
	   _ArrayDisplay($temparray)
	   	  $sfile=FileOpen($file,256+2)
	  _FileWriteFromArray($sfile,$temparray,0)
	  FileClose($sfile)
  EndIf
  
EndFunc

