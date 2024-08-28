//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
// Events 
//
"Event.MissionStart_Survival"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	
	"wave" "#music/stmusic/NoHopeInHell.wav"

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "checkpoint"	
	}
}

"Event.MissionStart_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/stmusic/SouthOfHuman.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_Mall"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"	
		"MusicMasterTags"
		{
			"loopStart" "108.197"
		}
	}
}
"Event.MissionStart_BaseLoop_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForDeath.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

"Event.MissionStart_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		 "wave"			"#music/stmusic/DeathIsACarousel.wav"
			 // "wave"			"common/null.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_Fairgrounds"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"	
		"MusicMasterTags"
		{
			"loopStart" "80.156"
		}
	}
}
"Event.MissionStart_BaseLoop_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForDeath.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}


"Event.MissionStart_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.85"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/stmusic/DiedOnTheBayou.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_Plankcountry"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"	
		"MusicMasterTags"
		{
			"loopStart" "78.347"
		}
	}
}
"Event.MissionStart_BaseLoop_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForDeath.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}
"Event.MissionStart_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/stmusic/OSweetDeath.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_Milltown"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"	
		"MusicMasterTags"
		{
			"loopStart" "74.338"
		}
	}
}
"Event.MissionStart_BaseLoop_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForDeath.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}
"Event.MissionStart_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/stmusic/DeadEasy.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_BigEasy"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"	
		"MusicMasterTags"
		{
			"loopStart" "91.555"
		}
	}
}
"Event.MissionStart_BaseLoop_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForDeath.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

// --------------------------------------------------------------------
// checkpoints
// --------------------------------------------------------------------

"Event.CheckPointIntro_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/YouHadBetterPray.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_Mall"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"NO_INTENSITY_TRACK"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForDeath.wav"
 	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

"Event.CheckPointIntro_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/YouHadBetterPray.wav"


	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_Fairgrounds"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"NO_INTENSITY_TRACK"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForDeath.wav"
 	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

"Event.CheckPointIntro_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/YouHadBetterPray.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_Plankcountry"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"NO_INTENSITY_TRACK"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForDeath.wav"
 	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

"Event.CheckPointIntro_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/YouHadBetterPray.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_Milltown"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"NO_INTENSITY_TRACK"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForDeath.wav"
 	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}
"Event.CheckPointIntro_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/YouHadBetterPray.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_BigEasy"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"NO_INTENSITY_TRACK"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForDeath.wav"
 	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}
// --------------------------------------------------------------------
// when you first leave a checkpoint
"Event.LeavingSafety_Survival"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.3"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
	}

	GameData
	{
		"MusicDelayTime"        "4.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}
"Event.LeavingSafety_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4"	//"0.3, 0.35"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/MallGermM1a.wav"
 		"wave"	"#music/mob/MallGermS1a.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}
"Event.LeavingSafety_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/FairgroundGermM1a.wav"
 		"wave"	"#music/mob/FairgroundGermM1b.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}

"Event.LeavingSafety_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/PlankGermS1a.wav"
 		"wave"	"#music/mob/PlankGermS1b.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}

"Event.LeavingSafety_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4" //"0.6, 0.6"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/MilltownGermM1a.wav"
 		"wave"	"#music/mob/MilltownGermM1b.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}
"Event.LeavingSafety_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/EasyGermX1a.wav"
 		"wave"	"#music/mob/EasyGermX1b.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}

// --------------------------------------------------------------------
// starting atmosphere after leaving checkpoint
"Event.StartAtmosphere_Survival"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
	}
}

"Event.StartAtmosphere_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
	}
}

"Event.StartAtmosphere_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
	}
}
"Event.StartAtmosphere_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
	}
}
"Event.StartAtmosphere_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
	}
}
"Event.StartAtmosphere_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
	}
}


// --------------------------------------------------------------------
// zombat music
// --------------------------------------------------------------------
// --------------------------------------------------------------------
// combat music
// --------------------------------------------------------------------
"Event.Zombat_Intro_1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_1"
		"MusicPriority"			"CRITICAL"
	}
}
// swapped for new, check A/D V.S. B/C
"Event.Zombat_1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums01c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_1"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8"
		"MusicTagDelay"         "7"
	}
}
"Event.Zombat_A_1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums01b.wav"
		"wave"			"#music/zombat/horde/Drums01d.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_1"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"

	}
}
"Event.Zombat_B_1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums01c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_1"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}

//--------------------------------------------------------------------
// --------------------------------------------------------------------
// combat music
// --------------------------------------------------------------------
"Event.Zombat_Intro_2"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_2"
		"MusicPriority"			"CRITICAL"
	}
}
// swapped out for new 2 C and D
"Event.Zombat_2"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/drums02c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_2"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}
"Event.Zombat_A_2"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/drums02d.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_2"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}
"Event.Zombat_B_2"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/drums02c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_2"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"

	}
}

//--------------------------------------------------------------------
// --------------------------------------------------------------------
// combat music
// --------------------------------------------------------------------
"Event.Zombat_Intro_3"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_3"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.Zombat_3"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums3c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_3"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"

	}
}
"Event.Zombat_A_3"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums3d.wav"
		"wave"			"#music/zombat/horde/Drums3f.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_3"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"

	}
}
"Event.Zombat_B_3"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums3c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_3"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"

		"MusicTagDelay"         "7"
	}
}



// --------------------------------------------------------------------
// combat music
// --------------------------------------------------------------------
"Event.Zombat_Intro_4"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_4"
		"MusicPriority"			"CRITICAL"
	}
}
// only b + c from old are ok, 
"Event.Zombat_4"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		
		"wave"			"#music/zombat/horde/Drums03a.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_4"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}
"Event.Zombat_A_4"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums03b.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_4"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"

	}
}
"Event.Zombat_B_4"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums03a.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_4"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}

//--------------------------------------------------------------------

// --------------------------------------------------------------------
// combat music
// --------------------------------------------------------------------
"Event.Zombat_Intro_5"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_5"
		"MusicPriority"			"CRITICAL"
	}
}
// new ones no good, don't add
"Event.Zombat_5"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums5b.wav"
		"wave"			"#music/zombat/horde/Drums5d.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_5"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}
"Event.Zombat_A_5"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums5c.wav"
		"wave"			"#music/zombat/horde/Drums5e.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_5"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}
"Event.Zombat_B_5"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{

		"wave"			"#music/zombat/horde/Drums5b.wav"
		"wave"			"#music/zombat/horde/Drums5d.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_5"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}

// --------------------------------------------------------------------
// combat music
// --------------------------------------------------------------------
"Event.Zombat_Intro_6"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_6"
		"MusicPriority"			"CRITICAL"
	}
}
// NONE OF THE 6s are good find something else 
"Event.Zombat_6"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums08a.wav"
 		"wave"			"#music/zombat/horde/Drums08b.wav"
	}

	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_6"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}

"Event.Zombat_A_6"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
 		"wave"			"#music/zombat/horde/Drums08e.wav"
 		"wave"			"#music/zombat/horde/Drums08f.wav"
	}

	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_6"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}

"Event.Zombat_B_6"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
 		"wave"			"#music/zombat/horde/Drums08a.wav"
 		"wave"			"#music/zombat/horde/Drums08b.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_6"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"

	}
}

//--------------------------------------------------------------------

// --------------------------------------------------------------------
// combat music
// --------------------------------------------------------------------
"Event.Zombat_Intro_7"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_7"
		"MusicPriority"			"CRITICAL"
	}
}
// new ones no good, using existing
"Event.Zombat_7"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{	
 		"wave"			"#music/zombat/horde/Drums7a.wav"
		"wave"			"#music/zombat/horde/Drums7c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_7"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"

	}
}
"Event.Zombat_A_7"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{

		"wave"			"#music/zombat/horde/Drums7b.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_7"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}
"Event.Zombat_B_7"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
 		"wave"			"#music/zombat/horde/Drums7a.wav"
		"wave"			"#music/zombat/horde/Drums7c.wav"

	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_7"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"

	}
}

//--------------------------------------------------------------------

// --------------------------------------------------------------------
// combat music
// --------------------------------------------------------------------
"Event.Zombat_Intro_8"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_8"
		"MusicPriority"			"CRITICAL"
	}
}
// only b + c from old are ok, 
"Event.Zombat_8"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		
		"wave"			"#music/zombat/horde/Drums8b.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_8"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}
"Event.Zombat_A_8"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums8c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_8"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"

	}
}
"Event.Zombat_B_8"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums8b.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_8"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}

// --------------------------------------------------------------------
// combat music
// --------------------------------------------------------------------
"Event.Zombat_Intro_9"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_9"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.Zombat_9"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		
		"wave"			"#music/zombat/horde/Drums09c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_9"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}
"Event.Zombat_A_9"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums09d.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_9"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"

	}
}
"Event.Zombat_B_9"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums09c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_9"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}
// --------------------------------------------------------------------
// combat music
// --------------------------------------------------------------------
"Event.Zombat_Intro_10"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_10"
		"MusicPriority"			"CRITICAL"
	}
}
// only b + c from old are ok, 
"Event.Zombat_10"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		
		"wave"			"#music/zombat/horde/Drums10b.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_10"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}
"Event.Zombat_A_10"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums10c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_10"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"

	}
}
"Event.Zombat_B_10"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums10b.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_10"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}

// --------------------------------------------------------------------
// combat music
// --------------------------------------------------------------------
"Event.Zombat_Intro_11"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_11"
		"MusicPriority"			"CRITICAL"
	}
}
// only b + c from old are ok, 
"Event.Zombat_11"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums11c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_11"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}
"Event.Zombat_A_11"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums11d.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_11"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"

	}
}
"Event.Zombat_B_11"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/horde/Drums11c.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_11"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "8.0"
		"MusicTagDelay"         "7"
	}
}







// old 4a b c but deleted

// new 09c,d, b(alt) = good 
// 10  b c
// 11 c d


// --------------------------------------------------------------------
//  Survival
// --------------------------------------------------------------------
"Event.Zombat2_Intro_Survival"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"
	
	"wave"			"#music/zombat/slayer/lectric/Slayer_01a.wav"

	GameData
	{
		"MusicTrack"            "zombat2c"
		"MusicTagIndex"         "0"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags"	"4.0"
	}
}
// -------------------------------------------------------------------------------------------
// Danger 
// -------------------------------------------------------------------------------------------
"Event.Zombat3_Intro_Survival"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
		"wave"			"#music/zombat/danger/HordeDanger_02.wav"
		"wave"			"#music/zombat/danger/HordeDanger_03.wav"
		"wave"			"#music/zombat/danger/HordeDanger_04.wav"
	}

	GameData
	{
// 		"MusicAutoQueue"        "Event.Zombat3_A_coldstream"
		"MusicTrack"            "zombat3"
// 		"MusicTagDelay"         "1, 7"
// 		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

// --------------------------------------------------------------------
//  C1  Mall
// --------------------------------------------------------------------

"Event.Zombat2_Intro_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	// "rndwave"
	// {
		"wave"			"#music/zombat/slayer/lectric/Slayer_01a.wav"

	// }


	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Mall"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}

// --------------------------------------------------------------------
// Danger
// --------------------------------------------------------------------
"Event.Zombat3_Intro_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/banjo/banjo_01a_02.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01a_03.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01a_04.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01a_05.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01a_06.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01b_01.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01b_02.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01b_03.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01b_04.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01c_01.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01c_02.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01c_03.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01c_04.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01c_05.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01c_06.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_A_Mall"
		"MusicTrack"            "zombat3"
		"MusicTagDelay"         "1, 7"
			//	"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.Zombat3_A_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/banjo/banjo_02_01.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_02_02.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_02_03.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_02_04.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_02_05.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_02_06.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_02_07.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_02_08.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_02_09.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_02_10.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_02_11.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_02_12.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_02_13.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_02_14.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_02_15.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_03_01.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_03_02.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_03_03.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_03_04.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_03_05.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_03_06.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_03_07.wav"
	}


	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_B_Mall"
		"MusicTrack"            "zombat3"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicTagDelay"         "1, 7"
	}
}
"Event.Zombat3_B_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/banjo/banjo_01a_02.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01a_03.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01a_04.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01a_05.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01a_06.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01b_01.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01b_02.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01b_03.wav"
		"wave"			"#music/zombat/danger/banjo/banjo_01b_04.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01c_01.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01c_02.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01c_03.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01c_04.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01c_05.wav"
		// "wave"			"#music/zombat/danger/banjo/banjo_01c_06.wav"
	}

	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_A_Mall"
		"MusicTrack"            "zombat3"
		"MusicTagTrack"         "zombat"
		"MusicTagDelay"         "1, 7"
		"MusicPriority"			"CRITICAL"
	}
}



// // --------------------------------------------------------------------
// // A2 Fairgrounds
// // --------------------------------------------------------------------
"Event.Zombat_Intro_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_Fairgrounds"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.Zombat_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		
		"wave"			"#music/zombat/Snare_Horde_01_01a.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_Fairgrounds"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		// "MusicMasterDivTags" "8.0"
 		"MusicMasterTags"
		{
			"tag1" "1.033"
			"tag2" "2.806"
			"tag3" "5.647"
		}
	}
}
"Event.Zombat_A_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/Snare_Horde_01_01a.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_Fairgrounds"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "2"
		"MusicPriority"			"CRITICAL"
		// "MusicMasterDivTags" "8.0"
 		"MusicMasterTags"
		{
			"tag1" "1.033"
			"tag2" "2.806"
			"tag3" "5.647"
		}
	}
}
"Event.Zombat_B_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		// "wave"			"#music/zombat/Horde_01.wav"
		// "wave"			"#music/zombat/Horde_02.wav"
		"wave"			"#music/zombat/Snare_Horde_01_01b.wav"
// "wave"			"#music/zombat/Horde_03.wav"
		// "wave"			"#music/zombat/Horde_04.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_Fairgrounds"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "2"
		"MusicPriority"			"CRITICAL"
		// "MusicMasterDivTags" "8.0"
 		"MusicMasterTags"
		{
			"tag1" "1.033"
			"tag2" "2.806"
			"tag3" "5.647"
		}
	}
}

// --------------------------------------------------------------------
// C2 Slayer
// --------------------------------------------------------------------
"Event.Zombat2_Intro_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	// "rndwave"
	// {
		"wave"			"#music/zombat/slayer/lectric/Slayer_01a.wav"

	// }


	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Fairgrounds"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}

// --------------------------------------------------------------------
// Danger
// --------------------------------------------------------------------
"Event.Zombat3_Intro_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
// 		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_01.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_02.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_03.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_04.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_05.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_06.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_07.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_08.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_09.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_10.wav"
// 		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_11.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_12.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_13.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_14.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_15.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_16.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_17.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_18.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_19.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_20.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_21.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_22.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_23.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_24.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_25.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_26.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_27.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_28.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_29.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_30.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_31.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_32.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_33.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_A_Fairgrounds"
		"MusicTrack"            "zombat3"
		"MusicTagDelay"         "1, 7"
			//	"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.Zombat3_A_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
 		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_01.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_02.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_03.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_04.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_05.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_06.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_07.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_08.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_09.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_10.wav"
 		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_11.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_12.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_13.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_14.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_15.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_16.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_17.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_18.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_19.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_20.wav"
 		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_21.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_22.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_23.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_24.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_25.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_26.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_27.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_28.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_29.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_30.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_31.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_32.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_33.wav"
	}


	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_B_Fairgrounds"
		"MusicTrack"            "zombat3"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
//		"MusicMasterDivTags"    "1.0"
//		"MusicTagDelay"         "1, 1"
		"MusicTagDelay"         "1, 7"
//		"MusicTagDelayMult"     "2"
	}
}
"Event.Zombat3_B_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
// 		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_01.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_02.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_03.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_04.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_05.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_06.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_07.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_08.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_09.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_10.wav"
// 		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_11.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_12.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_13.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_14.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_15.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_16.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_17.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_18.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_19.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_20.wav"
// 		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_21.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_22.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_23.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_24.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_25.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_26.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_27.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_28.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_29.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_30.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_31.wav"
		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_32.wav"
//		"wave"			"#music/zombat/danger/saw/Saw_Danger_02_33.wav"

	}

	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_A_Fairgrounds"
		"MusicTrack"            "zombat3"
		"MusicTagTrack"         "zombat"
//		"MusicTagDelay"         "1, 1"
		"MusicTagDelay"         "1, 7"
//		"MusicTagIndex"         "2"
		"MusicPriority"			"CRITICAL"
//		"MusicMasterDivTags"    "1.0"
	}
}


// // --------------------------------------------------------------------

// "Event.Zombat3_Intro_Fairgrounds"
// {
// 	"channel"		"CHAN_STATIC"
// 	"volume"		"1.0"
// 	"soundlevel"	"SNDLVL_NONE"

// 	"rndwave"
// 	{
// 		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
// 		// "wave"			"#music/zombat/danger/HordeDanger_02.wav"
// 		// "wave"			"#music/zombat/danger/HordeDanger_03.wav"
// 		// "wave"			"#music/zombat/danger/HordeDanger_04.wav"

// 	}
// 	GameData
// 	{
// 		"MusicTrack"            "zombat3"
// 		"MusicTagTrack"         "zombat"
// 		"MusicPriority"			"HIGH"
// 	}
// }


// --------------------------------------------------------------------
// C3 Plankcountry
// drums
// --------------------------------------------------------------------
"Event.Zombat_Intro_PlankCountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_PlankCountry"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.Zombat_PlankCountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		
		"wave"			"#music/zombat/Snare_Horde_01_01a.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_PlankCountry"
		"MusicTrack"            "zombat"
		"MusicPriority"			"CRITICAL"
		// "MusicMasterDivTags" "8.0"
 		"MusicMasterTags"
		{
			"tag1" "1.033"
			"tag2" "2.806"
			"tag3" "5.647"
		}
	}
}
"Event.Zombat_A_PlankCountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/Snare_Horde_01_01a.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_PlankCountry"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "2"
		"MusicPriority"			"CRITICAL"
		// "MusicMasterDivTags" "8.0"
 		"MusicMasterTags"
		{
			"tag1" "1.033"
			"tag2" "2.806"
			"tag3" "5.647"
		}
	}
}
"Event.Zombat_B_PlankCountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		// "wave"			"#music/zombat/Horde_01.wav"
		// "wave"			"#music/zombat/Horde_02.wav"
		"wave"			"#music/zombat/Snare_Horde_01_01b.wav"
