Scriptname OCumAddictionJunkieScript extends OCumAddictionBaseEffect

Event OnEffectStart(Actor akTarget, Actor akCaster)
    EffectStart(akTarget, akCaster, "Junkie")
EndEvent

Event OnUpdate()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Junkie tick")
    EndIf
    RegisterForSingleUpdate(10)
EndEvent

Function WithdrawlCumSatiated()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Junkie Cum Satiated")
    EndIf
    StatChanges(0.0, 0.0, 0.0)
EndFunction

Function WithdrawalCumPeckish()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Junkie Cum Peckish")
    EndIf
    StatChanges(-10.0, -10.0, -10.0)
EndFunction

Function WithdrawalCumHungry()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Junkie Cum Hungry")
    EndIf
    StatChanges(-20.0, -20.0, -20.0)
EndFunction

Function WithdrawalCumStarved()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Junkie Cum Starved")
    EndIf
    StatChanges(-30.0, -30.0, -30.0)
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    WithdrawlCumSatiated()
EndEvent