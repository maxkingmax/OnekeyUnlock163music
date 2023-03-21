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
Opt("TrayAutoPause",0)

FileInstall('unblockneteasemusic.cfg',@ScriptDir&"\unblockneteasemusic.cfg",0)
Global $settingfile=@ScriptDir&"\OKUL163.ini"
Global $node_exe=@ScriptDir&"\unblockneteasemusic-win-x64.exe"
Global $show=0
Global $music_exe=@ScriptDir&"\CloudMusic\cloudmusic.exe"
Global $file=StringTrimRight ($music_exe,14)&"\Netease\CloudMusic\localdata"
Global $node_md5="0xEADF3AC9F0BCFA0C5EB8076A0C67A243"
checkfile()

Func checkfile()
If Not FileExists($settingfile) Then
	onekeygui()
Else
	
	main()
EndIf
EndFunc

Func readfile()
$music_exe=IniRead($settingfile,"path","exe163",$music_exe)
$node_exe=IniRead($settingfile,"path","exenode",$node_exe)
$file=StringTrimRight ($music_exe,14)&"\Netease\CloudMusic\localdata"
$node_md5=IniRead($settingfile,"md5","node","0xEADF3AC9F0BCFA0C5EB8076A0C67A243")
EndFunc



Func onekeygui()
	Opt("TrayIconHide",1)
#Region ### START Koda GUI section ### Form=
Global $Form1_1 = GUICreate("一键部署", 598, 164, -1,-1)
$Label1 = GUICtrlCreateLabel("1.请指定网易云音乐主程序（版本要低于 2.10）的文件位置：(强烈建议下载)", 16, 8, 570, 17)
Global $Labelver = GUICtrlCreateLabel("", 470, 8, 90, 17)

Global $Input1 = GUICtrlCreateInput($music_exe, 16, 32, 457, 21,$ES_READONLY)

Global $Button1 = GUICtrlCreateButton("浏览...", 480, 32, 49, 25)
$Label2 = GUICtrlCreateLabel("2.指定 unblockneteasemusic-win-x64.exe 的位置：（可下载)", 16, 64, 573, 17)
Global $Input2 = GUICtrlCreateInput($node_exe, 16, 88, 457, 21,$ES_READONLY)
Global	$Button2 = GUICtrlCreateButton("浏览...", 480, 88, 49, 25)

Global	$Button3 = GUICtrlCreateButton("下载", 536, 88, 49, 25)
If FileExists($node_exe) Then 
	GUICtrlSetState(-1,$gui_disable)
	GUICtrlSetData(-1,"已下载")
Else
	GUICtrlSetState(-1,$gui_enable)
EndIf

Global $Button4 = GUICtrlCreateButton("部署并运行", 480, 120, 105, 33)
GUICtrlSetState(-1,$gui_disable)
If FileExists($music_exe) And FileExists($node_exe) Then GUICtrlSetState(-1,$gui_enable)
Global $Checkbox1 = GUICtrlCreateCheckbox("创建一键运行桌面快捷方式", 24, 128, 193, 17)
GUICtrlSetState(-1,$GUI_CHECKED)
Global	$Button5 = GUICtrlCreateButton("下载", 536, 32, 49, 25)
If FileExists($music_exe) Then 
	GUICtrlSetState(-1,$gui_disable)
	GUICtrlSetData(-1,"已下载")
Else
	GUICtrlSetState(-1,$gui_enable)
EndIf
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
check163()
checknode()
While 1
	$nMsg = GUIGetMsg()
;~ 	Sleep(500)


	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			
			Exit
		Case $Button1
			$tmp=GUICtrlRead($input1)
			$music_exe=FileOpenDialog("请指定网易云音乐主程序的位置：",@ScriptDir,"可执行程序 (*.exe)" ,1,"cloudmusic.exe",$Form1_1)
			If @error Then 
				GUICtrlSetData($input1,$tmp)
			Else
				
				If Not FileExists($music_exe) Or StringInStr($music_exe,"cloudmusic.exe") =0 Then 
					MsgBox(5,"文件指定错误",'请重新指定位置',0,$Form1_1)
					ControlClick($Form1_1,"",$Button1)
				Else
					GUICtrlSetData($input1,$music_exe)
				EndIf
			EndIf
			check163()
			
		Case $Button2
			
			$tmp2=GUICtrlRead($input2)
			$node_exe=FileOpenDialog("请指定 unblockneteasemusic 的位置：",@ScriptDir,"可执行程序 (*.exe)" ,1,"unblockneteasemusic-win-x64.exe",$Form1_1)
			If @error Then 
				GUICtrlSetData($input2,$tmp2)
			Else
				
				ConsoleWrite(checknodever(GUICtrlRead($Input2)) = $node_md5 ) 
