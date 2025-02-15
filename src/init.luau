local types = require("types")
local axis = {
   device = nil
}

function axis:update(inputs) 
   for _, input in inputs do
      input:update()
   end
end

function axis:clear()
   
end

return axis :: types.axis