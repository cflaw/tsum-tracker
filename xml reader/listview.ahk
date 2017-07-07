#SingleInstance force
#NoEnv
SetTitleMatchMode 2
SetWorkingDir %A_ScriptDir%


Gui, Add, ListView, x0 y0 w300 H300 vMyLV gLV, c1|c2|c3|c4|c5
LV_SetImageList( DllCall( "ImageList_Create", Int,2, Int,60, Int,0x18, Int,1, Int,1 ), 1 )
loop, 5
{  
  a := A_Index
  LV_Add( "", a*1, a*2, a*3, a*4, a*5)
}
Gui, +resize
Gui, Show
return

LV:
if A_GuiEvent = DoubleClick
{
    LV_GetText(Col1, A_EventInfo, 1) ; Get the text of the first  field.
    LV_GetText(Col8, A_EventInfo, 8) ; Get the text of the last field.
    MsgBox You select the row %A_EventInfo%`nCol1=%Col1%`nCol8=%Col8%
}
return


GuiEscape:
GuiClose:
  ExitApp
return