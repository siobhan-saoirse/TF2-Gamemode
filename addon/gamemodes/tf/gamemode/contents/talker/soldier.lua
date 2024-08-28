//--------------------------------------------------------------------------------------------------------------
// Soldier Response Rule File
//--------------------------------------------------------------------------------------------------------------

Criterion "SoldierIsKillSpeechObject" "SoldierKillSpeechObject" "1" "required" weight 0
Criterion "SoldierIsNotStillonFire" "SoldierOnFire" "!=1" "required" weight 0
Criterion "SoldierIsStillonFire" "SoldierOnFire" "1" "required" weight 0
Criterion "SoldierNotKillSpeech" "SoldierKillSpeech" "!=1" "required" weight 0
Criterion "SoldierNotKillSpeechMelee" "SoldierKillSpeechMelee" "!=1" "required" weight 0
Criterion "SoldierNotSaidHealThanks" "SoldierSaidHealThanks" "!=1" "required"
Criterion "IsHelpCapSoldier" "SoldierHelpCap" "1" "required" weight 0

Response SoldierJarateHit
{
	scene "scenes/Player/Soldier/low/1051.vcd"
	scene "scenes/Player/Soldier/low/1155.vcd"
	scene "scenes/Player/Soldier/low/1353.vcd"
	scene "scenes/Player/Soldier/low/1152.vcd"
}
Rule SoldierJarateHit
{
	criteria ConceptJarateHit IsSoldier 50PercentChance
	Response SoldierJarateHit
}


Response PlayerCloakedSpyDemomanSoldier
{
	scene "scenes/Player/Soldier/low/1082.vcd" 
}
Rule PlayerCloakedSpyDemomanSoldier
{
	criteria ConceptPlayerCloakedSpy IsSoldier IsOnDemoman
	Response PlayerCloakedSpyDemomanSoldier
}

Response PlayerCloakedSpyEngineerSoldier
{
	scene "scenes/Player/Soldier/low/1087.vcd" 
}
Rule PlayerCloakedSpyEngineerSoldier
{
	criteria ConceptPlayerCloakedSpy IsSoldier IsOnEngineer
	Response PlayerCloakedSpyEngineerSoldier
}

Response PlayerCloakedSpyHeavySoldier
{
	scene "scenes/Player/Soldier/low/1077.vcd" 
}
Rule PlayerCloakedSpyHeavySoldier
{
	criteria ConceptPlayerCloakedSpy IsSoldier IsOnHeavy
	Response PlayerCloakedSpyHeavySoldier
}

Response PlayerCloakedSpyMedicSoldier
{
	scene "scenes/Player/Soldier/low/1085.vcd" 
}
Rule PlayerCloakedSpyMedicSoldier
{
	criteria ConceptPlayerCloakedSpy IsSoldier IsOnMedic
	Response PlayerCloakedSpyMedicSoldier
}

Response PlayerCloakedSpyPyroSoldier
{
	scene "scenes/Player/Soldier/low/1080.vcd" 
}
Rule PlayerCloakedSpyPyroSoldier
{
	criteria ConceptPlayerCloakedSpy IsSoldier IsOnPyro
	Response PlayerCloakedSpyPyroSoldier
}

Response PlayerCloakedSpyScoutSoldier
{
	scene "scenes/Player/Soldier/low/1074.vcd" 
}
Rule PlayerCloakedSpyScoutSoldier
{
	criteria ConceptPlayerCloakedSpy IsSoldier IsOnScout
	Response PlayerCloakedSpyScoutSoldier
}

Response PlayerCloakedSpySniperSoldier
{
	scene "scenes/Player/Soldier/low/1090.vcd" 
}
Rule PlayerCloakedSpySniperSoldier
{
	criteria ConceptPlayerCloakedSpy IsSoldier IsOnSniper
	Response PlayerCloakedSpySniperSoldier
}

Response PlayerCloakedSpySoldierSoldier
{
	scene "scenes/Player/Soldier/low/1075.vcd" 
}
Rule PlayerCloakedSpySoldierSoldier
{
	criteria ConceptPlayerCloakedSpy IsSoldier IsOnSoldier
	Response PlayerCloakedSpySoldierSoldier
}

