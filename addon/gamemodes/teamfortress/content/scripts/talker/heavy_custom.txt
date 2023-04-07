
criterion "WeaponIsFistsOfSteel" "item_name" "Fists of Steel" "required" weight 10

Response KilledPlayerSpecialMeleeHeavy
{
	scene "scenes/Player/Heavy/low/1941.vcd"
}
Rule KilledPlayerSpecialMeleeHeavy
{
	criteria ConceptKilledPlayer KilledPlayerDelay 10PercentChance WeaponIsFistsOfSteel HeavyNotKillSpeechMelee IsHeavy
	ApplyContext "HeavyKillSpeechMelee:1:10"
	applycontexttoworld
	Response KilledPlayerSpecialMeleeHeavy
}