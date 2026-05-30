# Gizmos

A Roblox Gizmos module designed for debugging

## Features

- Circles
- Semi Circles
- Spheres
- Hemispheres
- Capsules
- Lines
- Triangles
- Cubes
- Squares
- Pyramids
- Rays / Arrows
- Points
- CFrame Axes
- Stars
- Text

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
