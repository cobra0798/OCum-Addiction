scriptname OCumAddictionMCM extends SKI_ConfigBase

;0 None
;1 spit
;2 swallow
;3 bottle, spit otherwise
;4 bottle, swallow otherwise
Int Property cumAction Auto
Float Property cumSwallowed Auto
Float Property cumSpit Auto

String[] cumActionStrings
String[] pointsOfView

Event OnInit()
    pages = new String[1]
    pages[0] = "main"
    cumAction = 0
    cumSwallowed = 0.0
    cumSpit = 0.0

    cumActionStrings = new String[5]
    cumActionStrings[0] = "None"
    cumActionStrings[1] = "Spit"
    cumActionStrings[2] = "Swallow"
    cumActionStrings[3] = "Bottle, Spit Otherwise"
    cumActionStrings[4] = "Bottle, Swallow Otherwise"
EndEvent

Event OnPageReset(string page)
    If (page == "main")
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddMenuOptionST("CUM_ACTION_STATE", "Spit, Swallow, or Bottle", cumActionStrings[cumAction])
        AddTextOptionST("CUM_SWALLOWED_STATE", "Cum Swallowed", cumSwallowed)
        AddTextOptionST("CUM_SPIT_STATE", "Cum Spit", cumSpit)
    EndIf
EndEvent

State CUM_ACTION_STATE ;MENU

        event OnMenuOpenST()
            SetMenuDialogStartIndex(cumAction)
            SetMenuDialogDefaultIndex(0)
            SetMenuDialogOptions(cumActionStrings)
        endEvent
    
        event OnMenuAcceptST(int a_index)
            cumAction = a_index    
            SetMenuOptionValueST(cumActionStrings[cumAction])
        endEvent
    
        event OnDefaultST()
            cumAction = 0    
            SetTextOptionValueST(cumActionStrings[cumAction])
        endEvent
    
        event OnHighlightST()
            SetInfoText("Sets the default action to take for blowjobs in which the player is giving.")
        endEvent
EndState

State CUM_SWALLOWED_STATE
    event OnHighlightST()
        SetInfoText("The total amount of cum you have swallowed.")
    endEvent
EndState

State CUM_SPIT_STATE
    event OnHighlightST()
        SetInfoText("The total amount of cum you have spit out.")
    endEvent
EndState