Scriptname OCumAddictionUneffectedScript extends OCumAddictionBaseEffect

Event OnEffectStart(Actor akTarget, Actor akCaster)
    EffectStart(akTarget, akCaster, "Uneffected")
EndEvent

Event OnUpdate()
    OUtils.Console("OCA: Uneffected tick")
    RegisterForSingleUpdate(10)
EndEvent

Function WithdrawlCumSatiated()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Uneffected Cum Satiated")
    EndIf
    StatChanges(0.0, 0.0, 0.0)
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    WithdrawlCumSatiated()
EndEvent