ScriptName OCumAddictionPlayerAliasScript Extends ReferenceAlias

OCumAddictionScript Property OCumAddiction Auto
Float clock

Event OnInit()
	OCumAddiction = (GetOwningQuest()) as OCumAddictionScript
	clock = Utility.GetCurrentGameTime()
EndEvent

Event OnPlayerLoadGame()
	OCumAddiction.onload()
	RegisterForSingleUpdate(120)
EndEvent

Event OnUpdate()
	Float curTime = Utility.GetCurrentGameTime()
	OCumAddiction.UpdateAddictionPoints(curTime)
	clock = curTime
	RegisterForSingleUpdate(120)
EndEvent