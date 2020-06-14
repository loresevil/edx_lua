ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.mouse.wasPressed(1) then
---    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function ScoreState:render()
    love.graphics.setFont(flippyFont)
    love.graphics.printf('Oof! You Lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Click Mouse to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end