local List = require("list")
local lerp = require("lerp")

local Player = {} --The player object that the user pilots through the maze.

local function draw(self)
  love.graphics.setColor(1,0,0)
--  love.graphics.rectangle("fill", ((self.drawx * W) + 5), ((self.drawy * W)+ 5), W-10, W-10)
  love.graphics.draw(self.sprite, self.drawx * W, self.drawy * W)
  love.graphics.setColor(1,1,1)
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
      elseif not self.game.map[-1][0].grid[ROWS - 1][self.x].walls[2] then
        self.game.map[0][0].exit = self.game.map[0][0].grid[self.y][self.x]
        self.game.map:update("up")
        self.y = ROWS - 1
        self.move = false
        self.drawy = self.drawy + ROWS
      end
    end

    if key == "down" then
      if not self.game.map[0][0].grid[self.y][self.x].walls[2] then
        if self.y < ROWS - 1 then
          self.y = self.y  + 1
          self.move = false
        else
          self.game.map[0][0].exit = self.game.map[0][0].grid[self.y][self.x]
          self.game.map:update("down")
          self.y = 0
          self.move = false
          self.drawy = self.drawy - ROWS
        end
      end
    end
    if key == "left" then
      if self.x > 0 then
        if not self.game.map[0][0].grid[self.y][self.x - 1].walls[1] then
          self.x = self.x - 1
          self.move = false
        end
      elseif not self.game.map[0][-1].grid[self.y][COLS - 1].walls[1] then
        self.game.map[0][0].exit = self.game.map[0][0].grid[self.y][self.x]
        self.game.map:update("left")
        self.x = COLS - 1
        self.move = false
        self.drawx = self.drawx + COLS
      end
    end
    if key == "right" then
      if not self.game.map[0][0].grid[self.y][self.x].walls[1] then
        if self.x < COLS - 1 then
          self.x = self.x + 1
          self.move = false
        else
          self.game.map[0][0].exit = self.game.map[0][0].grid[self.y][self.x]
          self.game.map:update("right")
          self.x = 0
          self.move = false
          self.drawx = self.drawx - COLS
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


function Player.create(x, y, game)
  local inst = {}
  inst.x = x
  inst.y = y
  inst.drawx = x
  inst.drawy = y
  inst.move = true
  inst.roomTrail = List.create()
  inst.draw = draw
  inst.keypressed = keypressed
  inst.update = update
  inst.timer = 0
  inst.trapped = false
  inst.items = {}
  inst.game = game
  inst.sprite = game.sprites.player



  return inst
end

return Player
