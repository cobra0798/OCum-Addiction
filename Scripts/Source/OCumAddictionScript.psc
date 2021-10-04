scriptname OCumAddictionScript extends Quest Conditional

Float Property TolerantThreshhold Auto
Float Property DependentThreshhold Auto
Float Property AddictThreshhold Auto
Float Property JunkieThreshhold Auto

Float Property digestRate ;modifies digestion rate. Intended to be modified by other mods.
	float Function Get()
		return StorageUtil.GetFloatValue(none, "ocum.digestRate", 0.0)
	EndFunction

	Function Set(Float val)
		StorageUtil.SetFloatValue(none, "ocum.digestRate", val)
	EndFunction
endProperty

Int Property autoCumAction
	int Function Get()
		return StorageUtil.GetIntValue(none, "ocum.cumaction", 2)
	EndFunction

	Function Set(int val)
		StorageUtil.SetIntValue(none, "ocum.cumaction", val)
	EndFunction
endProperty

Float Property DecayRate Auto
Float Property addictionPoints Auto
Int Property AddictionLevel Auto Conditional
Int Property WithdrawalLevel Auto Conditional
Bool Property hasBottles Auto Conditional
GlobalVariable Property debugMode Auto
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
Message cumMessageBox
Sound swallowing
Sound spitting
int bottleRefId

string bellyCumTimeCheckedKey
string maxBellyCumKey
string bellyCumKey
string cumSpitKey
string cumSwallowedKey

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
    debugMode = Game.GetFormFromFile(0x000814, "OCumAddiction.esp") as GlobalVariable
    cumMessageBox = Game.GetFormFromFile(0x000801, "OCumAddiction.esp") as Message
    swallowing = Game.GetFormFromFile(0x000804, "OCumAddiction.esp") as Sound
    spitting = Game.GetFormFromFile(0x000805, "OCumAddiction.esp") as Sound

	maxBellyCumKey = "MaxBellyCumVolume"
	bellyCumKey = "BellyCumVolume"
	bellyCumTimeCheckedKey = "bellyCumTimeChecked"
    cumSpitKey = "cumSpit"
    cumSwallowedKey = "cumSwallowed"

    playerref.AddSpell(UneffectedSpell, false)
    OnLoad()
EndEvent

Function OnLoad()
    console("Registering events")
    RegisterForModEvent("ocum_cumoral", "OnEjaculation")
    RegisterForModEvent("ostim_prestart", "OStimPreStart")
EndFunction

Event OStimPreStart(string eventname, string strArg, float numArg, Form sender)
	Debug.StartStackProfiling()
    console("prestart event received")
	Bool rndInstalled = ostim.IsModLoaded("RealisticNeedsandDiseases.esp")
	If (!rndInstalled)
    	hasBottles = False
	Else
		if rndInstalled
			If (playerRef.GetItemCount(Game.GetFormFromFile(0x0043B0, "RealisticNeedsandDiseases.esp")))
				console("player has RND_EmptyBottle01")
				hasBottles = True
				bottleRefId = 0x0043B0
				Debug.StopStackProfiling()
				return
			ElseIf (playerRef.GetItemCount(Game.GetFormFromFile(0x0043B2, "RealisticNeedsandDiseases.esp")))
				console("player has RND_EmptyBottle02")
				hasBottles = True
				bottleRefId = 0x0043B2
				Debug.StopStackProfiling()
				return
			ElseIf (playerRef.GetItemCount(Game.GetFormFromFile(0x0043B4, "RealisticNeedsandDiseases.esp")))
				console("player has RND_EmptyBottle03")
				hasBottles = True
				bottleRefId = 0x0043B4
				Debug.StopStackProfiling()
				return
			EndIf
		EndIf
		If (playerRef.GetItemCount(Game.GetFormFromFile(0x0F2012, "Skyrim.esm")))
			console("player has WineBottle01AEmpty")
			hasBottles = True
			bottleRefId = 0x0F2012
			Debug.StopStackProfiling()
			return
		ElseIf (playerRef.GetItemCount(Game.GetFormFromFile(0x0F2013, "Skyrim.esm")))
			console("player has WineBottle01BEmpty")
			hasBottles = True
			bottleRefId = 0x0F2013
			Debug.StopStackProfiling()
			return
		ElseIf (playerRef.GetItemCount(Game.GetFormFromFile(0x0F2014, "Skyrim.esm")))
			console("player has WineBottle02AEmpty")
			hasBottles = True
			bottleRefId = 0x0F2014
			Debug.StopStackProfiling()
			return
		ElseIf (playerRef.GetItemCount(Game.GetFormFromFile(0x0F2015, "Skyrim.esm")))
			console("player has WineBottle02BEmpty")
			hasBottles = True
			bottleRefId = 0x0F2015
			Debug.StopStackProfiling()
			return
		ElseIf (playerRef.GetItemCount(Game.GetFormFromFile(0x0FED17, "Skyrim.esm")))
			console("player has WineSolitudeSpicedBottleEmpty")
			hasBottles = True
			bottleRefId = 0x0FED17
			Debug.StopStackProfiling()
			return
		EndIf
		hasBottles = False
		Debug.StopStackProfiling()
		return
	EndIf
