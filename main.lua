local Minotaur = require("minotaur")
local Player = require("player")
local Game = require("game")
local Map = require("map")
local Camera = require("camera")

cols, rows = 0, 0 --Column and row count for all mazes. Global. Probably doesn't need to be.
w = 25 --Tile size. Side of a square. Global. '' '' '' 
local middle = {} --Holds the coordinates for the middle of the maze. Used for player starting location and calculating offsets.
local mino --The Minotaur
local camera --Smooth camera effect keeping view centered on player

function love.load()
  cols, rows = math.floor(love.graphics.getWidth() / w), math.floor(love.graphics.getHeight() / w)
  map = Map.create()
  camera = Camera.create()
  middle.x, middle.y = math.floor((cols-1)/2), math.floor((rows-1)/2)
  player = Player.create(middle.x, middle.y)
  mino = Minotaur.create(love.math.random(cols-1), love.math.random(rows-1), map[0][0])
  game = Game.create(map, player, mino, camera, middle)
  player.game, mino.game, map.game, camera.game = game, game, game, game
end

function love.update(dt)
  game:update(dt)
end

function love.draw()
  camera:draw()
  map:draw()
  mino:draw()
  player:draw()
end

function love.keypressed(key)
  player:keypressed(key)
  
  if key == 'space' then
    print(camera.x, camera.y)
  end
end