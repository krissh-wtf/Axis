--!optimize 2
--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local Spring = require(ReplicatedStorage.Spring)
local inputMap = require(script.Parent.inputMap)
local axis = require(ReplicatedStorage.Axis)

local camera = workspace.CurrentCamera

local PLAYER_SNAP = vector.create(0, 1.5, 0)
local pitch, yaw = 0, 0
local rotateCFrame = CFrame.Angles(0, 0, 0)
local snapVector = Spring.new(PLAYER_SNAP, 16, 0.5)
local offsetVector = Spring.new(vector.create(0, 0, 13), 16, 0.5)

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.RespectCanCollide = true
raycastParams.IgnoreWater = true

local dragged = 0
local MIN_ZOOM = 6--0.5
local MAX_ZOOM = 80
local ZOOM_SPEED = {
	Touch = 5,
	Gamepad = 2,
	Desktop = 10,
}

local function cameraSystem(delta)
	local humanoid = camera.CameraSubject
	if not humanoid then
		return
	end
	local pivot = humanoid.RootPart:GetPivot()
	local current = inputMap.drag:read()
	-- print("crrnt", current)
	local drag = -current / 2
	local holding = inputMap.dragHold:pressing()
	camera.CameraType = Enum.CameraType.Scriptable
	UserInputService.MouseBehavior = Enum.MouseBehavior[if holding then "LockCurrentPosition" else "Default"]
	dragged = if drag == 0 or drag.Magnitude ~= 0 or holding then os.clock() else dragged
	
	snapVector.Target = PLAYER_SNAP

	--angle math
	yaw -= -drag.X
	pitch -= drag.Y
	pitch = math.clamp(pitch, -75, 75)
	rotateCFrame = CFrame.Angles(0, math.rad(yaw), 0)
		* CFrame.Angles(math.rad(pitch), 0, 0)

	local height = CFrame.new((pivot * CFrame.new(snapVector.Position)).Position)
	camera.CFrame = CFrame.lookAt(
		(height * rotateCFrame):PointToWorldSpace(offsetVector.Position),
		height.Position
	)
	camera.Focus = pivot

	raycastParams.FilterDescendantsInstances = CollectionService:GetTagged("CameraExclude")
	local collision: RaycastResult? = workspace:Raycast(height.Position, camera.CFrame.Position - height.Position, raycastParams)
	if collision then
		camera.CFrame -= camera.CFrame.Position - collision.Position
	end
	local zoom = inputMap.zoom:read()
	offsetVector.Target = vector.create(
		0,
		0,
		math.clamp(offsetVector.Position.Z - zoom 
			* ZOOM_SPEED[axis.device(UserInputService:GetLastInputType())],
			MIN_ZOOM, MAX_ZOOM
		)
	)
end

return cameraSystem