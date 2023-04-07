NEXT_MAP = "d1_trainstation_06"

TRIGGER_CHECKPOINT = {
	{ Vector( -6509, -1105, 0 ), Vector( -6459, -1099, 92 ) },
	{ Vector( -10461, -4749, 319 ), Vector( -10271, -4689, 341 ) }
}

TRAINSTATION_REMOVESUIT = true


-- Player spawns
function tf2gmhl2PlayerSpawn( ply )

	if ( TRAINSTATION_REMOVESUIT ) then
	
		ply:RemoveSuit()
		timer.Simple( 0.01, function() if ( IsValid( ply ) ) then GAMEMODE:SetPlayerSpeed( ply, 150, 150 ); end; end )
	
	end

	if ( !game.SinglePlayer() && IsValid( PLAYER_VIEWCONTROL ) && ( PLAYER_VIEWCONTROL:GetClass() == "point_viewcontrol" ) ) then
	
		ply:SetViewEntity( PLAYER_VIEWCONTROL )
		ply:Freeze( true )
	
	end

end
hook.Add( "PlayerSpawn", "tf2gmhl2PlayerSpawn", tf2gmhl2PlayerSpawn )


-- Entity removed
local tf2gmhl2_server_custom_playermodels = GetConVar( "tf2gmhl2_server_custom_playermodels" )
function tf2gmhl2EntityRemoved( ent )

	if ( ent:GetClass() == "item_suit" ) then
	
		TRAINSTATION_REMOVESUIT = false
		for _, ply in pairs( player.GetAll() ) do
		
			ply:EquipSuit()
			if ( !tf2gmhl2_server_custom_playermodels:GetBool() ) then ply:SetModel( string.gsub( ply:GetModel(), "group01", "group03" ) ); end
			ply:SetupHands()
			GAMEMODE:SetPlayerSpeed( ply, 190, 320 )
		
		end
	
	end

end
hook.Add( "EntityRemoved", "tf2gmhl2EntityRemoved", tf2gmhl2EntityRemoved )


-- Accept input
function tf2gmhl2AcceptInput( ent, input, activator, caller, value )

	if ( !game.SinglePlayer() && ( ent:GetClass() == "point_viewcontrol" ) ) then
	
		if ( string.lower( input ) == "enable" ) then
		
			PLAYER_VIEWCONTROL = ent
		
			for _, ply in ipairs( player.GetAll() ) do
			
				ply:SetViewEntity( ent )
				ply:Freeze( true )
			
			end
		
			if ( !ent.doubleEnabled ) then
			
				ent.doubleEnabled = true
				ent:Fire( "Enable" )
			
			end
		
		elseif ( string.lower( input ) == "disable" ) then
		
			PLAYER_VIEWCONTROL = nil
		
			for _, ply in ipairs( player.GetAll() ) do
			
				ply:SetViewEntity( ply )
				ply:Freeze( false )
			
			end
		
			return true
		
		end
	
	end

	if ( !game.SinglePlayer() && ( ( ent:GetName() == "lab_door" ) || ( ent:GetName() == "lab_door_clip" ) ) && ( string.lower( input ) == "close" ) ) then
	
		return true
	
	end

	if ( !game.SinglePlayer() && ( ent:GetName() == "kleiner_teleport_player_starter_1" ) && ( string.lower( input ) == "trigger" ) ) then
	
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetVelocity( Vector( 0, 0, 0 ) )
			ply:SetPos( Vector( -7186.700195, -1176.699951, 28 ) )
		
		end
	
	end

	if ( !game.SinglePlayer() && ( ent:GetClass() == "player_speedmod" ) && ( string.lower( input ) == "modifyspeed" ) ) then
	
		for _, ply in pairs( player.GetAll() ) do
		
			ply:SetLaggedMovementValue( tonumber( value ) )
		
		end
	
		return true
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )
