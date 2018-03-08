local Map = {} --The map is a grid of mazes which comprise the game world.
local maze = require("maze")

local function draw(self)
  for y = -1, 1 do --for each maze in the map
    for x = -1, 1 do
      if  ( self.game.camera.x / math.abs(self.game.camera.x) ~= x) and (self.game.camera.y / math.abs(self.game.camera.y) ~= y) then -- If maze isn't offscreen
        love.graphics.push()
        love.graphics.translate(love.graphics.getWidth() * x, love.graphics.getHeight() * y) --translate a maze length in the appropriate direction
        self[y][x]:draw() --draw the maze
        love.graphics.pop()
      end
    end
  end
end

local function update(self, dir) --called when the player moves from one maze to another. Shifts everything over in the 3x3 grid of mazes, generating new mazes in the direction the player moved
  if dir == "up" then --player moved up into a new maze
    for y = 1, -1, -1 do --for each row, starting from the bottom
      for x = -1, 1 do --for each maze in the row, starting from left
        if self[y-1] then --if there's a maze above it
          self[y][x] = self[y-1][x] --Move the above maze down into the current positon
        else
          self[y][x] = maze.create() --else create new maze
        end
      end
    end
    self.game.player.roomTrail:push("up")
    self.game.player.roomTrail:push(self[0][0])
    self.game.camera.y = self.game.camera.y - (rows * w) --fix offset to match the new map.
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
    self.game.camera.y = self.game.camera.y + (rows * w)
  elseif dir == "left" then --player moved left
    for x = 1, -1, -1 do --for each column
      for y = -1, 1 do --for each maze in column
        if self[y][x-1] then --if maze exists to left
          self[y][x] = self[y][x-1] --move that maze over
        else
          self[y][x] = maze.create()--else create a new maze
        end
      end
    end
    self.game.player.roomTrail:push("left")
    self.game.player.roomTrail:push(self[0][0])
    self.game.camera.x = self.game.camera.x - (cols * w) --fix offset
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
    self.game.camera.x = self.game.camera.x + (cols * w)
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