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

local Collisions = require(path.to.module)

-- Vertex positions
local pointA: number
local pointB: number
local pointC: number

local capsulePosition: Vector3
local capsuleRadius = 1.5 / 2
local capsuleHeight = 4.2 / 2

local colliderMin = position - Vector3.new(capsuleRadius, capsuleHeight, capsuleRadius)
local colliderMax = position + Vector3.new(capsuleRadius, capsuleHeight, capsuleRadius)

local normal = Collisions.PointsToNormal(pointA, pointB, pointC)
local minBounds, maxBounds = Collisions.PointsToBounds(pointA, pointB, pointC)

local intersecting = Collisions.AABBToAABB(colliderMin, colliderMax, minBounds, maxBounds)
if intersecting then return end

local hitPosition, hitNormal, Depth = Collisions.CapsuleToTriangle(
	capsulePosition + Vector3.new(0, capsuleHeight, 0),
	capsulePosition - Vector3.new(0, capsuleHeight, 0),
	capsuleRadius, pointA, pointB, pointC
)

print(hitPosition, hitNormal, Depth)
