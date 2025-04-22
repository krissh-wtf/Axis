--!optimize 2
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local Spring = require(ReplicatedStorage.Spring)
local inputMap = require(script.Parent.inputMap)

local camera = workspace.CurrentCamera
local PLAYER_SNAP = vector.create(0, 1.5, 0)
local MIN_ZOOM = 6
local MAX_ZOOM = 80

local pitch, yaw = 0, 0
local rotateCFrame = CFrame.Angles(0, 0, 0)
local snapVector = Spring.new(PLAYER_SNAP, 16, 0.5)
local offsetVector = Spring.new(vector.create(0, 0, 13), 16, 0.5)

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.RespectCanCollide = true
raycastParams.IgnoreWater = true

local function clampZoom(zoom: number): number
	return math.clamp(offsetVector.Position.Z - zoom, MIN_ZOOM, MAX_ZOOM)
end

local function cameraSystem(delta)
	local humanoid = camera.CameraSubject
	if not humanoid then
		return
	end

	-- getting inputs and positions
	local pivot = humanoid.RootPart:GetPivot()
	local current = inputMap.drag:read()
	local drag = -current / 2
	local holding = inputMap.dragHold:pressing()
	local zoom = inputMap.zoom:read()

	-- setting behavior
	camera.CameraType = Enum.CameraType.Scriptable
	UserInputService.MouseBehavior = Enum.MouseBehavior[if holding then "LockCurrentPosition" else "Default"]
	snapVector.Target = PLAYER_SNAP

	-- angle math
	yaw -= -drag.X
	pitch -= drag.Y
	pitch = math.clamp(pitch, -75, 75)
	rotateCFrame = CFrame.Angles(0, math.rad(yaw), 0)
		* CFrame.Angles(math.rad(pitch), 0, 0)

	-- calculating positions of camera
	offsetVector.Target = vector.create(0, 0, clampZoom(zoom))
	local height = CFrame.new((pivot * CFrame.new(snapVector.Position)).Position)
	local cframe = CFrame.lookAt(
		(height * rotateCFrame):PointToWorldSpace(offsetVector.Position),
		height.Position
	)

	-- raycasting
	raycastParams.FilterDescendantsInstances = CollectionService:GetTagged("CameraExclude")
	local collision: RaycastResult? = workspace:Raycast(height.Position, cframe.Position - height.Position, raycastParams)
	if collision then
		cframe -= cframe.Position - collision.Position
	end

	--finalize
	camera.Focus = pivot
	camera.CFrame = cframe
end

return cameraSystem