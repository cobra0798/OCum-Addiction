scriptname OCumAddictionScript extends Quest Conditional

OSexIntegrationMain ostim
OCumAddictionMCM mcm
Actor playerref
Message cumMessageBox
Sound swallowing
Sound spitting
Spell UneffectedSpell
Spell TolerantSpell
Spell DependentSpell
Spell AddictSpell
Spell JunkieSpell
Bool Property hasBottles Auto Conditional

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
    playerref = Game.GetPlayer()
    hasBottles = False
    cumMessageBox = Game.GetFormFromFile(0x000801, "OCumAddiction.esp") as Message
    swallowing = Game.GetFormFromFile(0x000805, "OCumAddiction.esp") as Sound
    spitting = Game.GetFormFromFile(0x000807, "OCumAddiction.esp") as Sound

    UneffectedSpell = Game.GetFormFromFile(0x00080D, "OCumAddiction.esp") as Spell
    TolerantSpell = Game.GetFormFromFile(0x00080E, "OCumAddiction.esp") as Spell
    DependentSpell = Game.GetFormFromFile(0x000810, "OCumAddiction.esp") as Spell
    AddictSpell = Game.GetFormFromFile(0x000811, "OCumAddiction.esp") as Spell
    JunkieSpell = Game.GetFormFromFile(0x000812, "OCumAddiction.esp") as Spell
    UneffectedSpell.Cast(playerref)
    OnLoad()
EndEvent

Function OnLoad()
    console("OCA Registering events")
    RegisterForModEvent("ostim_prestart", "OnScenePreStart")
    RegisterForModEvent("ocum_cum", "OnEjaculation")
EndFunction

Event OnScenePreStart(string eventname, string strArg, float numArg, Form sender)
    console("OCA prestart event received")
    hasBottles = False
EndEvent

Event OnEjaculation(string eventname, string strArg, float cumAmount, Form sender)
    console("OCA ocum event received")
    console("OCA Cum ML = " + cumAmount)
    Actor sucker = ostim.GetSubActor()
    Int cumAction = getDefaultCumAction()
    String animType = ostim.GetCurrentAnimationClass()
    If cumAction == -1 ; If no default option was chosen
        console("OCA no default option was chosen.")
        If sucker == playerref && cumAmount > 0.0 && (animType == "BJ" || animType == "HhBJ" || animType == "AgBJ" || animType == "DBJ")
            cumAction = cumMessageBox.Show()
        Else
            console("OCA " + sucker.GetDisplayName() + " == playerref: " + (sucker == playerref))
            console("OCA " + cumAmount + " > 0.0: " + (cumAmount > 0.0))
            console("OCA animType is oral: " + (animType == "BJ" || animType == "HhBJ" || animType == "AgBJ" || animType == "DBJ"))
            console("OCA AnimType = " + animType)
        EndIf
    EndIf

    If cumAction == -1 ; no action was taken
        console("OCA no action was taken")
        return
    ElseIf cumAction > 1 && hasBottles ; bottle
        console("OCA Chose to bottle")
    ElseIf cumAction == 0 || cumAction == 2; spit, or swallow when no bottles
        console("OCA Chose to spit")
        Debug.Notification("You spit out their cum.")
        mcm.cumSpit += cumAmount
        ostim.PlaySound(sucker, spitting)
    ElseIf cumAction == 1 || cumAction == 3; swallow, or swallow when no bottles
        console("OCA Chose to swallow")
        Debug.Notification("You swallow every last drop of their load.")
        mcm.cumSwallowed += cumAmount
        updateAddictionSpells()
        ostim.PlaySound(sucker, swallowing)
    EndIf
EndEvent

;todo - spells should auto dispel when another one is applied instead of through this script
;todo - the spells need to update if the mcm settings are changed
;todo - the spells will need to update when decay is implemented and this func doesn't handle that
Function UpdateAddictionSpells()
    If playerref.HasMagicEffect(UneffectedSpell.GetNthEffectMagicEffect(0)) && mcm.cumSwallowed > mcm.TolerantThreshhold
        playerref.DispelSpell(UneffectedSpell)
        TolerantSpell.Cast(playerref)
    ElseIf playerref.HasMagicEffect(TolerantSpell.GetNthEffectMagicEffect(0)) && mcm.cumSwallowed > mcm.DependentThreshhold
        playerref.DispelSpell(TolerantSpell)
        DependentSpell.Cast(playerref)
    ElseIf playerref.HasMagicEffect(DependentSpell.GetNthEffectMagicEffect(0)) && mcm.cumSwallowed > mcm.AddictThreshhold
        playerref.DispelSpell(DependentSpell)
        AddictSpell.Cast(playerref)
    ElseIf playerref.HasMagicEffect(AddictSpell.GetNthEffectMagicEffect(0)) && mcm.cumSwallowed > mcm.JunkieThreshhold
        playerref.DispelSpell(AddictSpell)
        JunkieSpell.Cast(playerref)
    EndIf
EndFunction

Int Function GetDefaultCumAction()
    return mcm.cumAction - 1
EndFunction

Function console(String in)
    OSexIntegrationMain.Console(in)
EndFunction

Int Function GetVersion()
    return 1
EndFunction

; https://freesound.org/people/RuanZA/sounds/437480/ (FSwallowing - 1)
; https://freesound.org/people/anagar/sounds/267932/ (FSwallowing - 2)
; https://freesound.org/people/sagetyrtle/sounds/37226/ (MSwallowing - 1)
; https://freesound.org/people/bmcken/sounds/118193/ (spitting 1 and 2)