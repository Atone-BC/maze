local Game = require("game")
local game

function love.load()
  W = 25 --The side length of the squares in the maze
  COLS, ROWS = math.floor(love.graphics.getWidth() / W), math.floor(love.graphics.getHeight() / W)
  game = Game.create()
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  game:draw()
end

function love.keypressed(key)
  game.player:keypressed(key)
end
