;-----------------------------------------
; Dota 2 Queue-and-Go - FULL AUTO LOOP
;-----------------------------------------

#SingleInstance force
#NoEnv
#Persistent
#MaxThreadsPerHotkey 1

SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 3

if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%"

currentVersion 						:= 	"Dota 2 Queue-and-Go! (Auto Loop + Random Hero)"
Global i_ShareToChat 				:= 	"ShareToChat.png"
icon_Main 							:= 	"icon.ico"

;-----------------------------------------
; ----- H O T K E Y S -----
;-----------------------------------------

IniRead, Hotkey_QueueAndGo, 		hotkeys.ini, Hotkeys, Hotkey_QueueAndGo
IniRead, Hotkey_ScriptReload, 		hotkeys.ini, Hotkeys, Hotkey_ScriptReload
IniRead, Hotkey_ScriptHotkeys, 		hotkeys.ini, Hotkeys, Hotkey_ScriptHotkeys

Hotkey, %Hotkey_QueueAndGo%, 		QueueAndGo, 			UseErrorLevel
Hotkey, %Hotkey_ScriptReload%,		ScriptReload, 			UseErrorLevel
Hotkey, %Hotkey_ScriptHotkeys%,		ScriptHotkeys, 			UseErrorLevel

Tooltip_Hotkey_QueueAndGo 		:= ReplaceModifiers(Hotkey_QueueAndGo)
Tooltip_Hotkey_ScriptReload 	:= ReplaceModifiers(Hotkey_ScriptReload)
Tooltip_Hotkey_ScriptHotkeys 	:= ReplaceModifiers(Hotkey_ScriptHotkeys)

Menu, Tray, NoStandard

Menu, Tray, Add, 			%currentVersion%,										menublank
Menu, Tray, Disable,		%currentVersion%

Menu, Tray, Add,			etofok Link Tree >>,									LinkTree
Menu, Tray, Add,
Menu, Tray, Add,			Run 'Queue-And-Go'`t[%Tooltip_Hotkey_QueueAndGo%],		QueueAndGo
Menu, Tray, Default,		Run 'Queue-And-Go'`t[%Tooltip_Hotkey_QueueAndGo%]
Menu, Tray, Add, 			Reload / Stop`t[%Tooltip_Hotkey_ScriptReload%],			ScriptReload
Menu, Tray, Add,
Menu, Tray, Add, 			Change Hotkeys,											ScriptHotkeys
Menu, Tray, Add, 			Open Folder, 											ScriptFolder
Menu, Tray, Add, 			Open Github, 											ScriptGithub
Menu, Tray, Add, 			Exit Script, 											ScriptExit

Menu, Tray, Icon, 			%icon_Main%,, 1
Menu, Tray, Tip, 			%currentVersion%


; ---
; Optional Add/Remove Launch Dota 2 to the app
; ---

IniRead, Hotkey_LaunchDota2, 		hotkeys.ini, Hotkeys, Hotkey_LaunchDota2

if (Hotkey_LaunchDota2) {

	Hotkey, %Hotkey_LaunchDota2%,	LaunchDota2, 			UseErrorLevel

	Tooltip_Hotkey_LaunchDota2 		:= ReplaceModifiers(Hotkey_LaunchDota2)

	Menu, Tray, Insert, 3&
	Menu, Tray, Insert, 4&,	Launch Dota 2`t[%Tooltip_Hotkey_LaunchDota2%],			LaunchDota2
}


;-----------------------------------------
; ----- G U I   S E T U P -----
;-----------------------------------------

gui_Width		:= 240
gui_Height 		:= 20
gui_margin		:= 15
gui_colorBG		:= 0x467C52
gui_typeFont	:= Tahoma
gui_colorFont	:= "cFAFDFD"
gui_sizeFont	:= 10

Gui, GUI_DotaQueueAndGo:+LastFound -Caption -Border +ToolWindow +AlwaysOnTop
Gui, GUI_DotaQueueAndGo:Color, %gui_colorBG%
Gui, GUI_DotaQueueAndGo:margin, %gui_margin%, %gui_margin%
Gui, GUI_DotaQueueAndGo:Font, s%gui_sizeFont% %gui_colorFont%, %gui_typeFont%
Gui, GUI_DotaQueueAndGo:Add, Text, w%gui_Width% h%gui_Height% vAlert1

