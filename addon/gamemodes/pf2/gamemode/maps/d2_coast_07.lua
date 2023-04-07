ALLOWED_VEHICLE = "Jeep"

if ( file.Exists( "half-life_2_campaign/d2_coast_08.txt", "DATA" ) ) then

	INFO_PLAYER_SPAWN = { Vector( 3151, 5233, 1552 ), 180 }
	NEXT_MAP = "d2_coast_09"

else

	INFO_PLAYER_SPAWN = { Vector( -6695, 6144, 1630 ), 0 }
	NEXT_MAP = "d2_coast_08"

end


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

	if ( file.Exists( "half-life_2_campaign/d2_coast_08.txt", "DATA" ) ) then
	
		for _, ent in pairs( ents.FindByName( "bridge_field_02" ) ) do
		
			ent:Remove()
		
		end
	
		for _, ent in pairs( ents.FindByName( "forcefield*" ) ) do
		
			ent:Remove()
		
		end
	
		for _, ent in pairs( ents.FindByName( "dropship*" ) ) do
		
			ent:Remove()
		
		end
	
		for _, ent in pairs( ents.FindByName( "gunship*" ) ) do
		
			ent:Remove()
		
		end
	
		for _, ent in pairs( ents.FindByName( "assault*" ) ) do
		
			ent:Remove()
		
		end
	
		for _, ent in pairs( ents.FindByName( "halt*" ) ) do
		
			ent:Remove()
		
		end
	
		ents.FindByName( "field_trigger" )[ 1 ]:Remove()
	
	end

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )
