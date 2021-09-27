scriptname OCumAddictionScript extends Quest Conditional

;properties
;0 None
;1 spit
;2 swallow
;3 bottle, spit otherwise
;4 bottle, swallow otherwise
Int Property autoCumAction Auto
    
Float Property cumSwallowed Auto
Float Property cumSpit Auto
Float Property TolerantThreshhold Auto
Float Property DependentThreshhold Auto
Float Property AddictThreshhold Auto
Float Property JunkieThreshhold Auto
Float Property DigestRate Auto
Float Property DecayRate Auto
Float Property timeLastSwallowed Auto
Float Property timeSinceLastUpdate Auto
Float Property bellyCum Auto
Float Property addictionPoints Auto
Int Property AddictionLevel Auto Conditional
Bool Property hasBottles Auto Conditional
Bool Property debugMode Auto

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
    playerref.AddSpell(UneffectedSpell, false)

    timeLastSwallowed = -1.0
    bellyCum = 0.0
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
    If debugMode
        console("OCA ocum event received")
        console("OCA Cum ML = " + cumAmount)
    EndIf
    Actor sucker = ostim.GetSubActor()
    Actor orgasmer = ostim.GetMostRecentOrgasmedActor()
    String animType = ostim.GetCurrentAnimationClass()
    Int cumAction = -1
    If autoCumAction == 0 ; If no default option was chosen
        if debugMode
            console("OCA no default option was chosen.")
        EndIf
        If sucker == playerref && cumAmount > 0.0 && (animType == "BJ" || animType == "HhBJ" || animType == "AgBJ" || animType == "DBJ")
            cumAction = cumMessageBox.Show()
        ElseIf debugMode
            console("OCA " + sucker.GetDisplayName() + " == playerref: " + (sucker == playerref))
            console("OCA " + cumAmount + " > 0.0: " + (cumAmount > 0.0))
            console("OCA animType is oral: " + (animType == "BJ" || animType == "HhBJ" || animType == "AgBJ" || animType == "DBJ"))
            console("OCA AnimType = " + animType)
        EndIf
    EndIf

    If autoCumAction == 0 && cumAction == -1 && debugMode; no action was taken
        console("OCA no action was taken")
        return
    ElseIf (autoCumAction > 2 && hasBottles) || cumAction == 2 && hasBottles ; bottle
        Bottle(cumAmount, sucker, orgasmer)
    ElseIf cumAction == 0 || autoCumAction == 1 || autoCumAction == 3; spit, or swallow when no bottles
        Spit(cumAmount, sucker, orgasmer)
    ElseIf cumAction == 1 || autoCumAction == 2 || autoCumAction == 4; swallow, or swallow when no bottles
        Swallow(cumAmount, sucker, orgasmer)
    EndIf
EndEvent

Function spit(Float cumAmount, Actor sucker, Actor orgasmer)
    If (debugMode)
        console("OCA Chose to spit")
    EndIf
    Debug.Notification("You spit out their cum.")
    cumSpit += cumAmount
    ostim.PlaySound(sucker, spitting)
EndFunction

Function Swallow(Float cumAmount, Actor sucker, Actor orgasmer)
    If debugMode
        console("OCA Chose to swallow")
    EndIf
    Debug.Notification("You swallow every last drop of their load.")
    cumSwallowed += cumAmount
    AdjustBelly(cumAmount)
    updateAddictionSpells()
    ostim.PlaySound(sucker, swallowing)
EndFunction

Function Bottle(Float cumAmount, Actor sucker, Actor orgasmer)
    If (debugMode)
        console("OCA Chose to bottle")
    EndIf
EndFunction

;todo - the spells need to update if the mcm settings are changed - handle OnOptionAccept for the mcm sliders
;todo - the spells will need to update when decay is implemented and this func doesn't handle that - handle when decay is calculated
Function UpdateAddictionSpells()
    If debugMode
        console("OCA Updating addiction spells")
    EndIf
    If playerref.HasMagicEffect(UneffectedSpell.GetNthEffectMagicEffect(0)) && cumSwallowed > TolerantThreshhold
        playerref.AddSpell(TolerantSpell)
    ElseIf playerref.HasMagicEffect(TolerantSpell.GetNthEffectMagicEffect(0)) && cumSwallowed > DependentThreshhold
        playerref.AddSpell(DependentSpell)
    ElseIf playerref.HasMagicEffect(DependentSpell.GetNthEffectMagicEffect(0)) && cumSwallowed > AddictThreshhold
        playerref.AddSpell(AddictSpell)
    ElseIf playerref.HasMagicEffect(AddictSpell.GetNthEffectMagicEffect(0)) && cumSwallowed > JunkieThreshhold
        playerref.AddSpell(JunkieSpell)
    EndIf
EndFunction

Function SetAddictionLevel()
    If (DebugMode)
        console("OCA Setting addiction level")
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
EndFunction

Function AdjustBelly(Float cumAmount)
    If (DebugMode)
        console("OCA Adding " + cumAmount + " to belly")
        console("OCA belly current volume = " + bellyCum)
    EndIf
    timeLastSwallowed = Utility.GetCurrentGameTime()
    UpdateBelly()
    bellyCum += cumAmount
    If (DebugMode)
        console("OCA belly new volume = " + bellyCum)
    EndIf
EndFunction

;todo - profile this to make sure it isn't laggy as fuck
Function UpdateBelly()
    If (DebugMode)
        console("OCA udating belly")
    EndIf
    If (bellyCum > 0)
        Float curTime = Utility.GetCurrentGameTime()
        Float digest = (curTime - timeSinceLastUpdate) * 24 * DigestRate ; flat starting rate per hr
        If (DebugMode)
            console("OCA curTime = " + curTime)
            console("OCA digest before addiction level = " + digest)
        EndIf
        SetAddictionLevel() 
        digest = digest * (1 + AddictionLevel / 2 - 1 / (AddictionLevel + 2)) ;50%, 117%, 175%, 230%, 284% as you become more addicted, you digest cum faster so it's harder to stave off withdrawl
        If (DebugMode)
            console("OCA addiction level = " + AddictionLevel)
            console("OCA digest after addiction level = " + digest)
        EndIf
        If (bellyCum < digest)
            bellyCum = 0
        Else
            bellyCum -= digest
        EndIf
        timeSinceLastUpdate = curTime
    EndIf
EndFunction

Function UpdateAddictionPoints(float timePassed)
    If (DebugMode)
        console("OCA updating addiction points")
    EndIf
    SetAddictionLevel()
    Float decay = timePassed * 24 * DecayRate
    decay = decay * (1 - (1 / (5 - AddictionLevel) + 1 / 5)) ;100%, 95%, 87%, 70%, 20%
    addictionPoints -= decay
    If (debugMode)
        console("decay before addiction level = " + (timePassed * 24 * DecayRate))
        console("decay after addiction level = " + decay)
    EndIf
    UpdateAddictionSpells()
EndFunction

Float Function timeSinceLastSwallowed()
    If timeLastSwallowed > 0
        return Utility.GetCurrentGameTime() - timeLastSwallowed
    Else
        return -1
    EndIf
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