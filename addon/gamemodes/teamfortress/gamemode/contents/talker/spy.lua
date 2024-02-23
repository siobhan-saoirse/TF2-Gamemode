//--------------------------------------------------------------------------------------------------------------
// Spy Response Rule File
//--------------------------------------------------------------------------------------------------------------

Criterion "SpyIsNotStillonFire" "SpyOnFire" "!=1" "required" weight 0
Criterion "SpyIsStillonFire" "SpyOnFire" "1" "required" weight 0
Criterion "SpyNotKillSpeech" "SpyKillSpeech" "!=1" "required" weight 0
Criterion "SpyNotKillSpeechMelee" "SpyKillSpeechMelee" "!=1" "required" weight 0
Criterion "SpyNotSaidHealThanks" "SpySaidHealThanks" "!=1" "required"
Criterion "IsHelpCapSpy" "SpyHelpCap" "1" "required" weight 0


Response PlayerCloakedSpyDemomanSpy
{
	scene "scenes/Player/Spy/low/729.vcd" 
}
Rule PlayerCloakedSpyDemomanSpy
{
	criteria ConceptPlayerCloakedSpy IsSpy IsOnDemoman
	Response PlayerCloakedSpyDemomanSpy
}

Response PlayerCloakedSpyEngineerSpy
{
	scene "scenes/Player/Spy/low/735.vcd" 
}
Rule PlayerCloakedSpyEngineerSpy
{
	criteria ConceptPlayerCloakedSpy IsSpy IsOnEngineer
	Response PlayerCloakedSpyEngineerSpy
}

Response PlayerCloakedSpyHeavySpy
{
	scene "scenes/Player/Spy/low/725.vcd" 
}
Rule PlayerCloakedSpyHeavySpy
{
	criteria ConceptPlayerCloakedSpy IsSpy IsOnHeavy
	Response PlayerCloakedSpyHeavySpy
}

Response PlayerCloakedSpyMedicSpy
{
	scene "scenes/Player/Spy/low/733.vcd" 
}
Rule PlayerCloakedSpyMedicSpy
{
	criteria ConceptPlayerCloakedSpy IsSpy IsOnMedic
	Response PlayerCloakedSpyMedicSpy
}

Response PlayerCloakedSpyPyroSpy
{
	scene "scenes/Player/Spy/low/727.vcd" 
}
Rule PlayerCloakedSpyPyroSpy
{
	criteria ConceptPlayerCloakedSpy IsSpy IsOnPyro
	Response PlayerCloakedSpyPyroSpy
}

Response PlayerCloakedSpyScoutSpy
{
	scene "scenes/Player/Spy/low/721.vcd" 
}
Rule PlayerCloakedSpyScoutSpy
{
	criteria ConceptPlayerCloakedSpy IsSpy IsOnScout
	Response PlayerCloakedSpyScoutSpy
}

Response PlayerCloakedSpySniperSpy
{
	scene "scenes/Player/Spy/low/737.vcd" 
}
Rule PlayerCloakedSpySniperSpy
{
	criteria ConceptPlayerCloakedSpy IsSpy IsOnSniper
	Response PlayerCloakedSpySniperSpy
}

Response PlayerCloakedSpySoldierSpy
{
	scene "scenes/Player/Spy/low/723.vcd" 
}
Rule PlayerCloakedSpySoldierSpy
{
	criteria ConceptPlayerCloakedSpy IsSpy IsOnSoldier
	Response PlayerCloakedSpySoldierSpy
}