// "wave"			"#music/zombat/Horde_03.wav"
		// "wave"			"#music/zombat/Horde_04.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_PlankCountry"
		"MusicTrack"            "zombat"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "2"
		"MusicPriority"			"CRITICAL"
		// "MusicMasterDivTags" "8.0"
 		"MusicMasterTags"
		{
			"tag1" "1.033"
			"tag2" "2.806"
			"tag3" "5.647"
		}
	}
}

// --------------------------------------------------------------------
// Plankcountry
// Slayer music
// --------------------------------------------------------------------
"Event.Zombat2_Intro_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	// "rndwave"
	// {
		"wave"			"#music/zombat/slayer/lectric/Slayer_01a.wav"

	// }


	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Plankcountry"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}


// --------------------------------------------------------------------
// Danger
// --------------------------------------------------------------------
"Event.Zombat3_Intro_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.92"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave" "#music/zombat/danger/deviddle/deviddle_41.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_42.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_43.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_44.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_45.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_46.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_47.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_48.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_49.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_50.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_51.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_52.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_53.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_54.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_55.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_56.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_57.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_58.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_59.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_60.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_61.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_62.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_63.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_64.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_65.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_66.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_67.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_68.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_69.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_70.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_71.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_72.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_73.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_74.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_75.wav"

	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_A_Plankcountry"
		"MusicTrack"            "zombat3"
			//	"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.Zombat3_A_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.92"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave" "#music/zombat/danger/deviddle/deviddle_01.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_02.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_03.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_04.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_05.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_06.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_07.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_08.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_09.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_10.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_11.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_12.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_13.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_14.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_15.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_16.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_17.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_18.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_19.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_20.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_21.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_22.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_23.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_24.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_25.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_26.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_27.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_28.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_29.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_30.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_31.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_32.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_33.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_34.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_35.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_36.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_37.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_38.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_39.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_40.wav"


	}


	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_B_Plankcountry"
		"MusicTrack"            "zombat3"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
//		"MusicMasterDivTags"    "1.0"
//		"MusicTagDelay"         "1, 1"
		"MusicTagDelay"         "1, 3"
//		"MusicTagDelayMult"     "2"
	}
}
"Event.Zombat3_B_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.92"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave" "#music/zombat/danger/deviddle/deviddle_41.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_42.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_43.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_44.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_45.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_46.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_47.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_48.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_49.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_50.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_51.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_52.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_53.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_54.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_55.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_56.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_57.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_58.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_59.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_60.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_61.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_62.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_63.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_64.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_65.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_66.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_67.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_68.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_69.wav"
 		"wave" "#music/zombat/danger/deviddle/deviddle_70.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_71.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_72.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_73.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_74.wav"
		"wave" "#music/zombat/danger/deviddle/deviddle_75.wav"
	}

	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_A_Plankcountry"
		"MusicTrack"            "zombat3"
		"MusicTagTrack"         "zombat"
//		"MusicTagDelay"         "1, 1"
		"MusicTagDelay"         "1, 3"
//		"MusicTagIndex"         "2"
		"MusicPriority"			"CRITICAL"
//		"MusicMasterDivTags"    "1.0"
	}
}
// "Event.Zombat3_Intro_Plankcountry"
// {
// 	"channel"		"CHAN_STATIC"
// 	"volume"		"1.0"
// 	"soundlevel"	"SNDLVL_NONE"

// 	"rndwave"
// 	{
// 		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
// 		// "wave"			"#music/zombat/danger/HordeDanger_02.wav"
// 		// "wave"			"#music/zombat/danger/HordeDanger_03.wav"
// 		// "wave"			"#music/zombat/danger/HordeDanger_04.wav"

// 	}
// 	GameData
// 	{
// 		"MusicTrack"            "zombat3"
// 		"MusicTagTrack"         "zombat"
// 		"MusicPriority"			"HIGH"
// 	}
// }

// --------------------------------------------------------------------
// A2 Milltown
// --------------------------------------------------------------------
// --------------------------------------------------------------------
"Event.Zombat2_Intro_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	// "rndwave"
	// {
		"wave"			"#music/zombat/slayer/lectric/Slayer_01a.wav"

	// }


	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Milltown"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}
// --------------------------------------------------------------------
// Danger
// --------------------------------------------------------------------
"Event.Zombat3_Intro_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_01.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_02.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_03.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_04.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_05.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_06.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_07.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_08.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_09.wav"
// // 		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_10.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_11.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_12.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_13.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_14.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_15.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_16.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_17.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_18.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_19.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_20.wav"



		"wave" "#music/zombat/danger/dobro/dobro_04_01.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_02.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_03.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_04.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_05.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_06.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_07.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_08.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_09.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_10.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_11.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_12.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_13.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_14.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_15.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_16.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_17.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_18.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_19.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_20.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_21.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_A_Milltown"
		"MusicTrack"            "zombat3"
			//	"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.Zombat3_A_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_01.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_02.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_03.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_04.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_05.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_06.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_07.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_08.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_09.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_10.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_11.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_12.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_13.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_14.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_15.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_16.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_17.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_18.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_19.wav"
		"wave" "#music/zombat/danger/dobro/Dobro_Danger_02_20.wav"



		// // "wave" "#music/zombat/danger/dobro/dobro_04_01.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_02.wav"
		// // "wave" "#music/zombat/danger/dobro/dobro_04_03.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_04.wav"
		// // "wave" "#music/zombat/danger/dobro/dobro_04_05.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_06.wav"
		// // "wave" "#music/zombat/danger/dobro/dobro_04_07.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_08.wav"
		// // "wave" "#music/zombat/danger/dobro/dobro_04_09.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_10.wav"
		// // "wave" "#music/zombat/danger/dobro/dobro_04_11.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_12.wav"
		// // "wave" "#music/zombat/danger/dobro/dobro_04_13.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_14.wav"
		// // "wave" "#music/zombat/danger/dobro/dobro_04_15.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_16.wav"
		// // "wave" "#music/zombat/danger/dobro/dobro_04_17.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_18.wav"
		// // "wave" "#music/zombat/danger/dobro/dobro_04_19.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_20.wav"
		// "wave" "#music/zombat/danger/dobro/dobro_04_21.wav"
	}


	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_B_Milltown"
		"MusicTrack"            "zombat3"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
//		"MusicMasterDivTags"    "1.0"
//		"MusicTagDelay"         "1, 1"
		"MusicTagDelay"         "1, 7"
//		"MusicTagDelayMult"     "2"
	}
}
"Event.Zombat3_B_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_01.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_02.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_03.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_04.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_05.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_06.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_07.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_08.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_09.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_10.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_11.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_12.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_13.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_14.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_15.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_16.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_17.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_18.wav"
		// "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_19.wav"
		// // "wave" "#music/zombat/danger/dobro/Dobro_Danger_02_20.wav"

		"wave" "#music/zombat/danger/dobro/dobro_04_01.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_02.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_03.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_04.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_05.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_06.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_07.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_08.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_09.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_10.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_11.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_12.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_13.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_14.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_15.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_16.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_17.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_18.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_19.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_20.wav"
		"wave" "#music/zombat/danger/dobro/dobro_04_21.wav"


	}

	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_A_Milltown"
		"MusicTrack"            "zombat3"
		"MusicTagTrack"         "zombat"
//		"MusicTagDelay"         "1, 1"
		"MusicTagDelay"         "1, 3"
//		"MusicTagIndex"         "2"
		"MusicPriority"			"CRITICAL"
//		"MusicMasterDivTags"    "1.0"
	}
}
// "Event.Zombat3_Intro_Milltown"
// {
// 	"channel"		"CHAN_STATIC"
// 	"volume"		"1.0"
// 	"soundlevel"	"SNDLVL_NONE"

// 	"rndwave"
// 	{
// 		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
// 		// "wave"			"#music/zombat/danger/HordeDanger_02.wav"
// 		// "wave"			"#music/zombat/danger/HordeDanger_03.wav"
// 		// "wave"			"#music/zombat/danger/HordeDanger_04.wav"

// 	}
// 	GameData
// 	{
// 		"MusicTrack"            "zombat3"
// 		"MusicTagTrack"         "zombat"
// 		"MusicPriority"			"HIGH"
// 	}
// }

// --------------------------------------------------------------------
// C5 BigEasy
// --------------------------------------------------------------------


// --------------------------------------------------------------------
// slayer
// --------------------------------------------------------------------
"Event.Zombat2_Intro_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	// "rndwave"
	// {
		"wave"			"#music/zombat/slayer/lectric/Slayer_01a.wav"

	// }


	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Plankcountry"
		"MusicTrack"            "zombat2"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		"MusicPriority"			"CRITICAL"
		// "MusicMasterDivTags"    "8.0"
	}
}

// --------------------------------------------------------------------
// Danger
// --------------------------------------------------------------------
"Event.Zombat3_Intro_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_01.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_02.wav"
//		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_03.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_04.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_05.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_06.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_07.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_08.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_09.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_10.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_11.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_12.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_13.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_14.wav"
//		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_15.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_A_BigEasy"
		"MusicTrack"            "zombat3"
			//	"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.Zombat3_A_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_01.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_02.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_03.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_04.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_05.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_06.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_07.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_08.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_09.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_10.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_11.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_12.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_13.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_14.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_15.wav"
	}


	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_B_BigEasy"
		"MusicTrack"            "zombat3"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicTagDelay"         "1, 3"
	}
}
"Event.Zombat3_B_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
//		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_01.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_02.wav"
//		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_03.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_04.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_05.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_06.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_07.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_08.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_09.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_10.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_11.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_12.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_13.wav"
 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_14.wav"
// 		"wave" "#music/zombat/danger/trumpet/Trumpet_Danger_02_15.wav"
	}

	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_A_BigEasy"
		"MusicTrack"            "zombat3"
		"MusicTagTrack"         "zombat"
		"MusicTagDelay"         "1, 3"
		"MusicPriority"			"CRITICAL"
	}
}

// // --------------------------------------------------------------------
// // A2 Clown
// // --------------------------------------------------------------------
// "Event.Zombat2_Intro_Clown"
// {
	// "channel"		"CHAN_STATIC"
	// "volume"		"0.9"
	// "soundlevel"	"SNDLVL_NONE"

	// // "rndwave"
	// // {
		// "wave"			"#music/zombat/slayer/lectric/Slayer_01a.wav"

	// // }


	// GameData
	// {
		// // "MusicAutoQueue"        "Event.Zombat_A2B_Fairgrounds"
		// "MusicTrack"            "zombat2c"
		// "MusicPriority"			"CRITICAL"
		// "MusicTagTrack"         "zombat"
		// "MusicTagIndex"         "0"
		// // "MusicMasterDivTags"    "8.0"
	// }
// }

"Event.Zombat3_Intro_Clown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.84"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/not_a_laughing_matter.wav"

		
	GameData
	{
		"MusicTrack"            "zombat3"
		// "MusicTagTrack"         "zombat"
		// "MusicAutoQueue"        "Event.Zombat3_A_Clown"
		"MusicPriority"			"CRITICAL"
	}
}
// "Event.Zombat3_A_Clown"
// {
	// "channel"		"CHAN_STATIC"
	// "volume"		"1.0"
	// "soundlevel"	"SNDLVL_NONE"

	// "rndwave"
	// {
		
		// "wave"			"#music/zombat/danger/not_a_laughing_matter.wav"
	// }
	// GameData
	// {
		// // "MusicAutoQueue"        "Event.Zombat3_B_Clown"
		// "MusicTagTrack"         "zombat"
		// "MusicTrack"            "zombat3"
		// "MusicPriority"			"CRITICAL"
		// // "MusicTagDelay"         "15"
			
		// "MusicTagDelay"         "15"
		// // "MusicMasterDivTags" "8.0"
	// }
// }
// "Event.Zombat3_B_Clown"
// {
	// "channel"		"CHAN_STATIC"
	// "volume"		"1.0"
	// "soundlevel"	"SNDLVL_NONE"

	// "rndwave"
	// {
		
		// "wave"			"#music/zombat/danger/not_a_laughing_matter.wav"
	// }
	// GameData
	// {
		// "MusicAutoQueue"        "Event.Zombat3_A_Clown"
		// "MusicTagTrack"         "zombat"
		// "MusicTrack"            "zombat3"
		// "MusicPriority"			"CRITICAL"
		// "MusicTagDelay"         "15"
		// // "MusicMasterDivTags" "8.0"
	// }
// }


///////////////////////////////// DEATH!! //////////////////////////

// DEATH
//
// There are many kinds of deaths, each specific to how you are dying.
//

// ledge hang
// for dying by falling, each successive cue should segue into the next
"Event.LedgeHangTwoHands"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.8"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/terror/ClingingToHell1.wav"

	GameData
	{
		"MusicTrack"            "ledge"
		"MusicPriority"			"CRITICAL"
		"MusicDuckTrackList"    "all"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"

		"MusicMaster"		"PLAY_SPLIT"
	}
}

"Event.LedgeHangOneHand"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.8"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/terror/ClingingToHell2.wav"

	GameData
	{
		"MusicTrack"            "ledge"
		"MusicPriority"			"CRITICAL"
		"MusicDuckTrackList"    "all"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"

		"MusicMaster"		"PLAY_SPLIT"
	}		
}

"Event.LedgeHangFingers"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.8"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/terror/ClingingToHell3.wav"

	GameData
	{
		"MusicDuckTrackList"    "all"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"

		"MusicTrack"            "ledge"
		"MusicPriority"			"CRITICAL"
		"MusicMaster"		"PLAY_SPLIT"
	}		
}

// This cue starts exactly 10 seconds before falling as the health meter clicks down.
"Event.LedgeHangAboutToFall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.8"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/terror/ClingingToHell4.wav"

	GameData
	{
		"MusicDuckTrackList"    "all"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"

		"MusicTrack"            "ledge"
		"MusicPriority"			"CRITICAL"
		"MusicMaster"		"PLAY_SPLIT"

	}		
}
"Event.LedgeHangFalling"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.8"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"common/null.wav"

	GameData
	{
		"MusicDuckTrackList"    "all"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"

		"MusicTrack"            "ledge"
		"MusicPriority"			"CRITICAL"
		"MusicMaster"		"PLAY_SPLIT"
	}		
}

// Hits
"Event.LedgeHangTwoHandsHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"

	"wave"			"music/tags/ClingingToHellHit1.wav"

	GameData
	{
		"MusicTrack"            "ledgeHits"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.LedgeHangOneHandHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"

	"wave"			"music/tags/ClingingToHellHit2.wav"

	GameData
	{
		"MusicTrack"            "ledgeHits"
		"MusicPriority"			"CRITICAL"
	}		
}

"Event.LedgeHangFingersHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"

	"wave"			"music/tags/ClingingToHellHit3.wav"

	GameData
	{
		"MusicTrack"            "ledgeHits"
		"MusicPriority"			"CRITICAL"
	}		
}

// This cue starts exactly 10 seconds before falling as the health meter clicks down.
"Event.LedgeHangAboutToFallHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"

//	"wave"			"common/null.wav"
	"wave"			"music/tags/ClingingToHellHit4.wav"

	GameData
	{
		"MusicTrack"            "ledgeHits"
		"MusicPriority"			"CRITICAL"
	}		
}

// Down
// Survivor is down and being beaten by infected
"Event.Down"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/terror/PuddleOfYou.wav"

	GameData
	{
		"MusicTrack"            "down"
		"MusicPriority"			"CRITICAL"
		"MusicMaster"		"PLAY_SPLIT"
	}		
}
// Down
// Survivor is down and being beaten by infected
"Event.DownHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"music/tags/PuddleOfYouHit.wav"

	GameData
	{
		"MusicTrack"            "downHits"
		"MusicPriority"			"CRITICAL"
	}		
}

// BleedingOut
// This cue starts exactly 10 seconds before death as the health meter clicks down.
"Event.BleedingOut"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/terror/IAmSoCold.wav"

	GameData
	{
		"MusicTrack"            "down"
		"MusicPriority"			 "CRITICAL"
		"MusicMaster"		"PLAY_SPLIT"

	}		
}
// This cue starts exactly 10 seconds before death as the health meter clicks down.
"Event.BleedingOutHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"music/tags/IAmSoColdHit.wav"

	GameData
	{
		"MusicTrack"            "downHits"
		"MusicPriority"			"CRITICAL"
	}		
}

// This cue starts exactly 10 seconds before death as the health meter clicks down.
"Event.BleedingOutEnd"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/terror/TheEnd.wav"

//	"wave"			"common/null.wav"


	GameData
	{
		"MusicTrack"            "down"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_SPLIT"

	}		
}

// Survivor death
// This is for the death of an individual survivor to be played after the health meter has reached zero
"Event.SurvivorDeath"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/undeath/LeftForDeath.wav"
	
	GameData
	{
		"MusicTrack"            "default"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH"
// Originaly it was changed from "PLAY_SPLIT" to "PLAY_SPLIT | DONT_DISENGAGE" in order to fix the bug where this cue wouldn't play if you were spectating on someone
// This resulted in the cue playing for Infected players after killing one of the survivors alongside making any other sound playing quieter. Changing it back to "PLAY_SPLIT" fixes it
		"MusicMaster"           "PLAY_SPLIT"

	}
}

"Event.SurvivorDeathHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"#music/tags/LeftForDeathHit.wav"
	
	GameData
	{
		"MusicTrack"            "deathHits"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH"
	}
}

"Event.ScenarioLose"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/undeath/Death.wav"
	
	GameData
	{
		"MusicTrack"            "default"
		"MusicMaster"           "PLAY_TO_END | DONT_DISENGAGE"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH | AFTER_MISSION_END"
	}
}


///////////////////////////////// Finale!! //////////////////////////
//
// FINALE
//

"Event.FinaleStart"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.83"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/the_end/YourOwnFuneral.wav"
	
	GameData
	{
		"MusicTrack"            "finaleStart"
		"MusicPriority"			"HIGH"
	}
}


"Event.FinaleWave4"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/the_end/FinalNail.wav"
	GameData
	{
		"MusicTrack"            "default"
		"MusicPriority"			"HIGH"
	}
}

