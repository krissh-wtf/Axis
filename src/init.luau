local UserInputService = game:GetService("UserInputService")
local types = require("./types")
local constructor = require("./input")
local getInputDevice = require("./getInputDevice")

--[=[
	@class Axis
	The Axis library used to define input axes, get devices, and update inputs
]=]
--[[
	@within Axis
	Creates a new input axis with the provided keymap
	```lua
	local attack = Axis.input {
		Enum.KeyCode.E,
		Enum.KeyCode.ButtonX,
	}
	```
]]
local Axis = {
   input = constructor,
}

--[[
	@within Axis
	Updates all the provided inputs as a shorthand
	```lua
	Axis.update(inputMap) 
	```
]]
function Axis.update(inputs: { [any]: types.Input<any> })
   for _, input in inputs do
      input:update()
   end
end

--[[
	@within Axis
	Gets the device of the provided UserInputType (or the last UserInputType if none is provided)
	```lua
	Axis.device() --gets device of last input
	```
]]
function Axis.device(input: Enum.UserInputType): types.DeviceType
   return getInputDevice(input or UserInputService:GetLastInputType())
end

return Axis :: types.Axis