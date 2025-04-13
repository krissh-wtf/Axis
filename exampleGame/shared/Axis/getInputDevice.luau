local match = require(script.Parent.match)
local previousInputDevice = "Desktop"

local function getInputDevice(input: { Name: string } | Enum.UserInputType): string
	local result = match(input.Name) {
		"Gamepad1", "Gamepad",
		"Gamepad2", "Gamepad",
		"Gamepad3", "Gamepad",
		"Gamepad4", "Gamepad",
		"Gamepad5",  "Gamepad",
		"Gamepad6", "Gamepad",
		"Gamepad7", "Gamepad",
		"Gamepad8", "Gamepad",
		"Touch", "Touch",
		"MouseButton1", "Desktop",
		"MouseButton2", "Desktop",
		"MouseButton3", "Desktop",
		"MouseMovement", "Desktop",
		"MouseWheel", "Desktop",
		"Keyboard", "Desktop"
	}
	previousInputDevice = result or previousInputDevice
	return previousInputDevice
end

return getInputDevice