WinSet, TransColor, %gui_colorBG% 220, ahk_id %GUI_DotaQueueAndGo%
WinSet, ExStyle, +0x20, ahk_id %GUI_DotaQueueAndGo%


displaySplash := currentVersion
SplashTextOn, 350, 50, , %displaySplash%
Sleep, 1000
SplashTextOff

Return 

; 	END OF AUTOLAUNCH
;-----------------------------------------


; ==========================================
; ===== ОСНОВНАЯ ФУНКЦИЯ =====
; ==========================================

QueueAndGo:

	SplashTextOff

	; Сброс переменных
	weAreInGame 	:= 0
	allConnected 	:= 0
	endTimeReset	:= 10
	endTime 		:= endTimeReset
	heroSelected 	:= 0  ; Флаг выбора героя
	
	; БЕСКОНЕЧНЫЙ ЦИКЛ
	Loop {
		
		; Проверяем, запущена ли Dota 2
		if !WinExist("ahk_exe dota2.exe") {
			Gui, GUI_DotaQueueAndGo:Hide
			SplashTextOn, 200, 45,, Dota 2 not found!
			Sleep 1000
			SplashTextOff
			UpdateGUI("Dota 2 not found! Waiting...")
			Sleep 5000
			continue
		}
		
		; Активируем окно
		WinActivate, Dota 2
		WinGetPos, Dota2WindowStart_X, Dota2WindowStart_Y, Dota2WindowWidth, Dota2WindowHeight, Dota 2
		
		; Показываем GUI
		Gui, GUI_DotaQueueAndGo:Show, % "x" (Dota2WindowStart_X + Dota2WindowWidth - (gui_Width + gui_margin*2)) " y" (Dota2WindowStart_Y + (Dota2WindowHeight * (0.1)))
		
		UpdateGUI("Dota 2 found!")
		Sleep 750
		
		; Ищем кнопку "Поделиться" (Share to Chat)
		WinActivate, Dota 2
		ImageSearch, ShareToChat_X, ShareToChat_Y, Dota2WindowStart_X, Dota2WindowStart_Y, Dota2WindowWidth, Dota2WindowHeight, *50 %i_ShareToChat%
		
		if (ShareToChat_X > 0) {
			
			UpdateGUI("Starting search...")
			; Определяем координаты кнопки "Играть"
			coords_PlayDotaButton_X := Dota2WindowWidth * 0.94
			coords_PlayDotaButton_Y := ShareToChat_Y
			
		} else {
			
			UpdateGUI("'ShareToChat.png' not found! Trying alternative...")
			Sleep 1500
			
			; Альтернативный способ: используем координаты
			coords_PlayDotaButton_X := Dota2WindowWidth * 0.94
			coords_PlayDotaButton_Y := Dota2WindowHeight * 0.85
			
			UpdateGUI("Using alternative coordinates...")
			Sleep 500
		}
		
		; ===== НАЖИМАЕМ КНОПКИ =====
		
		; Нажимаем 'PLAY DOTA'
		UpdateGUI("Clicking 'Play Dota'...")
		Click, %coords_PlayDotaButton_X%, %coords_PlayDotaButton_Y%
		Random ranSleep, 621, 1154
		sleep %ranSleep%
		
		; Нажимаем 'FIND MATCH'
		UpdateGUI("Clicking 'Find Match'...")
		Click, %coords_PlayDotaButton_X%, %coords_PlayDotaButton_Y%
		Sleep 100
		
		; Сворачиваем игру
		WinMinimize, Dota 2
		
		; ===== ОЖИДАНИЕ ПРИНЯТИЯ ИГРЫ =====
		UpdateGUI("Waiting for match...")
		
		while (allConnected = 0) {
			
			; Ждем, пока игра станет активной
			while !(WinActive("ahk_exe dota2.exe")) {
				UpdateGUI("Waiting for Dota 2...")
				Sleep 500
			}
			
			Sleep 500
			UpdateGUI("Dota 2!")
			Sleep 500
			
			UpdateGUI("Loading...")
			Sleep 2500
			
			; Проверяем, есть ли кнопка "Поделиться" (значит, мы в лобби)
			WinActivate, Dota 2
			ImageSearch, ShareToChat_X, ShareToChat_Y, Dota2WindowStart_X, Dota2WindowStart_Y, Dota2WindowWidth, Dota2WindowHeight, *50 %i_ShareToChat%
			
			if !(ShareToChat_X > 0) { 
				; Мы в игре!
				weAreInGame := 1
				UpdateGUI("Game On!")
				Sleep 1000
				break
			} else {
				; Мы в лобби - есть попап для принятия
				UpdateGUI("Accepting match...")
				Sleep 500
				Send {Enter}
				Sleep 250
				UpdateGUI("Minimizing...")
				Sleep 250
				WinMinimize, Dota 2
				Sleep 500
			}
		}
		
		; ===== ОЖИДАНИЕ ПОДКЛЮЧЕНИЯ ИГРОКОВ =====
		UpdateGUI("Waiting for players to connect...")
		
		Loop {
			WinActivate, Dota 2
			ImageSearch, ShareToChat_X2, ShareToChat_Y2, Dota2WindowStart_X, Dota2WindowStart_Y, Dota2WindowWidth, Dota2WindowHeight, *20 %i_ShareToChat%
			
			if (ShareToChat_X2 > 0) { 
				; Кто-то не принял - возвращаемся в лобби
				weAreInGame := 0
				allConnected := 0
				endTime := endTimeReset
				heroSelected := 0  ; Сбрасываем флаг
				Send {Enter}
				Sleep 100
				WinMinimize, Dota 2		
				UpdateGUI("Match cancelled! Restarting...")
				Sleep 1500
				break
			} else {
				tempTxt := "Connecting players in " . endTime . "s..."
				UpdateGUI(tempTxt)
			}
			
			Sleep 1000
			endTime--
			
			if (endTime <= 0) {
				; Игроки подключились - игра началась!
				allConnected := 1
				endTime := endTimeReset
				UpdateGUI("All connected! Game started!")
				Sleep 2000
				break
			}
		}
		
		; Если игра не началась, перезапускаем цикл
		if (allConnected = 0) {
			continue
		}
		
		; ============================================
		; ===== ВЫБОР РАНДОМНОГО ГЕРОЯ =====
		; ============================================
		
		UpdateGUI("Waiting for hero selection screen...")
		
		; ===== ЖДЕМ ПОЯВЛЕНИЯ ЭКРАНА ВЫБОРА ГЕРОЯ =====
		; Ждем, пока появится кнопка "СЛУЧАЙНЫЙ ГЕРОЙ"
		; Ищем характерный цвет/элемент на экране выбора
		
		; Ждем максимум 10 секунд
		heroWaitTime := 0
		heroScreenFound := 0
		
		Loop {
			Sleep 1000
			heroWaitTime += 1
			
			WinActivate, Dota 2
			
			; Проверяем, появился ли экран выбора героя
			; Ищем по цвету в области, где обычно находится кнопка рандома
			PixelGetColor, checkColor, Dota2WindowStart_X + (Dota2WindowWidth * 0.91), Dota2WindowStart_Y + (Dota2WindowHeight * 0.50), RGB
			
			; Если цвет не черный и не темный - значит экран загрузился
			if (checkColor > 0x222222) {
				heroScreenFound := 1
				UpdateGUI("Hero selection screen loaded!")
				Sleep 1000
				break
			}
			
			; Проверка по таймауту (10 секунд)
			if (heroWaitTime >= 10) {
				UpdateGUI("Hero screen timeout, trying anyway...")
				Sleep 1000
				break
			}
			
			UpdateGUI("Waiting for hero screen... " . heroWaitTime . "s")
		}
		
		; ===== НАЖИМАЕМ КНОПКУ "СЛУЧАЙНЫЙ ГЕРОЙ" =====
		UpdateGUI("Selecting random hero...")
		
		; Координаты кнопки "СЛУЧАЙНЫЙ ГЕРОЙ"
		; Для 1920x1080: X=1682, Y=721
		RandomHero_X := Dota2WindowStart_X + (Dota2WindowWidth * 0.876)   ; 87.6% от ширины
		RandomHero_Y := Dota2WindowStart_Y + (Dota2WindowHeight * 0.667)   ; 66.7% от высоты
		
		; Кликаем по кнопке рандома (3 раза для надежности)
		Click, %RandomHero_X%, %RandomHero_Y%
		Sleep 300
		Click, %RandomHero_X%, %RandomHero_Y%
		Sleep 300
		Click, %RandomHero_X%, %RandomHero_Y%
		Sleep 500
		
		UpdateGUI("Random hero selected!")
		Sleep 1000
		
		; ===== ИГРА НАЧАЛАСЬ =====
		UpdateGUI("Game is in progress!")
		Sleep 3000
		
		; ========================================
		; ===== ОЖИДАНИЕ ВОЗВРАТА В МЕНЮ =====
		; ========================================
		UpdateGUI("Waiting for game to end...")
		UpdateGUI("Press CONTINUE manually or use auto-clicker")
		
		; Ждем, пока вернемся в меню
		Loop {
			; Проверяем каждые 10 секунд
			Sleep 10000
			
			WinActivate, Dota 2
			
			; Ищем кнопку "Поделиться" (признак того, что мы в меню)
			ImageSearch, foundX, foundY, Dota2WindowStart_X, Dota2WindowStart_Y, Dota2WindowWidth, Dota2WindowHeight, *50 %i_ShareToChat%
			
			if (foundX > 0) {
				UpdateGUI("Back in menu! Starting new game...")
				Sleep 2000
				break
			}
			
			; Проверяем, не закрылась ли игра
			if !WinExist("ahk_exe dota2.exe") {
				UpdateGUI("Dota 2 closed! Restarting...")
				Sleep 3000
				Loop 10 {
					if WinExist("ahk_exe dota2.exe") {
						break
					}
					Sleep 1000
				}
				break
			}
			
			UpdateGUI("Waiting for you to press CONTINUE...")
		}
		
		; ===== ПОДГОТОВКА К СЛЕДУЮЩЕЙ ИГРЕ =====
		UpdateGUI("Preparing for next game...")
		Sleep 2000
		
		; Сбрасываем флаги
		weAreInGame := 0
		allConnected := 0
		heroSelected := 0
		endTime := endTimeReset
		
		; Ждем, пока загрузится главное меню
		UpdateGUI("Waiting for menu...")
		Sleep 5000
		
		; Проверяем, есть ли кнопка "Поделиться"
		WinActivate, Dota 2
		ImageSearch, ShareToChat_X, ShareToChat_Y, Dota2WindowStart_X, Dota2WindowStart_Y, Dota2WindowWidth, Dota2WindowHeight, *50 %i_ShareToChat%
		
		if (ShareToChat_X > 0) {
			UpdateGUI("Ready for next search!")
			Sleep 1500
		} else {
			UpdateGUI("Menu not ready, waiting...")
			Sleep 5000
		}
		
		; Продолжаем цикл
		UpdateGUI("Starting new search...")
		Sleep 1000
		
	} ; КОНЕЦ БЕСКОНЕЧНОГО ЦИКЛА

