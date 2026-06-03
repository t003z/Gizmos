# Gizmos

A Roblox Gizmos module designed for debugging

## Functions

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

- SetColor
- SetThickness
- SetTransparency
- SetEnabled

- Clear
- Destroy

## Usage

```lua

local gizmo = Gizmo.new()

gizmo:DrawSphere(
	CFrame.new(0, 5, 0),
	5,
	32
)

gizmo:DrawRay(
	Vector3.zero,
	Vector3.yAxis,
	10,
	1
)

gizmo:DrawText(
	Vector3.new(0, 10, 0),
	1,
	"Hello World"
)
