
if !IsMounted("tf") then
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
		conflicttext:AppendText("Unfortuntely, it is highly unrecommended to play this gamemode right now because you do not have Team Fortress 2 Mounted. Please get it from the steam store.")
			local conflictbut2 = vgui.Create("DButton", conflict_help_frame)
			conflictbut2:SetSize(100, 30)
			conflictbut2:SetPos(0, 125)
			conflictbut2:CenterHorizontal(0.5)
			conflictbut2:SetText("I understand") 

			function conflictbut.DoClick()
				engine.SetMounted("tf",true)
				RunConsoleCommand("retry")
			end
			function conflictbut2.DoClick()
				conflict_help_frame:Close()
			end
	end
end 