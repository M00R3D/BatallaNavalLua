-- main.lua
local boardModule = require("board")
local input = require("input")
local constants = require("constants")
local Hud = require("hud") -- Importar el módulo Hud
local Boat = require("boat")

local board1
local board2
local boardSize = 9
local tileSize = 32
local margin = 10
local spriteMar
local boats = {} 
local hud -- Variable para almacenar el objeto Hud
local selectedSize = 1 -- Tamaño de barco seleccionado por defecto
local rotation = 0 -- Orientación del barco (0 para horizontal, 1 para vertical)
local boatPlaced = {false, false, false, false} -- Bandera para cada tamaño de barco

function love.load()
    board1 = boardModule.createBoard(boardSize)
    board2 = boardModule.createBoard(boardSize)
    spriteMar = love.graphics.newImage("mar.png")

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

    -- Dibujar el espacio que ocupará el barco antes de colocarlo
    if selectedSize > 0 then
        local mouseX, mouseY = love.mouse.getPosition()
        local gridX = math.floor(mouseX / tileSize) + 1
        local gridY = math.floor(mouseY / tileSize) + 1

        love.graphics.setColor(0, 0, 0, 100)  -- Color negro con transparencia
        if rotation == 0 then -- Barco horizontal
            for i = 1, selectedSize do
                local posX = (gridX + i - 2) * tileSize
                local posY = (gridY - 1) * tileSize
                love.graphics.rectangle("fill", posX, posY, tileSize, tileSize)
            end
        else -- Barco vertical
            for i = 1, selectedSize do
                local posX = (gridX - 1) * tileSize
                local posY = (gridY + i - 2) * tileSize
                love.graphics.rectangle("fill", posX, posY, tileSize, tileSize)
            end
        end
    end

    -- Dibujar los barcos en el primer océano según el tamaño seleccionado
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
    -- Verificar si el clic está dentro del tablero 1
    if x <= boardSize * tileSize and y <= boardSize * tileSize then
        local gridX = math.floor(x / tileSize) + 1
        local gridY = math.floor(y / tileSize) + 1

        -- Verificar si no hay otro barco en esa posición o si el tamaño ya ha sido creado
        if not boatPlaced[selectedSize] then
            local newBoat = Boat:new(gridX, gridY, selectedSize, rotation)
            table.insert(boats, newBoat)
            boatPlaced[selectedSize] = true
        else
            -- Buscar y recolocar el barco del mismo tamaño
            for _, boat in ipairs(boats) do
                if boat.size == selectedSize then
                    boat.x = gridX
                    boat.y = gridY
                    boat.orientation = rotation
                    break
                end
            end
        end
    end

    -- Manejar clics en la Hud
    local sizeOptions = {1, 2, 3, 4}
    for i, size in ipairs(sizeOptions) do
        local posX = hud.x + (i - 1) * hud.tileSize * 2
        local posY = hud.y
        local tileSize = hud.tileSize * 2
        if x >= posX and x <= posX + tileSize and y >= posY and y <= posY + tileSize then
            selectedSize = size
            break
        end
    end
end

function love.wheelmoved(x, y)
    if y > 0 then -- Rueda del mouse hacia arriba
        rotation = 0 -- Orientación horizontal
    elseif y < 0 then -- Rueda del mouse hacia abajo
        rotation = 1 -- Orientación vertical
    end
end
