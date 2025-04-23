local Client = game:GetService("Players").LocalPlayer
local inputMap = require(script.Parent.inputMap)

local gui = Client:WaitForChild("PlayerGui"):WaitForChild("JumpBar")
local camera = workspace.CurrentCamera
local jumpHoldTime = 0

local MAX_JUMP_CHARGE = 1 -- seconds
local MINIMUM_JUMP_PERCENTAGE = 0.3
local JUMP_CHARGE_RATE = 2 -- exponent
local JUMP_POWER = 100

local function getJumpPower()
    return JUMP_POWER * (
        (1 - MINIMUM_JUMP_PERCENTAGE) * math.pow(
            math.min(jumpHoldTime, MAX_JUMP_CHARGE) / MAX_JUMP_CHARGE,
            JUMP_CHARGE_RATE
        ) + MINIMUM_JUMP_PERCENTAGE
    )
end

local function jump(deltaTime) 
    if not camera.CameraSubject then
        return
    end

    local humanoid: Humanoid = camera.CameraSubject
    humanoid.UseJumpPower = true

    gui.Outer.Inner.Size = UDim2.fromScale(math.pow(
        math.min(jumpHoldTime or 0, MAX_JUMP_CHARGE) / MAX_JUMP_CHARGE, JUMP_CHARGE_RATE
    ), 1)
    -- if the player is swimming or falling or climbing, reset jump power
    if humanoid:GetState() ~= Enum.HumanoidStateType.Running then
        jumpHoldTime = 0
        return
    end

    if inputMap.jump:released() then -- When the jump axis changed and is not held any more
        humanoid.JumpPower = getJumpPower()
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        jumpHoldTime = 0
        return
    end

    humanoid.JumpPower = 0
    jumpHoldTime = inputMap.jump:pressing() and (jumpHoldTime or 0) + deltaTime
end

return jump