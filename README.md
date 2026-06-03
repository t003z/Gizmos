# Gizmos

A Roblox Gizmos module designed for debugging

## Draw functions

- DrawCircle
- DrawSemiCircle
- DrawSphere
- DrawHemisphere
- DrawTorus
- DrawCapsule
- DrawCone
- DrawStar
- DrawTriangle
- DrawQuad
- DrawNgon
- DrawCube
- DrawSquare
- DrawLine
- DrawPoint
- DrawText
- DrawArrow
- DrawCFrame
- DrawArc
- DrawMesh
- DrawImage
- DrawPath
- DrawBezierCurve

## Visual functions

- SetColor
- SetThickness
- SetTransparency
- SetEnabled

## Misc functions

- Clear
- Destroy

## Usage

```lua

gizmo:DrawStar(CFrame.new(0, 10, 0), 3, 1, 5)
gizmo:DrawCapsule(CFrame.new(0, 10, 0), 1, 2)
gizmo:DrawCFrame(CFrame.new(0, 10, 0), 0.5)

gizmo:DrawNgon({
	Vector3.new(-2, 1, 0),
	Vector3.new(0, 1, 0),
	Vector3.new(0, 2, 0),
	Vector3.new(2, 0, 0),
	Vector3.new(0, -2, 0),
	Vector3.new(0, -1, 0),
	Vector3.new(-2, -1, 0)
})

gizmo:DrawBezierCurve({
	Vector3.new(-5, 0, -3),
	Vector3.new(-2, 6, 3),
	Vector3.new(2, -6, -3),
	Vector3.new(5, 0, 3)
})
