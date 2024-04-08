-- hud.lua
local Hud = {}

function Hud:new(x, y, tileSize)
    local newHud = {
        x = x,
        y = y,
        tileSize = tileSize,
        selectedSize = 1, -- Tamaño de barco seleccionado por defecto
    }
    setmetatable(newHud, self)
    self.__index = self
    return newHud
end

function Hud:update(dt)
    -- Aquí puedes agregar lógica para manejar eventos de entrada
end

function Hud:draw()
    -- Dibujar el HUD
    local sizeOptions = {1, 2, 3, 4} -- Opciones de tamaño de barco disponibles

    for i, size in ipairs(sizeOptions) do
        local posX = self.x + (i - 1) * self.tileSize * 2
        local posY = self.y
        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle("line", posX, posY, self.tileSize * 2, self.tileSize * 2)
        love.graphics.print("Size: " .. size, posX + self.tileSize * 0.5, posY + self.tileSize * 0.5)
    end

    -- Resaltar el tamaño de barco seleccionado
    local selectedPosX = self.x + (self.selectedSize - 1) * self.tileSize * 2
    local selectedPosY = self.y
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("line", selectedPosX, selectedPosY, self.tileSize * 2, self.tileSize * 2)
end

function Hud:setSelectedSize(selectedSize)
    self.selectedSize = selectedSize
end

return Hud
