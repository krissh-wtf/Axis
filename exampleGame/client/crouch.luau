local inputMap = require(script.Parent.inputMap)

local camera = workspace.CurrentCamera
local normalHipHeight = nil

local function crouch(dt)
    if not camera.CameraSubject then
        return
    end
    if not normalHipHeight then
        normalHipHeight = camera.CameraSubject.HipHeight
    end

    if not inputMap.crouch:changed() then
        return
    end

    local crouching = inputMap.crouch:pressing() -- we want a boolean so we use pressing()

    -- camera.CameraSubject.HipHeight = normalHipHeight * if crouching then 0.5 else 1
    camera.CameraSubject.WalkSpeed = if crouching then 6 else 16
end

return crouch