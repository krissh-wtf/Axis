local types = require("types")

-- TODO: clamp in read?
local function read(input)
    return input.current, input.previous --clamp this?
end

-- TODO: benchmark type() vs typeof() on both numbers and vectors
local function pressing(input)
    local value = read(input)
    local magnitude = if type(value) == "number" then value else value.Magnitude
    return magnitude ~= 0
end

local function changed(input)
    return input.current ~= input.previous
end

local function pressed(input)
    return changed(input) and pressing(input)
end

local function released(input)
    return changed(input) and not pressing(input)
end

local function hold(input, value)

end

local function reset(input)
    --reset custom values (ex: mouse delta, mouse wheel)
end

--[[
local function onInputBeganOrEnded(inputObject)
    local keyCode = inputObject.KeyCode

    if Inputs.MOUSE_BUTTONS[inputObject.UserInputType] then
        state.mouseButtons[inputObject.UserInputType] = inputObject.UserInputState == Enum.UserInputState.Begin
    elseif Inputs.GAMEPAD_BUTTONS[keyCode] then
        local gamepad = inputObject.UserInputType

        gamepadButtons[keyCode][gamepad] = inputObject.UserInputState == Enum.UserInputState.Begin
    elseif keyCode ~= Enum.KeyCode.Unknown then
        state.keycodes[keyCode] = inputObject.UserInputState == Enum.UserInputState.Begin
    end
end

local function onInputChanged(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
        state.mouseDelta = Vector2.new(inputObject.Delta.X, -inputObject.Delta.Y)
    elseif inputObject.UserInputType == Enum.UserInputType.MouseWheel then
        state.mouseWheel = inputObject.Position.Z
    elseif inputObject.KeyCode == Enum.KeyCode.Thumbstick1 or inputObject.KeyCode == Enum.KeyCode.Thumbstick2 then
        local gamepad = inputObject.UserInputType

        state.gamepadThumbsticks[inputObject.KeyCode][gamepad] =
            Vector2.new(inputObject.Position.X, inputObject.Position.Y)
    end
end

UserInputService.InputBegan:Connect(function(inputObject, sunk)
    if not sunk then
        onInputBeganOrEnded(inputObject)
    end
end)
UserInputService.InputEnded:Connect(onInputBeganOrEnded)
UserInputService.InputChanged:Connect(onInputChanged)
]]

local function map(input, keyMap)
    --disconnect previous connections
    for _, connection in input do
        connection:Disconnect()
    end

    --set up connections
    for inputType, value in keyMap do
        if type(inputType) == "number" then -- { Enum.KeyCode.MouseWheel }
            inputType = value
            value = 1 -- maybe get other values and set magnitude to 1
        end

                


    end
end

local function update(input)
    -- set last frame
    input.previous = input.current

    -- get current frame
    local result = nil
    for _, value in input.active do
        if not result then
            result = value
            continue
        end
        result += value
    end
    input.current = result
end

local function new(inputMap)
    local input = {
        vector = nil :: true?, -- should we do something like this to tell if it's a vector or not?
        previous = nil,
        frame = nil,
        active = {
            
        },
        connections = {},
        inputMap = inputMap,
        mouseWheel = 0,
        keycodes = {},
        mouseButtons = {},
        mouseDelta = Vector2.zero,
        gamepadThumbsticks = {
            [Enum.KeyCode.Thumbstick1] = {},
            [Enum.KeyCode.Thumbstick2] = {},
        },


        read = read,
        pressing = pressing,
        pressed = pressed,
        released = released,
        changed = changed,
        hold = hold,
        map = map,
        update = update,
        reset = reset
    }
    map(input, map)

    return input
end

return new :: types.Input