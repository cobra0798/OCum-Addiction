scriptname OCumAddictionMCM extends SKI_ConfigBase

OCumAddictionScript oca

String[] cumActionStrings
String[] pointsOfView

Event OnConfigInit()
    oca = (Self as Quest) as OCumAddictionScript
    pages = new String[2]
    pages[0] = "$oca_page_main"
    pages[1] = "$oca_page_stats"
    oca.TolerantThreshhold = 100.0
    oca.DependentThreshhold = 200.0
    oca.AddictThreshhold = 300.0
    oca.JunkieThreshhold = 400.0
    oca.DecayRate = 1.0
    oca.DigestRate = 1.0
    oca.UpdateFreq = 120

	cumActionStrings = new String[8]
	cumActionStrings[0] = "$oca_cum_action_none"
	cumActionStrings[1] = "$oca_cum_action_spit"
	cumActionStrings[2] = "$oca_cum_action_swallow"
	cumActionStrings[3] = "$oca_cum_action_random"
	cumActionStrings[4] = "$oca_cum_action_bottle_ask"
	cumActionStrings[5] = "$oca_cum_action_bottle_spit"
	cumActionStrings[6] = "$oca_cum_action_bottle_swallow"
	cumActionStrings[7] = "$oca_cum_action_bottle_random"
EndEvent

Event OnPageReset(string page)
    If (page == "main")
        SetCursorFillMode(TOP_TO_BOTTOM)
        AddMenuOptionST("CUM_ACTION_STATE", "$oca_cum_action", cumActionStrings[oca.autoCumAction])
        AddSliderOptionST("TOLERANT_THRESHHOLD_STATE", "$oca_tolerance_threshhold", oca.TolerantThreshhold, "{1} ML")
        AddSliderOptionST("DEPENDENT_THRESHHOLD_STATE", "$oca_dependence_threshhold", oca.DependentThreshhold, "{1} ML")
        AddSliderOptionST("ADDICT_THRESHHOLD_STATE", "$oca_addict_threshhold", oca.AddictThreshhold, "{1} ML")
        AddSliderOptionST("JUNKIE_THRESHHOLD_STATE", "$oca_junkie_threshhold", oca.JunkieThreshhold, "{1} ML")
        AddSliderOptionST("DIGEST_RATE_STATE", "$oca_digest_rate", oca.DigestRate, "{2} ML/HR")
        AddSliderOptionST("DECAY_RATE_STATE", "$oca_decay_rate", oca.DecayRate, "{2} ML/HR")
        AddSliderOptionST("UPDATE_FREQUENCY_STATE", "$oca_update_frequency", oca.UpdateFreq, "{0} Seconds")
        AddToggleOptionST("DEBUG_MODE_STATE", "$oca_enable_debug", oca.debugMode.GetValue())
        AddTextOptionST("IMPORT_STATE", "$oca_import_settings", "$oca_click")
        AddTextOptionST("EXPORT_STATE", "$oca_export_settings", "$oca_click")
    ElseIf(page == "stats")
        AddTextOptionST("CUM_SWALLOWED_STATE", "$oca_cum_swallowed", oca.GetTotalCumSwallowed(oca.playerref))
        AddTextOptionST("CUM_SPIT_STATE", "$oca_cum_spit", oca.GetTotalCumSpit(oca.playerref))
        AddTextOptionST("BELLY_CUM_STATE", "$oca_cum_belly", oca.GetBellyCumStorage(oca.playerref))
        AddTextOptionST("ADDICTION_POINTS_STATE", "$oca_addiction_points", oca.addictionPoints)
        AddTextOptionST("TIME_SINCE_LAST_UPDATE_STATE", "$oca_last_update", oca.getOCum().GetNPCDataFloat(oca.playerref, "bellyCumTimeChecked"))
    EndIf
EndEvent

State CUM_ACTION_STATE ;MENU

    event OnMenuOpenST()
        SetMenuDialogStartIndex(oca.autoCumAction)
        SetMenuDialogDefaultIndex(0)
        SetMenuDialogOptions(cumActionStrings)
    endEvent

    event OnMenuAcceptST(int a_index)
        oca.autoCumAction = a_index
        SetMenuOptionValueST(cumActionStrings[oca.autoCumAction])
    endEvent

    event OnDefaultST()
        oca.autoCumAction = 0    
        SetTextOptionValueST(cumActionStrings[oca.autoCumAction])
    endEvent

    event OnHighlightST()
        SetInfoText("$oca_tooltip_cum_action")
    endEvent
EndState

State DEBUG_MODE_STATE ;TOGGLE
    event OnSelectST()
        if oca.debugMode.GetValue() == 0
            oca.debugMode.SetValue(1)
        Else
            oca.debugMode.SetValue(0)
        EndIf
        SetToggleOptionValueST(oca.debugMode)
    endEvent

    event OnDefaultST()
        oca.debugMode.SetValue(0)
        SetToggleOptionValueST(oca.debugMode)
    endEvent

    event OnHighlightST()
        SetInfoText("$oca_tooltip_debug_mode")
    EndEvent
