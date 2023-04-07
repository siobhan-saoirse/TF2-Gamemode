
local crosshairs = surface.GetTextureID("sprites/tf_crosshairs")

Crosshairs = {

tf_crosshair1={
	x=0,
	y=0,
	w=32,
	h=32,
},
tf_crosshair2={
	x=64,
	y=0,
	w=32,
	h=32,
},
tf_crosshair3={
	x=32,
	y=32,
	w=32,
	h=32,
},
tf_crosshair4={
	x=64,
	y=64,
	w=64,
	h=64,
},
tf_crosshair5={
	x=0,
	y=64,
	w=32,
	h=32,
},
tf_crosshair6={
	x=0,
	y=48,
	w=24,
	h=24,
},

} -- Crosshairs

local function DrawCrosshair(crosshair, scale)
	local c = Crosshairs[crosshair or "_"] or Crosshairs.tf_crosshair1
	local s = scale or 1
	local W,H = ScrW(), ScrH()
	local pos = LocalPlayer():GetEyeTrace().HitPos:ToScreen()
	surface.SetDrawColor(255,255,255,255)
	if LocalPlayer():ShouldDrawLocalPlayer() then -- and !LocalPlayer().FirstReality then
		tf_draw.ModTexture(crosshairs, pos.x - ((s*c.w) / 2), pos.y - ((s*c.w) / 2), s*c.w, s*c.h, c)
	else
		tf_draw.ModTexture(crosshairs, (W-s*c.w)/2, (H-s*c.h)/2, s*c.w, s*c.h, c)
	end
end

function GM:DrawCrosshair()
	if GetConVarNumber("crosshair")==0 or LocalPlayer():GetNWBool("Taunting") then return end
	local w = LocalPlayer():GetActiveWeapon()
	
	-- false is not nil, this will exclude HL2 weapons, which do not have this property, but still have a crosshair
	if w.DrawCrosshair==false then
		return
	end
	
	if IsValid(w) then
		DrawCrosshair(w.Crosshair, w.CrosshairScale)
	end
end
