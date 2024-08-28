local bindfunc = function(self, mat, ent)

	if !IsValid(ent) then return end

	local factor = 0

	if ent.ProxyentCloakEffect and ent.ProxyentCloakEffect.GetCloakTintVector then
		mat:SetInt("$cloakPassEnabled", 1)
		mat:SetVector("$cloakcolortint", ent.ProxyentCloakEffect:GetCloakTintVector())
		mat:SetFloat("$refractamount", ent.ProxyentCloakEffect:GetCloakRefractAmount())

		//If the cloak effect is animated, then use CurTime() to determine what the cloak level should be at, otherwise use the static cloak factor value
		if ent.ProxyentCloakEffect:GetCloakAnim() then
			local diff = (ent.ProxyentCloakEffect.CloakAnimTargetTime or 0) - CurTime()
			if ent.ProxyentCloakEffect:GetCloakAnimActive() then
				//cloaking
				if diff < 0 then
					factor = 1
				else
					factor = 1 - (diff / ent.ProxyentCloakEffect:GetCloakAnimTimeIn())
				end
			else
				//decloaking
				if diff < 0 then
					factor = 0
				else
					factor = diff / ent.ProxyentCloakEffect:GetCloakAnimTimeOut()
				end
			end
		else
			factor = ent.ProxyentCloakEffect:GetCloakFactor()
		end

		if ent.ProxyentCloakEffect:GetCloakDisablesShadow() then
			//Tell the proxy ent to disable the ent's shadow if cloaked
			if factor > 0.27 then
				ent.ProxyentCloakEffect.ShouldDisableShadow = true
			else
				ent.ProxyentCloakEffect.ShouldDisableShadow = false
			end
		end
	end

	mat:SetFloat("$cloakfactor", factor)

end


matproxy.Add(
{
	name = "invis",
	bind = bindfunc,
})

matproxy.Add(
{
	name = "spy_invis",
	bind = bindfunc,
})

matproxy.Add(
{
	name = "weapon_invis",
	bind = bindfunc,
})

matproxy.Add(
{
	name = "vm_invis",
	bind = bindfunc,
})

matproxy.Add(
{
	name = "building_invis",
	bind = bindfunc,
})