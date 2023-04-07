//--------------------------------------------------------------------------------------------------------------
// Medic Response Rule File
//--------------------------------------------------------------------------------------------------------------

Criterion "MedicIsKillSpeechObject" "MedicKillSpeechObject" "1" "required" weight 0
Criterion "MedicIsNotStillonFire" "MedicOnFire" "!=1" "required" weight 0
Criterion "MedicIsStillonFire" "MedicOnFire" "1" "required" weight 0
Criterion "MedicNotInvulnerableSpeech" "MedicInvulnerableSpeech" "!=1" "required" weight 0
Criterion "MedicNotKillSpeech" "MedicKillSpeech" "!=1" "required" weight 0
Criterion "MedicNotKillSpeechMelee" "MedicKillSpeechMelee" "!=1" "required" weight 0
Criterion "MedicNotSaidHealThanks" "MedicSaidHealThanks" "!=1" "required"
Criterion "IsHelpCapMedic" "MedicHelpCap" "1" "required" weight 0

Response MedicJarateHit
{
	scene "scenes/Player/Medic/low/622.vcd"
	scene "scenes/Player/Medic/low/623.vcd"
	scene "scenes/Player/Medic/low/1223.vcd"
	scene "scenes/Player/Medic/low/1224.vcd"
	scene "scenes/Player/Medic/low/1225.vcd"
}
Rule MedicJarateHit
{
	criteria ConceptJarateHit IsMedic 50PercentChance
	Response MedicJarateHit
}

// Custom stuff - melee dare
// Look at enemy, then do battle cry voice command while holding a melee weapon.
Response MeleeDareCombatMedic
{
	scene "scenes/Player/Medic/low/661.vcd"
	scene "scenes/Player/Medic/low/669.vcd"
	scene "scenes/Player/Medic/low/672.vcd"
	scene "scenes/Player/Medic/low/667.vcd"
	scene "scenes/Player/Medic/low/677.vcd"
	scene "scenes/Player/Medic/low/680.vcd"
	scene "scenes/Player/Medic/low/1241.vcd"
	scene "scenes/Player/Medic/low/679.vcd"
}
Rule MeleeDareCombatMedic
{
	criteria ConceptPlayerBattleCry IsWeaponMelee IsMedic IsCrossHairEnemy
	Response MeleeDareCombatMedic
}
//End custom
Response MedicChargeReady
{
	scene "scenes/Player/Medic/low/529.vcd" 
	scene "scenes/Player/Medic/low/530.vcd" 
}
Rule MedicChargeReady
{
	criteria ConceptMedicChargeReady IsMedic
	Response MedicChargeReady
}

Response PlayerCloakedSpyDemomanMedic
{
	scene "scenes/Player/Medic/low/559.vcd" 
}
Rule PlayerCloakedSpyDemomanMedic
{
	criteria ConceptPlayerCloakedSpy IsMedic IsOnDemoman
	Response PlayerCloakedSpyDemomanMedic
}

Response PlayerCloakedSpyEngineerMedic
{
	scene "scenes/Player/Medic/low/562.vcd" 
}
Rule PlayerCloakedSpyEngineerMedic
{
	criteria ConceptPlayerCloakedSpy IsMedic IsOnEngineer
	Response PlayerCloakedSpyEngineerMedic
}

Response PlayerCloakedSpyHeavyMedic
{
	scene "scenes/Player/Medic/low/557.vcd" 
}
Rule PlayerCloakedSpyHeavyMedic
{
	criteria ConceptPlayerCloakedSpy IsMedic IsOnHeavy
	Response PlayerCloakedSpyHeavyMedic
}

Response PlayerCloakedSpyMedicMedic
{
	scene "scenes/Player/Medic/low/561.vcd" 
}
Rule PlayerCloakedSpyMedicMedic
{
	criteria ConceptPlayerCloakedSpy IsMedic IsOnMedic
	Response PlayerCloakedSpyMedicMedic
}

