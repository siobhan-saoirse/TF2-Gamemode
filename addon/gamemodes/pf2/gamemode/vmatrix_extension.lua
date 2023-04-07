
local META = FindMetaTable("Angle")

-- Returns the inverse of a rotation
function META:GetInverse()
	local Mp = Matrix()		Mp:Rotate(Angle(-self.p, 0, 0))
	local My = Matrix()		My:Rotate(Angle(0, -self.y, 0))
	local Mr = Matrix()		Mr:Rotate(Angle(0, 0, -self.r))
	
	return (Mr*Mp*My):GetAngles()
end

local META = FindMetaTable("VMatrix")

-- Returns the scale of a matrix

function META:GetScale()
	local rot = self:GetAngles()
	
	self:Rotate(rot:GetInverse())
	local v1 = self:GetTranslation()
	self:Translate(Vector(1,1,1))
	local v2 = self:GetTranslation()
	self:Translate(Vector(-1,-1,-1))
	self:Rotate(rot)
	
	return v2 - v1
end

-- Returns the inverse of a matrix (inverse(M) * M = identity matrix)
function META:GetInverse()
	local trans = self:GetTranslation()
	local inv_trans = -1 * self:GetTranslation()
	
	local rot = self:GetAngles()
	local inv_rot = rot:GetInverse()
	
	self:Rotate(inv_rot)
	local v1 = self:GetTranslation()
	self:Translate(Vector(1,1,1))
	local v2 = self:GetTranslation()
	self:Translate(Vector(-1,-1,-1))
	self:Rotate(rot)
	
	local scl = v2 - v1
	local inv_scl = Vector(1/scl.x, 1/scl.y, 1/scl.z)
	
	local i = Matrix()
	i:Scale(inv_scl)
	i:Rotate(inv_rot)
	i:Translate(inv_trans)
	
	return i
end

-- Creates a 4x4 table from a matrix
function META:ToTable()
	local mat = {
		{1, 0, 0, 0},
		{0, 1, 0, 0},
		{0, 0, 1, 0},
		{0, 0, 0, 1},
	}
	
	local trans = self:GetTranslation()
	local rot = self:GetAngles()
	local scl = self:GetScale()
	
	mat[1][4] = trans.x
	mat[2][4] = trans.y
	mat[3][4] = trans.z
	
	local cp, sp = math.cos(math.rad(rot.p)), math.sin(math.rad(rot.p))
	local cy, sy = math.cos(math.rad(rot.y)), math.sin(math.rad(rot.y))
	local cr, sr = math.cos(math.rad(rot.r)), math.sin(math.rad(rot.r))
	
	mat[1][1] = cp * cy	; mat[1][2] = -cr * sy + sr * sp * cy	; mat[1][3] = sr * sy + cr * sp * cy
	mat[2][1] = cp * sy	; mat[2][2] = cr * cy + sr * sp * sy	; mat[2][3] = -sr * cy + cr * sp * sy
	mat[3][1] = -sp		; mat[3][2] = sr * cp					; mat[3][3] = cr * cp
	
	mat[1][1] = mat[1][1] * scl.x
	mat[2][2] = mat[2][2] * scl.y
	mat[3][3] = mat[3][3] * scl.z
	
	return mat
end


function META:__tostring()
	local mat = self:ToTable()
	local str = ""
	
	for i=1, 4 do
		str = str.."("
		for j=1, 4 do
			local s = Format("%f", mat[i][j])
			if string.sub(s, 1, 1) ~= "-" then
				s = " "..s
			end
			if j < 4 then
				s = s.." "
			end
			str = str..s
		end
		str = str..")"
		if i < 4 then
			str = str.."\n"
		end
	end
	
	return str
end

