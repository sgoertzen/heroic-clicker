; Heroic Clicker 
; Version: 1.1
; Date: 7/24/2015
; Author: SGoertzen (https://github.com/sgoertzen)
; Adapted from: Andrux51 (http://github.com/Andrux51)
;
; Instructions:
; Run .ahk file (using autohotkey: http://www.autohotkey.com/)
; F9  - Play the game forever (iris, level heroes, grind, salvage relics, ascend)
; F10 - Play the game forever, skipping iris the first time 
; F11 - Pause (press F11 to resume)
; F12 - Exit
;
; **************************************************************************************
;  Set these values
; **************************************************************************************
; How many minutes before it should ascend
global minutesPerAscension := 120
; Set the level of your iris ancient.  Set to Zero if you don't have iris
global irislevel := 200
; change this value to adjust script speed (milliseconds)
global timing := 25

; **************************************************************************************
; **************************************************************************************

#SingleInstance force ; if script is opened again, replace instance
#Persistent ; script stays in memory until ExitApp is called or script crashes

global title := "Clicker Heroes" ; we will exact match against this for steam version
global stop := false
global pause := false
global CLICK_STORM := 170
global POWER_SURGE := 220
global LUCKY_STRIKES := 270
global METAL_DETECTOR := 325
global GOLDEN_CLICKS := 375
global DARK_RITUAL := 425
global SUPER_CLICK := 480
global ENERGIZE := 530
global RELOAD := 580
  
F9::
  doEverything(true)
  return
  
F10::
  doEverything(false)
  return
  
F11::
  pause := !pause
  return
   
F12::
  ExitApp
  return

doEverything(includeIrisStart) {
  setDefaults()
  startTimer()
  while (true) {
    stop := false
    if (includeIrisStart) {
      salvageRelics()
      ascend()
      if (irislevel > 0){
        irisStart()
        levelAllHeroes()
      }
    }
    includeIrisStart := true
    grind()
  }
}

startTimer(){
  timeInMilli := minutesPerAscension * 60 * 1000
  SetTimer, AscensionTimer, %timeInMilli%
}

AscensionTimer:
  stop := true
  return
  
ascend() {
  scrollToListTop()
  ControlClick,, %title%,,,, x545 y420 NA
  Sleep 1000

  ; The scrollbar is inaccurate so just walk down clicking
  ; Go from 200 to 580
  ypos := 200
  while (ypos < 600) {
	ypos += 20
	ControlClick,, %title%,,,, x298 y%ypos% NA
  }

  Sleep 1000
  ; Click ok button
  ControlClick,, %title%,,,, x500 y400 NA
  
  
  scrollToListTop()
  ControlClick,, %title%,,,, x545 y460 NA
  Sleep 1000

  ; The scrollbar is inaccurate so just walk down clicking
  ; Go from 200 to 580
  ypos := 200
  while (ypos < 600) {
	ypos += 20
	ControlClick,, %title%,,,, x298 y%ypos% NA
  }

  Sleep 1000
  ; Click ok button
  ControlClick,, %title%,,,, x500 y400 NA
}

irisStart() {
  ; Just kill some to get initial gold
  Loop, 20 {
    getSkillBonusClickable()
    collectGold()
  }

  ; Go up by ten levels at a time
  steps := Round(irislevel / 13)
  Loop, %steps% {
    if(stop) {
        return
    }
    scrollToListBottom()
    clickHeroInSlot(2,10)
    scrollToFarmZone(13)
    ; Let it get some gold on this new level
    ;Sleep 5000
    Loop, 10 {
      collectGold()
      Sleep timing
    }
  }
  clickProgressionMode()
}


grind() {
  ; We get the title match for the Clicker Heroes game window
  setDefaults()

  i = 1
  ; Send clicks to CH while the script is active (press F8 to stop)
  while(!stop) {
    ; try to catch skill bonus clickable
    getSkillBonusClickable()

		remainder := mod(i, 50)
    if(remainder = 0) {
	    clearRelicDialog()
      getClickables()
    }
        
		remainder := mod(i, 200)
    if(remainder = 0) {     
      goldFound := isGildedHeroInSecondSlot()    
      if (!goldFound) {
        scrollToListBottom()
      }
			clickBuyAvailableUpgrades()
			clickHeroInSlot(2, 25)
      useAbilities()
    }

		remainder := mod(i, 500)
    if(remainder = 0) {
			if (isProgressionModeOff()){
				clickProgressionMode()
			}
    }
        
    i++
    if (i>1000) {
      i = 1
    }
    Sleep timing
    while (pause) {
      Sleep 1000
    }
  }
  return
}

salvageRelics() {
  ControlClick,, %title%,,,, x373 y100 NA ; Click relics tab
  Sleep 500  
  ControlClick,, %title%,,,, x278 y439 NA ; Click Salvage
  Sleep 500
  ControlClick,, %title%,,,, x501 y404 NA ; Click yes button
  Sleep 500
  ControlClick,, %title%,,,, x41 y100 NA ; Click hero tab
  Sleep 500
}

useAbilities() {
    ; TODO: use abilities at more appropriate times
    ; Combos: 123457, 1234, 12

    useAbility(CLICK_STORM)
    useAbility(POWER_SURGE)
    useAbility(LUCKY_STRIKES)
    useAbility(METAL_DETECTOR)
    useAbility(GOLDEN_CLICKS)
    useAbility(SUPER_CLICK)

    useAbility(ENERGIZE)
    useAbility(DARK_RITUAL)
    useAbility(RELOAD)
    return
}


useAbility(ability) {
	ControlClick,, %title%,,,, x600 y%ability% NA
  return
}


clearRelicDialog() {
  ControlClick,, %title%,,,, x560 y375 NA
  Sleep 1000
  ControlClick,, %title%,,,, x925 y120 NA
  Sleep 500
  return
}

collectGold() {
  ControlClick,, %title%,,,, d x760 y420 NA
  Sleep 5
  ControlClick,, %title%,,,, d x800 y420 NA
  Sleep 5
  ControlClick,, %title%,,,, d x850 y420 NA
  Sleep 5
  ControlClick,, %title%,,,, d x910 y420 NA
  Sleep 5
  ControlClick,, %title%,,,, u x5 y300 NA
  return
}

getSkillBonusClickable() {
    ; click in a sequential area to try to catch mobile clickable
    ControlClick,, %title%,,,, x770 y130 NA
    ControlClick,, %title%,,,, x790 y130 NA
    ControlClick,, %title%,,,, x870 y130 NA
    ControlClick,, %title%,,,, x890 y130 NA
    ControlClick,, %title%,,,, x970 y130 NA
    ControlClick,, %title%,,,, x990 y130 NA

    return
}

getClickables() {
    ; clickable positions
    ControlClick,, %title%,,,, x505 y460 NA
    ControlClick,, %title%,,,, x730 y400 NA
    ControlClick,, %title%,,,, x745 y450 NA
    ControlClick,, %title%,,,, x745 y340 NA
    ControlClick,, %title%,,,, x850 y480 NA
    ControlClick,, %title%,,,, x990 y425 NA
    ControlClick,, %title%,,,, x1030 y410 NA

    return
}

setDefaults() {
    SendMode InputThenPlay
    CoordMode, Mouse, Client
    SetKeyDelay, 0, 0
    SetMouseDelay 1 ; anything lower becomes unreliable for scrolling
    SetControlDelay 1 ; anything lower becomes unreliable for scrolling
    SetTitleMatchMode 3 ; window title is an exact match of the string supplied

    return
}

clickForwardArrow(times) {
    ControlClick,, %title%,,, %times%, x1035 y40 NA
    return
}

clickZone() {
    ControlClick,, %title%,,,, x980 y40 NA
    return
}

clickHeroInSlot(slot, times) {
    if(slot = 1) {
        ControlClick,, %title%,,, %times%, x156 y250 NA
    }
    if(slot = 2) {
        ControlClick,, %title%,,, %times%, x156 y356 NA
    }
    if(slot = 3) {
        ControlClick,, %title%,,, %times%, x156 y462 NA
    }
    if(slot = 4) {
        ControlClick,, %title%,,, %times%, x156 y568 NA
    }
    return
}

scrollToFarmZone(zone) {
    ; subtract 3 because zone 3 is already on screen,
    ; so it takes 3 less clicks to get there than the zone number
    clicksToFarmZone := zone - 3
    looper := 0
    while(looper < clicksToFarmZone) {
        clickForwardArrow(1)
        Sleep 5
        looper++
    }

    ; let the screen catch up, then go to zone
    Sleep 300
    clickZone()

    return
}

levelAllHeroes() {
    scrollToListTop()

    ; This is set to click the very right side of each hire button
	; so that it avoids clicking the "Gilded" button when it makes it
	; to the bottom
	offset = 0
	Loop, 7 {
		Sleep 500
		ypos := 246 + offset * 55
		ControlClick,, %title%,,,, x545 y%ypos% NA
		Sleep 500
		upgradeHerosOnScreen()
		offset++
	}

    ; Buy all available upgrades
    Sleep 300
    scrollToListBottom()
    clickBuyAvailableUpgrades()

    return
}

upgradeHerosOnScreen() {
  ; Since the scroll bar is inconsistent, we just slowly walk down the
  ; screen clicking the entire time.  This means some heroes will
  ; have more upgrades then others but everyone will be at
  ; at least 150
  
  ; If the window is active we can great increase the speed of this by
  ; holding down 'Z' while clicking
  WinGetActiveTitle, ActiveWindowTitle
  if (ActiveWindowTitle = title) {
    Send {z down}
  }
  ypos := 200
  while (ypos < 600) {
	ypos += 6
    WinGetActiveTitle, ActiveWindowTitle
    if (ActiveWindowTitle = title) {
	   ControlClick,, %title%,,,1, x156 y%ypos% NA
    }
    else {
	   ControlClick,, %title%,,,25, x156 y%ypos% NA
    }
  }
  if (ActiveWindowTitle = title) {
    Send {z up}
  }
}

clickBuyAvailableUpgrades(){
    ControlClick,, %title%,,,, x280 y550 NA
}

scrollToListTop() {
    ; scroll to the top of the hero list
    ControlClick,, %title%,,,, x545 y208 NA
    ; This pause is needed so the screen can catch up
    Sleep 350
    return
}

scrollToListBottom() {
    ; Sometimes when a new hero unlocked the scrollbar doesn't expand as it should
    ; In order to work around this we scroll to the top first then scroll back down
    scrollToListTop()

    ; Scroll to far bottom of the hero list
    ControlClick,, %title%,,,, x545 y605 NA
    ; This pause is needed so the screen can catch up
    Sleep 350
    return
}

isProgressionModeOff(){
  ImageSearch, foundX, foundY, 1124, 278, 1126, 280, *5 red.png
  if ErrorLevel = 2
		return false
	else if ErrorLevel = 1
		return false
	else
		return true
}

clickProgressionMode() {
    ControlClick,, %title%,,,, x1110 y250 NA
}

isGildedHeroInSecondSlot() {
    ; search at 15-20 x coordinates, between 320 and 380
  ImageSearch, foundX, foundY, 15, 320, 24, 380, *5 gold.png
  ;ImageSearch, foundX, foundY, 17, 360, 17, 361, *5 gold.png
  if ErrorLevel = 2
		return false
	else if ErrorLevel = 1
		return false
	else
		return true
}