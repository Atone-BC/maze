local Game = {} --Gamestate object giving everything easy reference to everything else in the game world. Also hiding away some update code from cluttering main.lua
local List = require("list")
local Map = require("map")
local Camera = require("camera")
local Minotaur = require("minotaur")
local Player = require("player")

local timer = 0

local function lerp(a, b, t)
  return a * (1-t) + (b*t)
end

local function update(self, dt)
  timer = timer + dt
  if timer > 0.5 then
    timer = 0
    if self.mino.trapped <= 0 then
      self.mino:update()
    else
      self.mino.trapped = self.mino.trapped - 1
    end
  end

  self.player:update(dt)
  self.camera:update()

  if self.mino.maze == self.map[0][0] then self.player.roomTrail = List.create() end
end

local function draw(self)
  self.camera:draw()
  self.map:draw()
  self.mino:draw()
  self.player:draw()
end

function Game.create()
  local inst = {}
  inst.middle = {x = math.floor((COLS-1)/2), y = math.floor((ROWS-1)/2) }
  inst.map = Map.create()
  inst.player = Player.create(inst.middle.x, inst.middle.y)
  inst.mino = Minotaur.create(0, 0, inst.map[0][0]) --(love.math.random(cols-1), love.math.random(rows-1), map[0][0])
  inst.camera = Camera.create()
  inst.update = update
  inst.draw = draw

  for k, v in pairs(inst) do
    if type(v) == "table" then
      v.game = inst
    end
  end
  return inst

end

return Game
