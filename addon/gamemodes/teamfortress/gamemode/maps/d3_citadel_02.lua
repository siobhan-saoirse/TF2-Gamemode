NEXT_MAP = "d3_citadel_03"

NEXT_MAP_PERCENT = 1

TRIGGER_DELAYMAPLOAD = { Vector( 3781, 13186, 3900 ), Vector( 3984, 13590, 4000 ) }


-- Player spawns
function tf2gmhl2PlayerSpawn( ply )

	ply:Give( "weapon_crowbar" )
	ply:Give( "weapon_pistol" )
	ply:Give( "weapon_smg1" )
	ply:Give( "weapon_357" )
	ply:Give( "weapon_frag" )
	ply:Give( "weapon_physcannon" )
	ply:Give( "weapon_shotgun" )
	ply:Give( "weapon_ar2" )
	ply:Give( "weapon_rpg" )
	ply:Give( "weapon_crossbow" )
	ply:Give( "weapon_bugbait" )

	if ( !game.SinglePlayer() && IsValid( PLAYER_VIEWCONTROL ) && ( PLAYER_VIEWCONTROL:GetClass() == "point_viewcontrol" ) ) then
	
		ply:SetViewEntity( PLAYER_VIEWCONTROL )
		ply:Spectate( OBS_MODE_ROAMING )
		ply:DrawWorldModel( false )
		ply:Lock()
	
	end

	timer.Simple( 0.1, function() if ( IsValid( ply ) ) then ply:SetNoTarget( true ); end; end )

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Initialize entities
function tf2gmhl2MapEdit()

	ents.FindByName( "global_newgame_template_base_items" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_local_items" )[ 1 ]:Remove()

	if ( !game.SinglePlayer() ) then
	
		local viewcontrol = ents.Create( "point_viewcontrol" )
		viewcontrol:SetName( "pod_player_viewcontrol" )
		viewcontrol:SetPos( ents.FindByName( "pod_player" )[ 1 ]:GetPos() )
		viewcontrol:SetKeyValue( "spawnflags", "12" )
		viewcontrol:Spawn()
		viewcontrol:Activate()
		viewcontrol:SetParent( ents.FindByName( "pod_player" )[ 1 ] )
		viewcontrol:Fire( "SetParentAttachment", "vehicle_driver_eyes" )
		viewcontrol:Fire( "Enable", "", 1 )
	
	end

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( !game.SinglePlayer() && ( ent:GetClass() == "point_viewcontrol" ) ) then
	
		if ( string.lower( input ) == "enable" ) then
		
			PLAYER_VIEWCONTROL = ent
		
			for _, ply in ipairs( player.GetAll() ) do
			
				ply:SetViewEntity( ent )
				ply:Spectate( OBS_MODE_ROAMING )
				ply:DrawWorldModel( false )
				ply:Lock()
			
			end
		
			if ( !ent.doubleEnabled ) then
			
				ent.doubleEnabled = true
				ent:Fire( "Enable" )
			
			end
		
		elseif ( string.lower( input ) == "disable" ) then
		
			PLAYER_VIEWCONTROL = nil
		
			for _, ply in ipairs( player.GetAll() ) do
			
				ply:SetViewEntity( ply )
				ply:UnSpectate()
				ply:DrawWorldModel( true )
				ply:UnLock()
			
				ply:Spawn()
			
			end
		
			return true
		
		end
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "track_dump" ) && ( string.lower( input ) == "enable" ) ) then
	
		if ( timer.Exists( "tf2gmhl2UpdatePlayerPosition" ) ) then timer.Destroy( "tf2gmhl2UpdatePlayerPosition" ); end
	
		GAMEMODE:CreateSpawnPoint( Vector( 3882, 13388, 3950 ), 0 )
	
		PLAYER_VIEWCONTROL:Fire( "Disable" )
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )


if ( !game.SinglePlayer() ) then

	-- Update player position to the vehicle
	function tf2gmhl2UpdatePlayerPosition()
	
		for _, ply in ipairs( team.GetPlayers( TEAM_ALIVE ) ) do
		
			if ( IsValid( ply ) && ply:Alive() ) then
			
				ply:SetPos( ents.FindByName( "pod_player" )[ 1 ]:GetPos() )
			
			end
		
		end
	
	end
	timer.Create( "tf2gmhl2UpdatePlayerPosition", 0.1, 0, tf2gmhl2UpdatePlayerPosition )

end