"Event.SurvivalStart"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/the_end/SnowballInHell.wav"
	
	GameData
	{
		"MusicTrack"            "default"
		"MusicPriority"			"HIGH"
	}
}

// Final battle
// For the final battle before getting rescued"Event.FinalBattle"
"Event.FinalBattle"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.88"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/the_end/SkinOnOurTeeth.wav"

	GameData
	{
		"MusicTrack"            "default"
		"MusicPriority"			"HIGH"
		"MusicFadeOut"         	"2.0"
		"MusicBlockTrackList"   "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient, tank"
		"MusicStopTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient, tank"

	}
}


///////////////////////////////// Scenario finish!! //////////////////////////
"Event.ScenarioWin"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/unalive/TheMonstersWithin.wav"
	
	GameData
	{
		"MusicTrack"            "default"
		"MusicMaster"           "PLAY_TO_END | DONT_DISENGAGE"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH | AFTER_MISSION_END"
	}
}
"Event.SafeRoom"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.85"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/safe/TheMonstersWithout.wav"
	
	GameData
	{
		"MusicTrack"            "default"
		"MusicMaster"           "PLAY_TO_END | DONT_DISENGAGE"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH | AFTER_MISSION_END"
	}
}

///////////////////////////////// Scavenge Mode!! //////////////////////////
"Event.ScavengeRoundStart"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

 	"wave"	"#music/mob/GermS1a.wav"

	
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicFadeOut"         	"1.0"
	}
}
"Event.ScavengeRoundHalftime"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/safe/TheMonstersWithout.wav"
	
	GameData
	{
		"MusicTrack"            "default"
		"MusicMaster"           "PLAY_TO_END | DONT_DISENGAGE"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH | AFTER_MISSION_END"
	}
}
"Event.ScavengeRoundEnd"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/safe/TheMonstersWithout_s.wav"
	
	GameData
	{
		"MusicTrack"            "default"
		"MusicMaster"           "PLAY_TO_END | DONT_DISENGAGE"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH | AFTER_MISSION_END"
	}
}
"Event.ApproachingScavengeRoundWin"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/scavenge/gascanofvictory.wav"

	GameData
	{
		"MusicTrack"            "default"
		"MusicPriority"			"HIGH"
		"MusicFadeOut"         	"2.0"
	}
}
"Event.ScavengeOvertimeStart"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.95"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/terror/ClingingToHell1.wav"

	GameData
	{
		"MusicTrack"            "default"
		"MusicPriority"			"MEDIUM"
		"MusicFadeOut"         	"2.0"
	}
}
"Event.ScavengeOvertimeEnd"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat"
		"MusicPriority"			"CRITICAL"
	}
}

// level stuff
"Event.ScavengeLevel_01"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

		"wave" "#/music/scavenge/level_01_01.wav"

	GameData
	{
		"MusicTrack"            "scavengeLevel"
		"MusicTagTrack"         "scavengeLevel"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "4.0"
	}
}
"Event.ScavengeLevel_02"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.97"
	"soundlevel"	"SNDLVL_NONE"

		"wave" "#/music/scavenge/level_02_01.wav"

	GameData
	{
		"MusicTrack"            "scavengeLevel"
		"MusicTagTrack"         "scavengeLevel"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "4.0"
	}
}
"Event.ScavengeLevel_03"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.94"
	"soundlevel"	"SNDLVL_NONE"

		"wave" "#/music/scavenge/level_03_01.wav"

	GameData
	{
		"MusicTrack"            "scavengeLevel"
		"MusicTagTrack"         "scavengeLevel"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "4.0"
	}
}
"Event.ScavengeLevel_04"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.91"
	"soundlevel"	"SNDLVL_NONE"

		"wave" "#/music/scavenge/level_04_01.wav"

	GameData
	{
		"MusicTrack"            "scavengeLevel"
		"MusicTagTrack"         "scavengeLevel"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "4.0"
	}
}
"Event.ScavengeLevel_05"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.87"
	"soundlevel"	"SNDLVL_NONE"

		"wave" "#/music/scavenge/level_05_01.wav"

	GameData
	{
		"MusicTrack"            "scavengeLevel"
		"MusicTagTrack"         "scavengeLevel"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "4.0"
	}
}
"Event.ScavengeLevel_06"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.80"
	"soundlevel"	"SNDLVL_NONE"

		"wave" "#/music/scavenge/level_06_01.wav"

	GameData
	{
		"MusicTrack"            "scavengeLevel"
		"MusicTagTrack"         "scavengeLevel"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "4.0"
	}
}
"Event.ScavengeLevel_07"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.76"
	"soundlevel"	"SNDLVL_NONE"

		"wave" "#/music/scavenge/level_07_01.wav"

	GameData
	{
		"MusicTrack"            "scavengeLevel"
		"MusicTagTrack"         "scavengeLevel"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "4.0"
	}
}
"Event.ScavengeLevel_08"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.72"
	"soundlevel"	"SNDLVL_NONE"

		"wave" "#/music/scavenge/level_08_01.wav"

	GameData
	{
		"MusicTrack"            "scavengeLevel"
		"MusicTagTrack"         "scavengeLevel"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "4.0"
	}
}
"Event.ScavengeLevel_09"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.68"
	"soundlevel"	"SNDLVL_NONE"

		"wave" "#/music/scavenge/level_09_01.wav"

	GameData
	{
		"MusicTrack"            "scavengeLevel"
//		"MusicTagTrack"         "scavengeLevel"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "4.0"
	}
}
"Event.ScavengeLevel_10"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.64"
	"soundlevel"	"SNDLVL_NONE"

	"wave" "#/music/scavenge/level_10_01.wav"

	GameData
	{
		"MusicTrack"            "scavengeLevel"
//		"MusicTagTrack"         "scavengeLevel"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "4.0"
	}
}


///////////////////////////////// Bosses!! //////////////////////////

// --------------------------------------------------------------------
// TANKS
// --------------------------------------------------------------------
"Event.Tank"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/tank/Tank.wav"
	
	GameData
	{
		"MusicTrack"            "tank"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicPriority"			"CRITICAL"
	}
}
// tank midpoint
// half way through the finale a tank shows up
"Event.TankMidpoint"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/tank/Taank.wav"
	
	GameData
	{
		"MusicTrack"            "tank"
		"MusicPriority"			"HIGH"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicStopTrackList"    "concert1, concert2"
	}
}

// --------------------------------------------------------------------
// See: game_sounds_music_lighthouse.txt
// --------------------------------------------------------------------
//The Last Stand tank brothers music
//"Event.TankMidpoint_Metal"
//{
//	"channel"		"CHAN_STATIC"
//	"volume"		"1.0"
//	"soundlevel"	"SNDLVL_NONE"
//	"wave"			"#music/tank/Tank_Metal.wav"
	
//	GameData
//	{
//		"MusicTrack"            "tank"
//		"MusicPriority"			"HIGH"
//		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
//		"MusicStopTrackList"    "concert1, concert2"
//	}
//}

// tank brothers
// Before the final zombie battle 2 tanks show up
"Event.TankBrothers"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/tank/Taank.wav"
	
	GameData
	{
		"MusicTrack"            "tank"
		"MusicPriority"			"HIGH"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicStopTrackList"    "concert1, concert2"
	}
}

// tank midpoint
// half way through the finale a tank shows up
"C2M5.RidinTank1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.85"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/tank/MidNightTank.wav"
	
	GameData
	{
		"MusicTrack"            "tank"
		"MusicPriority"			"HIGH"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicStopTrackList"    "concert1, concert2"
	}
}
"C2M5.RidinTank2"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.85"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/tank/MidNightTank.wav"
	
	GameData
	{
		"MusicTrack"            "tank2"
		"MusicPriority"			"HIGH"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicStopTrackList"    "concert1, concert2"
	}
}
// tank midpoint
// half way through the finale a tank shows up
"C2M5.BadManTank1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.85"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/tank/OneBadTank.wav"
	
	GameData
	{
		"MusicTrack"            "tank"
		"MusicPriority"			"HIGH"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicStopTrackList"    "concert1, concert2"
	}
}
"C2M5.BadManTank2"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.85"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/tank/OneBadTank.wav"
	
	GameData
	{
		"MusicTrack"            "tank2"
		"MusicPriority"			"HIGH"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicStopTrackList"    "concert1, concert2"
	}
}


// ----------------------------------------------
// witch
// ----------------------------------------------
"Event.WitchAttack"  
 {
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
 	"wave"			"#music/witch/PsychoWitch.wav"
	
	GameData
	{
		"MusicDuckTrackList"    "tank"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"

		"MusicTrack"            "witch"
		"MusicPriority"			"CRITICAL"
	}

}
"Event.WitchBurning"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
 	"wave"			"#music/witch/WitchRoast.wav"
  
	
	GameData
	{
		"MusicDuckTrackList"    "tank"
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"

		"MusicTrack"            "witch"
		"MusicPriority"			"CRITICAL" 
	}

}

"Event.WitchRage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"		"SNDLVL_NONE"
 	"wave"			"music/witch/WitchEncroacher.wav"
	
	GameData
	{
		"MusicTrack"            "witch"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.WitchDead"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"common/null.wav"

	GameData
	{
		"MusicTrack"            "witch"
	}
}

"Event.WanderingWitch"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_145dB"

	"rndwave"
	{
		"wave"		"music/witch/lost_little_witch_01a.wav"
		"wave"		"music/witch/lost_little_witch_01b.wav"
		"wave"		"music/witch/lost_little_witch_02a.wav"
		"wave"		"music/witch/lost_little_witch_02b.wav"
		"wave"		"music/witch/lost_little_witch_03a.wav"
		"wave"		"music/witch/lost_little_witch_03b.wav"
		"wave"		"music/witch/lost_little_witch_04a.wav"
		"wave"		"music/witch/lost_little_witch_04b.wav"
	}	
	GameData
	{
		"MusicTrack"            "witchChoir"
		"MusicPriority"			"CRITICAL"
		"MusicFadeOut"         	"1.5"

	}
}
"Event.WanderingAngryWitch"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.87"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"		"music/witch/LOUD_angry_little_witch_04.wav"
	}	
	GameData
	{
		"MusicTrack"            "witchChoir"
		"MusicPriority"			"CRITICAL"
		"MusicFadeOut"         	"1.5"
	}
}
"Event.WanderingAngryWitch2"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.87"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"		"music/witch/LOUD_angry_little_witch_03.wav"
//		 "wave"		"common/null.wav"
	}	
	GameData
	{
		"MusicTrack"            "witchChoir"
		"MusicPriority"			"CRITICAL"
		"MusicFadeOut"         	"1.5"
	}
}
"Event.WanderingAngryWitch3"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.87"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"		"music/witch/LOUD_angry_little_witch_02.wav"
//		 "wave"		"common/null.wav"
	}	
	GameData
	{
		"MusicTrack"            "witchChoir"
		"MusicPriority"			"CRITICAL"
		"MusicFadeOut"         	"1.5"
	}
}
"Event.WanderingAngryWitch4"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.87"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"		"music/witch/LOUD_angry_little_witch_01.wav"
		// "wave"		"common/null.wav"
	}	
	GameData
	{
		"MusicTrack"            "witchChoir"
		"MusicPriority"			"CRITICAL"
		"MusicFadeOut"         	"1.5"
	}
}

// --------------------------------------------------------------------
// mobbed
// --------------------------------------------------------------------
"Event.Mobbed"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/terror/MobRules.wav"
	
	GameData
	{
		"MusicTrack"            "mobRules"
		"MusicDuckTrackList"    "all"

		"MusicPriority"			"HIGH"
	}
}
// --------------------------------------------------------------------
// Hunter Pounce
// While being torn apart by a hunter
// --------------------------------------------------------------------
"Event.HunterPounce"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/pzattack/Exenteration.wav"
	
	GameData
	{
		"MusicTrack"            "PZAttack"
		"MusicDuckTrackList"    "all"

		"MusicPriority"			"CRITICAL"
		"MusicMaster"		"PLAY_SPLIT"
	}
}
"Event.HunterHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"music/tags/ExenterationHit.wav"
	
	GameData
	{
		"MusicTrack"            "hunterHits"
		"MusicPriority"			"CRITICAL"
	}
}

// --------------------------------------------------------------------
// SMOKER
// While being choked by a smoker
// --------------------------------------------------------------------
"Event.SmokerChoke"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/pzattack/Asphyxiation.wav"
	
	GameData
	{
		"MusicTrack"            "PZAttack"
		"MusicDuckTrackList"    "all"
		"MusicPriority"			"CRITICAL"
		"MusicMaster"		"PLAY_SPLIT"
	}
}
"Event.SmokerChokeHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"#music/tags/AsphyxiationHit.wav"

	GameData
	{
		"MusicTrack"            "smokerHits"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.SmokerDrag"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/terror/TongueTied.wav"
	
	GameData
	{
		"MusicTrack"            "PZAttack"
		"MusicDuckTrackList"    "all"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.SmokerDragHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"music/tags/TongueTiedHit.wav"
	
	GameData
	{
		"MusicTrack"            "smokerHits"
		"MusicDuckTrackList"    "all"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"NO_INTENSITY_TRACK"
	}
}

// --------------------------------------------------------------------
// Boomer
// --------------------------------------------------------------------
"Event.VomitInTheFace"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/terror/Pukricide.wav"
	
	GameData
	{
		"MusicTrack"            "PZAttack"
		"MusicDuckTrackList"    "all"
		"MusicPriority"			"HIGH"
		"MusicMaster"		"PLAY_SPLIT"
	}
}

"Event.BoomerHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"music/tags/PukricideHit.wav"
	
	GameData
	{
		"MusicTrack"            "boomerHits"
		"MusicPriority"			"CRITICAL"
	}
}

// --------------------------------------------------------------------
// Charger smash
// While being torn apart by a hunter
// --------------------------------------------------------------------
"Event.ChargerSmash"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/pzattack/Contusion.wav"
	
	GameData
	{
		"MusicTrack"            "PZAttack"
		"MusicDuckTrackList"    "all"
		"MusicPriority"			"CRITICAL"
		"MusicMaster"		"PLAY_SPLIT"
	}
}
"Event.ChargerHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"music/tags/ContusionHit.wav"
	
	GameData
	{
		"MusicTrack"            "chargerHits"
		// "MusicDuckTrackList"    "all"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.ChargerSlam"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.79"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/pzattack/Mortification.wav"
	
	GameData
	{
		"MusicTrack"            "PZAttack"
		"MusicDuckTrackList"    "all"
		"MusicPriority"			"CRITICAL"
		"MusicMaster"		"PLAY_SPLIT"
	}
}
"Event.ChargerSlamHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"music/tags/MortificationHit.wav"
	
	GameData
	{
		"MusicTrack"            "chargerSlamHits"
		// "MusicDuckTrackList"    "all"
		"MusicPriority"			"CRITICAL"
	}
}
// --------------------------------------------------------------------
// Jockey ride
// --------------------------------------------------------------------
"Event.JockeyRide"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.78"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/pzattack/Vassalation.wav"
	
	GameData
	{
		"MusicTrack"            "PZAttack"
		"MusicDuckTrackList"    "all"
		"MusicPriority"			"CRITICAL"
		"MusicMaster"		"PLAY_SPLIT"
	}
}
"Event.JockeyHit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"music/tags/VassalationHit.wav"
	
	GameData
	{
		"MusicTrack"            "jockeyHits"
		"MusicPriority"			"CRITICAL"
	}
}

// --------------------------------------------------------------------
// Spitter Spit
// --------------------------------------------------------------------
"Event.SpitterSpit"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_80dB"
	"wave"			")music/terror/PileOBile.wav"
	
	GameData
	{
		"MusicTrack"            "spitterSpit"
//		"MusicDuckTrackList"    "all"
		"MusicPriority"			"CRITICAL"
//		"MusicMaster"		"PLAY_SPLIT"
	}
}
"Event.SpitterBurn"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/pzattack/Enzymicide.wav"
//	"wave"			"common/null.wav"

	GameData
	{
		"MusicTrack"            "PZAttack"
		"MusicDuckTrackList"    "all"
		"MusicPriority"			"HIGH"
		"MusicMaster"		"PLAY_SPLIT"
	}
}

