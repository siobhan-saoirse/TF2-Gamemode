
local ScrW = ScrW
local ScrH = ScrH
local ipairs = ipairs
local type = type
local surface = surface
local math = math
local string = string
local table = table
local draw = draw

local TEXT_ALIGN_TOP = TEXT_ALIGN_TOP
local TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM
local TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT
local TEXT_ALIGN_RIGHT = TEXT_ALIGN_RIGHT
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

local Colors = Colors

module("tf_draw")

-- Useful drawing functions

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

function ShadedText(text, offset)
	offset = offset or Scale
	local oldx = text.pos[1]
	local oldy = text.pos[2]
	local oldcol = text.color
	
	text.pos[1] = text.pos[1] + offset
	text.pos[2] = text.pos[2] + offset
	text.color = Colors.Black
	draw.Text(text)
	
	text.pos[1] = oldx
	text.pos[2] = oldy
	text.color = oldcol
	draw.Text(text)
end

function TranslatePosition(x, y)
	return x*WScale, y*Scale
end

function TranslateScale(w, h)
	return w*Scale, h*Scale
end

function TexturedQuadTiled(tex, x1, y1, w, h, dir)
	dir = dir or {}
	
	local x2, y2 = x1+w, y1+h
	local tw, th = surface.GetTextureSize(tex)
	
	local u2,v2 = w/tw, h/th
	
	-- I want nil to be considered as true here, inb4 ==false hurr noob
	if dir.x==false and u2>1 then
		u2 = 1
		x2 = x1+tw
	end
	
	if dir.y==false and v2>1 then
		v2 = 1
		y2 = y1+th
	end
	
	local v = {}
	v[1] = {
		x=x1,
		y=y1,
		u=0,
		v=0
	}
	v[2] = {
		x=x2,
		y=y1,
		u=u2,
		v=0
	}
	v[3] = {
		x=x2,
		y=y2,
		u=u2,
		v=v2
	}
	v[4] = {
		x=x1,
		y=y2,
		u=0,
		v=v2
	}
	surface.SetTexture(tex)
	surface.DrawPoly(v)
end

function TexturedQuadPart(tex, x1, y1, w, h, tx, ty, tw, th)
	local x2, y2 = x1+w, y1+h
	local tw0, th0 = surface.GetTextureSize(tex)
	local u1,v1,u2,v2 = tx/tw0, ty/th0, (tx+tw)/tw0, (ty+th)/th0
	
	local v = {}
	v[1] = {
		x=x1,
		y=y1,
		u=u1,
		v=v1
	}
	v[2] = {
		x=x2,
		y=y1,
		u=u2,
		v=v1
	}
	v[3] = {
		x=x2,
		y=y2,
		u=u2,
		v=v2
	}
	v[4] = {
		x=x1,
		y=y2,
		u=u1,
		v=v2
	}
	surface.SetTexture(tex)
	surface.DrawPoly(v)
end

function ModTexture(tex,x,y,w,h,data)
	if data then
		TexturedQuadPart(tex, x, y, w, h, data.x, data.y, data.w, data.h)
	else
		TexturedQuadPart(tex.texture, x, y, w, h, tex.x, tex.y, tex.w, tex.h)
	end
end

function BorderPanel(tex,x,y,w,h,src_corner_width,src_corner_height,draw_corner_width,draw_corner_height)
	local tw, th = surface.GetTextureSize(tex)
	
	local dx = draw_corner_width
	local dy = draw_corner_height
	local Dx = src_corner_width
	local Dy = src_corner_height
	
	local x1,y1 = x+dx, y+dy
	local x2,y2 = x+w-dx, y+h-dy
	
	local w2,h2 = w-2*dx, h-2*dy
	
	-- Corners
	TexturedQuadPart(tex, x , y , dx, dy, 0     , 0     , Dx, Dy)
	TexturedQuadPart(tex, x2, y , dx, dy, tw-Dx , 0     , Dx, Dy)
	TexturedQuadPart(tex, x , y2, dx, dy, 0     , th-Dy, Dx, Dy)
	TexturedQuadPart(tex, x2, y2, dx, dy, tw-Dy , th-Dy, Dx, Dy)
	
	-- Borders
	TexturedQuadPart(tex, x1, y , w2, dy, Dx    , 0     , tw-2*Dx , Dy      )
	TexturedQuadPart(tex, x1, y2, w2, dy, Dx    , th-Dy , tw-2*Dx , Dy      )
	TexturedQuadPart(tex, x , y1, dx, h2, 0     , Dy    , Dx      , th-2*Dy)
	TexturedQuadPart(tex, x2, y1, dx, h2, tw-Dx , Dy    , Dx      , th-2*Dy)
	
	-- Inside
	TexturedQuadPart(tex, x1, y1, w2, h2, Dx, Dy, tw-2*Dx, th-2*Dy)
