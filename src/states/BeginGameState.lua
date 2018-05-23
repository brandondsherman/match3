BeginGameState = Class{__includes = BaseState}

function BeginGameState:init(par)
    self.transitionAlpha = 255
    self.board = Board(VIRTUAL_WIDTH - 272, 16)
    self.levelLabelY = -64
end

function BeginGameState:enter(par)
    
    
    Chain(
        Timer.tween(1, {[self] = {transitionAlpha = 0}}),
        Timer.tween(.25, {[self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 8}}),
        Timer.tween(.25, {[self] = {levelLabelY = VIRTUAL_HEIGHT + 30}}),
        gStateMachine:change('play', {
            board = self.board
        })
    )
end

function BeginGameState:update(dt)
    
end

function BeginGameState:render()
    self.board:render()
    love.graphics.setColor(95, 205, 228, 200)
    love.graphics.rectangle('fill', 0, self.levelLabelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(gLevel),
        0, self.levelLabelY, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255, 255, 255, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function BeginGameState:exit(par)

end