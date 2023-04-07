NEXT_MAP = "d1_canals_06"


-- Player spawns
function tf2gmhl2PlayerSpawn( ply )

	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_smg1" )

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Initialize entities
function tf2gmhl2MapEdit()

	ents.FindByName( "global_newgame_template" )[ 1 ]:Remove()

	if ( !game.SinglePlayer() ) then
	
		ents.FindByName( "relay_rockfall_start" )[ 1 ]:Remove()
		ents.FindByName( "relay_rockfall_docollapse" )[ 1 ]:Remove()
	
	end

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( !game.SinglePlayer() && ( ent:GetName() == "relay_airboat_gateopen" ) && ( string.lower( input ) == "trigger" ) ) then
	
		ALLOWED_VEHICLE = "Airboat"
		PrintMessage( HUD_PRINTTALK, "You're now allowed to spawn the Airboat (F3)." )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "scriptcond_pincher_cops" ) && ( string.lower( input ) == "enable" ) ) then
	
		ents.FindByName( "relay_pincher_startcops" )[ 1 ]:Fire( "Trigger" )
		ents.FindByName( "relay_pincher_startmanhacks" )[ 1 ]:Fire( "Trigger" )
		ents.FindByName( "trigger_pincher_failsafe_left" )[ 1 ]:Fire( "Kill" )
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "door_boatdock_entrance" ) && ( string.lower( input ) == "close" ) ) then
	
		return true
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
