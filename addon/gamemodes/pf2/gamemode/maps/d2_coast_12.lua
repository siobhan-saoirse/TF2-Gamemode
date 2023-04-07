INFO_PLAYER_SPAWN = { Vector( 4830, -12136, 300 ), 90 }

NEXT_MAP = "d2_prison_01"


-- Player initial spawn
function tf2gmhl2PlayerInitialSpawn( ply )

	ply:SendLua( "table.insert( FRIENDLY_NPCS, \"npc_antlion\" )" )

end
hook.Add( "PlayerInitialSpawn", "tf2gmhl2PlayerInitialSpawn", tf2gmhl2PlayerInitialSpawn )


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

	game.SetGlobalState( "antlion_allied", GLOBAL_ON )

	ents.FindByName( "player_spawn_items_maker" )[ 1 ]:Remove()

	table.insert( FRIENDLY_NPCS, "npc_antlion" )

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )
