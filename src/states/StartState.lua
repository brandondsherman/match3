StartState = Class{__includes = BaseState}



function StartState:init(par)

    self.highlighted = 0
    self.menuOptions = {
        [1] = {text = 'Start', 
                func = function()
                    Timer.tween(1, {
                        [self] = {transitionAlpha = 255}
                    }):finish(function()
                            gStateMachine:change('begin-game') 
                        end)
                end
        },
        [2] = {text = 'Quit Game', 
                func = function()
                    love.event.quit()
                end
        }
    }
    self.menuOptionsSize = table.size(self.menuOptions)

    self.colors = {
        [1] = {217, 87, 99, 255},
        [2] = {95, 205, 228, 255},
        [3] = {251, 242, 54, 255},
        [4] = {118, 66, 138, 255},
        [5] = {153, 229, 80, 255},
        [6] = {223, 113, 38, 255}
    }

    
    self.letterTable = {
        {letter = 'M', x = -108},
        {letter = 'A', x = -64},
        {letter = 'T', x = -28},
        {letter = 'C', x = 2},
        {letter = 'H', x = 40},
        {letter = '3', x = 112}
    }

    self.colorTimer = Timer.every(0.075, function()
        self.colors[0] = self.colors[6]

        for i = 6, 1, -1 do
            self.colors[i] = self.colors[i - 1]
        end
    end)

    self.placeHolderBricks = {}
    for i = 1, 64 do
        table.insert(self.placeHolderBricks, gFrames['tiles'][math.random(18)][math.random(6)])
    end

    self.transitionAlpha = 0

    self.pauseInput = false

end


function StartState:enter(par)

end


function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if not self.pauseInput then
        if love.keyboard.wasPressed('up') then
            self.highlighted = (self.highlighted - 1) % self.menuOptionsSize
            --gEventHandler:alert('select')
        elseif love.keyboard.wasPressed('down') then
            self.highlighted = (self.highlighted + 1) % self.menuOptionsSize
            --gEventHandler:alert('select')
        end
            
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            self.menuOptions[self.highlighted + 1].func()
        end
        
    end
    
end


function StartState:render()
    self:drawPlacerHolders()
    

    -- keep the background and tiles a little darker than normal
    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self:drawMatch3Text(-60)
    self:drawMenuOptions(12)

    -- draw our transition rect; is normally fully transparent, unless we're moving to a new state
    love.graphics.setColor(255, 255, 255, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function StartState:drawPlacerHolders()
    for y = 1, 8 do
        for x = 1, 8 do
            love.graphics.setColor(0, 0, 0, 255)
            love.graphics.draw(gTextures['main'], self.placeHolderBricks[(y - 1) * x + x], 
                (x - 1) * 32 + 128 + 3, (y - 1) * 32 + 16 + 3)

            
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.draw(gTextures['main'], self.placeHolderBricks[(y - 1) * x + x], 
                (x - 1) * 32 + 128, (y - 1) * 32 + 16)
        end
    end
end

function StartState:drawMatch3Text(y)
    love.graphics.setColor(255,255,255,128)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT /2 + y - 11, 150, 58, 6)
    
    love.graphics.setFont(gFonts['large'])
    self:drawTextShadow('MATCH 3', VIRTUAL_HEIGHT / 2 + y)

    for i = 1, 6 do
        love.graphics.setColor(self.colors[i])
        love.graphics.printf(self.letterTable[i]['letter'], 0, VIRTUAL_HEIGHT / 2 + y, 
            VIRTUAL_WIDTH + self.letterTable[i]['x'], 'center')
    end
end

function StartState:drawTextShadow(text, y)
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, 'center')
end

function StartState:drawMenuOptions(y)
    love.graphics.setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y, 150, 29 * self.menuOptionsSize, 6)
    
    
    for i = 1, self.menuOptionsSize do
        love.graphics.setFont(gFonts['medium'])
        self:drawTextShadow(self.menuOptions[i].text, VIRTUAL_HEIGHT / 2 + y + 8 + ((i - 1) * 25))    
        if self.highlighted + 1 == i then
            love.graphics.setColor(99, 155, 255, 255)
            
        else
            love.graphics.setColor(48, 96, 130, 255)
        end
        
        love.graphics.printf(self.menuOptions[i].text, 0, VIRTUAL_HEIGHT / 2 + y + 8 + ((i - 1) * 25), VIRTUAL_WIDTH, 'center')
    end
end

function StartState:exit(par)
    self.colorTimer:remove()
end


