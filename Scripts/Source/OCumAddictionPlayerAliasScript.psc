ScriptName OCumAddictionPlayerAliasScript Extends ReferenceAlias

OCumAddictionScript Property oca Auto
Float clock

Event OnInit()
	oca = (GetOwningQuest()) as OCumAddictionScript
	clock = -1.0
EndEvent

Event OnPlayerLoadGame()
	If (clock < 0)
		clock = Utility.GetCurrentGameTime()
	EndIf
	oca.onload()
	RegisterForSingleUpdate(oca.UpdateFreq)
EndEvent

Event OnUpdate()
	Float curTime = Utility.GetCurrentGameTime()
	oca.UpdateBelly(curTime - clock, self.GetActorReference())
	oca.UpdateAddictionPoints(curTime - clock)
	clock = curTime
	RegisterForSingleUpdate(oca.UpdateFreq)
EndEvent