// --------------------------------------------------------------------
// Alerts
// --------------------------------------------------------------------
// --------------------------------------------------------------------
// Alerts
// --------------------------------------------------------------------
"Event.BoomerAlertClose"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_110dB"
	"wave"			"music/bacteria/BoomerBacteria.wav"
	
	GameData
	{
		"MusicTrack"            "BoomerAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.BoomerAlert"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_120dB"
	"wave"			"music/bacteria/BoomerBacteriaS.wav"
	
	GameData
	{
		"MusicTrack"            "BoomerAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.BoomerAlertFar"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_125dB"
	"wave"			"music/bacteria/BoomerBacteriaS.wav"
	
	GameData
	{
		"MusicTrack"            "BoomerAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.SmokerAlertClose"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_110dB"
	"wave"			"music/bacteria/SmokerBacteria.wav"
	
	GameData
	{
		"MusicTrack"            "SmokerAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.SmokerAlert"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_120dB"
	"wave"			"music/bacteria/SmokerBacteriaS.wav"
	
	GameData
	{
		"MusicTrack"            "SmokerAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.SmokerAlertFar"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_125dB"
	"wave"			"music/bacteria/SmokerBacteriaS.wav"
	
	GameData
	{
		"MusicTrack"            "SmokerAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.HunterAlertClose"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_110dB"
	"wave"			"music/bacteria/HunterBacteria.wav"
	
	GameData
	{
		"MusicTrack"            "HunterAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.HunterAlert"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_115dB"
	"wave"			"music/bacteria/HunterBacteriaS.wav"
	
	GameData
	{
		"MusicTrack"            "HunterAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.HunterAlertFar"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_120dB"
	"wave"			"music/bacteria/HunterBacteriaS.wav"
	
	GameData
	{
		"MusicTrack"            "HunterAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.ChargerAlertClose"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_110dB"
	"wave"			"music/bacteria/ChargerBacteria.wav"
	
	GameData
	{
		"MusicTrack"            "ChargerAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.ChargerAlert"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_115dB"
	"wave"			"music/bacteria/ChargerBacteriaS.wav"
	
	GameData
	{
		"MusicTrack"            "ChargerAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.ChargerAlertFar"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_120dB"
	"wave"			"music/bacteria/ChargerBacteriaS.wav"
	
	GameData
	{
		"MusicTrack"            "ChargerAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.SpitterAlertClose"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_110dB"
	"wave"			"music/bacteria/SpitterBacteria.wav"
	
	GameData
	{
		"MusicTrack"            "SpitterAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.SpitterAlert"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_115dB"
	"wave"			"music/bacteria/SpitterBacteriaS.wav"
	
	GameData
	{
		"MusicTrack"            "SpitterAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.SpitterAlertFar"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_120dB"
	"wave"			"music/bacteria/SpitterBacteriaS.wav"
	
	GameData
	{
		"MusicTrack"            "SpitterAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.JockeyAlertClose"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_110dB"
	"wave"			"music/bacteria/JockeyBacteria.wav"
	
	GameData
	{
		"MusicTrack"            "JockeyAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.JockeyAlert"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_115dB"
	"wave"			"music/bacteria/JockeyBacteriaS.wav"
	
	GameData
	{
		"MusicTrack"            "JockeyAlert"
		"MusicPriority"			"CRITICAL"
	}
}
"Event.JockeyAlertFar"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_120dB"
	"wave"			"music/bacteria/JockeyBacteriaS.wav"
	
	GameData
	{
		"MusicTrack"            "JockeyAlert"
		"MusicPriority"			"CRITICAL"
	}
}

///////////////////////////////// Zombies!! //////////////////////////
// L4D2
// BigEasy
// S
"Event.MobSignal1_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.3, 0.35"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/MallGermS1a.wav"
 		"wave"	"#music/mob/MallGermS1b.wav"
 		"wave"	"#music/mob/MallGermL1a.wav"
 		"wave"	"#music/mob/MallGermL1b.wav"
 		"wave"	"#music/mob/MallGermL1c.wav"
 		"wave"	"#music/mob/MallGermM1a.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}
"Event.MobSignal2_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.3, 0.35"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/MallGermS2a.wav"
 		"wave"	"#music/mob/MallGermS2b.wav"
 		"wave"	"#music/mob/MallGermM2a.wav"
 		"wave"	"#music/mob/MallGermM2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}
"Event.MobSignal1_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.55"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/FairgroundGermX1a.wav"
 		"wave"	"#music/mob/FairgroundGermX1b.wav"
 		"wave"	"#music/mob/FairgroundGermL1a.wav"
 		"wave"	"#music/mob/FairgroundGermL1b.wav"
 		"wave"	"#music/mob/FairgroundGermM1a.wav"
 		"wave"	"#music/mob/FairgroundGermM1b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}
"Event.MobSignal2_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.55"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/FairgroundGermX2a.wav"
 		"wave"	"#music/mob/FairgroundGermX2b.wav"
 		"wave"	"#music/mob/FairgroundGermX2a.wav"
 		"wave"	"#music/mob/FairgroundGermX2b.wav"
 		"wave"	"#music/mob/FairgroundGermM2a.wav"
 		"wave"	"#music/mob/FairgroundGermM2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

"Event.MobSignal1_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.35, 0.5"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/PlankGermX1a.wav"
 		"wave"	"#music/mob/PlankGermX1b.wav"
 		"wave"	"#music/mob/PlankGermL1a.wav"
 		"wave"	"#music/mob/PlankGermL1b.wav"
 		"wave"	"#music/mob/PlankGermS1a.wav"
 		"wave"	"#music/mob/PlankGermS1b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}
"Event.MobSignal2_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.35, 0.5"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/PlankGermX2a.wav"
 		"wave"	"#music/mob/PlankGermX2b.wav"
 		"wave"	"#music/mob/PlankGermL2a.wav"
 		"wave"	"#music/mob/PlankGermL2b.wav"
 		"wave"	"#music/mob/PlankGermS2a.wav"
 		"wave"	"#music/mob/PlankGermS2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

"Event.MobSignal1_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.35, 0.4"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave"	"#music/mob/MilltownGermX1a.wav"
 		"wave"	"#music/mob/MilltownGermX1b.wav"
 		"wave"	"#music/mob/MilltownGermX1c.wav"
		"wave"	"#music/mob/MilltownGermL1a.wav"
 		"wave"	"#music/mob/MilltownGermL1b.wav"
 		"wave"	"#music/mob/MilltownGermL1c.wav"
 		"wave"	"#music/mob/MilltownGermM1a.wav"
 		"wave"	"#music/mob/MilltownGermM1b.wav"
 		"wave"	"#music/mob/MilltownGermM1d.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}
"Event.MobSignal2_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.35, 0.4"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave"	"#music/mob/MilltownGermX2a.wav"
 		"wave"	"#music/mob/MilltownGermX2b.wav"
		"wave"	"#music/mob/MilltownGermL2a.wav"
 		"wave"	"#music/mob/MilltownGermL2b.wav"
 		"wave"	"#music/mob/MilltownGermL2c.wav"
 		"wave"	"#music/mob/MilltownGermM2a.wav"
 		"wave"	"#music/mob/MilltownGermM2b.wav"
 		"wave"	"#music/mob/MilltownGermM2c.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

"Event.MobSignal1_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.35, 0.5"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		// "wave"	"#music/mob/EasyGermS1a.wav"
 		// "wave"	"#music/mob/EasyGermS1b.wav"
 		// "wave"	"#music/mob/EasyGermX1a.wav"
 		// "wave"	"#music/mob/EasyGermX1b.wav"
 		"wave"	"#music/mob/ParishTmptGermX1a.wav"
 		"wave"	"#music/mob/ParishTmptGermX1b.wav"
 		"wave"	"#music/mob/ParishTmptGermX1c.wav"
 		"wave"	"#music/mob/ParishTmptGermX1d.wav"
 		// "wave"	"#music/mob/EasyGermL1a.wav"
 		// "wave"	"#music/mob/EasyGermL1b.wav"
 		"wave"	"#music/mob/ParishTmptGermL1a.wav"
 		"wave"	"#music/mob/ParishTmptGermL1b.wav"
 		// "wave"	"#music/mob/EasyGermS1a.wav"
 		// "wave"	"#music/mob/EasyGermS1b.wav"
 		"wave"	"#music/mob/ParishTmptGermM1a.wav"
 		"wave"	"#music/mob/ParishTmptGermM1b.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}
"Event.MobSignal2_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.35, 0.5"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		// "wave"	"#music/mob/EasyGermX2a.wav"
 		// "wave"	"#music/mob/EasyGermX2b.wav"
 		"wave"	"#music/mob/ParishTmptGermX2a.wav"
 		"wave"	"#music/mob/ParishTmptGermX2b.wav"
 		"wave"	"#music/mob/ParishTmptGermX2c.wav"
 		// "wave"	"#music/mob/EasyGermL2a.wav"
 		// "wave"	"#music/mob/EasyGermL2b.wav"
 		"wave"	"#music/mob/ParishTmptGermL2a.wav"
 		"wave"	"#music/mob/ParishTmptGermL2b.wav"
 		// "wave"	"#music/mob/EasyGermM2c.wav"
 		// "wave"	"#music/mob/EasyGermM2d.wav"
 		"wave"	"#music/mob/ParishTmptGermM2a.wav"
 		"wave"	"#music/mob/ParishTmptGermM2b.wav"
 		"wave"	"#music/mob/ParishTmptGermM2c.wav"
 		"wave"	"#music/mob/ParishTmptGermM2d.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}


"Event.MobSignal1_Survival"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL1a.wav"
 		"wave"	"#music/mob/GermL1b.wav"
 		"wave"	"#music/mob/GermM1a.wav"
 		"wave"	"#music/mob/GermM1b.wav"
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
 		"wave"	"#music/mob/GermX1a.wav"
 		"wave"	"#music/mob/GermX1b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}
"Event.MobSignal2_Survival"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL2a.wav"
 		"wave"	"#music/mob/GermL2b.wav"
 		"wave"	"#music/mob/GermM2a.wav"
 		"wave"	"#music/mob/GermM2b.wav"
 		"wave"	"#music/mob/GermS2a.wav"
 		"wave"	"#music/mob/GermS2b.wav"
 		"wave"	"#music/mob/GermX2a.wav"
 		"wave"	"#music/mob/GermX2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}


///////////////////////////////// Atmosphere!! //////////////////////////

"Event.SafeAtmosphere_Survival"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}
"Event.SafeAtmosphere_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}

"Event.SafeAtmosphere_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}
"Event.SafeAtmosphere_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}
"Event.SafeAtmosphere_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}

"Event.SafeAtmosphere_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}

"Event.SafeAtmosphere_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}




// danger

"Event.DangerAtmosphere_Survival"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{

		"wave" "#music/contagion/l4d2_rabies_01.wav"
		"wave" "#music/contagion/l4d2_rabies_02.wav"
		"wave" "#music/contagion/l4d2_rabies_03.wav"
		"wave" "#music/contagion/l4d2_rabies_04.wav"
		"wave" "#music/contagion/l4d2_rabies_05.wav"
		"wave" "#music/contagion/l4d2_rabies_06.wav"
		"wave" "#music/contagion/l4d2_rabies_07.wav"
		"wave" "#music/contagion/l4d2_rabies_08.wav"
		"wave" "#music/contagion/l4d2_rabies_09.wav"
		"wave" "#music/contagion/l4d2_rabies_10.wav"
		"wave" "#music/contagion/l4d2_rabies_11.wav"
		"wave" "#music/contagion/l4d2_rabies_12.wav"
		"wave" "#music/contagion/l4d2_rabies_13.wav"
		"wave" "#music/contagion/l4d2_rabies_14.wav"
		"wave" "#music/contagion/l4d2_rabies_15.wav"
		"wave" "#music/contagion/l4d2_rabies_16.wav"
		"wave" "#music/contagion/l4d2_rabies_17.wav"
		"wave" "#music/contagion/l4d2_rabies_18.wav"
		"wave" "#music/contagion/l4d2_rabies_19.wav"
		"wave" "#music/contagion/l4d2_rabies_20.wav"
		"wave" "#music/contagion/l4d2_rabies_21.wav"
		"wave" "#music/contagion/l4d2_rabies_22.wav"

		"wave" "#music/contagion/L4D_Rabies_01.wav"
		"wave" "#music/contagion/L4D_Rabies_02.wav"
		"wave" "#music/contagion/L4D_Rabies_03.wav"
		"wave" "#music/contagion/L4D_Rabies_04.wav"
		"wave" "#music/contagion/L4D_Rabies_05.wav"
		"wave" "#music/contagion/L4D_Rabies_06.wav"
		"wave" "#music/contagion/L4D_Rabies_07.wav"
		"wave" "#music/contagion/L4D_Rabies_08.wav"
		"wave" "#music/contagion/L4D_Rabies_09.wav"
		"wave" "#music/contagion/L4D_Rabies_10.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

"Event.DangerAtmosphere_Mall"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/c1rabies_01.wav"
		"wave" "#music/contagion/c1rabies_02.wav"
		"wave" "#music/contagion/c1rabies_03.wav"
		"wave" "#music/contagion/c1rabies_04.wav"
		"wave" "#music/contagion/c1rabies_05.wav"
		"wave" "#music/contagion/c1rabies_06.wav"
		"wave" "#music/contagion/c1rabies_07.wav"
		"wave" "#music/contagion/c1rabies_08.wav"
		"wave" "#music/contagion/c1rabies_09.wav"
		"wave" "#music/contagion/c1rabies_10.wav"
		"wave" "#music/contagion/c1rabies_11.wav"
		"wave" "#music/contagion/c1rabies_12.wav"
		"wave" "#music/contagion/c1rabies_13.wav"
		"wave" "#music/contagion/c1rabies_14.wav"

		"wave" "#music/contagion/l4d2_rabies_01.wav"
		"wave" "#music/contagion/l4d2_rabies_02.wav"
		"wave" "#music/contagion/l4d2_rabies_03.wav"
		"wave" "#music/contagion/l4d2_rabies_04.wav"
		"wave" "#music/contagion/l4d2_rabies_05.wav"
		"wave" "#music/contagion/l4d2_rabies_06.wav"
		"wave" "#music/contagion/l4d2_rabies_07.wav"
		"wave" "#music/contagion/l4d2_rabies_08.wav"
		"wave" "#music/contagion/l4d2_rabies_09.wav"
		"wave" "#music/contagion/l4d2_rabies_10.wav"
		"wave" "#music/contagion/l4d2_rabies_11.wav"
		"wave" "#music/contagion/l4d2_rabies_12.wav"
		"wave" "#music/contagion/l4d2_rabies_13.wav"
		"wave" "#music/contagion/l4d2_rabies_14.wav"
		"wave" "#music/contagion/l4d2_rabies_15.wav"
		"wave" "#music/contagion/l4d2_rabies_16.wav"
		"wave" "#music/contagion/l4d2_rabies_17.wav"
		"wave" "#music/contagion/l4d2_rabies_18.wav"
		"wave" "#music/contagion/l4d2_rabies_19.wav"
		"wave" "#music/contagion/l4d2_rabies_20.wav"
		"wave" "#music/contagion/l4d2_rabies_21.wav"
		"wave" "#music/contagion/l4d2_rabies_22.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}
"Event.DangerAtmosphere_Fairgrounds"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/C2Rabies_01.wav"
		"wave" "#music/contagion/C2Rabies_02.wav"
		"wave" "#music/contagion/C2Rabies_03.wav"
		"wave" "#music/contagion/C2Rabies_04.wav"
		"wave" "#music/contagion/C2Rabies_05.wav"
		"wave" "#music/contagion/C2Rabies_06.wav"
		"wave" "#music/contagion/C2Rabies_07.wav"
		"wave" "#music/contagion/C2Rabies_08.wav"
		"wave" "#music/contagion/C2Rabies_09.wav"
		"wave" "#music/contagion/C2Rabies_10.wav"

		"wave" "#music/contagion/l4d2_rabies_01.wav"
		"wave" "#music/contagion/l4d2_rabies_02.wav"
		"wave" "#music/contagion/l4d2_rabies_03.wav"
		"wave" "#music/contagion/l4d2_rabies_04.wav"
		"wave" "#music/contagion/l4d2_rabies_05.wav"
		"wave" "#music/contagion/l4d2_rabies_06.wav"
		"wave" "#music/contagion/l4d2_rabies_07.wav"
		"wave" "#music/contagion/l4d2_rabies_08.wav"
		"wave" "#music/contagion/l4d2_rabies_09.wav"
		"wave" "#music/contagion/l4d2_rabies_10.wav"
		"wave" "#music/contagion/l4d2_rabies_11.wav"
		"wave" "#music/contagion/l4d2_rabies_12.wav"
		"wave" "#music/contagion/l4d2_rabies_13.wav"
		"wave" "#music/contagion/l4d2_rabies_14.wav"
		"wave" "#music/contagion/l4d2_rabies_15.wav"
		"wave" "#music/contagion/l4d2_rabies_16.wav"
		"wave" "#music/contagion/l4d2_rabies_17.wav"
		"wave" "#music/contagion/l4d2_rabies_18.wav"
		"wave" "#music/contagion/l4d2_rabies_19.wav"
		"wave" "#music/contagion/l4d2_rabies_20.wav"
		"wave" "#music/contagion/l4d2_rabies_21.wav"
		"wave" "#music/contagion/l4d2_rabies_22.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

"Event.DangerAtmosphere_Plankcountry"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.45, 0.65"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/C3Rabies_01.wav"
		"wave" "#music/contagion/C3Rabies_02.wav"
		"wave" "#music/contagion/C3Rabies_03.wav"
		"wave" "#music/contagion/C3Rabies_04.wav"
		"wave" "#music/contagion/C3Rabies_05.wav"
		"wave" "#music/contagion/C3Rabies_06.wav"
		"wave" "#music/contagion/C3Rabies_07.wav"
		"wave" "#music/contagion/C3Rabies_08.wav"
		"wave" "#music/contagion/C3Rabies_09.wav"
		"wave" "#music/contagion/C3Rabies_10.wav"

		"wave" "#music/contagion/l4d2_rabies_01.wav"
		"wave" "#music/contagion/l4d2_rabies_02.wav"
		"wave" "#music/contagion/l4d2_rabies_03.wav"
		"wave" "#music/contagion/l4d2_rabies_04.wav"
		"wave" "#music/contagion/l4d2_rabies_05.wav"
		"wave" "#music/contagion/l4d2_rabies_06.wav"
		"wave" "#music/contagion/l4d2_rabies_07.wav"
		"wave" "#music/contagion/l4d2_rabies_08.wav"
		"wave" "#music/contagion/l4d2_rabies_09.wav"
		"wave" "#music/contagion/l4d2_rabies_10.wav"
		"wave" "#music/contagion/l4d2_rabies_11.wav"
		"wave" "#music/contagion/l4d2_rabies_12.wav"
		"wave" "#music/contagion/l4d2_rabies_13.wav"
		"wave" "#music/contagion/l4d2_rabies_14.wav"
		"wave" "#music/contagion/l4d2_rabies_15.wav"
		"wave" "#music/contagion/l4d2_rabies_16.wav"
		"wave" "#music/contagion/l4d2_rabies_17.wav"
		"wave" "#music/contagion/l4d2_rabies_18.wav"
		"wave" "#music/contagion/l4d2_rabies_19.wav"
		"wave" "#music/contagion/l4d2_rabies_20.wav"
		"wave" "#music/contagion/l4d2_rabies_21.wav"
		"wave" "#music/contagion/l4d2_rabies_22.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

"Event.DangerAtmosphere_Milltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/C4Rabies_01.wav"
		"wave" "#music/contagion/C4Rabies_02.wav"
		"wave" "#music/contagion/C4Rabies_03.wav"
		"wave" "#music/contagion/C4Rabies_04.wav"
		"wave" "#music/contagion/C4Rabies_05.wav"
		"wave" "#music/contagion/C4Rabies_06.wav"
		"wave" "#music/contagion/C4Rabies_07.wav"
		"wave" "#music/contagion/C4Rabies_08.wav"
		"wave" "#music/contagion/C4Rabies_09.wav"
		"wave" "#music/contagion/C4Rabies_10.wav"
		"wave" "#music/contagion/C4Rabies_11.wav"
		"wave" "#music/contagion/C4Rabies_12.wav"
		"wave" "#music/contagion/C4Rabies_13.wav"
		"wave" "#music/contagion/C4Rabies_14.wav"
		"wave" "#music/contagion/C4Rabies_15.wav"

		"wave" "#music/contagion/l4d2_rabies_01.wav"
		"wave" "#music/contagion/l4d2_rabies_02.wav"
		"wave" "#music/contagion/l4d2_rabies_03.wav"
		"wave" "#music/contagion/l4d2_rabies_04.wav"
		"wave" "#music/contagion/l4d2_rabies_05.wav"
		"wave" "#music/contagion/l4d2_rabies_06.wav"
		"wave" "#music/contagion/l4d2_rabies_07.wav"
		"wave" "#music/contagion/l4d2_rabies_08.wav"
		"wave" "#music/contagion/l4d2_rabies_09.wav"
		"wave" "#music/contagion/l4d2_rabies_10.wav"
		"wave" "#music/contagion/l4d2_rabies_11.wav"
		"wave" "#music/contagion/l4d2_rabies_12.wav"
		"wave" "#music/contagion/l4d2_rabies_13.wav"
		"wave" "#music/contagion/l4d2_rabies_14.wav"
		"wave" "#music/contagion/l4d2_rabies_15.wav"
		"wave" "#music/contagion/l4d2_rabies_16.wav"
		"wave" "#music/contagion/l4d2_rabies_17.wav"
		"wave" "#music/contagion/l4d2_rabies_18.wav"
		"wave" "#music/contagion/l4d2_rabies_19.wav"
		"wave" "#music/contagion/l4d2_rabies_20.wav"
		"wave" "#music/contagion/l4d2_rabies_21.wav"
		"wave" "#music/contagion/l4d2_rabies_22.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}
"Event.DangerAtmosphere_BigEasy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/C5Rabies_01.wav"
		"wave" "#music/contagion/C5Rabies_02.wav"
		"wave" "#music/contagion/C5Rabies_03.wav"
		"wave" "#music/contagion/C5Rabies_04.wav"
		"wave" "#music/contagion/C5Rabies_05.wav"
		"wave" "#music/contagion/C5Rabies_06.wav"
		"wave" "#music/contagion/C5Rabies_07.wav"
		"wave" "#music/contagion/C5Rabies_08.wav"
		"wave" "#music/contagion/C5Rabies_09.wav"
		"wave" "#music/contagion/C5Rabies_10.wav"
		"wave" "#music/contagion/C5Rabies_11.wav"
		"wave" "#music/contagion/C5Rabies_12.wav"
		"wave" "#music/contagion/C5Rabies_13.wav"
		"wave" "#music/contagion/C5Rabies_14.wav"
		"wave" "#music/contagion/C5Rabies_15.wav"

		"wave" "#music/contagion/l4d2_rabies_01.wav"
		"wave" "#music/contagion/l4d2_rabies_02.wav"
		"wave" "#music/contagion/l4d2_rabies_03.wav"
		"wave" "#music/contagion/l4d2_rabies_04.wav"
		"wave" "#music/contagion/l4d2_rabies_05.wav"
		"wave" "#music/contagion/l4d2_rabies_06.wav"
		"wave" "#music/contagion/l4d2_rabies_07.wav"
		"wave" "#music/contagion/l4d2_rabies_08.wav"
		"wave" "#music/contagion/l4d2_rabies_09.wav"
		"wave" "#music/contagion/l4d2_rabies_10.wav"
		"wave" "#music/contagion/l4d2_rabies_11.wav"
		"wave" "#music/contagion/l4d2_rabies_12.wav"
		"wave" "#music/contagion/l4d2_rabies_13.wav"
		"wave" "#music/contagion/l4d2_rabies_14.wav"
		"wave" "#music/contagion/l4d2_rabies_15.wav"
		"wave" "#music/contagion/l4d2_rabies_16.wav"
		"wave" "#music/contagion/l4d2_rabies_17.wav"
		"wave" "#music/contagion/l4d2_rabies_18.wav"
		"wave" "#music/contagion/l4d2_rabies_19.wav"
		"wave" "#music/contagion/l4d2_rabies_20.wav"
		"wave" "#music/contagion/l4d2_rabies_21.wav"
		"wave" "#music/contagion/l4d2_rabies_22.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

// --------------------------------------------------------------------
// See: game_sounds_music_lighthouse.txt
// --------------------------------------------------------------------
// danger
//"Event.DangerAtmosphere_Lighthouse"
//{
//	"channel"		"CHAN_STATIC"
//	"volume"		"0.6, 0.8"
//	"soundlevel"	"SNDLVL_NONE"
//	"rndwave"
//	{
//		"wave" "#music/contagion/DT_Rabies_01.wav"
//		"wave" "#music/contagion/DT_Rabies_02.wav"
//		"wave" "#music/contagion/DT_Rabies_03.wav"
//		"wave" "#music/contagion/DT_Rabies_04.wav"
//		"wave" "#music/contagion/DT_Rabies_05.wav"
//		"wave" "#music/contagion/DT_Rabies_06.wav"
//		"wave" "#music/contagion/DT_Rabies_07.wav"
//		"wave" "#music/contagion/DT_Rabies_08.wav"
//		"wave" "#music/contagion/DT_Rabies_09.wav"
//		"wave" "#music/contagion/DT_Rabies_10.wav"

//		"wave" "#music/contagion/L4D_Rabies_01.wav"
//		"wave" "#music/contagion/L4D_Rabies_02.wav"
//		"wave" "#music/contagion/L4D_Rabies_03.wav"
//		"wave" "#music/contagion/L4D_Rabies_04.wav"
//		"wave" "#music/contagion/L4D_Rabies_05.wav"
//		"wave" "#music/contagion/L4D_Rabies_06.wav"
//		"wave" "#music/contagion/L4D_Rabies_07.wav"
//		"wave" "#music/contagion/L4D_Rabies_08.wav"
//		"wave" "#music/contagion/L4D_Rabies_09.wav"
//		"wave" "#music/contagion/L4D_Rabies_10.wav"
//	}

//	GameData
//	{
//		"MusicPriority"			"LOW"
//		"MusicTrack"            "ambient"	
//		"MusicFadeOut"         	"1.0"
//	}
//}

// --------------------------------------------------------------------
// Zombie choir
//
// --------------------------------------------------------------------
"Event.ZombieChoir"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7, 1.0"
	"soundlevel"	"SNDLVL_150dB"

	"rndwave"
	{
		"wave"		"music/zombiechoir/ZombieChoir_01.wav"
		"wave"		"music/zombiechoir/ZombieChoir_02.wav"
		"wave"		"music/zombiechoir/ZombieChoir_03.wav"
		"wave"		"music/zombiechoir/ZombieChoir_04.wav"
		"wave"		"music/zombiechoir/ZombieChoir_05.wav"
		"wave"		"music/zombiechoir/ZombieChoir_06.wav"
		"wave"		"music/zombiechoir/ZombieChoir_07.wav"

	}	
	GameData
	{
		"MusicTrack"            "zombiechoir"
		"MusicPriority"			"CRITICAL"
	}
}

///////////////////////////////////////////////////////////
// "Reveal" - We just moved into a large open space
//
"Event.LargeAreaRevealed"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.8"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/glimpse/AGlimpseOfDeath_01.wav"
		"wave"			"#music/glimpse/AGlimpseOfDeath_02.wav"
		"wave"			"#music/glimpse/AGlimpseOfDeath_03.wav"
	}
	GameData
	{
		"MusicTrack"            "glimpse"
	}
}
///////////////////////////////////////////////////////////
//
"Event.MarchingIn"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.80"
	"soundlevel"	"SNDLVL_150dB"

	"wave"			"music/flu/TheSaintsWillNeverCome.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "jukebox"
	}
}

///////////////////////////////////////////////////////////
//
"Event.AmbientMob"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"music/infection/infection_09_01.wav"
		"wave"			"music/infection/infection_10_01.wav"
		"wave"			"music/infection/infection_11_01.wav"
	}

	GameData
	{
		"MusicTrack"            "infection"
	}
}

"c2m2.carousel_music"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"  	"SNDLVL_130dB"
	"pitch"			"PITCH_NORM"
	"wave"	"music/flu/RocketRide.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "jukebox"
		"MusicTrack"            "concert"
	}
}

"c2m4.Ridin1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.85"
	"soundlevel"	"SNDLVL_150dB"
	"pitch"			"100"

	"wave"	")music/flu/concert/midnightride.wav"

	GameData
	{
		"MusicBlockTrackList"    "finaleStart, zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicStopTrackList"    "finaleStart, zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "concert1"

    }
}

"c2m4.Ridin2"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.85"
	"soundlevel"	"SNDLVL_150dB"
	"pitch"			"100"

	"wave"	")music/flu/concert/midnightride.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "concert2"
    }
}

"c2m4.BadMan1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.85"
	"soundlevel"	"SNDLVL_150dB"
	"pitch"			"100"

	"wave"	")music/flu/concert/onebadman.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "concert1"
    }
}
"c2m4.BadMan2"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.85"
	"soundlevel"	"SNDLVL_150dB"
	"pitch"			"100"

	"wave"	")music/flu/concert/onebadman.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "concert2"
    }
}