;~ 				ConsoleWrite($node_md5) 
;~ 				ConsoleWrite
			If Not FileExists($node_exe)  Then
				ControlClick($Form1_1,"",$Button2)
			Else

				GUICtrlSetData($input2,$node_exe)

			EndIf
			EndIf
			checknode()
		Case $Button3
			
			downloadnode()
			checknode()
		Case $Button4
			checknode()
			check163()
				IniWrite($settingfile,'path',"exe163",GUICtrlRead($Input1))
				IniWrite($settingfile,'path',"exenode",GUICtrlRead($Input2))
				iniwrite($settingfile,"md5","node",checknodever(GUICtrlRead($Input2)))
				IniWrite($settingfile,"md5","163m",checknodever(GUICtrlRead($input1)))
				
				If GUICtrlRead($Checkbox1)=$GUI_CHECKED Then
				kjfs()
				EndIf
				If GUICtrlRead($Checkbox1)=$GUI_Unchecked Then
					If FileExists(@DesktopDir&"\网易云音乐(解锁版).lnk") Then FileDelete(@DesktopDir&"\网易云音乐(解锁版).lnk")
				EndIf
				GUISetState(@SW_HIDE)
				main()
		Case $Button5
;~ 		Case $Checkbox1
		download163()
			check163()
		Case $Checkbox1
			iniwrite($settingfile,"md5","node",checknodever(GUICtrlRead($Input2)))
			IniWrite($settingfile,"md5","163m",checknodever(GUICtrlRead($input1)))
;~ 			iniwrite($settingfile,"md5","node2",BinaryToString(checknodever(GUICtrlRead($Input2))))
	EndSwitch
WEnd

EndFunc

Func check163()
	If Not FileExists(GUICtrlRead($Input1)) Or   check163ver(GUICtrlRead($Input1)) = 0	Then 
		GUICtrlSetColor($Input1,0xFF0000)
		
	Else
		GUICtrlSetColor($Input1,0x0000FF)
		GUICtrlSetData($Labelver,"指定:"&check163ver(GUICtrlRead($Input1)))
		GUICtrlSetColor($Labelver,0x0000FF)
		GUICtrlSetState($button5,$gui_disable)
		
	EndIf
	
EndFunc

Func checknode()
	If Not FileExists(GUICtrlRead($Input2)) Then 
		GUICtrlSetColor($Input2,0xFF0000)
	Else
		GUICtrlSetColor($Input2,0x0000FF)
		GUICtrlSetState($button3,$gui_disable)		
	EndIf
EndFunc

Func check163ver($filepath)
Local $ver = FileGetVersion($filepath)
$verl=StringSplit($ver,".")
If $verl[1] <=2 and $verl[2] <=9 And $verl[3]<=9 Then 
Return $ver
Else
Return 0
MsgBox(0,'提示','您所指定的网易云音乐版本不支持代理解锁！',0,$Form1_1)
EndIf
EndFunc	

Func checknodever($file)
$md5= _Crypt_HashFile ( $file, $CALG_MD5 )

;~ MsgBox(0,"md5",$md5)
Return String($md5)
EndFunc	


	
Func downloadnode()
If Not FileExists($node_exe)  Then
	GUICtrlSetData($button3,"下载中")
	GUICtrlSetState($button2,$gui_disable)
	GUICtrlSetState($button4,$gui_disable)
