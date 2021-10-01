Scriptname OCumAddictionBaseEffect extends ActiveMagicEffect

GlobalVariable Property debugMode Auto
OCumScript Property ocum Auto
Actor Property target Auto
Float Property HealthModAV Auto
Float Property StaminaModAV Auto
Float Property MagickaModAV Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    EffectStart(akTarget, akCaster)
EndEvent

Function EffectStart(Actor akTarget, Actor akCaster, String effect = "Base")
    If debugMode.GetValue() == 1
        OUtils.Console("OCA: " + effect + " start")
    EndIf
    RegisterForSingleUpdate(10)
    If (akTarget)
        target = akTarget
    Else
        target = akCaster
    EndIf
    HealthModAV = 0.0
    StaminaModAV = 0.0
    MagickaModAV = 0.0
EndFunction

Function StatChanges(float hp, float sp, float mp)
    target.ModAV("Health", Math.abs(HealthModAV) + hp)
    target.ModAV("Stamina", Math.abs(StaminaModAV) + sp)
    target.ModAV("Magicka", Math.abs(MagickaModAV) + mp)
    HealthModAV = hp
    StaminaModAV = sp
    MagickaModAV = mp
EndFunction