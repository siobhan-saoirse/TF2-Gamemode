ALLOWED_VEHICLE = "Jeep"

NEXT_MAP = "d2_coast_10"

if ( file.Exists( "half-life_2_campaign/d2_coast_08.txt", "DATA" ) ) then

	file.Delete( "half-life_2_campaign/d2_coast_08.txt" )

end

COAST_SET_ALLOWED_VEHICLE = true


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

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Initialize entities
function tf2gmhl2MapEdit()

	game.SetGlobalState( "no_seagulls_on_jeep", GLOBAL_ON )

	ents.FindByName( "global_newgame_template_ammo" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_base_items" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_local_items" )[ 1 ]:Remove()
	ents.FindByName( "wheel_filter" )[ 1 ]:Fire( "AddOutput", "filterclass prop_vehicle_jeep_old" )

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( !game.SinglePlayer() && ( ent:GetName() == "spawn_dropship" ) && ( string.lower( input ) == "trigger" ) ) then
	
		ALLOWED_VEHICLE = nil
		PrintMessage( HUD_PRINTTALK, "Vehicle spawning has been disabled." )
	
		for _, ply in pairs( player.GetAll() ) do
		
			if ( !IsValid( ply.vehicle ) ) then
			
				ply:SetVelocity( Vector( 0, 0, 0 ) )
				ply:SetPos( Vector( 11128, 8820, -187 ) )
				ply:SetEyeAngles( Angle( 0, -175, 0 ) )
			
			end
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( 11128, 8820, -187 ), -175 )
	
	end

	if ( !game.SinglePlayer() && COAST_SET_ALLOWED_VEHICLE && ( ent:GetName() == "gate_door" ) && ( string.lower( input ) == "open" ) ) then
	
		COAST_SET_ALLOWED_VEHICLE = false
		ALLOWED_VEHICLE = "Jeep"
		PrintMessage( HUD_PRINTTALK, "You're now allowed to spawn the Jeep (F3)." )
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
