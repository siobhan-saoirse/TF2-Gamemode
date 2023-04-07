-- from https://steamcommunity.com/workshop/filedetails/?id=282164100&insideModal=0&requirelogin=1

if CLIENT then return end	//i'd like to do this clientside instead so we can potentially not get any lag on the flex changes, but it seems like changing flexes clientside
//if SERVER then return end	//just doesn't work (are they being overwritten by serverside flexes, or can you just not set clientside flexes on serverside entities at all?)
				



local function GetFlexFromName(ent,flexname)

	for i = 0, ent:GetFlexNum() - 1 do
		if string.lower(ent:GetFlexName(i)) == string.lower(flexname) then return i end
	end

end




BeardFlexifierEntities = {}
//local TestEnts = {}
 
hook.Add("Think", "BeardFlexifierThink", function()

	for parent, tab in pairs (BeardFlexifierEntities) do

		if IsValid(parent) and parent:GetFlexNum() > 0 then

			//if !TestEnts[parent] then MsgN("Started beard flexifier for ", parent, " ", parent:GetModel()) TestEnts[parent] = parent end

			local children = parent:GetChildren()
			//Handling for ents parented to a prop_effect instead of its attachedentity
			if IsValid(parent:GetParent()) and parent:GetParent().AttachedEntity == parent then
				table.Add(children, parent:GetParent():GetChildren())
			end

			for _, ent in pairs (children) do

				if IsValid(ent) and ent != parent and ent:GetFlexNum() > 0 then

					//Cache the flex ID translations so we don't have to keep retrieving them
					if !tab[ent] then
						tab[ent] = {}
						for i = 0, ent:GetFlexNum() - 1 do
							//this is faster, but it's case-sensitive and it grabs the wrong values sometimes 
							//(see spy's graylien - it'll have problems with case AND it'll assign scared to scaredUpper)
							//local flex = parent:GetFlexIDByName(ent:GetFlexName(i)) 
							local flex = GetFlexFromName(parent, ent:GetFlexName(i))
							if flex then tab[ent][i] = flex end
						end
					end

					for i, flex in pairs (tab[ent]) do
						ent:SetFlexWeight(i, parent:GetFlexWeight(flex))
					end

					ent:SetFlexScale(parent:GetFlexScale())

				end

			end

		else

			//note: the way we're doing this means that if an entity starts off with a flexless model, but gets changed to a model with flexes later on, it won't work with this 
			//addon, but that's an edge case, and doing it this way means we won't have to keep iterating over the 99.99% of things that don't have flexes and never will.
			BeardFlexifierEntities[parent] = nil

		end

	end

end)




hook.Add("OnEntityCreated", "AddBeardFlexifier", function(ent)

	if !IsValid(ent) then return end

	//ent:GetFlexNum() doesn't retrieve the right value here, so run every entity through the Think hook at least once
	BeardFlexifierEntities[ent] = {}

end)