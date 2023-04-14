#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Project2.ico
#AutoIt3Wrapper_Outfile_x64=onekeyUlock163.exe
#AutoIt3Wrapper_Res_Comment=一键部署解锁云音乐服务
#AutoIt3Wrapper_Res_Description=一键部署解锁云音乐服务
#AutoIt3Wrapper_Res_Fileversion=2.0.0.0
#AutoIt3Wrapper_Res_ProductName=HomeMade
#AutoIt3Wrapper_Res_ProductVersion=2.0
#AutoIt3Wrapper_Res_CompanyName=Massgrave
#AutoIt3Wrapper_Res_LegalCopyright=Free
#AutoIt3Wrapper_Res_Language=2052
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; *** AutoIt3Wrapper 开始 ***
#include <MsgBoxConstants.au3>
; *** AutoIt3Wrapper 结束 ***
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Outfile=onekey_GUI.exe
#AccAu3Wrapper_Outfile_x64=onekey_GUI_x64.exe
#AccAu3Wrapper_Compile_Both=y
#AccAu3Wrapper_Res_Fileversion=1.0
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=None
#AccAu3Wrapper_Run_AU3Check=n
#AccAu3Wrapper_Add_Constants=y
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <InetConstants.au3>
#include <WinAPIFiles.au3>
#include <File.au3>
#include <Crypt.au3>
#include "GUI.isf"

Opt("TrayIconHide",1)

Global $m, $n
Global $settingfile=@ScriptDir&"\OKUL163.ini"
Global $node_exe=@ScriptDir&"\unblockneteasemusic-win-x64.exe"
Global $show=0
Global $music_exe=@ScriptDir&"\CloudMusic\cloudmusic.exe"
Global $file=StringTrimRight ($music_exe,14)&"\Netease\CloudMusic\localdata"
Global $node_md5="0xEADF3AC9F0BCFA0C5EB8076A0C67A243"
Global $nodeport=""

checkfile()

Func checkfile()
If Not FileExists($settingfile)  or not FileExists($node_exe) or not FileExists($music_exe) or check163ver($music_exe) = 0   Then
	delkjfs()
	onekey_GUI()
	readfile()
	guictrlsetdata ( $labtxt,  $m & "	" & $n)
	GUICtrlSetColor($labtxt, 0xFF0000)
	GUISetState(@SW_SHOW)
	while 1
		$nMsg = GUIGetMsg()
;~ 	Sleep(500)


		Switch $nMsg
			Case $GUI_EVENT_CLOSE
			
			Exit
			Case $Button_OK
				GUICTRLSetstate($Button_OK, $gui_disable)
				
				download163()
				downloadnode()
				IniWrite($settingfile,'path',"exe163",$music_exe)
				IniWrite($settingfile,'path',"exenode",$node_exe)
				iniwrite($settingfile,"node","port","")
;~ 				IniWrite($settingfile,"md5","163m",checknodever($music_exe))
				kjfs()
				readfile()
				guictrlsetdata ( $labtxt,  $m & "	" & $n)
				GUICtrlSetColor($labtxt,0x339966 )
				sleep(2000)
				GUISetState(@SW_HIDE)
				
				main()
		EndSwitch 
	WEnd 
	

Else
	kjfs()
	main()
EndIf
EndFunc

Func readfile()
$music_exe=IniRead($settingfile,"path","exe163",$music_exe)
if FileExists($music_exe) and check163ver($music_exe) then 
	$m = "云音乐：OK" 
	Else 
	$m = "云音乐：无"	
EndIf

$node_exe=IniRead($settingfile,"path","exenode",$node_exe)
if FileExists($node_exe)  then 
	$n = "解锁服务：OK" 
	Else 
	$n = "解锁服务：无"	
EndIf
$file=StringTrimRight ($music_exe,14)&"\Netease\CloudMusic\localdata"
;~ $node_md5=IniRead($settingfile,"md5","node","0xEADF3AC9F0BCFA0C5EB8076A0C67A243")
$nodeport=IniRead($settingfile,"node","port","")
if StringIsInt ($nodeport ) then 
	$nodeport =$nodeport &":"& $nodeport +1 
$set = iniread($settingfile,"node","163set","")
if $set <> "yes" then 
	$nodeport=IniRead($settingfile,"node","port","")
	diyport()
	
EndIf
EndIf

EndFunc








Func check163ver($filepath)
Local $ver = FileGetVersion($filepath)
$verl=StringSplit($ver,".")
If $verl[1] <=2 and $verl[2] <=9 And $verl[3]<=9 Then 
	Return 1
Else
	Return 0
EndIf
EndFunc	

Func checknodever($file)
$md5= _Crypt_HashFile ( $file, $CALG_MD5 )
if String($md5) = $node_md5 Then 
	return 1
	
Else 
	Return 0
EndIf 
	
EndFunc	


	
Func downloadnode()
If Not FileExists($node_exe)  Then

