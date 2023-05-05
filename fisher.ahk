;===========================================================================
;   CONTROLS
;===========================================================================

; SLOTS 5-15 OF YOUR INVENTORY AND BAG WILL BE USED BY DEFAULT
; MAKE SURE THESE ARE CLEARED

; Press H to start fishing
; Press Esc to quit the script

; Make sure script is running as admin.
; Make sure the part of the screen where the "press h to catch the fish" popup appears has no white 

;===========================================================================
;   CONFIGURATION
;===========================================================================

; Change coordinates in these places if not playing 1920x1080 windowed or having issues using the script
; Use AutoHotkey's Window Spy to find these Coordinates - "Screen"

; 1. DropAndOpenBag() function
; -> First coord is the bag slot where its equipped, this gets right-clicked to open the dialog box.
; -> second coord is the "Drop" button, so it drops the bag

; 2. Transfer(slot) function
; -> You'll need to replace each of the numbers inside of "slotsCoord", "row1Coord", "row2Coord" and "row3Coord".
; -> For slotsCoord, each of these is the X coordinate for each inventory slot 1-6
; -> For each of the rowCoords there are two numbers, the first number is the Y coordinate for that row in your 
;    inventory, the second number is the Y coordinate for that row in your bag.

; 3. the main one -> that under h::
; -> Two places here, both of them will be the same coordinates - you want to find the white pixel section in 
;    the 'i' that pops up when the "you have caught a fish" notification pops up
; -> 1654, 270 <- this is the coord that you replace if needed


; once you've figured out how to use the script you can comment out the two places under h:: that contain
;   MsgBox,,,Found,1
; You can add a #IfWinActive to check if GTA5.exe is running
; Note that ControlSend does not work with GTA5 so game window needs to stay active
; You can also find under h::, there are two variable that are setup - feel free to adjust these

;===========================================================================
; SCRIPT STARTS HERE
;===========================================================================

#SingleInstance force

; Esc to close script
Esc::
ExitApp
return

; basic function to send a keypress in gta
SendKey(key) {
    Send {%key% Down}
    Sleep 150
    Send {%key% Up}
    Sleep 150
}

StartFishing() {
    SendKey("T")
    Send {text}/fish
    SendKey("Enter")
}

DropAndOpenBag() {
    SendKey("i") ; open inventory
    Click, right, 703, 601
    Sleep 150
    Click, 717, 611
    Sleep 150
    SendKey("i") ; close inv
    SendKey("i") ; open inv
}

Transfer(slot) {
    slots = 6
    rows = 3
   
    if (slot < 1 || slot > slots * rows) {
        MsgBox, Invalid slot number!
        return
    }

    row := 1
    while (slot > slots) {
        slot -= slots
        row += 1
    }

    slotsCoord := [785,860,930,1000,1065,1140]
    row1Coord := [625,365]
    row2Coord := [700,440]
    row3Coord := [770,500]
    if (row==1) {
        MouseMove, slotsCoord[slot], row1Coord[1], 10
        Send {LButton DOWN}
        MouseMove, slotsCoord[slot], row1Coord[2], 10
        Send {LButton UP}
        Return
    }
    else if (row==2) {
        MouseMove, slotsCoord[slot], row2Coord[1], 10
        Send {LButton DOWN}
        MouseMove, slotsCoord[slot], row2Coord[2], 10
        Send {LButton UP}
        Return
    }
    else if (row==3) {
        MouseMove, slotsCoord[slot], row3Coord[1], 10
        Send {LButton DOWN}
        MouseMove, slotsCoord[slot], row3Coord[2], 10
        Send {LButton UP}
        Return
    }
    Else {
        MsgBox, "This row does not exist"
        return
    }   
    
}

QuitGame() {
    Send {ALT Down}
    Sleep 150
    Send {F4 Down}
    Sleep 150
    Send {ALT Up}
    Sleep 150
    Send {F4 Up}
    Sleep 150
    SendKey("Enter")
    MsgBox, "Fin"
    return
}


h::
slot := 5 ; this is the starting slot - pick the first slot that would have a fish. from 1-18 counting left to right on each row. 
; this is also where the transfer starts on the bag side, so item in slot 5 in inventory will be transfer to slot 5 in bag
x := 10 ; Fish x number of times. max in inv is 17 and bag is 18, but fish weigh differently so keep fewer number to waste less time

StartFishing()
Sleep, 7000
counter:=0
while counter<x { 
    PixelGetColor, color, 1654, 270
    if (color = "0xFFFFFF") {
        counter++
        SendKey("H")
        MsgBox,,,Found,1 ; comment this out after confirm it work
        ; Wait for 10 seconds
        Sleep, 10000
        StartFishing()
        SendKey("Enter")
        Sleep 5500
    }
    Sleep, 2000
}

; Stop fishing
SendKey("T")
Send {text}/stopfishing
SendKey("Enter")

; Transfer from inventory to bag
DropAndOpenBag() ; Drop Bag then open it
Loop x { ; replace 10 if you fish a diff amount than 10
    Transfer(slot)
    slot++
}
SendKey("i") ; close inv
SendKey("o") ; pick up bag

; Fill inventory with fish
StartFishing()
Sleep, 7000
counter:=0
while counter<x { ; replace 10 if you fish a diff amount than 10
    PixelGetColor, color, 1654, 270
    if (color = "0xFFFFFF") {
        counter++
        MsgBox,,,Found,1 ; comment this out after confirm it works
        SendKey("H")
        Sleep, 12000
        StartFishing()
        SendKey("Enter")
        Sleep 5500
    }
    Sleep, 2000
}
Sleep 10000
; QuitGame() ; Uncomment this if you want the game to alt+f4 once completed
SoundBeep, 175, 800 ; A longer beep at the end
MsgBox, DONE
; end of function
return
