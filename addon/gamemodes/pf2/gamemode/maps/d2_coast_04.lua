ALLOWED_VEHICLE = "Jeep"

NEXT_MAP = "d2_coast_05"


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

	ents.FindByName( "global_newgame_template_ammo" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_base_items" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_local_items" )[ 1 ]:Remove()
	ents.FindByName( "jeep_filter" )[ 1 ]:Fire( "AddOutput", "filterclass prop_vehicle_jeep_old" )
	ents.FindByName( "push_car_superjump_01" )[ 1 ]:Fire( "Enable" )

	if ( !game.SinglePlayer() ) then
	
		ents.FindByName( "antlion_spawner" )[ 1 ]:Fire( "AddOutput", "spawntarget jeep" )
	
	end

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( ( ent:GetName() == "push_car_superjump_01" ) && ( string.lower( input ) == "disable" ) ) then
	
		return true
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
