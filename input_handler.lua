-- input_handler.lua

local Boat = require("Boat")
local input = require("input") -- Agrega esta línea

local input_handler = {}

function input_handler.handleMousePressed(x, y, button, boats, boardSize, tileSize, selectedSize, rotation, boatPlaced, hud)
    if x <= boardSize * tileSize and y <= boardSize * tileSize then
        local gridX = math.floor(x / tileSize) + 1
        local gridY = math.floor(y / tileSize) + 1

        if not boatPlaced[selectedSize] then
            local newBoat = Boat:new(gridX, gridY, selectedSize, rotation)
            if not input.isBoatOutOfBounds(newBoat) and not input.isBoatOverlapping(newBoat, boats) then
                table.insert(boats, newBoat)
                boatPlaced[selectedSize] = true
            end
        else
            for _, boat in ipairs(boats) do
                if boat.size == selectedSize then
                    boat.x = gridX
                    boat.y = gridY
                    boat.orientation = rotation
                    if not input.isBoatOutOfBounds(boat) and not input.isBoatOverlapping(boat, boats) then
                        break
                    else
                        boat.x = boat.x - 1
                        if input.isBoatOutOfBounds(boat) or input.isBoatOverlapping(boat, boats) then
                            boat.x = boat.x + 2
                            if input.isBoatOutOfBounds(boat) or input.isBoatOverlapping(boat, boats) then
                                boat.x = boat.x - 1
                                boat.y = boat.y - 1
                                if input.isBoatOutOfBounds(boat) or input.isBoatOverlapping(boat, boats) then
                                    boat.y = boat.y + 2
                                    if input.isBoatOutOfBounds(boat) or input.isBoatOverlapping(boat, boats) then
                                        boat.y = boat.y - 1
                                    end
                                end
                            end
                        end
                    end
                    break
                end
            end
        end
    end

    local sizeOptions = {1, 2, 3, 4, 5}
    for i, size in ipairs(sizeOptions) do
        local posY = hud.y + (i - 1) * hud.tileSize * 2
        local tileSize = hud.tileSize * 2
        if y >= posY and y <= posY + tileSize then
            selectedSize = size
            break
        end
    end

    love.graphics.setColor(255, 255, 255, 255)
end

return input_handler
