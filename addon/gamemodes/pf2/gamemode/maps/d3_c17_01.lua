NEXT_MAP = "d3_c17_02"


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
function tf2gmhl2AcceptInput( ent, input, activator, caller, value )

	if ( !game.SinglePlayer() && ( ent:GetName() == "door_klab01" ) && ( string.lower( input ) == "setanimation" ) && ( string.lower( value ) == "close" ) ) then
	
		return true
	
	end

	if ( !game.SinglePlayer() && ( ( ent:GetName() == "doors_elevator_1" ) || ( ent:GetName() == "doors_elevator_2" ) ) && ( string.lower( input ) == "close" ) ) then
	
		return true
	
	end

	if ( !game.SinglePlayer() && ( ( ent:GetName() == "pclip_TPdoor" ) || ( ent:GetName() == "pclip_exitdoor" ) ) && ( string.lower( input ) == "enable" ) ) then
	
		return true
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
