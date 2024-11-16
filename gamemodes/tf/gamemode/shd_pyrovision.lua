if CLIENT then
 
	local Suffixes = {"rt", "lf", "up", "ft", "dn", "bk"}
	local Skybox = GetConVarString("sv_skyname")
	local Replacement = "rj/sky_pyroland_01" 
	for k,v in pairs(Suffixes) do
		if GetConVar("tf_pyrovision"):GetBool() then 
			Material(Skybox..v):SetTexture("$basetexture", Replacement..v)
		end
	end
	 
	function replace(str,strb,text,rembump,texture2)
	 
		if GetConVar("tf_pyrovision"):GetBool() then 
			local SourceMaterial = Material(str)
			local ReplacementMaterial = Material(strb)
			local D = ReplacementMaterial:GetTexture("$basetexture")
			if(!text) then
					SourceMaterial:SetTexture("$basetexture", D)
					if(texture2 != nil) then
							SourceMaterial:SetTexture("$basetexture2", texture2)
					end
					//SourceMaterial:SetTexture("$lightwarptexture", "rj/colorbar_peach02")
			else
					if(texture2 != nil) then
							SourceMaterial:SetTexture("$basetexture2", texture2)
					end
					SourceMaterial:SetTexture("$basetexture", strb)
			end
			if(rembump) then
					SourceMaterial:SetTexture("$blendmodulatetexture", "nature/snowgrass_blendmask")
			end
		end
		
	end

	timer.Create("ReplaceTextures", 1.0, 0, function()
		
		replace("models/props_doomsday/dirtground006","rj/papergrain_pink",true,true)
		replace("nature/blendground_doomsday001","rj/colorbar_wood02",true,true,"rj/sky_pyroland_01dn")
		replace("nature/dirtground001","rj/colorbar_peach02",true,true)
		replace("nature/dirtground001","rj/colorbar_peach02",true,true)
		replace("nature/dirtroad003","rj/colorbar_peach02",true,true)
		replace("nature/gm_construct_grass","rj/sky_pyroland_01dn",true,true)
		replace("gm_construct/grass_13","rj/sky_pyroland_01dn",true,true,"rj/sky_pyroland_01dn") 
		replace("gm_construct/flatgrass","rj/sky_pyroland_01dn",true,true,"rj/sky_pyroland_01dn") 
		replace("gm_construct/flatgrass_2","rj/sky_pyroland_01dn",true,true,"rj/sky_pyroland_01dn") 
		replace("gm_construct/grass-sand_13","rj/sky_pyroland_01dn",true,true,"rj/papergrain_pink") 
		replace("gm_construct/water_13","rj/papergrain_pink",true,true,"rj/papergrain_pink") 
		replace("gm_construct/wall_bottom","rj/sky_pyroland_01dn",true,true) 
		replace("gm_construct/wall_top","rj/papergrain_pink",true,true) 
		replace("brick/brickwall003a_construct","rj/sky_badlands_pyroland_dn",true,true,"rj/sky_badlands_pyroland_dn") 
		replace("models/props_junk/woodcrates01a","rj/papergrain_pink",true,true) 
		replace("concrete/concretefloor009a_construct","rj/papergrain_pink",true,true) 
		replace("concrete/concretefloor026a","rj/papergrain_pink",true,true) 
		replace("concrete/concretefloor028a","rj/sky_badlands_pyroland_dn",true,true,"rj/sky_badlands_pyroland_dn") 
		replace("building_template/roof_template001a","rj/sky_pyroland_01dn",true,true) 
		replace("plaster/plasterwall022c","rj/colorbar_pink01",true,true)   
		replace("models/props_junk/woodcrates02a","rj/papergrain_pink",true,true) 
		replace("gm_construct/construct_sand","rj/sky_pyroland_01dn",true,true) 
		replace("gm_construct/construct_concrete_floor","rj/sky_badlands_pyroland_dn",true,true) 
		replace("gm_construct/construct_concrete_ground","rj/papergrain_pink",true,true) 
		 
		 
		replace("models/props_mining/rock006","rj/colorbar3",true,true)
		replace("nature/blendrockgroundwall004","rj/sky_badlands_pyroland_up_rot90",true,true)
		replace("nature/blendrockground004","rj/sky_badlands_pyroland_up_rot90",true,true)
		replace("nature/rockwall007","rj/colorbar3",true,true)
		 
		 
		 
		replace("models/props_mining/rock001","rj/colorbar_purple01",true,true)
		replace("models/props_mining/rock002","rj/colorbar_purple01",true,true)
		replace("models/props_mining/rock003","rj/colorbar_purple01",true,true)
		replace("models/props_mining/rock004","rj/colorbar_purple01",true,true)
		replace("models/props_mining/rock005","rj/colorbar_purple01",true,true)
		 
		   
		 
		replace("overlays/dirtroad001","rj/papergrain_pink")
		replace("detail/detailsprites_dustbow","rj/detailsprites_pyrovision02",true,true)
		
	end)
end