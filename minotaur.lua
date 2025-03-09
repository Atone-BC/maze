local List = require("list")

local Minotaur = {} -- The minotaur is a hostile NPC that chases the player through the labyrinth.

local function draw(self)
  for y = -1, 1 do
    for x = -1, 1 do
      if self.game.map[y][x] == self.maze then
        love.graphics.setColor(1,0,0)
      --  love.graphics.rectangle("fill", ((self.x * W) + 5) +  (love.graphics.getWidth() * x), ((self.y * W)+ 5) +  (love.graphics.getHeight()) * y, W-10, W-10)
        love.graphics.draw (self.sprite, (self.x * W) + (love.graphics.getWidth() * x), (self.y * W) + (love.graphics.getHeight() * y) )
        love.graphics.setColor(1,1,1)
      end
    end
  end
end

local function findPath(self)
  --Pathfinding with depth first search. Because mazes are considered "perfect", this gets an optimal solution within a maze.
  --May update with A* or Dijkstra or something to be smarter about chasing across multiple mazes.
  self.path = List.create()
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

local timer = 0
local function update(self, dt) -- Should we update the minotaur?
  timer = timer + dt
  if timer > self.speed then
    timer = 0
    if self.trapped <= 0 then
      self:update2()
    else
      self.trapped = self.trapped - 1
    end
  end
end

local function update2(self) -- Actually update the minotaur.
  local player = self.game.player
  local map = self.game.map
  if self.maze == map[0][0] then
    self.goal = map[0][0].grid[player.y][player.x]
  else
    self.goal = self.maze.exit
  end
  --Moving the minotaur from one maze to another.
  if self.x == self.goal.x and self.y == self.goal.y and self.maze ~= map[0][0] then
    local exitDirection = self.game.player.roomTrail:popleft()
    if exitDirection == "up" then
      self.maze = self.game.player.roomTrail:popleft()
      self.y = ROWS - 1
    elseif exitDirection == "down" then
      self.maze = self.game.player.roomTrail:popleft()
      self.y = 0
    elseif exitDirection == "left" then
      self.maze = self.game.player.roomTrail:popleft()
      self.x = COLS - 1
    elseif exitDirection == "right" then
      self.maze = self.game.player.roomTrail:popleft()
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
  for y = 0, ROWS - 1 do
    for x = 0, COLS - 1 do
      self.maze.grid[y][x].mvisited = false
    end
  end

  if self.maze.entities[self.y][self.x] then
    if self.maze.entities[self.y][self.x] and self.maze.entities[self.y][self.x].id == "trap" then
      self.trapped = 3
    end
    self.maze.entities[self.y][self.x] = nil
  end

  if self.maze == self.game.map[0][0] then self.game.player.roomTrail = List.create() end

end

function Minotaur.create(x, y, maze, game)
  local inst = {}
  inst.x = x
  inst.y = y
  inst.maze = maze
  inst.goal = inst.maze.grid[0][0]
  inst.path = nil
  inst.findPath = findPath
  inst.update = update -- Should we step?
  inst.update2 = update2 -- Step
  inst.draw = draw
  inst.trapped = 0 -- How many steps the minotaur is trapped for
  inst.speed = 0.3 -- Minotaur steps every this many seconds
  inst.game = game
  inst.sprite = game.sprites.mino
  return inst
end


return Minotaur
