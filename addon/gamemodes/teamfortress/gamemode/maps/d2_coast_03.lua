ALLOWED_VEHICLE = "Jeep"

NEXT_MAP = "d2_coast_04"


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

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Initialize entities
function tf2gmhl2MapEdit()

	game.SetGlobalState( "no_seagulls_on_jeep", GLOBAL_ON )

	ents.FindByName( "player_spawn_items_maker" )[ 1 ]:Remove()
	ents.FindByName( "jeep_filter" )[ 1 ]:Fire( "AddOutput", "filterclass prop_vehicle_jeep_old" )

	if ( !game.SinglePlayer() ) then
	
		ents.FindByName( "antlion_spawner" )[ 1 ]:Fire( "AddOutput", "spawntarget jeep" )
	
	end

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_ingreeterrange" ) && ( string.lower( input ) == "enable" ) ) then
	
		if ( IsValid( ents.FindByName( "lcs_odessaGreeting" )[ 1 ] ) ) then ents.FindByName( "lcs_odessaGreeting" )[ 1 ]:Fire( "Kill" ) end
		if ( IsValid( ents.FindByName( "aisc_ingreeterrange" )[ 1 ] ) ) then ents.FindByName( "aisc_ingreeterrange" )[ 1 ]:Fire( "Kill" ) end
		if ( IsValid( ents.FindByName( "lcs_odessa_lead" )[ 1 ] ) ) then ents.FindByName( "lcs_odessa_lead" )[ 1 ]:Fire( "Start", "", 0.1 ) end
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_pre_ingreeterrange" ) && ( string.lower( input ) == "enable" ) ) then
	
		if ( IsValid( ents.FindByName( "ss_gordongreet" )[ 1 ] ) ) then ents.FindByName( "ss_gordongreet" )[ 1 ]:Fire( "Kill" ) end
		if ( IsValid( ents.FindByName( "aisc_pre_ingreeterrange" )[ 1 ] ) ) then ents.FindByName( "aisc_pre_ingreeterrange" )[ 1 ]:Fire( "Kill" ) end
		if ( IsValid( ents.FindByName( "lcs_odessaGreeting" )[ 1 ] ) ) then ents.FindByName( "lcs_odessaGreeting" )[ 1 ]:Fire( "Start" ) end
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_gordontakesrpg" ) && ( string.lower( input ) == "enable" ) ) then
	
		for _, ent in pairs( ents.FindByName( "citizen_a_precmbt_*" ) ) do
		
			ent:Fire( "Kill" )
		
		end
		if ( IsValid( ents.FindByName( "player_leaves_house" )[ 1 ] ) ) then ents.FindByName( "player_leaves_house" )[ 1 ]:Fire( "Enable" ) end
		if ( IsValid( ents.FindByName( "rocketman_scene_0" )[ 1 ] ) ) then ents.FindByName( "rocketman_scene_0" )[ 1 ]:Fire( "Resume" ) end
		if ( IsValid( ents.FindByName( "spawner_rpg" )[ 1 ] ) ) then ents.FindByName( "spawner_rpg" )[ 1 ]:Fire( "ForceSpawn" ) end
		if ( IsValid( ents.FindByName( "pd_rpg" )[ 1 ] ) ) then ents.FindByName( "pd_rpg" )[ 1 ]:Fire( "Kill" ) end
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_odessapostgunship" ) && ( string.lower( input ) == "enable" ) ) then
	
		if ( IsValid( ents.FindByName( "aisc_odessapostgunshipignored" )[ 1 ] ) ) then ents.FindByName( "aisc_odessapostgunshipignored" )[ 1 ]:Fire( "Enable" ) end
		if ( IsValid( ents.FindByName( "tm_gatekeeper" )[ 1 ] ) ) then ents.FindByName( "tm_gatekeeper" )[ 1 ]:Fire( "ForceSpawn" ) end
		if ( IsValid( ents.FindByName( "aisc_odessapostgunship" )[ 1 ] ) ) then ents.FindByName( "aisc_odessapostgunship" )[ 1 ]:Fire( "Kill" ) end
		if ( IsValid( ents.FindByName( "rocketman_gunship1" )[ 1 ] ) ) then ents.FindByName( "rocketman_gunship1" )[ 1 ]:Fire( "Resume" ) end
		if ( IsValid( ents.FindByName( "ss_odessa_radio" )[ 1 ] ) ) then ents.FindByName( "ss_odessa_radio" )[ 1 ]:Fire( "CancelSequence" ) end
		if ( IsValid( ents.FindByName( "post_gunship_jeep_relay" )[ 1 ] ) ) then ents.FindByName( "post_gunship_jeep_relay" )[ 1 ]:Fire( "Kill" ) end
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "aisc_odessapostgunshipignored" ) && ( string.lower( input ) == "enable" ) ) then
	
		if ( IsValid( ents.FindByName( "lr_odessa_goodbye" )[ 1 ] ) ) then ents.FindByName( "lr_odessa_goodbye" )[ 1 ]:Fire( "Trigger", "", 1 ) end
		if ( IsValid( ents.FindByName( "odessa_goodbye" )[ 1 ] ) ) then ents.FindByName( "odessa_goodbye" )[ 1 ]:Fire( "Cancel" ) end
		if ( IsValid( ents.FindByName( "odessa_getyourcar" )[ 1 ] ) ) then ents.FindByName( "odessa_getyourcar" )[ 1 ]:Fire( "Cancel" ) end
		if ( IsValid( ents.FindByName( "lr_odessa_getyourcar" )[ 1 ] ) ) then ents.FindByName( "lr_odessa_getyourcar" )[ 1 ]:Fire( "Trigger", "", 0.5 ) end
		if ( IsValid( ents.FindByName( "lr_vort_goodbye" )[ 1 ] ) ) then ents.FindByName( "lr_vort_goodbye" )[ 1 ]:Fire( "Trigger", "", 1.5 ) end
		if ( IsValid( ents.FindByName( "vort_goodbye" )[ 1 ] ) ) then ents.FindByName( "vort_goodbye" )[ 1 ]:Fire( "Cancel" ) end
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "basement_gordon_first_entered" ) && ( string.lower( input ) == "trigger" ) ) then
	
		ALLOWED_VEHICLE = nil
		PrintMessage( HUD_PRINTTALK, "Vehicle spawning has been disabled." )
	
		for _, ply in pairs( player.GetAll() ) do
		
			if ( !IsValid( ply.vehicle ) && !ply:InVehicle() ) then
			
				ply:SetVelocity( Vector( 0, 0, 0 ) )
				ply:SetPos( Vector( 8755, 4055, 257 ) )
				ply:SetEyeAngles( Angle( 0, 0, 0 ) )
			
			end
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( 8755, 4055, 257 ), 0 )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "spawner_rpg" ) && ( string.lower( input ) == "forcespawn" ) ) then
	
		for _, ply in pairs( player.GetAll() ) do
		
			ply:Give( "weapon_rpg" )
		
		end
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "lr_odessa_goodbye" ) && ( string.lower( input ) == "trigger" ) ) then
	
		ALLOWED_VEHICLE = "Jeep"
		PrintMessage( HUD_PRINTTALK, "You're now allowed to spawn the Jeep (F3)." )
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
