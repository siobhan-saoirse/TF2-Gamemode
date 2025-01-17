if SERVER then AddCSLuaFile() end
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true
ENT.PrintName		= "BLU Spawner"
ENT.Category		= "TFBots"
ENT.Team = TEAM_BLU

list.Set( "NPC", "tf_blue_team_spawner", {
	Name = ENT.PrintName,
	Class = "tf_blue_team_spawner",
	Category = ENT.Category,
	AdminOnly = true,
	AdminOnly = true
} )
local randomNames =
{
	"Chucklenuts",
	"CryBaby",
	"WITCH",
	"ThatGuy",
	"Still Alive",
	"Hat-Wearing MAN",
	"Me",
	"Numnutz",
	"H@XX0RZ",
	"The G-Man",
	"Chell",
	"The Combine",
	"Totally Not A Bot",
	"Pow!",
	"Zepheniah Mann",
	"THEM",
	"LOS LOS LOS",
	"10001011101",
	"DeadHead",
	"ZAWMBEEZ",
	"MindlessElectrons",
	"TAAAAANK!",
	"The Freeman",
	"Black Mesa",
	"Soulless",
	"CEDA",
	"BeepBeepBoop",
	"NotMe",
	"CreditToTeam",
	"BoomerBile",
	"Someone Else",
	"Mann Co.",
	"Dog",
	"Kaboom!",
	"AmNot",
	"0xDEADBEEF",
	"HI THERE",
	"SomeDude",
	"GLaDOS",
	"Hostage",
	"Headful of Eyeballs",
	"CrySomeMore",
	"Aperture Science Prototype XR7",
	"Humans Are Weak",
	"AimBot",
	"C++",
	"GutsAndGlory!",
	"Nobody",
	"Saxton Hale",
	"RageQuit",
	"Screamin' Eagles",

	"Ze Ubermensch",
	"Maggot",
	"CRITRAWKETS",
	"Herr Doktor",
	"Gentlemanne of Leisure",
	"Companion Cube",
	"Target Practice",
	"One-Man Cheeseburger Apocalypse",
	"Crowbar",
	"Delicious Cake",
	"IvanTheSpaceBiker",
	"I LIVE!",
	"Cannon Fodder",

	"trigger_hurt",
	"Nom Nom Nom",
	"Divide by Zero",
	"GENTLE MANNE of LEISURE",
	"MoreGun",
	"Tiny Baby Man",
	"Big Mean Muther Hubbard",
	"Force of Nature",

	"Crazed Gunman",
	"Grim Bloody Fable",
	"Poopy Joe",
	"A Professional With Standards",
	"Freakin' Unbelievable",
	"SMELLY UNFORTUNATE",
	"The Administrator",
	"Mentlegen",

	"Archimedes!",
	"Ribs Grow Back",
	"It's Filthy in There!",
	"Mega Baboon",
	"Kill Me",
	"Glorified Toaster with Legs",
	"John Spartan",
	"Leeloo Dallas Multipass",
	"Sho'nuff",
	"Bruce Leroy",
	"CAN YOUUUUUUUUU DIG IT?!?!?!?!",
	"Big Gulp, Huh?",
	"Stupid Hot Dog",
	"I'm your huckleberry",
	"The Crocketeer"
};
function ENT:Initialize()
	if CLIENT then return end	
	self:SetModel("models/editor/playerstart.mdl")
	self:SetMaterial("models/debug/debugwhite")
	self:SetColor(Color(team.GetColor(self.Team).r,team.GetColor(self.Team).g,team.GetColor(self.Team).b,100))
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self:SetRenderFX(kRenderFxHologram)
	self:SetSolid(SOLID_BBOX)
	self:SetModelScale(1.0)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self.bots = {}
	self.bot = {}
	self.spawnsblu = {}
	self.spawnsred = {}	
	self:SetSkin(self.Team - 1)
	self:SetUseType(SIMPLE_USE)
	if SERVER then
		self:EmitSound("MVM.Robot_Engineer_Spawn")
		for k, v in pairs(ents.FindByClass("info_player_teamspawn")) do
			if v:GetKeyValues()["StartDisabled"] == 0 then
				if v:GetKeyValues()["TeamNum"] == 3 then
					table.insert(self.spawnsblu, v)
				elseif v:GetKeyValues()["TeamNum"] == 2 then
					table.insert(self.spawnsred, v)
				end
			end
		end
	end
end

function ENT:OnInjured()
	return false
end

function ENT:OnKilled()
	return false
end

function ENT:IsNPC()
	return false
end

function ENT:IsNextBot()
	return true
end

function ENT:Health()
	return nil
end

function ENT:OnRemove()
	if SERVER then
		for k,v in ipairs(self.bots) do
			v:Remove()
		end
	end
	timer.Stop("BotSpawner"..self:EntIndex())
end
  
function ENT:Think()
	
	if SERVER then
		for k,v in ipairs(self.bots) do
			if (!IsValid(v)) then
				table.remove(self.bots,k)
			end
		end
	end
	self:NextThink(CurTime())
	return true	
end


function ENT:Use( activator, caller )
	if (!self.WaveStarted) then
		activator:PrintMessage(HUD_PRINTTALK,"Bots will now spawn every 5 seconds")
		timer.Create("BotSpawner"..self:EntIndex(), 4, 0, function()
			if SERVER then 
				local slef = self
				local spawn = self
				if (table.Count(team.GetPlayers(self.Team)) < 4) then
					local bots = {
						"tf_red_bot",
						"tf_red_bot_soldier",
						"tf_red_bot_pyro",
						"tf_red_bot_demo",
						"tf_red_bot_heavyweapons",
						"tf_red_bot_engineer",
						"tf_red_bot_medic",
						"tf_red_bot_sniper",
						"tf_red_bot_spy"
					}
						for i=1,1 do
							local bot = ents.Create(table.Random(bots))
								if (!IsValid(bot)) then
									return
								end
								bot:SetOwner(self)
								bot:Spawn() 
								bot:EmitSound("Building_Teleporter.Receive",70,100)
								bot.Bot.Difficulty = math.random(0,3)
								bot.Bot:Speak("TLK_ROUND_START")
								bot.Bot:SetNWString("customname",table.Random(randomNames))
								bot.Bot:SetTeam(self.Team)
								bot.Bot:Spawn()
								if (table.Count(self.spawnsblu) > 0 and self.Team == TEAM_BLU) then
								elseif (table.Count(self.spawnsred) > 0 and self.Team == TEAM_RED) then
								else
									bot.Bot:SetPos(spawn:GetPos() + Vector(0,0,45))
								end
								bot:SetPos(bot.Bot:GetPos())
								if (self.Team == TEAM_BLU) then
									ParticleEffect("teleportedin_blue", bot.Bot:GetPos(), bot:GetAngles(), self)
								else
									ParticleEffect("teleportedin_red", bot.Bot:GetPos(), bot:GetAngles(), self)
								end
								table.insert(self.bots,bot) 
								--print("Creating robot #"..bot:EntIndex())
							end
				else
					--print("We have reached the limits! Not spawning MVM bots...")
				end
			end
		end) 
		self.WaveStarted = true
		self:EmitSound("buttons/lever8.wav")
	else
		activator:PrintMessage(HUD_PRINTTALK,"Bot spawning is now off")
		timer.Stop("BotSpawner"..self:EntIndex())
		self.WaveStarted = false
		self:EmitSound("buttons/lever8.wav")
	end
end