Tile = Class{}

local varietyOdds = {[1] = 0,[2] = 3,[3] = 9,[4] = 14,[5] = 24}
local colors = {[1] = 6, [2] = 8, [3] = 10, [4] = 11, [5] = 13, [6] = 16, [7] = 1, [8] =  5}

function Tile:init(x, y)
    self.gridX = x
    self.gridY = y

    self.x = (x - 1) * 32
    self.y = (y - 1) * 32

    self.variety = 1

    local varietyRoll = math.random(0,99)
    
    local rollingOdds = 0
    for i, odds in pairs(varietyOdds) do
        rollingOdds = rollingOdds + odds + gLevel
        if varietyRoll <= rollingOdds then
            self.variety = self.variety + i
            break
        end
    end

    local availableColors = math.min(#colors, 4 + math.floor(gLevel / 3))
    self.color = math.random(availableColors)
end


function Tile:update(dt)

end


function Tile:render(x, y)
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
end