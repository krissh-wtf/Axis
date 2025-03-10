local UserInputService = game:GetService("UserInputService")

local types = require(script.Parent.types)
local match = require(script.Parent.match)

local MAXIMUM_GAMEPADS = 8
local NEXT_HOLD_INDEX = 1

local function _reset(input, controller, inputType)
    table.insert(input.resets, {controller, inputType, false})
end

-- TODO: clamp in read?
local function read(input, controller: number?)
    local default = if input.vector then vector.zero else 0
    return input.current[controller or 1] or default, input.previous[controller or 1] or default
end

-- TODO: benchmark type() vs typeof() on both numbers and vectors
local function pressing(input, controller: number?)
    local value = read(input, controller)
    local magnitude = if input.vector then value.Magnitude else value
    return magnitude ~= 0
end

local function changed(input, controller: number?)
    return input.current[controller or 1] ~= input.previous[controller or 1]
end

local function pressed(input, controller: number?)
    return changed(input, controller) and pressing(input, controller)
end

local function released(input, controller: number?)
    return changed(input, controller) and not pressing(input, controller)
end

local function hold(input, value, controller: number?)
    local id = NEXT_HOLD_INDEX
    NEXT_HOLD_INDEX += 1
    input.active[controller or 1][id] = value or 1
    return function()
        input.active[controller or 1][id] = nil
    end
end

local function move(input, value, controller: number?)
    local id = NEXT_HOLD_INDEX
    NEXT_HOLD_INDEX += 1
    input.active[controller or 1][id] = value or 1
    _reset(input, controller or 1, id)
end

--[[
local function onInputBeganOrEnded(inputObject)
    local keyCode = inputObject.KeyCode

    if Inputs.MOUSE_BUTTONS[inputObject.UserInputType] then
        state.mouseButtons[inputObject.UserInputType] = inputObject.UserInputState == Enum.UserInputState.Begin
    elseif Inputs.GAMEPAD_BUTTONS[keyCode] then
        local gamepad = inputObject.UserInputType

        gamepadButtons[keyCode][    ] = inputObject.UserInputState == Enum.UserInputState.Begin
    elseif keyCode ~= Enum.KeyCode.Unknown then
        state.keycodes[keyCode] = inputObject.UserInputState == Enum.UserInputState.Begin
    end
end

local function onInputChanged(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
        state.mouseDelta = vector.create(inputObject.Delta.X, -inputObject.Delta.Y)
    elseif inputObject.UserInputType == Enum.UserInputType.MouseWheel then
        state.mouseWheel = inputObject.Position.Z
    elseif inputObject.KeyCode == Enum.KeyCode.Thumbstick1 or inputObject.KeyCode == Enum.KeyCode.Thumbstick2 then
        local gamepad = inputObject.UserInputType

        state.gamepadThumbsticks[inputObject.KeyCode][gamepad] =
            vector.create(inputObject.Position.X, inputObject.Position.Y)
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
    for _, connection in input.connections do
        connection:Disconnect()
    end
    input.vector = false
    input.inputMap = keyMap

    --set up connections
    local group =  {}
    for index, value in keyMap do
        local inputType = if type(index) == "number" then value else index
        value = if type(index) == "number" then 1 else value
        keyMap[index] = nil
        keyMap[inputType] = value

        if type(value) ~= "number" then -- assuming vector, else invalid input value
            input.vector = true
        end

        if inputType == Enum.UserInputType.MouseMovement then
            table.insert(input.connections, UserInputService.InputChanged:Connect(function(inputObject)
                if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
                    input.active[1][inputType] = vector.create(inputObject.Delta.X, -inputObject.Delta.Y)
                end
            end))
        elseif inputType == Enum.UserInputType.MouseWheel then
            table.insert(input.connections, UserInputService.InputChanged:Connect(function(object)
                if object.UserInputType ~= Enum.UserInputType.MouseWheel then
                    return
                end
                local position = object.Position.Z
                input.active[1][inputType] = position * value
                _reset(input, 1, inputType)
            end))
        elseif inputType == Enum.KeyCode.Thumbstick1 or inputType == Enum.KeyCode.Thumbstick2 then
            -- TODO: connect to thumbsticks and multiply their position by value
        elseif inputType == UserInputService.TouchSwipe then
            table.insert(input.connections, inputType:Connect(function(direction: Enum.SwipeDirection)
                input.active[1][inputType] = match(direction) {
                    Enum.SwipeDirection.Left, vector.create(-1, 0),
                    Enum.SwipeDirection.Right, vector.create(1, 0),
                    Enum.SwipeDirection.Up, vector.create(0, 1),
                    Enum.SwipeDirection.Down, vector.create(0, -1),
                }
            end))
        elseif inputType == UserInputService.TouchPinch then
            table.insert(input.connections, inputType:Connect(function(_, scale, _, state, sunk)
                if state == Enum.UserInputState.End then
                    input.active[1][inputType] = nil
                    return
                end
                input.active[1][inputType] = scale
            end))
        else
            table.insert(group, inputType)
        end
    end

    local inputBeganOrEnded = function(inputObject, sunk)
        if sunk then
            return
        end

        local controller = 1
        for i = 2, MAXIMUM_GAMEPADS do
            if inputObject.UserInputType == Enum.UserInputType[`Gamepad{i}`] then
                input.active[i] = input.active[i] or {}
                controller = i
                break
            end
        end

        local active = input.active[controller]
        for _, enum in group do
            if inputObject.KeyCode ~= enum and inputObject.UserInputType ~= enum then
                continue
            end

            active[enum] = if inputObject.UserInputState ~= Enum.UserInputState.End then
                keyMap[enum] else nil
        end
    end
    table.insert(input.connections, UserInputService.InputBegan:Connect(inputBeganOrEnded))
    table.insert(input.connections, UserInputService.InputEnded:Connect(inputBeganOrEnded))
end

local function update(input)
    -- reset old values
    for i, reset in input.resets do
        if not reset[3] then
            reset[3] = true
            continue
        end
        input.active[reset[1]][reset[2]] = nil
        input.resets[i] = nil
    end

    -- iterate through all controllers
    for i, set in input.active do
        -- set last frame
        input.previous[i] = input.current[i]

        local result = nil -- sum current values
		for key, value in set do
			if not result then
				result = value
				continue
			end
			result += value
		end

        input.current[i] = result
    end
end

local function new(inputMap)
    local input = {
        vector = false,
        current = {} :: { any },
        previous = {} :: { any },
        frame = nil,
        active = {
            {}, -- separate input axes for each controller
        },
        resets = {} :: {number | any}, --resets input on next update
        connections = {},
        inputMap = inputMap,
        mouseWheel = 0,
        keycodes = {},
        mouseButtons = {},
        mouseDelta = vector.zero,
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
        move = move,
    }
    map(input, inputMap)

    return input
end

return new :: types.InputConstructor