EndEvent

Event OnEjaculation(string eventName, string strArg, float cumAmount, Form sender)
    Actor orgasmer = ostim.GetMostRecentOrgasmedActor()
    Actor partner = ostim.GetSexPartner(orgasmer)
    If (partner == playerref)
        oralCumAction(CumAmount, partner, orgasmer)
    else
        RandomCumAction(CumAmount, partner, orgasmer)
    EndIf
EndEvent

Function UpdateAddictionSpells()
    If debugMode.GetValue() == 1
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
    If (DebugMode.GetValue() == 1)
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
    If (DebugMode.GetValue() == 1)
        console("updating addiction points")
    EndIf
    Float decay = timePassed * 24
    decay = decay * ((4 - AddictionLevel) / (5 - AddictionLevel) + 1 / 5) * DecayRate - decay * (GetBellyCumStorage(playerref) / getBellyMax(playerref)) * 2
    if decay <= addictionPoints
        addictionPoints -= decay
    Else
        addictionPoints = 0.0
    EndIf
    SetAddictionLevel()
    If (debugMode.GetValue() == 1)
        console("decay before addiction level = " + (timePassed * 24 * DecayRate))
        console("decay after addiction level = " + decay)
    EndIf
    UpdateAddictionSpells()
EndFunction

;cum actions

Function spit(Float cumAmount, Actor sucker, Actor orgasmer)
	SendModEvent("ocum_spit", numArg = cumAmount)
    console("Chose to spit")
    Debug.Notification("You spit out their cum.")
	If (sucker == playerref)
    	ocum.StoreNPCDataFloat(sucker, cumSpitKey, ocum.GetNPCDataFloat(sucker, cumSpitKey) + cumAmount)
	EndIf
    ostim.PlaySound(sucker, spitting)
EndFunction

Function Swallow(Float cumAmount, Actor sucker, Actor orgasmer)
	SendModEvent("ocum_swallow", numArg = cumAmount)
    console("Chose to swallow")
    Debug.Notification("You swallow every last drop of their load.")
    ocum.StoreNPCDataFloat(sucker, cumSwallowedKey, ocum.GetNPCDataFloat(sucker, cumSwallowedKey) + cumAmount)
	AdjustBelly(cumAmount, sucker)
    ostim.PlaySound(sucker, swallowing)
EndFunction

Function Bottle(Float cumAmount, Actor sucker, Actor orgasmer)
	SendModEvent("ocum_bottle", numArg = cumAmount)
	console("Chose to bottle")
EndFunction

Function RandomCumAction(Float cumAmount, Actor sucker, Actor orgasmer)
	bool option = OSANative.RandomInt(0, 1) as bool
	if option
		spit(cumAmount, sucker, orgasmer)
	else
		Swallow(cumAmount, sucker, orgasmer)
	endIf
