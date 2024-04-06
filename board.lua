-- board.lua
local constants = require("constants")

local M = {}

function M.createBoard(size)
    local board = {}
    for y = 1, size do
        board[y] = {}
        for x = 1, size do
            board[y][x] = constants.EMPTY
        end
    end
    return board
end

function M.drawBoard(board, tileSize)
    for y = 1, #board do
        for x = 1, #board[y] do
            local posX = (x - 1) * tileSize
            local posY = (y - 1) * tileSize
            
            if board[y][x] == constants.EMPTY then
                love.graphics.setColor(0, 0, 255)  -- Agua
            elseif board[y][x] == constants.SHIP then
                love.graphics.setColor(100, 100, 100)  -- Barco sin golpear
            elseif board[y][x] == constants.SHIP_HIT then
                love.graphics.setColor(255, 0, 0)  -- Barco golpeado
            elseif board[y][x] == constants.WATER_HIT then
                love.graphics.setColor(150, 150, 255)  -- Agua golpeada
            end
            love.graphics.rectangle("fill", posX, posY, tileSize, tileSize)
        end
    end
end

return M