Response PlayerCloakedSpySpySpy
{
	scene "scenes/Player/Spy/low/731.vcd" 
	scene "scenes/Player/Spy/low/732.vcd" 
}
Rule PlayerCloakedSpySpySpy
{
	criteria ConceptPlayerCloakedSpy IsSpy IsOnSpy
	Response PlayerCloakedSpySpySpy
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech
//--------------------------------------------------------------------------------------------------------------
Response HealThanksSpy
{
	scene "scenes/Player/Spy/low/851.vcd" 
	scene "scenes/Player/Spy/low/852.vcd" 
	scene "scenes/Player/Spy/low/853.vcd" 
}
Rule HealThanksSpy
{
	criteria ConceptMedicChargeStopped IsSpy SuperHighHealthContext SpyNotSaidHealThanks 50PercentChance
	ApplyContext "SpySaidHealThanks:1:20"
	Response HealThanksSpy
}

Response PlayerRoundStartSpy
{
	scene "scenes/Player/Spy/low/708.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Spy/low/709.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Spy/low/1309.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Spy/low/707.vcd" predelay "1.0, 5.0"
}
Rule PlayerRoundStartSpy
{
	criteria ConceptPlayerRoundStart IsSpy
	Response PlayerRoundStartSpy
}

Response PlayerCappedIntelligenceSpy
{
	scene "scenes/Player/Spy/low/698.vcd" 
	scene "scenes/Player/Spy/low/699.vcd" 
	scene "scenes/Player/Spy/low/700.vcd" 
}
Rule PlayerCappedIntelligenceSpy
{
	criteria ConceptPlayerCapturedIntelligence IsSpy
	Response PlayerCappedIntelligenceSpy
}

Response PlayerCapturedPointSpy
{
	scene "scenes/Player/Spy/low/695.vcd" 
	scene "scenes/Player/Spy/low/696.vcd" 
	scene "scenes/Player/Spy/low/697.vcd" 
}
Rule PlayerCapturedPointSpy
{
	criteria ConceptPlayerCapturedPoint IsSpy
	Response PlayerCapturedPointSpy
}

Response PlayerSuddenDeathSpy
{
	scene "scenes/Player/Spy/low/766.vcd" 
	scene "scenes/Player/Spy/low/767.vcd" 
	scene "scenes/Player/Spy/low/768.vcd" 
	scene "scenes/Player/Spy/low/769.vcd" 
	scene "scenes/Player/Spy/low/771.vcd" 
	scene "scenes/Player/Spy/low/770.vcd" 
}
Rule PlayerSuddenDeathSpy
{
	criteria ConceptPlayerSuddenDeathStart IsSpy
	Response PlayerSuddenDeathSpy
}

Response PlayerStalemateSpy
{
	scene "scenes/Player/Spy/low/701.vcd" 
	scene "scenes/Player/Spy/low/702.vcd" 
	scene "scenes/Player/Spy/low/703.vcd" 
}
Rule PlayerStalemateSpy
{
	criteria ConceptPlayerStalemate IsSpy
	Response PlayerStalemateSpy
}

Response PlayerTeleporterThanksSpy
{
	scene "scenes/Player/Spy/low/854.vcd" 
	scene "scenes/Player/Spy/low/855.vcd" 
	scene "scenes/Player/Spy/low/856.vcd" 
}
Rule PlayerTeleporterThanksSpy
{
	criteria ConceptTeleported IsNotEngineer IsSpy 30PercentChance
	Response PlayerTeleporterThanksSpy
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech Combat
//--------------------------------------------------------------------------------------------------------------
Response DefendOnThePointSpy
{
	scene "scenes/Player/Spy/low/830.vcd" 
	scene "scenes/Player/Spy/low/1323.vcd" 
	scene "scenes/Player/Spy/low/1324.vcd" 
	scene "scenes/Player/Spy/low/1325.vcd" 
}
Rule DefendOnThePointSpy
{
	criteria ConceptFireWeapon IsSpy IsOnFriendlyControlPoint NotDefendOnThePointSpeech
	ApplyContext "DefendOnThePointSpeech:1:30"
	applycontexttoworld
	Response DefendOnThePointSpy
}

Response KilledPlayerManySpy
{
	scene "scenes/Player/Spy/low/772.vcd" 
	scene "scenes/Player/Spy/low/1312.vcd" 
	scene "scenes/Player/Spy/low/773.vcd" 
	scene "scenes/Player/Spy/low/774.vcd" 
	scene "scenes/Player/Spy/low/1313.vcd" 
	scene "scenes/Player/Spy/low/775.vcd" 
	scene "scenes/Player/Spy/low/1322.vcd" 
	scene "scenes/Player/Spy/low/824.vcd" 
	scene "scenes/Player/Spy/low/825.vcd" 
}
Rule KilledPlayerManySpy
{
	criteria ConceptKilledPlayer IsManyRecentKills 30PercentChance IsWeaponPrimary KilledPlayerDelay SpyNotKillSpeech IsSpy
	ApplyContext "SpyKillSpeech:1:10"
	applycontexttoworld
	Response KilledPlayerManySpy
}

Response KilledPlayerMeleeSpy
{
	scene "scenes/Player/Spy/low/817.vcd" 
	scene "scenes/Player/Spy/low/818.vcd" 
	scene "scenes/Player/Spy/low/826.vcd" 
}
Rule KilledPlayerMeleeSpy
{
	criteria ConceptKilledPlayer KilledPlayerDelay 30PercentChance  IsWeaponMelee SpyNotKillSpeechMelee IsSpy
	ApplyContext "SpyKillSpeechMelee:1:10"
	applycontexttoworld
	Response KilledPlayerMeleeSpy
}

Response MedicFollowSpy
{
	scene "scenes/Player/Spy/low/3030.vcd" predelay ".25"
	scene "scenes/Player/Spy/low/3015.vcd" predelay ".25"
}
Rule MedicFollowSpy
{
	criteria ConceptPlayerMedic IsOnMedic IsSpy IsNotCrossHairEnemy
	ApplyContext "SpyKillSpeech:1:10"
	Response MedicFollowSpy
}

Response PlayerJarateHit
{
	scene "scenes/Player/Spy/low/3073.vcd" 
	scene "scenes/Player/Spy/low/3074.vcd" 
	scene "scenes/Player/Spy/low/3075.vcd" 
	scene "scenes/Player/Spy/low/3076.vcd" 
	scene "scenes/Player/Spy/low/3078.vcd" 
	scene "scenes/Player/Spy/low/3072.vcd" 
}
Rule PlayerJarateHit
{
	criteria ConceptJarateHit IsSpy
	Response PlayerJarateHit
}

Response PlayerKilledCapperSpy
{
	scene "scenes/Player/Spy/low/713.vcd" 
	scene "scenes/Player/Spy/low/716.vcd" 
	scene "scenes/Player/Spy/low/809.vcd" 
	scene "scenes/Player/Spy/low/810.vcd" 
	scene "scenes/Player/Spy/low/811.vcd" 
}
Rule PlayerKilledCapperSpy
{
	criteria ConceptCapBlocked IsSpy
	ApplyContext "SpyKillSpeech:1:10"
	Response PlayerKilledCapperSpy
}

Response PlayerKilledDominatingDemomanSpy
{
	scene "scenes/Player/Spy/low/3008.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3025.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3065.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3066.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3067.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3068.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingDemomanSpy
{
	criteria ConceptKilledPlayer IsSpy IsDominated  IsVictimDemoman
	ApplyContext "SpyKillSpeech:1:10"
	Response PlayerKilledDominatingDemomanSpy
}

Response PlayerKilledDominatingEngineerSpy
{
	scene "scenes/Player/Spy/low/3009.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3037.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3062.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3063.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3064.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3070.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingEngineerSpy
{
	criteria ConceptKilledPlayer IsSpy IsDominated  IsVictimEngineer
	ApplyContext "SpyKillSpeech:1:10"
	Response PlayerKilledDominatingEngineerSpy
}

Response PlayerKilledDominatingHeavySpy
{
	scene "scenes/Player/Spy/low/3019.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3024.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3031.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3056.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3057.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3058.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3069.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3055.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingHeavySpy
{
	criteria ConceptKilledPlayer IsSpy IsDominated  IsVictimHeavy
	ApplyContext "SpyKillSpeech:1:10"
	Response PlayerKilledDominatingHeavySpy
}

Response PlayerKilledDominatingMedicSpy
{
	scene "scenes/Player/Spy/low/3026.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3027.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3028.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3029.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3040.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3071.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingMedicSpy
{
	criteria ConceptKilledPlayer IsSpy IsDominated  IsVictimMedic
	ApplyContext "SpyKillSpeech:1:10"
	Response PlayerKilledDominatingMedicSpy
}

Response PlayerKilledDominatingPyroSpy
{
	scene "scenes/Player/Spy/low/3010.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3022.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3041.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3042.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3032.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingPyroSpy
{
	criteria ConceptKilledPlayer IsSpy IsDominated  IsVictimPyro
	ApplyContext "SpyKillSpeech:1:10"
	Response PlayerKilledDominatingPyroSpy
}

Response PlayerKilledDominatingScoutSpy
{
	scene "scenes/Player/Spy/low/3011.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3043.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3044.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3045.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3046.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3047.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3048.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3049.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingScoutSpy
{
	criteria ConceptKilledPlayer IsSpy IsDominated  IsVictimScout
	ApplyContext "SpyKillSpeech:1:10"
	Response PlayerKilledDominatingScoutSpy
}

Response PlayerKilledDominatingSniperSpy
{
	scene "scenes/Player/Spy/low/3012.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3020.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3033.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3050.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3036.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3052.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3051.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingSniperSpy
{
	criteria ConceptKilledPlayer IsSpy IsDominated  IsVictimSniper
	ApplyContext "SpyKillSpeech:1:10"
	Response PlayerKilledDominatingSniperSpy
}

Response PlayerKilledDominatingSoldierSpy
{
	scene "scenes/Player/Spy/low/3013.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3034.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3053.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3054.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3061.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingSoldierSpy
{
	criteria ConceptKilledPlayer IsSpy IsDominated  IsVictimSoldier
	ApplyContext "SpyKillSpeech:1:10"
	Response PlayerKilledDominatingSoldierSpy
}

Response PlayerKilledDominatingSpySpy
{
	scene "scenes/Player/Spy/low/3014.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3021.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3059.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3077.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/3060.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingSpySpy
{
	criteria ConceptKilledPlayer IsSpy IsDominated  IsVictimSpy
	ApplyContext "SpyKillSpeech:1:10"
	Response PlayerKilledDominatingSpySpy
}

Response PlayerKilledForRevengeSpy
{
	scene "scenes/Player/Spy/low/710.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/715.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/743.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/812.vcd" predelay "2.5"
	scene "scenes/Player/Spy/low/813.vcd" predelay "2.5"
}
Rule PlayerKilledForRevengeSpy
{
	criteria ConceptKilledPlayer IsSpy IsRevenge
	ApplyContext "SpyKillSpeech:1:10"
	Response PlayerKilledForRevengeSpy
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech Pain
//--------------------------------------------------------------------------------------------------------------
Response PlayerAttackerPainSpy
{
	scene "scenes/Player/Spy/low/803.vcd" 
	scene "scenes/Player/Spy/low/804.vcd" 
	scene "scenes/Player/Spy/low/805.vcd" 
	scene "scenes/Player/Spy/low/1387.vcd" 
	scene "scenes/Player/Spy/low/1388.vcd" 
}
Rule PlayerAttackerPainSpy
{
	criteria ConceptAttackerPain IsSpy
	Response PlayerAttackerPainSpy
}

Response PlayerOnFireSpy
{
	scene "scenes/Player/Spy/low/704.vcd" 
}
Rule PlayerOnFireSpy
{
	criteria ConceptFire IsSpy SpyIsNotStillonFire
	ApplyContext "SpyOnFire:1:7"
	Response PlayerOnFireSpy
}

Response PlayerOnFireRareSpy
{
	scene "scenes/Player/Spy/low/705.vcd" 
	scene "scenes/Player/Spy/low/706.vcd" 
}
Rule PlayerOnFireRareSpy
{
	criteria ConceptFire IsSpy 10PercentChance SpyIsNotStillonFire
	ApplyContext "SpyOnFire:1:7"
	Response PlayerOnFireRareSpy
}

Response PlayerPainSpy
{
	scene "scenes/Player/Spy/low/806.vcd" 
	scene "scenes/Player/Spy/low/807.vcd" 
	scene "scenes/Player/Spy/low/808.vcd" 
	scene "scenes/Player/Spy/low/1381.vcd" 
}
Rule PlayerPainSpy
{
	criteria ConceptPain IsSpy
	Response PlayerPainSpy
}

Response PlayerStillOnFireSpy
{
	scene "scenes/Player/Spy/low/1928.vcd" 
}
Rule PlayerStillOnFireSpy
{
	criteria ConceptFire IsSpy  SpyIsStillonFire
	ApplyContext "SpyOnFire:1:7"
	Response PlayerStillOnFireSpy
}


//--------------------------------------------------------------------------------------------------------------
// Duel Speech
//--------------------------------------------------------------------------------------------------------------
Response AcceptedDuelSpy
{
	scene "scenes/Player/Spy/low/709.vcd" 
	scene "scenes/Player/Spy/low/834.vcd" 
	scene "scenes/Player/Spy/low/833.vcd" 
	scene "scenes/Player/Spy/low/845.vcd" 
	scene "scenes/Player/Spy/low/847.vcd" 
	scene "scenes/Player/Spy/low/858.vcd" 
	scene "scenes/Player/Spy/low/859.vcd" 
}
Rule AcceptedDuelSpy
{
	criteria ConceptIAcceptDuel IsSpy
	Response AcceptedDuelSpy
}

Response MeleeDareSpy
{
	scene "scenes/Player/Spy/low/3016.vcd" 
	scene "scenes/Player/Spy/low/3023.vcd" 
}
Rule MeleeDareSpy
{
	criteria ConceptRequestDuel IsSpy
	Response MeleeDareSpy
}

Response RejectedDuelSpy
{
	scene "scenes/Player/Spy/low/703.vcd" 
	scene "scenes/Player/Spy/low/790.vcd" 
	scene "scenes/Player/Spy/low/791.vcd" 
	scene "scenes/Player/Spy/low/824.vcd" 
	scene "scenes/Player/Spy/low/825.vcd" 
	scene "scenes/Player/Spy/low/831.vcd" 
}
Rule RejectedDuelSpy
{
	criteria ConceptDuelRejected IsSpy
	Response RejectedDuelSpy
}


//--------------------------------------------------------------------------------------------------------------
// Speech Menu 1
//--------------------------------------------------------------------------------------------------------------
Response PlayerGoSpy
{
	scene "scenes/Player/Spy/low/740.vcd" 
	scene "scenes/Player/Spy/low/741.vcd" 
	scene "scenes/Player/Spy/low/742.vcd" 
}
Rule PlayerGoSpy
{
	criteria ConceptPlayerGo IsSpy
	Response PlayerGoSpy
}

Response PlayerHeadLeftSpy
{
	scene "scenes/Player/Spy/low/746.vcd" 
	scene "scenes/Player/Spy/low/747.vcd" 
	scene "scenes/Player/Spy/low/748.vcd" 
}
Rule PlayerHeadLeftSpy
{
	criteria ConceptPlayerLeft  IsSpy
	Response PlayerHeadLeftSpy
}

Response PlayerHeadRightSpy
{
	scene "scenes/Player/Spy/low/749.vcd" 
	scene "scenes/Player/Spy/low/750.vcd" 
	scene "scenes/Player/Spy/low/751.vcd" 
}
Rule PlayerHeadRightSpy
{
	criteria ConceptPlayerRight  IsSpy
	Response PlayerHeadRightSpy
}

Response PlayerHelpSpy
{
	scene "scenes/Player/Spy/low/752.vcd" 
	scene "scenes/Player/Spy/low/753.vcd" 
	scene "scenes/Player/Spy/low/754.vcd" 
}
Response MvMSniperCalloutSpy
{
	scene "scenes/Player/Spy/low/sniper01.vcd" 
	scene "scenes/Player/Spy/low/sniper02.vcd" 
	scene "scenes/Player/Spy/low/sniper03.vcd" 
}
Rule MvMSniperCalloutSpy
{
	criteria ConceptMvMSniperCallout IsSpy
	Response MvMSniperCalloutSpy
}
Rule PlayerHelpSpy
{
	criteria ConceptPlayerHelp IsSpy
	Response PlayerHelpSpy
}

Response PlayerHelpCaptureSpy
{
	scene "scenes/Player/Spy/low/755.vcd" 
	scene "scenes/Player/Spy/low/756.vcd" 
	scene "scenes/Player/Spy/low/757.vcd" 
}
Rule PlayerHelpCaptureSpy
{
	criteria ConceptPlayerHelp IsSpy IsOnCappableControlPoint
	ApplyContext "SpyHelpCap:1:10"
	Response PlayerHelpCaptureSpy
}

Response PlayerHelpCapture2Spy
{
	scene "scenes/Player/Spy/low/830.vcd" 
	scene "scenes/Player/Spy/low/1323.vcd" 
	scene "scenes/Player/Spy/low/1324.vcd" 
	scene "scenes/Player/Spy/low/1325.vcd" 
}
Rule PlayerHelpCapture2Spy
{
	criteria ConceptPlayerHelp IsSpy IsOnCappableControlPoint IsHelpCapSpy
	Response PlayerHelpCapture2Spy
}

Response PlayerHelpDefendSpy
{
	scene "scenes/Player/Spy/low/758.vcd" 
	scene "scenes/Player/Spy/low/759.vcd" 
	scene "scenes/Player/Spy/low/760.vcd" 
}
Rule PlayerHelpDefendSpy
{
	criteria ConceptPlayerHelp IsSpy IsOnFriendlyControlPoint
	Response PlayerHelpDefendSpy
}

Response PlayerMedicSpy
{
	scene "scenes/Player/Spy/low/779.vcd" 
	scene "scenes/Player/Spy/low/780.vcd" 
	scene "scenes/Player/Spy/low/781.vcd" 
}
Rule PlayerMedicSpy
{
	criteria ConceptPlayerMedic IsSpy
	Response PlayerMedicSpy
}

Response PlayerMoveUpSpy
{
	scene "scenes/Player/Spy/low/782.vcd" 
	scene "scenes/Player/Spy/low/1317.vcd" 
}
Rule PlayerMoveUpSpy
{
	criteria ConceptPlayerMoveUp  IsSpy
	Response PlayerMoveUpSpy
}

Response PlayerNoSpy
{
	scene "scenes/Player/Spy/low/797.vcd" 
	scene "scenes/Player/Spy/low/798.vcd" 
	scene "scenes/Player/Spy/low/799.vcd" 
}
Rule PlayerNoSpy
{
	criteria ConceptPlayerNo  IsSpy
	Response PlayerNoSpy
}

Response PlayerThanksSpy
{
	scene "scenes/Player/Spy/low/849.vcd" 
	scene "scenes/Player/Spy/low/850.vcd" 
	scene "scenes/Player/Spy/low/1326.vcd" 
}
Rule PlayerThanksSpy
{
	criteria ConceptPlayerThanks IsSpy
	Response PlayerThanksSpy
}

Response PlayerYesSpy
{
	scene "scenes/Player/Spy/low/857.vcd" 
	scene "scenes/Player/Spy/low/858.vcd" 
	scene "scenes/Player/Spy/low/859.vcd" 
}
Rule PlayerYesSpy
{
	criteria ConceptPlayerYes  IsSpy
	Response PlayerYesSpy
}


//--------------------------------------------------------------------------------------------------------------
// Speech Menu 2
//--------------------------------------------------------------------------------------------------------------
Response PlayerActivateChargeSpy
{
	scene "scenes/Player/Spy/low/692.vcd" 
	scene "scenes/Player/Spy/low/693.vcd" 
	scene "scenes/Player/Spy/low/694.vcd" 
}
Rule PlayerActivateChargeSpy
{
	criteria ConceptPlayerActivateCharge IsSpy
	Response PlayerActivateChargeSpy
}

Response PlayerCloakedSpySpy
{
	scene "scenes/Player/Spy/low/718.vcd" 
	scene "scenes/Player/Spy/low/719.vcd" 
	scene "scenes/Player/Spy/low/720.vcd" 
	scene "scenes/Player/Spy/low/1310.vcd" 
}
Rule PlayerCloakedSpySpy
{
	criteria ConceptPlayerCloakedSpy IsSpy
	Response PlayerCloakedSpySpy
}

Response PlayerDispenserHereSpy
{
	scene "scenes/Player/Spy/low/783.vcd" 
}
Rule PlayerDispenserHereSpy
{
	criteria ConceptPlayerDispenserHere IsSpy
	Response PlayerDispenserHereSpy
}

Response PlayerIncomingSpy
{
	scene "scenes/Player/Spy/low/761.vcd" 
	scene "scenes/Player/Spy/low/762.vcd" 
	scene "scenes/Player/Spy/low/763.vcd" 
}
Rule PlayerIncomingSpy
{
	criteria ConceptPlayerIncoming IsSpy
	Response PlayerIncomingSpy
}

Response PlayerSentryAheadSpy
{
	scene "scenes/Player/Spy/low/815.vcd" 
	scene "scenes/Player/Spy/low/814.vcd" 
}
Rule PlayerSentryAheadSpy
{
	criteria ConceptPlayerSentryAhead IsSpy
	Response PlayerSentryAheadSpy
}

Response PlayerSentryHereSpy
{
	scene "scenes/Player/Spy/low/786.vcd" 
}
Rule PlayerSentryHereSpy
{
	criteria ConceptPlayerSentryHere IsSpy
	Response PlayerSentryHereSpy
}

Response PlayerTeleporterHereSpy
{
	scene "scenes/Player/Spy/low/788.vcd" 
}
Rule PlayerTeleporterHereSpy
{
	criteria ConceptPlayerTeleporterHere IsSpy
	Response PlayerTeleporterHereSpy
}


//--------------------------------------------------------------------------------------------------------------
// Speech Menu 3
//--------------------------------------------------------------------------------------------------------------
Response PlayerBattleCrySpy
{
	scene "scenes/Player/Spy/low/708.vcd" 
	scene "scenes/Player/Spy/low/709.vcd" 
	scene "scenes/Player/Spy/low/1309.vcd" 
	scene "scenes/Player/Spy/low/707.vcd" 
}
Rule PlayerBattleCrySpy
{
	criteria ConceptPlayerBattleCry IsSpy
	Response PlayerBattleCrySpy
}

Response PlayerCheersSpy
{
	scene "scenes/Player/Spy/low/710.vcd" 
	scene "scenes/Player/Spy/low/711.vcd" 
	scene "scenes/Player/Spy/low/712.vcd" 
	scene "scenes/Player/Spy/low/713.vcd" 
	scene "scenes/Player/Spy/low/714.vcd" 
	scene "scenes/Player/Spy/low/715.vcd" 
	scene "scenes/Player/Spy/low/716.vcd" 
	scene "scenes/Player/Spy/low/717.vcd" 
}
Rule PlayerCheersSpy
{
	criteria ConceptPlayerCheers IsSpy
	Response PlayerCheersSpy
}

Response PlayerDisguisedTauntsSpy
{
	scene "scenes/Player/Spy/low/840.vcd" 
	scene "scenes/Player/Spy/low/839.vcd" 
}
Rule PlayerDisguisedTauntsSpy
{
	criteria ConceptPlayerTaunts IsDisguised IsSpy
	Response PlayerDisguisedTauntsSpy
}

Response PlayerGoodJobSpy
{
	scene "scenes/Player/Spy/low/743.vcd" 
	scene "scenes/Player/Spy/low/744.vcd" 
	scene "scenes/Player/Spy/low/745.vcd" 
}
Rule PlayerGoodJobSpy
{
	criteria ConceptPlayerGoodJob IsSpy
	Response PlayerGoodJobSpy
}

Response PlayerJeersSpy
{
	scene "scenes/Player/Spy/low/766.vcd" 
	scene "scenes/Player/Spy/low/767.vcd" 
	scene "scenes/Player/Spy/low/768.vcd" 
	scene "scenes/Player/Spy/low/769.vcd" 
	scene "scenes/Player/Spy/low/771.vcd" 
	scene "scenes/Player/Spy/low/770.vcd" 
}
Rule PlayerJeersSpy
{
	criteria ConceptPlayerJeers IsSpy
	Response PlayerJeersSpy
}

Response PlayerLostPointSpy
{
	scene "scenes/Player/Spy/low/792.vcd" 
	scene "scenes/Player/Spy/low/793.vcd" 
	scene "scenes/Player/Spy/low/790.vcd" 
	scene "scenes/Player/Spy/low/791.vcd" 
	scene "scenes/Player/Spy/low/789.vcd" 
	scene "scenes/Player/Spy/low/1318.vcd" 
	scene "scenes/Player/Spy/low/1319.vcd" 
	scene "scenes/Player/Spy/low/1320.vcd" 
	scene "scenes/Player/Spy/low/1321.vcd" 
}
Rule PlayerLostPointSpy
{
	criteria ConceptPlayerLostPoint IsSpy
	Response PlayerLostPointSpy
}

Response PlayerNegativeSpy
{
	scene "scenes/Player/Spy/low/792.vcd" 
	scene "scenes/Player/Spy/low/793.vcd" 
	scene "scenes/Player/Spy/low/790.vcd" 
	scene "scenes/Player/Spy/low/791.vcd" 
	scene "scenes/Player/Spy/low/789.vcd" 
	scene "scenes/Player/Spy/low/1318.vcd" 
	scene "scenes/Player/Spy/low/1319.vcd" 
	scene "scenes/Player/Spy/low/1320.vcd" 
	scene "scenes/Player/Spy/low/1321.vcd" 
}
Rule PlayerNegativeSpy
{
	criteria ConceptPlayerNegative IsSpy
	Response PlayerNegativeSpy
}

Response PlayerNiceShotSpy
{
	scene "scenes/Player/Spy/low/794.vcd" 
	scene "scenes/Player/Spy/low/795.vcd" 
	scene "scenes/Player/Spy/low/796.vcd" 
}
Rule PlayerNiceShotSpy
{
	criteria ConceptPlayerNiceShot IsSpy
	Response PlayerNiceShotSpy
}

Response PlayerPositiveSpy
{
	scene "scenes/Player/Spy/low/809.vcd" 
	scene "scenes/Player/Spy/low/810.vcd" 
	scene "scenes/Player/Spy/low/811.vcd" 
	scene "scenes/Player/Spy/low/812.vcd" 
	scene "scenes/Player/Spy/low/813.vcd" 
}
Rule PlayerPositiveSpy
{
	criteria ConceptPlayerPositive IsSpy
	Response PlayerPositiveSpy
}

Response PlayerTauntsSpy
{
	scene "scenes/Player/Spy/low/777.vcd" 
	scene "scenes/Player/Spy/low/778.vcd" 
	scene "scenes/Player/Spy/low/1314.vcd" 
	scene "scenes/Player/Spy/low/1315.vcd" 
	scene "scenes/Player/Spy/low/1316.vcd" 
}
Rule PlayerTauntsSpy
{
	criteria ConceptPlayerTaunts IsSpy
	Response PlayerTauntsSpy
}