//------------------------------------------
//  Jukebox music
//------------------------------------------
"Jukebox.BadMan1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1"
	"soundlevel"	"SNDLVL_80dB"
	"pitch"			"100"

	"wave"	"*music/flu/jukebox/BadMan.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "jukebox"
	}
}

"Jukebox.Ridin1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1"
	"soundlevel"	"SNDLVL_80dB"
	"pitch"			"100"

	"wave"	"*music/flu/jukebox/MidnightRide.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "jukebox"
	}
}
"Jukebox.AllIWantForXmas"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1"
	"soundlevel"	"SNDLVL_80dB"
	"pitch"			"100"

	"wave"	"*music/flu/jukebox/all_i_want_for_xmas.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "jukebox"
	}
}

"Jukebox.saints_will_never_come"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_80dB"

	"wave"			"*music/flu/jukebox/TheSaintsWillNeverCome.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "jukebox"
	}
}

"Jukebox.re_your_brains"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"  		"SNDLVL_80dB"
	"pitch"			"PITCH_NORM"
	"wave"	"*music/flu/jukebox/re_your_brains.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "jukebox"
	}
}


"Jukebox.still_alive"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"  		"SNDLVL_80dB"
	"pitch"			"PITCH_NORM"
	"wave"	"*music/flu/jukebox/portal_still_alive.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "jukebox"
	}
}
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
// Sacrifice - Docks - Highrise
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

"Event.MissionStart_Sacrifice"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/stmusic/TheSacrifice.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_Sacrifice"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"	
		"MusicMasterTags"
		{
			// "loopStart" "76.146"
			"loopStart" "107.252"

		}
	}
}
"Event.MissionStart_BaseLoop_Sacrifice"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/cpmusic/PrayForDeath.wav"

	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

// --------------------------------------------------------------------
// checkpoints
// --------------------------------------------------------------------

"Event.CheckPointIntro_Sacrifice"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/YouHadBetterPray.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_Sacrifice"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"NO_INTENSITY_TRACK"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_Sacrifice"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/cpmusic/PrayForDeath.wav"

	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

// --------------------------------------------------------------------
// when you first leave a checkpoint
"Event.LeavingSafety_Sacrifice"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}

// --------------------------------------------------------------------
// starting atmosphere after leaving checkpoint
"Event.StartAtmosphere_Sacrifice"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
		
		"wave" "#music/contagion/NM_Quarantine_01.wav"
		"wave" "#music/contagion/NM_Quarantine_02.wav"
		"wave" "#music/contagion/NM_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
	}
}

// --------------------------------------------------------------------
// zombat music - Used only in survivorset = "2"
// --------------------------------------------------------------------

"Event.Zombat2_Intro_Sacrifice"  
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

//	"rndwave"
//	{
//		"wave"			"#music/zombat/slayer/HordeSlayer_01.wav"
//		"wave"			"#music/zombat/slayer/HordeSlayer_02.wav"
//		"wave"			"#music/zombat/slayer/HordeSlayer_03.wav"
//		"wave"			"#music/zombat/slayer/HordeSlayer_04.wav"
		"wave"			"#music/zombat/slayer/lectric/Slayer_01a.wav"
//	}


	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Mall"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}

// --------------------------------------------------------------------
// Danger
// --------------------------------------------------------------------
"Event.Zombat3_Intro_Sacrifice"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
		"wave"			"#music/zombat/danger/HordeDanger_02.wav"
		"wave"			"#music/zombat/danger/HordeDanger_03.wav"
		"wave"			"#music/zombat/danger/HordeDanger_04.wav"
	}

	GameData
	{
// 		"MusicAutoQueue"        "Event.Zombat3_A_Sacrifice"
		"MusicTrack"            "zombat3"
// 		"MusicTagDelay"         "1, 7"
// 		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

// "Event.Zombat3_A_Sacrifice"
// {
// 	"channel"		"CHAN_STATIC"
// 	"volume"		"0.77"
// 	"soundlevel"	"SNDLVL_NONE"


// 	"wave"			"#music/zombat/danger/HordeDanger_01.wav"


// 	GameData
// 	{
// 		"MusicAutoQueue"        "Event.Zombat3_B_Sacrifice"
// 		"MusicTrack"            "zombat3"
// 		"MusicTagTrack"         "zombat"
// 		"MusicPriority"			"CRITICAL"
// 		"MusicTagDelay"         "1, 7"
// 	}
// }
// "Event.Zombat3_B_Sacrifice"
// {
// 	"channel"		"CHAN_STATIC"
// 	"volume"		"0.77"
// 	"soundlevel"	"SNDLVL_NONE"

// 	"wave"			"#music/zombat/danger/HordeDanger_01.wav"


// 	GameData
// 	{
// 		"MusicAutoQueue"        "Event.Zombat3_A_Sacrifice"
// 		"MusicTrack"            "zombat3"
// 		"MusicTagTrack"         "zombat"
// 		"MusicTagDelay"         "1, 7"
// 		"MusicPriority"			"CRITICAL"
// 	}
// }



"Event.MobSignal1_Sacrifice"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL1a.wav"
 		"wave"	"#music/mob/GermL1b.wav"
 		"wave"	"#music/mob/GermM1a.wav"
 		"wave"	"#music/mob/GermM1b.wav"
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
 		"wave"	"#music/mob/GermX1a.wav"
 		"wave"	"#music/mob/GermX1b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}
"Event.MobSignal2_Sacrifice"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL2a.wav"
 		"wave"	"#music/mob/GermL2b.wav"
 		"wave"	"#music/mob/GermM2a.wav"
 		"wave"	"#music/mob/GermM2b.wav"
 		"wave"	"#music/mob/GermS2a.wav"
 		"wave"	"#music/mob/GermS2b.wav"
 		"wave"	"#music/mob/GermX2a.wav"
 		"wave"	"#music/mob/GermX2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

///////////////////////////////// Atmosphere!! //////////////////////////

"Event.SafeAtmosphere_Sacrifice"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
		
		"wave" "#music/contagion/NM_Quarantine_01.wav"
		"wave" "#music/contagion/NM_Quarantine_02.wav"
		"wave" "#music/contagion/NM_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}


// danger

"Event.DangerAtmosphere_Sacrifice"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{

		"wave" "#music/contagion/l4d2_rabies_01.wav"
		"wave" "#music/contagion/l4d2_rabies_02.wav"
		"wave" "#music/contagion/l4d2_rabies_03.wav"
		"wave" "#music/contagion/l4d2_rabies_04.wav"
		"wave" "#music/contagion/l4d2_rabies_05.wav"
		"wave" "#music/contagion/l4d2_rabies_06.wav"
		"wave" "#music/contagion/l4d2_rabies_07.wav"
		"wave" "#music/contagion/l4d2_rabies_08.wav"
		"wave" "#music/contagion/l4d2_rabies_09.wav"
		"wave" "#music/contagion/l4d2_rabies_10.wav"
		"wave" "#music/contagion/l4d2_rabies_11.wav"
		"wave" "#music/contagion/l4d2_rabies_12.wav"
		"wave" "#music/contagion/l4d2_rabies_13.wav"
		"wave" "#music/contagion/l4d2_rabies_14.wav"
		"wave" "#music/contagion/l4d2_rabies_15.wav"
		"wave" "#music/contagion/l4d2_rabies_16.wav"
		"wave" "#music/contagion/l4d2_rabies_17.wav"
		"wave" "#music/contagion/l4d2_rabies_18.wav"
		"wave" "#music/contagion/l4d2_rabies_19.wav"
		"wave" "#music/contagion/l4d2_rabies_20.wav"
		"wave" "#music/contagion/l4d2_rabies_21.wav"
		"wave" "#music/contagion/l4d2_rabies_22.wav"

		"wave" "#music/contagion/L4D_Rabies_01.wav"
		"wave" "#music/contagion/L4D_Rabies_02.wav"
		"wave" "#music/contagion/L4D_Rabies_03.wav"
		"wave" "#music/contagion/L4D_Rabies_04.wav"
		"wave" "#music/contagion/L4D_Rabies_05.wav"
		"wave" "#music/contagion/L4D_Rabies_06.wav"
		"wave" "#music/contagion/L4D_Rabies_07.wav"
		"wave" "#music/contagion/L4D_Rabies_08.wav"
		"wave" "#music/contagion/L4D_Rabies_09.wav"
		"wave" "#music/contagion/L4D_Rabies_10.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
// NoMercy - Hospital
//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------

"Event.MissionStart_NoMercy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/stmusic/nomercy.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_NoMercy"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"	
		"MusicMasterTags"
		{
			// "loopStart" "76.146"
			"loopStart" "107.252"

		}
	}
}
"Event.MissionStart_BaseLoop_NoMercy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/nomercyforyou.wav"
//		"wave"			"#music/cpmusic/nomercyforyou2.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

// --------------------------------------------------------------------
// checkpoints
// --------------------------------------------------------------------

"Event.CheckPointIntro_NoMercy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/nomercyintro.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_NoMercy"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"NO_INTENSITY_TRACK"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_NoMercy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/nomercyforyou.wav"
		"wave"			"#music/cpmusic/nomercyforyou2.wav"
 	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

// --------------------------------------------------------------------
// when you first leave a checkpoint
"Event.LeavingSafety_NoMercy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}

