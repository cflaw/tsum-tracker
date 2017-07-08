
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

;---------- Version Note -------
ControlGetPos, noxx, noxy, noxw, noxh, subWin1, Nox ahk_class Qt5QWindowIcon
Script_Name = Tsum Tsum Heart Sender with Tracker
Script_Version = V0.1
Menu Tray, Tip, %Script_Name% %Script_Version% `nNOX Res W%noxw% H%noxh%


;---------- GLOBAL VAR ---------
SetWorkingDir %A_ScriptDir%
#Include *i Gdip.ahk
#Include xml.ahk

 noxw := 0
 noxh := 0
 newX := 0
 newY := 0
 GiveHearts = 0
 ; whichSearch:= 1 ; 1 is send hearts, 0 is  claim
 firstStart := 0
 delay := 0
 firstDelay := 1680000 ; 27mins
 secondDelay := 420000 ;7mins
 shortDelay = 20000 ;10 secs
 fullDelay := 3900000 ;65mins  
   
;---------- MAIN LOGIC ------
 IfWinNotExist, Tsum Tsum.txt - Notepad
 {
	Run, C:\Windows\Notepad.exe "Tsum Tsum.txt"
	Sleep, 3000 
 }

 while firstStart < 2 
 {
   GoSub, IniSeq
 }
ExitApp ;TsumTsum

;------------- LABEL(S) ----------

IniSeq:

 GoSub, CheckConnection
 GoSub, SetTime
 ;GoSub, doClaim
 GoSub, CheckHearts
 GoSub, CalDelay
 if elapsed < fullDelay
 {
    delay := fullDelay - elapsed - 1000
  }
  else
  {
	delay := 0
  }
  Sleep, %delay%

Return ; IniSeq

CalDelay:
  prevSecs := currSecs
  FormatTime, currentTime,, hh:mm:ss 
  aTime := StrSplit(currentTime, ":")
  currSecs := (aTime.1 * 3600 + aTime.2 * 60 + aTime.3 )*1000
  elapsed := currSecs - prevSecs
 
Return ; CalDelay

SetTime:
 FormatTime, currentTime,, hh:mm:ss 
 aTime := StrSplit(currentTime, ":")
 currSecs := (aTime.1 * 3600 + aTime.2 * 60 + aTime.3)*1000
Return ; Set Time

SendMessage:
 WinActivate, chunfu law
 Send, %message%
 Sleep, 200
 Send, {Enter}
Return ; SendMessage

doClaim:
 FormatTime, Time,, hh:mm:ss tt
 ControlSend,, ^{End}{Enter}%Time% - Start 20mins Claim{Enter}^{s}, Tsum Tsum.txt - Notepad
 message := Time . " - Start 20mins Claim" ;10mins delay + 10 mins to send hearts
 GoSub, SendMessage
  
 FormatTime, Time,, hh:mm:ss tt
 ControlSend,, %Time% - Claiming All{Enter}^{s}, Tsum Tsum.txt - Notepad
 message := Time . " - Claiming All"
 ;GoSub, SendMessage
 GoSub, ClaimAll
  
 FormatTime, Time,, hh:mm:ss tt
 ControlSend,, %Time% - End 20mins Claim{Enter}^{s}, Tsum Tsum.txt - Notepad
 message := Time . " - End 20mins Claim"
 GoSub, SendMessage
 
 Return ; doClaim

CheckHearts:
 
 FormatTime, Time,, hh:mm:ss tt
 ControlSend,, ^{End}{Enter}%Time% - Start Giving Hearts{Enter}^{s}, Tsum Tsum.txt - Notepad
 message := Time . " - Start Giving Hearts"
 GoSub, SendMessage
 
 FormatTime, Time,, hh:mm:ss tt
 ControlSend,, %Time% - Claiming All{Enter}^{s}, Tsum Tsum.txt - Notepad
 message := Time . " - Claiming All"
 ;GoSub, SendMessage
 GoSub, ClaimAll
 
 FormatTime, Time,, hh:mm:ss tt
 ControlSend,, %Time% - Resetting... {Enter}^{s}, Tsum Tsum.txt - Notepad
 message := Time . " - Resetting..."
 ;GoSub, SendMessage
 GoSub, Reset2Me
  
 FormatTime, Time,, hh:mm:ss tt
 ControlSend,, %Time% - Scrolling to top... {Enter}^{s}, Tsum Tsum.txt - Notepad
 message := Time . " - Scrolling to top..."
 ;GoSub, SendMessage
 GoSub, Scroll2Top

 FormatTime, Time,, hh:mm:ss tt
 ControlSend,, %Time% - Giving Hearts... {Enter}^{s}, Tsum Tsum.txt - Notepad
 message := Time . " - Giving Hearts..."
 ;GoSub, SendMessage
 GoSub, SendHearts
 
 FormatTime, Time,, hh:mm:ss tt
 ControlSend,, %Time% - %GiveHearts% Given {Enter}^{s}, Tsum Tsum.txt - Notepad
 message := Time . " - " . GiveHearts . " Given"
 ;GoSub, SendMessage
 
 ;FormatTime, Time,, hh:mm:ss tt
 ;ControlSend,, %Time% - Claiming All {Enter}^{s}, Tsum Tsum.txt - Notepad
 ;message := Time . " - Claiming All"
 ;GoSub, SendMessage
 ;GoSub, ClaimAll
 
 FormatTime, Time,, hh:mm:ss tt
 ControlSend,, %Time% - End Giving Hearts{Enter}^{s}, Tsum Tsum.txt - Notepad
 message := Time . " - End Giving " . GiveHearts . " Hearts"
 GoSub, SendMessage
 
Return ;CheckHearts

CheckConnection:
	Tap_Count = 0
	Loop
	{
		WinActivate, Nox ahk_class Qt5QWindowIcon ; Select Emulator
		ControlClick, x336 y178, Nox ahk_class Qt5QWindowIcon ; Click mail button.
		Sleep, 1000
		
		PixelSearch, Px1, Py1, 45, 555, 55, 565, 0x9540DE, 3, Fast ;Search for pink heart bottom left of Mail Box.
		if ErrorLevel = 0
			Break
		else
		{
			; Close Button Search 5YY Range
			PixelSearch, Px1, Py1, 195, 550, 205, 560, 0x0AADF0, 3, Fast
			if ErrorLevel = 0
				ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon
			
			; Close Button Search 6YY Range
			PixelSearch, Px1, Py1, 195, 685, 205, 695, 0x16AFF1, 3, Fast
			if ErrorLevel = 0
				ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon

			; Play Again button Error Code: -1
			PixelSearch, Px1, Py1, 310, 435, 320, 445, 0x283B67, 3, Fast
			if ErrorLevel = 0
				ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon

;			; Back button
;			PixelSearch, Px1, Py1, 70, 685, 80, 695, 0x0CAFF1, 3, Fast
;			if ErrorLevel = 0
;				ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon

			; Tap To Start button 
			PixelSearch, Px1, Py1, 195, 605, 205, 615, 0x09AAEF, 3, Fast
			if ErrorLevel = 0
			{
				If Tap_Count = 0
				{
					FormatTime, Time,, hh:mm:ss tt
					ControlSend,, %Time% - Reconnecting... {Enter}, Tsum Tsum.txt - Notepad
					message := Time . " - Reconnecting..."
					;GoSub, SendMessage
				}
				ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon
				Tap_Count++
			}
		}

		}
Return ;CheckConnection

ClaimAll:
 Mail_Claimed = 0
 
 ;Guarantees mailbox is click
 Loop	
 {
	WinActivate, Nox ahk_class Qt5QWindowIcon ; Select Emulator
	PixelSearch, Px1, Py1, 45, 555, 55, 565, 0x9540DE, 3, Fast ;Search for pink heart bottom left of Mail Box.
	if ErrorLevel = 0
		Break
	Else
		ControlClick, x336 y178, Nox ahk_class Qt5QWindowIcon ; Click mail button.
 }

 Loop
 {
	Sleep, 500
	WinActivate, Nox ahk_class Qt5QWindowIcon ; Select Emulator
	
	; Search for Claim All button
	;PixelSearch, Px1, Py1, 350, 565, 360, 575, 0x08ADF1, 3, Fast
	;if ErrorLevel = 0
	;	ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon
	
	Loop	
	{
		GoSub, StartIndivClaim ; start the individual claim
		
		Sleep, 200
		ControlClick, x336 y178, Nox ahk_class Qt5QWindowIcon ; Click mail button.
		Sleep, 300
		PixelSearch, Px1, Py1, 105, 275, 115, 280, 0x9540DE, 3, Fast ;Search for first pink heart in the Mail Box.
			
		if (ErrorLevel = 1) {
			;msgbox no first heart
			Break
		}

	}
	
	; Play Again button Error Code: -1
	PixelSearch, Px1, Py1, 310, 435, 320, 445, 0x283B67, 3, Fast
	if ErrorLevel = 0
		ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon

	; OK button in Receive Gift popup
	PixelSearch, Px1, Py1, 310, 435, 320, 445, 0x0AB0F2, 3, Fast
	if ErrorLevel = 0
		ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon

	; Received - Close Button Search 5YY Range
	PixelSearch, Px1, Py1, 195, 550, 205, 560, 0x0AADF0, 3, Fast
	if ErrorLevel = 0
	{
		ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon
		Loop
		{
			WinActivate, Nox ahk_class Qt5QWindowIcon ; Select Emulator
			PixelSearch, Px1, Py1, 45, 555, 55, 565, 0x9540DE, 3, Fast ;Search for pink heart bottom left of Mail Box.
			if ErrorLevel = 0
			{
				Mail_Claimed++
				Break
			}

			; Disconnected
			PixelSearch, Px1, Py1, 195, 605, 205, 615, 0x09AAEF, 3, Fast
			if ErrorLevel = 0
			{
				GoSub CheckConnection
				FormatTime, Time,, hh:mm:ss tt
				ControlSend,, %Time% - Claiming All {Enter}^{s}, Tsum Tsum.txt - Notepad
				message := Time . " - Claiming All"
				GoSub, SendMessage
				Break
			}
		}
		if Mail_Claimed > 0
			Break
	}
				
	; No messages notice in Mail Box
	PixelSearch, Px1, Py1, 195, 255, 205, 265, 0xE7CC70, 3, Fast
	if ErrorLevel = 0
	{
		FormatTime, Time,, hh:mm:ss tt
		ControlSend,, %Time% - Nothing To Claim{Enter}, Tsum Tsum.txt - Notepad
		message := Time . " - Nothing To Claim"
		;GoSub, SendMessage
		Break
	}
 }

Loop
{
	WinActivate, Nox ahk_class Qt5QWindowIcon ; Select Emulator
	Sleep, 500
	
	; Break loop if play button found on Leaderboard
	PixelSearch, Px1, Py1, 200, 640, 210, 650, 0x0F85FF, 3, Fast 
	if ErrorLevel = 0
		Break

 	; Guarantees Info Received popup gets closed
	PixelSearch, Px1, Py1, 195, 550, 205, 560, 0x0AADF0, 3, Fast
	if ErrorLevel = 0
		ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon

 	; Close Mail Box
	PixelSearch, Px1, Py1, 190, 685, 200, 695, 0x16AFF1, 3, Fast
	if ErrorLevel = 0
		ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon
}
	
Return ;ClaimAll 

Reset2Me:
	ResetL = 0
	Loop
	{
		if ResetL > 0
			Break
		else
		{	
			WinActivate, Nox ahk_class Qt5QWindowIcon ; Select Emulator
			Sleep, 500
			
			;Play button in leaderboard
			PixelSearch, Px1, Py1, 200, 640, 210, 650, 0x0F85FF, 3, Fast
			if ErrorLevel = 0
				ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon
		
			;Pink Start Button
			PixelSearch, Px1, Py1, 200, 640, 210, 650, 0x7D69F5, 3, Fast
			if ErrorLevel = 0
			{
				ControlClick, x70 y637, Nox ahk_class Qt5QWindowIcon ;Click Back Button
				Loop
				{
					Sleep, 500
					PixelSearch, Px1, Py1, 200, 640, 210, 650, 0x0F85FF, 3, Fast
					if ErrorLevel = 0
						Break
					else
						ControlClick, x70 y637, Nox ahk_class Qt5QWindowIcon ;Click Back Button
				}
				ResetL++
			}
		}
	}

Return ;Reset2Me

Scroll2Top:

 Loop
 {
	WinActivate, Nox ahk_class Qt5QWindowIcon ; Select Emulator
	Sleep, 1000

	PixelSearch, Px1, Py1, 70, 270, 80, 320, 0x39C5F4, 3, Fast
	if ErrorLevel
	{
		ControlClick, x217 y270 , Nox ahk_class Qt5QWindowIcon,,,, D ,,, NA
		ControlClick, x217 y500 , Nox ahk_class Qt5QWindowIcon,,,, U ,,, NA
	}
	Else
		Break
}
Return ;Scroll2Top

SendHearts:
	GiveHearts = 0
	loop
	{
		Sleep, 750
		; Search for 0 Scores
		WinActivate, Nox ahk_class Qt5QWindowIcon ; Select Emulator
		PixelSearch, Osx, Osy, 260, 300, 280, 500, 0xFFFFFF, 2, Fast ; x1 y1 x2 y2
		if ErrorLevel ;if no whites, stop searching for hearts. if errorlevel = 1, white is not found
		    Break

		; Search for Pink Hearts
		PixelSearch, Px1, Py1, 320, 240, 380, 550, 0x8B3DE1, 3, Fast
		if ErrorLevel ; Scroll Down if no pink found
		{
			;End of List
			WinActivate, Nox ahk_class Qt5QWindowIcon ; Select Emulator
			PixelSearch, Ex1, Ey1, 80, 390, 90, 530, 0x31509C, 3, Fast
			if ErrorLevel = 0
				Break

			ControlClick, x62 y500 , Nox ahk_class Qt5QWindowIcon,,,, D ,,, NA			
			Sleep, 25
			ControlClick, x62 y475 , Nox ahk_class Qt5QWindowIcon,,,, D ,,, NA			
			Sleep, 25
			ControlClick, x62 y450 , Nox ahk_class Qt5QWindowIcon,,,, D ,,, NA			
			Sleep, 25
			ControlClick, x62 y425 , Nox ahk_class Qt5QWindowIcon,,,, D ,,, NA			
			Sleep, 25
			ControlClick, x62 y400 , Nox ahk_class Qt5QWindowIcon,,,, D ,,, NA			
			Sleep, 25
			ControlClick, x62 y375 , Nox ahk_class Qt5QWindowIcon,,,, D ,,, NA			
			Sleep, 25
			ControlClick, x62 y350 , Nox ahk_class Qt5QWindowIcon,,,, D ,,, NA			
			Sleep, 25
			ControlClick, x62 y325 , Nox ahk_class Qt5QWindowIcon,,,, D ,,, NA			
			Sleep, 25
			ControlClick, x62 y300 , Nox ahk_class Qt5QWindowIcon,,,, D ,,, NA
			Sleep, 25
			ControlClick, x62 y275 , Nox ahk_class Qt5QWindowIcon,,,, D ,,, NA			
			Sleep, 25
			ControlClick, x62 y275 , Nox ahk_class Qt5QWindowIcon,,,, U ,,, NA
		}
		else  ; Give Hearts 
		{	
			ControlClick, X%Px1% Y%Py1%, Nox ahk_class Qt5QWindowIcon
			Loop
			{
				WinActivate, Nox ahk_class Qt5QWindowIcon ; Select Emulator

				; OK button in Gift a Heart popup
				PixelSearch, Px1, Py1, 310, 435, 320, 445, 0x0AB0F2, 3, Fast
				if ErrorLevel = 0
					ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon

				; Play Again button Error Code: -1
				PixelSearch, Px1, Py1, 310, 435, 320, 445, 0x283B67, 3, Fast
				if ErrorLevel = 0
					ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon


				; Heart Sent
				PixelSearch, Px1, Py1, 290, 435, 300, 445, 0xE6C11F, 3, Fast
				if ErrorLevel = 0
				{
					;PixelSearch, testX1, testY1, x%Px1% - 80, y%Py1%, x%Px1% - 50, y%Py1% +20, 0xFFFFFF, 3, Fast
					;if ErrorLevel = 0
					;{
					ControlClick, x%Px1% y%Py1%, Nox ahk_class Qt5QWindowIcon
					GiveHearts++
					;}
					Break
				}
	
				; Error 6 - Disconnected while giving hearts
				PixelSearch, Px1, Py1, 195, 550, 205, 560, 0x0AADF0, 3, Fast
				if ErrorLevel = 0
				{
 					FormatTime, Time,, hh:mm:ss tt
					ControlSend,, %Time% - Disconnected.  %GiveHearts% Given {Enter}^{s}, Tsum Tsum.txt - Notepad
					message := Time . " - Disconnected. " . GiveHearts . " Given"
					GoSub, SendMessage
					ExitApp
				}

			} 
		}
	}

Return ;SendHearts


getName(newX, newY) {
	
	newX1 := newX + 70
	newY1 := newY + 25
	newX2 := 210+newX
	newY2 := 41+newY
	
	TempFile := A_Temp . "\temp_capture.txt"
	FileDelete, %TempFile%
	RunWait, ocr\Capture2Text_CLI.exe -s "%newX1% %newY1% %newX2% %newY2%" -o %TempFile%,,Hide
	FileRead, CaptureText, %TempFile%
	FileDelete, %TempFile%
	
	modText := StrSplit(CaptureText, "(C")
	modText := RegexReplace( modText[1], "\.+", "" )
	
	return % modText
}

CheckImage(file,which,byRef getX := -1 ,byRef getY := -1) {
    global noxw
    global noxh
	
	WinActivate, Nox ahk_class Qt5QWindowIcon

	ImageSearch resultX, resultY, 0, 0, A_ScreenWidth, A_ScreenHeight, %which%\%file%
    ;PixelSearch, resultX, resultY, 270, 200, 340, 480, 0x0CBEF6 , 5, Fast

    getX := resultX
    getY := resultY

    if (ErrorLevel == 0) {
		;MsgBox found image
        return True
    }
    else {
		;MsgBox did not find image
        return False
    }
}

CreateRec(xPos, yPos) {
	Global newX
	Global newY
	
	try
		x := new xml("<users/>") 

	catch pe ; catch parsing error(if any)
		MsgBox, 16, PARSE ERROR
		, % "Exception thrown!!`n`nWhat: " pe.What "`nFile: " pe.File
		. "`nLine: " pe.Line "`nMessage: " pe.Message "`nExtra: " pe.Extra
		x.load("logger/tracker.xml")
	
	id := 1
	if x.documentElement {
		docNode := x.selectSingleNode("//users")
		id := docNode.childNodes.length + 1
	}
	
	file2=%A_ScriptDir%\logger\%id%.png
	WinGetPos, c_X, c_Y, , , A
	newX := c_X + xPos - 243
	newY := c_Y + yPos - 26
		
	pToken:=Gdip_Startup()
	raster:=0x40000000 + 0x00CC0020
	pBitmap:=Gdip_BitmapFromScreen(0,raster)
	pBitmap_part:=Gdip_CloneBitmapArea(pBitmap, newX, newY, 210,61) ;get active window - x,y, width, height
	Gdip_SaveBitmapToFile(pBitmap_part, file2)
	Gdip_DisposeImage(pBitmap)
	Gdip_DisposeImage(pBitmap_part)
	Gdip_Shutdown(pToken)
	
	return id	
}

