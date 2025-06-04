
local BASESPEED = 3

GM.PlayerClasses = {}
GM.PlayerClassesAutoComplete = {}
GM.GibTypeTable = {}

function lookForNearestPlayer(bot)
	local npcs = {}
		for k,v in ipairs(ents.FindInSphere(bot:GetPos(), 8000000)) do
			if ((v:IsTFPlayer()) and v:Health() > 0 and !v:IsFriendly(bot) and v:GetNoDraw() == false and !v:IsNeutral() and v:EntIndex() != bot:EntIndex() and !v:IsFlagSet(FL_NOTARGET)) then
				table.insert(npcs, v)
			end
		end
		return table.Random(npcs)
end

local TFHull = {Vector(-24, -24, 0), Vector(24, 24, 82)}
local TFHullDuck = {Vector(-24, -24, 0), Vector(24, 24, 62)}

local DefaultHull = {Vector(-24, -24, 0), Vector(24,  24,  72)}
local DefaultHullDuck = {Vector(-24, -24, 0), Vector(24,  24,  36)}

local randomizer = CreateConVar( "tf_randomizer", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE} )
local randomizerit = CreateConVar( "tf_randomizer_class_specific", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE} )
local dgmod = CreateConVar( "tf_disable_fun_classes", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE} )
local botrobot = CreateConVar( "tf_bots_are_robots", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE} )

