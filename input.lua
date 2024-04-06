-- input.lua
local constants = require("constants")

local M = {}

function M.handleMousePressed(x, y, board, boardSize, tileSize)
    local gridX = math.floor(x / tileSize) + 1
    local gridY = math.floor(y / tileSize) + 1
    
    if gridX >= 1 and gridX <= boardSize and gridY >= 1 and gridY <= boardSize then
        if board[gridY][gridX] == constants.EMPTY then
            board[gridY][gridX] = constants.WATER_HIT
        elseif board[gridY][gridX] == constants.SHIP then
            board[gridY][gridX] = constants.SHIP_HIT
        end
    end
end

return M
