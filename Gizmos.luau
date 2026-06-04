--!optimize 2
--!strict
--!native

-- Author: t003z
-- Module.luau

-- DEFAULTS
const THICKNESS = 2
const ENABLED = false
const TRANSPARENCY = 0
const COLOR = Color3.fromRGB(255, 255, 255)

-- Class
export type Public = {
	
	DrawCircle: (self: Public, Transform: CFrame, Radius: number, Sides: number) -> (),
	DrawSemiCircle: (self: Public, Transform: CFrame, Radius: number, Sides: number, Connected: boolean?) -> (),
	
	DrawSphere: (self: Public, Transform: CFrame, Radius: number, Sides: number) -> (),
	DrawHemisphere: (self: Public, Transform: CFrame, Radius: number, Sides: number, Connected: boolean?) -> (),
	DrawTorus: (self: Public, Transform: CFrame, MajorScale: number, MinorScale: number, Sides: number) -> (),
	
	DrawCapsule: (self: Public, Transform: CFrame, Radius: number, Height: number) -> (),
	DrawCone: (self: Public, Transform: CFrame, Radius: number, Height: number, Sides: number) -> (),
	DrawStar: (self: Public, Transform: CFrame, OuterWidth: number, InnerWidth: number, Points: number) -> (),
	
	DrawTriangle: (self: Public, PointA: Vector3, PointB: Vector3, PointC: Vector3) -> (),
	DrawQuad: (self: Public, PointA: Vector3, PointB: Vector3, PointC: Vector3, PointD: Vector3) -> (),
	DrawNgon: (self: Public, Points: {Vector3}) -> (),
	
	DrawCube: (self: Public, Transform: CFrame, Size: Vector3) -> (),
	DrawSquare: (self: Public, Transform: CFrame, Width: number, Height: number) -> (),
	
	DrawLine: (self: Public, PointA: Vector3, PointB: Vector3) -> (),
	DrawPoint: (self: Public, Origin: Vector3, Length: number) -> (),
	DrawText: (self: Public, Origin: Vector3, Scale: number, Text: string, MaxDistance: number?) -> (),
	
	DrawArrow: (self: Public, Origin: Vector3, Direction: Vector3, Length: number, Width: number) -> (),
	DrawCFrame: (self: Public, Transform: CFrame, Length: number) -> (),
	DrawArc: (self: Public, Transform: CFrame, Radius: number, Angle: number, Sides: number) -> (),
	
	DrawMesh: (self: Public, Transform: CFrame, Size: Vector3, Mesh: Content) -> (),
	DrawImage: (Self: Public, Transform: CFrame, Scale: number, Image: Content, Threshold: number?) -> (),
	
	DrawPath: (self: Public, Points: {Vector3}) -> (),
	DrawBezierCurve: (self: Public, Points: {Vector3}) -> (),
	
	SetColor: (self: Public, Color: Color3) -> (),
	SetThickness: (self: Public, Thickness: number) -> (),
	SetTransparency: (self: Public, Transparency: number) -> (),
	SetEnabled: (self: Public, Enable: boolean) -> (),
	
	Clear: (self: Public) -> (),
	Destroy: (self: Public) -> ()
}
type Private = Public & {
	Wireframe: WireframeHandleAdornment
}

-- Services
local AssetService = game:GetService("AssetService")

-- Variables
local camera = workspace.CurrentCamera :: Camera
local container = workspace

-- Helpers
local function Cross2D(PointA: Vector2, PointB: Vector2, PointC: Vector2): number
	return (PointB.X - PointA.X) * (PointC.Y - PointA.Y) - (PointB.Y - PointA.Y) * (PointC.X - PointA.X)
end

local function PointInTriangle(Origin: Vector2, PointA: Vector2, PointB: Vector2, PointC: Vector2): boolean
	
	local ab = Cross2D(PointA, PointB, Origin)
	local bc = Cross2D(PointB, PointC, Origin)
	local ca = Cross2D(PointC, PointA, Origin)
	
	return not ((ab < 0 or bc < 0 or ca < 0) and (ab > 0 or bc > 0 or ca > 0))
end

local function Bezier(Points: {Vector3}, Alpha: number): Vector3
	local temp = table.clone(Points)
	
	for key = #temp, 2, -1 do
		for index = 1, key - 1 do
			temp[index] = temp[index]:Lerp(temp[index + 1], Alpha)
		end
	end
	
	return temp[1]
end

