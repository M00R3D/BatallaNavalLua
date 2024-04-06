-- main.lua
local boardModule = require("board")
local constants = require("constants")

local board
local boardSize = 9
local tileSize = 50

function love.load()
    board = boardModule.createBoard(boardSize)
end

function love.update(dt)
    -- No hay necesidad de actualizar en este juego, dejar vacío
end

function love.draw()
    for y = 1, boardSize do
        for x = 1, boardSize do
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

function love.mousepressed(x, y, button)
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
