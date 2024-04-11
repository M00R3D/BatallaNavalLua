-- hud.lua
local Hud = {}

function Hud:new(x, y, tileSize)
    local newHud = {
        x = x,
        y = y,
        tileSize = tileSize,
        selectedSize = 1, -- Tamaño de barco seleccionado por defecto
        shipSprites = {}, -- Tabla para almacenar los sprites de los barcos
        buttonX = x + 220, -- Posición X del botón
        buttonY = y + 120, -- Posición Y del botón
        buttonWidth = 100, -- Ancho del botón
        buttonHeight = 40, -- Altura del botón
        buttonText = "Click me!", -- Texto del botón
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
    local sizeOptions = {
        {name = "Portaviones", size = 1},
        {name = "Acorazado", size = 2},
        {name = "Crucero", size = 3},
        {name = "Submarino", size = 3},
        {name = "Destructor", size = 2}
    } -- Opciones de tamaño de barco disponibles

    for i, option in ipairs(sizeOptions) do
        local posX = self.x
        local posY = self.y + (i - 1) * self.tileSize * 2
        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle("line", posX, posY, self.tileSize * 2, self.tileSize * 2)
        love.graphics.print(option.name, posX + self.tileSize * 0.5, posY + self.tileSize * 0.5)

        -- Dibujar el sprite del barco
        local sprite = self.shipSprites[option.size]
        if sprite then
            love.graphics.draw(sprite, posX + self.tileSize * 3, posY, 0, self.tileSize * 2 / sprite:getWidth(), self.tileSize * 2 / sprite:getHeight())
        end
    end

    -- Resaltar el tamaño de barco seleccionado
    local selectedPosY = self.y + (self.selectedSize - 1) * self.tileSize * 2
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("line", self.x, selectedPosY, self.tileSize * 2, self.tileSize * 2)

    -- Dibujar el botón
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.buttonX, self.buttonY, self.buttonWidth, self.buttonHeight)
    love.graphics.printf(self.buttonText, self.buttonX, self.buttonY + 10, self.buttonWidth, "center")
end

function Hud:setSelectedSize(selectedSize)
    self.selectedSize = selectedSize
end

function Hud:setShipSprites(shipSprites)
    self.shipSprites = shipSprites
end

-- Función para verificar si se ha hecho clic en el botón
function Hud:isButtonClicked(mouseX, mouseY)
    return mouseX >= self.buttonX and mouseX <= self.buttonX + self.buttonWidth and
           mouseY >= self.buttonY and mouseY <= self.buttonY + self.buttonHeight
end

return Hud