Local $sFilePath =@ScriptDir&"\unblockneteasemusic-win-x64.exe"
If Not FileExists($sFilePath) Then
    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("https://github.com/UnblockNeteaseMusic/server/releases/download/v0.27.0/unblockneteasemusic-win-x64.exe", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
;~ 	$iSize = InetGetSize("https://github.com/UnblockNeteaseMusic/server/releases/download/v0.27.0/unblockneteasemusic-win-x64.exe")
    ; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
    Do
        Sleep(250)
		WinSetTitle ( $Form1_1, "", "正在下载 unblockneteasemusic-win-x64.exe "& Round(InetGetInfo($hDownload, $INET_DOWNLOADREAD)/InetGetInfo($hDownload, $INET_DOWNLOADSIZE)*100)&"%")
    Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

    ; Retrieve the number of total bytes received and the filesize.
    Local $iBytesSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
    Local $iFileSize = FileGetSize($sFilePath)

    ; Close the handle returned by InetGet.
    InetClose($hDownload)

WinSetTitle ( $Form1_1, "", "下载完成，")

    ; Display details about the total number of bytes read and the filesize.
    MsgBox($MB_SYSTEMMODAL, "unblockneteasemusic-win-x64.exe  已经下载", "unblockneteasemusic-win-x64.exe 已经下载。"&@crlf&"下载文件: " & $iBytesSize & @CRLF & _
            "远程文件: " & $iFileSize,2)
EndIf
EndIf
	GUICtrlSetData($button3,"已下载")
	GUICtrlSetState($button3,$gui_disable)
	GUICtrlSetState($button4,$gui_enable)
	GUICtrlSetData($input2,$sFilePath)
	
EndFunc


Func download163()
GUICtrlSetData($button5,"下载中")
GUICtrlSetState($button4,$gui_disable)
GUICtrlSetState($button1,$gui_disable)
Local $sFilePath =@ScriptDir&"\CloudMusic.rar"
If Not FileExists($sFilePath) then
    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("https://github.com/maxkingmax/nondanee-unblock163music-helper/releases/download/2.9.9/CloudMusic.rar", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
;~ 	$iSize = InetGetSize("https://github.com/maxkingmax/nondanee-unblock163music-helper/releases/download/2.9.9/CloudMusic.rar")
;~ 	$sum=0
    ; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
;~ 	ConsoleWrite($iSize&@CRLF)
    Do
        Sleep(250)
;~ 		ConsoleWrite(InetGetInfo($hDownload, $INET_DOWNLOADSIZE)&@CRLF)
;~ 		InetGetInfo($hDownload, $INET_DOWNLOADREAD)
;~ 		$sum+=InetGetInfo($hDownload, $INET_DOWNLOADREAD)
		WinSetTitle ( $Form1_1, "", "正在下载 网易云音乐2.9.9压缩包（Repack） "& Round(InetGetInfo($hDownload, $INET_DOWNLOADREAD)/InetGetInfo($hDownload, $INET_DOWNLOADSIZE)*100)&"%")
		
    Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

    ; Retrieve the number of total bytes received and the filesize.
    Local $iBytesSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
    Local $iFileSize = FileGetSize($sFilePath)

    ; Close the handle returned by InetGet.
    InetClose($hDownload)


WinSetTitle ( $Form1_1, "", "下载完成，准备解压！")
    ; Display details about the total number of bytes read and the filesize.
    MsgBox($MB_SYSTEMMODAL, "网易云音乐2.9.9已经下载", "网易云音乐2.9.9已经下载（已经repack,不会自动升级）。"&@CRLF&"3秒后将自动解压并指定主程序位置。"&@CRLF&@crlf&"下载文件: " & $iBytesSize & @CRLF & _
            "远程文件: " & $iFileSize,3)
	EndIf		
	If FileExists("C:\Program Files\WinRAR\unrar.exe") Then 
		RunWait('"C:\Program Files\WinRAR\unrar.exe" x -o+ '&$sFilePath,"",@SW_HIDE )
	Else
		FileInstall("C:\Program Files\WinRAR\unrar.exe",@ScriptDir&"\unrar.exe",1)
		RunWait(@ScriptDir&'\unrar.exe x -o+ '&$sFilePath,"",@SW_HIDE )
	EndIf
	
			If FileExists(@ScriptDir&"\CloudMusic\cloudmusic.exe") Then
			$music_exe=@ScriptDir&"\CloudMusic\cloudmusic.exe"
			GUICtrlSetData($input1,$music_exe)
			GUICtrlSetState($button5,$gui_disable)
			GUICtrlSetState($button4,$gui_enable)
			GUICtrlSetData($button5,"已下载")
			EndIf

	
EndFunc

Func main()
	readfile()
	 config()
If ProcessExists("unblockneteasemusic-win-x64.exe") Then ProcessClose("unblockneteasemusic-win-x64.exe")
$pid=Run($node_exe,"",$show)
;~ config()
$pid2=Run($music_exe)
Opt("TrayIconHide",0)
Opt("TrayMenuMode",1)
TraySetState(4)
TraySetToolTip("网易云音乐解锁服务运行中...(退出网易云音乐,服务自动停止。)")
;~ TrayTip("服务运行中...","退出“网易云音乐”,服务自动停止。",2,1)
Do
	
	Sleep(100)
Until Not ProcessExists($pid2) Or Not ProcessExists($pid)
ProcessClose($pid)
ProcessClose($pid2)
;~ FileMove(@ScriptDir&"\localdata",$file,1)
FileMove(@ScriptDir&"\localdata",$file,1)

Sleep(1000)
Exit
EndFunc

Func kjfs()
readfile()
FileCreateShortcut(@ScriptFullPath,@DesktopDir&"\网易云音乐(解锁版).lnk",@ScriptDir,"","解锁灰色歌曲",$music_exe,"",0)
EndFunc


Func config()

  If Not FileExists($file) Then 
	  FileCopy(@ScriptDir&"\unblockneteasemusic.cfg",$file,1+8)
  Else
	  FileMove($file,@ScriptDir&"\localdata",1)
	  FileCopy(@ScriptDir&"\unblockneteasemusic.cfg",$file,1)
  EndIf
  
	  

EndFunc