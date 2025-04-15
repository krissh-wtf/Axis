local UserInputService = game:GetService("UserInputService")
local axis = require("../src")
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
read -> return current sum of all inputs
pressing -> interpret current sum as boolean (value ~= 0)
pressed -> if was not pressed last frame, and pressing this frame
released -> if was pressed last frame, and not pressing this frame
changed -> if sum of inputs last frame was different from this frame
hold -> creates temporary axis on input that is a certain value until release function is called

map -> set all input axes
getMap -> get all input axes

]]

local pickUp = input {
	Enum.KeyCode.E,
}

local pressing: boolean = pickUp:pressing()
local changed: boolean = pickUp:changed()

if pressing and changed then
	print("you picked up the item")
end

return { -- inputmap.luau
	block = input {
		Enum.KeyCode.F,
		Enum.KeyCode.T, --implicitly say that when F or T is pressed, the value is 1
	},
	dodge = input {
		[Enum.KeyCode.Q] = 1 --explicitly say that when Q is pressed, the value is 1
	},
	zoom = input {
		[Enum.KeyCode.I] = 1,
		[Enum.KeyCode.O] = -1, -- if O is pressed, the value of that input is -1
		Enum.UserInputType.MouseWheel, -- uses mouse wheel forward as 1 and backwards as -1
		--[Enum.UserInputType.MouseWheel] = -1, -- multiplies mouse wheel values by -1
	},
	move = input {
		[Enum.KeyCode.W] = Vector2.new(0, 1), --explicitly define W's value in two dimensions
		[Enum.KeyCode.S] = Vector2.new(0, -1),
		[Enum.KeyCode.A] = Vector2.new(-1, 0),
		[Enum.KeyCode.D] = Vector2.new(1, 0),
		Enum.KeyCode.Thumbstick1,
		--[Enum.KeyCode.Thumbstick1] = 0.5, -- multiplies thumbstick values by 0.5


		--Proposed syntax, not implemented as of v0.1
		[UserInputService.TouchSwipe] = function(swipeDirection, numberOfFingers)
			return Vector2.new(0, 0)
		end
	}
}