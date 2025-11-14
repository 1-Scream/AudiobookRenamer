
; Audiobook Renamer - settings are persisted to an INI. GUI appears only if settings missing.

IniFile := A_ScriptDir "\audiobook_renamer.ini"

; Read persisted settings (if any)
IniRead, BookName, %IniFile%, Settings, BookName, 
IniRead, StartChapter, %IniFile%, Settings, StartChapter, 1
IniRead, TotalChapters, %IniFile%, Settings, TotalChapters, 0
IniRead, NextNum, %IniFile%, Settings, NextNum, 

StartChapter += 0
TotalChapters += 0
NextNum += 0

; If BookName or TotalChapters missing (or zero), show GUI once to set them
if (BookName = "" || TotalChapters <= 0)
{
	Gosub, ShowSetupGUI
}

; Hotkey to edit settings manually later: Ctrl+Shift+S
^+s::
Gosub, ShowSetupGUI
Return

ShowSetupGUI:
Gui, New, +AlwaysOnTop
Gui, Add, Text,, Enter book details (this will be saved):
Gui, Add, Text,, Book name:
Gui, Add, Edit, vG_BookName w420, %BookName%
Gui, Add, Text,, Start chapter number:
Gui, Add, Edit, vG_Start w100, % (StartChapter ? StartChapter : 1)
Gui, Add, Text,, Total chapters in book:
Gui, Add, Edit, vG_Total w100, % (TotalChapters ? TotalChapters : 1)
Gui, Add, Button, gSaveSettings, Save
Gui, Add, Button, gCancelSettings, Cancel
Gui, Show,, Audiobook Setup
Return

SaveSettings:
Gui, Submit
if (G_BookName = "")
{
	MsgBox, 48, Missing, Please enter a book name.
	Return
}
G_Start += 0
G_Total += 0
if (G_Start < 1)
	G_Start := 1
if (G_Total < 1)
{
	MsgBox, 48, Missing, Please enter a valid total chapters number (>=1).
	Return
}

; Persist to INI
IniWrite, %G_BookName%, %IniFile%, Settings, BookName
IniWrite, %G_Start%, %IniFile%, Settings, StartChapter
IniWrite, %G_Total%, %IniFile%, Settings, TotalChapters

; Initialize NextNum to start-1 and persist
NewNext := G_Start - 1
IniWrite, %NewNext%, %IniFile%, Settings, NextNum

; Update runtime vars
BookName := G_BookName
StartChapter := G_Start
TotalChapters := G_Total
NextNum := NewNext

Gui, Destroy
Return

CancelSettings:
Gui, Destroy
; If no settings available, exit script so GUI doesn't keep showing
if (BookName = "" || TotalChapters <= 0)
{
	MsgBox, 48, Exiting, No settings provided. Exiting script.
	ExitApp
}
Return

`::
; Trigger renaming for next chapter, up to TotalChapters
if (TotalChapters <= 0)
{
	MsgBox, 48, NoSettings, Settings are missing. Press Ctrl+Shift+S to set up.
	Return
}
if (NextNum >= TotalChapters)
{
	MsgBox, 64, Done, All chapters processed (%TotalChapters%).`n`nPress Ctrl+Shift+S to change settings.
	Return
}

NextNum += 1

; perform the original send actions with BookName and NextNum
Send {Alt down}{Enter}{Alt up}
Sleep 2000
Click
Send {Up 9}
Send % BookName . NextNum
Sleep 4500
Send {Enter 2}
Sleep 1500
Send {Down 1}

; persist progress
IniWrite, %NextNum%, %IniFile%, Settings, NextNum
Return
