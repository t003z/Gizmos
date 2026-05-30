-- CONSTANTS
const THICKNESS = 2
const COLOR = Color3.new(1, 1, 1)

-- Storage
local storage = workspace:FindFirstChild("Gizmos") or Instance.new("Folder")
storage.Name = "Gizmos"
storage.Parent = workspace

-- Player
local camera = workspace.CurrentCamera :: Camera

-- Object
class Gizmo
	
	-- Private
	public _wireframe: WireframeHandleAdornment
	
	-- Create a new Gizmo
	function new(): Gizmo
		local self = Gizmo {}
		
		self._wireframe = Instance.new("WireframeHandleAdornment")
		self._wireframe.Color3 = COLOR
		self._wireframe.Thickness = THICKNESS
		self._wireframe.Visible = true
		self._wireframe.Adornee = workspace
		self._wireframe.Name = "Gizmo"
		self._wireframe.Parent = storage
		
		return self
	end
	
	-- Draw a circle
	function DrawCircle(self, Cframe: CFrame, Width: number, Sides: number): ()
		if Sides < 3 then return end
		
		local radius = Width / 2
		local points = table.create(Sides)
		
		for index = 0, Sides - 1 do
			
			local theta = (index / Sides) * math.pi * 2
			local point = Vector3.new(math.cos(theta) * radius, math.sin(theta) * radius, 0)
			points[index + 1] = Cframe:PointToWorldSpace(point)
		end
		
		self._wireframe:AddPath(points, true)
	end
	
	-- Draws a semi circle
	function DrawSemiCircle(self, Cframe: CFrame, Width: number, Sides: number, Connected: boolean?): ()
		if Sides < 2 then return end
		
		local radius = Width / 2
		local points = table.create(Sides + 1)
		
		for index = 0, Sides do

			local theta = (index / Sides) * math.pi
			local point = Vector3.new(math.cos(theta) * radius, math.sin(theta) * radius, 0)
			points[index + 1] = Cframe:PointToWorldSpace(point)
		end
		
		self._wireframe:AddPath(points, false)
		
		if not Connected then return end
		self._wireframe:AddLine(points[1], points[#points])
	end
	
	-- Draws a sphere
	function DrawSphere(self, Cframe: CFrame, Width: number, Sides: number): ()
		
		self:DrawCircle(Cframe, Width, Sides)
		self:DrawCircle(Cframe * CFrame.Angles(0, math.rad(90), 0), Width, Sides)
		self:DrawCircle(Cframe * CFrame.Angles(math.rad(90), 0, 0), Width, Sides)
	end
	
	-- Draws a hemisphere
	function DrawHemiSphere(self, Cframe: CFrame, Width: number, Sides: number, Connected: boolean?): ()
		
		self:DrawSemiCircle(Cframe, Width, Sides / 2)
		self:DrawSemiCircle(Cframe * CFrame.Angles(0, math.rad(90), 0), Width, Sides / 2)
		
		if not Connected then return end
		self:DrawCircle(Cframe * CFrame.Angles(math.rad(90), 0, 0), Width, Sides)
	end
	
	-- Draws a capsule
	function DrawCapsule(self, Cframe: CFrame, Width: number, Height: number): ()
		
		local radius = Width / 2
		local height = Height / 2
		
		self:DrawCircle(Cframe * CFrame.Angles(math.rad(90), 0, 0), Width, 32)
		
		self:DrawHemiSphere(Cframe * CFrame.new(0, height - radius, 0), Width, 32, true)
		self:DrawHemiSphere(Cframe * CFrame.new(0, -height + radius, 0) * CFrame.Angles(math.rad(180), 0, 0), Width, 32, true)
		
		self._wireframe:AddLine(Cframe * CFrame.new(radius, height - radius, 0).Position, Cframe * CFrame.new(radius, -height + radius, 0).Position)
		self._wireframe:AddLine(Cframe * CFrame.new(-radius, height - radius, 0).Position, Cframe * CFrame.new(-radius, -height + radius, 0).Position)
		self._wireframe:AddLine(Cframe * CFrame.new(0, height - radius, radius).Position, Cframe * CFrame.new(0, -height + radius, radius).Position)
		self._wireframe:AddLine(Cframe * CFrame.new(0, height - radius, -radius).Position, Cframe * CFrame.new(0, -height + radius, -radius).Position)
	end
	
	-- Draw a line
	function DrawLine(self, From: Vector3, To: Vector3): ()
		self._wireframe:AddLine(From, To)
	end
	
	-- Draws a triangle
	function DrawTriangle(self, PointA: Vector3, PointB: Vector3, PointC: Vector3): ()
		self._wireframe:AddLine(PointA, PointB)
		self._wireframe:AddLine(PointB, PointC)
		self._wireframe:AddLine(PointC, PointA)
	end
	
	-- Draws a cube
	function DrawCube(self, Cframe: CFrame, Size: Vector3): ()
		
		local half = Size * 0.5
		
		local p000 = Cframe * Vector3.new(-half.X, -half.Y, -half.Z)
		local p001 = Cframe * Vector3.new(-half.X, -half.Y,  half.Z)
		local p010 = Cframe * Vector3.new(-half.X,  half.Y, -half.Z)
		local p011 = Cframe * Vector3.new(-half.X,  half.Y,  half.Z)
		
		local p100 = Cframe * Vector3.new( half.X, -half.Y, -half.Z)
		local p101 = Cframe * Vector3.new( half.X, -half.Y,  half.Z)
		local p110 = Cframe * Vector3.new( half.X,  half.Y, -half.Z)
		local p111 = Cframe * Vector3.new( half.X,  half.Y,  half.Z)
		
		self:DrawLine(p000, p001)
		self:DrawLine(p001, p101)
		self:DrawLine(p101, p100)
		self:DrawLine(p100, p000)
		
		self:DrawLine(p010, p011)
		self:DrawLine(p011, p111)
		self:DrawLine(p111, p110)
		self:DrawLine(p110, p010)
		
		self:DrawLine(p000, p010)
		self:DrawLine(p001, p011)
		self:DrawLine(p101, p111)
		self:DrawLine(p100, p110)
	end
	
	-- Draws a square
	function DrawSquare(self, Cframe: CFrame, Height: number, Width: number): ()
		
		local halfWidth = Width * 0.5
		local halfHeight = Height * 0.5

		local a = Cframe:PointToWorldSpace(Vector3.new(-halfWidth, 0, -halfHeight))
		local b = Cframe:PointToWorldSpace(Vector3.new( halfWidth, 0, -halfHeight))
		local c = Cframe:PointToWorldSpace(Vector3.new( halfWidth, 0,  halfHeight))
		local d = Cframe:PointToWorldSpace(Vector3.new(-halfWidth, 0,  halfHeight))

		self._wireframe:AddLine(a, b)
		self._wireframe:AddLine(b, c)
		self._wireframe:AddLine(c, d)
		self._wireframe:AddLine(d, a)
	end
	
	-- Draws a pyramid
	function DrawPyramid(self, Cframe: CFrame, Width: number, Height: number, Sides: number): ()
		if Sides < 3 then return end
		
		local radius = Width / 2
		local apex = Cframe.Position + Cframe.LookVector * Height
		
		local vertices = table.create(Sides)
		
		for index = 1, Sides do
			
			local theta = ((index - 1) / Sides) * math.pi * 2
			vertices[index] = Cframe:PointToWorldSpace(Vector3.new(math.cos(theta) * radius, math.sin(theta) * radius, 0))
		end
		
		for index = 1, Sides do
			
			local current = vertices[index]
			local next = vertices[(index % Sides) + 1]
			self._wireframe:AddLine(current, next)
		end
		
		for index = 1, Sides do
			self._wireframe:AddLine(vertices[index], apex)
		end
	end
	
	-- Draws a ray arrow
	function DrawRay(self, Origin: Vector3, Direction: Vector3, Length: number, HeadWidth: number): ()
		
		local forward = Direction.Unit
		local endPoint = Origin + forward * Length
		
		self._wireframe:AddLine(Origin, endPoint)
		
		self:DrawPyramid(CFrame.new(Origin, Origin + forward) * CFrame.Angles(math.rad(180), 0, 0), HeadWidth, HeadWidth, 5)
	end
	
	-- Draws a point
	function DrawPoint(self, Point: Vector3, Length: number): ()
		
		local forward = Vector3.zAxis * Length / 2
		local right = Vector3.xAxis * Length / 2
		local up = Vector3.yAxis * Length / 2
		
		self._wireframe:AddLine(Point - forward, Point + forward)
		self._wireframe:AddLine(Point - right, Point + right)
		self._wireframe:AddLine(Point - up, Point + up)
	end
	
	-- Draws a CFrame axis
	function DrawCFrame(self, Cframe: CFrame, Length: number): ()
		
		local origin = Cframe.Position
		
		local forward = Cframe.LookVector
		local up = Cframe.UpVector
		local right = Cframe.RightVector
		
		local originalColor = self._wireframe.Color3
		
		self:SetColor(Color3.new(0, 0, 1))
		self._wireframe:AddLine(origin + forward * Length, origin)
		
		self:SetColor(Color3.new(1, 0, 0))
		self._wireframe:AddLine(origin + right * Length, origin)
		
		self:SetColor(Color3.new(0, 1, 0))
		self._wireframe:AddLine(origin + up * Length, origin)
		
		self:SetColor(originalColor)
	end
	
	-- Draws a star
	function DrawStar(self, Cframe: CFrame, Width: number, InnerWidth: number, Points: number): ()
		if Points < 2 then return end
	
		local radius = Width / 2
		local innerRadius = InnerWidth / 2
		
		local vertices = table.create(Points * 2)
		
		for index = 0, Points * 2 - 1 do
			
			local theta = (index / (Points * 2)) * math.pi * 2
			local radius2 = (index % 2 == 0) and radius or innerRadius

			vertices[index + 1] = Cframe:PointToWorldSpace(Vector3.new(math.cos(theta) * radius2, 0,math.sin(theta) * radius2))
		end
		
		for index = 1, #vertices do
			
			local current = vertices[index]
			local next = vertices[(index % #vertices) + 1]
			self._wireframe:AddLine(current, next)
		end
	end
	
	-- Draws text
	function DrawText(self, Point: Vector3, Size: number, Text: string, MaxDistance: number?): ()
		local distance = (camera.CFrame.Position - Point).Magnitude
		if MaxDistance and distance > MaxDistance then return end
		
		self._wireframe:AddText(Point, Text, Size * 10)
	end
	
	-- Set the color of the Gizmo
	function SetColor(self, Color: Color3): ()
		self._wireframe.Color3 = Color
	end
	
	-- Set the thickness of the Gizmo
	function SetThickness(self, Thickness: number): ()
		self._wireframe.Thickness = Thickness
	end
	
	-- Set enabled state of the Gizmo
	function SetEnabled(self, Enabled: boolean): ()
		self._wireframe.Visible = Enabled
	end
	
	-- Clears the Gizmo
	function Clear(self): ()
		self._wireframe:Clear()
		self._wireframe.Color3 = COLOR
		self._wireframe.Thickness = THICKNESS
	end
end
return Gizmo