// --------------------------------------------------------------------
// starting atmosphere after leaving checkpoint
"Event.StartAtmosphere_NoMercy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/NM_Quarantine_01.wav"
		"wave" "#music/contagion/NM_Quarantine_02.wav"
		"wave" "#music/contagion/NM_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
	}
}

// --------------------------------------------------------------------
// zombat music
// --------------------------------------------------------------------

"Event.Zombat2_Intro_NoMercy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/slayer/HordeSlayer_01.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_02.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_03.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_04.wav"
	}

	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Mall"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}

// --------------------------------------------------------------------
// Danger
// --------------------------------------------------------------------
"Event.Zombat3_Intro_NoMercy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7" 
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
		"wave"			"#music/zombat/danger/HordeDanger_02.wav"
		"wave"			"#music/zombat/danger/HordeDanger_03.wav"
		"wave"			"#music/zombat/danger/HordeDanger_04.wav"
	}

	GameData
	{
//		"MusicAutoQueue"        "Event.Zombat3_A_NoMercy"
		"MusicTrack"            "zombat3"
//		"MusicTagDelay"         "1, 7"
			//	"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

// "Event.Zombat3_A_NoMercy"
// {
// 	"channel"		"CHAN_STATIC"
// 	"volume"		"0.77"
// 	"soundlevel"	"SNDLVL_NONE"

// 	"wave"			"#music/zombat/danger/Hordedanger_01.wav"


// 	GameData
// 	{
// 		"MusicAutoQueue"        "Event.Zombat3_B_NoMercy"
// 		"MusicTrack"            "zombat3"
// 		"MusicTagTrack"         "zombat"
// 		"MusicPriority"			"CRITICAL"
// 		"MusicTagDelay"         "1, 7"
// 	}
// }
// "Event.Zombat3_B_NoMercy"
// {
// 	"channel"		"CHAN_STATIC"
// 	"volume"		"0.77"
// 	"soundlevel"	"SNDLVL_NONE"

// 	"wave"			"#music/zombat/danger/Hordedanger_01.wav"


// 	GameData
// 	{
// 		"MusicAutoQueue"        "Event.Zombat3_A_NoMercy"
// 		"MusicTrack"            "zombat3"
// 		"MusicTagTrack"         "zombat"
// 		"MusicTagDelay"         "1, 7"
// 		"MusicPriority"			"CRITICAL"
// 	}
// }


///////////////////////////////// Zombies!! //////////////////////////
// L4D2
// Hospital
// S
"Event.MobSignal1_NoMercy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.5, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL1a.wav"
 		"wave"	"#music/mob/GermL1b.wav"
 		"wave"	"#music/mob/GermM1a.wav"
 		"wave"	"#music/mob/GermM1b.wav"
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
 		"wave"	"#music/mob/GermX1a.wav"
 		"wave"	"#music/mob/GermX1b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}
"Event.MobSignal2_NoMercy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.5, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL2a.wav"
 		"wave"	"#music/mob/GermL2b.wav"
 		"wave"	"#music/mob/GermM2a.wav"
 		"wave"	"#music/mob/GermM2b.wav"
 		"wave"	"#music/mob/GermS2a.wav"
 		"wave"	"#music/mob/GermS2b.wav"
 		"wave"	"#music/mob/GermX2a.wav"
 		"wave"	"#music/mob/GermX2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

///////////////////////////////// Atmosphere!! //////////////////////////

"Event.SafeAtmosphere_NoMercy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/NM_Quarantine_01.wav"
		"wave" "#music/contagion/NM_Quarantine_02.wav"
		"wave" "#music/contagion/NM_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}


// danger

"Event.DangerAtmosphere_NoMercy"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/NM_Rabies_01.wav"
		"wave" "#music/contagion/NM_Rabies_02.wav"
		"wave" "#music/contagion/NM_Rabies_03.wav"
		"wave" "#music/contagion/NM_Rabies_04.wav"
		"wave" "#music/contagion/NM_Rabies_05.wav"
		"wave" "#music/contagion/NM_Rabies_06.wav"
		"wave" "#music/contagion/NM_Rabies_07.wav"
		"wave" "#music/contagion/NM_Rabies_08.wav"
		"wave" "#music/contagion/NM_Rabies_09.wav"
		"wave" "#music/contagion/NM_Rabies_10.wav"

		"wave" "#music/contagion/L4D_Rabies_01.wav"
		"wave" "#music/contagion/L4D_Rabies_02.wav"
		"wave" "#music/contagion/L4D_Rabies_03.wav"
		"wave" "#music/contagion/L4D_Rabies_04.wav"
		"wave" "#music/contagion/L4D_Rabies_05.wav"
		"wave" "#music/contagion/L4D_Rabies_06.wav"
		"wave" "#music/contagion/L4D_Rabies_07.wav"
		"wave" "#music/contagion/L4D_Rabies_08.wav"
		"wave" "#music/contagion/L4D_Rabies_09.wav"
		"wave" "#music/contagion/L4D_Rabies_10.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
//                                       L4D1 Default Music                                       //
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

// -----------------------------------------------------------------------------------------------//
//											combat music                                          //
// -----------------------------------------------------------------------------------------------//
"Event.ZombatIntro_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/zombat/GatesOfHell.wav"
		
	GameData
	{
		"MusicTrack"            "zombatIntro"
		"MusicAutoQueue"        "Event.Zombat_L4D1"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.Zombat_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave"			"#music/zombat/Horde_01.wav"
		"wave"			"#music/zombat/Horde_02.wav"
		"wave"			"#music/zombat/Horde_03.wav"
		"wave"			"#music/zombat/Horde_04.wav"
	}
	GameData
	{
		"MusicAutoQueue"		"Event.Zombat_A_L4D1"
		"MusicTrack"			"zombat"
		"MusicPriority"		"CRITICAL"
		"MusicMasterDivTags"	"8"
		"MusicTagDelay"		"7"
//		"MusicTagIndex"		"2"
// 		"MusicMasterTags"
//		{
//			"tag1" "1.033"
//			"tag2" "2.806"
//			"tag3" "5.647"
//		}
	}
}
"Event.Zombat_A_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/Horde_02.wav"
		"wave"			"#music/zombat/Horde_03.wav"
	}
	GameData
	{
		"MusicAutoQueue"		"Event.Zombat_B_L4D1"
		"MusicTrack"			"zombat"
		"MusicTagTrack"		"zombat"
		"MusicPriority"		"CRITICAL"
		"MusicMasterDivTags"	"8.0"
		"MusicTagDelay"		"7"
//		"MusicTagIndex"		"2"
// 		"MusicMasterTags"
//		{
//			"tag1" "1.033"
//			"tag2" "2.806"
//			"tag3" "5.647"
//		}
	}
}
"Event.Zombat_B_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/Horde_02.wav"
		"wave"			"#music/zombat/Horde_04.wav"
	}
	GameData
	{
		"MusicAutoQueue"		"Event.Zombat_A_L4D1"
		"MusicTrack"			"zombat"
		"MusicTagTrack"		"zombat"
		"MusicPriority"		"CRITICAL"
		"MusicMasterDivTags"	"8.0"
		"MusicTagDelay"		"7"
//		"MusicTagIndex"		"2"
// 		"MusicMasterTags"
//		{
//			"tag1" "1.033"
//			"tag2" "2.806"
//			"tag3" "5.647"
//		}
	}
}

"Event.Zombat2_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9" //og: 0.7
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/slayer/HordeSlayer_01.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_02.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_03.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_04.wav"
	}

	GameData
	{
		"MusicTrack"			"zombat2"
		"MusicTagTrack"		"zombat"
		"MusicPriority"		"CRITICAL"
		"MusicMasterDivTags" 	"4.0"
	}
}

"Event.Zombat3_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7" //og: 1.0
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
		"wave"			"#music/zombat/danger/HordeDanger_02.wav"
		"wave"			"#music/zombat/danger/HordeDanger_03.wav"
		"wave"			"#music/zombat/danger/HordeDanger_04.wav"
	}

	GameData
	{
		"MusicTrack"			"zombat3"  //og: zombatMobbed
		"MusicTagTrack"		"zombat"
		"MusicPriority"		"CRITICAL" //og: HIGH
	}
}

// Down
// Survivor is down and being beaten by infected
"Event.Down_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/terror/PuddleOfYou_l4d1.wav"

	GameData
	{
		"MusicTrack"            "down"
		"MusicPriority"			"CRITICAL"
		"MusicMaster"		"PLAY_SPLIT"
	}		
}
// Down
// Survivor is down and being beaten by infected
"Event.DownHit_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"music/tags/PuddleOfYouHit_l4d1.wav"

	GameData
	{
		"MusicTrack"            "downHits"
		"MusicPriority"			"CRITICAL"
	}		
}

// BleedingOut
// This cue starts exactly 10 seconds before death as the health meter clicks down.
"Event.BleedingOut_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/terror/IAmSoCold_l4d1.wav"

	GameData
	{
		"MusicTrack"            "down"
		"MusicPriority"			 "CRITICAL"
		"MusicMaster"		"PLAY_SPLIT"

	}		
}
// This cue starts exactly 10 seconds before death as the health meter clicks down.
"Event.BleedingOutHit_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"music/tags/IAmSoColdHit_l4d1.wav"

	GameData
	{
		"MusicTrack"            "downHits"
		"MusicPriority"			"CRITICAL"
	}		
}

// This cue starts exactly 10 seconds before death as the health meter clicks down.
"Event.BleedingOutEnd_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/terror/TheEnd_l4d1.wav"

	GameData
	{
		"MusicTrack"            "down"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_SPLIT"

	}		
}

// Survivor death
// This is for the death of an individual survivor to be played after the health meter has reached zero
"Event.SurvivorDeath_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/undeath/LeftForDeath_l4d1.wav"
	
	GameData
	{
		"MusicTrack"            "default"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH"
// Originaly it was changed from "PLAY_SPLIT" to "PLAY_SPLIT | DONT_DISENGAGE" in order to fix the bug where this cue wouldn't play if you were spectating on someone
// This resulted in the cue playing for Infected players after killing one of the survivors alongside making any other sound playing quieter. Changing it back to "PLAY_SPLIT" fixes it
		"MusicMaster"           "PLAY_SPLIT"

	}
}

"Event.SurvivorDeathHit_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"
	"wave"			"music/tags/LeftForDeathHit_l4d1.wav"
	
	GameData
	{
		"MusicTrack"            "deathHits"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH"
	}
}

"Event.ScenarioLose_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/undeath/Death_l4d1.wav"
	
	GameData
	{
		"MusicTrack"            "default"
		"MusicMaster"           "PLAY_TO_END | DONT_DISENGAGE"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH | AFTER_MISSION_END"
	}
}


///////////////////////////////// Finale!! //////////////////////////
//
// FINALE
//

// Final battle
// For the final battle before getting rescued"Event.FinalBattle"
"Event.FinalBattle_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/the_end/SkinOnOurTeeth_l4d1.wav"

	GameData
	{
		"MusicTrack"            "default"
		"MusicPriority"			"HIGH"
		"MusicFadeOut"         	"2.0"
		"MusicBlockTrackList"   "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient, tank"
		"MusicStopTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient, tank"
	}
}


///////////////////////////////// Scenario finish!! //////////////////////////
"Event.ScenarioWin_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/unalive/TheMonstersWithin_l4d1.wav"
	
	GameData
	{
		"MusicTrack"            "default"
		"MusicMaster"           "PLAY_TO_END | DONT_DISENGAGE"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH | AFTER_MISSION_END"
	}
}
"Event.SafeRoom_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"
	"wave"			"#music/safe/TheMonstersWithout_l4d1.wav"
	
	GameData
	{
		"MusicTrack"            "default"
		"MusicMaster"           "PLAY_TO_END | DONT_DISENGAGE"
		"MusicPriority"			"CRITICAL"
		"MusicParameters"		"AFTER_DEATH | AFTER_MISSION_END"
	}
}

// --------------------------------------------------------------------
// Zombie choir
//
// --------------------------------------------------------------------
"Event.ZombieChoir_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_150dB"

	"rndwave"
	{
		"wave"		"music/zombiechoir/ZombieChoir_01_l4d1.wav"
		"wave"		"music/zombiechoir/ZombieChoir_02_l4d1.wav"
		"wave"		"music/zombiechoir/ZombieChoir_03_l4d1.wav"
		"wave"		"music/zombiechoir/ZombieChoir_04_l4d1.wav"
		"wave"		"music/zombiechoir/ZombieChoir_05_l4d1.wav"
		"wave"		"music/zombiechoir/ZombieChoir_06_l4d1.wav"
		"wave"		"music/zombiechoir/ZombieChoir_07_l4d1.wav"
	}	
	GameData
	{
		"MusicTrack"            "zombiechoir"
		"MusicPriority"			"CRITICAL"
	}
}

///////////////////////////////////////////////////////////
// "Reveal" - We just moved into a large open space
//
"Event.LargeAreaRevealed_L4D1"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/glimpse/AGlimpseOfHell_01.wav"
		"wave"			"#music/glimpse/AGlimpseOfHell_02.wav"
		"wave"			"#music/glimpse/AGlimpseOfHell_03.wav"
	}
	GameData
	{
		"MusicTrack"            "glimpse"
	}
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
// Events 
//
"Event.MissionStart_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/stmusic/DeadLightDistrict.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_DeadLight"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"	
		"MusicMasterTags"
		{
			// "loopStart" "76.146"
			"loopStart" "76.563"

		}
	}
}
"Event.MissionStart_BaseLoop_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForDeath.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

// --------------------------------------------------------------------
// checkpoints
// --------------------------------------------------------------------

"Event.CheckPointIntro_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/YouHadBetterPray.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_DeadLight"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"NO_INTENSITY_TRACK"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForDeath.wav"
 	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

// --------------------------------------------------------------------
// when you first leave a checkpoint
"Event.LeavingSafety_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4"   //"0.3, 0.35"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/DeadLightGermM1a.wav"
 		"wave"	"#music/mob/DeadLightGermS1a.wav"
 		"wave"	"#music/mob/DeadLightGermL1a.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}

// --------------------------------------------------------------------
// starting atmosphere after leaving checkpoint
"Event.StartAtmosphere_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
	}
}

// --------------------------------------------------------------------
// zombat music
// --------------------------------------------------------------------

// --------------------------------------------------------------------
//  C6  DeadLight
// --------------------------------------------------------------------

"Event.Zombat2_Intro_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	// "rndwave"
	// {
		"wave"			"#music/zombat/slayer/lectric/Slayer_01a.wav"

	// }


	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Mall"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}

// --------------------------------------------------------------------
// Danger
// --------------------------------------------------------------------
"Event.Zombat3_Intro_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01a.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01b.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01c.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01d.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01e.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01f.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01g.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01h.wav"

	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_A_DeadLight"
		"MusicTrack"            "zombat3"
		"MusicTagDelay"         "1, 7"
			//	"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.Zombat3_A_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/internalorgans/organ_02_01a.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_02_01b.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_02_01c.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_02_01d.wav"
		// "wave"			"#music/zombat/danger/internalorgans/organ_03_01a.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_03_01b.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_03_01e.wav"
	}


	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_B_DeadLight"
		"MusicTrack"            "zombat3"
		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
		"MusicTagDelay"         "1, 7"
	}
}
"Event.Zombat3_B_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01a.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01b.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01c.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01d.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01e.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01f.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01g.wav"
		"wave"			"#music/zombat/danger/internalorgans/organ_01_01h.wav"

	}

	GameData
	{
		"MusicAutoQueue"        "Event.Zombat3_A_DeadLight"
		"MusicTrack"            "zombat3"
		"MusicTagTrack"         "zombat"
		"MusicTagDelay"         "1, 7"
		"MusicPriority"			"CRITICAL"
	}
}


///////////////////////////////// Zombies!! //////////////////////////
// L4D2
// BigEasy
// S
"Event.MobSignal1_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.3, 0.35"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/DeadLightGermS1a.wav"
 		"wave"	"#music/mob/DeadLightGermS1b.wav"
 		"wave"	"#music/mob/DeadLightGermS1c.wav"
 		"wave"	"#music/mob/DeadLightGermM1a.wav"
 		"wave"	"#music/mob/DeadLightGermM1b.wav"
 		"wave"	"#music/mob/DeadLightGermM1c.wav"
 		"wave"	"#music/mob/DeadLightGermL1a.wav"
 		"wave"	"#music/mob/DeadLightGermL1b.wav"
 		"wave"	"#music/mob/DeadLightGermL1c.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}
"Event.MobSignal2_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.3, 0.35"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/DeadLightGermS2a.wav"
 		"wave"	"#music/mob/DeadLightGermS2b.wav"
 		"wave"	"#music/mob/DeadLightGermS2c.wav"
 		"wave"	"#music/mob/DeadLightGermM2a.wav"
 		"wave"	"#music/mob/DeadLightGermM2b.wav"
 		"wave"	"#music/mob/DeadLightGermM2c.wav"
 		"wave"	"#music/mob/DeadLightGermL2a.wav"
 		"wave"	"#music/mob/DeadLightGermL2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

///////////////////////////////// Atmosphere!! //////////////////////////

"Event.SafeAtmosphere_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}


// danger

