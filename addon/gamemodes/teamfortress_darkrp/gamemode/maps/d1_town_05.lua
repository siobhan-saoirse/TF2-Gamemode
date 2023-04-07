NEXT_MAP = "d2_coast_01"

TRIGGER_DELAYMAPLOAD = { Vector( -1723, 10939, 904 ), Vector( -1638, 10995, 1010 ) }

TOWN_CREATE_NEW_SPAWNPOINT = true


-- Player spawns
function tf2gmhl2PlayerSpawn( ply )

	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_357" )
	ply:Give( "weapon_frag" )
	ply:Give( "weapon_physcannon" )
	ply:Give( "weapon_shotgun" )

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Initialize entities
function tf2gmhl2MapEdit()

	ents.FindByName( "player_spawn_template" )[ 1 ]:Remove()

	if ( !game.SinglePlayer() ) then
	
		ents.FindByName( "trigger_close_door" )[ 1 ]:Remove()
	
	end

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_attentiontoradio" ) && ( string.lower( input ) == "enable" ) ) then
	
		ents.FindByName( "alyx_camera" )[ 1 ]:Fire( "SetOn" )
		ents.FindByName( "lcs_leon_nag" )[ 1 ]:Fire( "Kill" )
		ents.FindByName( "radio_nag" )[ 1 ]:Fire( "Kill" )
		ents.FindByName( "lcs_leon_radios3" )[ 1 ]:Fire( "Start" )
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_leon_waits" ) && ( string.lower( input ) == "enable" ) ) then
	
		ents.FindByName( "warehouse_leonleads_lcs" )[ 1 ]:Fire( "Start" )
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_leaonwait1" ) && ( string.lower( input ) == "enable" ) ) then
	
		ents.FindByName( "warehouse_leonleads_lcs" )[ 1 ]:Fire( "Resume" )
		ents.FindByName( "radio_nag" )[ 1 ]:Fire( "Disable" )
		return true
	
	end

	if ( !game.SinglePlayer() && TOWN_CREATE_NEW_SPAWNPOINT && ( ent:GetName() == "citizen_warehouse_door_1" ) && ( string.lower( input ) == "open" ) ) then
	
		TOWN_CREATE_NEW_SPAWNPOINT = false
		GAMEMODE:CreateSpawnPoint( Vector( -1160, 10122, 908 ), 90 )
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
