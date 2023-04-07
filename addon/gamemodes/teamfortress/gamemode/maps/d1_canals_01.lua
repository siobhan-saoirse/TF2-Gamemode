NEXT_MAP = "d1_canals_01a"

CANALS_TRAIN_PREVENT_STARTFOWARD = false


-- Player spawns
function tf2gmhl2PlayerSpawn( ply )

	ply:Give( "weapon_crowbar" )

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Initialize entities
function tf2gmhl2MapEdit()

	ents.FindByName( "start_item_template" )[ 1 ]:Remove()

	if ( !game.SinglePlayer() ) then ents.FindByName( "boxcar_door_close" )[ 1 ]:Remove(); end

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( !game.SinglePlayer() && ( ent:GetName() == "barrelpush_cop1_sched" ) && ( string.lower( input ) == "startschedule" ) ) then
	
		CANALS_TRAIN_PREVENT_STARTFOWARD = true
	
	end

	if ( !game.SinglePlayer() && CANALS_TRAIN_PREVENT_STARTFOWARD && ( ent:GetName() == "looping_traincar1" ) && ( string.lower( input ) == "startforward" ) ) then
	
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "looping_traincar2" ) && ( string.lower( input ) == "startforward" ) ) then
	
		return true
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
