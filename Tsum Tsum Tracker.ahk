
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

;---------- Version Note -------
ControlGetPos, noxx, noxy, noxw, noxh, subWin1, Nox ahk_class Qt5QWindowIcon
Script_Name = Tsum Tsum Tracker
Script_Version = V0.1
Menu Tray, Tip, %Script_Name% %Script_Version% `nNOX Res W%noxw% H%noxh%

;---------- GLOBAL VAR ---------
SetWorkingDir %A_ScriptDir%
#Include *i Gdip.ahk
#Include xml.ahk

n_Width := 0
n_Height := 0
ControlGetPos, n_X, n_Y, n_Width, n_Height, subWin1, Nox ahk_class Qt5QWindowIcon

;---------- MAIN LOGIC ------
GoSub, IndivClaim
return
ExitApp ;TsumTsum

;------------- LABEL(S) ----------

CheckImage(file,which,byRef getX := -1 ,byRef getY := -1) {
    global n_Width
    global n_Height
	
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
	
	WinGetPos, c_X, c_Y, , , A
	file2=%A_ScriptDir%\logger\%id%.png
		
	pToken:=Gdip_Startup()
	raster:=0x40000000 + 0x00CC0020

	pBitmap:=Gdip_BitmapFromScreen(0,raster)
	G2 := Gdip_GraphicsFromImage(pBitmap), Gdip_SetSmoothingMode(G2, 10), Gdip_SetInterpolationMode(G2, 10)
	Gdip_DrawImage(G2, pBitmap, 0, 0, w, h,"","","","", "-1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|1|1|1|0|1")
	Gdip_DeleteGraphics(G2)
	;newX := c_X + xPos - 225
	;newY := c_Y + yPos - 6
	
	newX := c_X + xPos - 243
	newY := c_Y + yPos - 26
	
	pBitmap_part:=Gdip_CloneBitmapArea(pBitmap, newX, newY, 180,61) ;get active window - x,y, width, height
	
	Gdip_SaveBitmapToFile(pBitmap_part, file2)

	Gdip_DisposeImage(pBitmap)
	Gdip_DisposeImage(pBitmap_part)
	Gdip_DisposeImage(G2)
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

InsertXML(id) {
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

			x.addElement("user", "//users", {id: a}, {count: c}, data)
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
#c::Pause
#v::GoSub, IndivClaim
^Esc::ExitApp

