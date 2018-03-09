local Minotaur = require("minotaur")
local Player = require("player")
local Game = require("game")
local Map = require("map")
local Camera = require("camera")

cols, rows = 0, 0 --Column and row count for all mazes. Global. Probably doesn't need to be.
w = 25 --Tile size. Side of a square. Global. '' '' '' 
local middle = {} --Holds the coordinates for the middle of the maze. Used for player starting location and calculating offsets.
local mino --The Minotaur
local camera

function love.load()
  cols, rows = math.floor(love.graphics.getWidth() / w), math.floor(love.graphics.getHeight() / w) --determine row / column count.
  map = Map.create() -- Initialize the map, a 3x3 grid of randomly generated mazes.
  camera = Camera.create()
  middle.x, middle.y = math.floor((cols-1)/2), math.floor((rows-1)/2) --Find middle cell x,y
  player = Player.create(middle.x, middle.y) --Create player in the middle.
  mino = Minotaur.create(love.math.random(cols-1), love.math.random(rows-1), map[0][0]) --create the Minotaur at a random location in the map.
  game = Game.create(map, player, mino, camera, middle) --Lump everything into a game object for easy reference.
  player.game, mino.game, map.game, camera.game = game, game, game, game --Give everything access to the game object.
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