EndFunction

Function oralCumAction(Float cumAmount, Actor sucker, Actor orgasmer)
	Int cumAction = -1
    If autoCumAction == 0 || autoCumAction == 4 && !hasBottles ; If no default option was chosen
        cumAction = cumMessageBox.Show()
    EndIf

    If autoCumAction == 0 && cumAction == -1; no action was taken
        console("no action was taken")
        return
	ElseIf autoCumAction == 3 || autoCumAction == 7 && !hasBottles
		RandomCumAction(cumAmount, sucker, orgasmer)
    ElseIf (autoCumAction > 3 || cumAction == 2) && hasBottles ; bottle
        Bottle(cumAmount, sucker, orgasmer)
    ElseIf cumAction == 0 || autoCumAction == 1 || autoCumAction == 5; spit, or swallow when no bottles
        Spit(cumAmount, sucker, orgasmer)
    ElseIf cumAction == 1 || autoCumAction == 2 || autoCumAction == 6; swallow, or swallow when no bottles
        Swallow(cumAmount, sucker, orgasmer)
    EndIf
EndFunction

Float Function GetTotalCumSpit(Actor npc)
    return ocum.GetNPCDataFloat(npc, cumSpitKey)
EndFunction

Float Function GetTotalCumSwallowed(Actor npc)
    return ocum.GetNPCDataFloat(npc, cumSwallowedKey)
EndFunction

;belly funcs
float Function GetBellyCumStorage(actor npc)
	float bellyCum = ocum.GetNPCDataFloat(npc, bellyCumKey)
	If bellyCum < 0 ;never calculated
		bellyCum = 0.0
		ocum.StoreNPCDataFloat(npc, bellyCumKey, bellyCum)
	EndIf
	return bellyCum
EndFunction

Float Function getBellyMax(Actor akActor)
    float max = ocum.GetNPCDataFloat(akActor, maxBellyCumKey)
    if (max != -1)
        return max 
    else
        max = OSANative.RandomFloat(15, 56) * 0.75
        ocum.StoreNPCDataFloat(akactor, maxBellyCumKey, max)
        return max
    EndIf
EndFunction

Function AdjustBelly(Float cumAmount, Actor akActor)
	Float bellyCum = GetBellyCumStorage(akActor)
	Float timeSinceLastUpdate = ocum.GetNPCDataFloat(akActor, bellyCumTimeCheckedKey)
    console("Adding " + cumAmount + " to belly")
    console("belly current volume = " + bellyCum)

	Float curTime = Utility.GetCurrentGameTime()
    If timeSinceLastUpdate >= 0
        UpdateBelly(curTime - timeSinceLastUpdate, akActor)
    Else
        UpdateBelly(0, akActor)
    EndIf
    ocum.StoreNPCDataFloat(akActor, bellyCumTimeCheckedKey, curTime)
    float max = getBellyMax(playerref)
    If (bellyCum + cumAmount > max)
        bellyCum = max
        console("cumAmount went over max")
        console("cumAmount = " + cumAmount)
        console("bellyCum = " + bellyCum)
        console("max = " + max)
    Else
        bellyCum += cumAmount
    EndIf
    console("belly new volume = " + bellyCum)
	ocum.StoreNPCDataFloat(akActor, bellyCumKey, bellyCum)
EndFunction

;todo - profile this to make sure it isn't laggy as fuck
Function UpdateBelly(float timePassed, Actor akActor)
    console("udating belly")
	Float bellyCum = GetBellyCumStorage(akActor)
    If (bellyCum > 0)
        Float digest = timePassed * 24 ; flat starting rate per hr
        digest = digest * (1 + digestRate / 4 - 1 / (digestRate + 2))
        If (bellyCum < digest)
            bellyCum = 0
        Else
            bellyCum -= digest
        EndIf
    EndIf
	ocum.StoreNPCDataFloat(akActor, bellyCumKey, bellyCum)
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