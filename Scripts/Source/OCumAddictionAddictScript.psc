Scriptname OCumAddictionAddictScript extends OCumAddictionBaseEffect

Event OnEffectStart(Actor akTarget, Actor akCaster)
    EffectStart(akTarget, akCaster, "Addict")
EndEvent

Event OnUpdate()
    OUtils.Console("OCA: Addict tick")
    RegisterForSingleUpdate(10)
EndEvent

Function WithdrawlCumSatiated()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Addict Cum Satiated")
    EndIf
    StatChanges(0.0, 0.0, 0.0)
EndFunction

Function WithdrawalCumPeckish()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Addict Cum Peckish")
    EndIf
    StatChanges(-10.0, -10.0, -10.0)
EndFunction

Function WithdrawalCumHungry()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Addict Cum Hungry")
    EndIf
    StatChanges(-20.0, -20.0, -20.0)
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    WithdrawlCumSatiated()
EndEvent