-- Object
class Object

	public Wireframe: WireframeHandleAdornment
	
	function new(): Public
		local self = Object {} :: Private
		
		self.Wireframe = Instance.new("WireframeHandleAdornment")
		self.Wireframe.AdornCullingMode = Enum.AdornCullingMode.Never
		self.Wireframe.Transparency = TRANSPARENCY
		self.Wireframe.Thickness = THICKNESS
		self.Wireframe.Adornee = container
		self.Wireframe.Visible = ENABLED
		self.Wireframe.AlwaysOnTop = true
		self.Wireframe.Color3 = COLOR
		self.Wireframe.Name = "Gizmo"
		self.Wireframe.Parent = container
		
		return self
	end
	
	function DrawCircle(self, Transform: CFrame, Radius: number, Sides: number): ()
		if Sides < 3 then return end
		
		local halfRadius = Radius / 2
		local points = table.create(Sides)

		for index = 0, Sides - 1 do

			local theta = (index / Sides) * math.pi * 2
			local point = Vector3.new(math.cos(theta) * halfRadius, math.sin(theta) * halfRadius, 0)
			points[index + 1] = Transform:PointToWorldSpace(point)
		end

		self.Wireframe:AddPath(points, true)
	end
	
	function DrawSemiCircle(self, Transform: CFrame, Radius: number, Sides: number, Connected: boolean?): ()
		if Sides < 2 then return end

		local halfRadius = Radius / 2
		local points = table.create(Sides + 1)

		for index = 0, Sides do

			local theta = (index / Sides) * math.pi
			local point = Vector3.new(math.cos(theta) * halfRadius, math.sin(theta) * halfRadius, 0)
			points[index + 1] = Transform:PointToWorldSpace(point)
		end

		self.Wireframe:AddPath(points, Connected or false)
	end
	
	function DrawSphere(self, Transform: CFrame, Radius: number, Sides: number): ()
		self:DrawCircle(Transform, Radius, Sides)
		self:DrawCircle(Transform * CFrame.Angles(0, math.rad(90), 0), Radius, Sides)
		self:DrawCircle(Transform * CFrame.Angles(math.rad(90), 0, 0), Radius, Sides)
	end
	
	function DrawHemisphere(self, Transform: CFrame, Radius: number, Sides: number, Connected: boolean?): ()
		self:DrawSemiCircle(Transform, Radius, Sides / 2, Connected)
		self:DrawSemiCircle(Transform * CFrame.Angles(0, math.rad(90), 0), Radius, Sides / 2, Connected)
		self:DrawCircle(Transform * CFrame.Angles(math.rad(90), 0, 0), Radius, Sides)
	end
	
	function DrawTorus(self, Transform: CFrame, MajorScale: number, MinorScale: number, Sides: number): ()
		if Sides < 3 then return end
		
		local majorRadius = MajorScale / 2
		local minorRadius = MinorScale / 2
		
		for major = 0, Sides - 1 do

			local theta = (major / Sides) * math.pi * 2
			local offset = Transform * CFrame.Angles(0, theta, 0) * CFrame.new(majorRadius, 0, 0)

			self:DrawCircle(offset,	MinorScale,	Sides)
		end
		
		for minor = 0, Sides - 1 do

			local points = table.create(Sides)

			local thetaMinor = (minor / Sides) * math.pi * 2
			local cosMinor = math.cos(thetaMinor)
			local sinMinor = math.sin(thetaMinor)

			for major = 0, Sides - 1 do

				local thetaMajor = (major / Sides) * math.pi * 2
				local cosMajor = math.cos(thetaMajor)
				local sinMajor = math.sin(thetaMajor)

				local radius = majorRadius + minorRadius * cosMinor

				points[major + 1] = Transform:PointToWorldSpace(Vector3.new(radius * cosMajor, minorRadius * sinMinor, radius * sinMajor))
			end

			self.Wireframe:AddPath(points, true)
		end
	end
	
	function DrawCapsule(self, Transform: CFrame, Radius: number, Height: number): ()
		
		local radius = Radius / 2
		local height = Height / 2

		self:DrawCircle(Transform * CFrame.Angles(math.rad(90), 0, 0), Radius, 32)
		self:DrawHemisphere(Transform * CFrame.new(0, height - radius, 0), Radius, 32)
		self:DrawHemisphere(Transform * CFrame.new(0, -height + radius, 0) * CFrame.Angles(math.rad(180), 0, 0), Radius, 32)

		self.Wireframe:AddLine(Transform * CFrame.new(radius, height - radius, 0).Position, Transform * CFrame.new(radius, -height + radius, 0).Position)
		self.Wireframe:AddLine(Transform * CFrame.new(-radius, height - radius, 0).Position, Transform * CFrame.new(-radius, -height + radius, 0).Position)
		self.Wireframe:AddLine(Transform * CFrame.new(0, height - radius, radius).Position, Transform * CFrame.new(0, -height + radius, radius).Position)
		self.Wireframe:AddLine(Transform * CFrame.new(0, height - radius, -radius).Position, Transform * CFrame.new(0, -height + radius, -radius).Position)
	end
	
	function DrawCone(self, Transform: CFrame, Radius: number, Height: number, Sides: number): ()
		if Sides < 3 then return end
		
		local radius = Radius / 2
		local apex = Transform.Position + Transform.LookVector * Height
		
		local vertices = table.create(Sides) :: {Vector3}
		
		for index = 1, Sides do

			local theta = ((index - 1) / Sides) * math.pi * 2
			vertices[index] = Transform:PointToWorldSpace(Vector3.new(math.cos(theta) * radius, math.sin(theta) * radius, 0))
		end
		
		for index = 1, Sides do
			
			local current = vertices[index]
			local next = vertices[(index % Sides) + 1]
			self.Wireframe:AddLine(current, next)
		end
		
		for index = 1, Sides do
			self.Wireframe:AddLine(vertices[index], apex)
		end
	end
	
	function DrawStar(self, Transform: CFrame, OuterWidth: number, InnerWidth: number, Points: number): ()
		if Points < 2 then return end

		local outerRadius = OuterWidth / 2
		local innerRadius = InnerWidth / 2

		local vertices = table.create(Points * 2) :: {Vector3}

		for index = 0, Points * 2 - 1 do

			local theta = (index / (Points * 2)) * math.pi * 2
			local rad = (index % 2 == 0) and outerRadius or innerRadius

			vertices[index + 1] = Transform:PointToWorldSpace(Vector3.new(math.cos(theta) * rad, 0, math.sin(theta) * rad))
		end

		for index = 1, #vertices do

			local current = vertices[index]
			local next = vertices[(index % #vertices) + 1]
			self.Wireframe:AddLine(current, next)
		end
	end
	
	function DrawTriangle(self, PointA: Vector3, PointB: Vector3, PointC: Vector3): ()
		self.Wireframe:AddLine(PointA, PointB)
		self.Wireframe:AddLine(PointB, PointC)
		self.Wireframe:AddLine(PointC, PointA)
	end
	
	function DrawQuad(self, PointA: Vector3, PointB: Vector3, PointC: Vector3, PointD: Vector3): ()
		self.Wireframe:AddLine(PointA, PointB)
		self.Wireframe:AddLine(PointB, PointC)
		self.Wireframe:AddLine(PointC, PointD)
		self.Wireframe:AddLine(PointD, PointA)
		self.Wireframe:AddLine(PointA, PointC)
	end
	
	function DrawNgon(self, Points: {Vector3}): ()
		local count = #Points
		
		if count < 3 then
			return
		elseif count == 3 then
			self:DrawTriangle(Points[1], Points[2], Points[3])
			return
		end
		
		local normal = Vector3.zero
		for i = 1, count do
			local current = Points[i]
			local next = Points[(i % count) + 1]

			normal += Vector3.new(
				(current.Y - next.Y) * (current.Z + next.Z),
				(current.Z - next.Z) * (current.X + next.X),
				(current.X - next.X) * (current.Y + next.Y)
			)
		end
		normal = normal.Unit
		
		local ax = math.abs(normal.X)
		local ay = math.abs(normal.Y)
		local az = math.abs(normal.Z)
		local projected = table.create(count) :: {Vector2}
		
		if ax >= ay and ax >= az then
			for i = 1, count do
				local p = Points[i]
				projected[i] = Vector2.new(p.Y, p.Z)
			end
		elseif ay >= az then
			for i = 1, count do
				local p = Points[i]
				projected[i] = Vector2.new(p.X, p.Z)
			end
		else
			for i = 1, count do
				local p = Points[i]
				projected[i] = Vector2.new(p.X, p.Y)
			end
		end
		
		local indices = table.create(count) :: {number}
		for i = 1, count do
			indices[i] = i
		end
		
		local area = 0
		
		for i = 1, count do
			local a = projected[i]
			local b = projected[(i % count) + 1]
			area += a.X * b.Y - b.X * a.Y
		end
		
		local ccw = area > 0
		
		while #indices > 3 do
			
			local earFound = false
			
			for i = 1, #indices do
				
				local prev = indices[((i - 2) % #indices) + 1]
				local curr = indices[i]
				local next = indices[(i % #indices) + 1]
				
				local A = projected[prev]
				local B = projected[curr]
				local C = projected[next]
				
				local convex = ccw and Cross2D(A, B, C) > 0 or (not ccw and Cross2D(A, B, C) < 0)
				if convex then
					local containsPoint = false
					
					for j = 1, #indices do
						local test = indices[j]

						if test ~= prev and test ~= curr and test ~= next then
							if PointInTriangle(projected[test], A, B, C) then
								containsPoint = true
								break
							end
						end
					end
					
					if not containsPoint then
						self:DrawTriangle(Points[prev], Points[curr], Points[next])
						table.remove(indices, i)
						earFound = true
						break
					end
				end
			end
			
			if not earFound then return end
		end
		
		self:DrawTriangle(Points[indices[1]], Points[indices[2]], Points[indices[3]])
	end
	
	function DrawCube(self, Transform: CFrame, Size: Vector3): ()
		
		local half = Size * 0.5

		local p000 = Transform * Vector3.new(-half.X, -half.Y, -half.Z)
		local p001 = Transform * Vector3.new(-half.X, -half.Y, half.Z)
		local p010 = Transform * Vector3.new(-half.X, half.Y, -half.Z)
		local p011 = Transform * Vector3.new(-half.X, half.Y, half.Z)

		local p100 = Transform * Vector3.new(half.X, -half.Y, -half.Z)
		local p101 = Transform * Vector3.new(half.X, -half.Y, half.Z)
		local p110 = Transform * Vector3.new(half.X, half.Y, -half.Z)
		local p111 = Transform * Vector3.new(half.X, half.Y, half.Z)
		
		self.Wireframe:AddLine(p000, p001)
		self.Wireframe:AddLine(p001, p101)
		self.Wireframe:AddLine(p101, p100)
		self.Wireframe:AddLine(p100, p000)

		self.Wireframe:AddLine(p010, p011)
		self.Wireframe:AddLine(p011, p111)
		self.Wireframe:AddLine(p111, p110)
		self.Wireframe:AddLine(p110, p010)

		self.Wireframe:AddLine(p000, p010)
		self.Wireframe:AddLine(p001, p011)
		self.Wireframe:AddLine(p101, p111)
		self.Wireframe:AddLine(p100, p110)
	end
	
	function DrawSquare(self, Transform: CFrame, Width: number, Height: number): ()
		
		local halfWidth = Width * 0.5
		local halfHeight = Height * 0.5

		local a = Transform:PointToWorldSpace(Vector3.new(-halfWidth, 0, -halfHeight))
		local b = Transform:PointToWorldSpace(Vector3.new(halfWidth, 0, -halfHeight))
		local c = Transform:PointToWorldSpace(Vector3.new(halfWidth, 0, halfHeight))
		local d = Transform:PointToWorldSpace(Vector3.new(-halfWidth, 0, halfHeight))
		
		self.Wireframe:AddLine(a, b)
		self.Wireframe:AddLine(b, c)
		self.Wireframe:AddLine(c, d)
		self.Wireframe:AddLine(d, a)
	end
	
	function DrawLine(self, PointA: Vector3, PointB: Vector3): ()
		self.Wireframe:AddLine(PointA, PointB)
	end
	
	function DrawPoint(self, Origin: Vector3, Length: number): ()
		
		local forward = Vector3.zAxis * Length / 2
		local right = Vector3.xAxis * Length / 2
		local up = Vector3.yAxis * Length / 2

		self.Wireframe:AddLine(Origin - forward, Origin + forward)
		self.Wireframe:AddLine(Origin - right, Origin + right)
		self.Wireframe:AddLine(Origin - up, Origin + up)
	end
	
	function DrawText(self, Origin: Vector3, Scale: number, Text: string, MaxDistance: number?): ()
		local distance = (camera.CFrame.Position - Origin).Magnitude
		if MaxDistance and distance > MaxDistance then return end
		self.Wireframe:AddText(Origin, Text, Scale * 10)
	end
	
	function DrawArrow(self, Origin: Vector3, Direction: Vector3, Length: number, Width: number): ()
		local endPoint = Origin + Direction.Unit * Length

		self.Wireframe:AddLine(Origin, endPoint)
		self:DrawCone(CFrame.new(endPoint, Origin) * CFrame.Angles(math.rad(180), 0, 0), Width, Width, 5)
	end
	
	function DrawCFrame(self, Transform: CFrame, Length: number): ()
		
		local originalColor = self.Wireframe.Color3
		local origin = Transform.Position

		local forward = Transform.LookVector
		local up = Transform.UpVector
		local right = Transform.RightVector

		self:SetColor(Color3.new(0, 0, 1))
		self.Wireframe:AddLine(origin + forward * Length, origin)

		self:SetColor(Color3.new(1, 0, 0))
		self.Wireframe:AddLine(origin + right * Length, origin)

		self:SetColor(Color3.new(0, 1, 0))
		self.Wireframe:AddLine(origin + up * Length, origin)

		self:SetColor(originalColor)
	end
	
	function DrawArc(self, Transform: CFrame, Radius: number, Angle: number, Sides: number): ()
		if Sides < 1 then return end
		
		local center = Transform.Position
		local points = table.create(Sides + 1) :: {Vector3}
		local halfAngle = math.rad(Angle) / 2
		
		for index = 0, Sides do
			
			local theta = -halfAngle + (index / Sides) * (halfAngle * 2)
			points[index + 1] = Transform:PointToWorldSpace(Vector3.new(math.sin(theta) * Radius, math.cos(theta) * Radius, 0))
		end
		
		for index = 1, Sides do
			self:DrawTriangle(Transform.Position, points[index], points[index + 1])
		end
	end
	
	function DrawMesh(self, Transform: CFrame, Scale: Vector3, MeshContent: Content): ()
		
		local mesh = AssetService:CreateEditableMeshAsync(MeshContent, {FixedSize = true})
		
		for _, faceId in mesh:GetFaces() do
			
			local vertices = mesh:GetFaceVertices(faceId)
			
			local pointA: Vector3 = Transform:PointToWorldSpace(mesh:GetPosition(vertices[1]) * Scale)
			local pointB: Vector3 = Transform:PointToWorldSpace(mesh:GetPosition(vertices[2]) * Scale)
			local pointC: Vector3 = Transform:PointToWorldSpace(mesh:GetPosition(vertices[3]) * Scale)
			
			self:DrawTriangle(pointA, pointB, pointC)
		end
		
		mesh:Destroy()
	end
	
	function DrawImage(self, Transform: CFrame, Scale: number, ImageContent: Content, Threshold: number?): ()
		Threshold = Threshold or 0.5
		
		local image = AssetService:CreateEditableImageAsync(ImageContent)
		local pixels = image:ReadPixelsBuffer(Vector2.zero, image.Size)
		
		local width = image.Size.X
		local height = image.Size.Y
		
		local sampleWidth = width
		local sampleHeight = height
		
		local largestDimension = math.max(width, height)
		if largestDimension > 50 then
			
			local scaleFactor = 50 / largestDimension
			sampleWidth = math.max(1, math.floor(width * scaleFactor))
			sampleHeight = math.max(1, math.floor(height * scaleFactor))
		end
		
		for y = 0, sampleHeight - 1 do
			for x = 0, sampleWidth - 1 do

				local imageX = math.floor(x * width / sampleWidth)
				local imageY = math.floor(y * height / sampleHeight)

				local index = (imageY * width + imageX) * 4
				
				local alpha = buffer.readu8(pixels, index + 3) / 255
				if alpha > Threshold then
					
					local localPosition = Vector3.new((x / sampleWidth - 0.5) * Scale, (0.5 - y / sampleHeight) * Scale, 0)
					self:DrawPoint(Transform:PointToWorldSpace(localPosition), 0.05)
				end
			end
		end
		
		image:Destroy()
	end
	
	function DrawPath(self, Points: {Vector3}): ()
		
		local count = #Points
		if count < 2 then return end
		
		self.Wireframe:AddPath(Points, false)
	end
	
	function DrawBezierCurve(self, Points: {Vector3}): ()
		
		local count = #Points
		if count < 2 then return end

		local segments = math.max(8, count * 8)
		local prev = Bezier(Points, 0)

		for index = 1, segments do

			local alpha = index / segments
			local curr = Bezier(Points, alpha)

			self:DrawLine(prev, curr)
			prev = curr
		end
	end

	function SetColor(self, Color: Color3): ()
		self.Wireframe.Color3 = Color
	end

	function SetThickness(self, Thickness: number): ()
		self.Wireframe.Thickness = Thickness
	end
	
	function SetTransparency(self, Transparency: number): ()
		self.Wireframe.Transparency = Transparency
	end
	
	function SetEnabled(self, Enabled: boolean): ()
		self.Wireframe.Visible = Enabled
	end
	
	function Clear(self): ()
		self.Wireframe.Transparency = TRANSPARENCY
		self.Wireframe.Thickness = THICKNESS
		self.Wireframe.Color3 = COLOR
		self.Wireframe:Clear()
	end
	
	function Destroy(self): ()
		table.clear(self)
	end
end

return Object
