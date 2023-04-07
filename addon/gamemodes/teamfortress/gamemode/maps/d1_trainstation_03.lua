NEXT_MAP = "d1_trainstation_04"

TRIGGER_CHECKPOINT = {
	{ Vector( -4998, -4918, 512 ), Vector( -4978, -4699, 619 ) }
}

OVERRIDE_PLAYER_RESPAWNING = true


-- Player spawns
function tf2gmhl2PlayerSpawn( ply )

	ply:RemoveSuit()
	timer.Simple( 0.01, function() if ( IsValid( ply ) ) then GAMEMODE:SetPlayerSpeed( ply, 150, 150 ); end; end )

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Initialize entities
function tf2gmhl2MapEdit()

	game.SetGlobalState( "gordon_precriminal", GLOBAL_ON )
	game.SetGlobalState( "gordon_invulnerable", GLOBAL_ON )

	if ( !game.SinglePlayer() ) then
	
		ents.FindByName( "npc_breakincop3" )[ 1 ]:Remove()
		ents.FindByName( "ai_breakin_cop3goal3_blockplayer" )[ 1 ]:Remove()
		ents.FindByName( "ai_breakin_cop3goal3_blockplayer2" )[ 1 ]:Remove()
		ents.FindByName( "ai_breakin_cop3goal4_blockplayer" )[ 1 ]:Remove()
	
	end

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( !game.SinglePlayer() && ( ent:GetName() == "lcs_RaidRunner_1" ) && ( string.lower( input ) == "start" ) ) then
	
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetPos( Vector( -3900, -4507, 385 ) )
			ply:SetEyeAngles( Angle( 0, -260, 0 ) )
		
		end
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "lcs_cit_blocker_holdem" ) && ( string.lower( input ) == "start" ) ) then
	
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetPos( Vector( -4956, -4752, 513 ) )
			ply:SetEyeAngles( Angle( 0, -150, 0 ) )
		
		end
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
