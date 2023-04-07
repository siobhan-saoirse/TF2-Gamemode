INFO_PLAYER_SPAWN = { Vector( -2489, -1292, 580 ), 90 }

NEXT_MAP_PERCENT = 101

RESET_WEAPONS = true

TRIGGER_DELAYMAPLOAD = { Vector( 14095, 15311, 14964 ), Vector( 13702, 14514, 15000 ) }

if ( PLAY_EPISODE_1 ) then

	NEXT_MAP = "ep1_citadel_00"

else

	NEXT_MAP = "d1_trainstation_01"

end

OVERRIDE_PLAYER_RESPAWNING = true

CITADEL_ENDING = false


-- Player spawns
function tf2gmhl2PlayerSpawn( ply )

	if ( !game.SinglePlayer() && CITADEL_ENDING ) then
	
		ply:RemoveAllItems()
		ply:Freeze( true )
	
	end

	if ( !game.SinglePlayer() && IsValid( PLAYER_VIEWCONTROL ) && ( PLAYER_VIEWCONTROL:GetClass() == "point_viewcontrol" ) ) then
	
		ply:SetViewEntity( PLAYER_VIEWCONTROL )
		ply:SetNoDraw( true )
		ply:DrawWorldModel( false )
		ply:Freeze( true )
	
		timer.Simple( 0.01, function() if ( IsValid( ply ) ) then ply:SetMoveType( MOVETYPE_NOCLIP ); end; end )
	
	end

	if ( game.SinglePlayer() && IsValid( ents.FindByName( "pod" )[ 1 ] ) ) then
	
		ply:EnterVehicle( ents.FindByName( "pod" )[ 1 ] )
	
	end

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Initialize entities
function tf2gmhl2MapEdit()

	game.SetGlobalState( "super_phys_gun", GLOBAL_ON )

	SetGlobalBool( "SUPER_GRAVITY_GUN", true )

	game.ConsoleCommand( "physcannon_tracelength 850\n" )
	game.ConsoleCommand( "physcannon_maxmass 850\n" )
	game.ConsoleCommand( "physcannon_pullforce 8000\n" )

	if ( !game.SinglePlayer() ) then
	
		ents.FindByName( "citadel_template_combinewall_start1" )[ 1 ]:Remove()
	
		local viewcontrol = ents.Create( "point_viewcontrol" )
		viewcontrol:SetName( "pod_viewcontrol" )
		viewcontrol:SetPos( ents.FindByName( "pod" )[ 1 ]:GetPos() )
		viewcontrol:SetKeyValue( "spawnflags", "12" )
		viewcontrol:Spawn()
		viewcontrol:Activate()
		viewcontrol:SetParent( ents.FindByName( "pod" )[ 1 ] )
		viewcontrol:Fire( "SetParentAttachment", "vehicle_driver_eyes" )
		viewcontrol:Fire( "Enable", "", 0.1 )
	
	end

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input, activator, caller, value )

	if ( !game.SinglePlayer() && ( ent:GetClass() == "point_viewcontrol" ) ) then
	
		if ( ent:GetName() == "blackout_viewcontroller" ) then
		
			return true
		
		end
	
		if ( string.lower( input ) == "enable" ) then
		
			PLAYER_VIEWCONTROL = ent
		
			for _, ply in ipairs( player.GetAll() ) do
			
				ply:SetViewEntity( ent )
				ply:SetNoDraw( true )
				ply:DrawWorldModel( false )
				ply:Freeze( true )
			
				timer.Simple( 0.01, function() if ( IsValid( ply ) ) then ply:SetMoveType( MOVETYPE_NOCLIP ); end; end )
			
			end
		
			if ( !ent.doubleEnabled ) then
			
				ent.doubleEnabled = true
				ent:Fire( "Enable" )
			
			end
		
		elseif ( string.lower( input ) == "disable" ) then
		
			PLAYER_VIEWCONTROL = nil
		
			for _, ply in ipairs( player.GetAll() ) do
			
				ply:SetViewEntity( ply )
				ply:SetNoDraw( false )
				ply:DrawWorldModel( true )
				ply:Freeze( false )
				ply:UnLock()
			
				timer.Simple( 0.01, function() if ( IsValid( ply ) ) then ply:SetMoveType( MOVETYPE_WALK ); end; end )
			
			end
		
			return true
		
		end
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "logic_fade_view" ) && ( string.lower( input ) == "trigger" ) ) then
	
		if ( timer.Exists( "tf2gmhl2UpdatePlayerPosition" ) ) then timer.Destroy( "tf2gmhl2UpdatePlayerPosition" ); end
	
		GAMEMODE:CreateSpawnPoint( Vector( -1875, 887, 591 ), 265.5 )
	
		PLAYER_VIEWCONTROL:Fire( "Disable" )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "clip_door_BreenElevator" ) && ( string.lower( input ) == "enable" ) ) then
	
		for _, ply in ipairs( player.GetAll() ) do
		
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( -1968, 0, 600 ) )
			ply:SetEyeAngles( Angle( 0, -90, 0 ) )
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( -1860, 0, 1380 ), 0 )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "lcs_al_doworst" ) && ( string.lower( input ) == "start" ) ) then
	
		for _, ply in ipairs( player.GetAll() ) do
		
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( -1056, 464, 1340 ) )
			ply:SetEyeAngles( Angle( 0, -90, 0 ) )
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( -1056, 300, -200 ), -90 )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "citadel_scene_al_rift1" ) && ( string.lower( input ) == "start" ) ) then
	
		for _, ply in ipairs( player.GetAll() ) do
		
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( -640, -400, 1320 ) )
			ply:SetEyeAngles( Angle( 0, 35, 0 ) )
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( -640, -400, 1320 ), 35 )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "relay_portalfinalexplodeshake" ) && ( string.lower( input ) == "trigger" ) ) then
	
		SUPER_GRAVITY_GUN = false
	
		game.ConsoleCommand( "physcannon_tracelength 250\n" )
		game.ConsoleCommand( "physcannon_maxmass 250\n" )
		game.ConsoleCommand( "physcannon_pullforce 4000\n" )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "relay_breenwins" ) && ( string.lower( input ) == "trigger" ) ) then
	
		hook.Call( "RestartMap", GAMEMODE )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "teleport_player_gman_1" ) && ( string.lower( input ) == "teleport" ) ) then
	
		CITADEL_ENDING = true
	
		for _, ply in ipairs( player.GetAll() ) do
		
			ply:RemoveAllItems()
			ply:SetNoDraw( true )
			ply:SetPos( ent:GetPos() )
			ply:Freeze( true )
		
		end
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "view_gman_end_1" ) && ( string.lower( input ) == "enable" ) ) then
	
		hook.Call( "NextMap", GAMEMODE )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetClass() == "player_speedmod" ) && ( string.lower( input ) == "modifyspeed" ) ) then
	
		for _, ply in ipairs( player.GetAll() ) do
		
			ply:SetLaggedMovementValue( tonumber( value ) )
		
		end
	
		return true
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )


