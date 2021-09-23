scriptname OCumAddictionMCM extends SKI_ConfigBase

;0 None
;1 spit
;2 swallow
;3 bottle, spit otherwise
;4 bottle, swallow otherwise
Int Property cumAction Auto
Float Property cumSwallowed Auto
Float Property cumSpit Auto
Float Property TolerantThreshhold Auto
Float Property DependentThreshhold Auto
Float Property AddictThreshhold Auto
Float Property JunkieThreshhold Auto
OCumAddictionScript oca

String[] cumActionStrings
String[] pointsOfView

Event OnInit()
    oca = (Self as Quest) as OCumAddictionScript
    pages = new String[1]
    pages[0] = "main"
    cumAction = 0
    cumSwallowed = 0.0
    cumSpit = 0.0
    TolerantThreshhold = 100.0
    DependentThreshhold = 200.0
    AddictThreshhold = 300.0
    JunkieThreshhold = 400.0

    cumActionStrings = new String[5]
    cumActionStrings[0] = "No Action"
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
        AddSliderOptionST("TOLERANT_THRESHHOLD_STATE", "Tolerance Theshhold", TolerantThreshhold, "{1}")
        AddSliderOptionST("DEPENDENT_THRESHHOLD_STATE", "Dependence Theshhold", DependentThreshhold, "{1}")
        AddSliderOptionST("ADDICT_THRESHHOLD_STATE", "Addict Theshhold", AddictThreshhold, "{1}")
        AddSliderOptionST("JUNKIE_THRESHHOLD_STATE", "Junkie Theshhold", JunkieThreshhold, "{1}")
        AddTextOptionST("IMPORT_STATE", "Import", "Click")
        AddTextOptionST("EXPORT_STATE", "Export", "Click")
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

State CUM_SWALLOWED_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("The total amount of cum you have swallowed.")
    endEvent
EndState

State CUM_SPIT_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("The total amount of cum you have spit out.")
    endEvent
EndState

State IMPORT_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("Click here to import settings.")
    endEvent

    event onSelectST()
        if ShowMessage("Are you sure you want to import settings?\nThey will override your current settings.", true)
            ImportSettings()
        endif
    endEvent
EndState

State EXPORT_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("Click here to export settings.")
    endEvent

    event onSelectST()
        if ShowMessage("Are you sure you want to export settings?\nThey will override your stored settings.", true)
            ExportSettings()
        endif
    endEvent
EndState

State TOLERANT_THRESHHOLD_STATE ;SLIDER
    Event OnSliderOpenST()
        SetSliderDialogStartValue(TolerantThreshhold)
		SetSliderDialogDefaultValue(100)
		SetSliderDialogRange(0, 400)
		SetSliderDialogInterval(1)
    EndEvent

    Event OnSliderAcceptST(float option)
        If option > 0 && option < DependentThreshhold
            TolerantThreshhold = option
            SetSliderOptionValueST(TolerantThreshhold)
        Else
            ShowMessage("Please make sure that the tolerance threshhold is greater than 0 and less than the dependence threshhold.", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        TolerantThreshhold = 100.0
        SetSliderOptionValueST(TolerantThreshhold)
    EndEvent

    Event OnHighlightST()
        SetInfoText("This is the threshhold after which you will have built up a cum tolerance.")
    EndEvent
EndState

State DEPENDENT_THRESHHOLD_STATE ;SLIDER
    Event OnSliderOpenST()
        SetSliderDialogStartValue(DependentThreshhold)
		SetSliderDialogDefaultValue(200)
		SetSliderDialogRange(0, 400)
		SetSliderDialogInterval(1)
    EndEvent

    Event OnSliderAcceptST(float option)
        If option > TolerantThreshhold && option < AddictThreshhold
            DependentThreshhold = option
            SetSliderOptionValueST(DependentThreshhold)
        Else
            ShowMessage("Please make sure that the dependence threshhold is greater than the tolerance threshhold and less than the addict threshhold.", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        DependentThreshhold = 200.0
        SetSliderOptionValueST(DependentThreshhold)
    EndEvent

    Event OnHighlightST()
        SetInfoText("This is the threshhold after which you will have become dependent on cum.")
    EndEvent
EndState

State ADDICT_THRESHHOLD_STATE ;SLIDER
    Event OnSliderOpenST()
        SetSliderDialogStartValue(AddictThreshhold)
		SetSliderDialogDefaultValue(300)
		SetSliderDialogRange(0, 400)
		SetSliderDialogInterval(1)
    EndEvent

    Event OnSliderAcceptST(float option)
        If option > DependentThreshhold && option < JunkieThreshhold
            AddictThreshhold = option
            SetSliderOptionValueST(AddictThreshhold)
        Else
            ShowMessage("Please make sure that the addict threshhold is greater than the dependence threshhold and less than the junkie threshhold.", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        AddictThreshhold = 300.0
        SetSliderOptionValueST(AddictThreshhold)
    EndEvent

    Event OnHighlightST()
        SetInfoText("This is the threshhold after which you will have become completely addicted to cum.")
    EndEvent
EndState

State JUNKIE_THRESHHOLD_STATE ;SLIDER
    Event OnSliderOpenST()
        SetSliderDialogStartValue(JunkieThreshhold)
		SetSliderDialogDefaultValue(400)
		SetSliderDialogRange(0, 400)
		SetSliderDialogInterval(1)
    EndEvent

    Event OnSliderAcceptST(float option)
        If option > AddictThreshhold
            JunkieThreshhold = option
            SetSliderOptionValueST(JunkieThreshhold)
        Else
            ShowMessage("Please make sure that the tolerance threshhold is greater than the addict threshhold.", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        JunkieThreshhold = 400.0
        SetSliderOptionValueST(JunkieThreshhold)
    EndEvent

    Event OnHighlightST()
        SetInfoText("This is the threshhold after which you will have become a cum junkie.")
    EndEvent
EndState

Function ImportSettings()
    Int ocaMCMSettings
    if (JContainers.FileExistsAtPath(JContainers.UserDirectory() + "OcaMCMSettings.json"))
		ocaMCMSettings = JValue.readFromFile(JContainers.UserDirectory() + "OcaMCMSettings.json")
    elseif (JContainers.FileExistsAtPath(".\\Data\\OcaMCMSettings.json"))
		ocaMCMSettings = JValue.readFromFile(".\\Data\\OcaMCMSettings.json")
	endif
    If ocaMCMSettings
        TolerantThreshhold = JMap.GetFlt(ocaMCMSettings, "tolerantThreshhold")
        DependentThreshhold = JMap.GetFlt(ocaMCMSettings, "dependentThreshhold")
        AddictThreshhold = JMap.GetFlt(ocaMCMSettings, "addictThreshhold")
        JunkieThreshhold = JMap.GetFlt(ocaMCMSettings, "junkieThreshhold")
        ForcePageReset()
    EndIf
EndFunction

Function ExportSettings()
    Int ocaMCMSettings = JMap.object()
    JMap.SetFlt(ocaMCMSettings, "tolerantThreshhold", TolerantThreshhold)
    JMap.SetFlt(ocaMCMSettings, "dependentThreshhold", DependentThreshhold)
    JMap.SetFlt(ocaMCMSettings, "addictThreshhold", AddictThreshhold)
    JMap.SetFlt(ocaMCMSettings, "junkieThreshhold", JunkieThreshhold)
    
    Jvalue.WriteToFile(ocaMCMSettings, JContainers.UserDirectory() + "OcaMCMSettings.json")
    ForcePageReset()
EndFunction