end

local TextAlignment = {
["north-west"]={y=TEXT_ALIGN_TOP   , x=TEXT_ALIGN_LEFT  },
["north"     ]={y=TEXT_ALIGN_TOP   , x=TEXT_ALIGN_CENTER},
["north-east"]={y=TEXT_ALIGN_TOP   , x=TEXT_ALIGN_RIGHT },

["west"      ]={y=TEXT_ALIGN_CENTER, x=TEXT_ALIGN_LEFT  },
["center"    ]={y=TEXT_ALIGN_CENTER, x=TEXT_ALIGN_CENTER},
["east"      ]={y=TEXT_ALIGN_CENTER, x=TEXT_ALIGN_RIGHT },

["south-west"]={y=TEXT_ALIGN_BOTTOM, x=TEXT_ALIGN_LEFT  },
["south"     ]={y=TEXT_ALIGN_BOTTOM, x=TEXT_ALIGN_CENTER},
["south-east"]={y=TEXT_ALIGN_BOTTOM, x=TEXT_ALIGN_RIGHT },
}

function Text(x,y,text,col,font,align)
	font = font or "Default"
	col = col or "TanLight"
	align = align or "north-west"
	
	if type(col)=="string" then
		col = Colors[col] or Colors.TanLight
	end
	
	if type(align)=="string" then
		align = TextAlignment[align] or TextAlignment["north-west"]
	end
	
	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)
	
	if align.x==TEXT_ALIGN_CENTER then
		x = x - w/2
	elseif align.x==TEXT_ALIGN_RIGHT then
		x = x - w
	end
	
	if align.y==TEXT_ALIGN_CENTER then
		y = y - h/2
	elseif align.y==TEXT_ALIGN_BOTTOM then
		y = y - h
	end
	
	surface.SetTextPos(x, y)
	surface.SetTextColor(col.r, col.g, col.b, col.a)
	surface.DrawText(text)
	
	return w, h
end

function LabelText(x,y,w,h,text,col,font,align)
	align = align or "north-west"
	if type(align)=="string" then
		align = TextAlignment[align] or TextAlignment["north-west"]
	end
	
	if align.x==TEXT_ALIGN_CENTER then
		x = x + w/2
	elseif align.x==TEXT_ALIGN_RIGHT then
		x = x + w
	end
	
	if align.y==TEXT_ALIGN_CENTER then
		y = y + h/2
	elseif align.y==TEXT_ALIGN_BOTTOM then
		y = y + h
	end
	
	return Text(x, y, text, col, font, align)
end

