-- input.lua
local boardModule = require("board")
local constants = require("constants")

local function handleMouseClick(board, x, y)
    local tileSize = 50
    local gridX = math.floor(x / tileSize) + 1
    local gridY = math.floor(y / tileSize) + 1
    
    if gridX >= 1 and gridX <= #board and gridY >= 1 and gridY <= #board then
        -- Cambiar el estado de la casilla dependiendo del estado actual
        if board[gridY][gridX] == constants.EMPTY then
            board[gridY][gridX] = constants.WATER_HIT
        elseif board[gridY][gridX] == constants.SHIP then
            board[gridY][gridX] = constants.SHIP_HIT
        end
    end
end

return {
    handleMouseClick = handleMouseClick
}