local function UpgradePlayerIfBot(self)
	if (self:IsBot() and self:Team() != TEAM_RED and string.find(game.GetMap(),"mvm_")) then return end
	if (!string.find(game.GetMap(),"mvm_")) then return end
	if (!self:IsBot()) then return end 
	if SERVER then

			if self:GetPlayerClass() == "scout" then
				self:SetHealth(125 + 60)
				self:SetMaxHealth(125 + 60)
				self:SetArmor(2000)
				timer.Create("Speed"..self:EntIndex(), 0.01, 0, function()
					if self:Alive() then
						--self:ResetClassSpeed()
						--self:SetClassSpeed(self:GetPlayerClassTable().Speed * 1.2)
					else
						timer.Stop("Speed"..self:EntIndex())
						return
					end
				end)
			elseif self:GetPlayerClass() == "soldier" then
				self:SetHealth(200 + 100)
				self:SetMaxHealth(200 + 100)
				self:SetArmor(2950)
				timer.Create("Speed"..self:EntIndex(), 0.01, 0, function()
					if self:Alive() then
						--self:ResetClassSpeed()
						--self:SetClassSpeed(self:GetPlayerClassTable().Speed * 1.2)
					else
						timer.Stop("Speed"..self:EntIndex())
						return
					end
				end)
			elseif self:GetPlayerClass() == "gmodplayer" then
				self:SetHealth(100 + 150)
				self:SetMaxHealth(100 + 150)
				self:SetArmor(2950)
				timer.Create("Speed"..self:EntIndex(), 0.01, 0, function()
					if self:Alive() then
						--self:ResetClassSpeed()
						--self:SetClassSpeed(self:GetPlayerClassTable().Speed * 1.2)
					else
						timer.Stop("Speed"..self:EntIndex())
						return
					end
				end)
			elseif self:GetPlayerClass() == "pyro" then
				self:SetHealth(175 + 85)
				self:SetMaxHealth(175 + 85)
				self:SetArmor(2220)
				timer.Create("Speed"..self:EntIndex(), 0.01, 0, function()
					if self:Alive() then
						--self:ResetClassSpeed()
						--self:SetClassSpeed(self:GetPlayerClassTable().Speed * 1.2)
					else
						timer.Stop("Speed"..self:EntIndex())
						return
					end
				end)
			elseif self:GetPlayerClass() == "demoman" then
				self:SetHealth(175 + 85)
				self:SetMaxHealth(175 + 85)
				self:SetArmor(2220)
				timer.Create("Speed"..self:EntIndex(), 0.01, 0, function()
					if self:Alive() then
						--self:ResetClassSpeed()
						--self:SetClassSpeed(self:GetPlayerClassTable().Speed * 1.2)
					else
						timer.Stop("Speed"..self:EntIndex())
						return
					end
				end)
			elseif self:GetPlayerClass() == "heavy" then
				self:SetHealth(300 + 150)
				self:SetMaxHealth(300 + 150)
				self:SetArmor(2320)
				timer.Create("Speed"..self:EntIndex(), 0.01, 0, function()
					if self:Alive() then
						--self:ResetClassSpeed()
						--self:SetClassSpeed(self:GetPlayerClassTable().Speed * 1.2)
					else
						timer.Stop("Speed"..self:EntIndex())
						return
					end
				end)
			elseif self:GetPlayerClass() == "engineer" then
				self:SetHealth(125 + 60)
				self:SetMaxHealth(125 + 60)
				self:SetArmor(2420)
				timer.Create("Speed"..self:EntIndex(), 0.01, 0, function()
					if self:Alive() then
						--self:ResetClassSpeed()
						--self:SetClassSpeed(self:GetPlayerClassTable().Speed * 1.2)
					else
						timer.Stop("Speed"..self:EntIndex())
						return
					end
				end)
			elseif self:GetPlayerClass() == "medic" then
				self:SetHealth(150 + 75)
				self:SetMaxHealth(150 + 75)
				self:SetArmor(2620)
				timer.Create("Speed"..self:EntIndex(), 0.01, 0, function()
					if self:Alive() then
						--self:ResetClassSpeed()
						--self:SetClassSpeed(self:GetPlayerClassTable().Speed * 1.2)
					else
						timer.Stop("Speed"..self:EntIndex())
						return
					end
				end)
			elseif self:GetPlayerClass() == "sniper" then
				self:SetHealth(125 + 60)
				self:SetMaxHealth(125 + 60)
				self:SetArmor(2420)
				timer.Create("Speed"..self:EntIndex(), 0.01, 0, function()
					if self:Alive() then
						--self:ResetClassSpeed()
						--self:SetClassSpeed(self:GetPlayerClassTable().Speed * 1.2)
					else
						timer.Stop("Speed"..self:EntIndex())
						return
					end
				end)
			elseif self:GetPlayerClass() == "spy" then
				self:SetHealth(125 + 60)
				self:SetMaxHealth(125 + 60)
				self:SetArmor(2920)
				timer.Create("Speed"..self:EntIndex(), 0.01, 0, function()
					if self:Alive() then
						--self:ResetClassSpeed()
						--self:SetClassSpeed(self:GetPlayerClassTable().Speed * 1.2)
					else
						timer.Stop("Speed"..self:EntIndex())
						return
					end
				end)
			end
			local ent = self
			for _,currentweapon in ipairs(ent:GetWeapons()) do
				if (IsValid(currentweapon)) then
					if (currentweapon.Primary and currentweapon.Secondary and currentweapon.ReloadTime) then
						if (!currentweapon.Primary.OldDelay and !currentweapon.Secondary.OldDelay and !currentweapon.OldReloadTime) then
							currentweapon.Primary.OldDelay          = currentweapon.Primary.Delay
							currentweapon.Secondary.OldDelay          = currentweapon.Secondary.Delay 
							currentweapon.Primary.FastDelay          = currentweapon.Primary.OldDelay * 0.6 
							currentweapon.Secondary.FastDelay          = currentweapon.Secondary.OldDelay * 0.6
							currentweapon.Primary.Delay          = currentweapon.Primary.FastDelay
							currentweapon.Secondary.Delay          = currentweapon.Secondary.FastDelay
							currentweapon.OldReloadTime          = currentweapon.ReloadTime
							currentweapon.FastReloadTime          = currentweapon.OldReloadTime * 0.4
						end
						if (currentweapon.BaseDamage) then
							if (!currentweapon.OldBaseDamage) then
								currentweapon.ProjectileDamageMultiplier = 2.0
								currentweapon.OldBaseDamage = currentweapon.BaseDamage
								currentweapon.BaseDamage = currentweapon.OldBaseDamage * 2.0
							end
						end
						if (currentweapon.ReloadStartTime) then
							if (!currentweapon.FastReloadStartTime) then
								currentweapon.FastReloadStartTime          = currentweapon.ReloadStartTime * 0.6
							end
						elseif (currentweapon.Primary.ClipSize) then
							if (!currentweapon.Primary.OldClipSize) then
								currentweapon.Primary.OldClipSize          = currentweapon.Primary.ClipSize
								currentweapon.Primary.ClipSize          = currentweapon.Primary.OldClipSize * 3.0
							end
							currentweapon:SetClip1(currentweapon.Primary.ClipSize)
						end
					end
				end
			end
			ent.AmmoMax[TF_PRIMARY] = math.Round(ent.AmmoMax[TF_PRIMARY] * 2.5)
			ent.AmmoMax[TF_SECONDARY] = math.Round(ent.AmmoMax[TF_SECONDARY] * 2.5)
			ent.AmmoMax[TF_GRENADES1] = math.Round(ent.AmmoMax[TF_GRENADES1] * 7.0)
			ent.AmmoMax[TF_METAL] = math.Round(ent.AmmoMax[TF_METAL] * 3.0)
			GAMEMODE:GiveAmmoPercent(ent,100)
			ent:EmitSound("MVM.PlayerUpgraded")

	end	
