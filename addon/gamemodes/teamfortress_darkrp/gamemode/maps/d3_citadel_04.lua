NEXT_MAP = "d3_citadel_05"

TRIGGER_DELAYMAPLOAD = { Vector( -1281, -8577, 6015 ), Vector( -1151, -7743, 6200 ) }

CITADEL_ELEVATOR_CHECKPOINT1 = false
CITADEL_ELEVATOR_CHECKPOINT2 = true


-- Player spawns
function tf2gmhl2PlayerSpawn( ply )

	ply:Give( "weapon_physcannon" )

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

	if ( !game.SinglePlayer() && !CITADEL_ELEVATOR_CHECKPOINT1 && ( ent:GetName() == "citadel_brush_elevcage1_1" ) && ( string.lower( input ) == "enable" ) ) then
	
		CITADEL_ELEVATOR_CHECKPOINT1 = true
		CITADEL_ELEVATOR_CHECKPOINT2 = false
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( 256, 832, 2320 ) )
			ply:SetEyeAngles( Angle( 0, -90, 0 ) )
		
		end
	
	end

	if ( !game.SinglePlayer() && !CITADEL_ELEVATOR_CHECKPOINT2 && ( ent:GetName() == "citadel_path_lift01_1" ) && ( string.lower( input ) == "inpass" ) ) then
	
		CITADEL_ELEVATOR_CHECKPOINT2 = true
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( 256, 832, 6420 ) )
			ply:SetEyeAngles( Angle( 0, -90, 0 ) )
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( 256, 832, 6420 ), -90 )
	
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