return


;--------------------------------
; Update GUI
;--------------------------------

UpdateGUI(message) {
	pAlert1 := message
	GuiControl, GUI_DotaQueueAndGo:, Alert1, % pAlert1
}

;--------------------------------
; LaunchDota2
;--------------------------------

LaunchDota2:
	Run, steam://rungameid/570
return

;--------------------------------
; LinkTree
;--------------------------------

LinkTree:
	Run, https://linktr.ee/etofok
return

;--------------------------------
; Hotkeys.ini
;--------------------------------

ScriptHotkeys:
	Run, %a_scriptdir%/hotkeys.ini
return

;--------------------------------
; Locate This Script
;--------------------------------

ScriptFolder:
	Run, %a_scriptdir%
return

;--------------------------------
; Open on Github
;--------------------------------

ScriptGithub:
	Run, https://github.com/etofok/Dota-2-Queue-and-Go?tab=readme-ov-file#how-to-use
return

;--------------------------------
; Exit This Script
;--------------------------------

ScriptExit:
	ExitApp
return

;--------------------------------
; Reload This Script
;--------------------------------

ScriptReload:
	Reload
return

;--------------------------------
; Translate Tooltip Hotkeys to Human Language
;--------------------------------

ReplaceModifiers(str) {
    str := StrReplace(str, "+", "SHIFT + ")
    str := StrReplace(str, "!", "ALT + ")
    str := StrReplace(str, "^", "CTRL + ")
    str := StrReplace(str, "#", "WIN + ")
    return str
}

menublank:
return