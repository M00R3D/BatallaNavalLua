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
local boatPlaced = {false, false, false, false, false} -- Bandera para cada tamaño de barco
local switchTime = 1 -- Tiempo en segundos para cambiar entre los sprites de agua
local timer = 0 -- Contador de tiempo

local highlightColor = {255, 255, 0, 100} -- Amarillo semitransparente

-- Tamaños de los barcos en ancho
local boatWidths = {5, 4, 3, 3, 2} -- Anchura de los barcos

function love.load()
    board1 = boardModule.createBoard(boardSize)
    board2 = boardModule.createBoard(boardSize)
    spriteMar = love.graphics.newImage("sprite_water0.png")
    spriteMar1 = love.graphics.newImage("sprite_water1.png")
    spriteMar2 = love.graphics.newImage("sprite_water2.png")
    

    -- Cargar sprites de los barcos
    local shipSprites = {}
    shipSprites[1] = love.graphics.newImage("portaviones.png")
    shipSprites[2] = love.graphics.newImage("acorazado.png")
    shipSprites[3] = love.graphics.newImage("crucero.png")
    shipSprites[4] = love.graphics.newImage("submarino.png")
    shipSprites[5] = love.graphics.newImage("destructor.png")

    hud = Hud:new(10, 400, 20) -- Posición inicial y tamaño de los botones en el HUD
    hud:setShipSprites(shipSprites)
end

function love.update(dt)
    -- Actualizar el temporizador
    timer = timer + dt

    -- Cambiar el sprite de agua si el temporizador ha superado el tiempo de cambio
    if timer >= switchTime then
        timer = 0
        if spriteMar == spriteMar1 then
            spriteMar = spriteMar2
        else
            spriteMar = spriteMar1
        end
    end
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

    -- Dibujar el segundo tablero al lado derecho del primero
    local board2PosX = boardSize * tileSize + margin
    for y = 1, boardSize do
        for x = 1, boardSize do
            local posX = board2PosX + (x - 1) * tileSize
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

    -- Dibujar las casillas resaltadas donde se colocará el barco según la posición del mouse
    if selectedSize > 0 then
        local mouseX, mouseY = love.mouse.getPosition()
        local gridX = math.floor(mouseX / tileSize) + 1
        local gridY = math.floor(mouseY / tileSize) + 1

        -- Dibujar la casilla resaltada si está dentro de los límites del tablero
        if gridX <= boardSize - boatWidths[selectedSize] + 1 and gridY <= boardSize then
            love.graphics.setColor(highlightColor)
            local sizeX = boatWidths[selectedSize] * tileSize
            local sizeY = tileSize
            local posX = (gridX - 1) * tileSize
            local posY = (gridY - 1) * tileSize
            love.graphics.rectangle("fill", posX, posY, sizeX, sizeY)
        end
    end

    -- Dibujar los barcos en el primer océano según el tamaño seleccionado
    for _, boat in ipairs(boats) do
        local posX = (boat.x - 1) * tileSize
        local posY = (boat.y - 1) * tileSize
        local sprite = hud.shipSprites[boat.size]
        if sprite then
            love.graphics.setColor(255, 255, 255)  -- Color blanco
            love.graphics.draw(sprite, posX, posY)
        end
    end

    -- Dibujar el objeto Hud
    hud:draw()

    -- Imprimir los mensajes debajo del segundo tablero
    love.graphics.setColor(255, 255, 255)  -- Color blanco
    local messageY = (boardSize + 1) * tileSize + margin * 2
    for _, boat in ipairs(boats) do
        love.graphics.print("Barco de tamaño " .. boat.size .. " en (" .. boat.x .. ", " .. boat.y .. ")", board2PosX, messageY)
        messageY = messageY + 20 -- Ajustar la posición vertical para el próximo mensaje
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
    local sizeOptions = {1, 2, 3, 4, 5}
    for i, size in ipairs(sizeOptions) do
        local posY = hud.y + (i - 1) * hud.tileSize * 2
        local tileSize = hud.tileSize * 2
        if y >= posY and y <= posY + tileSize then
            selectedSize = size
            break
        end
    end

    -- Restablecer el color después de que se haya seleccionado un tamaño de barco
    love.graphics.setColor(255, 255, 255, 255)
end

function love.wheelmoved(x, y)
    if y > 0 then -- Rueda del mouse hacia arriba
        rotation = 0 -- Orientación horizontal
    elseif y < 0 then -- Rueda del mouse hacia abajo
        rotation = 1 -- Orientación vertical
    end
end