Local $sFilePath =$node_exe
If Not FileExists($sFilePath) Then
    Local $hDownload = InetGet("https://github.com/UnblockNeteaseMusic/server/releases/download/v0.27.0/unblockneteasemusic-win-x64.exe", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
    Do
        Sleep(250)
		guictrlsetdata ( $labtxt,  "正在下载 解锁服务 ")
		
		Guictrlsetdata($jdt, Round(InetGetInfo($hDownload, $INET_DOWNLOADREAD)/InetGetInfo($hDownload, $INET_DOWNLOADSIZE)*100))
    Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

    ; Retrieve the number of total bytes received and the filesize.
    Local $iBytesSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
    Local $iFileSize = FileGetSize($sFilePath)

    ; Close the handle returned by InetGet.
    InetClose($hDownload)

guictrlsetdata ( $labtxt,  "unblockneteasemusic-win-x64.exe已经下载完成。")
sleep(2000)
EndIf
EndIf

	
EndFunc


Func download163()
	if Not FileExists($music_exe) Then 
Local $sFilePath =@ScriptDir&"\CloudMusic.rar"
If Not FileExists($sFilePath) then
    Local $hDownload = InetGet("https://github.com/maxkingmax/nondanee-unblock163music-helper/releases/download/2.9.9/CloudMusic.rar", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
    Do
        Sleep(250)
		GUICtrlSetData ( $labtxt, "正在下载 云音乐2.9.9.1130（Repack） ")
		Guictrlsetdata($jdt, Round(InetGetInfo($hDownload, $INET_DOWNLOADREAD)/InetGetInfo($hDownload, $INET_DOWNLOADSIZE)*100))
		
    Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

    ; Retrieve the number of total bytes received and the filesize.
    Local $iBytesSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
    Local $iFileSize = FileGetSize($sFilePath)

    ; Close the handle returned by InetGet.
    InetClose($hDownload)
	GUICtrlSetData ( $labtxt, " 云音乐压缩包下载完成，")
sleep(2000)
EndIf 

GUICtrlSetData ( $labtxt, " 云音乐包正在解压缩 ...")
		for $i = 0 to 100 step 10
			Guictrlsetdata($jdt,$i)
		Next
	If FileExists("C:\Program Files\WinRAR\winrar.exe")  Then 
		RunWait('"C:\Program Files\WinRAR\winrar.exe" x -o+ "'&$sFilePath & '"',@ScriptDir,@SW_HIDE )
	Else
		FileInstall("C:\Program Files\WinRAR\unrar.exe",@ScriptDir&"\unrar.exe",1)
		RunWait(@ScriptDir&'\unrar.exe x -o+ "'&$sFilePath & '"',@ScriptDir,@SW_HIDE )
	EndIf
	sleep(2000)

EndIf
EndFunc

Func main()
	Opt("TrayIconHide",0)
Opt("TrayMenuMode",3)
FileInstall('unblockneteasemusic.cfg',@ScriptDir&"\unblockneteasemusic.cfg",0)

	readfile()
	 config()
If ProcessExists("unblockneteasemusic-win-x64.exe") Then ProcessClose("unblockneteasemusic-win-x64.exe")
If $nodeport="" Then
$pid=Run($node_exe,"",$show)
Else
	$pid=Run($node_exe&" -p "&$nodeport,"",$show)

EndIf
;~ config()
$pid2=Run($music_exe)


TraySetToolTip("网易云音乐解锁服务运行中...(退出网易云音乐,服务自动停止。)")
 

while 1

sleep(100)
if Not ProcessExists($pid2) Or Not ProcessExists($pid) Then 
ProcessClose($pid)
ProcessClose($pid2)
FileMove(@ScriptDir&"\localdata",$file,1)

Sleep(1000)
Exit
EndIf
WEnd 
EndFunc

Func kjfs()
FileCreateShortcut(@ScriptFullPath,@DesktopDir&"\网易云音乐(解锁版).lnk",@ScriptDir,"","解锁灰色歌曲",@ScriptFullPath,"",0)

EndFunc
func delkjfs()
	if FileExists(@DesktopDir&"\网易云音乐(解锁版).lnk") then FileDelete(@DesktopDir&"\网易云音乐(解锁版).lnk")
EndFunc 
		


Func config()

  If Not FileExists($file) Then 
	  FileCopy(@ScriptDir&"\unblockneteasemusic.cfg",$file,1+8)
  Else
	  FileMove($file,@ScriptDir&"\localdata",1)
	  FileCopy(@ScriptDir&"\unblockneteasemusic.cfg",$file,1)
  EndIf
  
	  

EndFunc


Func  diyport()
		SplashTextOn("操作提醒!!!","请在手动设置云音乐的代理端口与配置文件中设置的端口一致后，" &@CRLF& "配置端口为：" & $nodeport&@CRLF&"退出云音乐(是退出不是关闭)并重新运行本程序。",500,90,(@DesktopWidth-500)/2,100)
	RunWait($music_exe)
	FileCopy($file,"unblockneteasemusic.cfg",1)
	IniWrite($settingfile,"node","163set",'yes')
	exit

EndFunc