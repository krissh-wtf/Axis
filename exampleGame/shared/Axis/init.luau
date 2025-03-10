local UserInputService = game:GetService("UserInputService")
local types = require(script.types)
local constructor = require(script.input)
local getInputDevice = require(script.getInputDevice)
local Axis = {
   input = constructor,
}

function Axis.update(inputs)
   for _, input in inputs do
      input:update()
   end
end

function Axis.device(input)
   return getInputDevice(input or UserInputService:GetLastInputType())
end

function Axis.clear()
   --forgot what the point of this was
   -- - clears all input mappings?
   -- - clears all input states?
end

return Axis :: types.Axis