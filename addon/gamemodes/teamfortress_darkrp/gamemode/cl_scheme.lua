
local W = ScrW()
local H = ScrH()
local Scale = H/480
-- Fonts

surface.CreateFont("HudClassHealth", {font = "TF2", size = 16*Scale})
surface.CreateFont("HudClassHealthMax", {font = "DefaultSmall", size = 10*Scale})
surface.CreateFont("HudFontMedium", {font = "TF2", size = 24*Scale})
surface.CreateFont("HudFontMediumSmall", {font = "TF2", size = 18*Scale})
surface.CreateFont("HudFontBig", {font = "TF2", size = 36*Scale})

surface.CreateFont("HudFontSmallest", {font = "TF2 Secondary", size = 11*Scale})
surface.CreateFont("HudFontSmall", {font = "TF2 Secondary", size = 14*Scale})
surface.CreateFont("HudFontMediumSmallSecondary", {font = "TF2 Secondary", size = 18*Scale})

surface.CreateFont("HudFontSmallestBold", {font = "TF2 Build", size = 11*Scale})
surface.CreateFont("HudFontSmallBold", {font = "TF2 Build", size = 14*Scale})
surface.CreateFont("HudFontMediumBold", {font = "TF2 Build", size = 24*Scale})
surface.CreateFont("HudFontGiantBold", {font = "TF2 Build", size = 44*Scale})

surface.CreateFont("TFFontSmall", {font = "Verdana", size = 8*Scale, weight = 0, additive = true})
surface.CreateFont("TFFontMedium", {font = "Verdana", size = 9*Scale, weight = 400})
surface.CreateFont("SpectatorKeyHints", {font = "Verdana", size = 8*Scale})


surface.CreateFont("ChalkboardTitle", {font = "TF2 Professor", size = 28*Scale})
surface.CreateFont("ChalkboardTitleBig", {font = "TF2 Professor", size = 40*Scale})
surface.CreateFont("ChalkboardTitleMedium", {font = "TF2 Professor", size = 24*Scale})
surface.CreateFont("ChalkboardText", {font = "TF2 Professor", size = 14*Scale})

surface.CreateFont("ScoreboardSmallest", {font = "Verdana", size = 7*Scale, weight = 400})
surface.CreateFont("ScoreboardVerySmall", {font = "Verdana", size = 8*Scale, weight = 400})
surface.CreateFont("ScoreboardSmall", {font = "TF2 Secondary", size = 10*Scale, weight = 400})
surface.CreateFont("ScoreboardMediumSmall", {font = "TF2", size = 14*Scale})
surface.CreateFont("ScoreboardMedium", {font = "TF2 Secondary", size = 20*Scale})
surface.CreateFont("ScoreboardTeamName", {font = "TF2 Secondary", size = 20*Scale})
surface.CreateFont("ScoreboardTeamNameLarge", {font = "TF2 Secondary", size = 34*Scale})

if H<600 then
	surface.CreateFont("TFDefault", {font = "Verdana", size = 12, weight = 900, antialias = false})
	surface.CreateFont("TFDefaultVerySmall", {font = "Verdana", size = 12, weight = 0, antialias = false})
	surface.CreateFont("TFDefaultSmall", {font = "Verdana", size = 12, weight = 0, antialias = false})
	surface.CreateFont("TFHudSelectionText", {font = "TF2", size = 15, weight = 700})
	surface.CreateFont("ScoreboardTeamScore", {font = "TF2", size = 52, weight = 400})
elseif H<768 then
	surface.CreateFont("TFDefault", {font = "Verdana", size = 13, weight = 900, antialias = false})
	surface.CreateFont("TFDefaultVerySmall", {font = "Verdana", size = 12, weight = 0, antialias = false})
	surface.CreateFont("TFDefaultSmall", {font = "Verdana", size = 13, weight = 0, antialias = false})
	surface.CreateFont("TFHudSelectionText", {font = "TF2", size = 15, weight = 700})
	surface.CreateFont("ScoreboardTeamScore", {font = "TF2", size = 72, weight = 400})
