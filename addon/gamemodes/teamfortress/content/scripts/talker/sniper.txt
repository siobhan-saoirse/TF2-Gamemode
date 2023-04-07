//--------------------------------------------------------------------------------------------------------------
// Sniper Response Rule File
//--------------------------------------------------------------------------------------------------------------

Criterion "SniperIsNotStillonFire" "SniperOnFire" "!=1" "required" weight 0
Criterion "SniperIsStillonFire" "SniperOnFire" "1" "required" weight 0
Criterion "SniperNotKillSpeech" "SniperKillSpeech" "!=1" "required" weight 0
Criterion "SniperNotKillSpeechMelee" "SniperKillSpeechMelee" "!=1" "required" weight 0
Criterion "SniperNotSaidCartMovingBackwardD" "SaidCartMovingBackwardD" "!=1" "required" weight 0
Criterion "SniperNotSaidHealThanks" "SniperSaidHealThanks" "!=1" "required"
Criterion "IsHelpCapSniper" "SniperHelpCap" "1" "required" weight 0


// Custom stuff
Response SniperJarateHit
{
	scene "scenes/Player/Sniper/low/1608.vcd"    
	scene "scenes/Player/Sniper/low/1688.vcd"    
	scene "scenes/Player/Sniper/low/1689.vcd"    
}
Rule SniperJarateHit
{
	criteria ConceptJarateHit IsSniper 50PercentChance
	Response SniperJarateHit
}

Response SniperJarateHitScoped
{
	scene "scenes/Player/Sniper/low/1780.vcd"    
	scene "scenes/Player/Sniper/low/1690.vcd"    
	scene "scenes/Player/Sniper/low/1778.vcd"    
}
Rule SniperJarateHitScoped
{
	criteria ConceptJarateHit IsSniper DeployedContext
	Response SniperJarateHitScoped
}

Response PlayerCloakedSpyDemomanSniper
{
	scene "scenes/Player/Sniper/low/1633.vcd" 
}
Rule PlayerCloakedSpyDemomanSniper
{
	criteria ConceptPlayerCloakedSpy IsSniper IsOnDemoman
	Response PlayerCloakedSpyDemomanSniper
}

Response PlayerCloakedSpyEngineerSniper
{
	scene "scenes/Player/Sniper/low/1636.vcd" 
}
Rule PlayerCloakedSpyEngineerSniper
{
	criteria ConceptPlayerCloakedSpy IsSniper IsOnEngineer
	Response PlayerCloakedSpyEngineerSniper
}


// Custom stuff - melee dare
// Look at enemy, then do battle cry voice command while holding a melee weapon.
Response MeleeDareCombatSniper
{
	scene "scenes/Player/Sniper/low/2319.vcd"
	scene "scenes/Player/Sniper/low/2320.vcd"
	scene "scenes/Player/Sniper/low/2321.vcd"
	scene "scenes/Player/Sniper/low/2369.vcd"
	scene "scenes/Player/Sniper/low/2372.vcd"
	scene "scenes/Player/Sniper/low/2373.vcd"
	scene "scenes/Player/Sniper/low/2374.vcd"
	scene "scenes/Player/Sniper/low/2388.vcd"
	scene "scenes/Player/Sniper/low/2389.vcd"
}
Rule MeleeDareCombatSniper
{
	criteria ConceptPlayerBattleCry IsWeaponMelee IsSniper IsCrossHairEnemy
	Response MeleeDareCombatSniper
}

Response PlayerCloakedSpyHeavySniper
{
	scene "scenes/Player/Sniper/low/1631.vcd" 
}
Rule PlayerCloakedSpyHeavySniper
{
	criteria ConceptPlayerCloakedSpy IsSniper IsOnHeavy
	Response PlayerCloakedSpyHeavySniper
}

Response PlayerCloakedSpyMedicSniper
{
	scene "scenes/Player/Sniper/low/1635.vcd" 
}
Rule PlayerCloakedSpyMedicSniper
{
	criteria ConceptPlayerCloakedSpy IsSniper IsOnMedic
	Response PlayerCloakedSpyMedicSniper
}

Response PlayerCloakedSpyPyroSniper
{
	scene "scenes/Player/Sniper/low/1632.vcd" 
}
Rule PlayerCloakedSpyPyroSniper
{
	criteria ConceptPlayerCloakedSpy IsSniper IsOnPyro
	Response PlayerCloakedSpyPyroSniper
}

Response PlayerCloakedSpyScoutSniper
{
	scene "scenes/Player/Sniper/low/1629.vcd" 
}
Rule PlayerCloakedSpyScoutSniper
{
	criteria ConceptPlayerCloakedSpy IsSniper IsOnScout
	Response PlayerCloakedSpyScoutSniper
}