end

cvars.AddChangeCallback("tf_disable_fun_classes", function(_, _, val)
	if SERVER and val == "1" then
		for k, v in pairs(player.GetAll()) do
			if v:GetPlayerClass() == "gmodplayer" and !v:IsAdmin() then
				v:SetPlayerClass("scout")  
				v:Kill()
			end
		end
	end
end)

function GM:RegisterPlayerClass(name, tbl)
	for k,v in pairs(tbl.Gibs or {}) do  
		self.GibTypeTable[v] = k
	end
	
	local mdl = "models/player/"..(tbl.ModelName or "scout")..".mdl"
	util.PrecacheModel(mdl)
	--PrintTable(tbl)
	self.PlayerClasses[name] = tbl
	table.insert(self.PlayerClassesAutoComplete, "changeclass "..name)
end

function GM:LoadPlayerClasses()
	local path = string.Replace(GM.Folder, "gamemodes/", "").."/gamemode/playerclasses/"
	for _,f in pairs(file.Find(path.."*.lua", "LUA")) do
		CLASS = {}
		AddCSLuaFile(path..f)
		include(path..f)
		
		local classname = string.Replace(f, ".lua", "")
		self:RegisterPlayerClass(classname, CLASS)
		
		if SERVER then
			Msg("Registered class \""..classname.."\"\n")
		end
	end
end

GM:LoadPlayerClasses()

-- Player extension

local meta = FindMetaTable( "Player" )
if (!meta) then return end 

-- Serverside only
if SERVER then

local function InitPlayerBodygroups(pl)
	if IsValid(pl) then
		for _,v in pairs(pl:GetTFItems()) do
			if v.ApplyPlayerBodygroups then
				v:ApplyPlayerBodygroups()
			end
		end
	end
end

