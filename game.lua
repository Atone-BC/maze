local Game = {} --Gamestate object giving everything easy reference to everything else in the game world. Also hiding away some update code from cluttering main.lua
local maze = require("maze")
local list = require("list")
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
  
  if self.mino.maze == self.map[0][0] then self.player.roomTrail = list.create() end
end

function Game.create(map, player, mino, camera, middle)
  local inst = {}
  inst.map = map
  inst.player = player
  inst.mino = mino
  inst.camera = camera
  inst.middle = middle
  inst.update = update
  return inst

end

return Game