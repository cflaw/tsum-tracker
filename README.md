Tsum Tsum Tracker
==============

Disclaimer
--------------
Gdip.ahk and xml.ahk are both found from AutoHotkey Forums

https://autohotkey.com/board/topic/29449-gdi-standard-library-145-by-tic/

https://autohotkey.com/board/topic/89197-xml-build-parse-xml/

!!important
--------------
- script is written for Nox player, resolution: 405 x 720 
- script must be ran in AHK **ANSI 32-bit**

version 0.3
--------------
1) Current version able to start the loop after 65minutes from start of claim.
If elapsed time > 65minutes, loop will start immediately (actually 10ms after)
Note: Found out that this sequence will result in hearts that no longer gives 200 gold. Need to change sequence to probably send 80 hearts, then do a claim individual.

2) Added option to trigger on and off skype notifications

3) Added debug level to find out why we are stuck at mailbox.
Note: Usually due to the imagesearch of the Check button in the mailbox. If Msgbox shows, means that you probably need to do a recapture of your check button's image in the images folder.

4) OCR added to identify name from NOX screen.

version 0.2
--------------
import into git

version 0.1
--------------
- Manual checking of mail box for hearts using windows+v, and on first load of script
- screen must already be on mail box
- currently only checks for first item in the mail box
- stores image as .png in /logger/ folder
- hex value of image is stored in .xml, also in /logger/ folder
- each user will have an attribute named 'id'
- the same id will be used as the name of the .png
- each user will have an attribute named 'count' which will be incremented when the same user is found
- /images/ contains the required target pictures for ImageSearch
- /archive/ and /new/ folders for old images and new xml required for fresh start (fixed, no longer required)
