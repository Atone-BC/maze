local Minotaur = {} -- The minotaur is a hostile NPC that chases the player through the labyrinth.

local list = require("list")

local function draw(self)
  for y = -1, 1 do
    for x = -1, 1 do
      if self.game.map[y][x] == self.maze then
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", ((self.x * w) + 5) +  (love.graphics.getWidth() * x), ((self.y * w)+ 5) +  (love.graphics.getHeight()) * y, w-10, w-10)
        love.graphics.setColor(1,1,1)
      end
    end
  end
end

local function findPath(self)
  --Adapted version of the maze generation algorithm to find a path to the player or the maze exit. We'd like to rework this to be able to path across mazes or at least be wiser about what direction the player is in.
  local current = self.maze.grid[self.y][self.x]
  while current do
    current.mvisited = true
    if current == self.goal then self.path:push(current) break end
    local new = current:checkPath()
    if new then
      self.path:push(current)
      current = new
    else
      current = self.path:pop()
    end
  end
  self.path:popleft()
end

local function update(self)
  local player = self.game.player
  local map = self.game.map
  if self.maze == map[0][0] then
    self.goal = map[0][0].grid[player.y][player.x]
  else
    self.goal = self.maze.exit
  end
  --Moving the minotaur from one maze to another.
  if self.x == self.goal.x and self.y == self.goal.y and self.maze ~= map[0][0] then
    local exitDirection = game.player.roomTrail:popleft()
    if exitDirection == "up" then
      self.maze = game.player.roomTrail:popleft()
      self.y = rows - 1
    elseif exitDirection == "down" then
      self.maze = game.player.roomTrail:popleft()
      self.y = 0
    elseif exitDirection == "left" then
      self.maze = game.player.roomTrail:popleft()
      self.x = cols - 1
    elseif exitDirection == "right" then
      self.maze = game.player.roomTrail:popleft()
      self.x = 0
    end
  else --get path and take a step along it.
    self:findPath()
    local step = self.path:popleft()
    if step then
      self.x = step.x
      self.y = step.y
    end
  end
  self.path = list.create()
  for y = 0, rows - 1 do
    for x = 0, cols - 1 do
      self.maze.grid[y][x].mvisited = false
    end
  end

  if self.maze.entities[self.y][self.x] then
    if self.maze.entities[self.y][self.x] and self.maze.entities[self.y][self.x].id == "trap" then
      self.trapped = 3
    end
    self.maze.entities[self.y][self.x] = nil
  end

end

function Minotaur.create(x, y, maze)
  local inst = {}
  inst.x = x
  inst.y = y
  inst.maze = maze
  inst.goal = inst.maze.grid[0][0]
  inst.path = list.create()
  inst.findPath = findPath
  inst.update = update
  inst.draw = draw
  inst.trapped = 0
  inst.game = nil
  return inst
end


return Minotaur
