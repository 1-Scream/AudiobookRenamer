


`:: 
NextNum := 0
;
; Hotstring increments `NextNum` each activation and appends it to the name
;
Send {Alt down}{Enter}{Alt up} ; 
Sleep 2000
Click 
Send {Up 9}
NextNum += 1
Send % "Assassin and the empire - " . NextNum  ;name of the current book
sleep 4500
Send {Enter 2}
sleep 1500
Send {Down 1} 
Return
