scriptname OCumAddictionScript extends Quest Conditional

Float Property TolerantThreshhold Auto
Float Property DependentThreshhold Auto
Float Property AddictThreshhold Auto
Float Property JunkieThreshhold Auto
Float Property DigestRate Auto
Float Property DecayRate Auto
Float Property addictionPoints Auto
Int Property AddictionLevel Auto Conditional
Bool Property debugMode Auto
Int Property UpdateFreq Auto
Actor Property playerref Auto

OSexIntegrationMain ostim
OCumAddictionMCM mcm
OCumScript ocum
Spell UneffectedSpell
Spell TolerantSpell
Spell DependentSpell
Spell AddictSpell
Spell JunkieSpell

Event OnInit()
    Debug.Notification("OCum - Addiction installed")
    ;requirements check
    If Game.GetModByName("OStim.esp") == 255
        Debug.MessageBox("OStim is not installed. Please check to make sure you have enabled it in your mod organizer.")
    Else
        ostim = Game.GetFormFromFile(0x000801, "OStim.esp") as OSexIntegrationMain
        If ostim.GetAPIVersion() < 23
            Debug.MessageBox("Your ostim is out of date. Please get the latest update.")
        EndIf
    EndIf
    If Game.GetModByName("OCum.esp") == 255
        Debug.MessageBox("OCum is not installed. Please check to make sure you have enabled it in your mod organizer.")
    EndIf
    console("OCum - Addiction installed")

    mcm = (self as Quest) as OCumAddictionMCM
    ocum = Game.GetFormFromFile(0x000800, "OCum.esp") as OCumScript
    playerref = Game.GetPlayer()

    UneffectedSpell = Game.GetFormFromFile(0x00080D, "OCumAddiction.esp") as Spell
    TolerantSpell = Game.GetFormFromFile(0x00080E, "OCumAddiction.esp") as Spell
    DependentSpell = Game.GetFormFromFile(0x000810, "OCumAddiction.esp") as Spell
    AddictSpell = Game.GetFormFromFile(0x000811, "OCumAddiction.esp") as Spell
    JunkieSpell = Game.GetFormFromFile(0x000812, "OCumAddiction.esp") as Spell
    playerref.AddSpell(UneffectedSpell, false)
    OnLoad()
EndEvent

Function OnLoad()
    console("Registering events")
    RegisterForModEvent("ocum_swallow", "Swallow")
EndFunction

Event Swallow(Float cumAmount, Actor sucker, Actor orgasmer)
    updateAddictionSpells()
EndEvent

Function UpdateAddictionSpells()
    If debugMode
        console("Updating addiction spells")
    EndIf
    If playerref.HasMagicEffect(UneffectedSpell.GetNthEffectMagicEffect(0)) && addictionPoints >= TolerantThreshhold && addictionPoints < DependentThreshhold
        playerref.AddSpell(TolerantSpell)
    ElseIf playerref.HasMagicEffect(TolerantSpell.GetNthEffectMagicEffect(0)) && addictionPoints >= DependentThreshhold && addictionPoints < AddictThreshhold
        playerref.AddSpell(DependentSpell)
    ElseIf playerref.HasMagicEffect(DependentSpell.GetNthEffectMagicEffect(0)) && addictionPoints >= AddictThreshhold && addictionPoints < JunkieThreshhold
        playerref.AddSpell(AddictSpell)
    ElseIf playerref.HasMagicEffect(AddictSpell.GetNthEffectMagicEffect(0)) && addictionPoints >= JunkieThreshhold
        playerref.AddSpell(JunkieSpell)
    EndIf
EndFunction

Function SetAddictionLevel()
    If (DebugMode)
        console("Setting addiction level")
        console("addiction points = " + addictionPoints)
    EndIf
    If (addictionPoints < TolerantThreshhold)
        AddictionLevel = 0
    ElseIf (addictionPoints >= TolerantThreshhold && addictionPoints < DependentThreshhold)
        AddictionLevel = 1
    ElseIf (addictionPoints >= DependentThreshhold && addictionPoints < AddictThreshhold)
        AddictionLevel = 2
    ElseIf (addictionPoints >= AddictThreshhold && addictionPoints < JunkieThreshhold)
        AddictionLevel = 3
    ElseIf (addictionPoints >= JunkieThreshhold)
        AddictionLevel = 4
    EndIf
    If (DigestRate > 0)
        StorageUtil.SetFloatValue(none, "ocum.digestRate", AddictionLevel * DigestRate)
    else
        StorageUtil.SetFloatValue(none, "ocum.digestRate", AddictionLevel)
    EndIf
EndFunction

Function UpdateAddictionPoints(float timePassed)
    If (DebugMode)
        console("updating addiction points")
    EndIf
    Float decay = timePassed * 24
    decay = decay * ((4 - AddictionLevel) / (5 - AddictionLevel) + 1 / 5) * DecayRate - decay * (ocum.GetBellyCumStorage(playerref) / ocum.getBellyMax(playerref)) * 2
    if decay <= addictionPoints
        addictionPoints -= decay
    Else
        addictionPoints = 0.0
    EndIf
    SetAddictionLevel()
    If (debugMode)
        console("decay before addiction level = " + (timePassed * 24 * DecayRate))
        console("decay after addiction level = " + decay)
    EndIf
    UpdateAddictionSpells()
EndFunction

OCumScript Function getOCum()
    return ocum
EndFunction

Function console(String in)
    OSexIntegrationMain.Console("OCA: " + in)
EndFunction

Int Function GetVersion()
    return 1
EndFunction

; https://freesound.org/people/RuanZA/sounds/437480/ (FSwallowing - 1)
; https://freesound.org/people/anagar/sounds/267932/ (FSwallowing - 2)
; https://freesound.org/people/sagetyrtle/sounds/37226/ (MSwallowing - 1)
; https://freesound.org/people/bmcken/sounds/118193/ (spitting 1 and 2)