INFO_PLAYER_SPAWN = { Vector( 3328, 1505, 1537 ), -90 }

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

	ents.FindByName( "jeep_filter" )[ 1 ]:Fire( "AddOutput", "filterclass prop_vehicle_jeep_old" )

	local propblock = ents.Create( "prop_physics" )
	propblock:SetName( "prop_block" )
	propblock:SetPos( Vector( 3328, 1575, 1600 ) )
	propblock:SetModel( "models/props_wasteland/rockcliff01b.mdl" )
	propblock:DrawShadow( false )
	propblock:Spawn()
	propblock:Activate()
	propblock:GetPhysicsObject():EnableMotion( false )

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( !game.SinglePlayer() && ( ent:GetName() == "button_press" ) && ( string.lower( input ) == "trigger" ) ) then
	
		ents.FindByName( "prop_block" )[ 1 ]:Remove()
	
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( 2991, -6946, 1932 ) )
			ply:SetEyeAngles( Angle( 0, 0, 0 ) )
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( 2991, -6946, 1932 ), 0 )
	
		if ( !file.Exists( "half-life_2_campaign/d2_coast_08.txt", "DATA" ) ) then
		
			file.Write( "half-life_2_campaign/d2_coast_08.txt", "We have been to d2_coast_08 and pressed the button." )
		
		end
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