elseif H<1024 then
	surface.CreateFont("TFDefault", {font = "Verdana", size = 14, weight = 900})
	surface.CreateFont("TFDefaultVerySmall", {font = "Verdana", size = 12, weight = 0, antialias = false})
	surface.CreateFont("TFDefaultSmall", {font = "Verdana", size = 14, weight = 0})
	surface.CreateFont("TFHudSelectionText", {font = "TF2", size = 18, weight = 900})
	surface.CreateFont("ScoreboardTeamScore", {font = "TF2", size = 100, weight = 400})
elseif H<1200 then
	surface.CreateFont("TFDefault", {font = "Verdana", size = 20, weight = 900})
	surface.CreateFont("TFDefaultVerySmall", {font = "Verdana", size = 14, weight = 0, antialias = false})
	surface.CreateFont("TFDefaultSmall", {font = "Verdana", size = 20, weight = 0})
	surface.CreateFont("TFHudSelectionText", {font = "TF2", size = 21, weight = 900})
	surface.CreateFont("ScoreboardTeamScore", {font = "TF2", size = 140, weight = 400})
else
	surface.CreateFont("TFDefault", {font = "Verdana", size = 24, weight = 900})
	surface.CreateFont("TFDefaultVerySmall", {font = "Verdana", size = 16, weight = 0, antialias = false})
	surface.CreateFont("TFDefaultSmall", {font = "Verdana", size = 2, weight = 0})
	surface.CreateFont("TFHudSelectionText", {font = "TF2", size = 24, weight = 1000})
	surface.CreateFont("ScoreboardTeamScore", {font = "TF2", size = 180, weight = 400})
end

surface.CreateFont("ItemFontNameSmallest", {font = "TF2 Build", size = 8*Scale})
surface.CreateFont("ItemFontNameSmall", {font = "TF2 Build", size = 9*Scale})
surface.CreateFont("ItemFontNameLarge", {font = "TF2 Build", size = 12*Scale})

surface.CreateFont("ItemFontAttribSmallest", {font = "TF2 Secondary", size = 7*Scale})
surface.CreateFont("ItemFontAttribSmall", {font = "TF2 Secondary", size = 8*Scale})
surface.CreateFont("ItemFontAttribLarge", {font = "TF2 Secondary", size = 11*Scale})

surface.CreateFont("ClockSubText", {font = "Verdana", size = 9*Scale})
surface.CreateFont("ClockSubTextSuddenDeath", {font = "Verdana", size = 8*Scale})
surface.CreateFont("ClockSubTextTiny", {font = "Verdana", size = 8*Scale})

-- Colors

