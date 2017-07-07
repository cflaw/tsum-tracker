Path = ..\logger
dir = user

   ;FileDelete %Path%\%dir%.html
   Loop %Path%\*.png
   {
      imgcnt++
      If imgcnt = 10
      {
         EROW = </tr><tr>
         imgcnt = 0
      }
      Else
         EROW =
      If A_Index = 1
        FileAppend, <html>`n<body>`n<table>`n, %Path%\%dir%.html
      FileAppend,
      (LTrim
	  <tr>
      <td align="middle">
      <img src="file://%A_LoopFileLongPath%" border="no">
      </td>
	  </tr>
      %EROW%
      ), %Path%\%dir%.html
   }

FileAppend, </table>`n</body>`n</html>, %Path%\%dir%.html
Run, %Path%\%dir%.html