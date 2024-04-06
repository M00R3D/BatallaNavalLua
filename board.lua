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

return M
