NEXT_MAP = "d3_c17_13"


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

	ents.FindByName( "player_spawn_items_maker" )[ 1 ]:Remove()

	if ( !game.SinglePlayer() ) then
	
		ents.FindByName( "entry_ceiling_breakable_1" )[ 1 ]:Remove()
		ents.FindByName( "entry_ceiling_debris_1" )[ 1 ]:Remove()
		ents.FindByName( "entry_ceiling_debris_clip_1" )[ 1 ]:Remove()
		ents.FindByName( "entry_ceiling_exp_1" )[ 1 ]:Remove()
		ents.FindByName( "entry_ceiling_exp_1" )[ 2 ]:Remove()
	
	end

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )
