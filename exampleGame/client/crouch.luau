local inputMap = require(script.Parent.inputMap)

local camera = workspace.CurrentCamera
local normalHipHeight = nil
local crouching = false

local function crouch(dt)
    if not camera.CameraSubject then
        return
    end
    if not normalHipHeight then
        normalHipHeight = camera.CameraSubject.HipHeight
    end

    if not inputMap.crouch:pressed() then
        return
    end

    crouching = not crouching 
    camera.CameraSubject.HipHeight = normalHipHeight * if crouching then 0.5 else 1
    camera.CameraSubject.WalkSpeed = if crouching then 6 else 16
end

return crouch