---
title: Controller
description: Controller support guide
sidebar_position: 2
---

# Controller

If you have taken the time to read through the [API](../../api/Axis), you may have noticed that most methods have a `controller` parameter with the type of `number?`. Roblox supports up to 8 "gamepads" and as such, your game may experience up to 8 controllers (and you may want to support this by having different input axes for each controller).
```lua
local jump = Axis.input {
    Enum.KeyCode.Space, -- any other inputs will be treated as controller 1
    Enum.KeyCode.ButtonA,
}
```
In this example, let's say that we let 8 players play locally, each with their own character who may want to jump for whatever reason. You may write a system like this to handle each character:
```lua
local function jump()
    for i = 1, 8 do
        -- if standing on the ground ...
        if jump:pressed(i) then
            -- make their character jump
        end
    end
end
```
Remember that you can use [`UserInputService:GetConnectedGamepads()`](https://create.roblox.com/docs/reference/engine/classes/UserInputService#GetConnectedGamepads) to get the number of connected controllers. 
<br/>
Almost all methods allow you to specify a controller like this, even `move()`, `hold()`, and `read()`.
