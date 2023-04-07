
Response KilledPlayerSpecialMeleeDemoman
{
	scene "scenes/Player/Demoman/low/3564.vcd"
	scene "scenes/Player/Demoman/low/3565.vcd"
}
Rule KilledPlayerSpecialMeleeDemoman
{
	criteria ConceptKilledPlayer KilledPlayerDelay 30PercentChance WeaponIsSword DemomanNotKillSpeechMelee IsDemoman
	ApplyContext "DemomanKillSpeechMelee:1:10"
	applycontexttoworld
	Response KilledPlayerSpecialMeleeDemoman
}