"Event.DangerAtmosphere_DeadLight"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/c6rabies_01.wav"
		"wave" "#music/contagion/c6rabies_02.wav"
		"wave" "#music/contagion/c6rabies_03.wav"
		"wave" "#music/contagion/c6rabies_04.wav"
		"wave" "#music/contagion/c6rabies_05.wav"
		"wave" "#music/contagion/c6rabies_06.wav"
		"wave" "#music/contagion/c6rabies_07.wav"
		"wave" "#music/contagion/c6rabies_08.wav"
		"wave" "#music/contagion/c6rabies_09.wav"
		"wave" "#music/contagion/c6rabies_10.wav"

		"wave" "#music/contagion/l4d2_rabies_01.wav"
		"wave" "#music/contagion/l4d2_rabies_02.wav"
		"wave" "#music/contagion/l4d2_rabies_03.wav"
		"wave" "#music/contagion/l4d2_rabies_04.wav"
		"wave" "#music/contagion/l4d2_rabies_05.wav"
		"wave" "#music/contagion/l4d2_rabies_06.wav"
		"wave" "#music/contagion/l4d2_rabies_07.wav"
		"wave" "#music/contagion/l4d2_rabies_08.wav"
		"wave" "#music/contagion/l4d2_rabies_09.wav"
		"wave" "#music/contagion/l4d2_rabies_10.wav"
		"wave" "#music/contagion/l4d2_rabies_11.wav"
		"wave" "#music/contagion/l4d2_rabies_12.wav"
		"wave" "#music/contagion/l4d2_rabies_13.wav"
		"wave" "#music/contagion/l4d2_rabies_14.wav"
		"wave" "#music/contagion/l4d2_rabies_15.wav"
		"wave" "#music/contagion/l4d2_rabies_16.wav"
		"wave" "#music/contagion/l4d2_rabies_17.wav"
		"wave" "#music/contagion/l4d2_rabies_18.wav"
		"wave" "#music/contagion/l4d2_rabies_19.wav"
		"wave" "#music/contagion/l4d2_rabies_20.wav"
		"wave" "#music/contagion/l4d2_rabies_21.wav"
		"wave" "#music/contagion/l4d2_rabies_22.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

//////////////////////////////////////////////////////////////////////
// the passing
/////////////////////////////////////////////////////////////////////
// --------------------------------------------------------------------
// checkpoints
// --------------------------------------------------------------------

"Event.CheckPointIntro_ThePassing"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/YouHadBetterPray.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_ThePassing"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"NO_INTENSITY_TRACK"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_ThePassing"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/PrayForPassing.wav"
 	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

// --------------------------------------------------------------------
// when you first leave a checkpoint
"Event.LeavingSafety_ThePassing"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4" //"0.3, 0.35"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermM1a.wav"
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermL1a.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}

// --------------------------------------------------------------------
// starting atmosphere after leaving checkpoint
"Event.StartAtmosphere_ThePassing"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/L4D1_Quarantine_01.wav"
		"wave" "#music/contagion/L4D1_Quarantine_02.wav"
		"wave" "#music/contagion/L4D1_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
	}
}

// --------------------------------------------------------------------
// zombat music
// --------------------------------------------------------------------

// --------------------------------------------------------------------
//  C6  ThePassing
// --------------------------------------------------------------------

"Event.Zombat2_Intro_ThePassing"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"   "#music/zombat/slayer/HordeSlayer_01.wav"
		"wave"   "#music/zombat/slayer/HordeSlayer_02.wav"
		"wave"   "#music/zombat/slayer/HordeSlayer_03.wav"
		"wave"   "#music/zombat/slayer/HordeSlayer_04.wav"
		"wave"   "#music/zombat/slayer/lectric/Slayer_01a.wav"
	}


	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Mall"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}

// --------------------------------------------------------------------
// Danger
// --------------------------------------------------------------------
"Event.Zombat3_Intro_ThePassing"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.77"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01a.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01b.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01c.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01d.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01e.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01f.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01g.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01h.wav"

		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
		"wave"			"#music/zombat/danger/HordeDanger_02.wav"
		"wave"			"#music/zombat/danger/HordeDanger_03.wav"
		"wave"			"#music/zombat/danger/HordeDanger_04.wav"
	}
	
	GameData
	{
//		"MusicAutoQueue"        "Event.Zombat3_A_ThePassing"
		"MusicTrack"            "zombat3"
//		"MusicTagDelay"         "1, 7"
//		"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

//"Event.Zombat3_A_ThePassing"
//{
//	"channel"		"CHAN_STATIC"
//	"volume"		"0.77"
//	"soundlevel"	"SNDLVL_NONE"

//	"rndwave"
//	{
//		"wave"			"#music/zombat/danger/internalorgans/organ_02_01a.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_02_01b.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_02_01c.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_02_01d.wav"
		//"wave"			"#music/zombat/danger/internalorgans/organ_03_01a.wav" (not present in final game)
//		"wave"			"#music/zombat/danger/internalorgans/organ_03_01b.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_03_01e.wav"
//	}


//	GameData
//	{
//		"MusicAutoQueue"        "Event.Zombat3_B_ThePassing"
//		"MusicTrack"            "zombat3"
//		"MusicTagTrack"         "zombat"
//		"MusicPriority"			"CRITICAL"
//		"MusicTagDelay"         "1, 7"
//	}
//}

//"Event.Zombat3_B_ThePassing"
//{
//	"channel"		"CHAN_STATIC"
//	"volume"		"0.77"
//	"soundlevel"	"SNDLVL_NONE"

//	"rndwave"
//	{
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01a.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01b.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01c.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01d.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01e.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01f.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01g.wav"
//		"wave"			"#music/zombat/danger/internalorgans/organ_01_01h.wav"

//	}

//	GameData
//	{
//		"MusicAutoQueue"        "Event.Zombat3_A_ThePassing"
//		"MusicTrack"            "zombat3"
//		"MusicTagTrack"         "zombat"
//		"MusicTagDelay"         "1, 7"
//		"MusicPriority"			"CRITICAL"
//	}
//}


///////////////////////////////// Zombies!! //////////////////////////
// L4D2
// BigEasy
// S
"Event.MobSignal1_ThePassing"
{
	"channel"		"CHAN_STATIC"
//	"volume"		"0.3, 0.35"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL1a.wav"
 		"wave"	"#music/mob/GermL1b.wav"
 		"wave"	"#music/mob/GermM1a.wav"
 		"wave"	"#music/mob/GermM1b.wav"
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
 		"wave"	"#music/mob/GermX1a.wav"
 		"wave"	"#music/mob/GermX1b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}
"Event.MobSignal2_ThePassing"
{
	"channel"		"CHAN_STATIC"
//	"volume"		"0.3, 0.35"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL2a.wav"
 		"wave"	"#music/mob/GermL2b.wav"
 		"wave"	"#music/mob/GermM2a.wav"
 		"wave"	"#music/mob/GermM2b.wav"
 		"wave"	"#music/mob/GermS2a.wav"
 		"wave"	"#music/mob/GermS2b.wav"
 		"wave"	"#music/mob/GermX2a.wav"
 		"wave"	"#music/mob/GermX2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

///////////////////////////////// Atmosphere!! //////////////////////////

"Event.SafeAtmosphere_ThePassing"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/L4D1_Quarantine_01.wav"
		"wave" "#music/contagion/L4D1_Quarantine_02.wav"
		"wave" "#music/contagion/L4D1_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}


// danger

"Event.DangerAtmosphere_ThePassing"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/c6rabies_01.wav"
		"wave" "#music/contagion/c6rabies_02.wav"
		"wave" "#music/contagion/c6rabies_03.wav"
		"wave" "#music/contagion/c6rabies_04.wav"
		"wave" "#music/contagion/c6rabies_05.wav"
		"wave" "#music/contagion/c6rabies_06.wav"
		"wave" "#music/contagion/c6rabies_07.wav"
		"wave" "#music/contagion/c6rabies_08.wav"
		"wave" "#music/contagion/c6rabies_09.wav"
		"wave" "#music/contagion/c6rabies_10.wav"

		"wave" "#music/contagion/l4d2_rabies_01.wav"
		"wave" "#music/contagion/l4d2_rabies_02.wav"
		"wave" "#music/contagion/l4d2_rabies_03.wav"
		"wave" "#music/contagion/l4d2_rabies_04.wav"
		"wave" "#music/contagion/l4d2_rabies_05.wav"
		"wave" "#music/contagion/l4d2_rabies_06.wav"
		"wave" "#music/contagion/l4d2_rabies_07.wav"
		"wave" "#music/contagion/l4d2_rabies_08.wav"
		"wave" "#music/contagion/l4d2_rabies_09.wav"
		"wave" "#music/contagion/l4d2_rabies_10.wav"
		"wave" "#music/contagion/l4d2_rabies_11.wav"
		"wave" "#music/contagion/l4d2_rabies_12.wav"
		"wave" "#music/contagion/l4d2_rabies_13.wav"
		"wave" "#music/contagion/l4d2_rabies_14.wav"
		"wave" "#music/contagion/l4d2_rabies_15.wav"
		"wave" "#music/contagion/l4d2_rabies_16.wav"
		"wave" "#music/contagion/l4d2_rabies_17.wav"
		"wave" "#music/contagion/l4d2_rabies_18.wav"
		"wave" "#music/contagion/l4d2_rabies_19.wav"
		"wave" "#music/contagion/l4d2_rabies_20.wav"
		"wave" "#music/contagion/l4d2_rabies_21.wav"
		"wave" "#music/contagion/l4d2_rabies_22.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

///////////////////////////

// Hits
"Event.LoneSurvivor"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_100dB"

	"wave"			"music/terror/walkingdead.wav"

	GameData
	{
		"MusicTrack"            "lonesurvivor"
		"MusicPriority"			"CRITICAL"
	}
}

"c6m1.SaveMeSomeSugar"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_95dB"
	"pitch"			"100"

	// "wave"	"*)music/flu/concert/save_me_some_sugar.mp3"
	"wave"	"*)music/flu/jukebox/save_me_some_sugar_mono.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "wedding"
    }
}

"Jukebox.SaveMeSomeSugar"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1"
	"soundlevel"	"SNDLVL_80dB"
	"pitch"			"100"

	"wave"	"*music/flu/jukebox/save_me_some_sugar_mono.wav"

	GameData
	{
		"MusicBlockTrackList"    "zombat_tp, zombat, zombat2, zombat3, zombatIntro, ambient"
		"MusicTrack"            "jukebox"
	}
}


"Event.WitchRageBride"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"		"SNDLVL_NONE"
 	"wave"			"music/witch/WitchEncroacher_bride.wav"
	
	GameData
	{
		"MusicTrack"            "witch"
		"MusicPriority"			"CRITICAL"
	}
}


//////////////////////////////////////////
///////////////////////////////////////////
// --------------------------------------------------------------------
// combat music
// --------------------------------------------------------------------
// swapped for new, check A/D V.S. B/C
"Event.Zombat_ThePassing"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/Horde_01.wav"
		"wave"			"#music/zombat/Horde_02.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_1_ThePassing"
		"MusicTrack"            "zombat_tp"
		"MusicPriority"			"CRITICAL"
//		"MusicBlockTrackList"   "zombat"
		// "MusicMasterDivTags" "8"
		// "MusicTagDelay"         "7"
	}
}
"Event.Zombat_A_1_ThePassing"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/Horde_01.wav"
		"wave"			"#music/zombat/Horde_02.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_B_1_ThePassing"
		"MusicTrack"            "zombat_tp"
		"MusicTagTrack"         "zombat_tp"
		"MusicPriority"			"CRITICAL"
//		"MusicBlockTrackList"   "zombat"
		"MusicMasterDivTags"    "1.0"
		// "MusicTagDelay"         "7"

	}
}
"Event.Zombat_B_1_ThePassing"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/Horde_01.wav"
		"wave"			"#music/zombat/Horde_02.wav"
	}
	GameData
	{
		"MusicAutoQueue"        "Event.Zombat_A_1_ThePassing"
		"MusicTrack"            "zombat_tp"
		"MusicTagTrack"         "zombat_tp"
		"MusicPriority"			"CRITICAL"
		"MusicMasterDivTags" "1.0"
//		"MusicBlockTrackList"   "zombat"
		// "MusicTagDelay"         "7"
	}
}

//----------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------
// Cold Stream
//
"Event.MissionStart_coldstream"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/stmusic/ColdStream.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_coldstream"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"	
		"MusicMasterTags"
		{
			// "loopStart" "75.146"
			"loopStart" "75"

		}
	}
}
"Event.MissionStart_BaseLoop_coldstream"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/cpmusic/deepintheforest1.wav"

	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

// --------------------------------------------------------------------
// checkpoints
// --------------------------------------------------------------------

"Event.CheckPointIntro_coldstream"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/YouHadBetterPray.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_coldstream"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"NO_INTENSITY_TRACK"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_coldstream"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/cpmusic/deepintheforest2.wav"

	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

// --------------------------------------------------------------------
// when you first leave a checkpoint
"Event.LeavingSafety_coldstream"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}

// --------------------------------------------------------------------
// starting atmosphere after leaving checkpoint
"Event.StartAtmosphere_coldstream"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
//		"wave" "#music/contagion/NM_Quarantine_01.wav"
//		"wave" "#music/contagion/NM_Quarantine_02.wav"
//		"wave" "#music/contagion/NM_Quarantine_03.wav"
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
	}
}

// --------------------------------------------------------------------
// zombat music
// --------------------------------------------------------------------

// --------------------------------------------------------------------
//  C13  ColdStream
// --------------------------------------------------------------------

"Event.Zombat2_Intro_coldstream"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/slayer/HordeSlayer_01.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_02.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_03.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_04.wav"
	}
	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Mall"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}

// --------------------------------------------------------------------
//  C11  Airport
// --------------------------------------------------------------------

"Event.Zombat2_Intro_Airport"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/slayer/HordeSlayer_01.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_02.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_03.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_04.wav"
	}
	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Mall"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}

// --------------------------------------------------------------------
//  C12  Farm
// --------------------------------------------------------------------

"Event.Zombat2_Intro_Farm"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/slayer/HordeSlayer_01.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_02.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_03.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_04.wav"
	}
	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Mall"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}

// --------------------------------------------------------------------
//  C10  SmallTown
// --------------------------------------------------------------------

"Event.Zombat2_Intro_SmallTown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/slayer/HordeSlayer_01.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_02.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_03.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_04.wav"
	}
	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Mall"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}

// --------------------------------------------------------------------
//  C9 Garage
// --------------------------------------------------------------------

"Event.Zombat2_Intro_Garage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/slayer/HordeSlayer_01.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_02.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_03.wav"
		"wave"			"#music/zombat/slayer/HordeSlayer_04.wav"
	}
	GameData
	{
		// "MusicAutoQueue"        "Event.Zombat_A2B_Mall"
		"MusicTrack"            "zombat2c"
		"MusicPriority"			"CRITICAL"
		"MusicTagTrack"         "zombat"
		"MusicTagIndex"         "0"
		// "MusicMasterDivTags"    "8.0"
	}
}

// --------------------------------------------------------------------
// Danger
// --------------------------------------------------------------------
"Event.Zombat3_Intro_coldstream"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
		"wave"			"#music/zombat/danger/HordeDanger_02.wav"
		"wave"			"#music/zombat/danger/HordeDanger_03.wav"
		"wave"			"#music/zombat/danger/HordeDanger_04.wav"
	}

	GameData
	{
// 		"MusicAutoQueue"        "Event.Zombat3_A_coldstream"
		"MusicTrack"            "zombat3"
// 		"MusicTagDelay"         "1, 7"
// 			//	"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.Zombat3_Intro_Airport"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
		"wave"			"#music/zombat/danger/HordeDanger_02.wav"
		"wave"			"#music/zombat/danger/HordeDanger_03.wav"
		"wave"			"#music/zombat/danger/HordeDanger_04.wav"
	}

	GameData
	{
// 		"MusicAutoQueue"        "Event.Zombat3_A_coldstream"
		"MusicTrack"            "zombat3"
// 		"MusicTagDelay"         "1, 7"
// 			//	"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.Zombat3_Intro_Farm"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
		"wave"			"#music/zombat/danger/HordeDanger_02.wav"
		"wave"			"#music/zombat/danger/HordeDanger_03.wav"
		"wave"			"#music/zombat/danger/HordeDanger_04.wav"
	}

	GameData
	{
// 		"MusicAutoQueue"        "Event.Zombat3_A_coldstream"
		"MusicTrack"            "zombat3"
// 		"MusicTagDelay"         "1, 7"
// 			//	"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.Zombat3_Intro_SmallTown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
		"wave"			"#music/zombat/danger/HordeDanger_02.wav"
		"wave"			"#music/zombat/danger/HordeDanger_03.wav"
		"wave"			"#music/zombat/danger/HordeDanger_04.wav"
	}

	GameData
	{
// 		"MusicAutoQueue"        "Event.Zombat3_A_coldstream"
		"MusicTrack"            "zombat3"
// 		"MusicTagDelay"         "1, 7"
// 			//	"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

"Event.Zombat3_Intro_Garage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/zombat/danger/HordeDanger_01.wav"
		"wave"			"#music/zombat/danger/HordeDanger_02.wav"
		"wave"			"#music/zombat/danger/HordeDanger_03.wav"
		"wave"			"#music/zombat/danger/HordeDanger_04.wav"
	}

	GameData
	{
// 		"MusicAutoQueue"        "Event.Zombat3_A_coldstream"
		"MusicTrack"            "zombat3"
// 		"MusicTagDelay"         "1, 7"
// 			//	"MusicTagTrack"         "zombat"
		"MusicPriority"			"CRITICAL"
	}
}

///////////////////////////////// Zombies!! //////////////////////////
// L4D2
// BigEasy
// S
"Event.MobSignal1_coldstream"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL1a.wav"
 		"wave"	"#music/mob/GermL1b.wav"
 		"wave"	"#music/mob/GermM1a.wav"
 		"wave"	"#music/mob/GermM1b.wav"
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
 		"wave"	"#music/mob/GermX1a.wav"
 		"wave"	"#music/mob/GermX1b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}
"Event.MobSignal2_coldstream"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL2a.wav"
 		"wave"	"#music/mob/GermL2b.wav"
 		"wave"	"#music/mob/GermM2a.wav"
 		"wave"	"#music/mob/GermM2b.wav"
 		"wave"	"#music/mob/GermS2a.wav"
 		"wave"	"#music/mob/GermS2b.wav"
 		"wave"	"#music/mob/GermX2a.wav"
 		"wave"	"#music/mob/GermX2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

"Event.MobSignal1_Garage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL1a.wav"
 		"wave"	"#music/mob/GermL1b.wav"
 		"wave"	"#music/mob/GermM1a.wav"
 		"wave"	"#music/mob/GermM1b.wav"
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
 		"wave"	"#music/mob/GermX1a.wav"
 		"wave"	"#music/mob/GermX1b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

"Event.MobSignal2_Garage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL2a.wav"
 		"wave"	"#music/mob/GermL2b.wav"
 		"wave"	"#music/mob/GermM2a.wav"
 		"wave"	"#music/mob/GermM2b.wav"
 		"wave"	"#music/mob/GermS2a.wav"
 		"wave"	"#music/mob/GermS2b.wav"
 		"wave"	"#music/mob/GermX2a.wav"
 		"wave"	"#music/mob/GermX2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

