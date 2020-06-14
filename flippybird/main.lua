push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'
require 'states/CountdownState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('gfxassets/background.png')
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOPING_POINT = 413

local ground = love.graphics.newImage('gfxassets/ground.png')
local groundScroll = 0
local GROUND_SCROLL_SPEED = 60
local GROUND_LOOPING_POINT = 481

local scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Flippy Bird')

    smallFont = love.graphics.newFont('gfxassets/font.ttf', 8)
    mediumFont = love.graphics.newFont('gfxassets/flappy.ttf', 14)
    flippyFont = love.graphics.newFont('gfxassets/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('gfxassets/flappy.ttf', 56)
    love.graphics.setFont(flippyFont)

    sounds = {
        ['jump'] = love.audio.newSource('audioassets/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('audioassets/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('audioassets/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('audioassets/score.wav', 'static'),
        ['music'] = love.audio.newSource('audioassets/marios_way.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    ---love.keyboard.keysPressed = {}
    love.mouse.mousePressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

--- function love.keypressed(key)

    ---love.keyboard.keysPressed[key] = true

    --- if key == 'escape' then
    ---    love.event.quit()
    ---end
---end

function love.mousepressed(x ,y, button, istouch)
    love.mouse.mousePressed[button] = true

    if button == 3 then
        love.event.quit()
    end
end

--- function love.keyboard.wasPressed(key)
    ---return love.keyboard.keysPressed[key]
---end
 function love.mouse.wasPressed(button)
    return love.mouse.mousePressed[button]
end


function love.update(dt)
    if scrolling then

        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
                % BACKGROUND_LOOPING_POINT

        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
                % GROUND_LOOPING_POINT

        gStateMachine:update(dt)

        ---love.keyboard.keysPressed = {}
        love.mouse.mousePressed = {}
    end

end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end