function meta:SetPlayerClass(class)
	self.anim_Deployed = false
	class = string.lower(class)

	if dgmod:GetBool() and (class == "gmodplayer" or class == "civilian") and !self:IsAdmin() then
		return
	end
	local pl = self

	local oldclass = self:GetPlayerClass()
	local t1 = GAMEMODE.PlayerClasses[oldclass]
	
	if t1 and t1.ChangeClass then t1.ChangeClass(self, class) end
	
	local c = GAMEMODE.PlayerClasses[class]
	if not c then
		-- idiot proof
		ErrorNoHalt("WARNING : Class \""..class.."\" not found\n")
		return
	end

	self.TempAttributes = {}
	self.NextSpeak = nil
	
	-- Update all the needed Networked info
	if class~=self:GetNWString("PlayerClass") then
		if c.DefaultLoadout then
			self.ItemLoadout = table.Copy(c.DefaultLoadout)
			self.ItemProperties = {}
		else
			self.ItemLoadout = nil
			self.ItemProperties = nil
		end
	end
	self:SetNWInt("Heads", 0)
	self:SetNWString("PlayerClass", class)
	self:SetNWBool("IsHL2", (c.IsHL2~=false and c.IsHL2~=nil)) -- Doing this so the result is an actual boolean (else it seems not to work properly)
	self:SetNWBool("IsL4D", (c.IsL4D~=false and c.IsL4D~=nil)) -- Doing this so the result is an actual boolean (else it seems not to work properly)
	
	-- Set speed and health
	if (class != "scout" and self:GetInfoNum("tf_giant_robot",0) == 1) then
		self:SetClassSpeed((c.Speed or 100) * 0.5)
	else
		self:SetClassSpeed(c.Speed or 100)
	end
	self:ResetMaxHealth()
	
	if c.IsHL2 then -- ...however, only gmodplayers use the default view offset, TF2 players keep their own view height even when playing a HL2 map

		self.PlayerJumpPower = 200
	else

		self.PlayerJumpPower = 200
	end
	self:SetJumpPower(self.PlayerJumpPower)
	self.NextCritBoostExpire = 0
	-- Hull and view offset
	if self:ShouldUseDefaultHull() then -- In HL2 maps, all players should have a normal collision hull so they can go through doors properly...
		-- Default hull
		self:ResetHull()
		self:SetStepSize(18)
		self:SetViewOffset(Vector(0,0,64)) 
		self:SetViewOffsetDucked(Vector(0, 0, 28))
		self:SetCollisionBounds(unpack(DefaultHull))
	else 
		-- Special hull, because TF2 players are larger than HL2 players
		self:SetHull(unpack(TFHull))
		self:SetHullDuck(unpack(TFHullDuck))
		self:SetCollisionBounds(unpack(TFHull))
		self:SetStepSize(18)
	end
	self:SetDuckSpeed(0.2)
	
	-- Remove all weapons
	self:StripTFItems()
	self:ClearItemSetAttributes()
	self:GiveItemSetAttributes()
	
	-- Give ammo, and weapons
	self.AmmoMax = table.Copy(c.AmmoMax or {}) 
	
	for k,v in pairs(c.AdditionalAmmo or {}) do
		self:GiveAmmo(v, k, true)
	end
	
	if self.ItemLoadout then
		for k,v in ipairs(self.ItemLoadout or {}) do
			self:GiveItem(v, self.ItemProperties[k])
		end
	else
		for k,v in ipairs(c.Loadout or {}) do
			self:Give(v) 
		end
	end
	
	self:ResetHealth() 
	
	if c.Buildings then
		self.Buildings = tf_objects.GetBuildables(c.Buildings)
		self:GiveItem("TF_WEAPON_BUILDER") 
	end
	 
	for k,v in pairs(self.AmmoMax or {}) do
		self:SetAmmoCount(v, k)
	end  
	 
	-- Capitalize player class because the talker system wants to :/
	-- This is used for playing scenes
	if (self:GetPlayerClass() == "superscout" || self:GetPlayerClass() == "giantscoutmelee" || self:GetPlayerClass() == "chiefscout" || self:GetPlayerClass() == "melee_scout" || self:GetPlayerClass() == "melee_scout_expert" || self:GetPlayerClass() == "melee_scout_sandman" || self:GetPlayerClass() == "giantscout" || self:GetPlayerClass() == "scoutfan" || self:GetPlayerClass() == "scout_shortstop" || self:GetPlayerClass() == "superscoutfan" || self:GetPlayerClass() == "bonk_scout") then
		self.playerclass = "Scout"
	elseif (self:GetPlayerClass() == "demoknight" || self:GetPlayerClass() == "samuraidemo" || self:GetPlayerClass() == "sentrybuster" || self:GetPlayerClass() == "giantdemoman" || self:GetPlayerClass() == "wtfdemoman" || self:GetPlayerClass() == "giantdemoknight" || self:GetPlayerClass() == "chieftavish" || self:GetPlayerClass() == "headless_hatman") then
		self.playerclass = "Demoman"
	elseif (self:GetPlayerClass() == "soldierblackbox" || self:GetPlayerClass() == "soldierbuffed" || self:GetPlayerClass() == "giantsoldier" || self:GetPlayerClass() == "giantburstfiresoldier" || self:GetPlayerClass() == "giantburstfiresoldier2" || self:GetPlayerClass() == "giantblastsoldier" || self:GetPlayerClass() == "colonelbarrage" || self:GetPlayerClass() == "giantsoldiercharged" || self:GetPlayerClass() == "giantsoldierrapidfire") then
		self.playerclass = "Soldier"
	elseif (self:GetPlayerClass() == "giantheavy" || self:GetPlayerClass() == "giantheavyheater" || self:GetPlayerClass() == "giantheavyshotgun" || self:GetPlayerClass() == "heavyshotgun" || self:GetPlayerClass() == "heavyweightchamp" || self:GetPlayerClass() == "steelgauntlet" || self:GetPlayerClass() == "steelgauntletpusher" || self:GetPlayerClass() == "captain_punch" || self:GetPlayerClass() == "superheavyweightchamp") then
		self.playerclass = "Heavy"
	elseif (self:GetPlayerClass() == "bowman" or self:GetPlayerClass() == "bowman_rapid_fire" or self:GetPlayerClass() == "merasmus") then		
		self.playerclass = "Sniper"
	elseif (self:GetPlayerClass() == "giantpyro" || self:GetPlayerClass() == "chiefpyro" || self:GetPlayerClass() == "pyro_flare" || self:GetPlayerClass() == "giantflarepyro") then
		self.playerclass = "Pyro"  
	elseif (self:GetPlayerClass() == "giantengineer") then
		self.playerclass = "Engineer" 
	elseif (self:GetPlayerClass() == "giantmedic" || self:GetPlayerClass() == "kritzmedic") then
		self.playerclass = "Medic"
	elseif (self:GetPlayerClass() == "telecon") then
		self.playerclass = "Telecon"
	elseif (self:GetPlayerClass() == "rebel") then
		self.playerclass = "John"
	else
		self.playerclass = string.upper(string.sub(class,1,1))..string.sub(class,2)	
	end
	
	if (self:Team() == TEAM_BLU) then
		self.teamrole = "offense"
		self.IsMvMDefender = 0
	else
		self.teamrole = "defense"
		self.IsMvMDefender = 1
	end
	if (class == "nick") then
		self.Who = "Gambler"
	elseif (class == "coach") then
		self.Who = "Coach"
	elseif (class == "rochelle") then
		self.Who = "Producer"
	elseif (class == "ellis") then
		self.Who = "Mechanic"
	elseif (class == "bill") then
		self.Who = "Namvet"
	elseif (class == "francis") then
		self.Who = "Biker"
	elseif (class == "louis") then
		self.Who = "Manager"
	elseif (class == "zoey") then
		self.Who = "Teengirl"
	else
		self.Who = string.upper(string.sub(class,1,1))..string.sub(class,2)
	end
	if (self:Team() == TEAM_RED) then
		self.Team = "Survivor"
	else
		self.Team = "Infected"
	end
	timer.Simple(1.0, function()
	
		if (self:GetModel() == "models/player/scoutplayer/scout.mdl") then
			self.playerclass = "Scout"
		elseif (self:GetModel() == "models/player/demomanplayer/demonstrationman.mdl") then
			self.playerclass = "Demoman"
		elseif (self:GetModel() == "models/player/soldierplayer/soldier.mdl") then
			self.playerclass = "Soldier"
		elseif (self:GetModel() == "models/player/heavyplayer/heavy.mdl") then
			self.playerclass = "Heavy"
		elseif (self:GetModel() == "models/player/sniperplayer/sniper.mdl") then		
			self.playerclass = "Sniper"
		elseif (self:GetModel() == "models/player/pyroplayer/pyro.mdl") then
			self.playerclass = "Pyro"
		elseif (self:GetModel() == "models/player/engieplayer/engie.mdl") then
			self.playerclass = "Engineer" 
		elseif (self:GetModel() == "models/player/medicplayer/medic.mdl") then
			self.playerclass = "Medic"
		end

	end)
	-- Setting the model, obviously
	-- Stupid way to enable robots, but we just comment out class model already being defined!
	--if not c.Model then
		if self:GetInfoNum("tf_robot", 0) == 1 or (botrobot:GetBool() and self:IsBot()) or (self:IsBot() and self:Team() == TEAM_BLU and string.find(game.GetMap(), "mvm_") or (self:IsBot() and self.IsMVMRobot and !self.IsBoss)) then--or self:IsBot() then
			c.Model = "models/bots/"..(c.ModelName or "scout").."/bot_"..(c.ModelName or "scout")..".mdl"
		elseif self:GetInfoNum("tf_player_use_female_models", 0) == 1 && self:GetPlayerClass() == "soldier" then
			c.Model = "models/player/"..(c.ModelName or "scout").."_female.mdl"
		elseif self:GetInfoNum("civ2_touhou", 0) == 1 and file.Exists("models/player/touhou/"..(c.ModelName or "scout")..".mdl", "WORKSHOP") then
			c.Model = "models/player/touhou/"..(c.ModelName or "scout")..".mdl"
		elseif self:GetInfoNum("tf_tfc_model_override", 0) == 1 and file.Exists("models/player/tfc_"..(c.ModelName or "scout")..".mdl", "WORKSHOP") then--or self:IsBot() then
			c.Model = "models/player/tfc_"..(c.ModelName or "scout")..".mdl"
		elseif self:GetInfoNum("tf_usehwmmodels", 0) == 1 then--or self:IsBot() then
			c.Model = "models/player/hwm/"..(c.ModelName or "scout")..".mdl"
		elseif self:GetInfoNum("tf_useadvhwmmodels", 0) == 1 then--or self:IsBot() then
			c.Model = "models/player/hwm/adv_"..(c.ModelName or "scout")..".mdl"
		else 
			c.Model = "models/player/"..(c.ModelName or "scout")..".mdl"
		end
		if self:GetInfoNum("tf_giant_robot", 0) == 1 then
			if self:GetPlayerClass() != "medic" and self:GetPlayerClass() != "sniper" and self:GetPlayerClass() != "engineer" and self:GetPlayerClass() != "spy" then
				c.Model = "models/bots/"..(c.ModelName or "scout").."_boss/bot_"..(c.ModelName or "scout").."_boss.mdl"
			else
				c.Model = "models/bots/"..(c.ModelName or "scout").."/bot_"..(c.ModelName or "scout")..".mdl"
			end
			self:SetModelScale(1.75)
			   if  self:GetPlayerClass() == "medic" then
				self:SetHealth(4500)
				self:SetMaxHealth(4500)
		        elseif self:GetPlayerClass() == "pyro" then
				self:SetHealth(3000)
				self:SetMaxHealth(3000)
			elseif self:GetPlayerClass() == "soldier" then
				self:SetHealth(3800)
				self:SetMaxHealth(3800)
			elseif self:GetPlayerClass() == "demoman" then
				self:SetHealth(3300)
				self:SetMaxHealth(3300)
			elseif self:GetPlayerClass() == "engineer" then
				self:SetHealth(2000)
			        self:SetMaxHealth(2000)
		        elseif self:GetPlayerClass() == "sniper" then
			        self:SetHealth(1600)
			        self:SetMaxHealth(1600)
			elseif self:GetPlayerClass() == "scout" and self:GetPlayerClass() == "spy" then
				self:SetHealth(1600)
				self:SetMaxHealth(1600)	
			elseif self:GetPlayerClass() == "heavy" then
				self:SetHealth(5000)
				self:SetMaxHealth(5000)			
			end
			self:SetModelScale(1.75)
		end
	--end
	if (!self.TFBot) then
		self:SetModelScale(1.0)
	end
	if (!self:IsL4D() and !self:IsHL2()) then
		self:SetModel(c.Model)
	end
	-- If this class needs some special initialization, do it
	if c.Initialize then c.Initialize(self) end
	
	-- Notify the client that their class has changed
	umsg.Start("PlayerClassChanged")
		umsg.Long(self:EntIndex()) 
		umsg.String(oldclass)
		umsg.String(class)
	umsg.End()
	
	timer.Simple(0, function() InitPlayerBodygroups(self) end)
	self:ResetClassSpeed()
	if (!self:IsBot()) then
		if (class == "demoman") then
			self:SetNWString("PreferredIcon","hud/leaderboard_class_demo")
		elseif (class == "giantdemoman") then
			self:SetNWString("PreferredIcon","hud/leaderboard_class_demo")
		elseif (class == "gmodplayer") then
			self:SetNWString("PreferredIcon","vgui/modicon")
		elseif (class == "bonzi") then
			self:SetNWString("PreferredIcon","icon16/monkey.png")
		else
			self:SetNWString("PreferredIcon","hud/leaderboard_class_"..string.Replace(class,"giant",""))
		end
	end
	if (self.TFBot and self.IsL4DZombie) then
		for k,v in ipairs(ents.GetAll()) do
			if (IsValid(v.Bot) and v.Bot:EntIndex() == self:EntIndex() and string.find(v:GetClass(),"mvm")) then
				v:CustomOnInitialize(self)
			end
		end
	end
	if (!self:IsHL2() and !self:IsL4D()) then
		if (self:GetPlayerClass() == "bowman_rapid_fire") then
			self:ManipulateBoneScale(self:LookupBone("bip_head"),Vector(0.7, 0.7, 0.7))
		elseif (self:GetPlayerClass() == "scout_shortstop") then
			self:ManipulateBoneScale(self:LookupBone("bip_head"),Vector(0.75, 0.75, 0.75))
		elseif (self:GetPlayerClass() != "	" and self:GetInfoNum("tf_giant_robot",0) == 1) then
			self:SetModelScale(1.75) 
				if (!string.find(self:GetModel(),"boss")) then
					self:ManipulateBoneScale(self:LookupBone("bip_head"),Vector(0.75, 0.75, 0.75))
				else
					self:ManipulateBoneScale(self:LookupBone("bip_head"),Vector(1, 1, 1))
				end
		elseif (self:GetPlayerClass() == "scout" and self:GetInfoNum("tf_giant_robot",0) == 1) then
			self:SetModelScale(1.75)
				if (!string.find(self:GetModel(),"boss")) then
					self:ManipulateBoneScale(self:LookupBone("bip_head"),Vector(0.75, 0.75, 0.75))
				else
					self:ManipulateBoneScale(self:LookupBone("bip_head"),Vector(1, 1, 1))
				end
		else
				self:ManipulateBoneScale(self:LookupBone("bip_head"),Vector(1, 1, 1))
		end
	end
	UpgradePlayerIfBot(self)
	self:ResetClassSpeed()
	local ply = self
	if (ply:IsBot() and ply:GetPlayerClass() == "scout" and ply:GetWeapons()[2]:GetClass() == "tf_weapon_lunchbox_drink") then

		timer.Simple(0.8, function()
			self:SelectWeapon("tf_weapon_lunchbox_drink")
			if (CurTime() > self:GetActiveWeapon():GetNextPrimaryFire()) then
				self:GetActiveWeapon():PrimaryAttack()
			end
			timer.Simple(1.1, function()
				if (string.find(self:GetModel(),"/bot_")) then
					self:SelectWeapon(self:GetWeapons()[3])	
				else
					self:SelectWeapon(self:GetWeapons()[1])	
				end
			end)
		end)
		
	end
	
	if (IsValid(ply.trail)) then
		ply.trail:Remove()
		ply.trail2:Remove()
		ply.trail3:Remove()
		ply.trail4:Remove()
		ply.trail5:Remove()
	end
	if (self.TFBot) then
		self.TargetEnt = lookForNearestPlayer(self)
	end
	timer.Simple(0.1, function()
	
		if (self:IsMiniBoss()) then
			if SERVER then
				self:StopSound("MVM.GiantScoutLoop")
				self:StopSound("MVM.GiantSoldierLoop")
				self:StopSound("MVM.GiantPyroLoop")
				self:StopSound("MVM.GiantDemomanLoop")
				self:StopSound("MVM.GiantHeavyLoop")
				self:StopSound("MVM.SentryBusterLoop")
				self:StopSound("MVM.SentryBusterIntro")
				if (self.playerclass == "Scout") then
					self:EmitSound("MVM.GiantScoutLoop")
				elseif (self.playerclass == "Soldier") then
					self:EmitSound("MVM.GiantSoldierLoop")
				elseif (self.playerclass == "Pyro") then
					self:EmitSound("MVM.GiantPyroLoop")
				elseif (self.playerclass == "Demoman") then
				
					if (!string.find(self:GetPlayerClass(),"sentry")) then
					
						self:EmitSound("MVM.GiantDemomanLoop")
						
					else
						
						self:EmitSound("MVM.SentryBusterLoop")
						self:EmitSound("MVM.SentryBusterIntro")
						
					end
					
				elseif (self.playerclass == "Heavy") then
					self:EmitSound("MVM.GiantHeavyLoop")
				end	
			end
	
		end
		
	end)
