ScriptName OCumAddictionPlayerAliasScript Extends ReferenceAlias

OCumAddictionScript Property oca Auto
Float clock

Event OnInit()
	oca = (GetOwningQuest()) as OCumAddictionScript
	clock = Utility.GetCurrentGameTime()
EndEvent

Event OnPlayerLoadGame()
	oca.onload()
	RegisterForSingleUpdate(oca.UpdateFreq)
EndEvent

Event OnUpdate()
	Float curTime = Utility.GetCurrentGameTime()
	oca.UpdateBelly(curTime - clock)
	oca.UpdateAddictionPoints(curTime - clock)
	clock = curTime
	RegisterForSingleUpdate(oca.UpdateFreq)
EndEvent