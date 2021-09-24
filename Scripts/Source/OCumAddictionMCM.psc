scriptname OCumAddictionMCM extends SKI_ConfigBase

OCumAddictionScript oca

String[] cumActionStrings
String[] pointsOfView

Event OnConfigInit()
    oca = (Self as Quest) as OCumAddictionScript
    pages = new String[1]
    pages[0] = "main"
    oca.cumAction = 0
    oca.cumSwallowed = 0.0
    oca.cumSpit = 0.0
    oca.TolerantThreshhold = 100.0
    oca.DependentThreshhold = 200.0
    oca.AddictThreshhold = 300.0
    oca.JunkieThreshhold = 400.0

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
        AddMenuOptionST("CUM_ACTION_STATE", "Spit, Swallow, or Bottle", cumActionStrings[oca.cumAction])
        AddTextOptionST("CUM_SWALLOWED_STATE", "Cum Swallowed", oca.cumSwallowed)
        AddTextOptionST("CUM_SPIT_STATE", "Cum Spit", oca.cumSpit)
        AddSliderOptionST("TOLERANT_THRESHHOLD_STATE", "Tolerance Theshhold", oca.TolerantThreshhold, "{1}")
        AddSliderOptionST("DEPENDENT_THRESHHOLD_STATE", "Dependence Theshhold", oca.DependentThreshhold, "{1}")
        AddSliderOptionST("ADDICT_THRESHHOLD_STATE", "Addict Theshhold", oca.AddictThreshhold, "{1}")
        AddSliderOptionST("JUNKIE_THRESHHOLD_STATE", "Junkie Theshhold", oca.JunkieThreshhold, "{1}")
        AddTextOptionST("IMPORT_STATE", "Import", "Click")
        AddTextOptionST("EXPORT_STATE", "Export", "Click")
    EndIf
EndEvent

State CUM_ACTION_STATE ;MENU

        event OnMenuOpenST()
            SetMenuDialogStartIndex(oca.cumAction)
            SetMenuDialogDefaultIndex(0)
            SetMenuDialogOptions(cumActionStrings)
        endEvent
    
        event OnMenuAcceptST(int a_index)
            oca.cumAction = a_index
            SetMenuOptionValueST(cumActionStrings[oca.cumAction])
        endEvent
    
        event OnDefaultST()
            oca.cumAction = 0    
            SetTextOptionValueST(cumActionStrings[oca.cumAction])
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
        SetSliderDialogStartValue(oca.TolerantThreshhold)
		SetSliderDialogDefaultValue(100)
		SetSliderDialogRange(0, 400)
		SetSliderDialogInterval(1)
    EndEvent

    Event OnSliderAcceptST(float option)
        If option > 0 && option < oca.DependentThreshhold
            oca.TolerantThreshhold = option
            SetSliderOptionValueST(oca.TolerantThreshhold)
        Else
            ShowMessage("Please make sure that the tolerance threshhold is greater than 0 and less than the dependence threshhold.", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        oca.TolerantThreshhold = 100.0
        SetSliderOptionValueST(oca.TolerantThreshhold)
    EndEvent

    Event OnHighlightST()
        SetInfoText("This is the threshhold after which you will have built up a cum tolerance.")
    EndEvent
EndState

State DEPENDENT_THRESHHOLD_STATE ;SLIDER
    Event OnSliderOpenST()
        SetSliderDialogStartValue(oca.DependentThreshhold)
		SetSliderDialogDefaultValue(200)
		SetSliderDialogRange(0, 400)
		SetSliderDialogInterval(1)
    EndEvent

    Event OnSliderAcceptST(float option)
        If option > oca.TolerantThreshhold && option < oca.AddictThreshhold
            oca.DependentThreshhold = option
            SetSliderOptionValueST(oca.DependentThreshhold)
        Else
            ShowMessage("Please make sure that the dependence threshhold is greater than the tolerance threshhold and less than the addict threshhold.", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        oca.DependentThreshhold = 200.0
        SetSliderOptionValueST(oca.DependentThreshhold)
    EndEvent

    Event OnHighlightST()
        SetInfoText("This is the threshhold after which you will have become dependent on cum.")
    EndEvent
EndState

State ADDICT_THRESHHOLD_STATE ;SLIDER
    Event OnSliderOpenST()
        SetSliderDialogStartValue(oca.AddictThreshhold)
		SetSliderDialogDefaultValue(300)
		SetSliderDialogRange(0, 400)
		SetSliderDialogInterval(1)
    EndEvent

    Event OnSliderAcceptST(float option)
        If option > oca.DependentThreshhold && option < oca.JunkieThreshhold
            oca.AddictThreshhold = option
            SetSliderOptionValueST(oca.AddictThreshhold)
        Else
            ShowMessage("Please make sure that the addict threshhold is greater than the dependence threshhold and less than the junkie threshhold.", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        oca.AddictThreshhold = 300.0
        SetSliderOptionValueST(oca.AddictThreshhold)
    EndEvent

    Event OnHighlightST()
        SetInfoText("This is the threshhold after which you will have become completely addicted to cum.")
    EndEvent
EndState

State JUNKIE_THRESHHOLD_STATE ;SLIDER
    Event OnSliderOpenST()
        SetSliderDialogStartValue(oca.JunkieThreshhold)
		SetSliderDialogDefaultValue(400)
		SetSliderDialogRange(0, 400)
		SetSliderDialogInterval(1)
    EndEvent

    Event OnSliderAcceptST(float option)
        If option > oca.AddictThreshhold
            oca.JunkieThreshhold = option
            SetSliderOptionValueST(oca.JunkieThreshhold)
        Else
            ShowMessage("Please make sure that the tolerance threshhold is greater than the addict threshhold.", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        oca.JunkieThreshhold = 400.0
        SetSliderOptionValueST(oca.JunkieThreshhold)
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
        oca.TolerantThreshhold = JMap.GetFlt(ocaMCMSettings, "tolerantThreshhold")
        oca.DependentThreshhold = JMap.GetFlt(ocaMCMSettings, "dependentThreshhold")
        oca.AddictThreshhold = JMap.GetFlt(ocaMCMSettings, "addictThreshhold")
        oca.JunkieThreshhold = JMap.GetFlt(ocaMCMSettings, "junkieThreshhold")
        ForcePageReset()
    EndIf
EndFunction

Function ExportSettings()
    Int ocaMCMSettings = JMap.object()
    JMap.SetFlt(ocaMCMSettings, "tolerantThreshhold", oca.TolerantThreshhold)
    JMap.SetFlt(ocaMCMSettings, "dependentThreshhold", oca.DependentThreshhold)
    JMap.SetFlt(ocaMCMSettings, "addictThreshhold", oca.AddictThreshhold)
    JMap.SetFlt(ocaMCMSettings, "junkieThreshhold", oca.JunkieThreshhold)
    
    Jvalue.WriteToFile(ocaMCMSettings, JContainers.UserDirectory() + "OcaMCMSettings.json")
    ForcePageReset()
EndFunction