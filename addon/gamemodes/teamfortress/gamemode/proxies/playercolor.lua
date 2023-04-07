matproxy.Add({
    name = "PlayerColor", 
    init = function( self, mat, values )
        -- Store the name of the variable we want to set
        self.ResultTo = values.resultvar
    end, 
    bind = function( self, mat, ent ) 
        -- If the target ent has a function called GetPlayerColor then use that
        -- The function SHOULD return a Vector with the chosen player's colour.

        -- In sandbox this function is created as a network function, 
        -- in player_sandbox.lua in SetupDataTables
		if ( ent.GetPlayerColor ) then	
			local clr = ent:GetPlayerColor()
			mat:SetVector( self.ResultTo, clr )
		end
		if (ent:GetOwner():GetNWEntity("RagdollEntity") == ent) then
	
			mat:SetVector( self.ResultTo, ent:GetOwner():GetPlayerColor() )
			
		end
   end 
})