local maze = require("maze")

local Map = {} --The map is a 3x3 grid of mazes which comprise the game world.


local function draw(self) --For each maze in the grid, checks if it is onscreen then draws it at the appropriate offset.
  for y = -1, 1 do
    for x = -1, 1 do
      if  ( self.game.camera.x / math.abs(self.game.camera.x) ~= x) and (self.game.camera.y / math.abs(self.game.camera.y) ~= y) then
        love.graphics.push()
        love.graphics.translate(love.graphics.getWidth() * x, love.graphics.getHeight() * y)
        self[y][x]:draw()
        love.graphics.pop()
      end
    end
  end
end

local function update(self, dir) --called when the player moves from one maze to another. Shifts everything over in the 3x3 grid of mazes, dropping 3 mazes on one end and creating 3 mazes on the other.
  if dir == "up" then
    for y = 1, -1, -1 do
      for x = -1, 1 do
        if self[y-1] then
          self[y][x] = self[y-1][x]
        else
          self[y][x] = maze.create()
        end
      end
    end
    self.game.player.roomTrail:push("up")
    self.game.player.roomTrail:push(self[0][0])
    self.game.camera.y = self.game.camera.y - (ROWS * W)
  elseif dir == "down" then
    for y = -1, 1 do
      for x = -1, 1 do
        if self[y+1] then
          self[y][x] = self[y+1][x]
        else
          self[y][x] = maze.create()
        end
      end
    end
    self.game.player.roomTrail:push("down")
    self.game.player.roomTrail:push(self[0][0])
    self.game.camera.y = self.game.camera.y + (ROWS * W)
  elseif dir == "left" then
    for x = 1, -1, -1 do
      for y = -1, 1 do
        if self[y][x-1] then
          self[y][x] = self[y][x-1]
        else
          self[y][x] = maze.create()
        end
      end
    end
    self.game.player.roomTrail:push("left")
    self.game.player.roomTrail:push(self[0][0])
    self.game.camera.x = self.game.camera.x - (COLS * W)
  elseif dir == "right" then
    for x = -1, 1 do
      for y = -1, 1 do
        if self[y][x+1] then
          self[y][x] = self[y][x+1]
        else
          self[y][x] = maze.create()
        end
      end
    end
    self.game.player.roomTrail:push("right")
    self.game.player.roomTrail:push(self[0][0])
    self.game.camera.x = self.game.camera.x + (COLS * W)
  end
end

function Map.create()
  local inst = {}
    for y = -1, 1 do
    inst[y] = {}
    for x = -1, 1 do
      inst[y][x] = maze.create()
    end
  end
  inst.draw = draw
  inst.update = update
  inst.game = nil
  return inst
end

return Map
