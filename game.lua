local List = require("list")
local Map = require("map")
local Camera = require("camera")
local Minotaur = require("minotaur")
local Player = require("player")

local Game = {} --Gamestate object containing all objects in the game world.
local timer = 0

local function update(self, dt)
  self.camera:update()
  if not self.paused then
    self.player:update(dt)
    self.mino:update(dt)
  end
end

local function draw(self)
  self.camera:draw()
  self.map:draw()
  self.mino:draw()
  self.player:draw()

  if self.paused then
    love.graphics.origin()
    love.graphics.setColor(1,1,1)
    love.graphics.print("PAUSED", W * (COLS/2), W * (ROWS/2), 0)
  end
end

local function keypressed(self, key)
  if key == "escape" then
    self.paused = not self.paused
  elseif not self.paused then
    self.player:keypressed(key)
  end
end

function Game.create()
  local inst = {}

  inst.sprites = {
    sword = love.graphics.newImage('assets/gladius.png'),
    shield = love.graphics.newImage('assets/shield.png'),
    helm = love.graphics.newImage('assets/helm.png'),
    sandals = love.graphics.newImage('assets/wingfoot.png'),
    wings = love.graphics.newImage('assets/wing.png'),
    trap = love.graphics.newImage('assets/trap.png'),
    player = love.graphics.newImage('assets/person.png'),
    mino = love.graphics.newImage('assets/brute.png')
  }

  inst.middle = {x = math.floor((COLS-1)/2), y = math.floor((ROWS-1)/2) }
  inst.map = Map.create(inst)
  inst.player = Player.create(inst.middle.x, inst.middle.y, inst)
  inst.mino = Minotaur.create(0, 0, inst.map[0][0], inst) --(love.math.random(cols-1), love.math.random(rows-1), map[0][0])
  inst.camera = Camera.create(inst)
  inst.paused = false
  inst.keypressed = keypressed
  inst.update = update
  inst.draw = draw
  return inst

end

return Game
