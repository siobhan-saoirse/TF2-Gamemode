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
	self:SetNWInt("TeamNum",self.TeamNum)
	self:SetNWInt("Team",self.Team)
	print(key, value, tonumber(value), self.Team, self.TeamNum)
end

function ENT:StartTouch(ent) 
	print(self.Team, self.TeamNum)
end

function ENT:Touch(ent)
	if ent:IsPlayer() and string.find(game.GetMap(),"mvm_") and ent:Team() == TEAM_BLU and self.TeamNum == TEAM_BLU then
		self.Players[ent] = ent:EntIndex()
		--print(self.Team)
		ent:GodEnable()
		ent:SetSkin(3)
	end
	
		if (ent:IsPlayer()) then
			if (ent:Team() ~= self:GetNWInt("TeamNum") && ent:Team() == TEAM_RED && ent:Team() == TEAM_BLU) then
				ent:KillSilent()
				ent:Spawn()
			end
		end
end

function ENT:EndTouch(ent)
	if ent:IsPlayer() then
		self.Players[ent] = nil
		if (string.find(game.GetMap(),"mvm_") and ent:Team() == TEAM_BLU) then
			ent:GodDisable()
			ent:SetSkin(1)
		end
		if (ent.TFBot and ent:Team() == TEAM_RED and string.find(game.GetMap(),"mvm_")) then
			ent:GodDisable()
			ent:SetSkin(0)
		end
	end
end