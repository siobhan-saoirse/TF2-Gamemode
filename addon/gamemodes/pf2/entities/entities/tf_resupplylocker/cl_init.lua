include('shared.lua')
 
function ENT:Draw()
    -- self.BaseClass.Draw(self)  -- We want to override rendering, so don't call baseclass.
                                  -- Use this when you need to add to the rendering.
    self:DrawEntityOutline( 1.0 ) -- Draw an outline of 1 world unit.
    self:DrawModel()       -- Draw the model.
 
    AddWorldTip( self:EntIndex(), "BATHTUB TIME!", 0.5, self:GetPos(), self  ) -- Add an example tip.
end