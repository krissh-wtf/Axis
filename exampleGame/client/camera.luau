local UserInputService = game:GetService("UserInputService")
local Axis = require(game.ReplicatedStorage.Axis)
local Spring = require(script.Parent.Spring)

-- create input objects in each system if you'd like!
local zoom = Axis.input {
    [Enum.KeyCode.I] = 1,
    [Enum.KeyCode.O] = -1,
    [Enum.UserInputType.MouseWheel] = 70, -- Scroll to zoom, needs heavier weight
    [UserInputService.TouchPinch] = 1, -- Pinch to zoom
}


local zoomSpring = Spring.new(20, 16, 0.5)
local camera = workspace.CurrentCamera
local HEIGHT = Vector3.yAxis * 1
local OFFSET = Vector3.new(8, 10, 8).Unit
local MIN_ZOOM = 10
local MAX_ZOOM = 40


local function cameraSystem(dt)
    if not camera.CameraSubject then
        return
    end

    zoom:update() -- reevaluate input values
	local current, previous = zoom:read() -- read values as numbers with specified weights
	
    local newZoom = math.clamp(
        zoomSpring.Position - (current * 120 * dt),
        MIN_ZOOM, MAX_ZOOM
    )

    zoomSpring.Target = newZoom
    camera.CameraType = Enum.CameraType.Scriptable
    local position = camera.CameraSubject.Parent:GetPivot().Position + HEIGHT

    camera.CFrame = CFrame.lookAt(position + (OFFSET * zoomSpring.Position), position)
    camera.Focus = CFrame.new(position)
end

return cameraSystem