Colors = {
	Orange=Color(178,82,22,255),
	OrangeDim=Color(178,82,22,120),
	LightOrange=Color(188,112,0,128),
	GoalOrange=Color(255,133,0),
	TFOrange=Color(145,73,59,255),
		
	White=Color(235,235,235,255),
	Red=Color(192,28,0,140),
	RedSolid=Color(192,28,0,255),
	Blue=Color(0,28,162,140),
	Yellow=Color(251,235,202,255),
	TransparentYellow=Color(251,235,202,140),
	
	Black=Color(46,43,42,255),
	TransparentBlack=Color(0,0,0,196),
	TransparentLightBlack=Color(0,0,0,90),
	FooterBGBlack=Color(52,48,55,255),
		
	HUDBlueTeam=Color(104,124,155,127),
	HUDRedTeam=Color(180,92,77,127),
	HUDSpectator=Color(124,124,124,127),
	HUDBlueTeamSolid=Color(104,124,155,255),
	HUDRedTeamSolid=Color(180,92,77,255),
	HUDDeathWarning=Color(255,0,0,255),
	HudWhite=Color(255,255,255,255),
	HudOffWhite=Color(200,187,161,255),
		
	Gray=Color(178,178,178,255),

	Blank=Color(0,0,0,0),
	ForTesting=Color(255,0,0,32),
	ForTesting_Magenta=Color(255,0,255,255),
	ForTesting_MagentaDim=Color(255,0,255,120),

	HudPanelForeground=Color(123,110,59,184),
	HudPanelBackground=Color(123,110,59,184),
	HudPanelBorder=Color(255,255,255,102),

	HudProgressBarActive=Color(240,207,78,255),
	HudProgressBarInActive=Color(140,120,73,255),
	HudProgressBarActiveLow=Color(240,30,30,255),
	HudProgressBarInActiveLow=Color(240,30,30,99),	

	HudTimerProgressActive=Color(251,235,202,255),
	HudTimerProgressInActive=Color(52,48,45,255),
	HudTimerProgressWarning=Color(240,30,30,255),
		
	TanDark=Color(117,107,94,255),
	TanLight=Color(235,226,202,255),
	TanDarker=Color(46,43,42,255),
		
		//,Building,HUD,Specific
	LowHealthRed=Color(255,0,0,255),
	ProgressOffWhite=Color(251,235,202,255),
	ProgressBackground=Color(250,234,201,51),
	HealthBgGrey=Color(72,71,69,255),
		
	ProgressOffWhiteTransparent=Color(251,235,202,128),
		
	LabelDark=Color(48,43,42,255),
	LabelTransparent=Color(109,96,80,180),
		
	BuildMenuActive=Color(248,231,198,255),
		
	DisguiseMenuIconRed=Color(192,56,63,255),
	DisguiseMenuIconBlue=Color(92,128,166,255),

	MatchmakingDialogTitleColor=Color(200,184,151,255),
	MatchmakingMenuItemBackground=Color(46,43,42,255),
	MatchmakingMenuItemBackgroundActive=Color(150,71,0,255),	
	MatchmakingMenuItemTitleColor=Color(200,184,151,255),
	MatchmakingMenuItemDescriptionColor=Color(200,184,151,255),
		
	HTMLBackground=Color(95,92,101,255),
		
	ItemAttribLevel=Color(117,107,94,255),
	ItemAttribNeutral=Color(235,226,202,255),
	ItemAttribPositive=Color(153,204,255,255),
	ItemAttribNegative=Color(255,64,64,255),
	ItemAttribNeutralUnimplemented=Color(116,111,97,255),
	ItemAttribPositiveUnimplemented=Color(77,102,128,255),
	ItemAttribNegativeUnimplemented=Color(100,60,60,255),
	
	ItemSetName=Color(225,255,15,255),
	ItemSetItemEquipped=Color(149,175,12,255),
	ItemSetItemMissing=Color(139,137,137,255),
	ItemIsotope=Color(225,255,15,255),
	ItemBundleItem=Color(149,175,12,255),
	ItemLimitedUse=Color(0,160,0,255),
	ItemFlags=Color(117,107,94,255),
		
	QualityColorNormal=Color(178,178,178,255),
	QualityColorrarity1=Color(141,131,75,255),
	QualityColorrarity2=Color(77,116,85,255),
	QualityColorrarity3=Color(207,106,50,255),
	QualityColorrarity4=Color(134,80,172,255),
	QualityColorVintage=Color(71,98,145,255),
	QualityColorUnique=Color(255,215,0,255),
	QualityColorCommunity=Color(112,176,74,255),
	QualityColorDeveloper=Color(165,15,121,255),
	QualityColorSelfMade=Color(112,176,74,255),
	QualityColorCustomized=Color(71,98,145,255),
	QualityColorGey=Color(255,117,207,255),
	
	TeamSpec=Color(204,204,204,255),
	TeamRed=Color(255,64,64,255),
	TeamBlue=Color(153,204,255,255),
}