Response PlayerCloakedSpySniperSniper
{
	scene "scenes/Player/Sniper/low/1637.vcd" 
}
Rule PlayerCloakedSpySniperSniper
{
	criteria ConceptPlayerCloakedSpy IsSniper IsOnSniper
	Response PlayerCloakedSpySniperSniper
}

Response PlayerCloakedSpySoldierSniper
{
	scene "scenes/Player/Sniper/low/1630.vcd" 
}
Rule PlayerCloakedSpySoldierSniper
{
	criteria ConceptPlayerCloakedSpy IsSniper IsOnSoldier
	Response PlayerCloakedSpySoldierSniper
}

Response PlayerCloakedSpySpySniper
{
	scene "scenes/Player/Sniper/low/1634.vcd" 
}
Rule PlayerCloakedSpySpySniper
{
	criteria ConceptPlayerCloakedSpy IsSniper IsOnSpy
	Response PlayerCloakedSpySpySniper
}

Response SniperHeadShotKillSoldier
{
	scene "scenes/Player/Sniper/low/1719.vcd" predelay "1.75"
	scene "scenes/Player/Sniper/low/1725.vcd" predelay "1.75"
	scene "scenes/Player/Sniper/low/1727.vcd" predelay "1.75"
	scene "scenes/Player/Sniper/low/1731.vcd" predelay "1.75"
}
Rule SniperHeadShotKillSoldier
{
	criteria ConceptKilledPlayer IsSniper   50PercentChance IsVictimSoldier
	ApplyContext "SniperKillSpeech:1:10"
	Response SniperHeadShotKillSoldier
}