-- Every frame or tick
function tf2gmhl2Think()

	if ( GetGlobalBool( "SUPER_GRAVITY_GUN" ) ) then
	
		for _, ent in ipairs( ents.FindByClass( "weapon_physcannon" ) ) do
		
			if ( IsValid( ent ) && ent:IsWeapon() ) then
			
				if ( ent:GetSkin() != 1 ) then ent:SetSkin( 1 ); end
			
			end
		
		end
	
		for _, ent in ipairs( ents.FindByClass( "weapon_*" ) ) do
		
			if ( IsValid( ent ) && ent:IsWeapon() && ( ent:GetClass() != "weapon_physcannon" ) && ( !IsValid( ent:GetOwner() ) || ( IsValid( ent:GetOwner() ) && ent:GetOwner():IsPlayer() ) ) ) then
			
				ent:Remove()
			
			end
		
		end
	
	end

end
hook.Add( "Think", "tf2gmhl2Think", tf2gmhl2Think )


if ( !game.SinglePlayer() ) then

	-- Update player position to the vehicle
	function tf2gmhl2UpdatePlayerPosition()
	
		for _, ply in ipairs( team.GetPlayers( TEAM_ALIVE ) ) do
		
			if ( IsValid( ply ) && IsValid( ents.FindByName( "pod" )[ 1 ] ) && ply:Alive() ) then
			
				ply:SetPos( ents.FindByName( "pod" )[ 1 ]:GetPos() )
			
			end
		
		end
	
	end
	timer.Create( "tf2gmhl2UpdatePlayerPosition", 0.1, 0, tf2gmhl2UpdatePlayerPosition )

end
