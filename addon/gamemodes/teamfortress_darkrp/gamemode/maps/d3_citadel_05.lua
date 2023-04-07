NEXT_MAP = "d3_breen_01"

NEXT_MAP_PERCENT = 1

CITADEL_VEHICLE_ENTITY = nil


-- Player spawns
function tf2gmhl2PlayerSpawn( ply )

	ply:Give( "weapon_physcannon" )

	if ( !game.SinglePlayer() && IsValid( PLAYER_VIEWCONTROL ) && ( PLAYER_VIEWCONTROL:GetClass() == "point_viewcontrol" ) ) then
	
		ply:SetViewEntity( PLAYER_VIEWCONTROL )
		ply:SetNoDraw( true )
		ply:DrawWorldModel( false )
		ply:Lock()
	
		ply:SetCollisionGroup( COLLISION_GROUP_WORLD )
		ply:CollisionRulesChanged()
	
	end

	timer.Simple( 0.1, function() if ( IsValid( ply ) ) then ply:SetNoTarget( true ); end; end )

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Initialize entities
function tf2gmhl2MapEdit()

	game.SetGlobalState( "super_phys_gun", GLOBAL_ON )

	SetGlobalBool( "SUPER_GRAVITY_GUN", true )

	game.ConsoleCommand( "physcannon_tracelength 850\n" )
	game.ConsoleCommand( "physcannon_maxmass 850\n" )
	game.ConsoleCommand( "physcannon_pullforce 8000\n" )

	ents.FindByName( "global_newgame_template_ammo" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_base_items" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_local_items" )[ 1 ]:Remove()

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( !game.SinglePlayer() && ( ent:GetClass() == "point_viewcontrol" ) ) then
	
		if ( string.lower( input ) == "enable" ) then
		
			PLAYER_VIEWCONTROL = ent
		
			for _, ply in ipairs( player.GetAll() ) do
			
				ply:SetViewEntity( ent )
				ply:SetNoDraw( true )
				ply:DrawWorldModel( false )
				ply:Lock()
			
				ply:SetCollisionGroup( COLLISION_GROUP_WORLD )
				ply:CollisionRulesChanged()
			
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
				ply:UnLock()
			
				ply:SetCollisionGroup( COLLISION_GROUP_PLAYER )
				ply:CollisionRulesChanged()
			
			end
		
			return true
		
		end
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )


-- Every frame or tick
function tf2gmhl2Think()

	if ( GetGlobalBool( "SUPER_GRAVITY_GUN" ) ) then
	
		for _, ent in pairs( ents.FindByClass( "weapon_physcannon" ) ) do
		
			if ( IsValid( ent ) && ent:IsWeapon() ) then
			
				if ( ent:GetSkin() != 1 ) then ent:SetSkin( 1 ); end
			
			end
		
		end
	
		for _, ent in pairs( ents.FindByClass( "weapon_*" ) ) do
		
			if ( IsValid( ent ) && ent:IsWeapon() && ( ent:GetClass() != "weapon_physcannon" ) && ( !IsValid( ent:GetOwner() ) || ( IsValid( ent:GetOwner() ) && ent:GetOwner():IsPlayer() ) ) ) then
			
				ent:Remove()
			
			end
		
		end
	
	end

end
hook.Add( "Think", "tf2gmhl2Think", tf2gmhl2Think )


if ( !game.SinglePlayer() ) then

	-- Player entered vehicle
	function tf2gmhl2PlayerEnteredVehicle( ply, vehicle )
	
		if ( vehicle:GetClass() == "prop_vehicle_prisoner_pod" ) then
		
			CITADEL_VEHICLE_ENTITY = vehicle
		
			local viewcontrol = ents.Create( "point_viewcontrol" )
			viewcontrol:SetName( "pod_player_viewcontrol" )
			viewcontrol:SetPos( CITADEL_VEHICLE_ENTITY:GetPos() )
			viewcontrol:SetKeyValue( "spawnflags", "12" )
			viewcontrol:Spawn()
			viewcontrol:Activate()
			viewcontrol:SetParent( CITADEL_VEHICLE_ENTITY )
			viewcontrol:Fire( "SetParentAttachment", "vehicle_driver_eyes" )
			viewcontrol:Fire( "Enable", "", 0.1 )
		
			timer.Create( "tf2gmhl2UpdatePlayerPosition", 0.1, 0, tf2gmhl2UpdatePlayerPosition )
		
		end
	
	end
	hook.Add( "PlayerEnteredVehicle", "tf2gmhl2PlayerEnteredVehicle", tf2gmhl2PlayerEnteredVehicle )


	-- Update player position to the vehicle
	function tf2gmhl2UpdatePlayerPosition()
	
		for _, ply in ipairs( team.GetPlayers( TEAM_ALIVE ) ) do
		
			if ( IsValid( ply ) && ply:Alive() && IsValid( CITADEL_VEHICLE_ENTITY ) ) then
			
				ply:SetPos( CITADEL_VEHICLE_ENTITY:GetPos() )
			
			end
		
		end
	
	end

end
