for k, v in pairs(engine.GetAddons()) do 
	--print("addon "..v.wsid.." aka "..v.title.." has been detected!")
	if v.wsid == "349050451" and v.mounted == true then
		if not game.SinglePlayer() then if not LocalPlayer():IsListenServerHost() then return end end
		local conflict_help_frame = vgui.Create( "DFrame" )
		conflict_help_frame:SetSize(200, 200)
		conflict_help_frame:Center()
		conflict_help_frame:SetTitle("!!CONFLICT!!")
		conflict_help_frame:ShowCloseButton(true)
		conflict_help_frame:SetBackgroundBlur(true)
		conflict_help_frame:MakePopup()

		local conflicttext = vgui.Create("RichText", conflict_help_frame)
		conflicttext:Dock(FILL)
		conflicttext:InsertColorChange(255, 255, 255, 255)
		conflicttext:CenterHorizontal(0.5)
		conflicttext:SetVerticalScrollbarEnabled(false)
		conflicttext:AppendText("A addon named "..v.title.." (id "..v.wsid..") has been detected. This addon is known to cause problems with the gamemode. I suggest you disable it while playing the gamemode. After disabling it, reload the map!")

		local conflictbut = vgui.Create("DButton", conflict_help_frame)
		conflictbut:SetSize(100, 30)
		conflictbut:SetPos(0, 145)
		conflictbut:CenterHorizontal(0.5)
		conflictbut:SetText("Open Page")

		function conflictbut.DoClick()
			steamworks.ViewFile(349050451)
		end
	elseif v.wsid == "1417447538" and v.mounted == true then
		if not game.SinglePlayer() then if not LocalPlayer():IsListenServerHost() then return end end
		local conflict_help_frame = vgui.Create( "DFrame" )
		conflict_help_frame:SetSize(200, 200)
		conflict_help_frame:Center()
		conflict_help_frame:SetTitle("!!CONFLICT!!")
		conflict_help_frame:ShowCloseButton(true)
		conflict_help_frame:SetBackgroundBlur(true)
		conflict_help_frame:MakePopup()

		local conflicttext = vgui.Create("RichText", conflict_help_frame)
		conflicttext:Dock(FILL)
		conflicttext:InsertColorChange(255, 255, 255, 255)
		conflicttext:CenterHorizontal(0.5)
		conflicttext:SetVerticalScrollbarEnabled(false)
		conflicttext:AppendText("A addon named "..v.title.." (id "..v.wsid..") has been detected. The addon is conflicting with many core features and other things that is part of Civilian 2. Civilian 2 is not compatible with Team Fortress 2 gamemode. Please uninstall/disable the addon and reload the map.")

		local conflictbut = vgui.Create("DButton", conflict_help_frame)
		conflictbut:SetSize(100, 30)
		conflictbut:SetPos(0, 145)
		conflictbut:CenterHorizontal(0.5)
		conflictbut:SetText("Open Page")

		function conflictbut.DoClick()
			steamworks.ViewFile(349050451)
		end
	end
end

if !IsMounted("tf") then
end

