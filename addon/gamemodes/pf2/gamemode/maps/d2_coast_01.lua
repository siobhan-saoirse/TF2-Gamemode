NEXT_MAP = "d2_coast_03"


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

	ents.FindByName( "global_newgame_template_ammo" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_base_items" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_local_items" )[ 1 ]:Remove()

	ents.FindByName( "jeep" )[ 1 ]:Fire( "EnableGun", "1" )
	ents.FindByName( "jeep" )[ 1 ]:SetBodygroup( 1, 1 )

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( !game.SinglePlayer() && ( ent:GetName() == "logic_startcraneseq" ) && ( string.lower( input ) == "trigger" ) ) then
	
		ALLOWED_VEHICLE = "Jeep"
		PrintMessage( HUD_PRINTTALK, "You're now allowed to spawn the Jeep (F3)." )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "push_car_superjump_01" ) && ( string.lower( input ) == "disable" ) ) then
	
		return true
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