function LabelTextWrap(tab,dummy)
	--[[surface.SetDrawColor(255,0,0,255)
	surface.DrawLine(tab.x, tab.y, tab.x+tab.w, tab.y)
	surface.DrawLine(tab.x+tab.w, tab.y, tab.x+tab.w, tab.y+tab.h)
	surface.DrawLine(tab.x+tab.w, tab.y+tab.h, tab.x, tab.y+tab.h)
	surface.DrawLine(tab.x, tab.y+tab.h, tab.x, tab.y)]]
	
	local lines = {}
	local strtab = tab.text
	local col = tab.col
	
	if type(strtab)=="string" then
		strtab = {{1,strtab}}
		col = {col}
	end
	
	surface.SetFont(tab.font)
	
	local newlength, wordlength
	local splength, height = surface.GetTextSize(" ")
	
	for _,strdata in ipairs(strtab) do
		local str = strdata[2]
		for _,tline in ipairs(string.Explode("\n",str)) do
			local line = ""
			local length
			
			for _,word in ipairs(string.Explode(" ", tline)) do
				local newline = line
				
				if newline=="" then
					newline = word
				else
					newline = newline.." "..word
				end
				
				length = surface.GetTextSize(line)
				local newlength = surface.GetTextSize(newline)
				
				if newlength>tab.w then
					if line=="" then
						table.insert(lines, {word,newlength,col[strdata[1]]})
					else
						table.insert(lines, {line,length,col[strdata[1]]})
						line = word
						length = surface.GetTextSize(word)
					end
				else
					line = newline
					length = newlength
				end
			end
			table.insert(lines, {line,length,col[strdata[1]]})
		end
	end
	
	height = math.floor(height)
	local yspace = math.floor(height * (tab.yspace or 0.15))
	local totalheight = height * #lines + yspace * (#lines - 1)
	local align = TextAlignment[tab.align] or TextAlignment["north-west"]
	
	if dummy then return totalheight end
	
	local x, y
	if align.y == TEXT_ALIGN_TOP then			y = tab.y
	elseif align.y == TEXT_ALIGN_CENTER then	y = tab.y + tab.h/2 - totalheight/2
	else										y = tab.y + tab.h - totalheight
	end
	
	y = math.floor(y)
	
	for _,line in ipairs(lines) do
		if align.x == TEXT_ALIGN_LEFT then			x = tab.x
		elseif align.x == TEXT_ALIGN_CENTER then	x = tab.x + tab.w/2 - line[2]/2
		else										x = tab.x + tab.w - line[2]
		end
		
		if line[3] then
			if type(line[3])=="string" then
				line[3] = Colors[line[3]] or Colors.TanLight
			end
			surface.SetTextColor(line[3].r, line[3].g, line[3].b, line[3].a)
		else
			surface.SetTextColor(255,255,255,255)
		end
		
		surface.SetTextPos(x, y)
		surface.DrawText(line[1])
		
		y = y + height + yspace
	end
end


local pi = 3.1415926535

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

function CircularProgressBar(x, y, w, h, fore, back, fgcolor, bgcolor, progress)
	local wide, tall = w, h
	local halfWide, halfTall = wide/2, tall/2
	
	surface.SetTexture(back)
	surface.SetDrawColor(bgcolor)
	
	surface.DrawTexturedRect(x, y, w, h)
	
	surface.SetTexture(fore)
	surface.SetDrawColor(fgcolor)
	
	progress = progress * 3.1415926535 * 2
	
	for i=1,8 do
		if progress > Segments[i][1] then
			local v = {}
			
			v[1] = {
				x = x+halfWide,
				y = y+halfTall,
				u = 0.5,
				v = 0.5
			}
			
			local internalProgress = progress - Segments[i][1]

			if internalProgress < SEGMENT_ANGLE then
				-- Calc how much of this slice we should be drawing
				if i%2 == 1 then
					internalProgress = SEGMENT_ANGLE - internalProgress
				end
				
				local tan = math.tan(internalProgress)
				local deltaX, deltaY
				
				if i%2 == 1 then
					deltaX = (halfWide - halfTall * tan) * Segments[i][6]
					deltaY = (halfTall - halfWide * tan) * Segments[i][7]
				else
					deltaX = halfTall * tan * Segments[i][6]
					deltaY = halfWide * tan * Segments[i][7]
				end
				
				v[3] = {
					x = x+Segments[i][2] * wide + deltaX,
					y = y+Segments[i][3] * tall + deltaY,
					u = Segments[i][2] + (deltaX / halfWide) * 0.5,
					v = Segments[i][3] + (deltaY / halfTall) * 0.5
				}
			else
				-- full segment, easy calculation
				v[3] = {
					x = x+halfWide + wide * (Segments[i][4] - 0.5),
					y = y+halfTall + tall * (Segments[i][5] - 0.5),
					u = Segments[i][4],
					v = Segments[i][5]
				}
			end

			-- vert 2 is ( Segments[i].vert1x, Segments[i].vert1y )
			v[2] = {
				x = x+halfWide + wide * (Segments[i][2] - 0.5),
				y = y+halfTall + tall * (Segments[i][3] - 0.5),
				u = Segments[i][2],
				v = Segments[i][3]
			}
			
			surface.DrawPoly(v)
		end
	end
end
