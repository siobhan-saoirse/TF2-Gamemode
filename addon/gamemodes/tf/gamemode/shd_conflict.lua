
timer.Create("ExpectErrors!2", 0, 0, function()
	if (game.SinglePlayer()) then
		ErrorNoHalt("Singleplayer is enabled! Expect errors!")
	end
end)
if !IsMounted("tf") and !steamworks.IsSubscribed("3323795558") then
	timer.Create("ExpectErrors!", 0, 0, function()
		ErrorNoHalt("Team Fortress 2 is not mounted! Expect errors!")
	end)
	if CLIENT then
		local conflict_help_frame = vgui.Create( "DFrame" )
		conflict_help_frame:SetSize(200, 200)
		conflict_help_frame:Center()
		conflict_help_frame:SetTitle("!!TF2 IS NOT MOUNTED!!")
		conflict_help_frame:ShowCloseButton(true)
		conflict_help_frame:SetBackgroundBlur(true)
		conflict_help_frame:MakePopup()

		local conflicttext = vgui.Create("RichText", conflict_help_frame)
		conflicttext:Dock(FILL)
		conflicttext:InsertColorChange(255, 255, 255, 255)
		conflicttext:CenterHorizontal(0.5)
		conflicttext:SetVerticalScrollbarEnabled(false)
		conflicttext:AppendText("Hey! TF2 is currently not mounted! Without the assets, you will see everything as ERRORs! Luckily, I do have a solution for ya. Click the button below me to install the TF2 assets pack.")
			local conflictbut2 = vgui.Create("DButton", conflict_help_frame)
			conflictbut2:SetSize(100, 30)
			conflictbut2:SetPos(0, 125)
			conflictbut2:CenterHorizontal(0.5)
			conflictbut2:SetText("Subscribe") 

			function conflictbut2.DoClick()
				steamworks.Subscribe( "3323795558" )
				steamworks.ApplyAddons()
				RunConsoleCommand("disconnect")
			end
	end
end 