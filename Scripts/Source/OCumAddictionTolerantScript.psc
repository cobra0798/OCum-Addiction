Scriptname OCumAddictionTolerantScript extends OCumAddictionBaseEffect

Event OnEffectStart(Actor akTarget, Actor akCaster)
    EffectStart(akTarget, akCaster, "Tolerant")
EndEvent

Event OnUpdate()
    OUtils.Console("OCA: Tolerant tick")
    RegisterForSingleUpdate(10)
EndEvent

Function WithdrawlCumSatiated()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Tolerant Cum Satiated")
    EndIf
    StatChanges(0.0, 0.0, 0.0)
EndFunction

Function WithdrawalCumPeckish()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Tolerant Cum Peckish")
    EndIf
    StatChanges(-5.0, -5.0, -5.0)
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    WithdrawlCumSatiated()
EndEvent