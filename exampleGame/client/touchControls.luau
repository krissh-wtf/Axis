local Client = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local inputMap = require(script.Parent.inputMap)

local gui = Client:WaitForChild("PlayerGui"):WaitForChild("TouchControls")

-- example of touch controls
local crouching = false
local crouchButton = gui:WaitForChild("crouch")

crouchButton.MouseButton1Down:Connect(function()
    inputMap.crouch:move(1) -- by default the hold value is 1
    crouching = not crouching
    if not crouching then
        crouchButton.UIStroke.Thickness = 0
        crouchButton.Icon.ImageColor3 = Color3.new(1, 1, 1)
        crouchButton.Icon.Size = UDim2.fromScale(0.8, 0.8)
        return
    end
    crouchButton.UIStroke.Thickness = 2
    crouchButton.Icon.ImageColor3 = Color3.fromRGB(252, 255, 80)
    crouchButton.Icon.Size = UDim2.fromScale(0.7, 0.7)
end)

local releaseJump, touch = nil, nil
local jumpButton = gui:WaitForChild("jump")

-- I am listening to input differently so that mobile users can drag while holding the button
jumpButton.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
        input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    if input.UserInputState ~= Enum.UserInputState.Begin then
        return
    end
    print("starting jump")
    touch = input
    releaseJump = inputMap.jump:hold() -- by default the hold value is 1
    jumpButton.UIStroke.Thickness = 2
    jumpButton.Icon.ImageColor3 = Color3.fromRGB(252, 255, 80)
    jumpButton.Icon.Size = UDim2.fromScale(0.7, 0.6)
end)

UserInputService.InputEnded:Connect(function(input)
    if not releaseJump or input ~= touch or input.UserInputState ~= Enum.UserInputState.End then
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
        input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    print("releasing jump")
    releaseJump() -- release/destroy the hold when you want to disable it
    releaseJump = nil
    jumpButton.UIStroke.Thickness = 0
    jumpButton.Icon.ImageColor3 = Color3.new(1, 1, 1)
    jumpButton.Icon.Size = UDim2.fromScale(0.8, 0.7)
end)

return {}