end


function meta:SetClassSpeed(sp)  
	if !self:IsHL2() then
		if (self:GetInfoNum("tf_giant_robot",0) == 1 and self:GetPlayerClass() != "scout") then
			self:SetWalkSpeed(sp * 0.5) 
			self:SetRunSpeed(sp * 0.5) 
			self:SetJumpPower(220)
			self:SetCrouchedWalkSpeed(0.33)
			self:SetMaxSpeed(450) 
			self:SetNWFloat("ClassSpeed", sp * 0.5) 
		else
			self:SetWalkSpeed(sp) 
			self:SetRunSpeed(sp) 
			self:SetSlowWalkSpeed(sp * 0.5) 
			self:SetJumpPower(220)
			self:SetCrouchedWalkSpeed(0.33)
			self:SetMaxSpeed(450) 
			self:SetNWFloat("ClassSpeed", sp) 
		end
	else
		self:SetWalkSpeed(190)
		self:SetSlowWalkSpeed(150)
		self:SetRunSpeed(320) 
		self:SetJumpPower(200)
		self:SetCrouchedWalkSpeed(0.4)
		self:SetMaxSpeed(520) 
		self:SetNWFloat("ClassSpeed", sp)
	end
end

function meta:ResetClassSpeed()
	local c = self:GetPlayerClassTable()
	local sp = 100
	if c and c.Speed then sp = c.Speed end
	
	if self.TempAttributes then
		--[[sp = sp * (self.TempAttributes.SpeedBonus or 1) * (self:GetActiveWeapon().LocalSpeedBonus or 1)
		+ (self.TempAttributes.AdditiveSpeedBonus or 0) + (self:GetActiveWeapon().LocalAdditiveSpeedBonus or 0)]]
		
		local mul_speedbonus = self.TempAttributes.SpeedBonus or 1
		local add_speedbonus = self.TempAttributes.AdditiveSpeedBonus or 0
		
		for _,v in ipairs(self:GetTFItems()) do
			if v == self:GetActiveWeapon() or not v.OnlyProvideAttributesOnActive then
				mul_speedbonus = mul_speedbonus * (v.SpeedBonus or 1)
				add_speedbonus = add_speedbonus + (v.AdditiveSpeedBonus or 0)
			end
			
			if v == self:GetActiveWeapon() then
				mul_speedbonus = mul_speedbonus * (v.LocalSpeedBonus or 1)
				add_speedbonus = add_speedbonus + (v.LocalAdditiveSpeedBonus or 0)
			end
		end
		
		if self.ItemSetTable then
			mul_speedbonus = mul_speedbonus * (self.ItemSetTable.SpeedBonus or 1)
			add_speedbonus = add_speedbonus + (self.ItemSetTable.AdditiveSpeedBonus or 0)
		end
		
		sp = sp * mul_speedbonus + add_speedbonus
	end
	self:SetClassSpeed(sp)
	self:SetJumpPower(self.PlayerJumpPower)
