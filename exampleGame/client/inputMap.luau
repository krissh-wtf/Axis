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
		[Enum.KeyCode.DPadDown] = -2,
		[Enum.KeyCode.DPadUp] = 2,
		[Enum.KeyCode.I] = 2,
		[Enum.KeyCode.O] = -2,
		[Enum.UserInputType.MouseWheel] = 10,  
    },
	drag = input {
        Enum.UserInputType.MouseMovement,
        Enum.KeyCode.Thumbstick2,
		[Enum.KeyCode.Left] = vector.create(-2, 0),
		[Enum.KeyCode.Right] = vector.create(2, 0),
    },
	dragHold = input {
        Enum.UserInputType.MouseButton2
    },
}

return inputMap