ALLOWED_VEHICLE = "Jeep"

INFO_PLAYER_SPAWN = { Vector( 7824, -12136, 1856 ), 180 }

NEXT_MAP = "d2_coast_07"


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

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Initialize entities
function tf2gmhl2MapEdit()

	game.SetGlobalState( "no_seagulls_on_jeep", GLOBAL_ON )

	ents.FindByName( "player_spawn_items_maker" )[ 1 ]:Remove()
	ents.FindByName( "jeep_filter" )[ 1 ]:Fire( "AddOutput", "filterclass prop_vehicle_jeep_old" )

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

    if ( !game.SinglePlayer() && ( ent:GetName() == "gas_station_patrol_spawner" ) && ( string.lower( input ) == "forcespawn" ) ) then
	
		ALLOWED_VEHICLE = nil
        PrintMessage( HUD_PRINTTALK, "Vehicle spawning has been disabled." )
    
		for _, ply in pairs( player.GetAll() ) do
		
			if ( !IsValid( ply.vehicle ) && !ply:InVehicle() ) then
			
				ply:SetVelocity( Vector( 0, 0, 0 ) )
				ply:SetPos( Vector( -4727, -4647, 1128 ) )
				ply:SetEyeAngles( Angle( 0, 90, 0 ) )
			
			end
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( -4727, -4647, 1128 ), 90 )
	
	end

    if ( !game.SinglePlayer() && ( ent:GetName() == "logic_gate_shutdown" ) && ( string.lower( input ) == "trigger" ) ) then
	
		ALLOWED_VEHICLE = "Jeep"
		PrintMessage( HUD_PRINTTALK, "You're now allowed to spawn the Jeep (F3)." )
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