IndivClaim:
    Global getX
    Global getY

	if CheckImage("CheckPart.png", "images", getX, getY) {
		id := CreateRec(getX, getY)
		InsertXML(id)
    }
	else {
		;MsgBox not found claim indiv
	}
	
Return ; IndivClaim

StartIndivClaim:

	Loop {
		Sleep, 250
		WinActivate, Nox ahk_class Qt5QWindowIcon
		PixelSearch, Px1, Py1, 105, 275, 115, 280, 0x9540DE, 3, Fast ;Search for first pink heart in the Mail Box.
			
		if (ErrorLevel = 1) {
			;msgbox no first heart
			Break
		}
		else {
			Sleep, 250
			GoSub, IndivClaim ; start working on first item in mail box
			Sleep, 500
			ControlClick, x310 y250, Nox ahk_class Qt5QWindowIcon ; Click check button.	
			Sleep, 350
			ControlClick, x270 y440, Nox ahk_class Qt5QWindowIcon 	; click ok
			Sleep, 400
			ControlClick, x270 y440, Nox ahk_class Qt5QWindowIcon 	;  click away
		}
	}
Return ; StartIndivClaim


InsertXML(id) {
	Global newX
	Global newY
	
	name := getName(newX,newY)
	
	; get current user to check against records in XML
	File = logger\%id%.png
	FileGetSize, len  , %File% 
	FileRead , bin , %File% 
	Pointer := &bin 
	data := Mem2Hex( Pointer, len )
	
	try
		x := new xml("<users/>") 

	catch pe ; catch parsing error(if any)
		MsgBox, 16, PARSE ERROR
		, % "Exception thrown!!`n`nWhat: " pe.What "`nFile: " pe.File
		. "`nLine: " pe.Line "`nMessage: " pe.Message "`nExtra: " pe.Extra
		if(!x.load("logger/tracker.xml")) {
			x.addElement("users", "")
			x.writeXML("logger/tracker.xml")
		}
	if x.documentElement {
		found := 0
		docNode := x.selectSingleNode("//users")
		if (docNode.childNodes.length > 0) {
			for childnode in docNode.childNodes
			{
				; MsgBox checking
				if (childnode.text == data)	{	
					a := childnode.getAttribute("id")
					found := 1
					c := childnode.getAttribute("count") + 1
					childnode.setAttribute("count", c)
					FileDelete, logger\%id%.png ; user already exists
					;MsgBox found
					break
				}
			}
		}
		
		if (found < 1) {
			c := 1
			a := docNode.childNodes.length + 1
			
			if (childnode.getAttribute("id")) {
				a := childnode.getAttribute("id") + 1
				;MsgBox %a%
			}

			x.addElement("user", "//users", {id: a}, {name: name}, {count: c},data)
			;MsgBox not found
		}
		x.writeXML("logger/tracker.xml")
	}
}

Mem2Hex( pointer, len ) {
	A_FI := A_FormatInteger 
	SetFormat, Integer, Hex 
	Loop, %len%  { 
	  Hex := *Pointer+0 
	  StringReplace, Hex, Hex, 0x, 0x0 
	  StringRight Hex, Hex, 2            
	  hexDump := hexDump . hex 
	  Pointer ++ 
	} 
	SetFormat, Integer, %A_FI% 
	StringUpper, hexDump, hexDump 
	return SubStr(hexDump,1,255)
}


;---------- HOTKEYS ---------
Pause::Pause
#v::GoSub, IndivClaim
^Esc::ExitApp

