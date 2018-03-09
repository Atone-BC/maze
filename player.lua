local Player = {}
local list = require("list")
local maze = require("maze")

local function lerp(a, b, t) --Linear interpolation
  return a * (1-t) + (b*t)
end

local function draw(self)
  love.graphics.setColor(255,0,0)
  love.graphics.rectangle("fill", ((self.drawx * w) + 5), ((self.drawy * w)+ 5), w-10, w-10)
  love.graphics.setColor(255,255,255)
end

local function update(self, dt) --Updates player's movement timer, draw position, and checks for collisions with the minotaur
  if self.game.mino.maze == self.game.map[0][0] and self.game.mino.trapped <= 0 and self.x == self.game.mino.x and self.y == self.game.mino.y then
    if self.items.sword and (self.game.mino.trapped > 0 or self.items.shield or self.items.helm) then
      print("Victory!")
      love.event.quit("restart")
    elseif self.items.shield then
      self.game.mino.trapped = 3
      self.items.shield = false
    else
      print("Game over!")
      love.event.quit("restart")
    end
  end
  self.timer = self.timer + dt
  if self.trapped then
    if self.timer  > 1.5 then
      self.trapped = false
    end
  elseif not self.move then
    self.timer = self.timer + dt
    if self.timer > 0.05 then
      self.move = true
      self.timer = 0
    end
  end
  self.drawx = lerp( self.drawx, self.x, 0.2)
  self.drawy = lerp( self.drawy, self.y, 0.2)
end

local function keypressed(self, key) --Player movement
  if self.move and not self.trapped then
    if key == "up" then
      if self.y > 0 then
        if not self.game.map[0][0].grid[self.y - 1][self.x].walls[2] then
        self.y = self.y  - 1
        self.move = false
        end
      elseif not self.game.map[-1][0].grid[rows - 1][self.x].walls[2] then
        self.game.map[0][0].exit = self.game.map[0][0].grid[self.y][self.x]
        self.game.map:update("up")
        self.y = rows - 1
        self.move = false
        self.drawy = self.drawy + rows
      end
    end
    
    if key == "down" then
      if not self.game.map[0][0].grid[self.y][self.x].walls[2] then
        if self.y < rows - 1 then
          self.y = self.y  + 1
          self.move = false
        else
          self.game.map[0][0].exit = self.game.map[0][0].grid[self.y][self.x]
          self.game.map:update("down")
          self.y = 0
          self.move = false
          self.drawy = self.drawy - rows
        end
      end
    end
    if key == "left" then
      if self.x > 0 then
        if not self.game.map[0][0].grid[self.y][self.x - 1].walls[1] then
          self.x = self.x - 1
          self.move = false
        end
      elseif not self.game.map[0][-1].grid[self.y][cols - 1].walls[1] then
        self.game.map[0][0].exit = self.game.map[0][0].grid[self.y][self.x]
        self.game.map:update("left")
        self.x = cols - 1
        self.move = false
        self.drawx = self.drawx + cols
      end
    end
    if key == "right" then
      if not self.game.map[0][0].grid[self.y][self.x].walls[1] then
        if self.x < cols - 1 then
          self.x = self.x + 1
          self.move = false
        else
          self.game.map[0][0].exit = self.game.map[0][0].grid[self.y][self.x]
          self.game.map:update("right")
          self.x = 0
          self.move = false
          self.drawx = self.drawx - cols
        end
      end
    end
  end
  --Check if we moved onto an entity.
  local ent = self.game.map[0][0].entities[self.y][self.x]
  if ent then
    if ent.id == "trap" then
      self.trapped = true
    else
      self.items[ent.id] = true
      print(ent.id)
    end
    self.game.map[0][0].entities[self.y][self.x] = nil
  end
end


function Player.create(x, y)
  local inst = {}
  inst.x = x
  inst.y = y
  inst.drawx = x
  inst.drawy = y
  inst.move = true
  inst.roomTrail = list.create()
  inst.draw = draw
  inst.keypressed = keypressed
  inst.update = update
  inst.timer = 0
  inst.trapped = false
  inst.items = {}
  inst.game = nil
  return inst
end

return Player