Response PlayerCloakedSpySpySoldier
{
	scene "scenes/Player/Soldier/low/1083.vcd" 
}
Rule PlayerCloakedSpySpySoldier
{
	criteria ConceptPlayerCloakedSpy IsSoldier IsOnSpy
	Response PlayerCloakedSpySpySoldier
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech
//--------------------------------------------------------------------------------------------------------------
Response HealThanksSoldier
{
	scene "scenes/Player/Soldier/low/1213.vcd" 
	scene "scenes/Player/Soldier/low/1214.vcd" 
	scene "scenes/Player/Soldier/low/1215.vcd" 
}
Rule HealThanksSoldier
{
	criteria ConceptMedicChargeStopped IsSoldier SuperHighHealthContext SoldierNotSaidHealThanks 50PercentChance
	ApplyContext "SoldierSaidHealThanks:1:20"
	Response HealThanksSoldier
}

Response PlayerRoundStartSoldier
{
	scene "scenes/Player/Soldier/low/1055.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Soldier/low/1057.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Soldier/low/1058.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Soldier/low/1059.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Soldier/low/1056.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Soldier/low/1060.vcd" predelay "1.0, 5.0"
}
Rule PlayerRoundStartSoldier
{
	criteria ConceptPlayerRoundStart IsSoldier
	Response PlayerRoundStartSoldier
}

Response PlayerCappedIntelligenceSoldier
{
	scene "scenes/Player/Soldier/low/1046.vcd" 
	scene "scenes/Player/Soldier/low/1048.vcd" 
	scene "scenes/Player/Soldier/low/1047.vcd" 
}
Rule PlayerCappedIntelligenceSoldier
{
	criteria ConceptPlayerCapturedIntelligence IsSoldier
	Response PlayerCappedIntelligenceSoldier
}

Response PlayerCapturedPointSoldier
{
	scene "scenes/Player/Soldier/low/1043.vcd" 
	scene "scenes/Player/Soldier/low/1044.vcd" 
	scene "scenes/Player/Soldier/low/1045.vcd" 
}
Rule PlayerCapturedPointSoldier
{
	criteria ConceptPlayerCapturedPoint IsSoldier
	Response PlayerCapturedPointSoldier
}

Response PlayerSuddenDeathSoldier
{
	scene "scenes/Player/Soldier/low/1120.vcd" 
	scene "scenes/Player/Soldier/low/1121.vcd" 
	scene "scenes/Player/Soldier/low/1122.vcd" 
	scene "scenes/Player/Soldier/low/1123.vcd" 
	scene "scenes/Player/Soldier/low/1124.vcd" 
	scene "scenes/Player/Soldier/low/1125.vcd" 
	scene "scenes/Player/Soldier/low/1126.vcd" 
	scene "scenes/Player/Soldier/low/1127.vcd" 
	scene "scenes/Player/Soldier/low/1128.vcd" 
	scene "scenes/Player/Soldier/low/1129.vcd" 
	scene "scenes/Player/Soldier/low/1130.vcd" 
	scene "scenes/Player/Soldier/low/1131.vcd" 
}
Rule PlayerSuddenDeathSoldier
{
	criteria ConceptPlayerSuddenDeathStart IsSoldier
	Response PlayerSuddenDeathSoldier
}

Response PlayerStalemateSoldier
{
	scene "scenes/Player/Soldier/low/1049.vcd" 
	scene "scenes/Player/Soldier/low/1050.vcd" 
	scene "scenes/Player/Soldier/low/1051.vcd" 
}
Rule PlayerStalemateSoldier
{
	criteria ConceptPlayerStalemate IsSoldier
	Response PlayerStalemateSoldier
}

Response PlayerTeleporterThanksSoldier
{
	scene "scenes/Player/Soldier/low/1216.vcd" 
	scene "scenes/Player/Soldier/low/1217.vcd" 
	scene "scenes/Player/Soldier/low/1218.vcd" 
}
Rule PlayerTeleporterThanksSoldier
{
	criteria ConceptTeleported IsNotEngineer IsSoldier 30PercentChance
	Response PlayerTeleporterThanksSoldier
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech Combat
//--------------------------------------------------------------------------------------------------------------
Response DefendOnThePointSoldier
{
	scene "scenes/Player/Soldier/low/1187.vcd" 
	scene "scenes/Player/Soldier/low/1354.vcd" 
	scene "scenes/Player/Soldier/low/1355.vcd" 
}
Rule DefendOnThePointSoldier
{
	criteria ConceptFireWeapon IsSoldier IsOnFriendlyControlPoint NotDefendOnThePointSpeech
	ApplyContext "DefendOnThePointSpeech:1:30"
	applycontexttoworld
	Response DefendOnThePointSoldier
}

Response KilledPlayerManySoldier
{
	scene "scenes/Player/Soldier/low/1181.vcd" 
	scene "scenes/Player/Soldier/low/1356.vcd" 
	scene "scenes/Player/Soldier/low/1197.vcd" 
	scene "scenes/Player/Soldier/low/1199.vcd" 
}
Rule KilledPlayerManySoldier
{
	criteria ConceptKilledPlayer IsManyRecentKills 30PercentChance IsWeaponPrimary KilledPlayerDelay SoldierNotKillSpeech IsSoldier
	ApplyContext "SoldierKillSpeech:1:10"
	applycontexttoworld
	Response KilledPlayerManySoldier
}

Response KilledPlayerMeleeSoldier
{
	scene "scenes/Player/Soldier/low/1185.vcd" 
}
Rule KilledPlayerMeleeSoldier
{
	criteria ConceptKilledPlayer KilledPlayerDelay 30PercentChance  IsWeaponMelee SoldierNotKillSpeechMelee IsSoldier
	ApplyContext "SoldierKillSpeechMelee:1:10"
	applycontexttoworld
	Response KilledPlayerMeleeSoldier
}

Response KilledPlayerVeryManySoldier
{
	scene "scenes/Player/Soldier/low/1206.vcd" 
}

// Custom stuff - melee dare
// Look at enemy, then do battle cry voice command while holding a melee weapon.
Response MeleeDareCombatSoldier
{
	scene "scenes/Player/Soldier/low/1196.vcd"
	scene "scenes/Player/Soldier/low/1210.vcd"
	scene "scenes/Player/Soldier/low/1205.vcd"
	scene "scenes/Player/Soldier/low/1208.vcd"
	scene "scenes/Player/Soldier/low/1203.vcd"
	scene "scenes/Player/Soldier/low/1190.vcd" 
}
Rule MeleeDareCombatSoldier
{
	criteria ConceptPlayerBattleCry IsWeaponMelee IsSoldier IsCrossHairEnemy
	Response MeleeDareCombatSoldier
}

// Added the unused Direct Hit screams here, as they can't be added to the taunt.
Response KilledPlayerMeleeSoldier
{
	scene "scenes/Player/Soldier/low/1185.vcd" 
	scene "scenes/Player/Soldier/low/3403.vcd" 
	scene "scenes/Player/Soldier/low/3405.vcd" 
	scene "scenes/Player/Soldier/low/3406.vcd" 
}
Rule KilledPlayerMeleeSoldier
{
	criteria ConceptKilledPlayer KilledPlayerDelay 30PercentChance  IsWeaponMelee SoldierNotKillSpeechMelee IsSoldier
	ApplyContext "SoldierKillSpeechMelee:1:10"
	Response KilledPlayerMeleeSoldier
}

Rule KilledPlayerVeryManySoldier
{
	criteria ConceptKilledPlayer IsVeryManyRecentKills 50PercentChance IsWeaponPrimary KilledPlayerDelay SoldierNotKillSpeech IsSoldier
	ApplyContext "SoldierKillSpeech:1:10"
	applycontexttoworld
	Response KilledPlayerVeryManySoldier
}

Response PlayerKilledCapperSoldier
{
	scene "scenes/Player/Soldier/low/1064.vcd" 
	scene "scenes/Player/Soldier/low/1062.vcd" 
	scene "scenes/Player/Soldier/low/1063.vcd" 
}
Rule PlayerKilledCapperSoldier
{
	criteria ConceptCapBlocked IsSoldier
	ApplyContext "SoldierKillSpeech:1:10"
	Response PlayerKilledCapperSoldier
}

Response PlayerKilledDominatingSoldier
{
	scene "scenes/Player/Soldier/low/1132.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/1346.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/1348.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/1133.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/1134.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/1347.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/1135.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/1349.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/1195.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/1202.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingSoldier
{
	criteria ConceptKilledPlayer IsSoldier IsDominated
	ApplyContext "SoldierKillSpeech:1:10"
	Response PlayerKilledDominatingSoldier
}

Response PlayerKilledDominatingDemomanSoldier
{
	scene "scenes/Player/Soldier/low/3407.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3408.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3409.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3410.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3411.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3412.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingDemomanSoldier
{
	criteria ConceptKilledPlayer IsSoldier IsDominated  IsVictimDemoman
	ApplyContext "SoldierKillSpeech:1:10"
	Response PlayerKilledDominatingDemomanSoldier
}

Response PlayerKilledDominatingEngineerSoldier
{
	scene "scenes/Player/Soldier/low/3418.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3419.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3420.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3421.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3422.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3423.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingEngineerSoldier
{
	criteria ConceptKilledPlayer IsSoldier IsDominated  IsVictimEngineer
	ApplyContext "SoldierKillSpeech:1:10"
	Response PlayerKilledDominatingEngineerSoldier
}

Response PlayerKilledDominatingHeavySoldier
{
	scene "scenes/Player/Soldier/low/3424.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3425.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3426.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3427.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3428.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3429.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3430.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingHeavySoldier
{
	criteria ConceptKilledPlayer IsSoldier IsDominated  IsVictimHeavy
	ApplyContext "SoldierKillSpeech:1:10"
	Response PlayerKilledDominatingHeavySoldier
}

Response PlayerKilledDominatingMedicSoldier
{
	scene "scenes/Player/Soldier/low/3431.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3432.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3433.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3434.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3435.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3436.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3437.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingMedicSoldier
{
	criteria ConceptKilledPlayer IsSoldier IsDominated  IsVictimMedic
	ApplyContext "SoldierKillSpeech:1:10"
	Response PlayerKilledDominatingMedicSoldier
}

Response PlayerKilledDominatingPyroSoldier
{
	scene "scenes/Player/Soldier/low/3438.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3439.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3440.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3441.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3442.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3443.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3444.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3445.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3446.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingPyroSoldier
{
	criteria ConceptKilledPlayer IsSoldier IsDominated  IsVictimPyro
	ApplyContext "SoldierKillSpeech:1:10"
	Response PlayerKilledDominatingPyroSoldier
}

Response PlayerKilledDominatingScoutSoldier
{
	scene "scenes/Player/Soldier/low/3447.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3448.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3449.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3450.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3451.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3452.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3453.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3454.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3455.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3456.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3457.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingScoutSoldier
{
	criteria ConceptKilledPlayer IsSoldier IsDominated  IsVictimScout
	ApplyContext "SoldierKillSpeech:1:10"
	Response PlayerKilledDominatingScoutSoldier
}

Response PlayerKilledDominatingSniperSoldier
{
	scene "scenes/Player/Soldier/low/3458.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3459.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3460.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3461.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3462.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3463.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3464.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3465.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3466.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3467.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3468.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3469.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3470.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3471.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingSniperSoldier
{
	criteria ConceptKilledPlayer IsSoldier IsDominated  IsVictimSniper
	ApplyContext "SoldierKillSpeech:1:10"
	Response PlayerKilledDominatingSniperSoldier
}

Response PlayerKilledDominatingSoldierSoldier
{
	scene "scenes/Player/Soldier/low/3472.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3473.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3474.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3475.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3476.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3477.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingSoldierSoldier
{
	criteria ConceptKilledPlayer IsSoldier IsDominated  IsVictimSoldier
	ApplyContext "SoldierKillSpeech:1:10"
	Response PlayerKilledDominatingSoldierSoldier
}

Response PlayerKilledDominatingSpySoldier
{
	scene "scenes/Player/Soldier/low/3478.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3479.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3480.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3481.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3482.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3483.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3484.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/3485.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingSpySoldier
{
	criteria ConceptKilledPlayer IsSoldier IsDominated  IsVictimSpy
	ApplyContext "SoldierKillSpeech:1:10"
	Response PlayerKilledDominatingSpySoldier
}

Response PlayerKilledForRevengeSoldier
{
	scene "scenes/Player/Soldier/low/1060.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/1065.vcd" predelay "2.5"
	scene "scenes/Player/Soldier/low/1096.vcd" predelay "2.5"
}
Rule PlayerKilledForRevengeSoldier
{
	criteria ConceptKilledPlayer IsSoldier IsRevenge
	ApplyContext "SoldierKillSpeech:1:10"
	Response PlayerKilledForRevengeSoldier
}

Response PlayerKilledObjectSoldier
{
	scene "scenes/Player/Soldier/low/1055.vcd" 
	scene "scenes/Player/Soldier/low/1345.vcd" 
	scene "scenes/Player/Soldier/low/1172.vcd" 
	scene "scenes/Player/Soldier/low/1175.vcd" 
	scene "scenes/Player/Soldier/low/1182.vcd" 
}
Rule PlayerKilledObjectSoldier
{
	criteria ConceptKilledObject IsSoldier 30PercentChance IsARecentKill
	ApplyContext "SoldierKillSpeechObject:1:30"
	applycontexttoworld
	Response PlayerKilledObjectSoldier
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech Pain
//--------------------------------------------------------------------------------------------------------------
Response PlayerAttackerPainSoldier
{
	scene "scenes/Player/Soldier/low/1165.vcd" 
	scene "scenes/Player/Soldier/low/1166.vcd" 
	scene "scenes/Player/Soldier/low/1167.vcd" 
	scene "scenes/Player/Soldier/low/1371.vcd" 
	scene "scenes/Player/Soldier/low/1372.vcd" 
	scene "scenes/Player/Soldier/low/1373.vcd" 
}
Rule PlayerAttackerPainSoldier
{
	criteria ConceptAttackerPain IsSoldier
	Response PlayerAttackerPainSoldier
}

Response PlayerOnFireSoldier
{
	scene "scenes/Player/Soldier/low/1052.vcd" 
}
Rule PlayerOnFireSoldier
{
	criteria ConceptFire IsSoldier SoldierIsNotStillonFire
	ApplyContext "SoldierOnFire:1:7"
	Response PlayerOnFireSoldier
}

Response PlayerOnFireRareSoldier
{
	scene "scenes/Player/Soldier/low/1053.vcd" 
	scene "scenes/Player/Soldier/low/1054.vcd" 
}
Rule PlayerOnFireRareSoldier
{
	criteria ConceptFire IsSoldier 10PercentChance SoldierIsNotStillonFire
	ApplyContext "SoldierOnFire:1:7"
	Response PlayerOnFireRareSoldier
}

Response PlayerPainSoldier
{
	scene "scenes/Player/Soldier/low/1168.vcd" 
	scene "scenes/Player/Soldier/low/1169.vcd" 
	scene "scenes/Player/Soldier/low/1170.vcd" 
	scene "scenes/Player/Soldier/low/1374.vcd" 
	scene "scenes/Player/Soldier/low/1375.vcd" 
	scene "scenes/Player/Soldier/low/1376.vcd" 
	scene "scenes/Player/Soldier/low/1377.vcd" 
	scene "scenes/Player/Soldier/low/1378.vcd" 
}
Rule PlayerPainSoldier
{
	criteria ConceptPain IsSoldier
	Response PlayerPainSoldier
}

Response PlayerStillOnFireSoldier
{
	scene "scenes/Player/Soldier/low/1926.vcd" 
}
Rule PlayerStillOnFireSoldier
{
	criteria ConceptFire IsSoldier  SoldierIsStillonFire
	ApplyContext "SoldierOnFire:1:7"
	Response PlayerStillOnFireSoldier
}


//--------------------------------------------------------------------------------------------------------------
// Duel Speech
//--------------------------------------------------------------------------------------------------------------
Response AcceptedDuelSoldier
{
	scene "scenes/Player/Soldier/low/1062.vcd" 
	scene "scenes/Player/Soldier/low/1172.vcd" 
	scene "scenes/Player/Soldier/low/1175.vcd" 
	scene "scenes/Player/Soldier/low/1174.vcd" 
	scene "scenes/Player/Soldier/low/1190.vcd" 
	scene "scenes/Player/Soldier/low/1221.vcd" 
}
Rule AcceptedDuelSoldier
{
	criteria ConceptIAcceptDuel IsSoldier
	Response AcceptedDuelSoldier
}

Response MeleeDareSoldier
{
	scene "scenes/Player/Soldier/low/1094.vcd" 
	scene "scenes/Player/Soldier/low/1188.vcd" 
	scene "scenes/Player/Soldier/low/1195.vcd" 
	scene "scenes/Player/Soldier/low/1196.vcd" 
	scene "scenes/Player/Soldier/low/1202.vcd" 
	scene "scenes/Player/Soldier/low/1210.vcd" 
}
Rule MeleeDareSoldier
{
	criteria ConceptRequestDuel IsSoldier
	Response MeleeDareSoldier
}

Response RejectedDuelSoldier
{
	scene "scenes/Player/Soldier/low/3487.vcd" 
	scene "scenes/Player/Soldier/low/1120.vcd" 
	scene "scenes/Player/Soldier/low/1207.vcd" 
}
Rule RejectedDuelSoldier
{
	criteria ConceptDuelRejected IsSoldier
	Response RejectedDuelSoldier
}


//--------------------------------------------------------------------------------------------------------------
// Speech Menu 1
//--------------------------------------------------------------------------------------------------------------
Response PlayerGoSoldier
{
	scene "scenes/Player/Soldier/low/1092.vcd" 
	scene "scenes/Player/Soldier/low/1093.vcd" 
}
Rule PlayerGoSoldier
{
	criteria ConceptPlayerGo IsSoldier
	Response PlayerGoSoldier
}

Response PlayerHeadLeftSoldier
{
	scene "scenes/Player/Soldier/low/1098.vcd" 
	scene "scenes/Player/Soldier/low/1100.vcd" 
	scene "scenes/Player/Soldier/low/1099.vcd" 
}
Rule PlayerHeadLeftSoldier
{
	criteria ConceptPlayerLeft  IsSoldier
	Response PlayerHeadLeftSoldier
}

Response PlayerHeadRightSoldier
{
	scene "scenes/Player/Soldier/low/1103.vcd" 
	scene "scenes/Player/Soldier/low/1101.vcd" 
	scene "scenes/Player/Soldier/low/1102.vcd" 
}
Rule PlayerHeadRightSoldier
{
	criteria ConceptPlayerRight  IsSoldier
	Response PlayerHeadRightSoldier
}

Response PlayerHelpSoldier
{
	scene "scenes/Player/Soldier/low/1104.vcd" 
	scene "scenes/Player/Soldier/low/1105.vcd" 
	scene "scenes/Player/Soldier/low/1106.vcd" 
}
Rule PlayerHelpSoldier
{
	criteria ConceptPlayerHelp IsSoldier
	Response PlayerHelpSoldier
}

Response PlayerHelpCaptureSoldier
{
	scene "scenes/Player/Soldier/low/1109.vcd" 
	scene "scenes/Player/Soldier/low/1107.vcd" 
	scene "scenes/Player/Soldier/low/1108.vcd" 
}
Rule PlayerHelpCaptureSoldier
{
	criteria ConceptPlayerHelp IsSoldier IsOnCappableControlPoint
	ApplyContext "SoldierHelpCap:1:10"
	Response PlayerHelpCaptureSoldier
}

Response PlayerHelpCapture2Soldier
{
	scene "scenes/Player/Soldier/low/1187.vcd" 
	scene "scenes/Player/Soldier/low/1354.vcd" 
	scene "scenes/Player/Soldier/low/1355.vcd" 
}
Rule PlayerHelpCapture2Soldier
{
	criteria ConceptPlayerHelp IsSoldier IsOnCappableControlPoint IsHelpCapSoldier
	Response PlayerHelpCapture2Soldier
}

Response PlayerHelpDefendSoldier
{
	scene "scenes/Player/Soldier/low/1110.vcd" 
	scene "scenes/Player/Soldier/low/1111.vcd" 
	scene "scenes/Player/Soldier/low/1112.vcd" 
	scene "scenes/Player/Soldier/low/1113.vcd" 
}
Rule PlayerHelpDefendSoldier
{
	criteria ConceptPlayerHelp IsSoldier IsOnFriendlyControlPoint
	Response PlayerHelpDefendSoldier
}

Response PlayerMedicSoldier
{
	scene "scenes/Player/Soldier/low/1139.vcd" 
	scene "scenes/Player/Soldier/low/1140.vcd" 
	scene "scenes/Player/Soldier/low/1141.vcd" 
}
Rule PlayerMedicSoldier
{
	criteria ConceptPlayerMedic IsSoldier
	Response PlayerMedicSoldier
}

Response PlayerMoveUpSoldier
{
	scene "scenes/Player/Soldier/low/1142.vcd" 
	scene "scenes/Player/Soldier/low/1143.vcd" 
	scene "scenes/Player/Soldier/low/1144.vcd" 
}
Rule PlayerMoveUpSoldier
{
	criteria ConceptPlayerMoveUp  IsSoldier
	Response PlayerMoveUpSoldier
}

Response PlayerNoSoldier
{
	scene "scenes/Player/Soldier/low/1159.vcd" 
	scene "scenes/Player/Soldier/low/1161.vcd" 
	scene "scenes/Player/Soldier/low/1160.vcd" 
}
Rule PlayerNoSoldier
{
	criteria ConceptPlayerNo  IsSoldier
	Response PlayerNoSoldier
}

Response PlayerThanksSoldier
{
	scene "scenes/Player/Soldier/low/1211.vcd" 
	scene "scenes/Player/Soldier/low/1212.vcd" 
}
Rule PlayerThanksSoldier
{
	criteria ConceptPlayerThanks IsSoldier
	Response PlayerThanksSoldier
}

Response PlayerYesSoldier
{
	scene "scenes/Player/Soldier/low/1350.vcd" 
	scene "scenes/Player/Soldier/low/1220.vcd" 
	scene "scenes/Player/Soldier/low/1221.vcd" 
	scene "scenes/Player/Soldier/low/1219.vcd" 
}
Rule PlayerYesSoldier
{
	criteria ConceptPlayerYes  IsSoldier
	Response PlayerYesSoldier
}


//--------------------------------------------------------------------------------------------------------------
// Speech Menu 2
//--------------------------------------------------------------------------------------------------------------
Response PlayerActivateChargeSoldier
{
	scene "scenes/Player/Soldier/low/1040.vcd" 
	scene "scenes/Player/Soldier/low/1041.vcd" 
	scene "scenes/Player/Soldier/low/1042.vcd" 
}
Rule PlayerActivateChargeSoldier
{
	criteria ConceptPlayerActivateCharge IsSoldier
	Response PlayerActivateChargeSoldier
}

Response PlayerCloakedSpySoldier
{
	scene "scenes/Player/Soldier/low/1071.vcd" 
	scene "scenes/Player/Soldier/low/1072.vcd" 
	scene "scenes/Player/Soldier/low/1070.vcd" 
}
Rule PlayerCloakedSpySoldier
{
	criteria ConceptPlayerCloakedSpy IsSoldier
	Response PlayerCloakedSpySoldier
}

Response PlayerDispenserHereSoldier
{
	scene "scenes/Player/Soldier/low/1146.vcd" 
}
Rule PlayerDispenserHereSoldier
{
	criteria ConceptPlayerDispenserHere IsSoldier
	Response PlayerDispenserHereSoldier
}

Response PlayerIncomingSoldier
{
	scene "scenes/Player/Soldier/low/1114.vcd" 
}
Rule PlayerIncomingSoldier
{
	criteria ConceptPlayerIncoming IsSoldier
	Response PlayerIncomingSoldier
}

Response PlayerSentryAheadSoldier
{
	scene "scenes/Player/Soldier/low/1177.vcd" 
	scene "scenes/Player/Soldier/low/1178.vcd" 
	scene "scenes/Player/Soldier/low/1176.vcd" 
}
Rule PlayerSentryAheadSoldier
{
	criteria ConceptPlayerSentryAhead IsSoldier
	Response PlayerSentryAheadSoldier
}

Response PlayerSentryHereSoldier
{
	scene "scenes/Player/Soldier/low/1148.vcd" 
}
Rule PlayerSentryHereSoldier
{
	criteria ConceptPlayerSentryHere IsSoldier
	Response PlayerSentryHereSoldier
}

Response PlayerTeleporterHereSoldier
{
	scene "scenes/Player/Soldier/low/1150.vcd" 
}
Rule PlayerTeleporterHereSoldier
{
	criteria ConceptPlayerTeleporterHere IsSoldier
	Response PlayerTeleporterHereSoldier
}


//--------------------------------------------------------------------------------------------------------------
// Speech Menu 3
//--------------------------------------------------------------------------------------------------------------
Response PlayerBattleCrySoldier
{
	scene "scenes/Player/Soldier/low/1055.vcd" 
	scene "scenes/Player/Soldier/low/1057.vcd" 
	scene "scenes/Player/Soldier/low/1058.vcd" 
	scene "scenes/Player/Soldier/low/1059.vcd" 
	scene "scenes/Player/Soldier/low/1056.vcd" 
	scene "scenes/Player/Soldier/low/1060.vcd" 
}
Rule PlayerBattleCrySoldier
{
	criteria ConceptPlayerBattleCry IsSoldier
	Response PlayerBattleCrySoldier
}

Response PlayerCheersSoldier
{
	scene "scenes/Player/Soldier/low/1065.vcd" 
	scene "scenes/Player/Soldier/low/1068.vcd" 
	scene "scenes/Player/Soldier/low/1066.vcd" 
	scene "scenes/Player/Soldier/low/1064.vcd" 
	scene "scenes/Player/Soldier/low/1062.vcd" 
	scene "scenes/Player/Soldier/low/1063.vcd" 
}
Rule PlayerCheersSoldier
{
	criteria ConceptPlayerCheers IsSoldier
	Response PlayerCheersSoldier
}

Response PlayerGoodJobSoldier
{
	scene "scenes/Player/Soldier/low/1095.vcd" 
	scene "scenes/Player/Soldier/low/1096.vcd" 
	scene "scenes/Player/Soldier/low/1097.vcd" 
}
Rule PlayerGoodJobSoldier
{
	criteria ConceptPlayerGoodJob IsSoldier
	Response PlayerGoodJobSoldier
}

Response PlayerJeersSoldier
{
	scene "scenes/Player/Soldier/low/1120.vcd" 
	scene "scenes/Player/Soldier/low/1121.vcd" 
	scene "scenes/Player/Soldier/low/1122.vcd" 
	scene "scenes/Player/Soldier/low/1123.vcd" 
	scene "scenes/Player/Soldier/low/1124.vcd" 
	scene "scenes/Player/Soldier/low/1125.vcd" 
	scene "scenes/Player/Soldier/low/1126.vcd" 
	scene "scenes/Player/Soldier/low/1127.vcd" 
	scene "scenes/Player/Soldier/low/1128.vcd" 
	scene "scenes/Player/Soldier/low/1129.vcd" 
	scene "scenes/Player/Soldier/low/1130.vcd" 
	scene "scenes/Player/Soldier/low/1131.vcd" 
}
Rule PlayerJeersSoldier
{
	criteria ConceptPlayerJeers IsSoldier
	Response PlayerJeersSoldier
}

Response PlayerLostPointSoldier
{
	scene "scenes/Player/Soldier/low/1151.vcd" 
	scene "scenes/Player/Soldier/low/1152.vcd" 
	scene "scenes/Player/Soldier/low/1153.vcd" 
	scene "scenes/Player/Soldier/low/1154.vcd" 
	scene "scenes/Player/Soldier/low/1155.vcd" 
	scene "scenes/Player/Soldier/low/1353.vcd" 
}
Rule PlayerLostPointSoldier
{
	criteria ConceptPlayerLostPoint IsSoldier
	Response PlayerLostPointSoldier
}

Response PlayerNegativeSoldier
{
	scene "scenes/Player/Soldier/low/1151.vcd" 
	scene "scenes/Player/Soldier/low/1152.vcd" 
	scene "scenes/Player/Soldier/low/1153.vcd" 
	scene "scenes/Player/Soldier/low/1154.vcd" 
	scene "scenes/Player/Soldier/low/1155.vcd" 
	scene "scenes/Player/Soldier/low/1353.vcd" 
}
Rule PlayerNegativeSoldier
{
	criteria ConceptPlayerNegative IsSoldier
	Response PlayerNegativeSoldier
}

Response PlayerNiceShotSoldier
{
	scene "scenes/Player/Soldier/low/1156.vcd" 
	scene "scenes/Player/Soldier/low/1157.vcd" 
	scene "scenes/Player/Soldier/low/1158.vcd" 
}
Rule PlayerNiceShotSoldier
{
	criteria ConceptPlayerNiceShot IsSoldier
	Response PlayerNiceShotSoldier
}

Response PlayerPositiveSoldier
{
	scene "scenes/Player/Soldier/low/1345.vcd" 
	scene "scenes/Player/Soldier/low/1172.vcd" 
	scene "scenes/Player/Soldier/low/1175.vcd" 
	scene "scenes/Player/Soldier/low/1174.vcd" 
	scene "scenes/Player/Soldier/low/1171.vcd" 
}
Rule PlayerPositiveSoldier
{
	criteria ConceptPlayerPositive IsSoldier
	Response PlayerPositiveSoldier
}

Response PlayerTauntsSoldier
{
	scene "scenes/Player/Soldier/low/1136.vcd" 
	scene "scenes/Player/Soldier/low/1137.vcd" 
	scene "scenes/Player/Soldier/low/1138.vcd" 
	scene "scenes/Player/Soldier/low/1351.vcd" 
	scene "scenes/Player/Soldier/low/1352.vcd" 
}
Rule PlayerTauntsSoldier
{
	criteria ConceptPlayerTaunts IsSoldier
	Response PlayerTauntsSoldier
}

