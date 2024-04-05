-- Variables para almacenar el estado de cada casilla
local EMPTY = 0
local SHIP = 1
local SHIP_HIT = 2
local WATER_HIT = 3

local board = {}  -- Tablero del juego
local boardSize = 9
local tileSize = 50

function love.load()
    -- Inicializar el tablero
    for y = 1, boardSize do
        board[y] = {}
        for x = 1, boardSize do
            board[y][x] = EMPTY  -- Inicialmente todas las casillas están vacías
        end
    end
end

function love.update(dt)
    
end

function love.draw()
    for y = 1, boardSize do
        for x = 1, boardSize do
            local posX = (x - 1) * tileSize
            local posY = (y - 1) * tileSize
            
            -- Dibujar las casillas del tablero
            if board[y][x] == EMPTY then
                love.graphics.setColor(0, 0, 255)  -- Agua
                love.graphics.rectangle("fill", posX, posY, tileSize, tileSize)
            elseif board[y][x] == SHIP then
                love.graphics.setColor(100, 100, 100)  -- Barco sin golpear
                love.graphics.rectangle("fill", posX, posY, tileSize, tileSize)
            elseif board[y][x] == SHIP_HIT then
                love.graphics.setColor(255, 0, 0)  -- Barco golpeado
                love.graphics.rectangle("fill", posX, posY, tileSize, tileSize)
            elseif board[y][x] == WATER_HIT then
                love.graphics.setColor(150, 150, 255)  -- Agua golpeada
                love.graphics.rectangle("fill", posX, posY, tileSize, tileSize)
            end
        end
    end
end

function love.mousepressed(x, y, button)
    -- Convertir las coordenadas del mouse a coordenadas de la cuadrícula
    local gridX = math.floor(x / tileSize) + 1
    local gridY = math.floor(y / tileSize) + 1
    
    -- Verificar que las coordenadas estén dentro del rango válido
    if gridX >= 1 and gridX <= boardSize and gridY >= 1 and gridY <= boardSize then
        -- Cambiar el estado de la casilla dependiendo del estado actual
        if board[gridY][gridX] == EMPTY then
            board[gridY][gridX] = WATER_HIT
        elseif board[gridY][gridX] == SHIP then
            board[gridY][gridX] = SHIP_HIT
        end
    end
end

