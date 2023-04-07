ENT.Base = "base_brush"
ENT.Type = "brush"

randomscoutubertaunt = 
{
	"vo/Scout_specialcompleted12.mp3",
	"vo/Scout_award05.mp3", 
	"vo/taunts/Scout_taunts02.mp3",
	"vo/taunts/Scout_taunts09.mp3"
}	
randomsoldierubertaunt = 
{
	"vo/taunts/Soldier_taunts05.mp3",
	"vo/taunts/Soldier_taunts11.mp3", 
	"vo/taunts/Soldier_taunts21.mp3",
	"vo/taunts/Soldier_taunts06.mp3",
	"vo/taunts/Soldier_taunts15.mp3",
	"vo/taunts/Soldier_taunts04.mp3",
	"vo/taunts/Soldier_taunts12.mp3"
}		
randomdemomanubertaunt = 
{
	"vo/taunts/demoman_taunts01.mp3",
	"vo/taunts/demoman_taunts07.mp3",
	"vo/taunts/demoman_taunts09.mp3",
	"vo/taunts/demoman_taunts15.mp3",
}
		
randompyroubertaunt = 
{
	"vo/Pyro_specialcompleted01.mp3",
	"vo/Pyro_laughlong01.mp3",
}
function ENT:Initialize()
	local pos = self:GetPos()
	local mins, maxs = self:WorldSpaceAABB() -- https://forum.facepunch.com/gmoddev/lmcw/Brush-entitys-ent-GetPos/1/#postdwfmq
	pos = (mins + maxs) * 0.5

	self.Team = self.Team or 0		
	self.TeamNum = self.TeamNum or 0
	self.Pos = pos 
	self.Players = {}
end 

function ENT:KeyValue(key,value)
	key = string.lower(key)
	
	if key=="teamnum" then
		local t = tonumber(value)
		
		if t==0 then
			self.TeamNum = 0
		elseif t==2 then
			self.TeamNum = TEAM_RED
		elseif t==3 then
			self.TeamNum = TEAM_BLU
		end

		self.Team = tonumber(value)
	end
	print(key, value, tonumber(value), self.Team)
end

function ENT:StartTouch(ent) 
end

function ENT:Think()
	if game.GetMap() != "achievement_engineer_idle_a1" then
		for _,ent in ipairs(ents.FindInSphere(self.Pos, 100)) do
			if self.TeamNum == TEAM_RED then
				if ent:IsPlayer() and ent:Team() == TEAM_BLU then
					print(self.Team)
					ent:SetLocalVelocity( -ent:GetVelocity() * 8  )
					ent:EmitSound("player/suit_denydevice.wav", 50)
				end
			end
			if self.TeamNum == TEAM_BLU then 
				if ent:IsPlayer() and ent:Team() == TEAM_RED then
					ent:SetLocalVelocity( -ent:GetVelocity() * 8 )
					ent:EmitSound("player/suit_denydevice.wav", 50)
				end
			end
		end
	end
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() and ent:Team() == TEAM_BLU then
		self.Players[ent] = -1
		print(self.Team) 
		if ent:Team() == TEAM_BLU and ent:GetInfoNum("tf_robot", 0) == 1 then  
			timer.Create("LoopGod", 0.001, 0, function()
				if self:GetName() == "red_respawnroom1" or self:GetName() == "red_respawnroom2" then
					ent:TakeDamage(50000)
					timer.Simple(0.3, function()
						ent:EmitSound("vo/engineer_no0"..math.random(1,3)..".mp3", 80, 100)
					end)
				else
					ent:SetSkin(3)
					ent:GodEnable()
				end
			end)
		end 
		if ent:Team() == TEAM_BLU and ent:IsBot() and GetConVar("tf_bots_are_robots"):GetInt() == 1 then 
			timer.Create("LoopGod", 0.001, 0, function()
				if self:GetName() == "red_respawnroom1" or self:GetName() == "red_respawnroom2" then
					ent:TakeDamage(50000)
					timer.Simple(0.3, function()
						ent:EmitSound("vo/engineer_no0"..math.random(1,3)..".mp3", 80, 100)
					end)
				else
					ent:SetSkin(3)
					ent:GodEnable()
				end
			end)
		end
	end
end

function ENT:EndTouch(ent)
	if ent:IsPlayer() then
		self.Players[ent] = nil
		if ent:Team() == TEAM_BLU and ent:GetInfoNum("tf_robot", 0) == 1 and ent:Alive() then
			timer.Stop("LoopGod")
			ent:GodDisable() 
			if ent:GetPlayerClass() == "scout" then
				ent:EmitSound(table.Random(randomscoutubertaunt), 80, 100, 1, CHAN_VOICE )
			elseif ent:GetPlayerClass() == "soldier" then
				ent:EmitSound(table.Random(randomsoldierubertaunt), 80, 100, 1, CHAN_VOICE 	)
			elseif ent:GetPlayerClass() == "pyro" then
				ent:EmitSound(table.Random(randompyroubertaunt), 80, 100, 1, CHAN_VOICE 	)
			elseif ent:GetPlayerClass() == "demoman" then
				ent:EmitSound(table.Random(randomdemomanubertaunt), 80, 100, 1, CHAN_VOICE 	)
			end
			ent:SetSkin(1)
		end
		if ent:Team() == TEAM_BLU and string.find(game.GetMap(), "") and ent:Alive() then
			timer.Stop("LoopGod")
			ent:GodDisable() 
			if ent:GetPlayerClass() == "scout" then
				ent:EmitSound(table.Random(randomscoutubertaunt), 80, 100, 1, CHAN_VOICE )
			elseif ent:GetPlayerClass() == "soldier" then
				ent:EmitSound(table.Random(randomsoldierubertaunt), 80, 100, 1, CHAN_VOICE 	)
			elseif ent:GetPlayerClass() == "pyro" then
				ent:EmitSound(table.Random(randompyroubertaunt), 80, 100, 1, CHAN_VOICE 	)
			elseif ent:GetPlayerClass() == "demoman" then
				ent:EmitSound(table.Random(randomdemomanubertaunt), 80, 100, 1, CHAN_VOICE 	)
			end
			ent:SetSkin(1)
		end
	end
end