end

end

if CLIENT then

local function PlayerClassChanged(id, oldclass, newclass, timeout)
	local pl = Entity(id)
	
	
	if (pl:GetPlayerClass() == "heavy") then
		pl:SetupPhonemeMappings( "player/heavy/phonemes/phonemes" )
	elseif (pl:GetPlayerClass() == "scout") then
		pl:SetupPhonemeMappings( "player/scout/phonemes/phonemes" )
	elseif (pl:GetPlayerClass() == "soldier") then
		pl:SetupPhonemeMappings( "player/soldier/phonemes/phonemes" )
	elseif (pl:GetPlayerClass() == "demoman") then
		pl:SetupPhonemeMappings( "player/demo/phonemes/phonemes" )
	elseif (pl:GetPlayerClass() == "engineer") then
		pl:SetupPhonemeMappings( "player/engineer/phonemes/phonemes" )
	elseif (pl:GetPlayerClass() == "medic") then
		pl:SetupPhonemeMappings( "player/medic/phonemes/phonemes" )
	elseif (pl:GetPlayerClass() == "sniper") then
		pl:SetupPhonemeMappings( "player/sniper/phonemes/phonemes" )
	elseif (pl:GetPlayerClass() == "spy") then
		pl:SetupPhonemeMappings( "player/spy/phonemes/phonemes" )
	else
		pl:SetupPhonemeMappings( "phonemes" )
	end
	
	-- Because when the player spawns for the first time, their clientside entity seems not to have been created yet when this is called
	-- So we keep on trying till we run out of cake, err... I mean, until LocalPlayer() exists
	-- Also, there is no failsafe exit, because this should never loop forever unless something really wrong happens
	if not IsValid(pl) then
		if timeout then
			timeout = timeout - 0.05
			if timeout <= 0 then
				return
			end
		end
		
		timer.Simple(0.05, function() PlayerClassChanged(id, oldclass, newclass, timeout) end)
		return
	end
	
	--MsgFN("PlayerClassChanged %s", tostring(pl))
	
	local t1 = GAMEMODE.PlayerClasses[oldclass]
	local t2 = GAMEMODE.PlayerClasses[newclass]
	
	if t2 then
		pl:SetNWBool("IsHL2", t2.IsHL2 or false)
	end
	
	if pl:ShouldUseDefaultHull() then
		pl:ResetHull()
	else
		pl:SetHull(unpack(TFHull))
		pl:SetHullDuck(unpack(TFHullDuck))
	end
	
	pl:SetDuckSpeed(0.2)
	pl.TempAttributes = {}
	
	if pl == LocalPlayer() then
		--GAMEMODE:InitWeaponSelection(newclass)
		LocalPlayer().ShouldUpdateWeaponSelection = true
		
		if t1 and t1.ChangeClass then t1.ChangeClass(LocalPlayer(), newclass) end
		if t2 and t2.Initialize then t2.Initialize(LocalPlayer()) end
	end
	
	if t2.Buildings then
		pl.Buildings = tf_objects.GetBuildables(t2.Buildings)
		pl.BuilderInit = pl.Buildings
	end
