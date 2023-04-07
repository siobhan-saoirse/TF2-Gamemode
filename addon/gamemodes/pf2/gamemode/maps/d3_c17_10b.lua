INFO_PLAYER_SPAWN = { Vector( 2684, -1865, 260 ), 90 }

NEXT_MAP = "d3_c17_11"


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
	
		ents.FindByName( "lobby_combinedoor_portalbrush" )[ 1 ]:Remove()
	
	end

	local barney = ents.Create( "npc_barney" )
	barney:SetPos( Vector( 2696, -1944, 257 ) )
	barney:SetAngles( Angle( 0, 90, 0 ) )
	barney:SetName( "barney" )
	barney:SetKeyValue( "additionalequipment", "weapon_ar2" )
	barney:SetKeyValue( "spawnflags", "0" )
	barney:SetKeyValue( "squadname", "player_squad" )
	barney:Spawn()
	barney:Activate()

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input, activator, caller, value )

	if ( !game.SinglePlayer() && ( ent:GetName() == "firstdropship_lcs1" ) && ( string.lower( input ) == "start" ) ) then
	
		ents.FindByName( "barney" )[ 1 ]:SetLastPosition( Vector( 2466.740234, -466.801117, 256.03125 ) )
		ents.FindByName( "barney" )[ 1 ]:SetSchedule( SCHED_FORCED_GO )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "ctrlrm_east_field_off_relay" ) && ( string.lower( input ) == "trigger" ) ) then
	
		ents.FindByName( "barney" )[ 1 ]:SetLastPosition( Vector( 3429.184814, -509.042206, 512.03125 ) )
		ents.FindByName( "barney" )[ 1 ]:SetSchedule( SCHED_FORCED_GO_RUN )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "barney_laseroom_lcs" ) && ( string.lower( input ) == "start" ) ) then
	
		ents.FindByName( "barney" )[ 1 ]:SetLastPosition( Vector( 3168.077881, -1477.226807, 512.03125 ) )
		ents.FindByName( "barney" )[ 1 ]:SetSchedule( SCHED_FORCED_GO_RUN )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "n_room_trigger_relay" ) && ( string.lower( input ) == "trigger" ) ) then
	
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( 3140, 830, 513 ) )
			ply:SetEyeAngles( Angle( 0, -90, 0 ) )
		
		end
		GAMEMODE:CreateSpawnPoint( Vector( 3140, 830, 513 ), -90 )
	
		ents.FindByName( "barney" )[ 1 ]:SetPos( Vector( 3213, 1099, 513 ) )
		ents.FindByName( "barney" )[ 1 ]:SetLastPosition( Vector( 3416.997314, 917.139099, 512.03125 ) )
		ents.FindByName( "barney" )[ 1 ]:SetSchedule( SCHED_FORCED_GO_RUN )
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "s_room_detected_relay" ) && ( string.lower( input ) == "trigger" ) ) then
	
		timer.Simple( 20, function()
		
			for _, ent in pairs( ents.FindByName( "s_room_doors" ) ) do
			
				if ( IsValid( ent ) ) then
				
					ent:Fire( "Open" )
				
				end
			
			end
		
			for _, ent in pairs( ents.FindByName( "s_room_turret_*" ) ) do
			
				if ( IsValid( ent ) ) then
				
					ent:Fire( "Disable" )
				
				end
			
			end
		
			for _, ent in pairs( ents.FindByName( "s_laser*" ) ) do
			
				if ( IsValid( ent ) && ( ent:GetClass() == "env_beam" ) ) then
				
					ent:Fire( "TurnOn" )
				
				end
			
			end
		
			ents.FindByName( "s_room_nodelink_2" )[ 1 ]:Fire( "TurnOn" )
			ents.FindByName( "s_room_panelswitch" )[ 1 ]:Fire( "Unlock" )
			ents.FindByName( "laser_on_sound" )[ 1 ]:Fire( "PlaySound" )
		
		end )
	
	end

	if ( ( ent:GetName() == "lcs_barney_h4x_pows" ) && ( string.lower( input ) == "start" ) ) then
	
		for _, ent in pairs( ents.FindByName( "citizen_pod*" ) ) do
		
			if ( IsValid( ent ) && ent:IsNPC() ) then
			
				ent:Fire( "GiveWeapon", "weapon_ar2" )
			
			end
		
		end
	
	end

	if ( !game.SinglePlayer() && ( ( ent:GetName() == "lobby_combinedoor" ) || ( ent:GetName() == "exit_combinedoor" ) ) && ( string.lower( input ) == "setanimation" ) && ( ( string.lower( value ) == "close" ) || ( string.lower( value ) == "idle_closed" ) ) ) then
	
		return true
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