Response PlayerCloakedSpyPyroMedic
{
	scene "scenes/Player/Medic/low/558.vcd" 
}
Rule PlayerCloakedSpyPyroMedic
{
	criteria ConceptPlayerCloakedSpy IsMedic IsOnPyro
	Response PlayerCloakedSpyPyroMedic
}

Response PlayerCloakedSpyScoutMedic
{
	scene "scenes/Player/Medic/low/555.vcd" 
}
Rule PlayerCloakedSpyScoutMedic
{
	criteria ConceptPlayerCloakedSpy IsMedic IsOnScout
	Response PlayerCloakedSpyScoutMedic
}

Response PlayerCloakedSpySniperMedic
{
	scene "scenes/Player/Medic/low/563.vcd" 
}
Rule PlayerCloakedSpySniperMedic
{
	criteria ConceptPlayerCloakedSpy IsMedic IsOnSniper
	Response PlayerCloakedSpySniperMedic
}

Response PlayerCloakedSpySoldierMedic
{
	scene "scenes/Player/Medic/low/556.vcd" 
}
Rule PlayerCloakedSpySoldierMedic
{
	criteria ConceptPlayerCloakedSpy IsMedic IsOnSoldier
	Response PlayerCloakedSpySoldierMedic
}

Response PlayerCloakedSpySpyMedic
{
	scene "scenes/Player/Medic/low/560.vcd" 
}
Rule PlayerCloakedSpySpyMedic
{
	criteria ConceptPlayerCloakedSpy IsMedic IsOnSpy
	Response PlayerCloakedSpySpyMedic
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech
//--------------------------------------------------------------------------------------------------------------
Response HealThanksMedic
{
	scene "scenes/Player/Medic/low/683.vcd" 
	scene "scenes/Player/Medic/low/684.vcd" 
}
Rule HealThanksMedic
{
	criteria ConceptMedicChargeStopped IsMedic SuperHighHealthContext MedicNotSaidHealThanks 50PercentChance
	ApplyContext "MedicSaidHealThanks:1:20"
	Response HealThanksMedic
}

Response PlayerRoundStartMedic
{
	scene "scenes/Player/Medic/low/537.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Medic/low/539.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Medic/low/540.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Medic/low/541.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Medic/low/542.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Medic/low/543.vcd" predelay "1.0, 5.0"
}
Rule PlayerRoundStartMedic
{
	criteria ConceptPlayerRoundStart IsMedic
	Response PlayerRoundStartMedic
}

Response PlayerCappedIntelligenceMedic
{
	scene "scenes/Player/Medic/low/525.vcd" 
	scene "scenes/Player/Medic/low/526.vcd" 
	scene "scenes/Player/Medic/low/527.vcd" 
}
Rule PlayerCappedIntelligenceMedic
{
	criteria ConceptPlayerCapturedIntelligence IsMedic
	Response PlayerCappedIntelligenceMedic
}

Response PlayerCapturedPointMedic
{
	scene "scenes/Player/Medic/low/522.vcd" 
	scene "scenes/Player/Medic/low/523.vcd" 
	scene "scenes/Player/Medic/low/524.vcd" 
}
Rule PlayerCapturedPointMedic
{
	criteria ConceptPlayerCapturedPoint IsMedic
	Response PlayerCapturedPointMedic
}

Response PlayerSuddenDeathMedic
{
	scene "scenes/Player/Medic/low/592.vcd" 
	scene "scenes/Player/Medic/low/593.vcd" 
	scene "scenes/Player/Medic/low/594.vcd" 
	scene "scenes/Player/Medic/low/595.vcd" 
	scene "scenes/Player/Medic/low/596.vcd" 
	scene "scenes/Player/Medic/low/597.vcd" 
	scene "scenes/Player/Medic/low/598.vcd" 
	scene "scenes/Player/Medic/low/599.vcd" 
	scene "scenes/Player/Medic/low/600.vcd" 
	scene "scenes/Player/Medic/low/601.vcd" 
	scene "scenes/Player/Medic/low/603.vcd" 
	scene "scenes/Player/Medic/low/602.vcd" 
}
Rule PlayerSuddenDeathMedic
{
	criteria ConceptPlayerSuddenDeathStart IsMedic
	Response PlayerSuddenDeathMedic
}

Response PlayerStalemateMedic
{
	scene "scenes/Player/Medic/low/531.vcd" 
	scene "scenes/Player/Medic/low/532.vcd" 
	scene "scenes/Player/Medic/low/533.vcd" 
	scene "scenes/Player/Medic/low/1222.vcd" 
	scene "scenes/Player/Medic/low/1223.vcd" 
	scene "scenes/Player/Medic/low/1224.vcd" 
	scene "scenes/Player/Medic/low/1225.vcd" 
}
Rule PlayerStalemateMedic
{
	criteria ConceptPlayerStalemate IsMedic
	Response PlayerStalemateMedic
}

Response PlayerTeleporterThanksMedic
{
	scene "scenes/Player/Medic/low/688.vcd" 
	scene "scenes/Player/Medic/low/686.vcd" 
	scene "scenes/Player/Medic/low/687.vcd" 
}
Rule PlayerTeleporterThanksMedic
{
	criteria ConceptTeleported IsNotEngineer IsMedic 30PercentChance
	Response PlayerTeleporterThanksMedic
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech Combat
//--------------------------------------------------------------------------------------------------------------
Response DefendOnThePointMedic
{
	scene "scenes/Player/Medic/low/659.vcd" 
	scene "scenes/Player/Medic/low/660.vcd" 
	scene "scenes/Player/Medic/low/1237.vcd" 
	scene "scenes/Player/Medic/low/1238.vcd" 
	scene "scenes/Player/Medic/low/1239.vcd" 
}
Rule DefendOnThePointMedic
{
	criteria ConceptFireWeapon IsMedic IsOnFriendlyControlPoint NotDefendOnThePointSpeech
	ApplyContext "DefendOnThePointSpeech:1:30"
	applycontexttoworld
	Response DefendOnThePointMedic
}

Response InvulnerableSpeechMedic
{
	scene "scenes/Player/Medic/low/648.vcd" 
	scene "scenes/Player/Medic/low/649.vcd" 
	scene "scenes/Player/Medic/low/650.vcd" 
}
Rule InvulnerableSpeechMedic
{
	criteria ConceptMedicChargeDeployed IsMedic  IsInvulnerable MedicNotInvulnerableSpeech
	ApplyContext "MedicInvulnerableSpeech:1:30"
	Response InvulnerableSpeechMedic
}

Response KilledPlayerManyMedic
{
	scene "scenes/Player/Medic/low/651.vcd" 
}
Rule KilledPlayerManyMedic
{
	criteria ConceptKilledPlayer IsManyRecentKills 30PercentChance IsWeaponPrimary KilledPlayerDelay MedicNotKillSpeech IsMedic
	ApplyContext "MedicKillSpeech:1:10"
	applycontexttoworld
	Response KilledPlayerManyMedic
}

Response KilledPlayerMeleeMedic
{
	scene "scenes/Player/Medic/low/645.vcd" 
}
Rule KilledPlayerMeleeMedic
{
	criteria ConceptKilledPlayer KilledPlayerDelay 30PercentChance  IsWeaponMelee MedicNotKillSpeechMelee IsMedic
	ApplyContext "MedicKillSpeechMelee:1:10"
	applycontexttoworld
	Response KilledPlayerMeleeMedic
}

Response KilledPlayerVeryManyMedic
{
	scene "scenes/Player/Medic/low/646.vcd" 
	scene "scenes/Player/Medic/low/655.vcd" 
	scene "scenes/Player/Medic/low/656.vcd" 
	scene "scenes/Player/Medic/low/652.vcd" 
}
Rule KilledPlayerVeryManyMedic
{
	criteria ConceptKilledPlayer IsVeryManyRecentKills 50PercentChance IsWeaponPrimary KilledPlayerDelay MedicNotKillSpeech IsMedic
	ApplyContext "MedicKillSpeech:1:10"
	applycontexttoworld
	Response KilledPlayerVeryManyMedic
}

Response PlayerKilledCapperMedic
{
	scene "scenes/Player/Medic/low/1222.vcd" 
	scene "scenes/Player/Medic/low/545.vcd" 
	scene "scenes/Player/Medic/low/551.vcd" 
	scene "scenes/Player/Medic/low/552.vcd" 
	scene "scenes/Player/Medic/low/641.vcd" 
	scene "scenes/Player/Medic/low/674.vcd" 
}
Rule PlayerKilledCapperMedic
{
	criteria ConceptCapBlocked IsMedic
	ApplyContext "MedicKillSpeech:1:10"
	Response PlayerKilledCapperMedic
}

Response PlayerKilledDominatingMedic
{
	scene "scenes/Player/Medic/low/1227.vcd" predelay "2.5"
	scene "scenes/Player/Medic/low/1232.vcd" predelay "2.5"
	scene "scenes/Player/Medic/low/605.vcd" predelay "2.5"
	scene "scenes/Player/Medic/low/606.vcd" predelay "2.5"
	scene "scenes/Player/Medic/low/1229.vcd" predelay "2.5"
	scene "scenes/Player/Medic/low/607.vcd" predelay "2.5"
	scene "scenes/Player/Medic/low/608.vcd" predelay "2.5"
	scene "scenes/Player/Medic/low/1230.vcd" predelay "2.5"
	scene "scenes/Player/Medic/low/679.vcd" predelay "2.5"
	scene "scenes/Player/Medic/low/1240.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingMedic
{
	criteria ConceptKilledPlayer IsMedic IsDominated
	ApplyContext "MedicKillSpeech:1:10"
	Response PlayerKilledDominatingMedic
}

Response PlayerKilledForRevengeMedic
{
	scene "scenes/Player/Medic/low/569.vcd" predelay "2.5"
	scene "scenes/Player/Medic/low/620.vcd" predelay "2.5"
	scene "scenes/Player/Medic/low/1233.vcd" predelay "2.5"
	scene "scenes/Player/Medic/low/1234.vcd" predelay "2.5"
}
Rule PlayerKilledForRevengeMedic
{
	criteria ConceptKilledPlayer IsMedic IsRevenge
	ApplyContext "MedicKillSpeech:1:10"
	Response PlayerKilledForRevengeMedic
}

Response PlayerKilledObjectMedic
{
	scene "scenes/Player/Medic/low/653.vcd" 
	scene "scenes/Player/Medic/low/654.vcd" 
}
Rule PlayerKilledObjectMedic
{
	criteria ConceptKilledObject IsMedic 30PercentChance IsARecentKill
	ApplyContext "MedicKillSpeechObject:1:30"
	applycontexttoworld
	Response PlayerKilledObjectMedic
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech Pain
//--------------------------------------------------------------------------------------------------------------
Response PlayerAttackerPainMedic
{
	scene "scenes/Player/Medic/low/633.vcd" 
	scene "scenes/Player/Medic/low/634.vcd" 
	scene "scenes/Player/Medic/low/635.vcd" 
	scene "scenes/Player/Medic/low/1243.vcd" 
}
Rule PlayerAttackerPainMedic
{
	criteria ConceptAttackerPain IsMedic
	Response PlayerAttackerPainMedic
}

Response PlayerOnFireMedic
{
	scene "scenes/Player/Medic/low/534.vcd" 
	scene "scenes/Player/Medic/low/535.vcd" 
	scene "scenes/Player/Medic/low/536.vcd" 
}
Rule PlayerOnFireMedic
{
	criteria ConceptFire IsMedic MedicIsNotStillonFire
	ApplyContext "MedicOnFire:1:7"
	Response PlayerOnFireMedic
}

Response PlayerOnFireRareMedic
{
	scene "scenes/Player/Medic/low/1401.vcd" 
	scene "scenes/Player/Medic/low/1402.vcd" 
}
Rule PlayerOnFireRareMedic
{
	criteria ConceptFire IsMedic 10PercentChance MedicIsNotStillonFire
	ApplyContext "MedicOnFire:1:7"
	Response PlayerOnFireRareMedic
}

Response PlayerPainMedic
{
	scene "scenes/Player/Medic/low/636.vcd" 
	scene "scenes/Player/Medic/low/637.vcd" 
	scene "scenes/Player/Medic/low/638.vcd" 
	scene "scenes/Player/Medic/low/1244.vcd" 
	scene "scenes/Player/Medic/low/1245.vcd" 
	scene "scenes/Player/Medic/low/1246.vcd" 
	scene "scenes/Player/Medic/low/1247.vcd" 
	scene "scenes/Player/Medic/low/1248.vcd" 
}
Rule PlayerPainMedic
{
	criteria ConceptPain IsMedic
	Response PlayerPainMedic
}

Response PlayerStillOnFireMedic
{
	scene "scenes/Player/Medic/low/1924.vcd" 
}
Rule PlayerStillOnFireMedic
{
	criteria ConceptFire IsMedic  MedicIsStillonFire
	ApplyContext "MedicOnFire:1:7"
	Response PlayerStillOnFireMedic
}


//--------------------------------------------------------------------------------------------------------------
// Duel Speech
//--------------------------------------------------------------------------------------------------------------
Response AcceptedDuelMedic
{
	scene "scenes/Player/Medic/low/541.vcd" 
	scene "scenes/Player/Medic/low/640.vcd" 
	scene "scenes/Player/Medic/low/689.vcd" 
	scene "scenes/Player/Medic/low/690.vcd" 
}
Rule AcceptedDuelMedic
{
	criteria ConceptIAcceptDuel IsMedic
	Response AcceptedDuelMedic
}

Response MeleeDareMedic
{
	scene "scenes/Player/Medic/low/524.vcd" 
	scene "scenes/Player/Medic/low/597.vcd" 
	scene "scenes/Player/Medic/low/672.vcd" 
	scene "scenes/Player/Medic/low/677.vcd" 
}
Rule MeleeDareMedic
{
	criteria ConceptRequestDuel IsMedic
	Response MeleeDareMedic
}

Response RejectedDuelMedic
{
	scene "scenes/Player/Medic/low/531.vcd" 
	scene "scenes/Player/Medic/low/1222.vcd" 
	scene "scenes/Player/Medic/low/1225.vcd" 
	scene "scenes/Player/Medic/low/596.vcd" 
	scene "scenes/Player/Medic/low/678.vcd" 
}
Rule RejectedDuelMedic
{
	criteria ConceptDuelRejected IsMedic
	Response RejectedDuelMedic
}


//--------------------------------------------------------------------------------------------------------------
// Speech Menu 1
//--------------------------------------------------------------------------------------------------------------
Response PlayerGoMedic
{
	scene "scenes/Player/Medic/low/565.vcd" 
	scene "scenes/Player/Medic/low/566.vcd" 
	scene "scenes/Player/Medic/low/567.vcd" 
	scene "scenes/Player/Medic/low/1226.vcd" 
	scene "scenes/Player/Medic/low/1596.vcd" 
}
Rule PlayerGoMedic
{
	criteria ConceptPlayerGo IsMedic
	Response PlayerGoMedic
}

Response PlayerHeadLeftMedic
{
	scene "scenes/Player/Medic/low/571.vcd" 
	scene "scenes/Player/Medic/low/572.vcd" 
	scene "scenes/Player/Medic/low/573.vcd" 
}
Rule PlayerHeadLeftMedic
{
	criteria ConceptPlayerLeft  IsMedic
	Response PlayerHeadLeftMedic
}

Response PlayerHeadRightMedic
{
	scene "scenes/Player/Medic/low/574.vcd" 
	scene "scenes/Player/Medic/low/575.vcd" 
	scene "scenes/Player/Medic/low/576.vcd" 
}
Rule PlayerHeadRightMedic
{
	criteria ConceptPlayerRight  IsMedic
	Response PlayerHeadRightMedic
}

Response PlayerHelpMedic
{
	scene "scenes/Player/Medic/low/577.vcd" 
	scene "scenes/Player/Medic/low/578.vcd" 
	scene "scenes/Player/Medic/low/579.vcd" 
}
Rule PlayerHelpMedic
{
	criteria ConceptPlayerHelp IsMedic
	Response PlayerHelpMedic
}

Response PlayerHelpCaptureMedic
{
	scene "scenes/Player/Medic/low/580.vcd" 
	scene "scenes/Player/Medic/low/581.vcd" 
}
Rule PlayerHelpCaptureMedic
{
	criteria ConceptPlayerHelp IsMedic IsOnCappableControlPoint
	ApplyContext "MedicHelpCap:1:10"
	Response PlayerHelpCaptureMedic
}

Response PlayerHelpCapture2Medic
{
	scene "scenes/Player/Medic/low/659.vcd" 
	scene "scenes/Player/Medic/low/660.vcd" 
	scene "scenes/Player/Medic/low/1237.vcd" 
	scene "scenes/Player/Medic/low/1238.vcd" 
	scene "scenes/Player/Medic/low/1239.vcd" 
}
Rule PlayerHelpCapture2Medic
{
	criteria ConceptPlayerHelp IsMedic IsOnCappableControlPoint IsHelpCapMedic
	Response PlayerHelpCapture2Medic
}

Response PlayerHelpDefendMedic
{
	scene "scenes/Player/Medic/low/583.vcd" 
	scene "scenes/Player/Medic/low/584.vcd" 
	scene "scenes/Player/Medic/low/585.vcd" 
}
Rule PlayerHelpDefendMedic
{
	criteria ConceptPlayerHelp IsMedic IsOnFriendlyControlPoint
	Response PlayerHelpDefendMedic
}

Response PlayerMedicMedic
{
	scene "scenes/Player/Medic/low/611.vcd" 
	scene "scenes/Player/Medic/low/612.vcd" 
	scene "scenes/Player/Medic/low/613.vcd" 
}
Rule PlayerMedicMedic
{
	criteria ConceptPlayerMedic IsMedic
	Response PlayerMedicMedic
}

Response PlayerMoveUpMedic
{
	scene "scenes/Player/Medic/low/614.vcd" 
	scene "scenes/Player/Medic/low/615.vcd" 
}
Rule PlayerMoveUpMedic
{
	criteria ConceptPlayerMoveUp  IsMedic
	Response PlayerMoveUpMedic
}

Response PlayerNoMedic
{
	scene "scenes/Player/Medic/low/627.vcd" 
	scene "scenes/Player/Medic/low/628.vcd" 
	scene "scenes/Player/Medic/low/629.vcd" 
}
Rule PlayerNoMedic
{
	criteria ConceptPlayerNo  IsMedic
	Response PlayerNoMedic
}

Response PlayerThanksMedic
{
	scene "scenes/Player/Medic/low/681.vcd" 
	scene "scenes/Player/Medic/low/682.vcd" 
}
Rule PlayerThanksMedic
{
	criteria ConceptPlayerThanks IsMedic
	Response PlayerThanksMedic
}

Response PlayerYesMedic
{
	scene "scenes/Player/Medic/low/689.vcd" 
	scene "scenes/Player/Medic/low/690.vcd" 
	scene "scenes/Player/Medic/low/691.vcd" 
}
Rule PlayerYesMedic
{
	criteria ConceptPlayerYes  IsMedic
	Response PlayerYesMedic
}


//--------------------------------------------------------------------------------------------------------------
// Speech Menu 2
//--------------------------------------------------------------------------------------------------------------
Response PlayerActivateChargeMedic
{
	scene "scenes/Player/Medic/low/519.vcd" 
	scene "scenes/Player/Medic/low/520.vcd" 
	scene "scenes/Player/Medic/low/521.vcd" 
}
Rule PlayerActivateChargeMedic
{
	criteria ConceptPlayerActivateCharge IsMedic
	Response PlayerActivateChargeMedic
}

Response PlayerChargeReadyMedic
{
	scene "scenes/Player/Medic/low/529.vcd" 
	scene "scenes/Player/Medic/low/530.vcd" 
}
Rule PlayerChargeReadyMedic
{
	criteria ConceptPlayerChargeReady IsMedic
	Response PlayerChargeReadyMedic
}

Response PlayerCloakedSpyMedic
{
	scene "scenes/Player/Medic/low/553.vcd" 
	scene "scenes/Player/Medic/low/554.vcd" 
}
Rule PlayerCloakedSpyMedic
{
	criteria ConceptPlayerCloakedSpy IsMedic
	Response PlayerCloakedSpyMedic
}

Response PlayerDispenserHereMedic
{
	scene "scenes/Player/Medic/low/616.vcd" 
}
Rule PlayerDispenserHereMedic
{
	criteria ConceptPlayerDispenserHere IsMedic
	Response PlayerDispenserHereMedic
}

Response PlayerIncomingMedic
{
	scene "scenes/Player/Medic/low/586.vcd" 
	scene "scenes/Player/Medic/low/587.vcd" 
	scene "scenes/Player/Medic/low/588.vcd" 
}
Rule PlayerIncomingMedic
{
	criteria ConceptPlayerIncoming IsMedic
	Response PlayerIncomingMedic
}

Response PlayerSentryAheadMedic
{
	scene "scenes/Player/Medic/low/643.vcd" 
	scene "scenes/Player/Medic/low/644.vcd" 
}
Rule PlayerSentryAheadMedic
{
	criteria ConceptPlayerSentryAhead IsMedic
	Response PlayerSentryAheadMedic
}

Response PlayerSentryHereMedic
{
	scene "scenes/Player/Medic/low/617.vcd" 
}
Rule PlayerSentryHereMedic
{
	criteria ConceptPlayerSentryHere IsMedic
	Response PlayerSentryHereMedic
}

Response PlayerTeleporterHereMedic
{
	scene "scenes/Player/Medic/low/618.vcd" 
}
Rule PlayerTeleporterHereMedic
{
	criteria ConceptPlayerTeleporterHere IsMedic
	Response PlayerTeleporterHereMedic
}


//--------------------------------------------------------------------------------------------------------------
// Speech Menu 3
//--------------------------------------------------------------------------------------------------------------
Response PlayerBattleCryMedic
{
	scene "scenes/Player/Medic/low/537.vcd" 
	scene "scenes/Player/Medic/low/539.vcd" 
	scene "scenes/Player/Medic/low/540.vcd" 
	scene "scenes/Player/Medic/low/541.vcd" 
	scene "scenes/Player/Medic/low/542.vcd" 
	scene "scenes/Player/Medic/low/543.vcd" 
}
Rule PlayerBattleCryMedic
{
	criteria ConceptPlayerBattleCry IsMedic
	Response PlayerBattleCryMedic
}

Response PlayerCheersMedic
{
	scene "scenes/Player/Medic/low/544.vcd" 
	scene "scenes/Player/Medic/low/545.vcd" 
	scene "scenes/Player/Medic/low/548.vcd" 
	scene "scenes/Player/Medic/low/550.vcd" 
	scene "scenes/Player/Medic/low/551.vcd" 
	scene "scenes/Player/Medic/low/552.vcd" 
}
Rule PlayerCheersMedic
{
	criteria ConceptPlayerCheers IsMedic
	Response PlayerCheersMedic
}

Response PlayerGoodJobMedic
{
	scene "scenes/Player/Medic/low/568.vcd" 
	scene "scenes/Player/Medic/low/569.vcd" 
	scene "scenes/Player/Medic/low/570.vcd" 
}
Rule PlayerGoodJobMedic
{
	criteria ConceptPlayerGoodJob IsMedic
	Response PlayerGoodJobMedic
}

Response PlayerJeersMedic
{
	scene "scenes/Player/Medic/low/592.vcd" 
	scene "scenes/Player/Medic/low/593.vcd" 
	scene "scenes/Player/Medic/low/594.vcd" 
	scene "scenes/Player/Medic/low/595.vcd" 
	scene "scenes/Player/Medic/low/596.vcd" 
	scene "scenes/Player/Medic/low/597.vcd" 
	scene "scenes/Player/Medic/low/598.vcd" 
	scene "scenes/Player/Medic/low/599.vcd" 
	scene "scenes/Player/Medic/low/600.vcd" 
	scene "scenes/Player/Medic/low/601.vcd" 
	scene "scenes/Player/Medic/low/603.vcd" 
	scene "scenes/Player/Medic/low/602.vcd" 
}
Rule PlayerJeersMedic
{
	criteria ConceptPlayerJeers IsMedic
	Response PlayerJeersMedic
}

Response PlayerLostPointMedic
{
	scene "scenes/Player/Medic/low/619.vcd" 
	scene "scenes/Player/Medic/low/620.vcd" 
	scene "scenes/Player/Medic/low/621.vcd" 
	scene "scenes/Player/Medic/low/622.vcd" 
	scene "scenes/Player/Medic/low/623.vcd" 
	scene "scenes/Player/Medic/low/1233.vcd" 
	scene "scenes/Player/Medic/low/1234.vcd" 
}
Rule PlayerLostPointMedic
{
	criteria ConceptPlayerLostPoint IsMedic
	Response PlayerLostPointMedic
}

Response PlayerNegativeMedic
{
	scene "scenes/Player/Medic/low/619.vcd" 
	scene "scenes/Player/Medic/low/620.vcd" 
	scene "scenes/Player/Medic/low/621.vcd" 
	scene "scenes/Player/Medic/low/622.vcd" 
	scene "scenes/Player/Medic/low/623.vcd" 
	scene "scenes/Player/Medic/low/1233.vcd" 
	scene "scenes/Player/Medic/low/1234.vcd" 
}
Rule PlayerNegativeMedic
{
	criteria ConceptPlayerNegative IsMedic
	Response PlayerNegativeMedic
}

Response PlayerNiceShotMedic
{
	scene "scenes/Player/Medic/low/624.vcd" 
	scene "scenes/Player/Medic/low/625.vcd" 
}
Rule PlayerNiceShotMedic
{
	criteria ConceptPlayerNiceShot IsMedic
	Response PlayerNiceShotMedic
}

Response PlayerPositiveMedic
{
	scene "scenes/Player/Medic/low/639.vcd" 
	scene "scenes/Player/Medic/low/640.vcd" 
	scene "scenes/Player/Medic/low/641.vcd" 
	scene "scenes/Player/Medic/low/1235.vcd" 
	scene "scenes/Player/Medic/low/1236.vcd" 
}
Rule PlayerPositiveMedic
{
	criteria ConceptPlayerPositive IsMedic
	Response PlayerPositiveMedic
}

Response PlayerTauntsMedic
{
	scene "scenes/Player/Medic/low/604.vcd" 
	scene "scenes/Player/Medic/low/1228.vcd" 
	scene "scenes/Player/Medic/low/1231.vcd" 
	scene "scenes/Player/Medic/low/609.vcd" 
	scene "scenes/Player/Medic/low/610.vcd" 
}
Rule PlayerTauntsMedic
{
	criteria ConceptPlayerTaunts IsMedic
	Response PlayerTauntsMedic
}

