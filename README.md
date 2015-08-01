# Heroic Clicker 
Version: 2.0
Author: SGoertzen (https://github.com/sgoertzen) (Adapted from: http://github.com/Andrux51)

Heroic Clicker will play the steam version of Clicker Heroes for you.  
Features:
- Can play the entire game for you forever
- Automatically clicks enemies and levels up your heroes
- Collects fish and bees
- Correctly handles the dialog when a new artifact is found
- Can automatically level up all heroes and purchase their skills
- Will detect your gilded hero and will keep upgraded them only
- Uses your skills as soon as they become available
- Works well with the ancient Iris
- Automatically enables progression mode if a failed boss fight turns it off 

## Instructions:
1. Download all files from this repo
2. Install AutoHotKey (http://www.autohotkey.com/)
3. Double click the HeroicClicker.ahk
4. Use the hotkeys below to perform actions

## Hotkeys
- F9  - Start auto-playing showing options dialog first
- F10 - Start auto-playing with defaults (skip option dialog)
- F11 - Pause (press F11 to resume)
- F12 - Exit

## Warnings!
### Relics Destroyed
If you choose "Do Everything" it will automatically salvage any relics you get.  They will be gone forever.
### Active Window Requirement
The window must be active for the script to detect if auto-progression is off and to detect your highest gilded hero.  Hero leveling is also much faster with the window active.  Everything else works with the window in the background. 
### Pause
Using F11 to pause the grinding does not pause the ascension timer.

## Future Enhancements
- Keep track of the timers on skills and use them more effectively
- Automatically save out the game state on a regular interval
- Detect color of relic and don't ascend if it is purple
