local List = require("list")
local Map = require("map")
local Camera = require("camera")
local Minotaur = require("minotaur")
local Player = require("player")

local Game = {} --Gamestate object containing all objects in the game world.
local timer = 0

local function update(self, dt)
  self.player:update(dt)
  self.camera:update()

  timer = timer + dt
  if timer > 0.3 then
    timer = 0
    if self.mino.trapped <= 0 then
      self.mino:update()
    else
      self.mino.trapped = self.mino.trapped - 1
    end
  end
end

local function draw(self)
  self.camera:draw()
  self.map:draw()
  self.mino:draw()
  self.player:draw()
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
  inst.update = update
  inst.draw = draw


  return inst


end

return Game
