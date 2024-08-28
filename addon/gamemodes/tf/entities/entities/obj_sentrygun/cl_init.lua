
include("shared.lua")

function ENT:DoMuzzleFlash(right)
	if self:GetLevel() == 1 then
		ParticleEffectAttach("muzzle_sentry", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("muzzle"))
		self.MuzzleAttachmentOverride = nil
	else
		if right then
			ParticleEffectAttach("muzzle_sentry2", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("muzzle_r"))
			self.MuzzleAttachmentOverride = "muzzle_r"
		else
			ParticleEffectAttach("muzzle_sentry2", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("muzzle_l"))
			self.MuzzleAttachmentOverride = "muzzle_l"
		end
	end
end

function ENT:Think()
	if self:GetState()>=2 then
		if self:GetBuildingType() == 1 and not self.DoneParticleEffect then
			if self:Team() == TEAM_BLU then
				ParticleEffectAttach("cart_flashinglight", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("siren"))
			else
				ParticleEffectAttach("cart_flashinglight_red", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("siren"))
			end
			self.DoneParticleEffect = true
		end
	end
end

usermessage.Hook("DoSentryMuzzleFlash", function(msg)
	local w = msg:ReadEntity()
	if IsValid(w) and w.DoMuzzleFlash then
		w:DoMuzzleFlash(msg:ReadChar() > 0)
	end
end)

usermessage.Hook("NotifySentrySpotted", function(msg)
	local w = msg:ReadEntity()
	if IsValid(w) then
		w:EmitSound("Building_Sentrygun.AlertTarget")
	else
		LocalPlayer():EmitSound("Building_Sentrygun.AlertTarget")
	end
end)