EndState

State IMPORT_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("$oca_tooltip_import_settings")
    endEvent

    event onSelectST()
        if ShowMessage("$oca_import_confirm", true)
            ImportSettings()
        endif
    endEvent
EndState

State EXPORT_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("$oca_tooltip_export_settings")
    endEvent

    event onSelectST()
        if ShowMessage("$oca_export_confirm", true)
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
            ShowMessage("$oca_tolerance_error", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        oca.TolerantThreshhold = 100.0
        SetSliderOptionValueST(oca.TolerantThreshhold, "{1} ML")
    EndEvent

    Event OnHighlightST()
        SetInfoText("$oca_tooltip_tolerance_threshhold")
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
            ShowMessage("$oca_dependence_error", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        oca.DependentThreshhold = 200.0
        SetSliderOptionValueST(oca.DependentThreshhold, "{1} ML")
    EndEvent

    Event OnHighlightST()
        SetInfoText("$oca_tooltip_dependence_threshhold")
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
            ShowMessage("$oca_addict_error", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        oca.AddictThreshhold = 300.0
        SetSliderOptionValueST(oca.AddictThreshhold, "{1} ML")
    EndEvent

    Event OnHighlightST()
        SetInfoText("$oca_tooltip_addict_threshhold")
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
            ShowMessage("$oca_junkie_error", False)
        EndIf
    EndEvent

    Event OnDefaultST()
        oca.JunkieThreshhold = 400.0
        SetSliderOptionValueST(oca.JunkieThreshhold, "{1} ML")
    EndEvent

    Event OnHighlightST()
        SetInfoText("$oca_tooltip_junkie_threshhold")
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
        SetInfoText("$oca_tooltip_digest_rate")
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
        SetInfoText("$oca_tooltip_decay_rate")
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
        SetInfoText("$oca_tooltip_update_frequency")
    EndEvent
EndState

;STATS PAGE
State CUM_SWALLOWED_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("$oca_tooltip_cum_swallowed")
    endEvent
EndState

State CUM_SPIT_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("$oca_tooltip_cum_spit")
    endEvent
EndState

State BELLY_CUM_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("$oca_tooltip_cum_belly")
    endEvent
EndState

State ADDICTION_POINTS_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("$oca_tooltip_addiction_points")
    endEvent
EndState

State TIME_SINCE_LAST_UPDATE_STATE ;TEXT
    event OnHighlightST()
        SetInfoText("$oca_tooltip_last_update")
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
        oca.autoCumAction = JMap.GetInt(ocaMCMSettings, "autoCumAction")
        oca.TolerantThreshhold = JMap.GetFlt(ocaMCMSettings, "tolerantThreshhold")
        oca.DependentThreshhold = JMap.GetFlt(ocaMCMSettings, "dependentThreshhold")
        oca.AddictThreshhold = JMap.GetFlt(ocaMCMSettings, "addictThreshhold")
        oca.JunkieThreshhold = JMap.GetFlt(ocaMCMSettings, "junkieThreshhold")
        oca.DigestRate = JMap.GetFlt(ocaMCMSettings, "digestRate")
        oca.DecayRate = JMap.GetFlt(ocaMCMSettings, "decayRate")
        oca.debugMode.SetValue(JMap.getInt(ocaMCMSettings, "debugMode"))
        oca.UpdateFreq = JMap.getInt(ocaMCMSettings, "updateFreq")
        ForcePageReset()
    EndIf
EndFunction

Function ExportSettings()
    Int ocaMCMSettings = JMap.object()
    JMap.SetInt(ocaMCMSettings, "autoCumAction", oca.autoCumAction)
    JMap.SetFlt(ocaMCMSettings, "tolerantThreshhold", oca.TolerantThreshhold)
    JMap.SetFlt(ocaMCMSettings, "dependentThreshhold", oca.DependentThreshhold)
    JMap.SetFlt(ocaMCMSettings, "addictThreshhold", oca.AddictThreshhold)
    JMap.SetFlt(ocaMCMSettings, "junkieThreshhold", oca.JunkieThreshhold)
    JMap.SetFlt(ocaMCMSettings, "digestRate", oca.DigestRate)
    JMap.SetFlt(ocaMCMSettings, "decayRate", oca.DecayRate)
    JMap.SetInt(ocaMCMSettings, "debugMode", oca.debugMode.GetValue() as Int)
    JMap.SetInt(ocaMCMSettings, "updateFreq", oca.UpdateFreq)
    
    Jvalue.WriteToFile(ocaMCMSettings, JContainers.UserDirectory() + "OcaMCMSettings.json")
    ForcePageReset()
EndFunction