Response SniperHeadShotKillSpy
{
	scene "scenes/Player/Sniper/low/1712.vcd" predelay "1.75"
	scene "scenes/Player/Sniper/low/1723.vcd" predelay "1.75"
	scene "scenes/Player/Sniper/low/1729.vcd" predelay "1.75"
	scene "scenes/Player/Sniper/low/1732.vcd" predelay "1.75"
	scene "scenes/Player/Sniper/low/1805.vcd" predelay "1.75"
	scene "scenes/Player/Sniper/low/1806.vcd" predelay "1.75"
	scene "scenes/Player/Sniper/low/1808.vcd" predelay "1.75"
}
Rule SniperHeadShotKillSpy
{
	criteria ConceptKilledPlayer IsSniper   50PercentChance IsVictimSpy
	ApplyContext "SniperKillSpeech:1:10"
	Response SniperHeadShotKillSpy
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech
//--------------------------------------------------------------------------------------------------------------
Response HealThanksSniper
{
	scene "scenes/Player/Sniper/low/1761.vcd" 
	scene "scenes/Player/Sniper/low/1762.vcd" 
	scene "scenes/Player/Sniper/low/1763.vcd" 
}
Rule HealThanksSniper
{
	criteria ConceptMedicChargeStopped IsSniper SuperHighHealthContext SniperNotSaidHealThanks 50PercentChance
	ApplyContext "SniperSaidHealThanks:1:20"
	Response HealThanksSniper
}

Response PlayerRoundStartSniper
{
	scene "scenes/Player/Sniper/low/1612.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Sniper/low/1613.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Sniper/low/1614.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Sniper/low/1615.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Sniper/low/1616.vcd" predelay "1.0, 5.0"
	scene "scenes/Player/Sniper/low/1617.vcd" predelay "1.0, 5.0"
}
Rule PlayerRoundStartSniper
{
	criteria ConceptPlayerRoundStart IsSniper
	Response PlayerRoundStartSniper
}

Response PlayerCappedIntelligenceSniper
{
	scene "scenes/Player/Sniper/low/1603.vcd" 
	scene "scenes/Player/Sniper/low/1604.vcd" 
	scene "scenes/Player/Sniper/low/1605.vcd" 
	scene "scenes/Player/Sniper/low/1771.vcd" 
	scene "scenes/Player/Sniper/low/1772.vcd" 
}
Rule PlayerCappedIntelligenceSniper
{
	criteria ConceptPlayerCapturedIntelligence IsSniper
	Response PlayerCappedIntelligenceSniper
}

Response PlayerCapturedPointSniper
{
	scene "scenes/Player/Sniper/low/1600.vcd" 
	scene "scenes/Player/Sniper/low/1601.vcd" 
	scene "scenes/Player/Sniper/low/1602.vcd" 
}
Rule PlayerCapturedPointSniper
{
	criteria ConceptPlayerCapturedPoint IsSniper
	Response PlayerCapturedPointSniper
}

Response PlayerSuddenDeathSniper
{
	scene "scenes/Player/Sniper/low/1662.vcd" 
	scene "scenes/Player/Sniper/low/1663.vcd" 
	scene "scenes/Player/Sniper/low/1664.vcd" 
	scene "scenes/Player/Sniper/low/1665.vcd" 
	scene "scenes/Player/Sniper/low/1666.vcd" 
	scene "scenes/Player/Sniper/low/1667.vcd" 
	scene "scenes/Player/Sniper/low/1668.vcd" 
	scene "scenes/Player/Sniper/low/1669.vcd" 
}
Rule PlayerSuddenDeathSniper
{
	criteria ConceptPlayerSuddenDeathStart IsSniper
	Response PlayerSuddenDeathSniper
}

Response PlayerStalemateSniper
{
	scene "scenes/Player/Sniper/low/1606.vcd" 
	scene "scenes/Player/Sniper/low/1607.vcd" 
	scene "scenes/Player/Sniper/low/1608.vcd" 
}
Rule PlayerStalemateSniper
{
	criteria ConceptPlayerStalemate IsSniper
	Response PlayerStalemateSniper
}

Response PlayerTeleporterThanksSniper
{
	scene "scenes/Player/Sniper/low/1764.vcd" 
	scene "scenes/Player/Sniper/low/1765.vcd" 
	scene "scenes/Player/Sniper/low/1766.vcd" 
}
Rule PlayerTeleporterThanksSniper
{
	criteria ConceptTeleported IsNotEngineer IsSniper 30PercentChance
	Response PlayerTeleporterThanksSniper
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech Cart
//--------------------------------------------------------------------------------------------------------------
Response CartMovingBackwardsDefenseSniper
{
	scene "scenes/Player/Sniper/low/2334.vcd" 
	scene "scenes/Player/Sniper/low/2335.vcd" 
	scene "scenes/Player/Sniper/low/2336.vcd" 
	scene "scenes/Player/Sniper/low/2352.vcd" 
	scene "scenes/Player/Sniper/low/2431.vcd" 
	scene "scenes/Player/Sniper/low/2432.vcd" 
	scene "scenes/Player/Sniper/low/2444.vcd" 
	scene "scenes/Player/Sniper/low/2445.vcd" 
}
Rule CartMovingBackwardsDefenseSniper
{
	criteria ConceptCartMovingBackward IsSniper SniperNotSaidCartMovingBackwardD
	ApplyContext "SaidCartMovingBackwardD:1:20"
	Response CartMovingBackwardsDefenseSniper
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech Combat
//--------------------------------------------------------------------------------------------------------------
Response DefendOnThePointSniper
{
	scene "scenes/Player/Sniper/low/1736.vcd" 
	scene "scenes/Player/Sniper/low/1737.vcd" 
}
Rule DefendOnThePointSniper
{
	criteria ConceptFireWeapon IsSniper IsOnFriendlyControlPoint NotDefendOnThePointSpeech
	ApplyContext "DefendOnThePointSpeech:1:30"
	applycontexttoworld
	Response DefendOnThePointSniper
}

Response KilledPlayerManySniper
{
	scene "scenes/Player/Sniper/low/1670.vcd" 
	scene "scenes/Player/Sniper/low/1671.vcd" 
	scene "scenes/Player/Sniper/low/1672.vcd" 
	scene "scenes/Player/Sniper/low/1673.vcd" 
	scene "scenes/Player/Sniper/low/1674.vcd" 
	scene "scenes/Player/Sniper/low/1675.vcd" 
	scene "scenes/Player/Sniper/low/1715.vcd" 
	scene "scenes/Player/Sniper/low/1726.vcd" 
	scene "scenes/Player/Sniper/low/1810.vcd" 
}
Rule KilledPlayerManySniper
{
	criteria ConceptKilledPlayer IsManyRecentKills 30PercentChance IsWeaponPrimary KilledPlayerDelay SniperNotKillSpeech IsSniper
	ApplyContext "SniperKillSpeech:1:10"
	applycontexttoworld
	Response KilledPlayerManySniper
}

Response KilledPlayerMeleeSniper
{
	scene "scenes/Player/Sniper/low/1717.vcd" 
	scene "scenes/Player/Sniper/low/1720.vcd" 
}
Rule KilledPlayerMeleeSniper
{
	criteria ConceptKilledPlayer KilledPlayerDelay 30PercentChance  IsWeaponMelee SniperNotKillSpeechMelee IsSniper
	ApplyContext "SniperKillSpeechMelee:1:10"
	applycontexttoworld
	Response KilledPlayerMeleeSniper
}

Response KilledPlayerVeryManySniper
{
	scene "scenes/Player/Sniper/low/1714.vcd" 
	scene "scenes/Player/Sniper/low/1718.vcd" 
	scene "scenes/Player/Sniper/low/1721.vcd" 
	scene "scenes/Player/Sniper/low/1742.vcd" 
	scene "scenes/Player/Sniper/low/1743.vcd" 
	scene "scenes/Player/Sniper/low/1744.vcd" 
	scene "scenes/Player/Sniper/low/1748.vcd" 
	scene "scenes/Player/Sniper/low/1755.vcd" 
}
Rule KilledPlayerVeryManySniper
{
	criteria ConceptKilledPlayer IsVeryManyRecentKills 50PercentChance IsWeaponPrimary KilledPlayerDelay SniperNotKillSpeech IsSniper
	ApplyContext "SniperKillSpeech:1:10"
	applycontexttoworld
	Response KilledPlayerVeryManySniper
}

Response MedicFollowSniper
{
	scene "scenes/Player/Sniper/low/2277.vcd" predelay ".25"
	scene "scenes/Player/Sniper/low/2278.vcd" predelay ".25"
	scene "scenes/Player/Sniper/low/2279.vcd" predelay ".25"
	scene "scenes/Player/Sniper/low/2280.vcd" predelay ".25"
	scene "scenes/Player/Sniper/low/2281.vcd" predelay ".25"
}
Rule MedicFollowSniper
{
	criteria ConceptPlayerMedic IsOnMedic IsSniper IsNotCrossHairEnemy
	ApplyContext "SniperKillSpeech:1:10"
	Response MedicFollowSniper
}

Response PlayerJarateToss
{
	scene "scenes/Player/Sniper/low/3131.vcd" 
	scene "scenes/Player/Sniper/low/3132.vcd" 
	scene "scenes/Player/Sniper/low/3133.vcd" 
}
Rule PlayerJarateToss
{
	criteria ConceptJarateLaunch IsSniper
	Response PlayerJarateToss
}

Response PlayerKilledCapperSniper
{
	scene "scenes/Player/Sniper/low/1614.vcd" 
	scene "scenes/Player/Sniper/low/1619.vcd" 
	scene "scenes/Player/Sniper/low/1620.vcd" 
	scene "scenes/Player/Sniper/low/1710.vcd" 
	scene "scenes/Player/Sniper/low/1733.vcd" 
}
Rule PlayerKilledCapperSniper
{
	criteria ConceptCapBlocked IsSniper
	ApplyContext "SniperKillSpeech:1:10"
	Response PlayerKilledCapperSniper
}

Response PlayerKilledDominatingDemomanSniper
{
	scene "scenes/Player/Sniper/low/3080.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3081.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3082.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3083.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3084.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingDemomanSniper
{
	criteria ConceptKilledPlayer IsSniper IsDominated  IsVictimDemoman
	ApplyContext "SniperKillSpeech:1:10"
	Response PlayerKilledDominatingDemomanSniper
}

Response PlayerKilledDominatingEngineerSniper
{
	scene "scenes/Player/Sniper/low/3085.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3086.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3087.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3088.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3089.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3090.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingEngineerSniper
{
	criteria ConceptKilledPlayer IsSniper IsDominated  IsVictimEngineer
	ApplyContext "SniperKillSpeech:1:10"
	Response PlayerKilledDominatingEngineerSniper
}

Response PlayerKilledDominatingHeavySniper
{
	scene "scenes/Player/Sniper/low/3091.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3092.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3093.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3094.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3095.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3096.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3097.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingHeavySniper
{
	criteria ConceptKilledPlayer IsSniper IsDominated  IsVictimHeavy
	ApplyContext "SniperKillSpeech:1:10"
	Response PlayerKilledDominatingHeavySniper
}

Response PlayerKilledDominatingMedicSniper
{
	scene "scenes/Player/Sniper/low/3098.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3099.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3100.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3101.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3102.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingMedicSniper
{
	criteria ConceptKilledPlayer IsSniper IsDominated  IsVictimMedic
	ApplyContext "SniperKillSpeech:1:10"
	Response PlayerKilledDominatingMedicSniper
}

Response PlayerKilledDominatingPyroSniper
{
	scene "scenes/Player/Sniper/low/3103.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3104.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3105.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3106.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3107.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingPyroSniper
{
	criteria ConceptKilledPlayer IsSniper IsDominated  IsVictimPyro
	ApplyContext "SniperKillSpeech:1:10"
	Response PlayerKilledDominatingPyroSniper
}

Response PlayerKilledDominatingScoutSniper
{
	scene "scenes/Player/Sniper/low/3108.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3109.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3110.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3111.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3112.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingScoutSniper
{
	criteria ConceptKilledPlayer IsSniper IsDominated  IsVictimScout
	ApplyContext "SniperKillSpeech:1:10"
	Response PlayerKilledDominatingScoutSniper
}

Response PlayerKilledDominatingSniperSniper
{
	scene "scenes/Player/Sniper/low/2366.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/2397.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/2417.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/2434.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3113.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3114.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3115.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3116.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3117.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingSniperSniper
{
	criteria ConceptKilledPlayer IsSniper IsDominated  IsVictimSniper
	ApplyContext "SniperKillSpeech:1:10"
	Response PlayerKilledDominatingSniperSniper
}

Response PlayerKilledDominatingSoldierSniper
{
	scene "scenes/Player/Sniper/low/3118.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3119.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3120.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3121.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3122.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3123.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingSoldierSniper
{
	criteria ConceptKilledPlayer IsSniper IsDominated  IsVictimSoldier
	ApplyContext "SniperKillSpeech:1:10"
	Response PlayerKilledDominatingSoldierSniper
}

Response PlayerKilledDominatingSpySniper
{
	scene "scenes/Player/Sniper/low/3124.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3125.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3126.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3127.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3128.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3129.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/3130.vcd" predelay "2.5"
}
Rule PlayerKilledDominatingSpySniper
{
	criteria ConceptKilledPlayer IsSniper IsDominated  IsVictimSpy
	ApplyContext "SniperKillSpeech:1:10"
	Response PlayerKilledDominatingSpySniper
}

Response PlayerKilledForRevengeSniper
{
	scene "scenes/Player/Sniper/low/1622.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/1641.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/1708.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/1709.vcd" predelay "2.5"
	scene "scenes/Player/Sniper/low/1741.vcd" predelay "2.5"
}
Rule PlayerKilledForRevengeSniper
{
	criteria ConceptKilledPlayer IsSniper IsRevenge
	ApplyContext "SniperKillSpeech:1:10"
	Response PlayerKilledForRevengeSniper
}

Response SniperHeadShotKill
{
	scene "scenes/Player/Sniper/low/1790.vcd" predelay "1.75"
	scene "scenes/Player/Sniper/low/1795.vcd" predelay "1.75"
	scene "scenes/Player/Sniper/low/1801.vcd" predelay "1.75"
	scene "scenes/Player/Sniper/low/1802.vcd" predelay "1.75"
}
Rule SniperHeadShotKill
{
	criteria ConceptKilledPlayer IsSniper   50PercentChance
	ApplyContext "SniperKillSpeech:1:10"
	Response SniperHeadShotKill
}


//--------------------------------------------------------------------------------------------------------------
// Auto Speech Pain
//--------------------------------------------------------------------------------------------------------------
Response PlayerAttackerPainSniper
{
	scene "scenes/Player/Sniper/low/1700.vcd" 
	scene "scenes/Player/Sniper/low/1701.vcd" 
	scene "scenes/Player/Sniper/low/1702.vcd" 
	scene "scenes/Player/Sniper/low/1838.vcd" 
}
Rule PlayerAttackerPainSniper
{
	criteria ConceptAttackerPain IsSniper
	Response PlayerAttackerPainSniper
}

Response PlayerOnFireSniper
{
	scene "scenes/Player/Sniper/low/1609.vcd" 
	scene "scenes/Player/Sniper/low/1610.vcd" 
	scene "scenes/Player/Sniper/low/1611.vcd" 
}
Rule PlayerOnFireSniper
{
	criteria ConceptFire IsSniper SniperIsNotStillonFire
	ApplyContext "SniperOnFire:1:7"
	Response PlayerOnFireSniper
}

Response PlayerPainSniper
{
	scene "scenes/Player/Sniper/low/1705.vcd" 
	scene "scenes/Player/Sniper/low/1704.vcd" 
	scene "scenes/Player/Sniper/low/1703.vcd" 
	scene "scenes/Player/Sniper/low/1837.vcd" 
}
Rule PlayerPainSniper
{
	criteria ConceptPain IsSniper
	Response PlayerPainSniper
}

Response PlayerStillOnFireSniper
{
	scene "scenes/Player/Sniper/low/1929.vcd" 
}
Rule PlayerStillOnFireSniper
{
	criteria ConceptFire IsSniper  SniperIsStillonFire
	ApplyContext "SniperOnFire:1:7"
	Response PlayerStillOnFireSniper
}


//--------------------------------------------------------------------------------------------------------------
// Duel Speech
//--------------------------------------------------------------------------------------------------------------
Response AcceptedDuelSniper
{
	scene "scenes/Player/Sniper/low/2340.vcd" 
	scene "scenes/Player/Sniper/low/2341.vcd" 
	scene "scenes/Player/Sniper/low/2351.vcd" 
	scene "scenes/Player/Sniper/low/1613.vcd" 
	scene "scenes/Player/Sniper/low/1614.vcd" 
	scene "scenes/Player/Sniper/low/2321.vcd" 
	scene "scenes/Player/Sniper/low/2389.vcd" 
	scene "scenes/Player/Sniper/low/1749.vcd" 
	scene "scenes/Player/Sniper/low/1768.vcd" 
	scene "scenes/Player/Sniper/low/1769.vcd" 
}
Rule AcceptedDuelSniper
{
	criteria ConceptIAcceptDuel IsSniper
	Response AcceptedDuelSniper
}

Response MeleeDareSniper
{
	scene "scenes/Player/Sniper/low/2320.vcd" 
	scene "scenes/Player/Sniper/low/2369.vcd" 
	scene "scenes/Player/Sniper/low/2372.vcd" 
	scene "scenes/Player/Sniper/low/2373.vcd" 
}
Rule MeleeDareSniper
{
	criteria ConceptRequestDuel IsSniper
	Response MeleeDareSniper
}

Response RejectedDuelSniper
{
	scene "scenes/Player/Sniper/low/1606.vcd" 
	scene "scenes/Player/Sniper/low/1607.vcd" 
	scene "scenes/Player/Sniper/low/1608.vcd" 
	scene "scenes/Player/Sniper/low/3100.vcd" 
	scene "scenes/Player/Sniper/low/1663.vcd" 
	scene "scenes/Player/Sniper/low/1686.vcd" 
	scene "scenes/Player/Sniper/low/1687.vcd" 
	scene "scenes/Player/Sniper/low/1716.vcd" 
	scene "scenes/Player/Sniper/low/1722.vcd" 
}
Rule RejectedDuelSniper
{
	criteria ConceptDuelRejected IsSniper
	Response RejectedDuelSniper
}


//--------------------------------------------------------------------------------------------------------------
// Speech Menu 1
//--------------------------------------------------------------------------------------------------------------
Response PlayerGoSniper
{
	scene "scenes/Player/Sniper/low/1640.vcd" 
	scene "scenes/Player/Sniper/low/1639.vcd" 
	scene "scenes/Player/Sniper/low/1638.vcd" 
}
Rule PlayerGoSniper
{
	criteria ConceptPlayerGo IsSniper
	Response PlayerGoSniper
}

Response PlayerHeadLeftSniper
{
	scene "scenes/Player/Sniper/low/1644.vcd" 
	scene "scenes/Player/Sniper/low/1645.vcd" 
	scene "scenes/Player/Sniper/low/1646.vcd" 
}
Rule PlayerHeadLeftSniper
{
	criteria ConceptPlayerLeft  IsSniper
	Response PlayerHeadLeftSniper
}

Response PlayerHeadRightSniper
{
	scene "scenes/Player/Sniper/low/1647.vcd" 
	scene "scenes/Player/Sniper/low/1648.vcd" 
	scene "scenes/Player/Sniper/low/1649.vcd" 
}
Rule PlayerHeadRightSniper
{
	criteria ConceptPlayerRight  IsSniper
	Response PlayerHeadRightSniper
}

Response PlayerHelpSniper
{
	scene "scenes/Player/Sniper/low/1650.vcd" 
	scene "scenes/Player/Sniper/low/1651.vcd" 
	scene "scenes/Player/Sniper/low/1652.vcd" 
}
Rule PlayerHelpSniper
{
	criteria ConceptPlayerHelp IsSniper
	Response PlayerHelpSniper
}

Response PlayerHelpCaptureSniper
{
	scene "scenes/Player/Sniper/low/1653.vcd" 
	scene "scenes/Player/Sniper/low/1654.vcd" 
	scene "scenes/Player/Sniper/low/1655.vcd" 
}
Rule PlayerHelpCaptureSniper
{
	criteria ConceptPlayerHelp IsSniper IsOnCappableControlPoint
	ApplyContext "SniperHelpCap:1:10"
	Response PlayerHelpCaptureSniper
}

Response PlayerHelpCapture2Sniper
{
	scene "scenes/Player/Sniper/low/1736.vcd" 
	scene "scenes/Player/Sniper/low/1737.vcd" 
}
Rule PlayerHelpCapture2Sniper
{
	criteria ConceptPlayerHelp IsSniper IsOnCappableControlPoint IsHelpCapSniper
	Response PlayerHelpCapture2Sniper
}

Response PlayerHelpDefendSniper
{
	scene "scenes/Player/Sniper/low/1656.vcd" 
	scene "scenes/Player/Sniper/low/1657.vcd" 
	scene "scenes/Player/Sniper/low/1658.vcd" 
}
Rule PlayerHelpDefendSniper
{
	criteria ConceptPlayerHelp IsSniper IsOnFriendlyControlPoint
	Response PlayerHelpDefendSniper
}

Response PlayerMedicSniper
{
	scene "scenes/Player/Sniper/low/1678.vcd" 
	scene "scenes/Player/Sniper/low/1679.vcd" 
}
Rule PlayerMedicSniper
{
	criteria ConceptPlayerMedic IsSniper
	Response PlayerMedicSniper
}

Response PlayerMoveUpSniper
{
	scene "scenes/Player/Sniper/low/1681.vcd" 
	scene "scenes/Player/Sniper/low/1682.vcd" 
}
Rule PlayerMoveUpSniper
{
	criteria ConceptPlayerMoveUp  IsSniper
	Response PlayerMoveUpSniper
}

Response PlayerNoSniper
{
	scene "scenes/Player/Sniper/low/1694.vcd" 
	scene "scenes/Player/Sniper/low/1695.vcd" 
	scene "scenes/Player/Sniper/low/1696.vcd" 
	scene "scenes/Player/Sniper/low/1782.vcd" 
}
Rule PlayerNoSniper
{
	criteria ConceptPlayerNo  IsSniper
	Response PlayerNoSniper
}

Response PlayerThanksSniper
{
	scene "scenes/Player/Sniper/low/1760.vcd" 
	scene "scenes/Player/Sniper/low/1836.vcd" 
}
Rule PlayerThanksSniper
{
	criteria ConceptPlayerThanks IsSniper
	Response PlayerThanksSniper
}

Response PlayerYesSniper
{
	scene "scenes/Player/Sniper/low/1767.vcd" 
	scene "scenes/Player/Sniper/low/1768.vcd" 
	scene "scenes/Player/Sniper/low/1769.vcd" 
}
Rule PlayerYesSniper
{
	criteria ConceptPlayerYes  IsSniper
	Response PlayerYesSniper
}


//--------------------------------------------------------------------------------------------------------------
// Speech Menu 2
//--------------------------------------------------------------------------------------------------------------
Response PlayerActivateChargeSniper
{
	scene "scenes/Player/Sniper/low/1597.vcd" 
	scene "scenes/Player/Sniper/low/1599.vcd" 
	scene "scenes/Player/Sniper/low/1598.vcd" 
	scene "scenes/Player/Sniper/low/1770.vcd" 
}
Rule PlayerActivateChargeSniper
{
	criteria ConceptPlayerActivateCharge IsSniper
	Response PlayerActivateChargeSniper
}

Response PlayerCloakedSpySniper
{
	scene "scenes/Player/Sniper/low/1626.vcd" 
	scene "scenes/Player/Sniper/low/1627.vcd" 
	scene "scenes/Player/Sniper/low/1628.vcd" 
}
Rule PlayerCloakedSpySniper
{
	criteria ConceptPlayerCloakedSpy IsSniper
	Response PlayerCloakedSpySniper
}

Response PlayerDispenserHereSniper
{
	scene "scenes/Player/Sniper/low/1683.vcd" 
}
Rule PlayerDispenserHereSniper
{
	criteria ConceptPlayerDispenserHere IsSniper
	Response PlayerDispenserHereSniper
}

Response PlayerIncomingSniper
{
	scene "scenes/Player/Sniper/low/1659.vcd" 
	scene "scenes/Player/Sniper/low/1660.vcd" 
	scene "scenes/Player/Sniper/low/1661.vcd" 
	scene "scenes/Player/Sniper/low/1773.vcd" 
}
Rule PlayerIncomingSniper
{
	criteria ConceptPlayerIncoming IsSniper
	Response PlayerIncomingSniper
}

Response PlayerSentryAheadSniper
{
	scene "scenes/Player/Sniper/low/1711.vcd" 
}
Rule PlayerSentryAheadSniper
{
	criteria ConceptPlayerSentryAhead IsSniper
	Response PlayerSentryAheadSniper
}

Response PlayerSentryHereSniper
{
	scene "scenes/Player/Sniper/low/1684.vcd" 
}
Rule PlayerSentryHereSniper
{
	criteria ConceptPlayerSentryHere IsSniper
	Response PlayerSentryHereSniper
}

Response PlayerTeleporterHereSniper
{
	scene "scenes/Player/Sniper/low/1685.vcd" 
}
Rule PlayerTeleporterHereSniper
{
	criteria ConceptPlayerTeleporterHere IsSniper
	Response PlayerTeleporterHereSniper
}


//--------------------------------------------------------------------------------------------------------------
// Speech Menu 3
//--------------------------------------------------------------------------------------------------------------
Response PlayerBattleCrySniper
{
	scene "scenes/Player/Sniper/low/1612.vcd" 
	scene "scenes/Player/Sniper/low/1613.vcd" 
	scene "scenes/Player/Sniper/low/1614.vcd" 
	scene "scenes/Player/Sniper/low/1615.vcd" 
	scene "scenes/Player/Sniper/low/1616.vcd" 
	scene "scenes/Player/Sniper/low/1617.vcd" 
}
Rule PlayerBattleCrySniper
{
	criteria ConceptPlayerBattleCry IsSniper
	Response PlayerBattleCrySniper
}

Response PlayerCheersSniper
{
	scene "scenes/Player/Sniper/low/1618.vcd" 
	scene "scenes/Player/Sniper/low/1619.vcd" 
	scene "scenes/Player/Sniper/low/1620.vcd" 
	scene "scenes/Player/Sniper/low/1621.vcd" 
	scene "scenes/Player/Sniper/low/1622.vcd" 
	scene "scenes/Player/Sniper/low/1623.vcd" 
	scene "scenes/Player/Sniper/low/1624.vcd" 
	scene "scenes/Player/Sniper/low/1625.vcd" 
}
Rule PlayerCheersSniper
{
	criteria ConceptPlayerCheers IsSniper
	Response PlayerCheersSniper
}

Response PlayerGoodJobSniper
{
	scene "scenes/Player/Sniper/low/1641.vcd" 
	scene "scenes/Player/Sniper/low/1642.vcd" 
	scene "scenes/Player/Sniper/low/1643.vcd" 
}
Rule PlayerGoodJobSniper
{
	criteria ConceptPlayerGoodJob IsSniper
	Response PlayerGoodJobSniper
}

Response PlayerJeersSniper
{
	scene "scenes/Player/Sniper/low/1662.vcd" 
	scene "scenes/Player/Sniper/low/1663.vcd" 
	scene "scenes/Player/Sniper/low/1664.vcd" 
	scene "scenes/Player/Sniper/low/1665.vcd" 
	scene "scenes/Player/Sniper/low/1666.vcd" 
	scene "scenes/Player/Sniper/low/1667.vcd" 
	scene "scenes/Player/Sniper/low/1668.vcd" 
	scene "scenes/Player/Sniper/low/1669.vcd" 
}
Rule PlayerJeersSniper
{
	criteria ConceptPlayerJeers IsSniper
	Response PlayerJeersSniper
}

Response PlayerLostPointSniper
{
	scene "scenes/Player/Sniper/low/1686.vcd" 
	scene "scenes/Player/Sniper/low/1687.vcd" 
	scene "scenes/Player/Sniper/low/1688.vcd" 
	scene "scenes/Player/Sniper/low/1689.vcd" 
	scene "scenes/Player/Sniper/low/1690.vcd" 
	scene "scenes/Player/Sniper/low/1778.vcd" 
	scene "scenes/Player/Sniper/low/1779.vcd" 
	scene "scenes/Player/Sniper/low/1780.vcd" 
	scene "scenes/Player/Sniper/low/1781.vcd" 
}
Rule PlayerLostPointSniper
{
	criteria ConceptPlayerLostPoint IsSniper
	Response PlayerLostPointSniper
}

Response PlayerNegativeSniper
{
	scene "scenes/Player/Sniper/low/1686.vcd" 
	scene "scenes/Player/Sniper/low/1687.vcd" 
	scene "scenes/Player/Sniper/low/1688.vcd" 
	scene "scenes/Player/Sniper/low/1689.vcd" 
	scene "scenes/Player/Sniper/low/1690.vcd" 
	scene "scenes/Player/Sniper/low/1778.vcd" 
	scene "scenes/Player/Sniper/low/1779.vcd" 
	scene "scenes/Player/Sniper/low/1780.vcd" 
	scene "scenes/Player/Sniper/low/1781.vcd" 
}
Rule PlayerNegativeSniper
{
	criteria ConceptPlayerNegative IsSniper
	Response PlayerNegativeSniper
}

Response PlayerNiceShotSniper
{
	scene "scenes/Player/Sniper/low/1691.vcd" 
	scene "scenes/Player/Sniper/low/1692.vcd" 
	scene "scenes/Player/Sniper/low/1693.vcd" 
}
Rule PlayerNiceShotSniper
{
	criteria ConceptPlayerNiceShot IsSniper
	Response PlayerNiceShotSniper
}

Response PlayerPositiveSniper
{
	scene "scenes/Player/Sniper/low/1706.vcd" 
	scene "scenes/Player/Sniper/low/1707.vcd" 
	scene "scenes/Player/Sniper/low/1708.vcd" 
	scene "scenes/Player/Sniper/low/1709.vcd" 
	scene "scenes/Player/Sniper/low/1710.vcd" 
	scene "scenes/Player/Sniper/low/1783.vcd" 
	scene "scenes/Player/Sniper/low/1784.vcd" 
	scene "scenes/Player/Sniper/low/1785.vcd" 
	scene "scenes/Player/Sniper/low/1786.vcd" 
	scene "scenes/Player/Sniper/low/1787.vcd" 
}
Rule PlayerPositiveSniper
{
	criteria ConceptPlayerPositive IsSniper
	Response PlayerPositiveSniper
}

Response PlayerTauntsSniper
{
	scene "scenes/Player/Sniper/low/1774.vcd" 
	scene "scenes/Player/Sniper/low/1676.vcd" 
	scene "scenes/Player/Sniper/low/1677.vcd" 
	scene "scenes/Player/Sniper/low/1775.vcd" 
	scene "scenes/Player/Sniper/low/1776.vcd" 
	scene "scenes/Player/Sniper/low/1777.vcd" 
}
Rule PlayerTauntsSniper
{
	criteria ConceptPlayerTaunts IsSniper
	Response PlayerTauntsSniper
}

