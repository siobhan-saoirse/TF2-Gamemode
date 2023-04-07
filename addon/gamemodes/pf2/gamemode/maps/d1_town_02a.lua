NEXT_MAP = "d1_town_04"

if ( file.Exists( "half-life_2_campaign/d1_town_03.txt", "DATA" ) ) then

	file.Delete( "half-life_2_campaign/d1_town_03.txt" )

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

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Initialize entities
function tf2gmhl2MapEdit()

	ents.FindByName( "startobjects_template" )[ 1 ]:Remove()

	local monk = ents.Create( "npc_monk" )
	monk:SetPos( Vector( -5221, 2034, -3240 ) )
	monk:SetAngles( Angle( 0, 90, 0 ) )
	monk:SetName( "monk" )
	monk:SetKeyValue( "additionalequipment", "weapon_annabelle" )
	monk:SetKeyValue( "spawnflags", "4" )
	monk:Spawn()
	monk:Activate()

	if ( !game.SinglePlayer() ) then
	
		ents.FindByName( "graveyard_exit_momentary_wheel" )[ 1 ]:Fire( "Lock" )
	
	end

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( !game.SinglePlayer() && ( ent:GetName() == "graveyard_exit_door" ) && ( string.lower( input ) == "setposition" ) ) then
	
		ent:Fire( "Open" )
		return true
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
