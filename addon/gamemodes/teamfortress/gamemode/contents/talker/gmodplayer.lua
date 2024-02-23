
//--------------------------------------------------------------------------------------------------------------
// Auto Speech Pain
//--------------------------------------------------------------------------------------------------------------
Response PlayerAttackerPainGmodplayer
{
	scene "scenes/npc/male01/ow01.vcd"
	scene "scenes/npc/male01/ow02.vcd"
	scene "scenes/npc/male01/no01.vcd"
	scene "scenes/npc/male01/no02.vcd"
	scene "scenes/npc/male01/mygut01.vcd"
	scene "scenes/npc/male01/mygut02.vcd"
	scene "scenes/npc/male01/hitingut01.vcd"
	scene "scenes/npc/male01/hitingut02.vcd"
}
Rule PlayerAttackerPainGmodplayer
{
	criteria ConceptAttackerPain IsGmodplayer
	Response PlayerAttackerPainGmodplayer
}

Response PlayerOnFireGmodplayer
{
	scene "scenes/npc/male01/ow01.vcd"
	scene "scenes/npc/male01/no01.vcd"
	scene "scenes/npc/male01/no02.vcd"
}
Rule PlayerOnFireGmodplayer
{
	criteria ConceptFire IsGmodplayer GmodplayerIsNotStillonFire
	ApplyContext "GmodplayerOnFire:1:7"
	Response PlayerOnFireGmodplayer
}

Response PlayerOnFireRareGmodplayer
{
	scene "scenes/npc/male01/ow01.vcd"
	scene "scenes/npc/male01/no01.vcd"
	scene "scenes/npc/male01/no02.vcd"
}
Rule PlayerOnFireRareGmodplayer
{
	criteria ConceptFire IsGmodplayer 10PercentChance GmodplayerIsNotStillonFire
	ApplyContext "GmodplayerOnFire:1:7"
	Response PlayerOnFireRareGmodplayer
}

Response PlayerPainGmodplayer
{
	scene "scenes/npc/male01/ow01.vcd"
	scene "scenes/npc/male01/ow02.vcd"
	scene "scenes/npc/male01/imhurt01.vcd"
	scene "scenes/npc/male01/imhurt02.vcd"
	scene "scenes/npc/male01/mygut01.vcd"
	scene "scenes/npc/male01/mygut02.vcd"
	scene "scenes/npc/male01/hitingut01.vcd"
	scene "scenes/npc/male01/hitingut02.vcd"
	scene "scenes/npc/male01/myleg01.vcd"
	scene "scenes/npc/male01/myleg02.vcd"
	scene "scenes/npc/male01/myarm01.vcd"
	scene "scenes/npc/male01/myarm02.vcd" 
}
Rule PlayerPainGmodplayer
{
	criteria ConceptPain IsGmodplayer
	Response PlayerPainGmodplayer
}

Response PlayerStillOnFireGmodplayer
{
	scene "scenes/npc/male01/ow01.vcd"
	scene "scenes/npc/male01/no01.vcd"
	scene "scenes/npc/male01/no02.vcd"
}
Rule PlayerStillOnFireGmodplayer
{
	criteria ConceptFire IsGmodplayer  GmodplayerIsStillonFire
	ApplyContext "GmodplayerOnFire:1:7"
	Response PlayerStillOnFireGmodplayer
}