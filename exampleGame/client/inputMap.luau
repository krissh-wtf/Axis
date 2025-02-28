local UserInputService = game:GetService("UserInputService")
local Axis = require(game.ReplicatedStorage.Axis)
local input = Axis.input

-- It's encouraged to store your input objects in a map in their own script

local inputMap = {
    crouch = input {
        Enum.KeyCode.C,
        Enum.KeyCode.LeftControl,
        Enum.KeyCode.RightControl,
        Enum.KeyCode.ButtonR3, -- pressing on the right thumbstick will crouch!
    },
    jump = input {
        Enum.KeyCode.Space,
        Enum.KeyCode.ButtonA,
    },
}

return inputMap