PlayState = Class { __includes = BaseState }

function PlayState:enter(params)
    self.paddle = params.paddle
    self.ball = params.ball
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score


    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

    --self.paused = false
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then
        self.ball.y = self.ball.y - 8
        self.ball.dy = - self.ball.dy

        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end

        gSounds['paddle-hit']:play()
    end

    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            brick:hit()
            self.score = self.score + 10

            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - self.ball.width
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - self.ball.width
            else
                self.ball.dy = - self.ball.dy
                self.ball.y = brick.y + (self.ball.width * 2)
            end

            self.ball.dy = self.ball.dy * 1.02
            break
      end
    end

    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end


    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)


    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end
