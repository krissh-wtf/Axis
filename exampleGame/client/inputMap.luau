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
	zoom = input {
		Enum.UserInputType.MouseWheel,
		[Enum.KeyCode.DPadDown] = -1,
		[Enum.KeyCode.DPadUp] = 1,
		[Enum.KeyCode.I] = 1,
		[Enum.KeyCode.O] = -1,   
    },
	drag = input {
        Enum.UserInputType.MouseMovement,
        Enum.KeyCode.Thumbstick2
    },
	dragHold = input {
        Enum.UserInputType.MouseButton2
    },
}

return inputMap