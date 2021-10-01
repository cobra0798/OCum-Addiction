Scriptname OCumAddictionDependentScript extends OCumAddictionBaseEffect

Event OnEffectStart(Actor akTarget, Actor akCaster)
    EffectStart(akTarget, akCaster, "Dependent")
EndEvent

Event OnUpdate()
    OUtils.Console("OCA: Dependent tick")
    RegisterForSingleUpdate(10)
EndEvent

Function WithdrawlCumSatiated()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Dependent Cum Satiated")
    EndIf
    StatChanges(0.0, 0.0, 0.0)
EndFunction

Function WithdrawalCumPeckish()
    If (debugMode.GetValue() == 1)
        OUtils.Console("OCA: Dependent Cum Peckish")
    EndIf
    StatChanges(-10.0, -10.0, -10.0)
EndFunction

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    WithdrawlCumSatiated()
EndEvent