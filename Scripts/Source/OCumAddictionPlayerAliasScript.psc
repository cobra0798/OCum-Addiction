ScriptName OCumAddictionPlayerAliasScript Extends ReferenceAlias

OCumAddictionScript Property OCumAddiction Auto

Event OnInit()
	OCumAddiction = (GetOwningQuest()) as OCumAddictionScript
EndEvent

Event OnPlayerLoadGame()
	OCumAddiction.onload()
EndEvent