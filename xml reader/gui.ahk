#SingleInstance force
#NoEnv
SetTitleMatchMode 2
SetWorkingDir %A_ScriptDir%


Gui Main: New,, TTAHS
Gui Main: Add, Button, gStartButton x4 y3 w105 h30, &Start
Gui Main: Add, Button, gStopButton x253 y3 w105 h30, &Stop
Gui Main: Add, Button, gPauseButton x129 y3 w105 h30, &Pause
Gui, Add, Picture, x4 y75 vT1, ..\logger\1.png
Gui, Add, Picture, x4 y145  vT2, ..\logger\2.png

Gui, Show
return


StartButton:
return

PauseButton:
return

StopButton:
return

GuiEscape:
GuiClose:
  ExitApp
return