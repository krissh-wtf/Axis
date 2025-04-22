local UserInputService = game:GetService("UserInputService")

local inputMap = require(script.Parent.inputMap)
local Camera = workspace.CurrentCamera

local PINCH_MULTI = 50
local TOUCH_MULTI = Vector2.new(0.00945 * math.pi, -0.003375 * math.pi) * 40

local touch: InputObject? = nil
local previousPos: Vector2 = Vector2.zero
local upperLeft: Vector2 = Vector2.zero
local lowerRight: Vector2 = Vector2.zero
local previousScale: number = 0
local hold: nil | () -> () = nil

local function toVector2(vec: Vector3) 
	return Vector2.new(vec.X, vec.Y) 
end

local function calculateBounds()
	local viewport = Camera.ViewportSize
	upperLeft = Vector2.new(
		-100,
		viewport.Y / 3
	)
	lowerRight = upperLeft + Vector2.new(
		(viewport.X * 0.4) + 100,
		(2 * viewport.Y / 3) + 100
	)
end
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(calculateBounds)
calculateBounds()

local function endPinch()
	previousScale = 0
end

--TODO: create a map of touches on TouchBegan that are processed/out of bounds
--	then remove them from the map when they are Ended
--	then use custom logic like the PlayerModule.CameraModule.CameraInput
--	in that custom logic, calculate the initial distance between the two
--	pinch touches and then do the same pinch math as here

UserInputService.TouchPinch:Connect(function(touches: { Vector2 }, scale, velocity, state, processed)
	if processed then
		endPinch()
		return
	end
	if state ~= Enum.UserInputState.Change then
		endPinch()
	else
		inputMap.zoom:move((scale - previousScale) * PINCH_MULTI)
	end
	previousScale = scale
end)

UserInputService.TouchStarted:Connect(function(newTouch, processed)
	if processed or touch then
		return
	end
	
	--CHECK BOUNDS
	local pos = toVector2(newTouch.Position)
	if pos.X > upperLeft.X and pos.Y > upperLeft.Y
		and pos.X < lowerRight.X and pos.Y < lowerRight.Y then
		return
	end
	
	touch, previousPos, hold = newTouch, pos, inputMap.dragHold:hold()
end)

UserInputService.TouchEnded:Connect(function(ending, processed)
	if ending ~= touch then
		return
	end
	hold()
	touch, hold = nil, nil
end)

local function mobileInput(delta)
	if not touch then
		return
	end
	local new = toVector2(touch.Position)
	new, previousPos = (new - previousPos) * TOUCH_MULTI, new
	inputMap.drag:move(new)
end

return mobileInput