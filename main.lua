-- main.lua
local boardModule = require("board")
local constants = require("constants")
local input = require("input")

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
    boardModule.drawBoard(board, tileSize)
end

function love.mousepressed(x, y, button)
    input.handleMousePressed(x, y, board, boardSize, tileSize)
end