end

usermessage.Hook("PlayerClassChanged", function(msg)
	local id = msg:ReadLong()
	local oldclass = msg:ReadString()
	local newclass = msg:ReadString()
	
	PlayerClassChanged(id, oldclass, newclass, 2)
end)

end

-- Shared

function meta:GetPlayerClass()
	return self:GetNWString("PlayerClass")
end

function meta:GetPlayerClassTable()
	return GAMEMODE.PlayerClasses[self:GetPlayerClass()]
end

function meta:GetRealClassSpeed()
	local sp = self:GetNWFloat("ClassSpeed")
	
	if sp==0 then return 100
	else return sp
	end
end

function meta:GetClassSpeed()
	return self:GetNWFloat("ClassSpeed")
end


PlayerNamedBodygroups = {
	["demo"] = {},
	["engineer"] = {hat=1,rightarm=2},
	["heavy"] = {hands=1},
	["medic"] = {},
	["pyro"] = {head=1,grenades=2},
	["scout"] = {hat=1,headphones=2,shoes_socks=3},
	["sniper"] = {arrows=1,hat=2,bullets=3},
	["soldier"] = {hat=2,medal=3,grenades=4},
	["spy"] = {},
}

PlayerNamedViewmodelBodygroups = {
	["demo"] = {},
	["engineer"] = {rightarm=1},
	["heavy"] = {},
	["medic"] = {},
	["pyro"] = {},
	["scout"] = {},
	["sniper"] = {},
	["soldier"] = {},
	["spy"] = {},
}

ClassToMedalBodygroup = {
	["scout"] 		= 0,
	["sniper"] 		= 1,
	["soldier"] 	= 2,
	["demo"] 		= 3,
	["medic"] 		= 4,
	["heavy"] 		= 5,
	["pyro"] 		= 6,
	["spy"] 		= 7,
	["engineer"] 	= 8,
}
