local axis: any = nil

local input = axis.input

type DeviceType = "Desktop" | "Touch" | "Controller"
local device = axis.device() :: DeviceType
--[[

DEFINE ALL SENSITIVITY IN ACTIONS
HAVE AXIS AND INPUTS
- any axis dimension should always have a value between -1 and 1

-- AXIS LIBRARY
device -> returns current device if no inputtype is provided, else gets device of inputtype
input -> defines input axis


-- INPUT OBJECT
read -> return current sum
pressing -> interpret current sum as boolean (value ~= 0)
pressed -> if was not pressed last frame, and pressing this frame
released -> if was pressed last frame, and not pressing this frame
changed -> if sum of inputs last frame was different from this frame
hold -> creates temporary axis on input that is a certain value until release function is called

map -> set all input axes
getMap -> get all input axes

]]

return { -- inputmap.luau
    block = input { Enum.KeyCode.F, Enum.KeyCode.T },
    dodge = input { [Enum.KeyCode.Q] = 1 },
    zoom = input {
        [Enum.KeyCode.I] = 1,
        [Enum.KeyCode.O] = -1,
        Enum.UserInputType.MouseWheel,
    },
    move = input {
        [Enum.KeyCode.W] = Vector2.new(0, 1),
        [Enum.KeyCode.S] = Vector2.new(0, -1),
        [Enum.KeyCode.A] = Vector2.new(-1, 0),
        [Enum.KeyCode.D] = Vector2.new(1, 0),
        Enum.KeyCode.Thumbstick1,
    }
}

--[[

local inputAxes = {
	move = {
		VirtualAxis2d.wasd(),
		VirtualAxis2d.new({ up = Enum.KeyCode.ButtonR2, down = Enum.KeyCode.ButtonL2 })
	},
	zoom = {
		Enum.UserInputType.MouseWheel,
		VirtualAxis.new({
			negative = Enum.KeyCode.DPadDown,
			positive = Enum.KeyCode.DPadUp
		}),
		VirtualAxis.new({
			positive = Enum.KeyCode.I,
			negative = Enum.KeyCode.O
		})
	},
	drag = {Enum.UserInputType.MouseMovement, Enum.KeyCode.Thumbstick2},
	dragHold = {Enum.UserInputType.MouseButton2},
	skipRadio = {Enum.KeyCode.G, Enum.KeyCode.DPadLeft},
}

]]