local PANEL = {}

local pi = 3.1415926535

-- This defines the properties of the 8 circle segments
-- in the circular progress bar.

--[[
typedef struct
{
	float minProgressRadians;

	float vert1x;
	float vert1y;
	float vert2x;
	float vert2y;

	int swipe_dir_x;
	int swipe_dir_y;
} circular_progress_segment_t;
]]

local Segments = {
	{0.0	  ,	0.5, 0.0, 1.0, 0.0,  1,  0},
	{pi * 0.25,	1.0, 0.0, 1.0, 0.5,  0,  1},
	{pi * 0.5 ,	1.0, 0.5, 1.0, 1.0,  0,  1},
	{pi * 0.75,	1.0, 1.0, 0.5, 1.0, -1,  0},
	{pi		  ,	0.5, 1.0, 0.0, 1.0, -1,  0},
	{pi * 1.25,	0.0, 1.0, 0.0, 0.5,  0, -1},
	{pi * 1.5 ,	0.0, 0.5, 0.0, 0.0,  0, -1},
	{pi * 1.75,	0.0, 0.0, 0.5, 0.0,  1,  0},
}
local SEGMENT_ANGLE	= pi/4

AccessorFunc(PANEL, "ForegroundColor", "ForegroundColor")
AccessorFunc(PANEL, "BackgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "Centered", "Centered")
AccessorFunc(PANEL, "Progress", "Progress")

function PANEL:SetForegroundTexture(tex)
	self.ForegroundTexture = surface.GetTextureID(tex)
end

function PANEL:SetBackgroundTexture(tex)
	self.BackgroundTexture = surface.GetTextureID(tex)
end

function PANEL:Init()
	self:SetVisible(true)
	self:SetPaintBackgroundEnabled(false)
	self.ForegroundColor = Color(255,255,255,255)
	self.BackgroundColor = Color(255,255,255,255)
	self.Progress = 0
	self.Centered = false
end

function PANEL:PaintBackground()
	-- If we don't have a Bg image, use the foreground
	local tex = self.BackgroundTexture or self.ForegroundTexture
	local color = self.BackgroundColor or Color(0, 0, 0)
	surface.SetTexture(tex)
	surface.SetDrawColor(color)
	
	local wide, tall = self:GetSize()
	
	if self.Centered then
		surface.DrawTexturedRect(-wide/2, -tall/2, wide, tall)
	else
		surface.DrawTexturedRect(0, 0, wide, tall)
	end
	
	--[[if self.Centered then
		draw.Text{
			text=math.floor(self:GetProgress()*100),
			font="HudClassHealth",
			pos={0, 0},
			color=Color(255,255,255,255),
			xalign=TEXT_ALIGN_CENTER,
			yalign=TEXT_ALIGN_CENTER,
		}
	else
		draw.Text{
			text=math.floor(self:GetProgress()*100),
			font="HudClassHealth",
			pos={wide/2, tall/2},
			color=Color(255,255,255,255),
			xalign=TEXT_ALIGN_CENTER,
			yalign=TEXT_ALIGN_CENTER,
		}
	end]]
end

function PANEL:Paint()
	self:PaintBackground()
	
	local progress = self:GetProgress()
	self:DrawCircleSegment(self.ForegroundColor, progress, true)
end

-- function to draw from A to B degrees, with a direction
-- we draw starting from the top ( 0 progress )
function PANEL:DrawCircleSegment(c, endProgress, clockwise)
	if not self.ForegroundTexture then
		return
	end

	c = c or Color(0, 0, 0)
	
	local wide, tall = self:GetSize()
	local halfWide, halfTall = wide/2, tall/2
	
	surface.SetTexture(self.ForegroundTexture)
	surface.SetDrawColor(c)

	-- TODO - if we want to progress CCW, reverse a few things
	
	local endProgress = endProgress * 3.1415926535 * 2
	
	for i=1,8 do
		if endProgress > Segments[i][1] then
			local v = {}
			
			v[1] = {
				x = halfWide,
				y = halfTall,
				u = 0.5,
				v = 0.5
			}
			
			local internalProgress = endProgress - Segments[i][1]

			if internalProgress < SEGMENT_ANGLE then
				-- Calc how much of this slice we should be drawing
				if i%2 == 0 then
					internalProgress = SEGMENT_ANGLE - internalProgress
				end
				
				local tan = math.tan(internalProgress)
				local deltaX, deltaY
				
				if i%2 == 0 then
					deltaX = (halfWide - halfTall * tan) * Segments[i][6]
					deltaY = (halfTall - halfWide * tan) * Segments[i][7]
				else
					deltaX = halfTall * tan * Segments[i][6]
					deltaY = halfWide * tan * Segments[i][7]
				end
				
				v[3] = {
					x = Segments[i][2] * wide + deltaX,
					y = Segments[i][3] * tall + deltaY,
					u = Segments[i][2] + (deltaX / halfWide) * 0.5,
					v = Segments[i][3] + (deltaY / halfTall) * 0.5
				}
			else
				-- full segment, easy calculation
				v[3] = {
					x = halfWide + wide * (Segments[i][4] - 0.5),
					y = halfTall + tall * (Segments[i][5] - 0.5),
					u = Segments[i][4],
					v = Segments[i][5]
				}
			end

			-- vert 2 is ( Segments[i].vert1x, Segments[i].vert1y )
			v[2] = {
				x = halfWide + wide * (Segments[i][2] - 0.5),
				y = halfTall + tall * (Segments[i][3] - 0.5),
				u = Segments[i][2],
				v = Segments[i][3]
			}
			
			if self.Centered then
				for _,w in ipairs(v) do
					w.x = w.x-halfWide
					w.y = w.y-halfTall
				end
			end
			
			surface.DrawPoly(v)
		end
	end
end

vgui.Register("CircularProgressBar", PANEL)
