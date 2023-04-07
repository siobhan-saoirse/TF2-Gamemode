NEXT_MAP = "d3_c17_01"

TRIGGER_DELAYMAPLOAD = { Vector( -954, -1049, 912 ), Vector( -868, -965, 995 ) }

NEXT_MAP_PERCENT = 1

PRISON_PREVENT_DOORS = false


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

	if ( !game.SinglePlayer() ) then
	
		ents.FindByName( "PClip_sec_tp_door_1" )[ 1 ]:Remove()
		ents.FindByName( "combine_door_2" )[ 1 ]:Remove()
	
	end

	timer.Create( "tf2gmhl2TurretRelationship", 1, 0, function() if ( IsValid( ents.FindByName( "relationship_turret_vs_player_like" )[ 1 ] ) ) then ents.FindByName( "relationship_turret_vs_player_like" )[ 1 ]:Fire( "ApplyRelationship" ) end end )

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input, activator, caller, value )

	if ( !game.SinglePlayer() && !PRISON_PREVENT_DOORS && ( ent:GetName() == "brush_bigdoor_PClip_1" ) && ( string.lower( input ) == "enable" ) ) then
	
		PRISON_PREVENT_DOORS = true
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( -914, 943, 961 ) )
			ply:SetEyeAngles( Angle( 0, -90, 0 ) )
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( -914, 943, 961 ), -90 )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "PClip_teleport_shield_final" ) && ( string.lower( input ) == "enable" ) ) then
	
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( 128, 7, 1066 ) )
			ply:SetEyeAngles( Angle( 0, 90, 0 ) )
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( 128, 7, 1550 ), 90 )
	
	end

	if ( !game.SinglePlayer() && PRISON_PREVENT_DOORS && ( ( ent:GetName() == "sec_room_door_1" ) || ( ent:GetName() == "sec_tp_door_1" ) ) && ( string.lower( input ) == "close" ) ) then
	
		return true
	
	end

	if ( !game.SinglePlayer() && PRISON_PREVENT_DOORS && ( ent:GetName() == "combine_door_1" ) && ( string.lower( input ) == "setanimation" ) && ( ( string.lower( value ) == "close" ) || ( string.lower( value ) == "idle_closed" ) ) ) then
	
		return true
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
