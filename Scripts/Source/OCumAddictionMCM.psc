scriptname OCumAddictionMCM extends SKI_ConfigBase

OCumAddictionScript oca

String[] cumActionStrings
String[] pointsOfView

Event OnConfigInit()
    oca = (Self as Quest) as OCumAddictionScript
    pages = new String[2]
    pages[0] = "main"
    pages[1] = "stats"
    oca.TolerantThreshhold = 100.0
    oca.DependentThreshhold = 200.0
    oca.AddictThreshhold = 300.0
    oca.JunkieThreshhold = 400.0
    oca.DecayRate = 1.0
    oca.DigestRate = 1.0
    oca.debugMode = False
    oca.UpdateFreq = 120
EndEvent

Event OnPageReset(string page)
    If (page == "main")
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddSliderOptionST("TOLERANT_THRESHHOLD_STATE", "Tolerance Theshhold", oca.TolerantThreshhold, "{1} ML")
        AddSliderOptionST("DEPENDENT_THRESHHOLD_STATE", "Dependence Theshhold", oca.DependentThreshhold, "{1} ML")
        AddSliderOptionST("ADDICT_THRESHHOLD_STATE", "Addict Theshhold", oca.AddictThreshhold, "{1} ML")
        AddSliderOptionST("JUNKIE_THRESHHOLD_STATE", "Junkie Theshhold", oca.JunkieThreshhold, "{1} ML")
        AddSliderOptionST("DIGEST_RATE_STATE", "Digest Rate", oca.DigestRate, "{2} ML/HR")
        AddSliderOptionST("DECAY_RATE_STATE", "Decay Rate", oca.DecayRate, "{2} ML/HR")
        AddSliderOptionST("UPDATE_FREQUENCY_STATE", "Update Frequency", oca.UpdateFreq, "{0} Seconds")
        AddToggleOptionST("DEBUG_MODE_STATE", "Enable debug messages", oca.debugMode)
        AddTextOptionST("IMPORT_STATE", "Import", "Click")
        AddTextOptionST("EXPORT_STATE", "Export", "Click")
    ElseIf(page == "stats")
        AddTextOptionST("CUM_SWALLOWED_STATE", "Cum Swallowed", oca.getOCum().cumSwallowed)
        AddTextOptionST("CUM_SPIT_STATE", "Cum Spit", oca.getOCum().cumSpit)
        AddTextOptionST("BELLY_CUM_STATE", "Cum in belly", oca.getOCum().GetBellyCumStorage(oca.playerref))
        AddTextOptionST("ADDICTION_POINTS_STATE", "Addiction Points", oca.addictionPoints)
        AddTextOptionST("TIME_SINCE_LAST_UPDATE_STATE", "Last belly update", oca.getOCum().GetNPCDataFloat(oca.playerref, "bellyCumTimeChecked"))
    EndIf
EndEvent

State DEBUG_MODE_STATE ;TOGGLE
    event OnSelectST()
        oca.debugMode = !oca.debugMode
        SetToggleOptionValueST(oca.debugMode)
    endEvent

    event OnDefaultST()
        oca.debugMode = False
        SetToggleOptionValueST(oca.debugMode)
    endEvent

    event OnHighlightST()
        SetInfoText("When enabled, debug messages will show in console and notifications.")
    EndEvent
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
            SetSliderOptionValueST(oca.TolerantThreshhold, "{1} ML")
        Else
            ShowMessage("Please make sure that the tolerance threshhold is greater than 0 and less than the dependence threshhold.", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        oca.TolerantThreshhold = 100.0
        SetSliderOptionValueST(oca.TolerantThreshhold, "{1} ML")
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
            SetSliderOptionValueST(oca.DependentThreshhold, "{1} ML")
        Else
            ShowMessage("Please make sure that the dependence threshhold is greater than the tolerance threshhold and less than the addict threshhold.", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        oca.DependentThreshhold = 200.0
        SetSliderOptionValueST(oca.DependentThreshhold, "{1} ML")
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
            SetSliderOptionValueST(oca.AddictThreshhold, "{1} ML")
        Else
            ShowMessage("Please make sure that the addict threshhold is greater than the dependence threshhold and less than the junkie threshhold.", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        oca.AddictThreshhold = 300.0
        SetSliderOptionValueST(oca.AddictThreshhold, "{1} ML")
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
            SetSliderOptionValueST(oca.JunkieThreshhold, "{1} ML")
        Else
            ShowMessage("Please make sure that the tolerance threshhold is greater than the addict threshhold.", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        oca.JunkieThreshhold = 400.0
        SetSliderOptionValueST(oca.JunkieThreshhold, "{1} ML")
    EndEvent

    Event OnHighlightST()
        SetInfoText("This is the threshhold after which you will have become a cum junkie.")
    EndEvent
EndState

State DIGEST_RATE_STATE ;SLIDER
    Event OnSliderOpenST()
        SetSliderDialogStartValue(oca.DigestRate)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 2.0)
		SetSliderDialogInterval(0.01)
    EndEvent

    Event OnSliderAcceptST(float option)
        oca.DigestRate = option
        SetSliderOptionValueST(oca.DigestRate, "{2} ML/HR")
    EndEvent

    Event OnDefaultST()
        oca.DigestRate = 1.0
        SetSliderOptionValueST(oca.DigestRate, "{2} ML/HR")
    EndEvent

    Event OnHighlightST()
        SetInfoText("This is the rate at which you will digest the cum in your belly and withdrawl will set in.\nHigh values can make it nearly impossible to get addicted,\nwhile low values can make it nearly impossible to recover.")
    EndEvent
EndState

State DECAY_RATE_STATE ;SLIDER
    Event OnSliderOpenST()
        SetSliderDialogStartValue(oca.DecayRate)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 2.0)
		SetSliderDialogInterval(0.01)
    EndEvent

    Event OnSliderAcceptST(float option)
        oca.DecayRate = option
        SetSliderOptionValueST(oca.DecayRate, "{2} ML/HR")
    EndEvent

    Event OnDefaultST()
        oca.DigestRate = 1.0
        SetSliderOptionValueST(oca.DecayRate, "{2} ML/HR")
    EndEvent

    Event OnHighlightST()
        SetInfoText("This is the rate at which your addiction to cum will dwindle relative to the amount of cum in your belly.\nHigh values can make it nearly impossible to get addicted,\nwhile low values can make it nearly impossible to recover.")
    EndEvent
EndState

State UPDATE_FREQUENCY_STATE ;SLIDER
    Event OnSliderOpenST()
        SetSliderDialogStartValue(oca.UpdateFreq)
		SetSliderDialogDefaultValue(120)
		SetSliderDialogRange(1, 300)
		SetSliderDialogInterval(1)
    EndEvent

    Event OnSliderAcceptST(float option)
        oca.UpdateFreq = option as int
        SetSliderOptionValueST(oca.UpdateFreq, "{0} Seconds")
    EndEvent

    Event OnDefaultST()
        oca.UpdateFreq = 120
        SetSliderOptionValueST(oca.UpdateFreq, "{0} Seconds")
    EndEvent

    Event OnHighlightST()
        SetInfoText("This is how often the game updates your addiction, withdrawl, and cum in stomach.\nLower values result in more script load, so don't set it too low.")
    EndEvent
EndState

;STATS PAGE
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

State BELLY_CUM_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("The amount of cum currently in your belly.")
    endEvent
EndState

State ADDICTION_POINTS_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("The number of addiction points you have accrued.")
    endEvent
EndState

State TIME_SINCE_LAST_UPDATE_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("The last time the belly cum volume was updated.")
    endEvent
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
        oca.DigestRate = JMap.GetFlt(ocaMCMSettings, "digestRate")
        oca.DecayRate = JMap.GetFlt(ocaMCMSettings, "decayRate")
        oca.debugMode = JMap.getInt(ocaMCMSettings, "debugMode") as Bool
        oca.UpdateFreq = JMap.getInt(ocaMCMSettings, "updateFreq")
        ForcePageReset()
    EndIf
EndFunction

Function ExportSettings()
    Int ocaMCMSettings = JMap.object()
    JMap.SetFlt(ocaMCMSettings, "tolerantThreshhold", oca.TolerantThreshhold)
    JMap.SetFlt(ocaMCMSettings, "dependentThreshhold", oca.DependentThreshhold)
    JMap.SetFlt(ocaMCMSettings, "addictThreshhold", oca.AddictThreshhold)
    JMap.SetFlt(ocaMCMSettings, "junkieThreshhold", oca.JunkieThreshhold)
    JMap.SetFlt(ocaMCMSettings, "digestRate", oca.DigestRate)
    JMap.SetFlt(ocaMCMSettings, "decayRate", oca.DecayRate)
    JMap.SetInt(ocaMCMSettings, "debugMode", oca.debugMode as Int)
    JMap.SetInt(ocaMCMSettings, "updateFreq", oca.UpdateFreq)
    
    Jvalue.WriteToFile(ocaMCMSettings, JContainers.UserDirectory() + "OcaMCMSettings.json")
    ForcePageReset()
EndFunction