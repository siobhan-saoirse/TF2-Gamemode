NEXT_MAP = "d3_citadel_04"

RESET_WEAPONS = true

TRIGGER_CHECKPOINT = {
	{ Vector( 3175, 522, 2368 ), Vector( 3580, 562, 2529 ) }
}


-- Initialize entities
function tf2gmhl2MapEdit()

	game.ConsoleCommand( "physcannon_tracelength 850\n" )
	game.ConsoleCommand( "physcannon_maxmass 850\n" )
	game.ConsoleCommand( "physcannon_pullforce 8000\n" )

	ents.FindByName( "global_newgame_template_ammo" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_base_items" )[ 1 ]:Remove()
	ents.FindByName( "global_newgame_template_local_items" )[ 1 ]:Remove()

end
hook.Add( "MapEdit", "tf2gmhl2MapEdit", tf2gmhl2MapEdit )


-- Accept input
function tf2gmhl2AcceptInput( ent, input )

	if ( ( ent:GetName() == "logic_weapon_strip_dissolve" ) && ( string.lower( input ) == "trigger" ) ) then
	
		if ( IsValid( ents.FindByName( "logic_weapon_strip_physcannon_start" )[ 1 ] ) ) then ents.FindByName( "logic_weapon_strip_physcannon_start" )[ 1 ]:Fire( "Trigger", "", 3 ); end
	
	end

	if ( ( ent:GetName() == "strip_stop" ) && ( string.lower( input ) == "trigger" ) ) then
	
		SetGlobalBool( "SUPER_GRAVITY_GUN", true )
	
		for _, ply in pairs( team.GetPlayers( TEAM_ALIVE ) ) do
		
			if ( IsValid( ply ) && ply:Alive() ) then
			
				ply:Give( "weapon_physcannon" )
			
			end
		
		end
	
	end

end
hook.Add( "AcceptInput", "tf2gmhl2AcceptInput", tf2gmhl2AcceptInput )


-- Every frame or tick
function tf2gmhl2Think()

	if ( GetGlobalBool( "SUPER_GRAVITY_GUN" ) ) then
	
		for _, ent in pairs( ents.FindByClass( "weapon_physcannon" ) ) do
		
			if ( IsValid( ent ) && ent:IsWeapon() ) then
			
				if ( ent:GetSkin() != 1 ) then ent:SetSkin( 1 ); end
			
			end
		
		end
	
		for _, ent in pairs( ents.FindByClass( "weapon_*" ) ) do
		
			if ( IsValid( ent ) && ent:IsWeapon() && ( ent:GetClass() != "weapon_physcannon" ) && ( !IsValid( ent:GetOwner() ) || ( IsValid( ent:GetOwner() ) && ent:GetOwner():IsPlayer() ) ) ) then
			
				ent:Remove()
			
			end
		
		end
	
	end

end
hook.Add( "Think", "tf2gmhl2Think", tf2gmhl2Think )
