TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.mouse.wasPressed(1) then
    ---if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(flippyFont)
    love.graphics.printf('Flippy Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end