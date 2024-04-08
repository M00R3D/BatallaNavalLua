-- boat.lua
local Boat = {}

function Boat:new(x, y, size, orientation)
    local newBoat = {
        x = x,
        y = y,
        size = size,
        orientation = orientation, -- 0 para horizontal, 1 para vertical
        hits = {}, -- Almacenar los impactos en el barco
    }
    setmetatable(newBoat, self)
    self.__index = self
    return newBoat
end

function Boat:isHit(x, y)
    for i, hit in ipairs(self.hits) do
        if hit.x == x and hit.y == y then
            return true
        end
    end
    return false
end

function Boat:hit(x, y)
    table.insert(self.hits, {x = x, y = y})
end

return Boat