// --------------------------------------------------------------------
// See: game_sounds_music_waterfront.txt
// --------------------------------------------------------------------
//"Event.MobSignal1_Waterfront"
//{
//	"channel"		"CHAN_STATIC"
//	"volume"		"0.55, 0.7"
//	"soundlevel"		"SNDLVL_NONE"
//	"rndwave"
//	{
// 		"wave"	"#music/mob/GermL1a.wav"
// 		"wave"	"#music/mob/GermL1b.wav"
// 		"wave"	"#music/mob/GermM1a.wav"
// 		"wave"	"#music/mob/GermM1b.wav"
// 		"wave"	"#music/mob/GermS1a.wav"
// 		"wave"	"#music/mob/GermS1b.wav"
// 		"wave"	"#music/mob/GermX1a.wav"
// 		"wave"	"#music/mob/GermX1b.wav"
//	}

//	GameData
//	{
//		"MusicPriority"		"LOW"
//		"MusicTrack"            "mobsignal"	
//	}
//}
//"Event.MobSignal2_Waterfront"
//{
//	"channel"		"CHAN_STATIC"
//	"volume"		"0.55, 0.7"
//	"soundlevel"		"SNDLVL_NONE"
//	"rndwave"
//	{
// 		"wave"	"#music/mob/GermL2a.wav"
// 		"wave"	"#music/mob/GermL2b.wav"
// 		"wave"	"#music/mob/GermM2a.wav"
// 		"wave"	"#music/mob/GermM2b.wav"
// 		"wave"	"#music/mob/GermS2a.wav"
// 		"wave"	"#music/mob/GermS2b.wav"
//		"wave"	"#music/mob/GermX2a.wav"
// 		"wave"	"#music/mob/GermX2b.wav"
//	}

//	GameData
//	{
//		"MusicPriority"		"LOW"
//		"MusicTrack"            "mobsignal"	
//	}
//}

"Event.MobSignal1_Airport"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL1a.wav"
 		"wave"	"#music/mob/GermL1b.wav"
 		"wave"	"#music/mob/GermM1a.wav"
 		"wave"	"#music/mob/GermM1b.wav"
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
 		"wave"	"#music/mob/GermX1a.wav"
 		"wave"	"#music/mob/GermX1b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

"Event.MobSignal2_Airport"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL2a.wav"
 		"wave"	"#music/mob/GermL2b.wav"
 		"wave"	"#music/mob/GermM2a.wav"
 		"wave"	"#music/mob/GermM2b.wav"
 		"wave"	"#music/mob/GermS2a.wav"
 		"wave"	"#music/mob/GermS2b.wav"
 		"wave"	"#music/mob/GermX2a.wav"
 		"wave"	"#music/mob/GermX2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

"Event.MobSignal1_Farm"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL1a.wav"
 		"wave"	"#music/mob/GermL1b.wav"
 		"wave"	"#music/mob/GermM1a.wav"
 		"wave"	"#music/mob/GermM1b.wav"
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
 		"wave"	"#music/mob/GermX1a.wav"
 		"wave"	"#music/mob/GermX1b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

"Event.MobSignal2_Farm"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL2a.wav"
 		"wave"	"#music/mob/GermL2b.wav"
 		"wave"	"#music/mob/GermM2a.wav"
 		"wave"	"#music/mob/GermM2b.wav"
 		"wave"	"#music/mob/GermS2a.wav"
 		"wave"	"#music/mob/GermS2b.wav"
 		"wave"	"#music/mob/GermX2a.wav"
 		"wave"	"#music/mob/GermX2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

"Event.MobSignal1_Smalltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL1a.wav"
 		"wave"	"#music/mob/GermL1b.wav"
 		"wave"	"#music/mob/GermM1a.wav"
 		"wave"	"#music/mob/GermM1b.wav"
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
 		"wave"	"#music/mob/GermX1a.wav"
 		"wave"	"#music/mob/GermX1b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

"Event.MobSignal2_Smalltown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.55, 0.7"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermL2a.wav"
 		"wave"	"#music/mob/GermL2b.wav"
 		"wave"	"#music/mob/GermM2a.wav"
 		"wave"	"#music/mob/GermM2b.wav"
 		"wave"	"#music/mob/GermS2a.wav"
 		"wave"	"#music/mob/GermS2b.wav"
 		"wave"	"#music/mob/GermX2a.wav"
 		"wave"	"#music/mob/GermX2b.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "mobsignal"	
	}
}

///////////////////////////////// Atmosphere!! //////////////////////////

"Event.SafeAtmosphere_coldstream"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/Quarantine_01.wav"
		"wave" "#music/contagion/Quarantine_02.wav"
		"wave" "#music/contagion/Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}


// danger

"Event.DangerAtmosphere_coldstream"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{

		"wave" "#music/contagion/l4d2_rabies_01.wav"
		"wave" "#music/contagion/l4d2_rabies_02.wav"
		"wave" "#music/contagion/l4d2_rabies_03.wav"
		"wave" "#music/contagion/l4d2_rabies_04.wav"
		"wave" "#music/contagion/l4d2_rabies_05.wav"
		"wave" "#music/contagion/l4d2_rabies_06.wav"
		"wave" "#music/contagion/l4d2_rabies_07.wav"
		"wave" "#music/contagion/l4d2_rabies_08.wav"
		"wave" "#music/contagion/l4d2_rabies_09.wav"
		"wave" "#music/contagion/l4d2_rabies_10.wav"
		"wave" "#music/contagion/l4d2_rabies_11.wav"
		"wave" "#music/contagion/l4d2_rabies_12.wav"
		"wave" "#music/contagion/l4d2_rabies_13.wav"
		"wave" "#music/contagion/l4d2_rabies_14.wav"
		"wave" "#music/contagion/l4d2_rabies_15.wav"
		"wave" "#music/contagion/l4d2_rabies_16.wav"
		"wave" "#music/contagion/l4d2_rabies_17.wav"
		"wave" "#music/contagion/l4d2_rabies_18.wav"
		"wave" "#music/contagion/l4d2_rabies_19.wav"
		"wave" "#music/contagion/l4d2_rabies_20.wav"
		"wave" "#music/contagion/l4d2_rabies_21.wav"
		"wave" "#music/contagion/l4d2_rabies_22.wav"

		"wave" "#music/contagion/L4D_Rabies_01.wav"
		"wave" "#music/contagion/L4D_Rabies_02.wav"
		"wave" "#music/contagion/L4D_Rabies_03.wav"
		"wave" "#music/contagion/L4D_Rabies_04.wav"
		"wave" "#music/contagion/L4D_Rabies_05.wav"
		"wave" "#music/contagion/L4D_Rabies_06.wav"
		"wave" "#music/contagion/L4D_Rabies_07.wav"
		"wave" "#music/contagion/L4D_Rabies_08.wav"
		"wave" "#music/contagion/L4D_Rabies_09.wav"
		"wave" "#music/contagion/L4D_Rabies_10.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

"Event.MissionStart_Airport"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/stmusic/DeadAir.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_Airport"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"	
		"MusicMasterTags"
		{
			"loopStart" "78.554"
		}
	}
}
"Event.MissionStart_BaseLoop_Airport"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/DeadAirTime.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

"Event.MissionStart_Farm"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/stmusic/BloodHarvest.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_Farm"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"	
		"MusicMasterTags"
		{
			"loopStart" "78.021"
		}
	}
}
"Event.MissionStart_BaseLoop_Farm"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/BloodHarvestor.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

"Event.MissionStart_SmallTown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/stmusic/DeathToll.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_SmallTown"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "78.487"
		}
	}
}
"Event.MissionStart_BaseLoop_SmallTown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/DeathTollCollector.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

"Event.MissionStart_Garage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/stmusic/CrashCourse.wav"
	}
	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.MissionStart_BaseLoop_Garage"
		"MusicPriority"			"MEDIUM"
		"MusicParameters"		"AFTER_DEATH"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "78.167"
		}
	}
}
"Event.MissionStart_BaseLoop_Garage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/CrashCourseCP.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

"Event.CheckPointIntro_Airport"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/DeadAirIntro.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_Airport"
		"MusicPriority"			"MEDIUM"
		"MusicMaster"           "PLAY_TO_END"
		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_Airport"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/DeadAirTime.wav"
		"wave"			"#music/cpmusic/DeadAirTime2.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

"Event.CheckPointIntro_SmallTown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/DeathTollIntro.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_SmallTown"
		"MusicPriority"			"MEDIUM"
		"MusicMaster"           "PLAY_TO_END"

		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_SmallTown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/DeathTollCollector.wav"
		"wave"			"#music/cpmusic/DeathTollCollector2.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

"Event.CheckPointIntro_Garage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/DeathTollIntro.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_Garage"
		"MusicPriority"			"MEDIUM"
		"MusicMaster"           "PLAY_TO_END"

		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_Garage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.9"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/cpmusic/CrashCourseCP.wav"

	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

 

"Event.CheckPointIntro_Farm"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"wave"			"#music/stmusic/BloodHarvestIntro.wav"

	GameData
	{
		"MusicTrack"            "checkpoint"
		"MusicAutoQueue"        "Event.CheckPointBaseLoop_Farm"
		"MusicPriority"			"MEDIUM"
		"MusicMaster"           "PLAY_TO_END"

		"MusicMasterTags"
		{
			"loopStart" "1.95"
		}
	}
}

"Event.CheckPointBaseLoop_Farm"
{
	"channel"		"CHAN_STATIC"
	"volume"		"1.0"
	"soundlevel"	"SNDLVL_NONE"

	"rndwave"
	{
		"wave"			"#music/cpmusic/BloodHarvestor.wav"
		"wave"			"#music/cpmusic/BloodHarvestor2.wav"
	}
	GameData
	{
		"MusicPriority"			"MEDIUM"
		"MusicTrack"            "checkpoint"
		"MusicTagTrack"         "checkpoint"
		"MusicFadeOut"         	"5.0"
	}
}

"Event.LeavingSafety_Airport"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}
"Event.LeavingSafety_Farm"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}

"Event.LeavingSafety_SmallTown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}
"Event.LeavingSafety_Garage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.4, 0.4"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
 		"wave"	"#music/mob/GermS1a.wav"
 		"wave"	"#music/mob/GermS1b.wav"
	}

	GameData
	{
		"MusicDelayTime"        "2.0"
		"MusicPriority"			"LOW"
		"MusicTrack"            "overdub"	
	}
}

"Event.StartAtmosphere_Airport"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/DA_Quarantine_01.wav"
		"wave" "#music/contagion/DA_Quarantine_02.wav"
		"wave" "#music/contagion/DA_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
	}
}

"Event.StartAtmosphere_Farm"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/BH_Quarantine_01.wav"
		"wave" "#music/contagion/BH_Quarantine_02.wav"
		"wave" "#music/contagion/BH_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
	}
}

"Event.StartAtmosphere_SmallTown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/DT_Quarantine_01.wav"
		"wave" "#music/contagion/DT_Quarantine_02.wav"
		"wave" "#music/contagion/DT_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
	}
}
"Event.StartAtmosphere_Garage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/DT_Quarantine_01.wav"
		"wave" "#music/contagion/DT_Quarantine_02.wav"
		"wave" "#music/contagion/DT_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
	}
}

"Event.SafeAtmosphere_Airport"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/DA_Quarantine_01.wav"
		"wave" "#music/contagion/DA_Quarantine_02.wav"
		"wave" "#music/contagion/DA_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}
"Event.SafeAtmosphere_Farm"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/BH_Quarantine_01.wav"
		"wave" "#music/contagion/BH_Quarantine_02.wav"
		"wave" "#music/contagion/BH_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicParameters"		"INTENSITY_CELING"
		"MusicFadeOut"         	"1.0"

	}
}

"Event.SafeAtmosphere_SmallTown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/DT_Quarantine_01.wav"
		"wave" "#music/contagion/DT_Quarantine_02.wav"
		"wave" "#music/contagion/DT_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicFadeOut"         	"1.0"

	}
}

"Event.SafeAtmosphere_Garage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/DT_Quarantine_01.wav"
		"wave" "#music/contagion/DT_Quarantine_02.wav"
		"wave" "#music/contagion/DT_Quarantine_03.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "safeAmbient"	
		"MusicFadeOut"         	"1.0"

	}
}

"Event.DangerAtmosphere_Airport"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/DA_Rabies_01.wav"
		"wave" "#music/contagion/DA_Rabies_02.wav"
		"wave" "#music/contagion/DA_Rabies_03.wav"
		"wave" "#music/contagion/DA_Rabies_04.wav"
		"wave" "#music/contagion/DA_Rabies_05.wav"
		"wave" "#music/contagion/DA_Rabies_06.wav"
		"wave" "#music/contagion/DA_Rabies_07.wav"
		"wave" "#music/contagion/DA_Rabies_08.wav"
		"wave" "#music/contagion/DA_Rabies_09.wav"
		"wave" "#music/contagion/DA_Rabies_10.wav"

		"wave" "#music/contagion/L4D_Rabies_01.wav"
		"wave" "#music/contagion/L4D_Rabies_02.wav"
		"wave" "#music/contagion/L4D_Rabies_03.wav"
		"wave" "#music/contagion/L4D_Rabies_04.wav"
		"wave" "#music/contagion/L4D_Rabies_05.wav"
		"wave" "#music/contagion/L4D_Rabies_06.wav"
		"wave" "#music/contagion/L4D_Rabies_07.wav"
		"wave" "#music/contagion/L4D_Rabies_08.wav"
		"wave" "#music/contagion/L4D_Rabies_09.wav"
		"wave" "#music/contagion/L4D_Rabies_10.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

"Event.DangerAtmosphere_Farm"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/BH_Rabies_01.wav"
		"wave" "#music/contagion/BH_Rabies_02.wav"
		"wave" "#music/contagion/BH_Rabies_03.wav"
		"wave" "#music/contagion/BH_Rabies_04.wav"
		"wave" "#music/contagion/BH_Rabies_05.wav"
		"wave" "#music/contagion/BH_Rabies_06.wav"
		"wave" "#music/contagion/BH_Rabies_07.wav"
		"wave" "#music/contagion/BH_Rabies_08.wav"
		"wave" "#music/contagion/BH_Rabies_09.wav"
		"wave" "#music/contagion/BH_Rabies_10.wav"

		"wave" "#music/contagion/L4D_Rabies_01.wav"
		"wave" "#music/contagion/L4D_Rabies_02.wav"
		"wave" "#music/contagion/L4D_Rabies_03.wav"
		"wave" "#music/contagion/L4D_Rabies_04.wav"
		"wave" "#music/contagion/L4D_Rabies_05.wav"
		"wave" "#music/contagion/L4D_Rabies_06.wav"
		"wave" "#music/contagion/L4D_Rabies_07.wav"
		"wave" "#music/contagion/L4D_Rabies_08.wav"
		"wave" "#music/contagion/L4D_Rabies_09.wav"
		"wave" "#music/contagion/L4D_Rabies_10.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

"Event.DangerAtmosphere_SmallTown"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.6, 0.8"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/DT_Rabies_01.wav"
		"wave" "#music/contagion/DT_Rabies_02.wav"
		"wave" "#music/contagion/DT_Rabies_03.wav"
		"wave" "#music/contagion/DT_Rabies_04.wav"
		"wave" "#music/contagion/DT_Rabies_05.wav"
		"wave" "#music/contagion/DT_Rabies_06.wav"
		"wave" "#music/contagion/DT_Rabies_07.wav"
		"wave" "#music/contagion/DT_Rabies_08.wav"
		"wave" "#music/contagion/DT_Rabies_09.wav"
		"wave" "#music/contagion/DT_Rabies_10.wav"

		"wave" "#music/contagion/L4D_Rabies_01.wav"
		"wave" "#music/contagion/L4D_Rabies_02.wav"
		"wave" "#music/contagion/L4D_Rabies_03.wav"
		"wave" "#music/contagion/L4D_Rabies_04.wav"
		"wave" "#music/contagion/L4D_Rabies_05.wav"
		"wave" "#music/contagion/L4D_Rabies_06.wav"
		"wave" "#music/contagion/L4D_Rabies_07.wav"
		"wave" "#music/contagion/L4D_Rabies_08.wav"
		"wave" "#music/contagion/L4D_Rabies_09.wav"
		"wave" "#music/contagion/L4D_Rabies_10.wav"

	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

"Event.DangerAtmosphere_Garage"
{
	"channel"		"CHAN_STATIC"
	"volume"		"0.7, 0.9"
	"soundlevel"	"SNDLVL_NONE"
	"rndwave"
	{
		"wave" "#music/contagion/CC_Rabies_01.wav"
		"wave" "#music/contagion/CC_Rabies_02.wav"
		"wave" "#music/contagion/CC_Rabies_03.wav"
		"wave" "#music/contagion/CC_Rabies_04.wav"
		"wave" "#music/contagion/CC_Rabies_05.wav"
		"wave" "#music/contagion/CC_Rabies_06.wav"
		"wave" "#music/contagion/CC_Rabies_07.wav"
		"wave" "#music/contagion/CC_Rabies_08.wav"
		"wave" "#music/contagion/CC_Rabies_09.wav"
		"wave" "#music/contagion/CC_Rabies_10.wav"
		"wave" "#music/contagion/CC_Rabies_11.wav"
		"wave" "#music/contagion/CC_Rabies_12.wav"

		"wave" "#music/contagion/L4D_Rabies_01.wav"
		"wave" "#music/contagion/L4D_Rabies_02.wav"
		"wave" "#music/contagion/L4D_Rabies_03.wav"
		"wave" "#music/contagion/L4D_Rabies_04.wav"
		"wave" "#music/contagion/L4D_Rabies_05.wav"
		"wave" "#music/contagion/L4D_Rabies_06.wav"
		"wave" "#music/contagion/L4D_Rabies_07.wav"
		"wave" "#music/contagion/L4D_Rabies_08.wav"
		"wave" "#music/contagion/L4D_Rabies_09.wav"
		"wave" "#music/contagion/L4D_Rabies_10.wav"
	}

	GameData
	{
		"MusicPriority"			"LOW"
		"MusicTrack"            "ambient"	
		"MusicFadeOut"         	"1.0"

	}
}

