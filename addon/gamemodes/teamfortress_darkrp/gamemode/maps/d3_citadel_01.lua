NEXT_MAP = "d3_citadel_02"

NEXT_MAP_PERCENT = 1

CITADEL_VEHICLE_ENTITY = nil


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
		ply:SetNoDraw( true )
		ply:DrawWorldModel( false )
		ply:Lock()
	
		ply:SetCollisionGroup( COLLISION_GROUP_WORLD )
		ply:CollisionRulesChanged()
	
	end

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Initialize entities
function tf2gmhl2MapEdit()

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

	if ( !game.SinglePlayer() && ( ent:GetName() == "zapper_fade" ) && ( string.lower( input ) == "fade" ) ) then
	
		hook.Call( "RestartMap", GAMEMODE )
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )


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
