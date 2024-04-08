-- main.lua
local boardModule = require("board")
local input = require("input")
local constants = require("constants")
local Boat = require("boat")
local Hud = require("hud") -- Importar el módulo Hud

local board1
local board2
local boardSize = 9
local tileSize = 32
local margin = 10
local spriteMar
local boats = {} 

local hud -- Variable para almacenar el objeto Hud

function love.load()
    board1 = boardModule.createBoard(boardSize)
    board2 = boardModule.createBoard(boardSize)
    spriteMar = love.graphics.newImage("mar.png")

    -- Crear un barco en el tablero 1
    local boat1 = Boat:new(1, 1, 3, 0) -- Barco horizontal de tamaño 3
    table.insert(boats, boat1)

    -- Crear un barco en el tablero 2
    local boat2 = Boat:new(5, 5, 2, 1) -- Barco vertical de tamaño 2
    table.insert(boats, boat2)

    -- Inicializar el objeto Hud
    hud = Hud:new(10, 400, 20) -- Posición inicial y tamaño de los botones en el HUD
end

function love.update(dt)
    -- No hay necesidad de actualizar en este juego, dejar vacío
end

function love.draw()
    -- Dibujar el primer tablero
    for y = 1, boardSize do
        for x = 1, boardSize do
            local posX = (x - 1) * tileSize
            local posY = (y - 1) * tileSize
            
            if board1[y][x] == constants.EMPTY then
                love.graphics.setColor(0, 0, 255)  -- Agua
            elseif board1[y][x] == constants.SHIP then
                love.graphics.setColor(100, 100, 100)  -- Barco sin golpear
            elseif board1[y][x] == constants.SHIP_HIT then
                love.graphics.setColor(255, 0, 0)  -- Barco golpeado
            elseif board1[y][x] == constants.WATER_HIT then
                love.graphics.setColor(150, 150, 255)  -- Agua golpeada
            end
            love.graphics.draw(spriteMar, posX, posY, 0, tileSize/spriteMar:getWidth(), tileSize/spriteMar:getHeight())
        end
    end

    -- Dibujar el objeto Hud
    hud:draw()

    for _, boat in ipairs(boats) do
        if boat.orientation == 0 then -- Barco horizontal
            for i = 1, boat.size do
                local posX = (boat.x + i - 2) * tileSize
                local posY = (boat.y - 1) * tileSize
                love.graphics.setColor(0, 0, 0)  -- Color negro
                love.graphics.rectangle("fill", posX, posY, tileSize, tileSize)
            end
        else -- Barco vertical
            for i = 1, boat.size do
                local posX = (boat.x - 1) * tileSize
                local posY = (boat.y + i - 2) * tileSize
                love.graphics.setColor(0, 0, 0)  -- Color negro
                love.graphics.rectangle("fill", posX, posY, tileSize, tileSize)
            end
        end
    end

    -- Dibujar el segundo tablero al lado derecho del primero
    for y = 1, boardSize do
        for x = 1, boardSize do
            local posX = boardSize * tileSize + margin + (x - 1) * tileSize
            local posY = (y - 1) * tileSize
            
            if board2[y][x] == constants.EMPTY then
                love.graphics.setColor(255, 255, 0)  -- Otro color
            elseif board2[y][x] == constants.SHIP then
                love.graphics.setColor(200, 200, 0)  -- Otro color para barcos
            elseif board2[y][x] == constants.SHIP_HIT then
                love.graphics.setColor(255, 150, 0)  -- Otro color para barcos golpeados
            elseif board2[y][x] == constants.WATER_HIT then
                love.graphics.setColor(200, 200, 255)  -- Otro color para agua golpeada
            end
            love.graphics.draw(spriteMar, posX, posY, 0, tileSize/spriteMar:getWidth(), tileSize/spriteMar:getHeight())
        end
    end
end

function love.mousepressed(x, y, button)
    input.handleMouseClick(board1, x, y)
    input.handleMouseClick(board2, x - (boardSize * tileSize + margin), y)

    -- Manejar clics en el Hud
    local sizeOptions = {1, 2, 3, 4}
    for i, size in ipairs(sizeOptions) do
        local posX = hud.x + (i - 1) * hud.tileSize * 2
        local posY = hud.y
        local width = hud.tileSize * 2
        local height = hud.tileSize * 2

        if x >= posX and x <= posX + width and y >= posY and y <= posY + height then
            -- Si se hace clic en un botón del Hud, se establece el tamaño seleccionado
            hud:setSelectedSize(size)
            break
        end
    end
end
